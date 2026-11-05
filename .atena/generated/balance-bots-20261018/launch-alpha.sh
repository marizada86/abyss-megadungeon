#!/usr/bin/env bash
cd /f/dev/abyss-megadungeon/.atena/generated/balance-bots-20261018
while read -r root name pol hero stages seeds dt lvl items meta; do
  r="${root#BOT_ROOT=}"; echo "$r|$name|$pol|$hero|$stages|$seeds|$dt|$lvl|$items|$meta"
done < jobs-alpha.txt | xargs -P 5 -I{} bash -c 'IFS="|" read -r r n p h s sd dt lv it mt <<< "{}"; export BOT_ROOT="$r"; bash run-bot6.sh "$n" "$p" "$h" "$s" "$sd" "$dt" "$lv" "$it" "$mt"' > results/launch-alpha.log 2>&1
echo ALLDONE >> results/launch-alpha.log
