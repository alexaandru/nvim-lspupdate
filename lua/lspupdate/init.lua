local lspupdate = {}

local config = require"lspupdate/config".config
local commands = require"lspupdate/config".commands
local util = require "lspupdate/util"

function lspupdate.LspUpdate()
  local packages = {}
  local unknown = {}
  local user_commands = vim.g.lspupdate_commands or {}

  for k, _ in pairs(require "lspconfig/configs") do
    local c = config[k]

    if not c or c == "" then
      table.insert(unknown,
                   "WARN: don't know how to handle " .. k .. " LSP server")
      goto continue
    end

    local kind = vim.split(c, "|")[1]

    if not commands[kind] then
      table.insert(unknown, "WARN: don't know how to install command " .. kind
                       .. " for LSP server " .. k)
      goto continue
    end

    if not packages[kind] then packages[kind] = {} end

    table.insert(packages[kind], util.lspVal(c))

    ::continue::
  end

  local cmds = vim.tbl_extend("force", commands, user_commands)

  for k, v in pairs(packages) do util.run(cmds[k], v) end
  for _, v in pairs(unknown) do print("LspUpdate: " .. v) end
end

return lspupdate
