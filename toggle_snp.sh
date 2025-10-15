#!/usr/bin/env -S bash --norc

# KITTY="${HOME}/.local/bin/kitty"
KITTY="$(command -v kitty)"
output=$("${KITTY}" @ --to unix:/tmp/mykitty ls | jq '.[].tabs[] | select(.title=="mysnptab").is_active')

if [[ -z $output ]]; then
  "${KITTY}" @ --to unix:/tmp/mykitty launch --type=tab \
    --tab-title=mysnptab --copy-env bash --norc -c '"${HOME}/bin/snp"'
  # --tab-title=mysnptab bash --norc -c 'PERL5LIB=${HOME}/perl5/lib/perl5 "${HOME}/bin/snp"'
  # --tab-title=mysnptab --copy-env bash --norc -c 'PERL5LIB=${HOME}/perl5/lib/perl5 "${HOME}/bin/snp"'
else
  if [[ $output == 'true' ]]; then
    "${KITTY}" @ --to unix:/tmp/mykitty focus-tab -m recent:1
  else
    "${KITTY}" @ --to unix:/tmp/mykitty focus-tab -m title:mysnptab
  fi
fi
