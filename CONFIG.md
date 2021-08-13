**IMPORTANT!** As of v1.0.0, the project is written in [**Fennel**](https://fennel-lang.org/).

If you already use **Fennel** (with [**Hotpot**](https://github.com/rktjmp/hotpot.nvim))
then this plugin will work out of the box.

If you do **NOT** use **Fennel**, then there is an extra step you need to take,
after checking out the plugin and before using it for the 1st time:
run `make lua` from the plugin folder. That is a one time operation, that
will convert the **Fennel** files to **Lua**.

Most plugins managers should allow you to automate the step above, i.e.:
with **vim-plug**, you can do:

```
Plug 'alexaandru/nvim-lspupdate', {'do': 'make lua'}
```

---

# Neovim LSP Update

![Test](https://github.com/alexaandru/nvim-lspupdate/workflows/Test/badge.svg)
![Open issues](https://img.shields.io/github/issues/alexaandru/nvim-lspupdate.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

Updates installed (or auto installs if missing) LSP servers, that are already
configured in your `init.vim`.

It does NOT handle (auto)removals, i.e. if you had a LSP
server installed and then removed it's config, it will NOT
remove it. Only installs and/or updates are supported.

You can see it below in action:

https://user-images.githubusercontent.com/85237/129180498-11457175-5cfb-4085-a2a0-51745f56ee70.mp4

**NOTE:** your user must be able to perform installs of packages corresponding to the LSPs
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

### Dependencies

- [Neovim 0.5+](https://github.com/neovim/neovim/releases/tag/v0.5.0)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

#### Conditional Dependencies

If you (want to) run Fennel in **Neovim**, you will need [Hotpot](https://github.com/rktjmp/hotpot.nvim).

If instead you want to only run **Lua** (for which **Neovim** was builtin support)
you will need **Lua** installed on your system, in order to convert the
**Fennel** files using the `make lua` target.

## Config

I wrote this plugin as I did NOT want to manage installs manually anymore,
therefore I made it so that it requires NO configuration. It should work
out of the box for the supported configurations ([see status](#status)).

You can however override any (or all) of the [config tables](fnl/lspupdate/config.fnl)
by defining a `g:lspupdate_<table>` dictionary in your `init.vim`, i.e.:

```VimL
let g:lspupdate_commands = {'pip': 'pip install -U %s'}
```

or `init.lua`:

```Lua
vim.g.lspupdate_commands = {pip = "pip install -U %s"}
```

Any commands you define will be added to the existing commands (and override
them) so you only need to define the ones you actually want to modify, not the
whole table.

Please refer to the comments in `config.lua` above mentioned for the keys
and values (commands) to use in that dictionary.

Similarly, you can amend the `nosquash` table as well as the `config` table,
which holds the config for all the LSPs (although, not recommended, unless
you know what you are doing).

I.e. if you want to pin a specific version of a LSP, you can do (in init.lua):

```Lua
vim.g.lspupdate_config = {gopls = "go|golang.org/x/tools/gopls@v0.7.1"}
```

### Advanced

Finally, the commands table accepts (as values) either a string (i.e. "npm i %s")
or a function, in which case it will be called with the following parameters:
output (table), args (table) and dry (bool).

That combined with the ability to add configs for the LSPs, allow you to fully
override what the plugin does, including extending it to support LSPs that it
does not currently support. I.e.

Let's pick up `groovyls` (which at the time of writing is set to nil) say you
want that handled by this plugin. The boilerplate to support it would be
(again, in init.lua):

```Lua
local function update_groovyls(output, args, dry)
  -- output table is used for sync across all installs in a given "batch"
  -- you must set this as soon as your functions starts, and unset it when
  -- done.
  output.groovyls = 1

  -- you should add support for dry mode like this
  if dry
          vim.notify("LspUpdate: Installing groovyls OK (dry)")
          return
  end

  -- we are not in dry mode, doing the actual install here:
  -- code for your install goes here, the package(s) you
  -- specified in config are available as a list in args

  -- assuming all went well, we get to the end
  vim.notify("LspUpdate: Installing groovyls OK")
  output.groovyls = nil
end

vim.g.config = {groovyls = "user1|<package_path_will_be_passed_in_args>"}
vim.g.commands = {user1 = update_groovyls}

```

and that's how you can implement a custom "override" for a specific
LSP and install "kind". You must take care when picking up your config
"kind" (i.e. "npm", "go", "pip", etc.) not to pick an existing one,
and this, accidentally override it. It's best to pick something with
less chances of clashing, such as userN or whatever, anything that is
not defined as a key in `config.commands`.

## Usage

See [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig#quickstart) on
how to setup the LSP servers' configuration. Once you have them configured
(or any time later, for updates), then run:

```
:LspUpdate [dry]
```

and it will install any missing LSP servers as well as update the existing ones,
where possible (see below).

Hint: use `:checkhealth lspconfig` before/after to verify that the LSPs were
installed.

If the dry parameter is passed, then commands are only printed but not actually run.

The installs are async (using jobstart()) with one exception (gh_bin install type,
see below) so you can just fire & forget, and sometime later, check with `:messages`.

When all the jobs are completed it will print an "All done!" message.

## Status

Mix of **`stable`**, `beta` and <s>not (yet) supported</s>.

About 2/3 of the servers have [a config and a command](fnl/lspupdate/config.fnl)
defined. Of those, the following were battle tested by me or others: **`npm`**,
**`pip`**, **`go`**, **`cargogit`**, **`r`**, **`gem`** and **`gh_bin`**. These
are what I consider **`stable`**.

The others that do have a config and a command defined, but were not yet
tested (`cargo`, `nix`, etc.) I would consider `beta`. In theory, they may
work, just need beta testers :) If you do use them and they work, please
let me know so I can update this README accordingly.

Those that do not even have a config or command defined are, obviously,
not supported.

### Github binary releases

We now have support for Github binary releases (gh_bin "pseudo command") with
`terraform-ls` being the first to be tested successfully, on Linux.

To support this type of update, there are additional dependencies/requirements:

- `curl` (used to download the .zip files);
- `unzip` (used to unzip them).
- the repo name, .zip file prefix and binary file inside the .zip are identical
  (i.e. hashicorp/terraform-ls has terraform-ls.\*.zip assets which include a
  terraform-ls binary, well except for Windows, which also has .exe suffix).

## Roadmap

In no particular order:

- make the config configurable by end users (so they can override
  particular entries and use alternate sources/versions/etc.);
- ensure it runs well on all of {Linux,MacOS,Windows};
- integration tests.
