local split = vim.split
local function notif(msg, level)
  return vim.notify(("LspUpdate: " .. msg), vim.log.levels[level])
end
local function info(msg)
  return notif(msg, "INFO")
end
local function warn(msg)
  return notif(msg, "WARN")
end
local function err(msg)
  return notif(msg, "ERROR")
end
local function lspVal(s)
  if (not s or (s == "") or not string.find(s, "|")) then
    return {s}
  else
    return split((split(s, "|"))[2], ",")
  end
end
local function flatten(t, sep)
  return table.concat(vim.tbl_flatten(t), (sep or " "))
end
local function osCapture(cmd, trim)
  local no_trim = (trim == false)
  local f = assert(io.popen((cmd .. " 2>&1"), "r"))
  local s = assert(f:read("*a"))
  f:close()
  if no_trim then
    return s
  else
    return string.gsub(vim.trim(s), "[\n\13]+", " ")
  end
end
local function run(output, cmd, packages, dry)
  if (packages and not vim.tbl_isempty(packages)) then
    cmd = cmd:format(flatten(packages))
    if dry then
      info((cmd .. " OK (dry)"))
    end
    if not dry then
      local function on_stdout(job, data)
        local data0 = vim.fn.join((data or {}))
        local data1 = (("" or output[job]) .. data0)
        do end (output)[job] = data1
        return nil
      end
      local function on_exit(job, code)
        local out = output[job]
        output[job] = nil
        if ((code > 0) or out:find("ERROR")) then
          err((cmd .. ": " .. out))
        elseif (out ~= "") then
          warn((cmd .. ": " .. out))
        else
          info((cmd .. " OK"))
        end
        if vim.tbl_isempty(output) then
          return info("All done!")
        end
      end
      local opts = {on_exit = on_exit, on_stderr = on_stdout, on_stdout = on_stdout}
      local job = vim.fn.jobstart(cmd, opts)
      do end (output)[job] = ""
      return nil
    end
  end
end
local function basename(path)
  return path:sub((path:find("/[^/]*$") + 1))
end
local function dirname(path)
  return path:sub(1, (path:find("/[^/]*$") - 1))
end
local function tmpdir()
  if (jit.os == "Windows") then
    return os.getenv("Temp")
  else
    return "/tmp"
  end
end
local function first_path()
  local path = os.getenv("PATH")
  local sep
  if (jit.os == "Windows") then
    sep = ";"
  else
    sep = ":"
  end
  return split(path, sep, true)[2]
end
return {basename = basename, dirname = dirname, err = err, first_path = first_path, flatten = flatten, info = info, lspVal = lspVal, osCapture = osCapture, run = run, tmpdir = tmpdir, warn = warn}
