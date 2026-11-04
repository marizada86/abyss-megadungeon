# VFX — Golpes telegrafados temáticos por chefe, 2026-11-04, r1

Status: DRAFT, pedido do dono ("prompts para cada um dos golpes telegrafados, com a temática do jogo", a partir da captura da varredura em amarelo/vermelho). Nenhuma geração, integração, aceite, commit ou publicação autorizados por este rascunho. Checkpoints dos demais planos preservados. Mesmo pipeline do Lote 2 (`vfx-lote2-20261023-r1`): fundo preto puro, blend aditivo, folhas de 1536x256 (6 quadros) ou 2048x256 (4 + 4 quadros).

Não revelar nada de "cânone do mestre". Temas abaixo vêm só de nomes, golpes do jogo e das notas do codex já em rascunho; onde a leitura é minha, está marcado como "a confirmar".

## O que existe hoje

Os golpes telegrafados de chefe (`data/boss_mechanics.json`, `core/boss_vfx.gd`) usam uma folha neutra por verbo, tingida pelo jogo:

| Verbo | Folha atual | Leitura no jogo |
|---|---|---|
| `sweep` | `boss_varredura_aviso` e `boss_varredura_feixe` (G01, G02) | faixa no chão do chefe até `len` tiles (a da captura) |
| `quadrants` | `boss_quadrante_runas` (G03) | selo circular cortado em 4 fatias, algumas acendem |
| `mark` | `boss_marca_alvo` (G04) | anel que segue o herói e trava |
| `cast` | `boss_conjuracao_carga` (G05) | aura de carga em volta do chefe |

Não entram aqui (continuam neutros e tingidos): estouro da conjuração (G06), conjuração interrompida (G07, cor fria de recompensa de propósito), escudo (G08) e estouro de fase (G09). Também não entram o círculo genérico de inimigo comum (`_draw_telegraph` em `ui/overlay.gd`) nem o telégrafo de armadilha: seguem o código.

## Regras de leitura (valem para todos os prompts)

1. O perigo tem de ler como perigo antes do tema: núcleo branco-amarelo e borda âmbar/vermelha em todas as variantes. O tema mora no corpo, nas faíscas e nos motivos.
2. O sinal não pode depender só da cor (o jogo tem modos de cor em `Accessibility`): forma, pulso e ritmo carregam o aviso.
3. Geometria idêntica à folha neutra do mesmo verbo, porque o código fatia e estica a arte (`BEAM` em `core/boss_vfx.gd`; `SIGIL_HALF_PX`, `MARK_HALF_PX`). A pele muda, o esqueleto não.
4. Regra do preto: preto é transparente. Sem magenta e sem cinza em nenhum prompt, então o rosa/vinho de Malcanthet é carmesim e dourado.

## Como montar cada prompt

Prompt completo = **BASE** + **LAYOUT** (do tipo da folha) + **GEOMETRIA** (do tipo) + **PELE** (do item). Anexar a folha neutra aceita do mesmo verbo (G01, G02, G03, G04 ou G05) como referência de geometria e posição, e `ref-existing-vfx.png` só para acabamento.

### BASE (igual a G01..G09)

> Use case: stylized-concept. Game VFX sprite sheet for a 2D isometric dark-fantasy action roguelike. Dense pixel-art-inspired painted effect, crisp luminous shapes, clean readable silhouette. Match the line quality, brightness and crispness of the attached reference board of existing in-game effects, but do NOT copy its shapes. No floor, no cast shadow, no backdrop scenery, no characters, no text, no letters, no numbers, no labels, no cell borders, no logo, no watermark.
>
> Rendering: the effect is drawn in-game with ADDITIVE blending, so paint it as bright luminous light on a uniform PURE BLACK #000000 background. Black means transparent: no dark outlines and no dark shapes inside the effect, darkness is only the absence of light. No gray, no magenta anywhere. The attached neutral sheet of the same effect defines the exact geometry and anchor; keep it, change only the thematic skin described below.

### LAYOUT-6 (varredura e conjuração)

> Layout: landscape 1536x1024 canvas. SIX equal invisible 256x256 cells arranged in ONE straight horizontal row across the vertical center (cells start at x=0, 256, 512, 768, 1024, 1280), with a large empty background area above and below for a later crop to 1536x256. Six successive animation stages of the SAME effect, same scale and same anchor point at each cell centre, clear gaps so frames do not touch. Each frame entirely inside its own cell with at least 20 px margin, nothing cropped, all particles bounded. Exactly six frames. Six frames form a SEAMLESS LOOP: frame 6 flows back into frame 1.

### LAYOUT-8 (quadrante e marca)

> Layout: landscape 1536x1024 canvas. EIGHT frames in a grid of 4 columns x 2 rows of equal invisible 384x384 cells, the grid centered vertically (128 px of empty background above and below). TOP ROW = four LOOPING frames, frame 4 flows back into frame 1. BOTTOM ROW = four frames played once, in order. Same scale across frames, each frame entirely inside its own cell with at least 30 px margin, nothing cropped, clear gaps. Exactly eight frames.

### GEOMETRIA por tipo

**GEO-AVISO** (G01): "The WARNING phase of a boss sweep beam, lying flat along the ground, seen from a three-quarter isometric angle and pointing RIGHT. A narrow band about 28 px thick runs horizontally from x=24 to x=232 at y=128 inside each cell, with a bright white-yellow core line. The middle section (x=70 to x=186) must be perfectly uniform along its length so the game can stretch it, with any repeating motif so small and low-contrast that stretching it will not show; only the two ends taper into soft rounded caps. Thickness and position fixed across frames."

**GEO-FEIXE** (G02): "The ACTIVE phase of a boss sweep beam, lying flat along the ground, pointing RIGHT, three-quarter isometric. A thick column about 84 px thick runs horizontally from x=24 to x=232 at y=128 inside each cell, white-hot core. The middle section (x=70 to x=186) must be uniform along its length so the game can stretch it; only the two ends taper into rounded caps. Edges churn and a few arcs flicker, thickness and position fixed."

**GEO-QUADRANTE** (G03): "A boss danger sigil painted FLAT on the ground as a perfect TOP-DOWN circle (no perspective, the game will squash it into the isometric floor), about 320 px in diameter, centered at each cell centre. Concentric rings and a central motif, radially symmetric with NOTHING that marks one quadrant different from another, because the game cuts it into quarter slices. TOP ROW: the warning sigil dim and pulsing slowly, a brightness wave travelling around the rings. BOTTOM ROW: ignition, eruption across the whole circle, intense peak disc, fade to embers."

**GEO-MARCA** (G04): "A boss targeting mark painted FLAT on the ground as a TOP-DOWN circle (no perspective), about 300 px in diameter, centered at each cell centre. TOP ROW: a thin ring with four inward-pointing arrow ticks and a small central crosshair, rotating a quarter turn across the four frames. BOTTOM ROW: frame 5 the ticks slam inward and the ring turns bright red, frame 6 the whole disc floods with light, frame 7 peak burst with sharp radial streaks, frame 8 fading embers."

**GEO-CARGA** (G05): "A spell being charged by a large monster, drawn as an aura that wraps around a tall standing figure that is NOT painted: only the energy is visible. A column about 150 px wide and 210 px tall, centered at x=128 with its base at about y=215, spiral ribbons rising around an empty core, a flat oval ring of light at the base, small motes drifting upward and pulled inward. Base fixed."

## Peles por golpe

Cada item: ID, folha de destino proposta (`assets/vfx/<nome>.png`, ainda não existe), de qual chefe e golpe, e o texto de PELE. Termine sempre o prompt com a PELE (a paleta vai na última frase).

### Varredura (aviso = GEO-AVISO, feixe = GEO-FEIXE)

Cada chefe pede dois prompts, aviso e feixe, com a mesma pele para o par ler como o mesmo golpe.

**T01 — Guardião Alado (verdadeiro)**, 1 feixe (fase 1). Destino: `boss_varredura_aviso_guardiao.png`, `boss_varredura_feixe_guardiao.png`. Tema (a confirmar): guardião de asas, vento e penas.
- Aviso: "Thematic skin: the band is a streak of wind-torn light, thin pale-gold feathers drifting along it toward the right like the wake of a wingbeat, tiny abyssal-ember flecks eating the feather tips. Pale gold core, amber and red-orange edge, ash-white feathers."
- Feixe: "Thematic skin: a blade of wind and fire, the edges shaped like jagged raking feathers, scorched feather shards peeling off the edges, arcs of crimson lightning. White-hot core, crimson-orange body, ash-white feathers."

**T02 — Molydeus, Carcereiro-Chefe**, 2 feixes opostos (fase 2). Destino: `boss_varredura_aviso_molydeus.png`, `boss_varredura_feixe_molydeus.png`. Tema: carcereiro de Gehenna, ferro, correntes e fogo.
- Aviso: "Thematic skin: a glowing iron bar heated amber along its length, the faintest hint of linked chain rings in the glow, hot rivet-like sparks and embers crawling along it toward the right. Amber-yellow core, red-orange edge, dull ember sparks."
- Feixe: "Thematic skin: a whip of molten chain, a column of hellfire with the outline of heavy chain links glowing inside it, sparks of white-hot iron flying from the edges, flame tongues licking upward. White-hot core, deep crimson and orange body."

**T03 — Malcanthet, Rainha das Súcubos**, 1 feixe (fase 2). Destino: `boss_varredura_aviso_malcanthet.png`, `boss_varredura_feixe_malcanthet.png`. Tema: corte infernal, rosas, espinhos, o Espelho das Almas Desejantes.
- Aviso: "Thematic skin: a thin thorned vine of light, tiny rose petals and small mirror-glint sparkles sliding along it toward the right. Amber-gold core, wine-crimson and rose-red edge, gold glints."
- Feixe: "Thematic skin: a lashing whip of thorned crimson energy, rose petals tearing away from the edges as bright embers, a few mirror-shard glints flashing in the body. White-gold core, deep crimson and rose-red body, gold glints."

**T04 — A Síntese Abissal**, 1 feixe (fase 1). Destino: `boss_varredura_aviso_sintese.png`, `boss_varredura_feixe_sintese.png`. Tema: aberração de slime e presença de Ghaunadaur, psíquico, medo.
- Aviso: "Thematic skin: a band of unstable aberrant energy, small slime droplets and thin violet psychic filaments crawling along it toward the right, the edge twitching unnaturally. Amber-white core, amber and red edge, sickly green droplets and violet filaments."
- Feixe: "Thematic skin: a column of warped energy dripping slime upward and outward, violet psychic arcs crawling across it, the edge writhing like unseen mouths without drawing any face. White-hot core, crimson-orange body, sickly green and violet accents."

### Quadrante (GEO-QUADRANTE)

**T05 — Blogbog** (fase 2). Destino: `boss_quadrante_runas_blogbog.png`. Tema: limo de Juiblex.
- "Thematic skin: the sigil is made of concentric rings of acid-green ooze with bubbles and drip marks instead of angular runes, a central swirl of slime. Bottom row: the ooze bursts into a splashing geyser across the whole circle, droplets flung outward. Acid green and amber, white-yellow peak, crimson-orange edge for the danger read."

**T06 — Zuggtmoy, Dama dos Fungos** (fase 1, deixa poça). Destino: `boss_quadrante_runas_zuggtmoy.png`. Tema: fungos e esporos.
- "Thematic skin: the sigil is a mycelium web, concentric rings of fine fungal threads with tiny mushroom-cap tick marks and a central spore-ring, drifting spores around it. Bottom row: the caps pop and a cloud of spores erupts across the whole circle with a bright flash. Ochre-yellow and pale spore-green, white-yellow peak, red-orange edge for the danger read."

**T07 — O Discípulo Pestilento** (fase 1, deixa poça). Destino: `boss_quadrante_runas_discipulo.png`. Tema: peste de Feng-tu.
- "Thematic skin: the sigil is made of concentric rings of cracked, blistered plague-sores and bone-colored tick marks, tiny flies as dots drifting along the rings, a central swollen pustule. Bottom row: the pustules burst and a sickly gas erupts across the whole circle. Sickly green and bone-yellow, white-yellow peak, red-orange edge for the danger read."

**T08 — Socothbenoth, Âncora de Juiblex** (fase 1). Destino: `boss_quadrante_runas_socothbenoth.png`. Tema (a confirmar): falso paraíso, ilusão corrompida pelo limo.
- "Thematic skin: the sigil is a gilded mandala of concentric rings with ornate garden-like filigree, cracks in it leaking green slime light, the symmetry perfect. Bottom row: the filigree shatters like a mirror and slime-green light erupts across the whole circle. Gold and pale white with slime-green cracks, white-yellow peak, red-orange edge for the danger read."

**T09 — A Síntese Abissal** (fase 2). Destino: `boss_quadrante_runas_sintese.png`. Tema: aberração, runas do salão do Castelo da Fome, psíquico.
- "Thematic skin: the sigil is a ring of distorted, almost-readable runes (none legible) with warped concentric rings and psychic ripples, small slime droplets crawling along the rings, a central dim void with a faint violet glow. Bottom row: the rings invert outward in a psychic shockwave and slime erupts across the whole circle. Violet-white and sickly green, white-yellow peak, red-orange edge for the danger read."

### Marca (GEO-MARCA)

**T10 — Molydeus, Carcereiro-Chefe** (fase 1). Destino: `boss_marca_alvo_molydeus.png`. Tema: grilhões.
- "Thematic skin: the ring is an open iron shackle with four chain-link ticks pointing inward, ember sparks orbiting. Bottom row: the shackle snaps shut, the ring turns red-hot and the disc floods with hellfire, sharp radial streaks at the peak. Iron-amber, red-hot, white-yellow."

**T11 — O Discípulo Pestilento** (fase 1, deixa poça). Destino: `boss_marca_alvo_discipulo.png`. Tema: peste.
- "Thematic skin: the ring is a ring of tiny plague flies and spore motes orbiting a faint crosshair, four inward ticks shaped like thin bone spurs. Bottom row: the flies converge, the ring bloats and bursts into a sickly cloud that floods the disc. Bone-yellow and sickly green, red-orange at the lock, white-yellow peak."

**T12 — Malcanthet, Rainha das Súcubos** (fase 1). Destino: `boss_marca_alvo_malcanthet.png`. Tema: atração e espelho.
- "Thematic skin: the ring is a thin gold circle with four inward thorn ticks and a small central crescent-horn crosshair, rose petals orbiting. Bottom row: the thorns slam inward, the ring turns deep crimson and the disc floods with rose-red and gold light, mirror-shard streaks at the peak. Gold then crimson then white-gold."

### Conjuração, carga (GEO-CARGA)

**T13 — Sacerdote da Mente Derretida**, "Sussurro" (Dagruve, fase 2). Destino: `boss_conjuracao_carga_sacerdote.png`. Tema: mente derretida, sussurro.
- "Thematic skin: the ribbons are thin wavering whisper-lines rising like heat haze, faint concentric ripples spreading along the base ring, motes drifting like fragments of speech with no readable glyphs. Lilac-white core, pale amber edge so it still reads as a charge."

**T14 — Guardião Alado (verdadeiro)**, "Grito Abissal" (fase 2). Destino: `boss_conjuracao_carga_guardiao.png`. Tema (a confirmar): vento e grito.
- "Thematic skin: ribbons of swirling wind with pale feathers caught in the spiral, a ring of dark abyssal embers at the base, motes of ash pulled inward. Pale gold-white core, amber and crimson ring, ash feathers."

**T15 — O Discípulo Pestilento**, "Grito na mente" (fase 2). Destino: `boss_conjuracao_carga_discipulo.png`. Tema: peste e grito mental.
- "Thematic skin: ribbons of sickly gas spiraling upward with tiny flies caught in them, faint violet psychic ripples along the base ring, spore motes pulled inward. Bone-white core, sickly green body, amber ring."

**T16 — Malcanthet, Rainha das Súcubos**, "Beijo da Rainha" (fase 2). Destino: `boss_conjuracao_carga_malcanthet.png`. Tema: sedução sombria.
- "Thematic skin: ribbons of crimson light twining like silk around the empty core, drifting rose petals and tiny gold sparks pulled inward, a thorned oval ring at the base. White-gold core, deep crimson body, gold ring, no pink or magenta."

**T17 — Socothbenoth, Âncora de Juiblex**, "Verdade desfeita" (fase 2). Destino: `boss_conjuracao_carga_socothbenoth.png`. Tema (a confirmar): paraíso falso que se desfaz.
- "Thematic skin: ribbons of golden filigree light spiraling up, cracking at intervals and leaking slime-green light, shards of the illusion drifting inward, a mandala-like ring at the base. Gold-white core, slime-green cracks, amber ring."

**T18 — A Síntese Abissal**, "Armadura do Psíquico" (fase 2, efeito `armor`). Destino: `boss_conjuracao_carga_sintese.png`. Tema: carapaça psíquica.
- "Thematic skin: instead of loose ribbons, angular translucent plates of violet-white psychic energy assembling in a spiral around the empty core, slime droplets slipping between the plates, a thin ring of runes at the base (none legible). Violet-white core, sickly green droplets, amber ring so the base still reads as a charge."

## Totais e ordem sugerida

18 golpes (T01..T18): 4 de varredura, 5 de quadrante, 3 de marca e 6 de carga. Como cada varredura tem aviso e feixe, são 22 folhas a gerar. Piloto sugerido: T02 e T10 (Molydeus, que cobre varredura e marca com o mesmo tema) antes de abrir os demais. O aceite deve seguir o do Lote 2 (cada folha comparada com a neutra do mesmo verbo); não reabri os critérios exatos, então confirmar em `.atena/generated/vfx-lote2-20261023-r1/` antes de usar.

## Integração futura (só após aceite visual do dono)

Hoje `BossVfx.describe` escolhe a folha só pelo verbo e por `warn`; não há chave de chefe. A integração pede: um mapa `chefe + verbo -> folha` (em `data/boss_mechanics.json` ou arquivo próprio), com a folha neutra como fallback, mais as entradas novas em `BossVfx.SHEETS` e `EIGHT_CELL`, e `VfxAtlas` lendo as folhas novas. A tabela `BEAM` já serve se as peles respeitarem as fatias `l`, `m`, `r` e o `k`. Estender `tests/test_boss_vfx.gd` e rodar a importação do Godot. Nada disso foi iniciado.

## Fora de escopo

- Não regerar G01..G09 já aceitos nem alterar as folhas neutras.
- Estouro da conjuração, conjuração interrompida, escudo e estouro de fase: seguem neutros.
- Círculo genérico de inimigo comum e armadilhas.
- Geração, integração e aceite dependem de autorização e de aceite visual do dono.
