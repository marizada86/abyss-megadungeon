#!/usr/bin/env bash
# Uso: run-bot.sh <nome-saida> <policy> <heroes> <stages> <seeds> [dt]
# Perfil/APPDATA sintético isolado em tmp/balance-bots/<nome>; nenhum save real é tocado.
set -u
ROOT="${BOT_ROOT:-/f/dev/abyss-megadungeon}"
DEST="/f/dev/abyss-megadungeon/.atena/generated/balance-bots-20261018/results"
OUT="$DEST"
ISO="/f/dev/abyss-megadungeon/tmp/balance-bots/$1"
mkdir -p "$OUT" "$ISO/appdata" "$ISO/local" "$ISO/profile"
export APPDATA="$(cygpath -w "$ISO/appdata")" LOCALAPPDATA="$(cygpath -w "$ISO/local")" USERPROFILE="$(cygpath -w "$ISO/profile")"
cd "$ROOT"
./Godot_v4.7.2-stable_win64.exe --headless --path . \
  --script res://.atena/generated/balance-bots-20261018/bot.gd -- \
  --out "$(cygpath -w "$OUT/$1.jsonl")" --policy "$2" --heroes "$3" --stages "$4" --seeds "$5" --dt "${6:-0.0166667}" \
  > "$OUT/$1.log" 2>&1 < /dev/null
echo "fim $1 exit=$?"
