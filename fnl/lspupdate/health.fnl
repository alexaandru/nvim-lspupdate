(local {: osCapture} (require :lspupdate.util))
(local fmt string.format)

(fn [config]
  (let [start (. vim.fn "health#report_start")
        ok (. vim.fn "health#report_ok")
        err (. vim.fn "health#report_error")
        warn #(print (.. "  - WARN: " $))
        kinds {}]
    (start "Checking for executables needed for install/update...")
    (each [lsp _ (pairs (require :lspconfig/configs))]
      (let [cfg (. config.config lsp)]
        (if (or (not cfg) (= cfg ""))
            (warn (.. "don't know how to handle " lsp " LSP server"))
            (let [kind (. (vim.split cfg "|") 1)]
              (if (not (. config.commands kind))
                  (warn (.. "don't know how to install command " kind
                            " for LSP server " lsp))
                  (tset kinds kind true))))))
    (each [k (pairs kinds)]
      (let [check (. config.checks k)]
        (if (not check) (warn (.. "check is not configured for " k))
            (each [cmd opts (pairs check)]
              (let [out (or (osCapture (.. cmd " " (. opts 1))) "")
                    m (out:match (. opts 2))]
                (if (or (not m) (= m ""))
                    (err (fmt "command %s (needed for %s) not found" cmd k))
                    (ok (fmt "%s ready: %s v%s found" k cmd m))))))))))

