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
sed -r -e "s/(.*),([0-9]+)/\2 \1/" $tmp2|uniq -f 1 -D >$tmp1
sed -r -e "s/([0-9]+) (.*)$/\2,\1/" $tmp1 >$tmp2
# to one line
IFS=,
prev=""
out=""
echo "" > $tmp1
cat $tmp2 \
| while read ul ok
do
    if [ "$prev" = "$ul" ]
    then
        out="${out}, ${ok}"
    else
        printf "%s\n" "$out" >> $tmp1
        prev="$ul"
        out="${ul} $ok"
    fi
done
# rm first 2 lines, empty
sed -e "1,2d" $tmp1
