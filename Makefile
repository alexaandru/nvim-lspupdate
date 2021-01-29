test:
	@export tst=/tmp/lspupdate_test.txt && \
		nvim --headless +'luafile lua/lspupdate/util_test.lua' +q 2> $$tst && \
		[ ! -s $$tst ] && echo Tests passed\! || (cat $$tst; exit 101)
