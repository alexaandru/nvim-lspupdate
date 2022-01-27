(local {: err : warn : run} (require :lspupdate.util))

;; FIXME: output from npm seems to be truncated on errors.
;; Need to see what the errors are...
(fn LspUpdate [ctx]
  (let [opt ctx.args
        dry (= opt :dry)]
    (if (and (not= opt :dry) (not= opt nil))
        (err "only parameter 'dry' is supported")
        (let [{: commands : nosquash} (require :lspupdate.config)]
          (fn dispatch [kind args output unknown]
            (fn ins-unknown [kind typ]
              (let [ins table.insert
                    fmt string.format]
                (ins unknown (fmt "don't know how to handle command %s of type %s"
                                  kind typ))))

            (let [go vim.schedule
                  cmd (. commands kind)
                  typ (type cmd)]
              (if (and (. nosquash kind) (> (length args) 1))
                  (each [_ v (ipairs args)]
                    (dispatch kind [v] output unknown))
                  (match typ
                    :string (run output cmd args dry)
                    :function (go #(cmd output (vim.tbl_flatten args) dry))
                    _ (ins-unknown kind typ)))))

          (let [output {}
                packages-list (require :lspupdate.packages)
                (packages unknown) (packages-list)]
            (each [kind args (pairs packages)]
              (dispatch kind (vim.tbl_flatten args) output unknown))
            (each [_ v (pairs unknown)]
              (warn v)))))))

