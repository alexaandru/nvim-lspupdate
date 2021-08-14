# Config

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

Similarly, you can amend the `nosquash`, `config` and `tools` tables,
see their comments for what each do. It's not recommended to fiddle with them
though, unless you know what you are doing.

I.e. if you want to pin a specific version of a LSP, you can do (in init.lua):

```Lua
vim.g.lspupdate_config = {gopls = "go|golang.org/x/tools/gopls@v0.7.1"}
```

## Advanced

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
