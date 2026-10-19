#!/usr/bin/env bash
# Gates de release sem Python (espelho de validate_release.py --full): sessão sintética isolada, importação,
# suíte inteira (0 falhas e 0 SCRIPT ERROR) e auditoria do projeto (0 erros). Nunca usa o perfil real.
# Uso: bash tools/validate_release.sh [--quick]   (--quick pula a suíte inteira e roda só o contrato de versão/plataforma)
# Godot: NOTTGARD_GODOT, senão Godot_v4.7.2-stable_win64.exe na raiz do projeto.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GODOT="${NOTTGARD_GODOT:-$ROOT/Godot_v4.7.2-stable_win64.exe}"
[ -f "$GODOT" ] || { echo "FAIL: Godot não encontrado ($GODOT); defina NOTTGARD_GODOT"; exit 2; }
SESSION="$ROOT/tmp/release-validation-$(date -u +%Y%m%d-%H%M%S)"
mkdir -p "$SESSION/appdata" "$SESSION/localappdata" "$SESSION/userprofile" "$SESSION/probe"
export APPDATA="$(cygpath -w "$SESSION/appdata")" LOCALAPPDATA="$(cygpath -w "$SESSION/localappdata")" USERPROFILE="$(cygpath -w "$SESSION/userprofile")"
CUSTOM="$(grep -m1 '^config/custom_user_dir_name=' "$ROOT/project.godot" | sed 's/.*="\(.*\)"/\1/')"
printf 'config_version=5\n[application]\nconfig/name="ReleaseIsolationProbe"\nconfig/use_custom_user_dir=true\nconfig/custom_user_dir_name="%s"\n' "$CUSTOM" > "$SESSION/probe/project.godot"
printf 'extends SceneTree\nfunc _init() -> void:\n\tprint("ISOLATED_USER_DIR=" + OS.get_user_data_dir())\n\tquit()\n' > "$SESSION/probe/probe.gd"
run() { # nome args...
  local name="$1"; shift
  "$GODOT" "$@" > "$SESSION/$name.log" 2>&1 < /dev/null
  return $?
}
fail=0
run probe --headless --path "$(cygpath -w "$SESSION/probe")" -s probe.gd
USERDIR="$(grep -o 'ISOLATED_USER_DIR=.*' "$SESSION/probe.log" | head -1 | cut -d= -f2- | tr -d '\r' | tr '\\' '/')"
SESS_W="$(cygpath -m "$SESSION")"
case "$USERDIR" in "$SESS_W"/*) echo "PASS: diretório de usuário sintético verificado";; *) echo "FAIL: isolamento ($USERDIR)"; exit 2;; esac
run import --headless --editor --import --path "$(cygpath -w "$ROOT")"
if grep -qE 'SCRIPT ERROR:|Parse Error:' "$SESSION/import.log"; then echo "FAIL: importação"; tail -20 "$SESSION/import.log"; exit 1; fi
echo "PASS: importação Godot"
one() { # teste
  run "t-$1" --headless --quit-after 2400 --path "$(cygpath -w "$ROOT")" -s tools/run_one_test.gd -- "$1"
  if grep -q "$1: 0 falha" "$SESSION/t-$1.log" && ! grep -qE 'SCRIPT ERROR:|Parse Error:|FALHA ' "$SESSION/t-$1.log"; then echo "$1: PASS"; else echo "$1: FAIL"; tail -15 "$SESSION/t-$1.log"; fail=1; fi
}
one test_version_contract
one test_platform_contract
one test_stage_deferrals
one test_save_upgrade_050
if [ "${1:-}" != "--quick" ]; then
  run suite --headless --path "$(cygpath -w "$ROOT")" -s tests/run_all.gd
  if grep -q '^testes: 0 falha(s)' "$SESSION/suite.log" && ! grep -qE 'SCRIPT ERROR:|Parse Error:|^FALHA ' "$SESSION/suite.log"; then echo "suite: PASS"; else echo "suite: FAIL"; grep -E '^testes:|^FALHA|SCRIPT ERROR' "$SESSION/suite.log" | head -20; fail=1; fi
  run audit --headless --path "$(cygpath -w "$ROOT")" -s tools/audit_projeto.gd
  if grep -q '^RESUMO;erros=0;' "$SESSION/audit.log"; then echo "audit_projeto: PASS ($(grep -o '^RESUMO.*' "$SESSION/audit.log" | tr -d '\r'))"; else echo "audit_projeto: FAIL"; grep -E '^ERRO|^RESUMO' "$SESSION/audit.log" | head; fail=1; fi
fi
echo "SESSION=$SESSION"
[ $fail -eq 0 ] && echo "RELEASE-GATES: PASS" || echo "RELEASE-GATES: FAIL"
exit $fail
