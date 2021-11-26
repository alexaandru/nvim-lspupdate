;; Holds the installation/update instructions.
;;
;; INTERNAL - end users should not have to edit anything in here,
;; if needed, please submit a ticket.
;; The keys, represent the name of the LSP, as defined in nvim-lspconfig:
;; https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
;;
;; The values represent a micro DSL, as follows:
;; {npm,go,pip,gem,etc.}|package1[,package2[,...]]
;; where packageN is a package installable by the corresponding command.

;; fnlfmt: skip
(local config {
       :als nil
       :angularls "npm|@angular/language-server"
       :ansiblels "npm|ansible-language-server"
       :arduino_language_server "go|github.com/arduino/arduino-language-server"
       :bashls "npm|bash-language-server"
       :beancount "npm|@bryall/beancount-langserver"
       :bicep "bin|https://github.com/Azure/bicep/releases/latest/download/bicep-langserver.zip"
       :bsl_ls nil
       :ccls nil
       :clangd nil
       :clojure_lsp "nix|clojure-lsp"
       :cmake "pip|cmake-language-server"
       :codeqlls "bin|https://github.com/github/codeql-cli-binaries/releases/download/v2.5.7/codeql-{linux,osx,win}64.zip"
       :crystalline nil
       :csharp_ls "dotnet|csharp-ls"
       :cssls "npm|vscode-langservers-extracted"
       :cucumber_language_server "npm|@cucumber/language-server"
       :dartls nil
       :denols "cargo|deno"
       :dhall_lsp_server "cabal|dhall-lsp-server"
       :diagnosticls "npm|diagnostic-languageserver"
       :dockerls "npm|dockerfile-language-server-nodejs"
       :dotls "npm|dot-language-server"
       :efm "go|github.com/mattn/efm-langserver@latest"
       :elixirls nil
       :elmls "npm|elm,elm-test,elm-format,@elm-tooling/elm-language-server"
       :ember "npm|@lifeart/ember-language-server"
       :emmet_ls "npm|emmet-ls"
       :erlangls nil
       :esbonio "pip|esbonio"
       :eslint "npm|vscode-langservers-extracted"
       :flow "npm|flow-bin"
       :flux-lsp "cargogit|https://github.com/influxdata/flux-lsp"
       :fortls "pip|fortran-language-server"
       :fsautocomplete nil
       :fstar "opam|fstar"
       :gdscript "bin|https://downloads.tuxfamily.org/godotengine/3.3.2/Godot_v3.3.2-stable_{linux_headless.64,osx.64,win64.exe}.zip"
       :ghcide "deprecated|use hls"
       :gopls "go|golang.org/x/tools/gopls@latest"
       :graphql "npm|graphql-language-service-cli"
       :groovyls nil
       :haxe_language_server nil
       :hie "deprecated|use hls"
       :hls "bin|https://github.com/haskell/haskell-language-server/releases/download/1.2.0/haskell-language-server-{Linux,macOS}-1.2.0.tar.gz"
       :html "npm|vscode-langservers-extracted"
       :idris2_lsp nil
       :intelephense "npm|intelephense"
       :java_language_server nil
       :jdtls nil
       :jedi_language_server "pip|jedi-language-server"
       :jsonls "npm|vscode-langservers-extracted"
       :jsonnet_ls "go|github.com/jdbaldry/jsonnet-language-server"
       :julials "julia|Pkg.add(\"LanguageServer\"); Pkg.add(\"SymbolServer\")"
       :kotlin_language_server nil
       :lean3ls nil
       :leanls "npm|lean-language-server"
       :lelwel_ls "cargo2|lelwel"
       :lemminx "bin|https://download.jboss.org/jbosstools/vscode/stable/lemminx-binary/"
       :ltex nil
       :metals nil
       :mint nil
       :nickel_ls nil
       :nimls "nim|nimlsp"
       :ocamlls "npm|ocaml-langauge-server"
       :ocamllsp "opam|ocaml-lsp-server"
       :omnisharp "bin|https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v1.37.12/omnisharp-{linux-x64,osx,win-x64}.zip"
       :pasls nil
       :perlls "perl|Perl::LanguageServer"
       :perlpls "perl|PLS"
       :phpactor nil
       :powershell_es nil
       :prismals "npm|@prisma/language-server"
       :psalm "composer|vimeo/psalm"
       :puppet nil
       :purescriptls "npm|purescript-language-server,spago,purescript"
       :pylsp "pip|python-lsp-server[all]"
       :pyre "pip|pyre-check"
       :pyright "npm|pyright"
       :r_language_server "r|languageserver"
       :racket_langserver "raco|racket-langserver"
       :rescriptls nil
       :rls "rust|rls,rust-analysis,rust-src"
       :rnix "cargo|rnix-lsp"
       :robotframework_ls nil
       :rome "npm|rome"
       :rust_analyzer "bin|https://github.com/rust-analyzer/rust-analyzer/releases/download/2021-07-12/rust-analyzer-x86_64-{unknown-linux-gnu,apple-darwin,pc-windows-msvc}.gz"
       :scry nil
       :serve_d "bin|https://github.com/Pure-D/serve-d/releases"
       :sixtyfps "cargo|sixtyfps-lsp"
       :solang nil
       :solargraph "gem|solargraph"
       :sorbet "gem|sorbet"
       :sourcekit nil
       :spectral_ls "npm|spectral-language-server"
       :sqlls "npm|sql-language-server"
       :sqls "go|github.com/lighttiger2505/sqls@latest"
       :stylelint_lsp "npm|stylelint-lsp"
       :sumneko_lua nil
       :svelte "npm|svelte-language-server"
       :svls "cargo|svls"
       :tailwindcss nil
       :taplo "cargo|taplo-lsp"
       :terraform_lsp "go|github.com/juliosueiras/terraform-lsp"
       :terraformls "gh_bin|hashicorp/terraform-ls"
       :texlab "cargogit|https://github.com/latex-lsp/texlab.git"
       :tflint "go|github.com/terraform-linters/tflint@latest"
       :theme_check "gem|theme-check"
       :tsserver "npm|typescript,typescript-language-server"
       :typeprof "gem|typeprof"
       :vala_ls nil
       :vdmj nil
       :vimls "npm|vim-language-server"
       :vls nil
       :volar "npm|@volar/server"
       :vuels "npm|vls"
       :yamlls "npm|yaml-language-server"
       :zeta_note nil
       :zk nil
       :zls "bin|https://github.com/zigtools/zls/releases/download/0.1.0/x86_64-{linux,macos,windows}.tar.xz"})

(local update_github_releases (require :lspupdate.github))

;; the table defines the actual commands to be run for
;; each type of install. The keys must correspond to those
;; used in the config table above, and the value represents
;; the command to be run.
;;
;; The command MUST embed a %s in it - that will be replaced
;; with the (space separated) list of packages to install.

;; fnlfmt: skip
(local commands {
       :bin nil
       :cabal "cabal install %s"
       :cargo "cargo install %s"
       :cargo2 "cargo install --features=lsp %s"
       :cargogit "cargo install --locked --git %s"
       :composer "composer global require %s"
       :dotnet "dotnet tool install %s"
       :gem "gem install -q --silent --user-install %s"
       :gh_bin update_github_releases
       :go "go install %s"
       :julia "julia -e 'using Pkg; %s'"
       :luarocks "luarocks install --local %s"
       :luarocksdev "luarocks install --server=https://luarocks.org/dev --local %s"
       :nim "nimble install %s"
       :nix "nix-shell -p %s"
       :npm "npm i --quiet -g %s"
       :opam "opam install %s"
       :perl "PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install %s'"
       :pip "pip3 install --user -U -q %s"
       :r "R -q --slave -e \"install.packages(\\\"%s\\\",quiet=T)\""
       :raco "raco pkg install %s"
       :rust "rustup component add %s"})

;; by default the config.commands will be run in one go, with
;; all of their packages squashed into a single, space separated,
;; string.
;; I.e. if you have npm packages A, B and C, the command being
;; run will be `npm i [...] A B C` which will install them in
;; one go.
;; Adding a command to the `nosquash` map, prevents that behavior
;; and causes them to be run separately (but concurrently still).
(local nosquash {:go true :julia true :perl true})

;; list of known tools that can be installed/updated.
;; they get picked up automatically, taken from the
;; config of "proxy" LSPs:
;; - https://github.com/mattn/efm-langserver [DONE]
;; - https://github.com/iamcco/diagnostic-languageserver [TODO]
;; - https://github.com/jose-elias-alvarez/null-ls.nvim [TODO]
;; - https://github.com/mfussenegger/nvim-lint [TODO]
;;
;; the special "command" :nop, is to be used for commands
;; that are to be ignored from updates, such as commands
;; installed via os/package manager, and which consequently
;; will get their updates that way.

;; fnlfmt: skip
(local tools {
       :eslint_d "npm|eslint_d,eslint"
       :fennel "github|bakpakin/Fennel"
       :fnlfmt "sourcehut|~technomancy/fnlfmt"
       :golangci-lint "go|github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
       :jq :nop
       :jsonlint "npm|jsonlint"
       ;:lua-format "luarocksdev|luaformatter"
       :luacheck "luarocks|luacheck"
       :mix "apt|mix"
       :prettier "npm|preetier"
       :rebar3 "apt|rebar3"
       :terrascan "gh_bin_TODO|accurics/terrascan"
       :tfsec "gh_bin_TODO|aquasecurity/tfsec"})

;; the table holds checks for the various commands,
;; that allow us to determine if the executables are
;; installed or not.

;; fnlfmt: skip
(local checks {
       :gem {:gem [:-v "(%d+.%d+.%d+)"]}
       :gh_bin {:unzip [:-v "UnZip (%d+.%d+) of"] :curl [:-V "(%d+.%d+.%d+)"]}
       :go {:go [:version "go(%d+.%d+.%d+) "]}
       :julia {:julia [:-v "(%d+.%d+.%d+)"]}
       :luarocks {:luarocks [:--version "(%d+.%d+.%d+)"]}
       :npm {:npm [:-v "(%d+.%d+.%d+)"]}
       :opam {:opam [:--version "(%d+.%d+.%d+)"]}
       :perl {:perl [:-v "v(%d+.%d+.%d+)"]}
       :pip {:pip3 [:-V "pip (%d+.%d+.%d+)"]}
       :r {:R [:--version "R version (%d+.%d+.%d+)"]}})

(fn with-user-override [default-tbl key]
  (let [user-tbl (or {} (. vim.g (.. :lspupdate_ key)))]
    (vim.tbl_extend :force default-tbl user-tbl)))

(collect [k tbl (pairs {: config : commands : nosquash : tools : checks})]
  (values k (with-user-override tbl k)))

