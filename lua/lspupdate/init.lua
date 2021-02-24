local config = require"lspupdate.config".config
local commands = require"lspupdate.config".commands
local util = require "lspupdate.util"

return function(opt)
  local dry = false

  if opt then
    if opt ~= "dry" then
      print("LspUpdate: ERROR: only parameter 'dry' is supported")
      return
    end
    dry = true
  end

  local packages = {}
  local unknown = {}
  local user_commands = vim.g.lspupdate_commands or {}

  for lsp, _ in pairs(require "lspconfig/configs") do
    local cfg = config[lsp]

    if not cfg or cfg == "" then
      table.insert(unknown,
                   "WARN: don't know how to handle " .. lsp .. " LSP server")
      goto continue
    end

    local kind = vim.split(cfg, "|")[1]

    if not commands[kind] then
      table.insert(unknown, "WARN: don't know how to install command " .. kind
                       .. " for LSP server " .. lsp)
      goto continue
    end

    if not packages[kind] then packages[kind] = {} end

    table.insert(packages[kind], util.lspVal(cfg))

    ::continue::
  end

  local cmds = vim.tbl_extend("force", commands, user_commands)

  for k, v in pairs(packages) do util.run(cmds[k], v, dry) end
  for _, v in pairs(unknown) do print("LspUpdate: " .. v) end
end
