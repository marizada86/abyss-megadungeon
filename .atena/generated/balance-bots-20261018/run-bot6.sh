#!/usr/bin/env bash
# Uso: run-bot6.sh <nome-saida> <policy> <heroes> <stages> <seeds> [dt] [level] [items] [meta]
# BOT_ROOT aponta a raiz do projeto (dados) a usar; o executável é sempre o da raiz real. Perfil/APPDATA sintético isolado.
set -u
REAL="/f/dev/abyss-megadungeon"
ROOT="${BOT_ROOT:-$REAL}"
OUT="$REAL/.atena/generated/balance-bots-20261018/results"
ISO="$REAL/tmp/balance-bots/$1"
mkdir -p "$OUT" "$ISO/appdata" "$ISO/local" "$ISO/profile"
export APPDATA="$(cygpath -w "$ISO/appdata")" LOCALAPPDATA="$(cygpath -w "$ISO/local")" USERPROFILE="$(cygpath -w "$ISO/profile")"
cd "$ROOT"
"$REAL/Godot_v4.7.2-stable_win64.exe" --headless --path . \
  --script res://.atena/generated/balance-bots-20261018/bot6.gd -- \
  --out "$(cygpath -w "$OUT/$1.jsonl")" --policy "$2" --heroes "$3" --stages "$4" --seeds "$5" --dt "${6:-0.05}" --level "${7:-1}" --items "${8:-3}" --meta "${9:-none}" \
  > "$OUT/$1.log" 2>&1 < /dev/null
echo "fim $1 exit=$?"
