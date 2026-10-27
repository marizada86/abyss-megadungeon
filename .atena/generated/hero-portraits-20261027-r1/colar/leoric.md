# Leoric — HUD e Ficha: copiar e colar no ChatGPT

Use **uma conversa nova por imagem**. Para cada uma: arraste os arquivos da pasta indicada **nesta ordem** (os nomes já são numerados), cole o texto do bloco e envie. O HUD e a Ficha do Durvall já foram aprovados; este herói segue o mesmo contrato.

---

## IMAGEM 1 — HUD (quadrada)

**Anexar** (pasta `.atena/generated/art-candidates/hero-portraits-r1-refs/leoric/hud/`, 4 arquivos, na ordem): `1_canon_corpo.png`, `2_canon_rosto.png`, `3_estilo_menu_SO_ESTILO.png`, `4_estilo_jogo.png`

**Colar:**

```text
Generate ONE image, square 1024x1024, using the 4 attached images as references in this order: (1) canon front view of the character (body, costume and colors), (2) canon face and expressions sheet of the same character, (3) a game portrait used ONLY for painting style and color mood, (4) a game enemy used ONLY for painting style.

Dark-fantasy character portrait in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines on the armor and clothing, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur and no photorealistic skin. Style comes from the attached game portrait and enemy art ONLY (the last two attached images); do NOT copy the pose, the framing, the costume details, the weapon or the background of the attached game portrait.

Composition: a tight head-and-shoulders close-up that will be shrunk to 76 px, so the face must read instantly, centered, facing the camera. The face under the black top hat with the copper band fills about 62 percent of the canvas height, the long gray beard reaching the bottom edge, the trench coat collar and brass buttons at the bottom corners. Warm, sly, good-humored expression with bushy brows slightly raised, eyes fixed on the viewer. Strong contrast between the character and a very dark background.

CHARACTER (identity authority: the canon views, images 1 and 2; they win over any other description): Leoric, a male gnome about 1 m tall, 45 years old: pointed ears, a long full gray beard and mustache, bushy brows, a black top hat with a copper band, a long brown leather trench coat with brass buttons and shoulder epaulettes, a dark vest, a belt with small pouches, dark trousers, buckled boots.

Background: very dark green-blue night tone, nearly flat, with a faint cool halo behind the hat. No scenery, no weapon or prop, no particles, no lightning, no glow effects.

NEVER: No staff, no cane, no wand, no glow, no stars drawn around him. No frame, no extra people, no text.

No text, letters, numbers, labels, frame, border or watermark. Keep every asymmetric detail of the canon views (scars, ear edges, which side each item is on) on the same side as in the references. No redesign.
```

**Salvar como:** `assets_incoming/hero-portraits-r1/leoric/leoric_hud_v01.png`

Se o rosto não parecer com o CANON, responda no mesmo chat: `The face does not match the canon views. Keep the same composition and fix only the face and costume details to match the first reference images exactly.`

---

## IMAGEM 2 — Ficha (cena 16:9)

O ChatGPT só gera 1024×1024, 1536×1024 ou 1024×1536; por isso a cena é pedida em 1536×1024 e eu recorto o 16:9 depois.

**Anexar** (pasta `.atena/generated/art-candidates/hero-portraits-r1-refs/leoric/ficha/`, 4 arquivos, na ordem): `1_canon_corpo.png`, `2_canon_perfil.png`, `3_estilo_menu_SO_ESTILO.png`, `4_estilo_jogo.png`

**Colar:**

```text
Generate ONE image, landscape 1536x1024, using the 4 attached images as references in this order: (1) canon front view of the character (body, costume and colors), (2) canon side view of the same character, (3) a game portrait used ONLY for painting style and color mood, (4) a game enemy used ONLY for painting style.

Dark-fantasy character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines on the armor and clothing, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur and no photorealistic skin. Style comes from the attached game portrait and enemy art ONLY (the last two attached images); do NOT copy the pose, the framing, the costume details, the weapon or the background of the attached game portrait.

IMPORTANT LAYOUT: this image will be cropped to a 16:9 frame taken from the central horizontal band between 8 percent and 92 percent of the image height (the full width). The character must be BIG in that frame: ONE character, the whole body from the top of the head (including hat, horns or hair) to the soles of the boots, standing in the exact center of the image horizontally, with the top of the head at about 14 percent and the feet at about 84 percent of the image height, so the figure is about 70 percent of the image height. The camera is close: the environment frames the character tightly on both sides (walls, trunks, ships, pillars) so there are no wide empty side areas. Nothing important within the outer 10 percent of the left and right edges; the top 8 percent and the bottom 8 percent are only plain continuation of the background.

Composition: standing, upright and jaunty, the conch held in his right hand at belt height, the left hand touching the brim of his hat, looking toward the right of the frame. The mood is somber and quiet, not an action scene.

CHARACTER (identity authority: the canon views, images 1 and 2; they win over any other description): Leoric, a male gnome about 1 m tall, 45 years old: pointed ears, a long full gray beard and mustache, bushy brows, a black top hat with a copper band, a long brown leather trench coat with brass buttons and shoulder epaulettes, a dark vest, a belt with small pouches, dark trousers, buckled boots.
A small spiral conch shell, pale cream with faint gold star flecks, the size of his palm, carried in the RIGHT hand at belt height.

ENVIRONMENT: a moonlit forest clearing at night: enormous ancient tree trunks and giant roots that dwarf him, pale mist between the trunks, a starry sky through the canopy, a few small ferns; cool blue-green palette. The background is softly darker and less contrasted than the character so the character stays the brightest and most readable shape in the image.

NEVER: No staff, no cane, no wand, no glow, no stars drawn around him. No extra people, no monsters.

No text, letters, numbers, labels, frame, border or watermark. No motion blur, speed lines, particles, sparks or magic effects. No redesign: costume, hair and face follow the canon views, and every asymmetric detail stays on the same side as in the references.
```

**Salvar como:** `assets_incoming/hero-portraits-r1/leoric/leoric_ficha_v01.png`

Se o herói sair pequeno ou fora do centro, responda no mesmo chat: `Keep the same image but redraw it with the character larger and exactly centered: full body from head to boots about 70 percent of the image height, feet at about 84 percent of the height, and no wide empty areas on the sides.`

---

Quando as duas imagens estiverem em `assets_incoming/hero-portraits-r1/leoric/`, me avise.
