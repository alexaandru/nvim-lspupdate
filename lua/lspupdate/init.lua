local _local_1_ = require("lspupdate.util")
local err = _local_1_["err"]
local lspVal = _local_1_["lspVal"]
local run = _local_1_["run"]
local warn = _local_1_["warn"]
local cfg = require("lspupdate.config")
local ins = table.insert
local function _2_(opt)
  local function with_user_override(tbl)
    local default_tbl = cfg[tbl]
    local user_tbl = ({} or vim.g[("lspupdate_" .. tbl)])
    return vim.tbl_extend("force", default_tbl, user_tbl)
  end
  local dry = (opt == "dry")
  if ((opt ~= "dry") and (opt ~= nil)) then
    return err("only parameter 'dry' is supported")
  else
    local packages = {}
    local unknown = {}
    local output = {}
    local config = with_user_override("config")
    local commands = with_user_override("commands")
    local nosquash = with_user_override("nosquash")
    local function dispatch(kind, args)
      local cmd = commands[kind]
      if (vim.tbl_contains(nosquash, kind) and (#args > 1)) then
        for _, v in ipairs(args) do
          dispatch(kind, {v})
        end
        return nil
      else
        if (type(cmd) == "string") then
          return run(output, cmd, args, dry)
        elseif (type(cmd) == "function") then
          local function _3_()
            return cmd(output, vim.tbl_flatten(args), dry)
          end
          return vim.schedule(_3_)
        else
          return ins(unknown, ("don't know how to handle command " .. kind .. " of type " .. type(cmd)))
        end
      end
    end
    for lsp, _ in pairs(require("lspconfig/configs")) do
      local cfg0 = config[lsp]
      if (not cfg0 or (cfg0 == "")) then
        ins(unknown, ("don't know how to handle " .. lsp .. " LSP server"))
      else
        local kind = (vim.split(cfg0, "|"))[1]
        if not commands[kind] then
          ins(unknown, ("don't know how to install command " .. kind .. " for LSP server " .. lsp))
        else
          if not packages[kind] then
            packages[kind] = {}
          end
          ins(packages[kind], lspVal(cfg0))
        end
      end
    end
    for kind, args in pairs(packages) do
      dispatch(kind, vim.tbl_flatten(args))
    end
    for _, v in pairs(unknown) do
      warn(v)
    end
    return nil
  end
end
return _2_
