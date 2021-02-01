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
-- Run it with: `nvim --headless +'luafile x/y.lua' +q`
-- no error/output == success!
return function(package, testSuite)
  local I = vim.inspect
  for func, testCases in pairs(testSuite) do
    for _, tc in pairs(testCases) do
      local act = require(package)[func](unpack(tc.args))
      local args = I(tc.args) or ""
      if args:len() > 4 then args = args:sub(3, args:len() - 2) end

      assert(vim.deep_equal(tc.exp, act),
             "testing " .. package .. "." .. func .. "(" .. args
                 .. "), expected " .. I(tc.exp) .. " got " .. I(act) .. "\n")
    end
  end
end
