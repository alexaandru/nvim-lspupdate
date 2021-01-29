-- adhoc, micro testing framework:
--
-- it takes two parameters: a module name (to be tested),
-- and a table with testCases definitions, as follows:
-- keys represent functions to run in the target module (being tested)
-- values are lists of a "testCase", where each testCase is a
-- map with `args` (table, will be unpacked into actual arguments)
-- and `exp` - the expectation, will be used as is and compared
-- against the actual output from the function being tested.
--
-- Run it with: `neovim --headless +'luafile x/y.lua' +q`
-- no error/output == success!
return function(package, testCases)
  local I = vim.inspect
  for k, v in pairs(testCases) do
    for _, tc in pairs(v) do
      local act = require(package)[k](unpack(tc.args))
      assert(vim.deep_equal(tc.exp, act),
             "testing " .. package .. "." .. k .. "(), expected " .. I(tc.exp)
                 .. " got " .. I(act) .. " for args " .. I(tc.args))
    end
  end
end
