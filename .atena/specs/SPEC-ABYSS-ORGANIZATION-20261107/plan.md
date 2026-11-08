---
id: "PLAN-ABYSS-ORGANIZATION-20261107"
spec_id: "SPEC-ABYSS-ORGANIZATION-20261107"
status: "completed"
approval:
  mode: "per-plan"
---

# Plan of flight — SPEC-ABYSS-ORGANIZATION-20261107

## Plan mode

- Origin: `planned`
- Reconstruction: `false`

## Recommended approach

Menor conjunto suficiente: registrar o plano no formato 0.5.0, revalidar o que existe, tornar o repositório mais limpo sem apagar nada e preparar (não executar) o alpha.

## Reuse

`tools/validate_release.sh`, o validador `validate-add-state.cjs` da metodologia, o checkup `ALPHA-CHECKUP-20261104-r1.md` e `ALPHA-POLISH-RECOMENDACOES-20261104-r1.md`.

## Implementation sequence

1. `S-001` — Spec, plano e estado por conversa válidos no formato 0.5.0.
2. `S-002` — Higiene sem exclusão: `.gitignore`, README, ruído de testes.
3. `S-003` — Rascunho dos textos de distribuição e proposta de versão do alpha.
4. `S-004` — Validação final (gate de release e validador Atena) e registro de evidência.
5. `S-005` — Arquivar as cinco sessões do projeto (exceto áudio) e fechar o estado.

## Approval checkpoints

- `per-plan` — um checkpoint `PLAN` cobre as cinco etapas.

```yaml
mode: "per-plan"
checkpoints:
  - id: "PLAN"
    status: approved
```

## Expected changes

- `.atena/specs/SPEC-ABYSS-ORGANIZATION-20261107/*`, `.atena/state/conversations/abyss-organizacao-alpha-20261107/plan.yaml`
- `.gitignore`, `README.md`
- `.atena/vault/drafts/ALPHA-DISTRIBUICAO-RASCUNHO-20261107-r1.md`
- `.atena/evidence/EVID-ABYSS-ORGANIZATION-20261107-r1.md`

## Validation

- `node .atena/methodology/0.5.0/tools/validate-add-state.cjs --conversation abyss-organizacao-alpha-20261107 --require-executable` — estado executável.
- `bash tools/validate_release.sh` — `RELEASE-GATES: PASS` ou falha com saída real.

## Limits

- Max retries: 3
- Changed-file budget: ~10 arquivos
- Cost/time constraints: gate completo leva alguns minutos; roda em segundo plano.

## Recovery

Tudo é aditivo ou edição pequena de texto. `git diff` mostra cada alteração; reverter com `git checkout -- <arquivo>` (apenas com aprovação do dono) ou apagando os arquivos novos listados acima.

## Mandatory gates

- Commit, push, merge, tag, build, publicação, `git gc`, exclusão de arquivos e escolha de versão exigem aprovação separada.

## Approval record

```yaml
mode: "per-plan"
checkpoints:
  - id: "PLAN"
    status: approved
    approved_at: "2026-11-07T22:02:33-03:00"
    approved_by: "owner"
    scope_revision: 1
```

## Step progress and prepared handoff

Revision: 1.

| Step | Objective | Inputs | Deliverable | Actions/checks | Checkpoint/status |
| --- | --- | --- | --- | --- | --- |
| S-001 | Registrar plano 0.5.0 | templates 0.5.0 | spec, plano, estado | validador `--conversation` | PLAN approved |
| S-002 | Higiene sem exclusão | git status, README | `.gitignore`, README | `git diff` | PLAN approved |
| S-003 | Rascunho do alpha | checkup 04/11 | rascunho DRAFT | revisão do dono | PLAN approved |
| S-004 | Validar | gate, validador | evidência | saídas reais | PLAN approved |
| S-005 | Arquivar sessões | lista de sessões | cinco arquivadas | `list_sessions` | PLAN approved |
