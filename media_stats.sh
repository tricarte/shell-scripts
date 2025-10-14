#!/usr/bin/env bash

rfiles=$(fd mp4 /media --exclude '*cc_*' --exclude 'cpvf' | wc -l)
hfiles=$(fd ^cc_ /media | wc -l)
pfiles=$(fd -e mp4 -p 'cpvf' /media | wc -l)

printf "Number of hash files: %d\n" "$hfiles"
printf "Number of regular files: %d\n" "$rfiles"
printf "Total: %d\n" "$((hfiles + rfiles))"
printf "Number of cpvf files: %d\n" "$pfiles"
printf "Total number of files: %d\n" "$((hfiles + rfiles + pfiles))"
