.DEFAULT_GOAL := test

check:
	@luacheck --globals vim -- lua

test: check
	@export tst=/tmp/lspupdate_test.txt && \
		nvim --headless +'luafile lua/test/util.lua' +q 2> $$tst && \
		[ ! -s $$tst ] && echo Tests passed\! || (cat $$tst; exit 101)
lspconfig_check:
	@./lspconfig.sh

.PHONY: test
