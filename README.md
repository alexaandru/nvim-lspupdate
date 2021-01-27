# Neovim LSP Update

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
[see here](lua/lspupdate/config.lua) by defining a `g:lspupdate_commands`
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

Mix of beta and pre-alpha.

### Beta

About half of the servers can be installed by this plugin (see [config](lua/lspupdate/config.lua)
for details), and few of them were actually tested (only those that I use).
That is only `npm`, `pip` and `go` packages.

Now for these three, it actually seems to work very well AND they support
BOTH install and update, due to the way their update/install commands work
(`npm` will install on "update" command if not already installed, `pip` has
an "update" flag for the install command, etc.).

These are what I would consider beta at this point, they work, I use them to
keep the LSPs I am interested in up to date, problem solved :-)

### Pre-alpha

I have also defined commands for `gem`, `nix`, `cabal` and others BUT I haven't
used `gem` in many years now, so not sure how it works these days and haven't
used any of the others at all, so can't tell if or how well they work.

Feedback (as well as PRs) are more than welcome :-)
