# Lote 3, piloto: E03, D01 e T02

Para cada folha: abra um chat novo, **anexe `ref-existing-vfx.png`** (nesta pasta), cole o bloco inteiro e salve a imagem nesta pasta com o nome indicado. Até três tentativas por folha (`_v02`, `_v03`). Se vier com texto, grade desenhada, fundo cinza ou número de quadros errado, responda: *regenerate exactly as specified, pure black background, no text, no drawn grid*.

---

## E03 — orbe_radiante_evo

Salvar como `E03_orbe_radiante_evo_v01.png`

```text
Generate an image from the following specification. Use the attached reference board only for finish quality, not for shapes.

Use case: stylized-concept. Game VFX sprite sheet for a 2D isometric dark-fantasy action roguelike. Dense pixel-art-inspired painted effect, crisp luminous shapes, clean readable silhouette. Match the line quality, brightness and crispness of the attached reference board of existing in-game effects, but do NOT copy its shapes. No floor, no cast shadow, no backdrop scenery, no characters, no text, no letters, no numbers, no labels, no cell borders, no logo, no watermark.

Rendering: the effect is drawn in-game with ADDITIVE blending, so paint it as bright luminous light on a uniform PURE BLACK #000000 background. Black means transparent: no dark outlines and no dark shapes inside the effect, darkness is only the absence of light. No gray, no magenta anywhere.

Layout: landscape 1536x1024 canvas. EIGHT frames in a grid of 4 columns x 2 rows of equal invisible 384x384 cells, the grid centered vertically (128 px of empty background above and below). TOP ROW = four FLIGHT frames: the SAME projectile pointing RIGHT, head to the right of the cell centre, small shimmer and trail variation between frames so it loops. BOTTOM ROW = four IMPACT frames played once: contact flash, expansion, peak burst, fade-out, each centered on the cell centre. Same scale across frames, each frame entirely inside its own cell with at least 30 px margin, nothing cropped, clear gaps. Exactly eight frames.

Effect: the EVOLVED radiant projectile. Row 2 of the attached reference board is the BASE radiant orb (a white comet with a light tail); make a clearly related but obviously more powerful evolved version. FLIGHT: a pure-light orb with a large soft golden halo, a bright white core, four thin cross rays that rotate slightly between frames and a longer feathered tail of light behind it; must read clearly when the whole projectile is downscaled to about 48 px. IMPACT: a six-point star burst with a thin expanding ring and floating light motes, then fading. Palette: white and warm gold, pale amber edges.
```

---

## D01 — detonacao_fisica

Salvar como `D01_detonacao_fisica_v01.png`

```text
Generate an image from the following specification. Use the attached reference board only for finish quality, not for shapes.

Use case: stylized-concept. Game VFX sprite sheet for a 2D isometric dark-fantasy action roguelike. Dense pixel-art-inspired painted effect, crisp luminous shapes, clean readable silhouette. Match the line quality, brightness and crispness of the attached reference board of existing in-game effects, but do NOT copy its shapes. No floor, no cast shadow, no backdrop scenery, no characters, no text, no letters, no numbers, no labels, no cell borders, no logo, no watermark.

Rendering: the effect is drawn in-game with ADDITIVE blending, so paint it as bright luminous light on a uniform PURE BLACK #000000 background. Black means transparent: no dark outlines and no dark shapes inside the effect, darkness is only the absence of light. No gray, no magenta anywhere.

Layout: landscape 1536x1024 canvas. SIX equal invisible 256x256 cells arranged in ONE straight horizontal row across the vertical center (cells start at x=0, 256, 512, 768, 1024, 1280), with a large empty background area above and below for a later crop to 1536x256. Six successive animation stages of the SAME effect, same scale and same anchor point at each cell centre, clear gaps so frames do not touch. Each frame entirely inside its own cell with at least 20 px margin, nothing cropped, all particles bounded. Exactly six frames.

Effect: a heavy physical ground-slam detonation seen in three-quarter isometric view, centered at each cell centre. An ELLIPTICAL shockwave ring on the ground (twice as wide as tall) expands from the centre; the dominant ring reaches about 110 px from the cell centre horizontally at its peak. Frame 1: a bright impact flash at the centre. Frame 2: the ring starts and a dust cloud rises. Frame 3: peak, the full elliptical ring, rock shards and debris thrown upward, dust billowing. Frame 4: the ring keeps expanding and thins, shards at the top of their arc. Frame 5: dust settling, a few shards falling. Frame 6: nearly faded. Palette: pale warm off-white, amber and a little orange; no blue; earthy and heavy.
```

---

## T02 — tentaculos_laco

Salvar como `T02_tentaculos_laco_v01.png`

```text
Generate an image from the following specification. Use the attached reference board only for finish quality, not for shapes.

Use case: stylized-concept. Game VFX sprite sheet for a 2D isometric dark-fantasy action roguelike. Dense pixel-art-inspired painted effect, crisp luminous shapes, clean readable silhouette. Match the line quality, brightness and crispness of the attached reference board of existing in-game effects, but do NOT copy its shapes. No floor, no cast shadow, no backdrop scenery, no characters, no text, no letters, no numbers, no labels, no cell borders, no logo, no watermark.

Rendering: the effect is drawn in-game with ADDITIVE blending, so paint it as bright luminous light on a uniform PURE BLACK #000000 background. Black means transparent: no dark outlines and no dark shapes inside the effect, darkness is only the absence of light. No gray, no magenta anywhere.

Layout: landscape 1536x1024 canvas. SIX equal invisible 256x256 cells arranged in ONE straight horizontal row across the vertical center (cells start at x=0, 256, 512, 768, 1024, 1280), with a large empty background area above and below for a later crop to 1536x256. Six successive animation stages of the SAME effect, same scale and same anchor point at each cell centre, clear gaps so frames do not touch. Each frame entirely inside its own cell with at least 20 px margin, nothing cropped, all particles bounded. Exactly six frames.

Effect: a ring of seven tentacles writhing around a circular patch on the ground, seen in three-quarter isometric view, as a LOOPING animation. The ground footprint is an ellipse about 200 px wide and 100 px deep with its centre at about x=128, y=172 of each cell; tentacles rise up to about 120 px high. Thin violet tentacles with pale lilac highlights and tiny sucker details sway and curl; a faint glowing ground ring marks the footprint. Six frames form a SEAMLESS LOOP: frame 6 flows back into frame 1, tentacle bases stay fixed in every frame. No eyes, no faces. Palette: violet and teal-violet, subtle glow.
```
