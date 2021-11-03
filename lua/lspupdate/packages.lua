local function tool_extract_bash(tool)
  return tool:match("bash%s+-c%s+%W(%S+)%s+")
end
local function tool_extract(tool)
  if tool then
    if vim.startswith(tool, "bash -c") then
      return tool_extract_bash(tool)
    else
      return (vim.split(tool, " "))[1]
    end
  end
end
local function tools_list_efm()
  local tools = {}
  local _let_3_ = require("lspconfig/configs")
  local efm = _let_3_["efm"]
  local _let_4_ = efm
  local make_config = _let_4_["make_config"]
  local out = make_config()
  local languages = out.settings.languages
  for _, v1 in pairs(languages) do
    for _0, v2 in ipairs(v1) do
      do
        local tool = tool_extract(v2.lintCommand)
        if tool then
          tools[tool] = true
        end
      end
      local tool = tool_extract(v2.formatCommand)
      if tool then
        tools[tool] = true
      end
    end
  end
  return vim.tbl_keys(tools)
end
local function tools_list(lsp)
  local _7_ = lsp
  if (_7_ == "efm") then
    return tools_list_efm()
  else
    local _ = _7_
    return {}
  end
end
local function list_all()
  local _let_9_ = require("lspupdate.util")
  local lspVal = _let_9_["lspVal"]
  local _let_10_ = require("lspupdate.config")
  local commands = _let_10_["commands"]
  local config = _let_10_["config"]
  local tools = _let_10_["tools"]
  local ins = table.insert
  local packages = {}
  local unknown = {}
  local function ins_packages(cfg, lsp, label)
    if (not cfg or (cfg == "")) then
      return ins(unknown, ("don't know how to handle " .. lsp .. " " .. label))
    else
      local kind = (vim.split(cfg, "|"))[1]
      if (kind ~= "nop") then
        if not commands[kind] then
          return ins(unknown, ("don't know how to resolve command " .. kind .. " for " .. label .. " " .. lsp))
        else
          if not packages[kind] then
            packages[kind] = {}
          end
          return ins(packages[kind], lspVal(cfg))
        end
      end
    end
  end
  for lsp in pairs(require("lspconfig/configs")) do
    do
      local cfg = config[lsp]
      ins_packages(cfg, lsp, "LSP server")
    end
    if ("efm" == lsp) then
      local extracted_tools = tools_list(lsp)
      for _, tool in ipairs(extracted_tools) do
        local cfg = tools[tool]
        ins_packages(cfg, tool, "tool")
      end
    end
  end
  return packages, unknown
end
return list_all
