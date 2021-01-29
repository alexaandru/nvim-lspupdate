-- adhoc, micro testing framework:
-- keys represnt functions to run in the target package (being tested)
-- values are lists of a "testCase", where each testCase is a
-- map with `args` (table, will be unpacked into actual arguments)
-- and `exp` - the expectation, will be used as is.
--
-- Run it with: `neovim --headless +'luafile lua/lspupdate/util_test.lua' +q`
-- no error/output == success!
local util = require "lspupdate/util"
local testCases = {
  lspVal = {
    {args = {""}, exp = {""}},
    {args = {"foo|"}, exp = {""}},
    {args = {"foo|pack1"}, exp = {"pack1"}},
    {args = {"foo|pack1,pack2,pack3"}, exp = {"pack1", "pack2", "pack3"}},
  },
  flatten = {
    {args = {{}}, exp = ""},
    {args = {{"foo"}}, exp = "foo"},
    {args = {{"foo", "bar"}}, exp = "foo bar"},
    {args = {{"foo", "bar"}, "^"}, exp = "foo^bar"},
    {args = {{"foo", {"bar", "baz"}}, " "}, exp = "foo bar baz"},
  },
  osCapture = {{args = {"echo hello world"}, exp = "hello world"}},
}

local I = vim.inspect
for k, v in pairs(testCases) do
  for _, tc in pairs(v) do
    local act = util[k](unpack(tc.args))
    assert(vim.deep_equal(tc.exp, act),
           "testing util." .. k .. "(), expected " .. I(tc.exp) .. " got "
               .. I(act) .. " for args " .. I(tc.args))
  end
end
