local config = require'lspupdate/config'.config
local commands = require'lspupdate/config'.commands
local util = require 'lspupdate/util'

local function LspUpdate()
  local cfg = {unk = {}}

  for k,v in pairs(require'lspconfig/configs') do
    local c = config[k]

    if c == nil or c == "" then
      table.insert(cfg.unk, "WARN: don't know how to handle "..k.." LSP server")
      goto continue
    end

    local cmd = util.strSplit(c, "|")[1]
    local val = ""

    if commands[cmd] == nil then
      val = "WARN: don't know how to install command "..cmd.." for LSP server "..k
      cmd = "unk"
    else
      val = util.lspVal(c)
    end

    if cfg[cmd] == nil then
      cfg[cmd] = {}
    end

    table.insert(cfg[cmd], val)

    ::continue::
  end

  util.merge(commands, vim.g.lspupdate_commands)

  for k, v in pairs(cfg) do
    if k ~= nil and k ~= "unk" then
      util.run(commands[k], v)
    end
  end

  for k,v in pairs(cfg.unk) do print("LspUpdate: " .. v) end
end

return {
  LspUpdate = LspUpdate
}
