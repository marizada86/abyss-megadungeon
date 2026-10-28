# S-C08 · registro de portagem do Códex (PLAN-ABYSS-CODEX-LORE-20261027)

Estado: **PORTAGEM PENDENTE.** A origem (`D:/dev/nottgard/games/godot/nottgard-survivors`, HEAD de referência `b83f188a6dae9d32f78420a318bffedcac4ff4a3` em `.atena/add.yaml`) não existe nesta máquina em 2026-10-27 (`ls` falha). Este documento registra o que é comum às duas versões, para a portagem e os checks serem feitos onde a origem estiver. Sem sincronização automática (AGENTS.md); nada foi copiado, commitado ou publicado.

## Arquivos comuns a portar

| Arquivo | Tipo | O que muda | sha256 (16 primeiros) |
|---|---|---|---|
| `data/codex_lore.json` | novo | textos do Códex: `heroes` (12), `enemies` (52 inimigos e 12 quebráveis), `items` (25 únicos), `weapons` (17 entradas; 9 por `igual_a`) | `aa62f461e6b9b0ed` |
| `core/catalog.gd` | alterado | `QUARTEL_CATEGORIES`, `LABELS.heroes`, `detail(..., profile = null)` para inimigos, armas e itens, `hero_*`, `enemy_*`, `item_lore`, `resist_text` | `aaa2cb45f1f2afdb` |
| `ui/menu.gd` | alterado | categoria Personagens no seletor, `CodexArt`, `CodexGallery`, `_open_hq` compartilhado com o Diário, foco de controle | `3da568ee4094a5c6` |
| `ui/menu.tscn` | alterado | Códex: `Details` (HBox) com `CodexText` e `Side` (`CodexArt`, `CodexGallery`) | `57faac5a074f2644` |
| `tests/test_codex_lore.gd` | novo | cobertura total, `req`, `onde` contra `stages.json`, termos proibidos, gating, W-2 e W-3 | `183dee1d3a7745a4` |
| `tests/test_codex_quartel.gd` | novo | aba Personagens: lista, arte, texto, galeria, bloqueado sem vazamento | `89141d602fd14f1b` |
| `tests/test_quartel.gd` | alterado (1 linha) | `Catalog.detail("enemies", "zumbi", true, Game.profile)` | `08d4062c34935196` |
| `tools/codex_capture.gd` (opcional) | novo | capturas do Códex em perfil sintético | `994f72c0515daa18` |

Fora desta portagem (outras frentes, mudanças do working tree que não são do Códex): `ui/run.gd`, `.atena/generated/controller-experience/v01/unit-profile.json.bak`, os `.uid` de testes e ferramentas de outras frentes. `tools/codex_render.ps1` não roda com a política de execução desta máquina e não precisa ir.

## O que a origem precisa ter (pré-condições)

- Dados: `heroes.json` (12 ids), `hero_bios.json`, `hqs.json` (ids `hqn_01` a `hqn_21` com `title` e `panels[].image`), `stages.json` (campos `boss`, waves e elites), `enemies.json`, `weapons.json`, `items.json` (`uniques`), `achievements.json` (`bio_<id>` e desbloqueios de herói).
- Perfil: `hero_unlocked`, `hero_bio_unlocked`, `data.hqs_seen`, `data.stats.boss_kills` (já existem no jogo; **nenhum campo de save foi criado nem alterado**).
- Arte: `assets/icons/codex/herois.png`, `assets/portraits/<id>.png`, `assets/enemies/<id>.png`, imagens de HQ.
- Se a origem tiver textos diferentes nos dados (por exemplo a nota do Zumbi ou nomes de itens), o `quem` do Códex substitui a `note` só no Quartel; a pausa continua com a `note`.

## Atenções de compatibilidade

- `Catalog.detail` ganhou um 4º parâmetro opcional; chamadas antigas continuam valendo.
- `resist_text` muda o texto de "Resistências" também na pausa (era um dicionário cru).
- `Catalog.CATEGORIES` não mudou (a pausa segue com 3 categorias).
- Nomes trocados que seguem o Vault: o item `martelo_da_gloria` aparece como "Martelo da Luz" e a arma `martelo_da_luz` como "Martelo da Glória".
- Divergências deliberadas jogo × Vault, escritas como curiosidade: Zuggtmoy (aliada na mesa), Shu e Ezro (Vila das Sombras), Guardião do Paraíso, Colar dos Tentáculos fundido ao Olho de Ghaunadaur, nome Nidhogg.

## Checks para rodar na origem (e aqui, depois da portagem)

Todos com `APPDATA` e `LOCALAPPDATA` sintéticos, nunca o save real:
1. `tools/run_one_test.gd -- test_codex_lore`, `test_catalog`, `test_quartel`, `test_codex_quartel`, `test_pause_menu`.
2. `tests/run_all.gd` completo e `tools/audit_projeto.gd`.
3. Conferir `sha256` dos arquivos portados contra a tabela acima (se forem idênticos, a portagem é cópia fiel).

Resultado nesta versão (2026-10-27): os cinco testes, `run_all` e a auditoria passaram (0 falhas, 0 erros, 0 avisos); 90 capturas em `captures/` aceitas pelo dono.

## Pendência registrada

`source_port_parity: PENDING_SOURCE_PROJECT_NOT_ACCESSIBLE_FROM_THIS_SESSION`. Quando a origem estiver acessível, uma sessão com acesso a ela aplica esta lista, roda os checks e registra o resultado aqui.
