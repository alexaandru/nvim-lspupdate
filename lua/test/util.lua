require "test"("lspupdate/util", {
  lspVal = {
    {args = {""}, exp = {""}},
    {args = {"foo|"}, exp = {""}},
    {args = {"foo|pack1"}, exp = {"pack1"}},
    {args = {"foo|pack1,pack2,pack3"}, exp = {"pack1", "pack2", "pack3"}},
  },
  flatten = {
    {args = {{}}, exp = ""},
    {args = {{"foo"}}, exp = "foo"},
    {args = {{"foo", "bar"}}, exp = "foo bar"},
    {args = {{"foo", "bar"}, "^"}, exp = "foo^bar"},
    {args = {{"foo", {"bar", "baz"}}, " "}, exp = "foo bar baz"},
  },
  osCapture = {
    {args = {"echo hello world"}, exp = "hello world"},
    {args = {"bash -c 'echo $[2+2]'"}, exp = "4"},
  },
  esc = {
    {args = {""}, exp = ""},
    {args = {"foo"}, exp = "foo"},
    {args = {"foo'bar"}, exp = "foo''bar"},
    {args = {"'foo'bar''"}, exp = "''foo''bar''''"},
  },
})
