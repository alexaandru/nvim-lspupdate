local _local_1_ = require("lspupdate.util")
local err = _local_1_["err"]
local run = _local_1_["run"]
local warn = _local_1_["warn"]
local function LspUpdate(opt)
  local dry = (opt == "dry")
  if ((opt ~= "dry") and (opt ~= nil)) then
    return err("only parameter 'dry' is supported")
  else
    local _let_2_ = require("lspupdate.config")
    local commands = _let_2_["commands"]
    local nosquash = _let_2_["nosquash"]
    local function dispatch(kind, args, output, unknown)
      local function ins_unknown(kind0, typ)
        local ins = table.insert
        local fmt = string.format
        return ins(unknown, fmt("don't know how to handle command %s of type %s", kind0, typ))
      end
      local go = vim.schedule
      local cmd = commands[kind]
      local typ = type(cmd)
      if (nosquash[kind] and (#args > 1)) then
        for _, v in ipairs(args) do
          dispatch(kind, {v}, output, unknown)
        end
        return nil
      else
        local _3_ = typ
        if (_3_ == "string") then
          return run(output, cmd, args, dry)
        elseif (_3_ == "function") then
          local function _4_()
            return cmd(output, vim.tbl_flatten(args), dry)
          end
          return go(_4_)
        else
          local _ = _3_
          return ins_unknown(kind, typ)
        end
      end
    end
    local output = {}
    local packages_list = require("lspupdate.packages")
    local packages, unknown = packages_list()
    for kind, args in pairs(packages) do
      dispatch(kind, vim.tbl_flatten(args), output, unknown)
    end
    for _, v in pairs(unknown) do
      warn(v)
    end
    return nil
  end
end
return LspUpdate
