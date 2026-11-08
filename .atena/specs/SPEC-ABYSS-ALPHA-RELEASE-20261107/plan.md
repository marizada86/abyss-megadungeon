---
id: "PLAN-ABYSS-ALPHA-RELEASE-20261107"
spec_id: "SPEC-ABYSS-ALPHA-RELEASE-20261107"
status: "completed"
approval:
  mode: "per-plan"
---

# Plan of flight — SPEC-ABYSS-ALPHA-RELEASE-20261107

## Plan mode

- Origin: `planned`
- Reconstruction: `false`

## Recommended approach

Primeiro verificar o git, depois commitar tudo, depois compactar; só então mexer na versão e validar. Merge, push e build ficam como portões.

## Reuse

`tools/validate_release.sh`, `tools/stamp_build.ps1`, rascunho `ALPHA-DISTRIBUICAO-RASCUNHO-20261107-r1.md`.

## Implementation sequence

1. `S-001` — Estado e plano do alpha registrados.
2. `S-002` — `git fsck --full` limpo.
3. `S-003` — Commits temáticos de capturas, referências e itens soltos.
4. `S-004` — `git gc` e conferência do lixo.
5. `S-005` — Versão 0.6.0 e textos de distribuição.
6. `S-006` — Decisão da portagem registrada no plano legado.
7. `S-007` — Gate de release e preparo do build (sem gerar).

## Approval checkpoints

- `per-plan` — um checkpoint `PLAN` cobre as sete etapas; merge, push e build ficam fora.

```yaml
mode: "per-plan"
checkpoints:
  - id: "PLAN"
    status: approved
```

## Expected changes

- `core/version.gd`, `export_presets.cfg`, `.atena/state/plan.yaml`, `.atena/vault/drafts/`, `.git/` (gc).

## Validation

- `bash tools/validate_release.sh` — `RELEASE-GATES: PASS`.
- `git fsck --full`, `git count-objects -vH` — sem erro e sem lixo.

## Limits

- Max retries: 3

## Recovery

Commits locais reversíveis com `git reset` (só com aprovação). A versão volta editando duas linhas. O gc só roda com fsck limpo.

## Mandatory gates

- Merge em `main`, push, tag, build e envio a testadores exigem sim explícito.

## Approval record

```yaml
mode: "per-plan"
checkpoints:
  - id: "PLAN"
    status: approved
    approved_at: "2026-11-07T22:26:34-03:00"
    approved_by: "owner"
    scope_revision: 1
```

## Step progress and prepared handoff

Revision: 1.

| Step | Objective | Inputs | Deliverable | Actions/checks | Checkpoint/status |
| --- | --- | --- | --- | --- | --- |
| S-001 | Registrar plano | templates | spec, plano, estado | validador | PLAN approved |
| S-002 | fsck limpo | git | log | exit 0 | PLAN approved |
| S-003 | Commits | status | commits | git log | PLAN approved |
| S-004 | gc | fsck limpo | pack limpo | count-objects | PLAN approved |
| S-005 | Versão | contrato | 0.6.0 | test_version_contract | PLAN approved |
| S-006 | Portagem | plan.yaml | registro | diff | PLAN approved |
| S-007 | Validar | gate | PASS | validate_release | PLAN approved |
