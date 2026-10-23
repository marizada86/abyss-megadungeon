# Erik — pacote de prompts (contrato r2, DRAFT)

Status: nada foi gerado. Substitui o pacote r1 (`prompts/`), que gerou as v01 e v02 do Durvall e fica como histórico. prova de contrato (R2, assimétrico). Fundo: pure magenta #FF00FF. Oeste: real. Verificador: `r2_check_v2.gd` (tipo na última coluna). Contrato: `.atena/specs/SPEC-NOTTGARD-HERO-ART-RESET-20261021/animation-contract-r2.md`. Ficha: `.atena/vault/drafts/HERO-VISUAL-SHEETS-20261021-r1.md`.

> IMPORTANTE (decisão A2): as referências mostram cabelo e barba; ignore isso. Erik está de cabeça raspada e sem barba.

## Anexos (máximo 5 por pedido, nesta ordem)

**Idle:**

1. F:\dev\nottgard-vault\output\referencias-personagens\EEEE-r01\fronts\erik-front-v01.png
2. F:\dev\nottgard-vault\output\referencias-personagens\EEEE-r01\views\erik-left-v01.png
3. F:\dev\nottgard-vault\output\referencias-personagens\EEEE-r01\views\erik-back-v01.png
4. F:\dev\nottgard-vault\output\referencias-personagens\B-FALT-005-04\r01\erik-right-candidate-v01.png
5. F:\dev\abyss-megadungeon\assets\enemies\zuggtmoy.png  (estilo do jogo)

**Todas as outras imagens (caminhada, ataque, ativa, morte):**

1. F:\dev\nottgard-vault\output\referencias-personagens\EEEE-r01\fronts\erik-front-v01.png
2. F:\dev\nottgard-vault\output\referencias-personagens\EEEE-r01\views\erik-left-v01.png
3. F:\dev\nottgard-vault\output\referencias-personagens\EEEE-r01\views\erik-back-v01.png
4. F:\dev\nottgard-vault\output\referencias-personagens\B-FALT-005-04\r01\erik-right-candidate-v01.png
5. F:\dev\abyss-megadungeon\assets_incoming\hero-r2\erik\erik_idle_se_v01.png  (idle APROVADO do herói; use a versão aprovada; não anexe nenhuma caminhada)

Um herói por conversa. Salvar como `F:\dev\abyss-megadungeon\assets_incoming\hero-r2\erik\<arquivo>`.

## Imagens (12)

| # | Arquivo | Conteúdo | Layout | Figuras | Tipo |
|---|---|---|---|---|---|
| 1 | `erik_idle_se_v01.png` | Idle (3 desenhos, voltado para se) | 1×3 · 1536×1024 | 3 | idle |
| 2 | `erik_walk_e_r2_v01.png` | Caminhada e (A, P1, B, P2) | 2×2 · 1536×1024 | 4 | walk4 |
| 3 | `erik_walk_se_r2_v01.png` | Caminhada se (A, P1, B, P2) | 2×2 · 1536×1024 | 4 | walk4 |
| 4 | `erik_walk_ne_r2_v01.png` | Caminhada ne (A, P1, B, P2) | 2×2 · 1536×1024 | 4 | walk4 |
| 5 | `erik_walk_s_r2_v01.png` | Caminhada s (A, P1, B, P2) | 2×2 · 1536×1024 | 4 | walk4 |
| 6 | `erik_walk_n_r2_v01.png` | Caminhada n (A, P1, B, P2) | 2×2 · 1536×1024 | 4 | walk4 |
| 7 | `erik_walk_w_r2_v01.png` | Caminhada w (A, P1, B, P2) | 2×2 · 1536×1024 | 4 | walk4 |
| 8 | `erik_walk_sw_r2_v01.png` | Caminhada sw (A, P1, B, P2) | 2×2 · 1536×1024 | 4 | walk4 |
| 9 | `erik_walk_nw_r2_v01.png` | Caminhada nw (A, P1, B, P2) | 2×2 · 1536×1024 | 4 | walk4 |
| 10 | `erik_attack_se_v01.png` | Ataque (calibração + 3 desenhos) | 2×2 · 1536×1024 | 4 | grid |
| 11 | `erik_active_se_v01.png` | Habilidade ativa (calibração + 3 desenhos) | 2×2 · 1536×1024 | 4 | grid |
| 12 | `erik_death_se_v01.png` | Morte (calibração + 3 desenhos) | 2×2 · 1536×1024 | 4 | grid |

### 1. `erik_idle_se_v01.png` — Idle (3 desenhos, voltado para se)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps between figures. Draw exactly 3 full-body figures of the SAME character in ONE horizontal row, left to right, evenly spaced with at least 140 px of empty background between figures. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All figures have the same scale (about 75 percent of the canvas height) and all feet rest on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.

REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.

Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.

NEVER: No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.

Facing for ALL figures in this image: three-quarter front view, body and face turned toward the camera and toward screen-RIGHT at about 45 degrees.
Figure 1 — REST: relaxed standing pose, facing the camera and slightly to the right, weight even on both feet (this is the calibration figure).
Figure 2 — BREATH IN: identical pose and identical feet; shoulders and chest raised by only 2 to 3 px; cloth and hair shift by a hair's width.
Figure 3 — BREATH OUT: identical pose and identical feet; shoulders and chest settled slightly lower than REST; cloth and hair shift slightly the other way.
The three figures must be almost identical; only the tiny breathing and cloth/hair differences described. Same feet placement in all three.

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 2. `erik_walk_e_r2_v01.png` — Caminhada e (A, P1, B, P2)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.

REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.

Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.

NEVER: No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.

Facing for ALL figures in this image: pure side view in profile, facing screen-RIGHT.
The character walks at a normal pace; head height stays about the same. The torch is held in the RIGHT hand at hip height, flame up; the sword stays sheathed on the back.
Figure 1 — CONTACT with the NEAR leg leading (the near leg is the leg closest to the camera): the NEAR leg is the leading leg, extended forward with only the heel just touching the ground; the FAR leg is the trailing leg, behind the body with only the toes on the ground. The arm on the side opposite to the leading leg swings forward and the other arm swings back; the arm that carries the item stays steady.
Figure 2 — PASSING 1, the FAR leg passes (this is the calibration figure, standing height): the NEAR leg is the straight supporting leg with the foot flat on the ground; the FAR leg passes forward with the knee bent and the foot lifted, partly hidden behind the near leg; hips and head at their highest; arms close to the body.
Figure 3 — OPPOSITE CONTACT with the FAR leg leading: the exact opposite of figure 1. The FAR leg (the leg farthest from the camera) is the leading leg, extended forward with only the heel touching the ground; the NEAR leg (closest to the camera) is the trailing leg, BEHIND the body, only its toes touching the ground, its boot clearly visible BEHIND the body. This figure must NOT be a copy of figure 1: the near boot is in FRONT in figure 1 and BEHIND in this figure. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 4 — PASSING 2, the NEAR leg passes: the FAR leg is the straight supporting leg; the NEAR leg passes forward with the knee bent and the foot clearly lifted, in FRONT of the supporting leg and fully visible to the camera; hips and head at their highest; arms close to the body. This figure must NOT be a copy of figure 2: in figure 2 the lifted foot is the far one (mostly hidden); here it is the near one (fully visible).

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 3. `erik_walk_se_r2_v01.png` — Caminhada se (A, P1, B, P2)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.

REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.

Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.

NEVER: No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.

Facing for ALL figures in this image: three-quarter front view, body and face turned toward the camera and toward screen-RIGHT at about 45 degrees.
The character walks at a normal pace; head height stays about the same. The torch is held in the RIGHT hand at hip height, flame up; the sword stays sheathed on the back.
Figure 1 — CONTACT with the NEAR leg leading (the near leg is the leg closest to the camera): the NEAR leg is the leading leg, extended forward with only the heel just touching the ground; the FAR leg is the trailing leg, behind the body with only the toes on the ground. The arm on the side opposite to the leading leg swings forward and the other arm swings back; the arm that carries the item stays steady.
Figure 2 — PASSING 1, the FAR leg passes (this is the calibration figure, standing height): the NEAR leg is the straight supporting leg with the foot flat on the ground; the FAR leg passes forward with the knee bent and the foot lifted, partly hidden behind the near leg; hips and head at their highest; arms close to the body.
Figure 3 — OPPOSITE CONTACT with the FAR leg leading: the exact opposite of figure 1. The FAR leg (the leg farthest from the camera) is the leading leg, extended forward with only the heel touching the ground; the NEAR leg (closest to the camera) is the trailing leg, BEHIND the body, only its toes touching the ground, its boot clearly visible BEHIND the body. This figure must NOT be a copy of figure 1: the near boot is in FRONT in figure 1 and BEHIND in this figure. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 4 — PASSING 2, the NEAR leg passes: the FAR leg is the straight supporting leg; the NEAR leg passes forward with the knee bent and the foot clearly lifted, in FRONT of the supporting leg and fully visible to the camera; hips and head at their highest; arms close to the body. This figure must NOT be a copy of figure 2: in figure 2 the lifted foot is the far one (mostly hidden); here it is the near one (fully visible).

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 4. `erik_walk_ne_r2_v01.png` — Caminhada ne (A, P1, B, P2)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.

REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.

Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.

NEVER: No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.

Facing for ALL figures in this image: three-quarter back view, walking away from the camera toward screen-RIGHT at about 45 degrees (face mostly hidden).
The character walks at a normal pace; head height stays about the same. The torch is held in the RIGHT hand at hip height, flame up; the sword stays sheathed on the back.
Figure 1 — CONTACT with the NEAR leg leading (the near leg is the leg closest to the camera): the NEAR leg is the leading leg, extended forward with only the heel just touching the ground; the FAR leg is the trailing leg, behind the body with only the toes on the ground. The arm on the side opposite to the leading leg swings forward and the other arm swings back; the arm that carries the item stays steady.
Figure 2 — PASSING 1, the FAR leg passes (this is the calibration figure, standing height): the NEAR leg is the straight supporting leg with the foot flat on the ground; the FAR leg passes forward with the knee bent and the foot lifted, partly hidden behind the near leg; hips and head at their highest; arms close to the body.
Figure 3 — OPPOSITE CONTACT with the FAR leg leading: the exact opposite of figure 1. The FAR leg (the leg farthest from the camera) is the leading leg, extended forward with only the heel touching the ground; the NEAR leg (closest to the camera) is the trailing leg, BEHIND the body, only its toes touching the ground, its boot clearly visible BEHIND the body. This figure must NOT be a copy of figure 1: the near boot is in FRONT in figure 1 and BEHIND in this figure. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 4 — PASSING 2, the NEAR leg passes: the FAR leg is the straight supporting leg; the NEAR leg passes forward with the knee bent and the foot clearly lifted, in FRONT of the supporting leg and fully visible to the camera; hips and head at their highest; arms close to the body. This figure must NOT be a copy of figure 2: in figure 2 the lifted foot is the far one (mostly hidden); here it is the near one (fully visible).

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 5. `erik_walk_s_r2_v01.png` — Caminhada s (A, P1, B, P2)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.

REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.

Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.

NEVER: No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.

Facing for ALL figures in this image: front view, facing the camera.
The character walks at a normal pace; head height stays about the same. The torch is held in the RIGHT hand at hip height, flame up; the sword stays sheathed on the back.
Figure 1 — CONTACT with the leg on the SCREEN-LEFT side leading: the leg on the screen-left half of the figure is the leading leg (it steps toward the camera with the heel just touching the ground when the character faces the camera, or away from the camera, appearing slightly higher on the ground, when seen from behind); the leg on the screen-right half trails with only the toes on the ground. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 2 — PASSING 1 (this is the calibration figure, standing height): the leg on the SCREEN-LEFT side is the straight supporting leg, foot flat; the leg on the SCREEN-RIGHT side passes with the knee bent and the foot lifted; hips and head at their highest; arms close to the body.
Figure 3 — OPPOSITE CONTACT with the leg on the SCREEN-RIGHT side leading: the exact opposite of figure 1 (the screen-right leg leads, the screen-left leg trails). This figure must NOT be a copy of figure 1.
Figure 4 — PASSING 2: the leg on the SCREEN-RIGHT side is the straight supporting leg, foot flat; the leg on the SCREEN-LEFT side passes with the knee bent and the foot lifted. This figure must NOT be a copy of figure 2.

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 6. `erik_walk_n_r2_v01.png` — Caminhada n (A, P1, B, P2)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.

REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.

Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.

NEVER: No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.

Facing for ALL figures in this image: back view, walking directly away from the camera.
The character walks at a normal pace; head height stays about the same. The torch is held in the RIGHT hand at hip height, flame up; the sword stays sheathed on the back.
Figure 1 — CONTACT with the leg on the SCREEN-LEFT side leading: the leg on the screen-left half of the figure is the leading leg (it steps toward the camera with the heel just touching the ground when the character faces the camera, or away from the camera, appearing slightly higher on the ground, when seen from behind); the leg on the screen-right half trails with only the toes on the ground. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 2 — PASSING 1 (this is the calibration figure, standing height): the leg on the SCREEN-LEFT side is the straight supporting leg, foot flat; the leg on the SCREEN-RIGHT side passes with the knee bent and the foot lifted; hips and head at their highest; arms close to the body.
Figure 3 — OPPOSITE CONTACT with the leg on the SCREEN-RIGHT side leading: the exact opposite of figure 1 (the screen-right leg leads, the screen-left leg trails). This figure must NOT be a copy of figure 1.
Figure 4 — PASSING 2: the leg on the SCREEN-RIGHT side is the straight supporting leg, foot flat; the leg on the SCREEN-LEFT side passes with the knee bent and the foot lifted. This figure must NOT be a copy of figure 2.

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 7. `erik_walk_w_r2_v01.png` — Caminhada w (A, P1, B, P2)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.

REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.

Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.

NEVER: No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.

Facing for ALL figures in this image: pure side view in profile, facing screen-LEFT.
The character walks at a normal pace; head height stays about the same. The torch is held in the RIGHT hand at hip height, flame up; the sword stays sheathed on the back.
Figure 1 — CONTACT with the NEAR leg leading (the near leg is the leg closest to the camera): the NEAR leg is the leading leg, extended forward with only the heel just touching the ground; the FAR leg is the trailing leg, behind the body with only the toes on the ground. The arm on the side opposite to the leading leg swings forward and the other arm swings back; the arm that carries the item stays steady.
Figure 2 — PASSING 1, the FAR leg passes (this is the calibration figure, standing height): the NEAR leg is the straight supporting leg with the foot flat on the ground; the FAR leg passes forward with the knee bent and the foot lifted, partly hidden behind the near leg; hips and head at their highest; arms close to the body.
Figure 3 — OPPOSITE CONTACT with the FAR leg leading: the exact opposite of figure 1. The FAR leg (the leg farthest from the camera) is the leading leg, extended forward with only the heel touching the ground; the NEAR leg (closest to the camera) is the trailing leg, BEHIND the body, only its toes touching the ground, its boot clearly visible BEHIND the body. This figure must NOT be a copy of figure 1: the near boot is in FRONT in figure 1 and BEHIND in this figure. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 4 — PASSING 2, the NEAR leg passes: the FAR leg is the straight supporting leg; the NEAR leg passes forward with the knee bent and the foot clearly lifted, in FRONT of the supporting leg and fully visible to the camera; hips and head at their highest; arms close to the body. This figure must NOT be a copy of figure 2: in figure 2 the lifted foot is the far one (mostly hidden); here it is the near one (fully visible).

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 8. `erik_walk_sw_r2_v01.png` — Caminhada sw (A, P1, B, P2)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.

REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.

Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.

NEVER: No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.

Facing for ALL figures in this image: three-quarter front view, body and face turned toward the camera and toward screen-LEFT at about 45 degrees.
The character walks at a normal pace; head height stays about the same. The torch is held in the RIGHT hand at hip height, flame up; the sword stays sheathed on the back.
Figure 1 — CONTACT with the NEAR leg leading (the near leg is the leg closest to the camera): the NEAR leg is the leading leg, extended forward with only the heel just touching the ground; the FAR leg is the trailing leg, behind the body with only the toes on the ground. The arm on the side opposite to the leading leg swings forward and the other arm swings back; the arm that carries the item stays steady.
Figure 2 — PASSING 1, the FAR leg passes (this is the calibration figure, standing height): the NEAR leg is the straight supporting leg with the foot flat on the ground; the FAR leg passes forward with the knee bent and the foot lifted, partly hidden behind the near leg; hips and head at their highest; arms close to the body.
Figure 3 — OPPOSITE CONTACT with the FAR leg leading: the exact opposite of figure 1. The FAR leg (the leg farthest from the camera) is the leading leg, extended forward with only the heel touching the ground; the NEAR leg (closest to the camera) is the trailing leg, BEHIND the body, only its toes touching the ground, its boot clearly visible BEHIND the body. This figure must NOT be a copy of figure 1: the near boot is in FRONT in figure 1 and BEHIND in this figure. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 4 — PASSING 2, the NEAR leg passes: the FAR leg is the straight supporting leg; the NEAR leg passes forward with the knee bent and the foot clearly lifted, in FRONT of the supporting leg and fully visible to the camera; hips and head at their highest; arms close to the body. This figure must NOT be a copy of figure 2: in figure 2 the lifted foot is the far one (mostly hidden); here it is the near one (fully visible).

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 9. `erik_walk_nw_r2_v01.png` — Caminhada nw (A, P1, B, P2)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.

REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.

Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.

NEVER: No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.

Facing for ALL figures in this image: three-quarter back view, walking away from the camera toward screen-LEFT at about 45 degrees (face mostly hidden).
The character walks at a normal pace; head height stays about the same. The torch is held in the RIGHT hand at hip height, flame up; the sword stays sheathed on the back.
Figure 1 — CONTACT with the NEAR leg leading (the near leg is the leg closest to the camera): the NEAR leg is the leading leg, extended forward with only the heel just touching the ground; the FAR leg is the trailing leg, behind the body with only the toes on the ground. The arm on the side opposite to the leading leg swings forward and the other arm swings back; the arm that carries the item stays steady.
Figure 2 — PASSING 1, the FAR leg passes (this is the calibration figure, standing height): the NEAR leg is the straight supporting leg with the foot flat on the ground; the FAR leg passes forward with the knee bent and the foot lifted, partly hidden behind the near leg; hips and head at their highest; arms close to the body.
Figure 3 — OPPOSITE CONTACT with the FAR leg leading: the exact opposite of figure 1. The FAR leg (the leg farthest from the camera) is the leading leg, extended forward with only the heel touching the ground; the NEAR leg (closest to the camera) is the trailing leg, BEHIND the body, only its toes touching the ground, its boot clearly visible BEHIND the body. This figure must NOT be a copy of figure 1: the near boot is in FRONT in figure 1 and BEHIND in this figure. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 4 — PASSING 2, the NEAR leg passes: the FAR leg is the straight supporting leg; the NEAR leg passes forward with the knee bent and the foot clearly lifted, in FRONT of the supporting leg and fully visible to the camera; hips and head at their highest; arms close to the body. This figure must NOT be a copy of figure 2: in figure 2 the lifted foot is the far one (mostly hidden); here it is the near one (fully visible).

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 10. `erik_attack_se_v01.png` — Ataque (calibração + 3 desenhos)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.

REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.

Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.

NEVER: No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.

Facing for ALL figures in this image: three-quarter front view, body and face turned toward the camera and toward screen-RIGHT at about 45 degrees.
Figure 1 — CALIBRATION: neutral standing pose facing the camera and slightly to the right, arms relaxed, feet together, holding the item (if any) in a relaxed resting carry in the same hand as in the other poses (used to match scale; keep it exact).
Figure 2 — ATTACK 1 of 3, wind-up: the torch drawn back at right-shoulder height.
Figure 3 — ATTACK 2 of 3, strike: the torch sweeps in a wide arc to the front, the small flame only as part of the torch.
Figure 4 — ATTACK 3 of 3, follow-through: the torch low on the far side, torso turned.

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 11. `erik_active_se_v01.png` — Habilidade ativa (calibração + 3 desenhos)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.

REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.

Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.

NEVER: No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.

Facing for ALL figures in this image: three-quarter front view, body and face turned toward the camera and toward screen-RIGHT at about 45 degrees.
Figure 1 — CALIBRATION: neutral standing pose facing the camera and slightly to the right, arms relaxed, feet together, holding the item (if any) in a relaxed resting carry in the same hand as in the other poses (used to match scale; keep it exact).
Figure 2 — ACTIVE ABILITY 1 of 3, crouching, the torch held low to the right.
Figure 3 — ACTIVE ABILITY 2 of 3, the torch swept along the ground in front, body lunging.
Figure 4 — ACTIVE ABILITY 3 of 3, standing up, the torch raised back to the shoulder.

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 12. `erik_death_se_v01.png` — Morte (calibração + 3 desenhos)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.

REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.

Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.

NEVER: No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.

Facing for ALL figures in this image: three-quarter front view, body and face turned toward the camera and toward screen-RIGHT at about 45 degrees.
Figure 1 — CALIBRATION: neutral standing pose facing the camera and slightly to the right, arms relaxed, feet together, holding the item (if any) in a relaxed resting carry in the same hand as in the other poses (used to match scale; keep it exact).
Figure 2 — DEATH 1 of 3, HIT: recoiling backward from a blow, head thrown back, one foot just off the ground, the held item loosening.
Figure 3 — DEATH 2 of 3, FALL: dropping to the knees, head down, the held item falling from the hand.
Figure 4 — DEATH 3 of 3, DOWN: lying collapsed on the ground on one side, eyes closed, the held item on the ground beside the hand; no blood, no gore. This figure is wide: keep it fully inside its quadrant. The torch lies on the ground beside the hand with the flame out.

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```
