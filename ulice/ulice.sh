#!/bin/bash
# vypise duplicity spolu s okrsky
tmp1=$(mktemp)
tmp2=$(mktemp)
trap 'rm -rf $tmp1, $tmp2' EXIT

# dos2unix, rm CRLF
dos2unix $1
# sort by street
sort -t, -k2 $1 >$tmp2
# extract dupicities
sed -r -e "s/,/ /" $tmp2|uniq -f 1 -D >$tmp1
# to one line
IFS=" "
prev=""
out=""
echo "" > $tmp2 #erase tmp
cat $tmp1 \
| while read ok ul
do
    if [ "$prev" = "$ul" ]
    then
        out="${out},${ok}"
    else
        printf "%s\n" "$out" >> $tmp2
        prev="$ul"
        out="${ul} $ok"
    fi
done
# rm first 2 lines, empty
sed -e "1,2d" $tmp2
