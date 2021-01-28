local util = {}

function util.lspVal(s)
  if not s or s == "" or not string.find(s, "|") then return {s} end
  return vim.split(vim.split(s, "|")[2], ",")
end

function util.flatten(t, sep)
  return table.concat(vim.tbl_flatten(t), sep or " ")
end

function util.osCapture(cmd)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))

  f:close()

  return vim.trim(s):gsub('[\n\r]+', ' ')
end

function util.run(cmd, t)
  if not t or vim.tbl_isempty(t) then return end

  cmd = cmd:format(util.flatten(t))

  vim.cmd("echom 'LspUpdate: " .. cmd .. "... ⏳ '")
  vim.cmd("echom '" .. util.osCapture(cmd) .. "'")
end

return util
