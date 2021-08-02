.DEFAULT_GOAL := test

test:
	@export tst=/tmp/lspupdate_test.txt && \
		nvim --headless +"packadd hotpot" +"exe 'lua require \"test.util\"' | exe 'lua require \"test.github\"'" +q 2> $$tst && \
		[ ! -s $$tst ] && echo Tests passed\! || (cat $$tst; exit 101)
lspconfig_check:
	@./lspconfig.sh

.PHONY: test
