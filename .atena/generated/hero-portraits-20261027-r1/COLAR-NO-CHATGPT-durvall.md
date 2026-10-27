# Durvall — HUD e Ficha: copiar e colar no ChatGPT

Use **uma conversa nova por imagem** (modelo de imagens do ChatGPT). Para cada uma: arraste os arquivos da pasta indicada para o chat **nesta ordem** (os nomes já são numerados), cole o texto do bloco e envie.

Pastas das referências: `.atena/generated/hero-portraits-20261027-r1/refs/`

---

## IMAGEM 1 — HUD (quadrada)

**Anexar** (pasta `refs/hud/`, 4 arquivos, na ordem 1 a 4):
`1_canon_corpo.png`, `2_canon_rosto.png`, `3_estilo_menu_SO_ESTILO.png`, `4_estilo_jogo.png`

**Colar:**

```text
Generate ONE image, square 1024x1024, using the 4 attached images as references in this order: (1) canon full-body view of the character, (2) canon face and expressions sheet of the same character, (3) a game portrait used ONLY for painting style and color mood, (4) a game enemy used ONLY for painting style.

Dark-fantasy character portrait in the exact style of the attached game references (images 3 and 4): dense pixel-art-inspired painting with painterly shading, crisp dark outlines on the armor, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur and no photorealistic skin. Do NOT copy the pose, the framing, the sword, the lightning or the ruined-city background of image 3.

Composition: a tight head-and-collar close-up that will be shrunk to 76 px, so the face must read instantly. The head, hair and pointed ears fill about 70 percent of the canvas height, centered, with only the high collar and the tips of the spiked pauldrons visible at the bottom corners. The face looks straight at the camera, head level, with a stern, intent, battle-ready expression: eyes narrowed and fixed on the viewer, jaw set, lips closed. Strong contrast between the pale hair, the blue-gray face and a very dark background.

CHARACTER (images 1 and 2 are the identity authority and win over any description): Durvall, a lean male drow: blue-gray skin with a few faint scars on the cheek, light pale-blue eyes (NOT glowing), light stubble on the chin, long straight white hair falling on both sides of the face past the shoulders, long pointed ears with a red edge. Black plate armor of overlapping leaf-shaped segments with a high pointed collar and silver filigree on the chest plate, spiked pauldrons at the bottom corners.

Background: very dark blue-black, nearly flat, with a faint cold vignette and, behind the head, a soft dim halo of cold blue-gray light to separate the white hair from the dark. No scenery, no sword, no weapon, no particles, no lightning, no glow effects.

NEVER: no helmet, no glowing eyes, no red eyes, no cape, no hood, no tentacles, no black ooze or sludge, no ghostly or divine imagery, no symbols of any kind, no extra people.

No text, letters, numbers, labels, frame, border or watermark. Keep every asymmetric detail of the canon face (scars, ear edges) on the same side as in the references. No redesign.
```

**Salvar como:** `assets_incoming/hero-portraits-r1/durvall/durvall_hud_v01.png`

Se o rosto não parecer com as imagens 1 e 2, responda no mesmo chat: `The face does not match the canon sheet in image 2. Keep the same composition and fix only the face: pale-blue eyes, blue-gray skin, faint cheek scars, light chin stubble, pointed ears with red edge.`

---

## IMAGEM 2 — Ficha (faixa larga)

O ChatGPT só gera 1024×1024, 1536×1024 ou 1024×1536; por isso a cena é pedida em 1536×1024 com tudo importante na faixa central. Eu recorto a faixa 3:1 depois.

**Anexar** (pasta `refs/ficha/`, 5 arquivos, na ordem 1 a 5):
`1_canon_corpo.png`, `2_canon_rosto.png`, `3_canon_perfil.png`, `4_estilo_menu_SO_ESTILO.png`, `5_estilo_jogo.png`

**Colar:**

```text
Generate ONE image, landscape 1536x1024, using the 5 attached images as references in this order: (1) canon full-body view of the character, (2) canon face and expressions sheet, (3) canon side view, (4) a game portrait used ONLY for painting style and color mood, (5) a game enemy used ONLY for painting style.

Dark-fantasy character illustration in the exact style of the attached game references (images 4 and 5): dense pixel-art-inspired painting with painterly shading, crisp dark outlines on the armor, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur and no photorealistic skin. Do NOT copy the pose, the framing or the background of image 4.

IMPORTANT LAYOUT: this image will be cropped to a wide 3:1 banner taken from the central horizontal band between 25 percent and 75 percent of the image height (the full width, 1536x512). Put the ENTIRE character and every important element inside that central band. The top quarter and the bottom quarter are only a plain continuation of the background (dark ceiling of the hall above, floor below) with nothing important in them. Nothing important within the outer 6 percent of the left and right edges.

Composition: ONE character, standing, shown from the head to about mid-thigh, with the head near the top of the central band, placed in the central third of the width. Seen from the side in three-quarter view turned toward the RIGHT of the image, calm and resolute, weight on the back foot, head slightly lowered, eyes looking toward the right of the frame. The left and right thirds are environment only. The mood is somber and quiet, not an action scene.

CHARACTER (images 1, 2 and 3 are the identity authority and win over any description): Durvall, a tall, lean male drow: blue-gray skin, light pale-blue eyes (NOT glowing), long straight white hair falling past the shoulder blades, long pointed ears with a red edge, a stern angular face with a calm closed expression. Black plate armor of overlapping leaf-shaped segments with sharp points, spiked pauldrons and plate gauntlets. A torn dark-red sash tied at the waist with a ragged red cloth hanging down the front-left hip. A straight black-steel longsword with a plain cold edge highlight, no glow and no lightning, held low in the right hand with the tip pointing down at his side. The left hand is open and empty.

ENVIRONMENT: the dark stone hall of a drowned abyssal fortress at night: a long row of tall black arches and broken columns receding to the left and right in cold blue-gray fog, a cracked flagstone floor, a few dim amber embers far in the background as the only warm accents. Low horizon line. The background is softly darker than the character so his white hair and red sash are the brightest, most readable shapes in the image.

NEVER: no helmet, no glowing eyes, no red eyes, no cape, no tentacles, no black ooze or sludge, no extra weapons, no ghostly or divine imagery, no symbols of any kind, no extra people, no monsters.

No text, letters, numbers, labels, frame, border or watermark. No motion blur, speed lines, particles, sparks or magic effects. No redesign: costume, hair and face follow the canon views, and every asymmetric detail (sash on the screen-left hip, sword in the right hand) stays on the same side as in the references.
```

**Salvar como:** `assets_incoming/hero-portraits-r1/durvall/durvall_ficha_v01.png`

Se a cabeça ou os pés saírem da faixa central, responda no mesmo chat: `Keep the same image but redraw it so the whole character, head included, fits inside the central horizontal band between 25 and 75 percent of the image height.`

---

## Variante: espada com raios (só se quiser manter o raio do menu)

Na imagem 2, troque a frase "A straight black-steel longsword ... tip pointing down at his side." por:

```text
A straight black-steel longsword held low in the right hand with the tip pointing down at his side, with thin pale-blue lightning wrapping the blade. The lightning is light, only wraps the sword and does not light the face or the scene.
```

---

Quando as duas imagens estiverem em `assets_incoming/hero-portraits-r1/durvall/`, me avise: eu recorto, reduzo para 256×256 e 768×256, integro e capturo.
