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

function util.run(cmd, t)
  if not t or vim.tbl_isempty(t) then return end

  cmd = cmd:format(util.flatten(t))

  vim.cmd("echom 'LspUpdate: " .. cmd .. "... ⏳ '")
  vim.cmd("echom '" .. util.osCapture(cmd) .. "'")
end

-- adhoc, micro testing framework:
--
-- it takes two parameters: a module (to be tested),
-- and a table with testCases definitions, as follows:
-- keys represent functions to run in the target module (being tested)
-- values are lists of a "testCase", where each testCase is a
-- map with `args` (table, will be unpacked into actual arguments)
-- and `exp` - the expectation, will be used as is and compared
-- against the actual output from the function being tested.
--
-- Run it with: `neovim --headless +'luafile x/y.lua' +q`
-- no error/output == success!
function util.test(package, testCases)
  local I = vim.inspect
  for k, v in pairs(testCases) do
    for _, tc in pairs(v) do
      local act = package[k](unpack(tc.args))
      assert(vim.deep_equal(tc.exp, act),
             "testing " .. k .. "(), expected " .. I(tc.exp) .. " got " .. I(act)
                 .. " for args " .. I(tc.args))
    end
  end
end

return util
