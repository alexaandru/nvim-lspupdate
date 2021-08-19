.DEFAULT_GOAL := test

test:
	@export tst=/tmp/lspupdate_test.txt && \
		nvim --headless +"packadd hotpot" +"exe 'lua require \"test.util\"' | exe 'lua require \"test.github\"'" +q 2> $$tst && \
		[ ! -s $$tst ] && echo Tests passed\! || (cat $$tst; exit 101)
lspconfig_check:
	@./lspconfig.sh

fennel:
	@gunzip --stdout fennel.gz > fennel
	@chmod a+rx fennel

lua: clean fennel 
	@mkdir -p lua/lspupdate
	@for i in fnl/lspupdate/*; do lua fennel --compile $$i > lua/lspupdate/$$(basename $$i .fnl).lua; done

clean:
	@rm -rf lua fennel

.PHONY: test lua fennel
