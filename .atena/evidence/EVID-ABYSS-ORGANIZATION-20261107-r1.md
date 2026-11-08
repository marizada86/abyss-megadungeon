# EVID-ABYSS-ORGANIZATION-20261107-r1

Estado: DRAFT. Spec `SPEC-ABYSS-ORGANIZATION-20261107`, plano `PLAN-ABYSS-ORGANIZATION-20261107` (per-plan, aprovado pelo dono no chat em 2026-11-07).

## Estado Atena 0.5.0
- Validador `validate-add-state.cjs` no `plan.yaml` legado: falha com "Unsupported YAML scalar" (aspas simples e mapas inline). O legado continua legível por humanos e não foi alterado nem migrado (CONTRACT.md).
- Estado por conversa criado em `.atena/state/conversations/abyss-organizacao-alpha-20261107/plan.yaml`. Validador com `--conversation ... --require-executable`: `valid: true`, `executionReady: true`, `binding: matched`.

## Gate de release (perfil sintético isolado, save real não carregado)
- `bash tools/validate_release.sh`, sessão `tmp/release-validation-20261108-010019`: importação, `test_version_contract`, `test_platform_contract`, `test_stage_deferrals`, `test_save_upgrade_050`, suíte (`testes: 0 falha(s)`, 0 SCRIPT ERROR) e `audit_projeto` (`erros=0;avisos=0`): `RELEASE-GATES: PASS`.
- Uma primeira rodada foi interrompida por queda de energia durante a suíte; foi refeita do zero. `git fsck --connectivity-only` depois da queda: sem erro de conectividade.
- Resíduo conhecido: o log da suíte ainda mostra "2 ObjectDB instances were leaked" e "1 resources still in use" no encerramento, igual ao log de 04/11 (anterior à mudança em `core/sfx.gd`). O conserto `_exit_tree` de `core/sfx.gd` (não commitado) portanto **não eliminou** esse aviso; ele não falha o gate. Não é prova de que o conserto seja inútil, só de que não resolve este aviso.

## Alterações desta organização (nenhuma apaga arquivo)
`.gitignore` (+`Godot/`), `README.md` (organização, validação, trechos obsoletos), `.atena/specs/SPEC-ABYSS-ORGANIZATION-20261107/`, estado por conversa, `.atena/vault/drafts/ALPHA-DISTRIBUICAO-RASCUNHO-20261107-r1.md`, esta evidência.

## Conflitos e pendências reportados
- `AGENTS.md` aponta para `C:/Users/gui-m/.codex/AGENTS.md`, que não existe neste PC; é instrução do dono, mantida.
- `.atena/add.yaml` `platform.source` (`D:/dev/nottgard/...`) não existe; a origem histórica está em `F:\dev\nottgard-survivor` (registrado no plano em 2026-11-05).
- `.atena/installation.json`: `clientRecognition: unverified`, `agentRuntime: not-installed`.
- Pendentes com o dono: versão do alpha, canal de retorno, commits temáticos, destino de `feat/codex-lore`, `git gc`, escuta das faixas de música, retroportar ou declarar "não aplicável" a portagem dos golpes telegrafados.
