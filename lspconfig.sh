#!/bin/bash

LSPCONFIG=${LSPCONFIG:-~/.config/nvim/pack/plugins/opt/nvim-lspconfig}
NEWCFG=$(comm -3 <(grep -o -P '^- \[(\K.*)\]\(.*\)$' ${LSPCONFIG}/CONFIG.md |cut -f1 -d]|sort) \
        <(sed -n '/^config.config/,/^}$/p' lua/lspupdate/config.lua|sed '1d;$d'|cut -f1 -d=|tr -d ' '|sort))

[ -z "${NEWCFG}" ] && echo All good, we''re up to date\! || \
       echo -e "New LSP configs:\n${NEWCFG}"
