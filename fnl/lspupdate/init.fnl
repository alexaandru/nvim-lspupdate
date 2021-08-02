(local {: config : commands} (require :lspupdate.config))
(local {: err : warn : lspVal : run} (require :lspupdate.util))
(local ins table.insert)

(fn [opt]
  (let [dry (= opt :dry)]
    (if (and (not= opt :dry) (not= opt nil))
        (err "only parameter 'dry' is supported")
        (let [packages {}
              unknown {}
              output {}
              user-commands (or vim.g.lspupdate_commands {})]
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
          (let [cmds (vim.tbl_extend :force commands user-commands)]
            (each [k v (pairs packages)]
              (let [cmd (. cmds k)]
                (if (= (type cmd) :string) (run output cmd v dry)
                    (= (type cmd) :function)
                    (vim.schedule #(cmd output (vim.tbl_flatten v) dry))
                    (ins unknown
                         (.. "don't know how to handle command " k " of type "
                             (type cmd)))))))
          (each [_ v (pairs unknown)]
            (warn v))))))

