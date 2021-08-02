(local no-output-trim false)
(local fmt string.format)
(local {: info : err : osCapture : basename : tmpdir : dirname : first_path}
       (require :lspupdate.util))

(fn release-os []
  (let [os (jit.os:lower)]
    (if (= :osx os) :darwin os)))

;; release will return the latest release .zip file for the given
;; github repo (i.e. hashicorp/terraform-ls)
(fn release [proj]
  (let [proj-re (proj:gsub "-" "%%-")
        pname-re (string.gsub (basename proj) "-" "%%-")
        os (release-os)
        pat (fmt "/%s/releases/download[/.v0-9]+/%s[_.0-9]+%s_amd64.zip"
                 proj-re pname-re os)
        curl (fmt "curl -sL https://github.com/%s/releases/latest" proj)
        out (osCapture curl no-output-trim)
        m (out:match pat)]
    (if (= os "") "" (.. "https://github.com" m))))

;; TODO: allow end users to override where the release binaries go
(fn update_release [output proj dry]
  (tset output proj 1)
  (let [pname (basename proj)
        url (release proj)]
    (if (= "" url) (err (.. "URL error for " pname)) dry
        (info (.. url " to " pname " OK (dry)"))
        (do
          (var location (first_path))
          ;; TODO: use exepath() instead, as it's portable
          (let [existing (osCapture (.. "type " pname) no-output-trim)]
            (if (vim.startswith existing (.. pname " is "))
                (set location
                     (dirname (existing:sub (+ (existing:find " [^ ]*$") 1))))))
          (let [tmp (tmpdir)
                curl-out (osCapture (fmt "curl -sLo %s/lsp.zip %s" tmp url))]
            (if (not= curl-out "")
                (err (.. "failed to download " url ": " curl-out))
                (let [os (release-os)
                      ext (if (= os :windows) :.exe "")
                      unzip-out (osCapture (fmt "unzip -qo %s/lsp.zip %s%s -d %s/"
                                                tmp pname ext location))]
                  (if (not= unzip-out "")
                      (err (fmt "failed to unzip %s/lsp.zip to %s/: %s" tmp
                                location unzip-out))
                      (do
                        (tset output proj nil)
                        (info (fmt "gh_bin %s to %s" url location))
                        (if (vim.tbl_isempty output) (info "All done!")))))))))))

(fn update_releases [output projs dry]
  (each [_ p (ipairs projs)]
    (update_release output p dry)))

