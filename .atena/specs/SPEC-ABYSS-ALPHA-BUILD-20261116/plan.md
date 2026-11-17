---
id: "PLAN-ABYSS-ALPHA-BUILD-20261116"
spec_id: "SPEC-ABYSS-ALPHA-BUILD-20261116"
status: "draft"
approval:
  mode: "per-plan"
---

# Plan of flight — SPEC-ABYSS-ALPHA-BUILD-20261116

## Plan mode

- Origin: `planned`
- Reconstruction: `false`

## Recommended approach

Resolver primeiro o que bloqueia (lista de nomes), depois mudar texto, ícone e versão, validar, commitar localmente e só então gerar a build. Merge e push ficam fora.

## Implementation sequence

1. `S-001` — Spec, plano e estado registrados (feito neste rascunho).
2. `S-002` — Renomeação de textos exibidos. Depende de G-001 e G-002.
3. `S-003` — Ícone `destino`: preparar o PNG do dono, integrar em `ui/hud.gd`, importar, capturar a 100% e 150%. Depende de G-005.
4. `S-004` — Versão Alpha (`core/version.gd`, 3 presets, rótulo no menu, teste).
5. `S-005` — LEIA-ME, notas da versão, canal de retorno e limites conhecidos.
6. `S-006` — Gate: suíte, auditoria, `controller_check`, `validate_release.sh`, varredura de nomes.
7. `S-007` — Commits locais temáticos.
8. `S-008` — Build de Produção (`stamp_build.ps1`), smoke sintético, zip, SHA-256, evidência.
9. `S-009` — Roteiro de playtest humano entregue ao dono (o que testar, critérios, feedback).

## Approval checkpoints

```yaml
mode: "per-plan"
checkpoints:
  - id: "PLAN"
    status: pending   # modo escolhido; só executável com zero BLOCKING (G-001, G-002)
```

## Validation

`bash tools/validate_release.sh` PASS; varredura de termos; smoke do `.exe`; SHA-256.

## Limits

- Max retries: 3. Merge, push, tag e envio exigem sim explícito.

## Recovery

Commits locais reversíveis com aprovação; versão e rótulo voltam editando poucas linhas; build anterior preservada em `build/dist-0.6.0/`.
