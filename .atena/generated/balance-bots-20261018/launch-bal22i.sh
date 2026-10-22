#!/usr/bin/env bash
cd /f/dev/abyss-megadungeon/.atena/generated/balance-bots-20261018
for h in brook durvall kayron korrak maelor sylas; do for p in smart-god smart; do
  echo "i-meta-$p-$h $p $h pilares 1,2 0.0166667 40 3 full"; done; done \
 | xargs -P 6 -I{} bash -c 'set -- {}; bash run-bot5.sh "$@"' > results/launch-bal22i.log 2>&1
echo ALLDONE >> results/launch-bal22i.log
