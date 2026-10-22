#!/usr/bin/env bash
# Pós-correção dos covils (C1/C2): Goranthis nível 38 + 3 itens (como h-*) e Shedaklah nível 1 (como bal22*).
cd /f/dev/abyss-megadungeon/.atena/generated/balance-bots-20261018
for h in brook durvall kayron korrak maelor sylas; do for p in smart-god smart; do
  echo "j-$p-goranthis-$h $p $h goranthis 1,2 0.0166667 38 3 none"
  echo "j-$p-shedaklah-$h $p $h shedaklah 1,2 0.0166667 1 3 none"; done; done \
 | xargs -P 6 -I{} bash -c 'set -- {}; bash run-bot5.sh "$@"' > results/launch-bal22j.log 2>&1
echo ALLDONE >> results/launch-bal22j.log
