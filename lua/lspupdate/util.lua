local function strSplit(s, sep)
  local out = {}

  if s == nil or s == "" then return out end

  for i in string.gmatch(s, "[^"..sep.."]+") do
    out[#out+1] = i
  end

  return out
end

local function lspVal(s)
  if s == nil or s == "" or not string.find(s, "|") then
    return { s }
  end

  v = strSplit(s, "|")

  return strSplit(v[2], ",")
end

local function flatten(t, sep)
  sep = sep or " "
  local out = {}

  for k,v in pairs(t) do
    out[k] = table.concat(v, sep)
  end

  return table.concat(out, sep)
end

local function merge(a, b)
  if a == nil then return b end
  if b == nil then return a end

  for k,v in pairs(b) do
    a[k] = v
  end
end

local function osCapture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))

  f:close()

  if raw then return s end

  return s:gsub('^%s+', ''):gsub('%s+$', ''):gsub('[\n\r]+', ' ')
end

local function run(cmd, t)
  if t == nil then return end

  local n = 0

  for k, v in pairs(t) do
    n = n + 1

    if n > 0 then break end
  end

  if n == 0 then return end

  cmd = cmd:format(flatten(t))

  vim.cmd("echom 'LspUpdate: " .. cmd .. "... ⏳ '")
  vim.cmd("echom '" .. osCapture(cmd) .. "'")
end

return {
  strSplit  = strSplit,
  lspVal    = lspVal,
  flatten   = flatten,
  merge     = merge,
  osCapture = osCapture,
  run       = run,
}
