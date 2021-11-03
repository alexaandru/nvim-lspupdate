local no_output_trim = false
local fmt = string.format
local _local_1_ = require("lspupdate.util")
local basename = _local_1_["basename"]
local dirname = _local_1_["dirname"]
local err = _local_1_["err"]
local first_path = _local_1_["first_path"]
local info = _local_1_["info"]
local osCapture = _local_1_["osCapture"]
local tmpdir = _local_1_["tmpdir"]
local function release_os()
  local os = (jit.os):lower()
  if ("osx" == os) then
    return "darwin"
  else
    return os
  end
end
local function release(proj)
  local proj_re = proj:gsub("-", "%%-")
  local pname_re = string.gsub(basename(proj), "-", "%%-")
  local os = release_os()
  local pat = fmt("/%s/releases/download[/.v0-9]+/%s[_.0-9]+%s_amd64.zip", proj_re, pname_re, os)
  local curl = fmt("curl -sL https://github.com/%s/releases/latest", proj)
  local out = osCapture(curl, no_output_trim)
  local m = out:match(pat)
  if (os == "") then
    return ""
  else
    return ("https://github.com" .. m)
  end
end
local function update_release(output, proj, dry)
  output[proj] = 1
  local pname = basename(proj)
  local url = release(proj)
  if ("" == url) then
    return err(("URL error for " .. pname))
  elseif dry then
    return info((url .. " to " .. pname .. " OK (dry)"))
  else
    local location = first_path()
    do
      local existing = vim.fn.exepath(pname)
      if ("" ~= existing) then
        location = dirname(existing)
      end
    end
    local tmp = tmpdir()
    local curl_out = osCapture(fmt("curl -sLo %s/lsp.zip %s", tmp, url))
    if (curl_out ~= "") then
      return err(("failed to download " .. url .. ": " .. curl_out))
    else
      local os = release_os()
      local ext
      if (os == "windows") then
        ext = ".exe"
      else
        ext = ""
      end
      local unzip_out = osCapture(fmt("unzip -qo %s/lsp.zip %s%s -d %s/", tmp, pname, ext, location))
      if (unzip_out ~= "") then
        return err(fmt("failed to unzip %s/lsp.zip to %s/: %s", tmp, location, unzip_out))
      else
        output[proj] = nil
        info(fmt("gh_bin %s to %s", url, location))
        if vim.tbl_isempty(output) then
          return info("All done!")
        end
      end
    end
  end
end
local function update_releases(output, projs, dry)
  for _, p in ipairs(projs) do
    update_release(output, p, dry)
  end
  return nil
end
return update_releases
