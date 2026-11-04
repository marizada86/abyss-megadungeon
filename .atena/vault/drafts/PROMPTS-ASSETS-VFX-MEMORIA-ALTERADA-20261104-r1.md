# VFX — Memória Alterada (habilidade de Arlindo), 2026-11-04, r1

Status: DRAFT, pedido do dono ("criar prompt para o gpt de VFX para a habilidade 'memória alterada'"). Nenhuma geração, integração, aceite, commit ou publicação autorizados por este rascunho. Checkpoints dos demais planos preservados. Segue o formato de `PROMPTS-ASSETS-PEDRA-RUNICA-DURAO-20261104-r1.md`.

## Situação atual

A habilidade ativa de Arlindo (`modify_memory`, `data/abilities.json`: tipo `forget_nova`, raio 4 tiles, recarga 18 s, 2 s) já tem folha: `assets/vfx/habilidade_arlindo.png` (1536×256, 6 quadros de 256×256, item C16 de `ASSET-GENERATION-LIST-20261021-r1.md`), ligada em `core/hero_ability_vfx.gd` (`"modify_memory"`, tipo `pulse`, `ref_px` 112, duração 0,8 s). Este rascunho é uma renovação (r2) da folha, não uma arte nova do zero.

Mecânica que o VFX precisa comunicar: pulso em área ao redor do herói; os inimigos atingidos esquecem o herói e perdem os ataques por 2 s (atordoados; chefes só 0,6 s).

Provável motivo de ela ficar fraca em jogo (a confirmar vendo-a em partida): o código do tipo `pulse` já achata o sprite 2:1 para a projeção isométrica (`escala = (TILE_W, TILE_H) × …`, x:y = 2:1, e o teste exige essa razão). A folha atual já vem desenhada em elipse achatada (cerca de 200×50 px por quadro), então o achatamento é aplicado duas vezes e o anel fica com cerca de 4:1, fino e quase invisível. A nova folha deve ser desenhada como círculo visto de cima, para o código achatá-lo uma vez só.

## Entrega

Folha PNG RGBA 1536×256, 6 quadros de 256×256 em fila, pivô no centro de cada célula. O anel, no pico, alcança cerca de 112 px do centro (`ref_px`), com 16 px de margem livre até a borda da célula; borda da célula sem luz. Gerar sobre preto puro; a preparação usa chave de preto (`"key": "black"` em `tools/asset_jobs/icons_v01.json`) e o jogo compõe em modo aditivo, então luz sobre preto, sem sombras escuras nem cinza.

Referências (estilo/acabamento, não alvo de edição): `assets/vfx/habilidade_arlindo.png` atual (paleta azul/violeta e silhuetas fantasmas), `assets/vfx/habilidade_maelor.png`, `assets/vfx/habilidade_zynara.png` (outros pulsos de área). A paleta azul-violeta e as silhuetas translúcidas da folha atual são o que o dono já viu; mudar só a leitura e a projeção.

Lore (vault, Sessões 8–12): Arlindo, líder dos Grimholders, usa Modify Memory para mostrar memórias (por exemplo, uma do Massacre Celestial). O VFX deve evocar lembranças vistas como silhuetas anônimas de figuras e armas, sem rosto e sem identificar ninguém. Não mostrar o destino de Bromnor nem partículas douradas: o codex só revela isso depois da HQ hqn_11.

## Prompt (colar no GPT com as referências anexadas)

> Use case: stylized-concept. Generate a horizontal sprite sheet of one game ability visual effect: a "Modify Memory" pulse, 6 animation frames in one row, each frame a square cell of equal size, on a pure solid black background (#000000) for additive blending, no transparency needed. The reference images are STYLE references only. Match their luminous painterly fantasy VFX finish and their blue and violet palette. Camera: strictly TOP-DOWN, as if seen from directly above, NOT in perspective: the effect is drawn as a flat circle on the ground and the game squashes it later, so do not pre-flatten it into an ellipse. Everything is centered in each cell. Frame 1: a small bright cold-blue core with a few faint ripples. Frame 2: a thin glowing circular ripple expands, with three or four translucent anonymous memory silhouettes (figures and weapons, no faces, no identifiable character) fading in along the ring. Frame 3: the ring reaches about 85% of its maximum size, thick luminous double ring with soft violet inner swirl and drifting shard-like fragments. Frame 4: maximum size, the ring touches about 88% of the half-cell (a ring radius of about 112 px in a 256 px cell), brightest frame, silhouettes at their most visible, thin broken rings around it. Frame 5: the ring thins and fragments, silhouettes dissolve into pale blue mist and shards. Frame 6: only faint mist and a few fading shards, almost empty. Keep clear margin (at least 16 px) between the effect and each cell edge, and nothing may touch the cell borders. The ring must be clearly readable at small size: strong contrast against black, bright cyan-white core edge on the ring, restrained detail. No text, runes with readable letters, logos, frame, characters with faces, ground, scenery, or visible grid lines between cells.

## Destino e integração (após aceite visual do dono)

Destino: substituir `assets/vfx/habilidade_arlindo.png` (mantém caminho, tamanho e `modify_memory` em `core/hero_ability_vfx.gd`; o raio/`ref_px` só muda se a arte nova alcançar outro raio, e então o teste de `ref_px` deve ser revisto). Preparar com a mesma tarefa de `tools/asset_jobs/icons_v01.json` (chave de preto, 1536×256), rodar a importação do Godot e `tests/test_projectile_and_ability_vfx.gd` (6 quadros, células sem borda iluminada). Conferir em jogo, em Dagruve, a leitura do anel com o raio de 4 tiles.

## Fora de escopo

- Não alterar mecânica, raio, recarga nem duração.
- Não mexer na arma `memoria_alterada` (projétil `bolt` de Arlindo): ela hoje não tem VFX de projétil dedicado (fora da lista `FAMILIES` de `ProjectileVfx`). Se o dono quiser, é outro pedido.
- Geração e integração dependem de autorização e de aceite visual do dono.
