-- luacheck: globals vim
local github = {}
local util = require "lspupdate.util"
local no_output_trim = false

-- release will return the latest release .zip file for the given
-- github repo (i.e. hashicorp/terraform-ls)
-- TODO: need fix for OSX
-- jit.os values are "Windows", "Linux", "OSX", "BSD", "POSIX" or "Other", whereas
-- release os values are "linux", "windows", "darwin".
-- See: https://luajit.org/ext_jit.html
-- TODO: need fix for Windows (it includes a .exe suffix which must be accounted for).
function github.release(proj)
  local projRe = proj:gsub("-", "%%-")
  local pnameRe = util.basename(proj):gsub("-", "%%-")
  local pat = ("/%s/releases/download[/.v0-9]+/%s[_.0-9]+%s_amd64.zip"):format(
                  projRe, pnameRe, jit.os:lower())

  return "https://github.com" .. util.osCapture(
             ("curl -sL https://github.com/%s/releases/latest"):format(proj),
             no_output_trim):match(pat)
end

-- TODO: allow end users to override where the release binaries go
-- TODO: support dry mode
function github.update_release(proj, _)
  local pname = util.basename(proj)
  local url = github.release(proj)

  -- 1. determine location of (existing) binary
  local location = util.first_path()
  local existing = util.osCapture("type " .. pname, no_output_trim)
  if vim.startswith(existing, pname .. " is ") then
    location = util.dirname(existing:sub(existing:find(" [^ ]*$") + 1))
  end

  local tmp = util.tmpdir()
  local out = util.osCapture(("curl -sLo %s/lsp.zip %s"):format(tmp, url))
  if out ~= "" then
    util.error("failed to download " .. url .. ": " .. out)
    return
  end

  out = util.osCapture(("unzip -qo %s/lsp.zip %s -d %s/"):format(tmp, pname,
                                                                 location))
  if out ~= "" then
    util.error(("failed to unzip %s/lsp.zip to %s/"):format(tmp, location))
    return
  end

  util.info(("gh_bin %s to %s"):format(url, location))
end

function github.update_releases(projs, dry)
  for _, proj in ipairs(projs) do github.update_release(proj, dry) end
end

return github
