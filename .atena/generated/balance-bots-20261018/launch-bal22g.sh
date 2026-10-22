#!/usr/bin/env bash
cd /f/dev/abyss-megadungeon/.atena/generated/balance-bots-20261018
while read -r root name pol hero stages seeds; do
  r="${root#BOT_ROOT=}"; echo "$r|$name|$pol|$hero|$stages|$seeds"
done < jobs-bal22g.txt | xargs -P 6 -I{} bash -c 'IFS="|" read -r r n p h s sd <<< "{}"; if [ -n "$r" ]; then export BOT_ROOT="$r"; fi; bash run-bot.sh "$n" "$p" "$h" "$s" "$sd"' > results/launch-bal22g.log 2>&1
echo ALLDONE >> results/launch-bal22g.log
