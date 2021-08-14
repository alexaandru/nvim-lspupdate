(fn tool-extract-bash [tool]
  (tool:match "bash%s+-c%s+%W(%S+)%s+"))

(fn tool-extract [tool]
  (if tool (if (vim.startswith tool "bash -c") (tool-extract-bash tool)
               (. (vim.split tool " ") 1))))

(fn tools-list-efm [] ; print(vim.inspect(x.make_config().settings.languages))
  (let [tools {}
        {: efm} (require :lspconfig/configs)
        {: make_config} efm
        out (make_config)
        languages out.settings.languages]
    (each [_ v1 (pairs languages)]
      (each [_ v2 (ipairs v1)]
        (let [tool (tool-extract v2.lintCommand)]
          (if tool (tset tools tool true)))
        (let [tool (tool-extract v2.formatCommand)]
          (if tool (tset tools tool true)))))
    (vim.tbl_keys tools)))

(fn tools-list [lsp]
  (match lsp
    :efm (tools-list-efm)
    _ []))

;; returns all the packages to be installed,
;; both LSP and tools used by LSP "proxies".
;;
;; It also returns a table with unkown/unable
;; to handle packages/commands.
(fn list-all []
  (let [{: lspVal} (require :lspupdate.util)
        {: config : tools : commands} (require :lspupdate.config)
        ins table.insert
        packages {}
        unknown {}]
    (fn ins-packages [cfg lsp label]
      (if (or (not cfg) (= cfg ""))
          (ins unknown (.. "don't know how to handle " lsp " " label))
          (let [kind (. (vim.split cfg "|") 1)]
            (if (not= kind :nop)
                (if (not (. commands kind))
                    (ins unknown
                         (.. "don't know how to resolve command " kind " for "
                             label " " lsp))
                    (do
                      (when (not (. packages kind))
                        (tset packages kind {}))
                      (ins (. packages kind) (lspVal cfg))))))))

    ;; gather packages for all configured LSPs
    (each [lsp (pairs (require :lspconfig/configs))]
      (let [cfg (. config lsp)]
        (ins-packages cfg lsp "LSP server"))
      ;; gather all tools for "proxy LSPs"
      (if (= :efm lsp)
          (let [extracted-tools (tools-list lsp)]
            (each [_ tool (ipairs extracted-tools)]
              (let [cfg (. tools tool)]
                (ins-packages cfg tool :tool))))))
    (values packages unknown)))

