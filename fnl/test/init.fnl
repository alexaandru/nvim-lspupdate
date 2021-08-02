(local I vim.inspect)
(local fmt string.format)

;;  adhoc, micro testing framework:
;; 
;;  it takes two parameters: a module name (to be tested),
;;  and a table with testCases definitions, as follows:
;;  keys represent functions to run in the target module (being tested)
;;  values are lists of a "testCase", where each testCase is a
;;  map with `args` (table, will be unpacked into actual arguments)
;;  and `exp` - the expectation, will be used as is and compared
;;  against the actual output from the function being tested.
;; 
;;  Run it with: `nvim --headless +"packadd hotpot" +"exe 'lua require \"x.y\"'" +q`
;;  (where x.y is the path to your module, without .lua ext, and with dot as separator).
;;
;;  No error/output == success!
(fn [pkg test-suite]
  (each [func test-cases (pairs test-suite)]
    (each [_ tc (pairs test-cases)]
      (let [out ((. (require pkg) func) (unpack tc.args))
            x (or (I tc.args) "")
            pretty-args (if (> (x:len) 4) (x:sub 3 (- (x:len) 2)) x)]
        (assert (vim.deep_equal tc.exp out)
                (fmt "testing %s.%s(%s), expected %s got %s" ;;
                     pkg func pretty-args (I tc.exp) (I out)))))))

