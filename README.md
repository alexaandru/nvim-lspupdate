<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Neovim LSP Update](#neovim-lsp-update)
  - [Dependencies](#dependencies)
  - [Install](#install)
  - [Config](#config)
  - [Use](#use)
  - [Status](#status)
  - [Roadmap](#roadmap)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Neovim LSP Update

![Test](https://github.com/alexaandru/nvim-lspupdate/workflows/Test/badge.svg)
![Open issues](https://img.shields.io/github/issues/alexaandru/nvim-lspupdate.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

Updates installed (or auto installs if missing) LSP servers, that are already
configured in your `init.vim`.

It does NOT handle (auto)removals, i.e. if you had a LSP
server installed and then removed it's config, it will NOT
remove it. Only installs and/or updates are supported.

## Dependencies

- [Neovim HEAD/nightly](https://github.com/neovim/neovim/releases/tag/nightly) (v0.5 prerelease);
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).

NOTE: your user must be able to perform installs of packages corresponding to the LSPs
you will be using. I.e. if you install `npm` based LSPs, then you must be able to
run `npm i -g ...` successfully, **WITHOUT** sudo. That is the best practice anyway,
you should in general install "global" packages (whether we talk about NodeJS, Ruby,
Python or whatever) under your user and not at system level.

Please refer to http://npm.github.io/installation-setup-docs/installing/a-note-on-permissions.html
for setup instructions for NodeJS (which covers many of the LSPs available). For
LSPs in other languages, please refer to their own documentation for installing,
and best practices for setting up the environment.

## Install

Add `alexaandru/nvim-lspupdate` plugin to your `init.vim`, using your favorite
package manager, e.g.:

```
packadd nvim-lspupdate
```

## Config

I wrote this plugin as I did NOT want to manage installs manually anymore,
therefore I made it so that it requires NO configuration. It should work
out of the box for the supported configurations ([see status](#status)).

You can however override any (or all) of the commands used (which you can
[see here](lua/lspupdate/config.lua#L85)) by defining a `g:lspupdate_commands`
dictionary in your `init.vim`, i.e.:

```VimL
let g:lspupdate_commands = {'pip': 'pip install -U %s'}
```

Any commands you define will be added to the existing commands (and override
them) so you only need to define the ones you actually want to modify, not the
whole table.

Please refer to the comments in `config.lua` above mentioned for the keys
and values (commands) to use in that dictionary.

## Use

See [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig#quickstart) on
how to setup the LSP servers' configuration. Once you have them configured
(or any time later, for updates), then run:

```
:LspUpdate
```

and it will install any missing LSP servers as well as update the existing ones,
where possible (see below).

Currently, the command takes no options. This may or may not change in the future.

Hint: use `:checkhealth lspconfig` before/after to verify that the LSPs were
installed.

## Status

<style>
section.cols {
        display:flex;
}
section.cols div {
        width:100%;
}
.green {
color:green;
        }
.gray {
        color:gray;
        text-decoration: line-through;
        }
</style>

Mix of beta (<b class="green">green</b>), pre-alpha (<b>bold</b>) and not (yet) supported (<span class="gray">gray</span>).

<section class="cols">
<div>
<span class="gray">als</span><br>
<b class="green">angularls</b><br>
<b class="green">bashls</b><br>
<span class="gray">ccls</span><br>
<span class="gray">clangd</span><br>
<b class="">clojure_lsp</b><br>
<b class="green">cmake</b><br>
<span class="gray">codeqlls</span><br>
<b class="green">cssls</b><br>
<span class="gray">dartls</span><br>
<span class="gray">denols</span><br>
<b class="">dhall_lsp_server</b><br>
<b class="green">diagnosticls</b><br>
<b class="green">dockerls</b><br>
<b class="green">efm</b><br>
<span class="gray">elixirls</span><br>
</div>

<div>
<b class="green">elmls</b><br>
<b class="">flow</b><br>
<b class="green">fortls</b><br>
<span class="gray">gdscript</span><br>
<span class="gray">ghcide</span><br>
<b class="green">gopls</b><br>
<span class="gray">groovyls</span><br>
<span class="gray">hie</span><br>
<span class="gray">hls</span><br>
<b class="green">html</b><br>
<b class="green">intelephense</b><br>
<span class="gray">jdtls</span><br>
<b class="green">jedi_language_server</b><br>
<b class="green">jsonls</b><br>
<span class="gray">julials</span><br>
<span class="gray">kotlin_language_server</span><br>
</div>

<div>
<b class="green">leanls</b><br>
<span class="gray">metals</span><br>
<b class="green">nimls</b><br>
<b class="green">ocamlls</b><br>
<span class="gray">ocamllsp</span><br>
<span class="gray">omnisharp</span><br>
<span class="gray">perlls</span><br>
<b class="green">purescriptls</b><br>
<b class="green">pyls</b><br>
<span class="gray">pyls_ms</span><br>
<span class="gray">pyright</span><br>
<span class="gray">r_language_server</span><br>
<b class="">racket_langserver</b><br>
<b class="">rls</b><br>
<b class="">rnix</b><br>
<b class="green">rome</b><br>
</div>

<div>
<span class="gray">rust_analyzer</span><br>
<span class="gray">scry</span><br>
<b class="">solargraph</b><br>
<b class="">sorbet</b><br>
<span class="gray">sourcekit</span><br>
<b class="green">sqlls</b><br>
<span class="gray">sumneko_lua</span><br>
<b class="green">svelte</b><br>
<span class="gray">terraformls</span><br>
<b class="green">texlab</b><br>
<b class="green">tsserver</b><br>
<b class="green">vimls</b><br>
<span class="gray">vls</span><br>
<b class="green">vuels</b><br>
<b class="green">yamlls</b><br>
<span class="gray">zls</span><br>
</div>
</section>

&nbsp;<br>
About half of the servers have [a config and a command](lua/lspupdate/config.lua)
defined. Of those, only `npm`, `pip`, `go` and `cargogit` commands were
tested. These are what I would consider beta.

The others that do have a config and a command defined, but were not yet
tested (`gem`, `cargo`, `nix`, etc.) I would consider pre-alpha. In theory,
they may work. If you do use them and they work, please let me know so I
can update this README accordingly.

Those that do not even have a config or command defined are, obviously,
not supported.

## Roadmap

In no particular order:

- dry run (show but don't actually run the commands);
- integration tests;
- add support for github binary releases;
- make the config configurable by end users (so they can override
  particular entries and use alternate sources/versions/etc.);
- add a nice way to handle "complicated installs" (yes sumenko_lua,
  that includes you);
- give a way to end users to control if the packages (for a
  particular LSP or package kind) are "merged" into a single
  command or handled individually;
- ensure it runs well on all of {Linux,MacOS,Windows};
- add a make target to verify our config against nvim-lspconfig
  to ensure we're catching any additions to the list of supported
  LSP servers.
