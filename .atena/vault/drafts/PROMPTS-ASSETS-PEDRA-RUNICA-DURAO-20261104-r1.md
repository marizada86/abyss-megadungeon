# Asset — Pedra rúnica / montanha de Durao, 2026-11-04, r1

Status: DRAFT, pedido do dono ("essas pedras rúnicas precisam ser renovadas"; "criar um prompt pro GPT"). Nenhuma geração, integração, aceite, commit ou publicação autorizados por este rascunho. Checkpoints dos demais planos preservados. Segue o formato de `PROMPTS-ASSETS-TEMPLO-TOU-UM-20261029-r1.md`.

## Lacuna

As 4 montanhas de Durao (`TerrainLayout.MOUNTAINS` em `core/terrain_layout.gd`: (7,9) r2,2; (10,30) r2,0; (34,12) r2,3; (34,31) r2,1) não têm arte. `ui/terrain_features.gd` (classe `Ridge`) as desenha por código: base em estrela escura, corpo poligonal liso, um "Λ" e um ponto. Cada uma bloqueia o movimento num círculo no chão do raio indicado (o herói não atravessa), e o desenho atual não transmite isso nem combina com o acabamento dos props de Durao (`rocha_01`, `rocha_03`, `durao_estrutura_01`).

Nota do dono: ao subir o mapa um pouco para a esquerda, o herói trava onde deveria haver uma pedra rúnica legível. Causa ainda não confirmada em jogo (ver "Verificação").

## A08 — Pedra rúnica de Durao (objeto proposto, não aprovado)

Entrega: 1 sprite estático da pedra (base de variante única). Opcional: 2 variantes (r≈2,0 e r≈2,3) para quebrar a repetição, decisão do dono.

Formato normalizado: PNG RGBA com alfa real, cerca de 208×256 (escala de `arco_pedra.png` 208×248), margem transparente livre, base apoiada no mesmo ponto das outras interações. Escala do chão: 1 tile = 64×32 px de tela; um círculo de raio 2,2 tiles ocupa cerca de 200×100 px, então a base visível da pedra deve cobrir aproximadamente essa elipse, para o bloqueio ficar legível (o desenho atual já tem a base maior que a rocha por causa de um bug de "obstrução invisível").

Referências (estilo/escala, não alvo de edição): `assets/props/rocha_01.png` (rocha vertical com runa ciano), `assets/props/rocha_03.png` (algema e fendas ciano), `assets/props/durao_estrutura_01.png` (pedra escura com ferrugem), `assets/interactions/eclipse_pedra.png` (acabamento).

Prompt (colar no GPT com as referências anexadas):

> Use case: stylized-concept. Generate a single new game object sprite, a large rune-carved standing stone / small rocky spire for a dark fantasy prison mountain, on a truly transparent RGBA background. Reference images are STYLE/SCALE references only, not edit targets. Match the sober dark fantasy pixel art / crisp hand-pixelled finish of the references, clear dark outlines and upper-left light. Three-quarter isometric 2:1 camera. A tall, jagged obsidian-grey stone spire with a wide rocky base made of fallen rubble and scree that spreads into a clear low ellipse (about twice as wide as it is deep, to read as a blocking footprint), rust-orange mineral veins in the cracks, and a single large angular rune glowing in cold cyan on the front face, with thin cyan light seeping through the cracks below it. The rune is an abstract angular glyph, no readable letters. Compact silhouette legible at small sprite size; entire object visible and centered, transparent margin on all sides. Intended normalized delivery approximately 208x256 pixels; render as a clean small game sprite with restrained detail. No text, logos, frame, cast shadow, separate ground patch, scenery, characters, checkerboard pattern, or added props. One static sprite only.

Destino futuro: `assets/props/montanha_runica_01.png`. Integração: registrar o tipo em `ui/prop.gd` (lista de `kind` e caminho do PNG) e em `data/level_design.json` (tamanho), ou trocar o desenho da `Ridge` por `draw_texture` ancorada em `Iso.to_screen(anchor)` mantendo `ground_offset` e o raio de colisão de `MOUNTAINS`; a colisão não muda. Estender o teste de props/arte e rodar a importação do Godot.

## Verificação antes de integrar

Confirmar em jogo qual montanha trava o herói na posição relatada: o bloqueio de `Ridge` é um círculo de `radius` tiles; se a arte nova ficar menor que o círculo, a obstrução invisível volta. O bloqueio de Esquecimento do Estige (`hero.gd`, `styx_forget_t`) é outra causa possível e independe da arte.

## Fora de escopo

- Não regerar assets já aceitos nem alterar `rocha_*` ou `durao_estrutura_01`.
- Não mudar posições ou raios das montanhas nesta frente.
- Geração, variantes e integração dependem de autorização e de aceite visual do dono.
