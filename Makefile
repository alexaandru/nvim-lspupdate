.DEFAULT_GOAL := test

check:
	@luacheck --globals vim -- lua

test: check
	@export tst=/tmp/lspupdate_test.txt && \
		nvim --headless +"exe 'luafile lua/test/util.lua' | exe 'luafile lua/test/github.lua'" +q 2> $$tst && \
		[ ! -s $$tst ] && echo Tests passed\! || (cat $$tst; exit 101)
lspconfig_check:
	@./lspconfig.sh

.PHONY: test
