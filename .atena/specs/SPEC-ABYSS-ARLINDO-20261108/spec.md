---
id: "SPEC-ABYSS-ARLINDO-20261108"
title: "Melhorar a Memória Alterada de Arlindo"
status: "completed"
origin: "planned"
implementation_preceded_spec: false
created: "2026-11-08"
canonical_refs: []
---

# Melhorar a Memória Alterada de Arlindo

## Objective

Reduzir a fraqueza de Arlindo apontada pelos bots (a6: 28/33 vitórias, 0/3 em Pilares, falhas em Docas e Reino Abissal) sem mudar a identidade de controle da arma.

## Context and evidence

- `BALANCE-BOTS-A6-20261107-r1.md`: Arlindo é o herói mais fraco; a playtest do dono (2026-11-08) aprovou a dificuldade geral, mas o dono pediu melhorar Arlindo.
- Causa: bolt 1d6 de alvo único com recarga 2,2 s e sem perfuração, contra 1,5 s em Maelor e Sylas com o mesmo dado.

## Scope

- `data/weapons.json`: `memoria_alterada` recarga 2,2 → 1,7 s e perfuração 0 → 1; `memoria_reescrita` (evolução) perfuração 0 → 1 para a evolução não perder o que a base ganhou.

## Non-goals

- Habilidade (Q), passiva, atributos e demais heróis; mapas.

## Decisions

| Decision | Choice | Evidence / rationale | Status |
| --- | --- | --- | --- |
| Direção do ajuste | Arma: mais cadência (e perfuração) | Escolha do dono neste chat (2026-11-08), opção recomendada | decided |
| Evolução com perfuração | Incluída | Sem ela, a evolução perderia perfuração em relação à base | decided |

## Gaps

### BLOCKING
- None.
### RESOLVABLE
- None.
### DEFERRED
- Playtest humana do Arlindo; revisão de Nyrelia e Zynara.

## Acceptance criteria

- [x] `bash tools/validate_release.sh`: `RELEASE-GATES: PASS` (2026-11-08).
- [x] Varredura de bots só com Arlindo (a7) sem erro de script e sem piora no total de vitórias (28/33 → 31/33).

## Impact

### Expected files/systems
- `data/weapons.json`.

### Canonical impact
- none expected.

## Risks

- Sobreposição de dano em grupos densos pela perfuração; o ruído da amostra (3 sementes) limita a conclusão em Pilares.

## Post-hoc disclosure

Not applicable.
