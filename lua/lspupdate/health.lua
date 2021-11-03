local _local_1_ = require("lspupdate.util")
local osCapture = _local_1_["osCapture"]
local function _2_(config)
  local start = vim.fn["health#report_start"]
  local ok = vim.fn["health#report_ok"]
  local err = vim.fn["health#report_error"]
  local warn
  local function _3_(_241)
    return print(("  - WARN: " .. _241))
  end
  warn = _3_
  local kinds = {}
  start("Checking for executables needed for install/update...")
  local packages, unknown = require("lspupdate.packages")()
  for _, v in ipairs(unknown) do
    warn(v)
  end
  for k in pairs(packages) do
    local check = config.checks[k]
    if not check then
      warn(("check is not configured for " .. k))
    else
      for cmd, opts in pairs(check) do
        local out = (osCapture((cmd .. " " .. opts[1])) or "")
        local m = out:match(opts[2])
        local fmt = string.format
        if (not m or (m == "")) then
          err(fmt("command %s (needed for %s) not found", cmd, k))
        else
          ok(fmt("%s ready: %s v%s found", k, cmd, m))
        end
      end
    end
  end
  return nil
end
return _2_
