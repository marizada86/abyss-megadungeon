# Nyrelia — HUD e Ficha: copiar e colar no ChatGPT

Use **uma conversa nova por imagem**. Para cada uma: arraste os arquivos da pasta indicada **nesta ordem** (os nomes já são numerados), cole o texto do bloco e envie. O HUD e a Ficha do Durvall já foram aprovados; este herói segue o mesmo contrato.

> Só existe a vista de frente da Nyrelia no Vault (sem costas nem perfil). Por isso as poses dela ficam quase de frente e o rosto nunca aparece.

---

## IMAGEM 1 — HUD (quadrada)

**Anexar** (pasta `.atena/generated/art-candidates/hero-portraits-r1-refs/nyrelia/hud/`, 3 arquivos, na ordem): `1_canon_corpo.png`, `2_estilo_menu_SO_ESTILO.png`, `3_estilo_jogo.png`

**Colar:**

```text
Generate ONE image, square 1024x1024, using the 3 attached images as references in this order: (1) canon front view of the character (body, costume and colors), (2) a game portrait used ONLY for painting style and color mood, (3) a game enemy used ONLY for painting style.

Dark-fantasy character portrait in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines on the armor and clothing, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur and no photorealistic skin. Style comes from the attached game portrait and enemy art ONLY (the last two attached images); do NOT copy the pose, the framing, the costume details, the weapon or the background of the attached game portrait.

Composition: a tight head-and-shoulders close-up that will be shrunk to 76 px, so the face must read instantly, centered, facing the camera. The hooded head with the smooth dark metal mask fills about 66 percent of the canvas height, centered, facing the camera; the fringed hood edge, the green scarf with its gold tassels and the cloak shoulders fill the bottom. Still, composed, unreadable presence; the mask has no eye holes visible and no skin shows. Only one view of this character exists, so keep the head facing the camera. Strong contrast between the character and a very dark background.

CHARACTER (identity authority: the canon views, image 1; they win over any other description): Nyrelia: a tall hooded figure, the face completely hidden behind a smooth dark metal mask (no eyes visible, no skin visible); a deep green ragged hooded cloak with fringed edges, a green scarf with gold tassels, a black dress with a gold embroidered sash, dark gloves, black boots with gold buckles.

Background: very dark green-black, nearly flat, with a faint dim halo behind the hood. No scenery, no weapon or prop, no particles, no lightning, no glow effects.

NEVER: Never show the face, skin, eyes or any trait that reveals her species. No weapon. No yellow aura drawn (the game draws it). No frame, no extra people, no text.

No text, letters, numbers, labels, frame, border or watermark. Keep every asymmetric detail of the canon views (scars, ear edges, which side each item is on) on the same side as in the references. No redesign.
```

**Salvar como:** `assets_incoming/hero-portraits-r1/nyrelia/nyrelia_hud_v01.png`

Se o rosto não parecer com o CANON, responda no mesmo chat: `The face does not match the canon views. Keep the same composition and fix only the face and costume details to match the first reference images exactly.`

---

## IMAGEM 2 — Ficha (cena 16:9)

O ChatGPT só gera 1024×1024, 1536×1024 ou 1024×1536; por isso a cena é pedida em 1536×1024 e eu recorto o 16:9 depois.

**Anexar** (pasta `.atena/generated/art-candidates/hero-portraits-r1-refs/nyrelia/ficha/`, 3 arquivos, na ordem): `1_canon_corpo.png`, `2_estilo_menu_SO_ESTILO.png`, `3_estilo_jogo.png`

**Colar:**

```text
Generate ONE image, landscape 1536x1024, using the 3 attached images as references in this order: (1) canon front view of the character (body, costume and colors), (2) a game portrait used ONLY for painting style and color mood, (3) a game enemy used ONLY for painting style.

Dark-fantasy character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines on the armor and clothing, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur and no photorealistic skin. Style comes from the attached game portrait and enemy art ONLY (the last two attached images); do NOT copy the pose, the framing, the costume details, the weapon or the background of the attached game portrait.

IMPORTANT LAYOUT: this image will be cropped to a 16:9 frame taken from the central horizontal band between 8 percent and 92 percent of the image height (the full width). The character must be BIG in that frame: ONE character, the whole body from the top of the head (including hat, horns or hair) to the soles of the boots, standing in the exact center of the image horizontally, with the top of the head at about 14 percent and the feet at about 84 percent of the image height, so the figure is about 70 percent of the image height. The camera is close: the environment frames the character tightly on both sides (walls, trunks, ships, pillars) so there are no wide empty side areas. Nothing important within the outer 10 percent of the left and right edges; the top 8 percent and the bottom 8 percent are only plain continuation of the background.

Composition: standing nearly front-on, only slightly turned toward the right of the frame, hands folded in front of her, the fringed cloak hanging heavy; the face stays hidden behind the mask. Only one canon view exists, so keep the pose close to it. The mood is somber and quiet, not an action scene.

CHARACTER (identity authority: the canon views, image 1; they win over any other description): Nyrelia: a tall hooded figure, the face completely hidden behind a smooth dark metal mask (no eyes visible, no skin visible); a deep green ragged hooded cloak with fringed edges, a green scarf with gold tassels, a black dress with a gold embroidered sash, dark gloves, black boots with gold buckles.
The hands carry no weapon or prop.

ENVIRONMENT: a damp underground stone cellar used as a hideout: hanging lanterns with small warm flames, stacked crates and barrels, a rough stone arch, drifting mist, deep green-black shadows. The background is softly darker and less contrasted than the character so the character stays the brightest and most readable shape in the image.

NEVER: Never show the face, skin, eyes or any trait that reveals her species. No weapon. No yellow aura drawn (the game draws it). No extra people, no monsters.

No text, letters, numbers, labels, frame, border or watermark. No motion blur, speed lines, particles, sparks or magic effects. No redesign: costume, hair and face follow the canon views, and every asymmetric detail stays on the same side as in the references.
```

**Salvar como:** `assets_incoming/hero-portraits-r1/nyrelia/nyrelia_ficha_v01.png`

Se o herói sair pequeno ou fora do centro, responda no mesmo chat: `Keep the same image but redraw it with the character larger and exactly centered: full body from head to boots about 70 percent of the image height, feet at about 84 percent of the height, and no wide empty areas on the sides.`

---

Quando as duas imagens estiverem em `assets_incoming/hero-portraits-r1/nyrelia/`, me avise.
