#!/bin/bash
# vypise duplicity spolu s okrsky
tmp1=$(mktemp)
tmp2=$(mktemp)
trap 'rm -rf $tmp1, $tmp2' EXIT

# dos2unix
dos2unix $1
# swap numbers and streets
sed -r -e "s/([0-9]+)\,(.*)$/\2,\1/" $1 >$tmp1
# sort by street
sort $tmp1 >$tmp2
# extract dupicities
sed -r -e "s/(.*),([0-9]+)/\2 \1/" $tmp2|uniq -f 1 -D
