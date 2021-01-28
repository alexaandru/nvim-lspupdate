local config = require'lspupdate/config'.config
local commands = require'lspupdate/config'.commands
local util = require 'lspupdate/util'

local function LspUpdate()
  local packages = {}
  local unknown = {}

  for k, _ in pairs(require 'lspconfig/configs') do
    local c = config[k]

    if c == nil or c == "" then
      table.insert(unknown,
                   "WARN: don't know how to handle " .. k .. " LSP server")
      goto continue
    end

    local kind = util.strSplit(c, "|")[1]

    if commands[kind] == nil then
      table.insert(unknown, "WARN: don't know how to install command " .. kind
                       .. " for LSP server " .. k)
      goto continue
    end

    if packages[kind] == nil then packages[kind] = {} end

    table.insert(packages[kind], util.lspVal(c))

    ::continue::
  end

  util.merge(commands, vim.g.lspupdate_commands)

  for k, v in pairs(packages) do util.run(commands[k], v) end
  for _, v in pairs(unknown) do print("LspUpdate: " .. v) end
end

return {LspUpdate = LspUpdate}
