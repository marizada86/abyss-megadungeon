---
id: "PLAN-ABYSS-ARLINDO-20261108"
spec_id: "SPEC-ABYSS-ARLINDO-20261108"
status: "completed"
approval:
  mode: "per-plan"
---

# Plan of flight — SPEC-ABYSS-ARLINDO-20261108

## Plan mode

- Origin: `planned`
- Reconstruction: `false`

## Recommended approach

Ajuste mínimo em dados, gate de release e varredura dirigida do herói.

## Reuse

`tools/validate_release.sh`, `.atena/generated/balance-bots-20261018/{jobs-a7.txt,launch-a7.sh,aggregate-a7.js}` com código congelado em `tmp/base-a7-20261108`.

## Implementation sequence

1. `S-001` — Editar `data/weapons.json`.
2. `S-002` — Gate de release.
3. `S-003` — Varredura a7 e comparação com a6.

## Approval checkpoints

```yaml
mode: "per-plan"
checkpoints:
  - id: "PLAN"
    status: approved
```

## Expected changes

- `data/weapons.json`; arquivos de varredura a7.

## Validation

- `RELEASE-GATES: PASS`; `results/a7-aggregate.md`.

## Limits

- Max retries: 3

## Recovery

Reverter três linhas em `data/weapons.json` (`git checkout -- data/weapons.json` com aprovação).
