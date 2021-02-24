local util = require "lspupdate.util"

return function(config)
  local health_start = vim.fn["health#report_start"]
  local health_ok = vim.fn["health#report_ok"]
  local health_error = vim.fn["health#report_error"]
  local warn = function(s)
    print("  - WARN: " .. s)
  end

  health_start("Checking for executables needed for install/update...")

  local kinds = {}
  for lsp, _ in pairs(require "lspconfig/configs") do
    local cfg = config.config[lsp]
    if not cfg or cfg == "" then
      warn("don't know how to handle " .. lsp .. " LSP server")
      goto continue
    end

    local kind = vim.split(cfg, "|")[1]
    if not config.commands[kind] then
      warn("don't know how to install command " .. kind .. " for LSP server "
               .. lsp)
      goto continue
    end

    kinds[kind] = true

    ::continue::
  end

  for k in pairs(kinds) do
    local check = config.checks[k]

    if not check then
      warn("check is not configured for " .. k)
      goto continue
    end

    local out = util.osCapture(check[1])
    out = out or ""

    local match = out:match(check[2])

    if not match or match == "" then
      health_error(("command %s not found"):format(k))
    else
      health_ok(("command %s found: v%s"):format(k, match))
    end

    ::continue::
  end
end
