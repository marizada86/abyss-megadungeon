---
id: "SPEC-ABYSS-ALPHA-BUILD-20261116"
title: "Nova build Alpha pública (sem áudio): renomeação, ícone, versão, distribuição e build"
status: "draft"
origin: "planned"
implementation_preceded_spec: false
created: "2026-11-16"
canonical_refs: []
---

# Nova build Alpha pública (sem áudio)

## Objective

Fechar todas as pendências não sonoras e gerar uma nova build de Produção (Windows x86_64), com pacote de distribuição (zip, SHA-256, LEIA-ME, notas), pronta para o dono decidir o envio. Áudio fica fora do escopo.

## Context and evidence

- Pedido do dono (2026-11-16): "nova build, incluindo todas as pendências (exceto áudio)".
- Build anterior: `build/dist-0.6.0/` (commit `841dab2`, 07/11). Desde então: 7 commits locais não enviados (Arlindo em `data/weapons.json`, SFX). `origin/main` e `origin/feat/codex-lore` estão em `f343389`.
- Levantamento de 05/11 (`PROMPTS-ALPHA-PENDENCIAS-20261105-r1.md`): lacunas de Molydeus/ilusões, ícone de Docas, quebráveis e evoluções são falsos positivos ou já integradas. Pendência de arte real: ícone de regra "destino" (Reino Abissal e Domwieck; `ui/hud.gd` `stage_icons`). Durao fica sem ícone de propósito.
- Decisões do dono (2026-11-16): público **aberto**; versão "Alpha" com contagem reiniciada; ícone gerado pelo dono e integrado aqui; aprovação **por plano, sem push**.
- Memória e AGENTS: antes de divulgação pública a renomeação por direitos autorais tem de estar feita; IDs, nome técnico e saves não mudam, só texto exibido.
- `tests/test_version_contract.gd` exige `X.Y.Z` e `X.Y.Z.0` nos 6 campos dos presets; `Version.VERSION` só é logado e gravado em `run_record`, não comparado a saves.

## Scope

- Renomeação de textos exibidos (dados, UI, codex, testes com nome embutido) conforme lista final do dono/Vault.
- Ícone `destino` (Reino Abissal e Domwieck): preparação e integração do PNG do dono.
- Versão Alpha (contagem reiniciada) e rótulo ALPHA no menu.
- LEIA-ME, notas da versão e canal de retorno; aviso de limites conhecidos.
- Gate de release, checagem automática de controle, commits locais, build de Produção, smoke sintético, zip e SHA-256.
- Roteiro de playtest humano para o que só o dono confirma.

## Non-goals

- Áudio de qualquer tipo.
- Merge, push, tag, publicação e envio aos testadores (portões separados).
- Mudar equilíbrio, novas mecânicas, renomear IDs, tocar em saves reais.
- Revelar "cânone do mestre".

## Decisions

| Decision | Choice | Evidence / rationale | Status |
|---|---|---|---|
| Público | aberto | Resposta do dono | decided |
| Ícone destino | dono gera, Claude integra | Sem gerador de imagem na sessão | decided |
| Aprovação | por plano, sem push | Resposta do dono | decided |
| Número da versão | `0.1.0` com canal "Alpha" (contagem reiniciada) | Interpretação de "chamar de Alpha e reiniciar a contagem"; o contrato exige X.Y.Z | proposed, confirmar |

## Gaps

### BLOCKING

- **G-001 Lista final de renomeação.** Não existe no repositório (nem no Vault) a lista antigo→novo. Sem ela a renomeação, e portanto a build pública, não pode ser executada. O checkup lista cerca de 13 termos de terceiros (Zuggtmoy, Juiblex, Ghaunadaur, Malcanthet, Socothbenoth, Molydeus, Blogbog, Graz'zt, Death Tyrant, Arch-hag, Gehenna, Lu Yueh, Nidhogg) mais nomes de evoluções provisórios; quem decide o conjunto é o dono/Vault.
- **G-002 Arte com nome desenhado.** HQs, cartazes e `lettering.json` não foram inspecionados imagem por imagem; se alguma tiver nome desenhado, exige nova geração (fora do alcance desta sessão).

### RESOLVABLE

- G-003 Número exato da versão (`0.1.0` proposto).
- G-004 Canal de retorno dos testadores (texto do LEIA-ME; recomendação: mensagem direta ou formulário simples).
- G-005 PNG do ícone `destino` (prompt pronto no Lote B de 05/11).

### DEFERRED

- Playtest humano: passe com controle físico, voo de `eclipse_evo` e `cajado_realizado_evo`, primeira partida em Docas, Pilares.
- Música e SFX (fora do escopo).

## Acceptance criteria

- [ ] G-001 e G-002 resolvidos e renomeação aplicada; varredura sem termos da lista em texto exibido.
- [ ] `bash tools/validate_release.sh`: `RELEASE-GATES: PASS` com a versão nova.
- [ ] Ícone `destino` visível no HUD de Reino Abissal e Domwieck a 100% e 150%.
- [ ] Build de Produção com carimbo sem `-dirty`, smoke em perfil sintético (saída 0), zip e SHA-256.
- [ ] Nenhum push, merge ou tag sem sim explícito; save real nunca carregado.

## Impact

### Expected files/systems

`data/*.json` (textos), `ui/`, `core/version.gd`, `export_presets.cfg`, `assets/icons/stages/destino.png`, `tests/`, `.atena/`, `build/dist-<versão>/`.

### Canonical impact

none expected; nomes finais vêm do Vault e só se promovem com aprovação do dono.

## Risks

- Renomeação em cerca de 250 ocorrências de testes e muitos dados: risco de quebrar IDs; mitigar alterando só texto exibido e rodando a suíte.
- Reiniciar a versão parece rebaixamento para quem testou 0.5.x ou 0.6.0; documentar nas notas.
- Arte com nome embutido pode forçar nova geração.

## Post-hoc disclosure

Not applicable.
