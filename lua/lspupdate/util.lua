local util = {}

function util.lspVal(s)
  if not s or s == "" or not string.find(s, "|") then return {s} end
  return vim.split(vim.split(s, "|")[2], ",")
end

function util.flatten(t, sep)
  return table.concat(vim.tbl_flatten(t), sep or " ")
end

function util.osCapture(cmd)
  local f = assert(io.popen(cmd, "r"))
  local s = assert(f:read("*a"))

  f:close()

  return vim.trim(s):gsub("[\n\r]+", " ")
end

function util.esc(s)
  return s:gsub("'", "''")
end

function util.run(cmd, t, dry)
  if not t or vim.tbl_isempty(t) then return end

  cmd = cmd:format(util.flatten(t))

  local suffix = "... ⏳"
  if dry then suffix = "" end

  vim.cmd("echom 'LspUpdate: " .. util.esc(cmd) .. suffix .. "'")
  if not dry then vim.cmd("echom '" .. util.esc(util.osCapture(cmd)) .. "'") end
end

return util
