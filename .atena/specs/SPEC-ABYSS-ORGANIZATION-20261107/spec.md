---
id: "SPEC-ABYSS-ORGANIZATION-20261107"
title: "Organização do projeto sob Atena 0.5.0 e preparo do alpha demo"
status: "completed"
origin: "planned"
implementation_preceded_spec: false
created: "2026-11-07"
canonical_refs: []
---

# Organização do projeto sob Atena 0.5.0 e preparo do alpha demo

## Objective

Deixar o repositório coerente com a Atena 0.5.0 (estado por conversa, validador aceitando o estado, instruções sem conflito), fechar as sessões abertas deste projeto sem perder pendências e preparar, sem executar, os insumos do alpha demo (rascunho dos textos de distribuição e proposta de versão), conforme o roteiro de `.atena/vault/drafts/ALPHA-CHECKUP-20261104-r1.md` seção 6.

## Context and evidence

- `.atena/installation.json`: Atena 0.5.0 adotada; `clientRecognition: unverified`, `agentRuntime: not-installed`.
- `.atena/state/conversations/` existia vazio; `.atena/state/plan.yaml` (legado, ~3 560 linhas) não é lido pelo validador 0.5.0 (falha em escalar com aspas simples e mapas inline).
- Sessões abertas neste projeto: seis; "Alternativas de áudio" aguarda escuta do dono; "Análise dos ZIP" deixou `core/sfx.gd` sem confirmação.
- `core/version.gd` e `export_presets.cfg` estão em 0.5.2; a árvore já tem muito mais que a 0.5.2.
- `git count-objects`: 15 itens de lixo (87,5 MiB) de operação interrompida; `git fsck --connectivity-only` sem erro de conectividade.

## Scope

- Spec, plano e estado por conversa válidos para esta organização.
- Higiene do repositório que não apaga dados: `.gitignore`, README, ruído de testes.
- Rascunho (DRAFT) de LEIA-ME/NOTAS e proposta de versão para o alpha.
- Revalidação (gate de release em perfil sintético, validador Atena) e registro de evidência.
- Arquivar as cinco sessões deste projeto, exceto "Alternativas de áudio".

## Non-goals

- Commit, push, merge, tag, build, publicação, `git gc`/`git fsck --prune`: exigem aprovação própria.
- Apagar `tmp/`, `build/`, `evidencias/` ou qualquer arquivo; migrar ou reescrever o `plan.yaml` legado.
- Renomeação por direitos autorais, mudanças de equilíbrio, novas mecânicas.
- Carregar o save real; promover rascunhos a CANON.

## Decisions

| Decision | Choice | Evidence / rationale | Status |
| --- | --- | --- | --- |
| Nível de aprovação | `per-plan` | Resposta do dono no chat em 2026-11-07 | decided |
| Sessões a arquivar | cinco deste projeto, exceto áudio | Resposta do dono no chat em 2026-11-07 | decided |
| Plano legado | preservado, somente leitura | CONTRACT.md: legado nunca é migrado automaticamente | decided |
| Número da versão do alpha | proposta `0.6.0-alpha.1`, não aplicada | Checkup 04/11; exige decisão do dono | open |

## Gaps

### BLOCKING

- None.

### RESOLVABLE

- Número da versão: default de manter 0.5.2 nos arquivos até o dono decidir.
- Conflito no AGENTS.md (referência a `C:/Users/gui-m/.codex/AGENTS.md`, inexistente neste PC): apenas reportar; é instrução do dono.

### DEFERRED

- Escolha das faixas de música (depende de escuta do dono).
- Renomeação por direitos autorais, playtest humano, build de Produção.

## Acceptance criteria

- [ ] `node validate-add-state.cjs --conversation <key> --require-executable` passa antes da execução e o estado final fica consistente.
- [ ] Gate de release (`tools/validate_release.sh`) em perfil sintético: PASS ou falha explicada com evidência.
- [ ] Nenhum arquivo apagado; nenhum commit, push ou build feito.
- [ ] Cinco sessões arquivadas e "Alternativas de áudio" preservada.
- [ ] Rascunhos do alpha em `.atena/vault/drafts/` marcados DRAFT.

## Impact

### Expected files/systems

- `.atena/specs/SPEC-ABYSS-ORGANIZATION-20261107/`, `.atena/state/conversations/<key>/plan.yaml`, `.gitignore`, `README.md`, `.atena/vault/drafts/`, `.atena/evidence/`.

### Canonical impact

- none expected.

## Risks

- Gate pode falhar por vazamentos intermitentes de áudio: registrar saída real, sem esconder.
- Sessões em outros diretórios não são afetadas.

## Post-hoc disclosure

Not applicable.
