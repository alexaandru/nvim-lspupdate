(local split vim.split)

(fn notif [msg level]
  (vim.notify (.. "LspUpdate: " msg) (. vim.log.levels level)))

(fn info [msg]
  (notif msg :INFO))

(fn warn [msg]
  (notif msg :WARN))

(fn err [msg]
  (notif msg :ERROR))

(fn lspVal [s]
  (if (or (not s) (= s "") (not (string.find s "|"))) [s]
      (split (. (split s "|") 2) ",")))

(fn flatten [t sep]
  (table.concat (vim.tbl_flatten t) (or sep " ")))

;; TODO: rewrite it to use jobstart (reuse run() somehow?).
(fn osCapture [cmd trim]
  (let [no-trim (= trim false)
        f (assert (io.popen (.. cmd " 2>&1") :r))
        s (assert (f:read :*a))]
    (f:close)
    (if no-trim s (string.gsub (vim.trim s) "[\n\r]+" " "))))

;; the output table must be shared by all runs in a batch,
;; hence, it must be provided by the caller, and it must
;; be unique/the same one, for all of them.
(fn run [output cmd packages dry]
  (when (and packages (not (vim.tbl_isempty packages)))
    (set-forcibly! cmd (cmd:format (flatten packages)))
    (when dry
      (info (.. cmd " OK (dry)")))
    (when (not dry)
      (fn on_stdout [job data]
        (let [data (vim.fn.join (or data {}))
              data (.. (or "" (. output job)) data)]
          (tset output job data)))

      (fn on_exit [job code]
        (let [out (. output job)]
          (tset output job nil)
          (if (or (> code 0) (out:find :ERROR)) (err (.. cmd ": " out))
              (not= out "") (warn (.. cmd ": " out))
              (info (.. cmd " OK")))
          (if (vim.tbl_isempty output) (info "All done!"))))

      (let [opts {: on_exit : on_stdout :on_stderr on_stdout}
            job (vim.fn.jobstart cmd opts)]
        (tset output job "")))))

(fn basename [path]
  (path:sub (+ (path:find "/[^/]*$") 1)))

(fn dirname [path]
  (path:sub 1 (- (path:find "/[^/]*$") 1)))

;; TODO: allow endusers to override the location of TMP folder
(fn tmpdir []
  (if (= jit.os :Windows) (os.getenv :Temp) :/tmp))

(fn first_path []
  (let [path (os.getenv :PATH)
        sep (if (= jit.os :Windows) ";" ":")]
    (. (split path sep true) 2)))

{: info
 : warn
 : err
 : lspVal
 : flatten
 : osCapture
 : run
 : basename
 : dirname
 : tmpdir
 : first_path}

