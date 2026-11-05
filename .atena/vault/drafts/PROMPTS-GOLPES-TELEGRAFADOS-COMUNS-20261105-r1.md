# Prompts dos golpes telegrafados dos inimigos comuns, 2026-11-05, r1

Status: DRAFT, pedido do dono ("os golpes telegrafados de investida continuam sem asset", depois "incluir mira e área", 2026-11-05). Nenhuma geração, integração, aceite, commit ou publicação autorizados por este rascunho. Checkpoints dos demais planos preservados. Segue o formato de `PROMPTS-GOLPES-TELEGRAFADOS-TEMATICOS-20261104-r1.md` (mesmo preâmbulo de luz aditiva sobre preto puro).

Papéis (plano, 2026-11-04): a Atena gera as imagens; Claude prepara e integra depois do aceite do dono.

## 0. Lacuna

As 22 peles de 2026-11-04 cobrem só **chefes** (`core/boss_vfx.gd`). Os avisos dos inimigos comuns seguem desenhados por código em `ui/overlay.gd`, sem arte:

| Aviso | Quem usa | Função hoje | Medidas do jogo |
|---|---|---|---|
| Faixa de investida | habilidade `charge` (carcereiro de Durao e outros) e o bote `lunge` (`difficulty.json`) | `_draw_charge_lane` ([overlay.gd:599](../../../ui/overlay.gd)) | comprimento 3,0 (bote) a 5,0 tiles; meia largura = raio do inimigo + 0,35; carga de 0,45 a 0,8 s |
| Mira do atirador | habilidade `shoot` com `aim` ligado | `_draw_aim_beam` (overlay.gd:625) | comprimento até 9 tiles; trava 0,4 s antes do tiro |
| Círculo de golpe em área | habilidade `aoe` | `_draw_telegraph` (overlay.gd:340) | raio 1,3 a 2,0 tiles; atraso 0,9 a 1,1 s |

Os três recebem a cor pelo tipo de dano (`DangerFeedback.WARN_COLORS`: físico vermelho, mágico violeta, fogo laranja, radiante dourado) e o modo de daltonismo troca a cor principal. A detonação depois do aviso já tem arte (`detonacao_fisica`, `detonacao_magica`); **só o aviso falta**.

## 1. Decisão de cor (dono confirma ao revisar)

As folhas saem **neutras e prontas para tingir**: luz branco-quente com um leve tom âmbar, sem saturação forte. O jogo tinge cada aviso com a cor do tipo de dano e do daltonismo, como já faz hoje. Se o tingimento ficar lavado em violeta ou radiante, geramos as variantes por tipo (12 imagens no lugar de 3); não gerar antes de ver o resultado.

## 2. Preâmbulo comum (já dentro de cada prompt)

Uso: `stylized-concept`, efeito 2D isométrico dark-fantasy, luz pintada sobre **PRETO PURO #000000** para mistura aditiva, sem contorno escuro, sem cinza nem magenta, sem personagem, cenário, mancha de chão, sombra projetada, texto, número, rótulo, grade, borda, logotipo ou marca d'água.

## T20 — Faixa de investida (investida e bote)

Fatiamento previsto: o mesmo de `BossVfx.BEAM` em três pedaços (tampa esquerda, meio esticável, tampa direita), mas **projetado no chão** (paralelogramo isométrico), não girado em tela. O desenho do avanço (preenchimento que enche até o disparo e a linha de frente) continua no código; a arte é o corpo da faixa.

```
Use case: stylized-concept. Asset: a game VFX animation sprite sheet for Abyss Megadungeon, a 2D isometric dark-fantasy action roguelike. Dense pixel-art-inspired painted effects with crisp luminous silhouettes and restrained detail. Paint luminous light on uniform PURE BLACK #000000 for ADDITIVE blending. Darkness is absence of light, no dark painted outlines. No gray or magenta. No characters, scenery, ground patch, cast shadow, text, letters, numbers, labels, grid lines, borders, logo or watermark. Danger must read clearly from shape and pulse, with a white-yellow luminous core and warm amber edges, kept low in saturation so the game can tint it later. No explicit image references are attached; follow the geometric specifications below exactly. Source canvas: landscape 1536x1024. Exactly SIX equal invisible 256x256 cells in ONE horizontal row across the vertical center, strip y=384..639. Cell centers x=128,384,640,896,1152,1408 and y=512. Everything above/below the strip is pure black. These are six frames of ONE effect, same scale and fixed anchor. SEAMLESS LOOP, frame6 flows into frame1. All particles stay inside each cell with at least 20px clean black margin. No seventh frame. Final prepared delivery will crop/recenter to 1536x256. A CHARGE LANE seen from straight above, pointing RIGHT along the horizontal axis, a flat rectangular strip painted on the ground: band x=24..232, y=80..176 within each 256px cell (about 96px thick), flat top-down, no perspective. The band is a faint luminous floor plate with soft translucent fill, two bright thin long edge lines along its top and bottom borders, and a hot white-yellow END BAR across the right end (x=216..232) marking where the rush stops. The LEFT end (x=24..79) is a soft fading start with a small bright origin flare. Stretchable middle x=80..176 MUST remain uniform along x: just fill and the two edge lines, no arrows, chevrons, droplets, glyphs or shapes in that middle. The only motion in the loop is a gentle synchronous brightness pulse of the fill and a slow shimmer travelling along the edge lines. Recognizable motifs ONLY in end caps. Thematic skin: a trampled strip of scorched, scratched ground marks, faint claw-drag scratches only inside the end caps, ember flecks at the start flare. Warm white core, pale amber edges. Keep thickness and anchor fixed across all six frames.
```

## T21 — Mira do atirador

Fatiamento: igual a `BossVfx.BEAM` (esquerda 24..79, meio 80..176, direita 177..232), em tela como o feixe do chefe (linha fina na altura do peito, `lift` de 16 px). A mira que "fecha" conforme o tiro se aproxima fica no código: escala do aro da tampa direita.

```
Use case: stylized-concept. Asset: a game VFX animation sprite sheet for Abyss Megadungeon, a 2D isometric dark-fantasy action roguelike. Dense pixel-art-inspired painted effects with crisp luminous silhouettes and restrained detail. Paint luminous light on uniform PURE BLACK #000000 for ADDITIVE blending. Darkness is absence of light, no dark painted outlines. No gray or magenta. No characters, scenery, ground patch, cast shadow, text, letters, numbers, labels, grid lines, borders, logo or watermark. Danger must read clearly from shape and pulse, with a white-yellow luminous core and warm amber edges, kept low in saturation so the game can tint it later. No explicit image references are attached; follow the geometric specifications below exactly. Source canvas: landscape 1536x1024. Exactly SIX equal invisible 256x256 cells in ONE horizontal row across the vertical center, strip y=384..639. Cell centers x=128,384,640,896,1152,1408 and y=512. Everything above/below the strip is pure black. These are six frames of ONE effect, same scale and fixed anchor. SEAMLESS LOOP, frame6 flows into frame1. All particles stay inside each cell with at least 20px clean black margin. No seventh frame. Final prepared delivery will crop/recenter to 1536x256. An AIMING BEAM pointing RIGHT along the horizontal axis, a thin precise laser-like line at y=128 within each 256px cell, band x=24..232, only about 12px thick with a soft 24px glow around a 3px white-yellow core line. LEFT cap x=24..79: a small bright muzzle flare that the line grows out of. RIGHT cap x=177..232: a targeting reticle centered at x=204,y=128, a thin ring of about 22px radius with four short ticks (left, right, up, down) and a small bright dot at its center; the ring must stay inside the cell. Stretchable middle x=80..176 MUST remain uniform along x: only the glow and the core line, no dashes, ticks, droplets or shapes in that middle. Motion in the loop: a slow synchronous pulse of the glow and a faint shimmer travelling along the core line; the reticle ring breathes by at most 2px. Thematic skin: none, keep it sober and readable, a clean hostile sight line. Warm white core, pale amber glow. Keep thickness and anchor fixed across all six frames.
```

## T22 — Círculo de golpe em área (aviso)

Fatiamento: um círculo completo, escalado pelo raio do golpe (1,3 a 2,0 tiles), projetado no chão como a pele de quadrante. Só o aviso: a explosão segue sendo a detonação existente. O preenchimento que enche até o disparo continua no código.

```
Use case: stylized-concept. Asset: a game VFX animation sprite sheet for Abyss Megadungeon, a 2D isometric dark-fantasy action roguelike. Dense pixel-art-inspired painted effects with crisp luminous silhouettes and restrained detail. Paint luminous light on uniform PURE BLACK #000000 for ADDITIVE blending. Darkness is absence of light, no dark painted outlines. No gray or magenta. No characters, scenery, ground patch, cast shadow, text, letters, numbers, labels, grid lines, borders, logo or watermark. Danger must read clearly from shape and pulse, with a white-yellow luminous core and warm amber edges, kept low in saturation so the game can tint it later. No explicit image references are attached; follow the geometric specifications below exactly. Source canvas: landscape 1536x1024. Exactly FOUR equal invisible 384x384 cells in ONE horizontal row across the vertical center, strip y=320..703. Cell centers x=192,576,960,1344 and y=512. Everything above/below the strip is pure black. These are four frames of ONE effect, same scale and fixed anchor, a SEAMLESS LOOP, frame4 flows into frame1. Final prepared delivery will resize each cell 384->256 and repack to 1024x256. No grid or extra frames. Keep at least 48 source-pixel clean black margins on every side of each cell. A GROUND WARNING SIGIL that is a perfect TOP-DOWN CIRCLE, no perspective or ellipse; the game projects it onto the isometric floor later. Radially symmetric: a thin bright outer ring of radius 111px (diameter 222px) centered in the cell, a thinner inner ring at radius 74px, and three short radial tick marks on the outer ring at 120-degree spacing; a faint translucent fill inside the outer ring that is dimmer toward the center, leaving the central disc of radius 45px calm and nearly empty so the game can draw a growing fill there. Only faint sparks may extend to radius 135px. Motion in the loop: a synchronous breathing pulse of both rings and a slow quarter-turn rotation of the three ticks per full loop. No directional motif, no uniquely emphasized sector. Thematic skin: none, sober and readable, a clean hostile impact mark. Warm white core line, pale amber edges. Keep the center and scale fixed across all four frames.
```

## 3. Entrega e aceite

- Entrega: `assets_incoming/queue-20261105-r1/T20_faixa_investida_v01.png`, `T21_mira_v01.png`, `T22_area_v01.png`.
- Aceite do dono por folha, antes da preparação. Guarda de qualidade: sem magenta, sem cinza, margens mínimas de 20 px (T20, T21) e 48 px (T22), meio esticável uniforme (T20, T21), quadros com o mesmo centro.

## 4. Integração prevista (Claude, depois do aceite)

1. `tools/telegraph_prep.gd` com um job novo (`tools/asset_jobs/telegraph_comum_v01.json`): escala única por folha e centro medido por quadro, como em `telegraph_skins_v01.json`.
2. `ui/overlay.gd`: `_draw_charge_lane`, `_draw_aim_beam` e `_draw_telegraph` usam a folha quando existe e **caem no desenho atual** quando falta o arquivo (mesmo contrato das peles de chefe). Tingimento por `_warn(dtype)`; "Impacto reduzido" congela o quadro; progresso, linha de frente e preenchimento seguem no código.
3. Testes: um teste novo de presença, fallback, margens e tingimento, sem tocar o save real (perfil sintético).
4. Portagem: alteração comum, exige portagem registrada para a outra versão (AGENTS.md); não feita.
