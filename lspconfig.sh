#!/bin/bash

LSPCONFIG=${LSPCONFIG:-~/.config/nvim/pack/plugins/start/nvim-lspconfig}
NEWCFG=$(comm -3 <(grep -o -P '^- \[(\K.*)\]\(.*\)$' ${LSPCONFIG}/doc/server_configurations.md|cut -f1 -d]|sort) \
        <(sed -n '/local config/,/})$/p' fnl/lspupdate/config.fnl|cut -f8 -d" "|grep ^:|cut -f2 -d:|sort))

[ -z "${NEWCFG}" ] && echo All good, we''re up to date\! || \
       echo -e "New LSP configs:\n${NEWCFG}"
