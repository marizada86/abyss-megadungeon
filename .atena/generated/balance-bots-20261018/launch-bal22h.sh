#!/usr/bin/env bash
cd /f/dev/abyss-megadungeon/.atena/generated/balance-bots-20261018
while read -r root name pol hero stages seeds dt lvl items; do
  r="${root#BOT_ROOT=}"; echo "$r|$name|$pol|$hero|$stages|$seeds|$dt|$lvl|$items"
done < jobs-bal22h.txt | xargs -P 6 -I{} bash -c 'IFS="|" read -r r n p h s sd dt lv it <<< "{}"; if [ -n "$r" ]; then export BOT_ROOT="$r"; fi; bash run-bot4.sh "$n" "$p" "$h" "$s" "$sd" "$dt" "$lv" "$it"' > results/launch-bal22h.log 2>&1
echo ALLDONE >> results/launch-bal22h.log
