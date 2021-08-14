(local {: osCapture} (require :lspupdate.util))

(fn [config]
  (let [start (. vim.fn "health#report_start")
        ok (. vim.fn "health#report_ok")
        err (. vim.fn "health#report_error")
        warn #(print (.. "  - WARN: " $))
        kinds {}]
    (start "Checking for executables needed for install/update...")
    (let [(packages unknown) ((require :lspupdate.packages))]
      (each [_ v (ipairs unknown)]
        (warn v))
      (each [k (pairs packages)]
        (let [check (. config.checks k)]
          (if (not check) (warn (.. "check is not configured for " k))
              (each [cmd opts (pairs check)]
                (let [out (or (osCapture (.. cmd " " (. opts 1))) "")
                      m (out:match (. opts 2))
                      fmt string.format]
                  (if (or (not m) (= m ""))
                      (err (fmt "command %s (needed for %s) not found" cmd k))
                      (ok (fmt "%s ready: %s v%s found" k cmd m)))))))))))

