-- luacheck: globals vim
local util = {}

function util.lspVal(s)
  if not s or s == "" or not string.find(s, "|") then return {s} end
  return vim.split(vim.split(s, "|")[2], ",")
end

function util.flatten(t, sep)
  return table.concat(vim.tbl_flatten(t), sep or " ")
end

function util.osCapture(cmd, trim)
  trim = (trim ~= false)
  local f = assert(io.popen(cmd .. " 2>&1", "r"))
  local s = assert(f:read("*a"))

  f:close()

  if trim then s = vim.trim(s):gsub("[\n\r]+", " ") end

  return s
end

function util.esc(s)
  return s:gsub("'", "''")
end

function util.run(output, cmd, t, dry)
  if not t or vim.tbl_isempty(t) then return end

  cmd = cmd:format(util.flatten(t))

  if dry then
    util.info(cmd .. " OK (dry)")
    return
  end

  local update = function(job, data)
    data = data or {}
    output[job] = output[job] or ""
    output[job] = output[job] .. vim.fn.join(data)
  end

  local wrapit = function(job, code)
    local out = output[job]
    output[job] = nil

    if code > 0 or out:find("ERROR") then
      util.error(cmd .. ": " .. out)
    elseif out ~= "" then
      util.warn(cmd .. ": " .. out)
    else
      util.info(cmd .. " OK")
    end

    if vim.tbl_isempty(output) then util.info("All done!") end
  end

  local job = vim.fn.jobstart(cmd, {
    on_stdout = update,
    on_stderr = update,
    on_exit = wrapit,
  })

  -- Need to ensure all jobs have an entry there ASAP or we'll get the "All done" message too soon :-)
  -- I know, a mutex would be much better...
  output[job] = ""
end

function util.basename(path)
  return path:sub(path:find("/[^/]*$") + 1)
end

function util.dirname(path)
  return path:sub(1, path:find("/[^/]*$") - 1)
end

-- TODO: allow endusers to override the location of TMP folder
function util.tmpdir()
  if jit.os == "Windows" then
    return os.getenv("Temp")
  else
    return "/tmp"
  end
end

function util.first_path()
  local path = os.getenv("PATH")
  local sep = ":"
  if jit.os == "Windows" then sep = ";" end

  return vim.split(path, sep, true)[1]
end

function util.info(msg)
  vim.notify("LspUpdate: " .. msg, vim.log.levels.INFO)
end

function util.warn(msg)
  vim.notify("LspUpdate: " .. msg, vim.log.levels.WARN)
end

function util.error(msg)
  vim.notify("LspUpdate: " .. msg, vim.log.levels.ERROR)
end

return util
