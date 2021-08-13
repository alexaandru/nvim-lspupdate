(local {: err : warn : lspVal : run} (require :lspupdate.util))
(local cfg (require :lspupdate.config))
(local ins table.insert)

(fn [opt]
  (fn with-user-override [tbl]
    (let [default-tbl (. cfg tbl)
          user-tbl (or {} (. vim.g (.. :lspupdate_ tbl)))]
      (vim.tbl_extend :force default-tbl user-tbl)))

  (let [dry (= opt :dry)]
    (if (and (not= opt :dry) (not= opt nil))
        (err "only parameter 'dry' is supported")
        (let [packages {}
              unknown {}
              output {}
              config (with-user-override :config)
              commands (with-user-override :commands)
              nosquash (with-user-override :nosquash)]
          (fn dispatch [kind args]
            (let [cmd (. commands kind)]
              ;; dispatch commands, respecting nosquash indication
              (if (and (vim.tbl_contains nosquash kind) (> (length args) 1))
                  (each [_ v (ipairs args)]
                    (dispatch kind [v]))
                  (if (= (type cmd) :string) (run output cmd args dry)
                      (= (type cmd) :function)
                      (vim.schedule #(cmd output (vim.tbl_flatten args) dry))
                      (ins unknown
                           (.. "don't know how to handle command " kind
                               " of type " (type cmd)))))))

          (each [lsp _ (pairs (require :lspconfig/configs))]
            (let [cfg (. config lsp)]
              (if (or (not cfg) (= cfg ""))
                  (ins unknown
                       (.. "don't know how to handle " lsp " LSP server"))
                  (let [kind (. (vim.split cfg "|") 1)]
                    (if (not (. commands kind))
                        (ins unknown
                             (.. "don't know how to install command " kind
                                 " for LSP server " lsp))
                        (do
                          (when (not (. packages kind))
                            (tset packages kind {}))
                          (ins (. packages kind) (lspVal cfg))))))))
          (each [kind args (pairs packages)]
            (dispatch kind (vim.tbl_flatten args)))
          (each [_ v (pairs unknown)]
            (warn v))))))

