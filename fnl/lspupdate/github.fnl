;; TODO: get it to work with all the github releases we have in config
;; (see test cases at the bottom).
;;
;; Current status: we can retrieve the release URLs for all of them.
;; We can only install terraform-ls (due to assumed conventions).
;;
;; Next steps:
;;  - add the ability to detect archive format (or lack of);
;;  - add ability to extract certain file (or files) from the archive
;;    (if there is an archive). Will need ammendment to the DSL, maybe
;;    something like gh_bin|<org>/<repo>[;<bin>[,<bin2>[,...<binN>]]] ?
;;    and default the bin to <repo> (which takes care of terraform-ls
;;    at least).

(local release-api "https://api.github.com/repos/%s/releases/latest")
(local no-output-trim false)
(local fmt string.format)
(local {: info : err : osCapture : basename : tmpdir : dirname : first_path}
       (require :lspupdate.util))

(fn release-os []
  (let [os (jit.os:lower)]
    (if (= :osx os) :darwin os)))

;; vim regex compatible OS pattern
(fn release-os-pat []
  (let [os (jit.os:lower)]
    (match os
      :osx "\\(darwin\\|macos\\|osx\\)"
      :windows "\\(win\\|windows\\)"
      :linux "\\(linux\\|ubuntu\\)"
      _ os)))

(local sep "[-_.]")
(local arch-pat "\\(x\\|x86_\\|amd\\)64")
(local os-pat (vim.regex (let [pat (release-os-pat)
                               patS (.. sep pat sep)
                               pat (fmt "\\(%s.*%s\\|%s.*%s\\|%s%s64\\)"
                                        arch-pat patS patS arch-pat sep pat)]
                           pat)))

;; release will return the latest release .zip file for the given
;; github repo (i.e. hashicorp/terraform-ls) using Github API:
;; https://docs.github.com/en/rest/reference/repos#releases
(fn release [proj]
  (let [curl (fmt "curl -sL %s" (fmt release-api proj))
        out (osCapture curl no-output-trim)
        json (vim.json.decode out)]
    (if (or (not json)
            (and json.message (json.message:find "rate limit exceeded")))
        (err (.. "Rate limit exceeded while attempting to resolve " proj))
        (let [assets (?. json :assets)
              asset (vim.tbl_filter #(os-pat:match_str ($.name:lower)) assets)]
          ;; NOTE: Azure/bicep and chipsalliance/verible return multiple choices, and the last one fits.
          ;; That's the reason for picking the last one. The other releases don't care (only have one).
          (?. asset (length asset) :browser_download_url)))))

;; TODO: allow end users to override where the release binaries go
(fn update_release [output proj dry]
  (tset output proj 1)
  (let [pname (basename proj)
        url (release proj)]
    (if (not url) (err (.. "URL error for " pname)) dry
        (info (.. url " to " pname " OK (dry)"))
        (do
          (var location (first_path))
          (let [existing (vim.fn.exepath pname)]
            (if (not= "" existing) (set location (dirname existing))))
          (let [tmp (tmpdir)
                ;; FIXME: not concurrency friendly. Better use the original name
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
    (vim.schedule #(update_release output p dry))))

;; NOTE: careful when using this for testing, as the non-authenticated rate limit is 60/hour
;; running the below a few times (8, at the time of writing this) gets us past that limit...

;; fnlfmt: skip
;(collect [_ v (ipairs [:hashicorp/terraform-ls :Azure/bicep :github/codeql-cli-binaries :OmniSharp/omnisharp-roslyn :Galarius/opencl-language-server :rust-analyzer/rust-analyzer :zigtools/zls :Pure-D/serve-d :chipsalliance/verible])]
;  v (release v))

