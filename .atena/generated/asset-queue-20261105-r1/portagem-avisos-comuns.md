# Registro de portagem: avisos dos comuns (T20, T21, T22), 2026-11-05

Estado: **PORTAGEM PENDENTE (origem inacessível).** A origem (`D:/dev/nottgard/games/godot/nottgard-survivors`, HEAD de referência `b83f188a6dae9d32f78420a318bffedcac4ff4a3` em `.atena/add.yaml`) não existe nesta máquina em 2026-11-05 (`ls` falha; mesma situação de `codex-lore-20261027-r1/portagem-S-C08.md`). Este documento lista o que é comum às duas versões, para a portagem e os checks serem feitos onde a origem estiver. Sem sincronização automática (AGENTS.md); nada foi copiado para a origem.

Commits desta versão: `4356e20` (código, folhas, teste), `84b9cca` (plano, guia, capturas) e o ajuste da investida (só feixe, sem setas).

## Arquivos comuns a portar

| Arquivo | Tipo | O que muda | sha256 (16 primeiros) |
|---|---|---|---|
| `assets/vfx/aviso_comum_faixa.png` | novo | T20, 6 quadros 1536×256, branco neutro, brilho no alfa | `f34b35b6ceb10b27` |
| `assets/vfx/aviso_comum_mira.png` | novo | T21, 6 quadros 1536×256 | `e40140da98ed6813` |
| `assets/vfx/aviso_comum_area.png` | novo | T22, 4 quadros 1024×256 | `e219f3f34fc9eb7f` |
| `assets/vfx/aviso_comum_*.png.import` | novo | gerar por `--headless --editor --import` em perfil isolado (parâmetros iguais aos de `boss_varredura_aviso.png.import`) | não copiar às cegas |
| `ui/telegraph_art.gd` (+ `.uid` gerado) | novo | nó aditivo, funções puras, fila de comandos | `302d6f55b314d100` |
| `ui/overlay.gd` | alterado | **só os trechos do patch** `portagem-overlay.patch` (`_draw`, `_art`, `_telegraph_art`, `_draw_zones`, `_draw_lane_art`, `_draw_telegraph`, `_draw_charge_lane`, `_draw_aim_beam`); o arquivo inteiro pode diferir da origem (hash do arquivo aqui: `8dcbd853f0c4fa60`, só para conferência se forem idênticos) | ver patch |
| `tests/test_telegraph_comuns_art.gd` (+ `.uid`) | novo | folhas, quadro congelado, fatias, fallback, nó aditivo, camadas | `6d68fbdce7391096` |
| `tools/telegraph_comuns_capture.gd` (+ `.uid`) | novo (opcional) | captura em jogo em perfil sintético | `413b8d0dda3b2390` |
| `tools/telegraph_prep_comuns.gd`, `tools/telegraph_preview_comuns.gd`, `tools/asset_jobs/telegraph_comum_v01.json` | novos (opcionais) | preparação e prévias das folhas | `07132c51ac6e534a`, `06c99669424307ba`, `c2701a52fb616724` |

O patch está em `.atena/generated/asset-queue-20261105-r1/portagem-overlay.patch` (diff de `ui/overlay.gd` de `4356e20^` até o commit do ajuste da investida, 117 linhas).

## O que a origem precisa ter (pré-condições)

- `VfxAtlas.texture(path, cells)` (devolve nulo se o arquivo falta ou o tamanho não bate) e `VfxAtlas.smooth(node)`, em `core/vfx_atlas.gd`.
- `Iso.to_screen` com projeção linear 2:1 (TILE_W 64, TILE_H 32).
- `Game.reduced_impact()`.
- No Overlay: instâncias com `mode` "under", "over" e "text"; `_warn(dtype)` devolvendo `{main, hot}` (com `main` seguindo o modo de daltonismo); `HERO_LANE_PAD`; `_allow_large_fx`; `_draw_zones`, `_draw_telegraph`, `_draw_charge_lane`, `_draw_aim_beam`.
- Em `Enemy`: `windup`, `windup_total`, `charge_dir`, `charge_ab` (com `dist` e `dtype`), `radius`.
- Se algum desses nomes diferir na origem, o patch precisa de adaptação manual (os trechos são pequenos).

## Atenções

- Sem a folha em `assets/vfx/`, cada aviso cai no desenho por código antigo (`TelegraphArt.has_sheet`); então a portagem do overlay sem as folhas não muda o visual.
- Nenhum campo de save, dado de balanceamento ou ID foi alterado.
- A mira e o anel só mudam apresentação; geometria, dano e tempo do golpe ficam em `Battle`.

## Checks para rodar na origem (e aqui, depois da portagem)

Todos com `APPDATA` e `LOCALAPPDATA` sintéticos, nunca o save real:
1. `tools/run_one_test.gd -- test_telegraph_comuns_art`.
2. `tests/run_all.gd` completo e `tools/audit_projeto.gd`.
3. Conferir `sha256` das folhas e de `ui/telegraph_art.gd` contra a tabela (se idênticos, a portagem é cópia fiel).
4. Opcional: `tools/telegraph_comuns_capture.gd` e comparar com `integration/`.

Resultado nesta versão (2026-11-05): teste novo 0 falhas; `run_all` 0 falhas; auditoria 0 erros e 0 avisos; 11 capturas em `integration/`.

## Pendência registrada

`source_port_parity: PENDING_SOURCE_PROJECT_NOT_ACCESSIBLE_FROM_THIS_SESSION`. Quando a origem estiver acessível, uma sessão com acesso a ela aplica esta lista, roda os checks e registra o resultado aqui.
