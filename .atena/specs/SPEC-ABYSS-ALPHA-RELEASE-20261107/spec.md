---
id: "SPEC-ABYSS-ALPHA-RELEASE-20261107"
title: "Fechamento do repositório e preparo da build alpha 0.6.0"
status: "completed"
origin: "planned"
implementation_preceded_spec: false
created: "2026-11-07"
canonical_refs: []
---

# Fechamento do repositório e preparo da build alpha 0.6.0

## Objective

Entregar ao dono uma árvore limpa e commitada, versão `0.6.0`, repositório git saudável, decisão de portagem registrada e a build de Produção pronta para a playtest do próprio dono, com os portões de merge, push e build tratados à parte.

## Context and evidence

- Resposta do dono (2026-11-07): só a playtest dele nesta etapa; os testadores ficam para depois; lançar o melhor possível. Aprovou o commit de capturas e itens soltos e o `git gc`.
- `ALPHA-DISTRIBUICAO-RASCUNHO-20261107-r1.md`: D1 a D4.
- `tests/test_version_contract.gd` exige `^[0-9]+\.[0-9]+\.[0-9]+$` em `Version.VERSION` e `VERSION.0` nos 6 campos dos presets: um sufixo como `-alpha.1` quebra o contrato.
- `feat/codex-lore` está 33 commits à frente de `main`, que é ancestral dela (fast-forward possível); 4 commits não enviados.

## Scope

- Versão `0.6.0` (core/version.gd e 3 presets) e textos de distribuição para a playtest do dono.
- Commit das capturas e itens soltos; `git fsck` e `git gc`.
- Decisão da portagem dos golpes telegrafados registrada no plano legado.
- Validação (gate de release) e preparo do build de Produção.

## Non-goals

- Merge para `main`, push, tag, publicação, envio a testadores: portões separados.
- Gerar build antes de autorização explícita.
- Mudar equilíbrio de Goranthis/Pilares antes da playtest humana.

## Decisions

| Decision | Choice | Evidence / rationale | Status |
| --- | --- | --- | --- |
| Número da versão | `0.6.0` (alpha é o canal, não o número) | Recomendação `0.6.0-alpha.1` aceita pelo dono; o contrato de versão não admite sufixo | decided |
| Público | só o dono | Resposta do dono | decided |
| Canal de retorno e LEIA-ME de testadores | adiados | Sem testadores nesta etapa | deferred |
| Commit de capturas e soltos | aprovado | Resposta do dono | decided |
| `git gc` | aprovado, após `git fsck --full` limpo | Resposta do dono | decided |
| Portagem dos golpes telegrafados | registrar "não aplicável: origem histórica sem a base" | Recomendação da Atena; o dono pediu para seguir as recomendações | decided |
| Merge, push, build | pendentes de sim explícito | add.yaml e memória do projeto | open |

## Gaps

### BLOCKING

- None.

### RESOLVABLE

- Aviso de nomes provisórios: fica no texto distribuído mesmo só para o dono, por segurança.

### DEFERRED

- Playtest humano, passe com controle físico, varredura de bots pós-evoluções, rebalanceamento de Goranthis e Pilares.

## Acceptance criteria

- [ ] `bash tools/validate_release.sh` PASS com a versão 0.6.0.
- [ ] `git fsck --full` sem erro antes do gc; `git count-objects -v` sem lixo depois, ou lixo restante explicado.
- [ ] Árvore sem pendências rastreadas além do que o dono quiser deixar.
- [ ] Nenhum push, merge, tag ou build sem sim explícito.

## Impact

### Expected files/systems

- `core/version.gd`, `export_presets.cfg`, `.git/`, `.atena/state/plan.yaml`, `.atena/vault/drafts/`, `.atena/specs/`, `.atena/state/conversations/`.

### Canonical impact

- none expected.

## Risks

- `git gc` reescreve 1,5 GB de packs: só roda com `fsck` limpo e disco livre (235 GB).
- A mudança de versão afeta a leitura de saves antigos: conferir `test_save_upgrade_050`.

## Post-hoc disclosure

Not applicable.
