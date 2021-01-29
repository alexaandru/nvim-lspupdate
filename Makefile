test:
	@export tst=/tmp/lspupdate_test.txt && \
		nvim --headless +"set rtp+=${pwd}/lua" +'packadd nvim-lspupdate' +'luafile lua/lspupdate/util_test.lua' +q 2> $$tst && \
		[ ! -s $$tst ] && echo Tests passed\! || (cat $$tst; exit 101)
