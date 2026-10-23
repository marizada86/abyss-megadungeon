# Kayron — pacote de prompts (contrato r2, DRAFT)

Status: nada foi gerado. Substitui o pacote r1 (`prompts/`), que gerou as v01 e v02 do Durvall e fica como histórico. R3. Fundo: pure magenta #FF00FF. Oeste: mirror. Verificador: `r2_check_v2.gd` (tipo na última coluna). Contrato: `.atena/specs/SPEC-NOTTGARD-HERO-ART-RESET-20261021/animation-contract-r2.md`. Ficha: `.atena/vault/drafts/HERO-VISUAL-SHEETS-20261021-r1.md`.

> Decisão A1: figurino CANON pós-S24 (roupão branco). Ignore a armadura escura e a capa roxa das tiras atuais do jogo.

## Anexos (máximo 5 por pedido, nesta ordem)

**Idle:**

1. F:\dev\nottgard-vault\output\referencias-personagens\CHAR-028\pos-S24\r03-turnaround\kayron-front-v01.png
2. F:\dev\nottgard-vault\output\referencias-personagens\CHAR-028\pos-S24\r03-turnaround\kayron-left-v01.png
3. F:\dev\nottgard-vault\output\referencias-personagens\CHAR-028\pos-S24\r03-turnaround\kayron-back-v01.png
4. F:\dev\nottgard-vault\output\referencias-personagens\CHAR-028\pos-S24\r03-turnaround\kayron-right-v01.png
5. F:\dev\abyss-megadungeon\assets\enemies\zuggtmoy.png  (estilo do jogo)

**Todas as outras imagens (caminhada, ataque, ativa, morte):**

1. F:\dev\nottgard-vault\output\referencias-personagens\CHAR-028\pos-S24\r03-turnaround\kayron-front-v01.png
2. F:\dev\nottgard-vault\output\referencias-personagens\CHAR-028\pos-S24\r03-turnaround\kayron-left-v01.png
3. F:\dev\nottgard-vault\output\referencias-personagens\CHAR-028\pos-S24\r03-turnaround\kayron-back-v01.png
4. F:\dev\nottgard-vault\output\referencias-personagens\CHAR-028\pos-S24\r03-turnaround\kayron-right-v01.png
5. F:\dev\abyss-megadungeon\assets_incoming\hero-r2\kayron\kayron_idle_se_v01.png  (idle APROVADO do herói; use a versão aprovada; não anexe nenhuma caminhada)

Um herói por conversa. Salvar como `F:\dev\abyss-megadungeon\assets_incoming\hero-r2\kayron\<arquivo>`.

## Imagens (9)

| # | Arquivo | Conteúdo | Layout | Figuras | Tipo |
|---|---|---|---|---|---|
| 1 | `kayron_idle_se_v01.png` | Idle (3 desenhos, voltado para se) | 1×3 · 1536×1024 | 3 | idle |
| 2 | `kayron_walk_e_r2_v01.png` | Caminhada e (A, P1, B, P2) | 2×2 · 1536×1024 | 4 | walk4 |
| 3 | `kayron_walk_se_r2_v01.png` | Caminhada se (A, P1, B, P2) | 2×2 · 1536×1024 | 4 | walk4 |
| 4 | `kayron_walk_ne_r2_v01.png` | Caminhada ne (A, P1, B, P2) | 2×2 · 1536×1024 | 4 | walk4 |
| 5 | `kayron_walk_s_r2_v01.png` | Caminhada s (A, P1) | 1×2 · 1024×1024 | 2 | walk2 |
| 6 | `kayron_walk_n_r2_v01.png` | Caminhada n (A, P1) | 1×2 · 1024×1024 | 2 | walk2 |
| 7 | `kayron_attack_se_v01.png` | Ataque (calibração + 3 desenhos) | 2×2 · 1536×1024 | 4 | grid |
| 8 | `kayron_active_se_v01.png` | Habilidade ativa (calibração + 3 desenhos) | 2×2 · 1536×1024 | 4 | grid |
| 9 | `kayron_death_se_v01.png` | Morte (calibração + 3 desenhos) | 2×2 · 1536×1024 | 4 | grid |

### 1. `kayron_idle_se_v01.png` — Idle (3 desenhos, voltado para se)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps between figures. Draw exactly 3 full-body figures of the SAME character in ONE horizontal row, left to right, evenly spaced with at least 140 px of empty background between figures. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All figures have the same scale (about 75 percent of the canvas height) and all feet rest on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Kayron Lioran, an aasimar: a young slim man with short messy silver-white hair, pale skin, EYES COMPLETELY RED (one uniform red color over the whole eye, no white sclera and no pupil), a calm serious face. A loose white knee-length coat with wide three-quarter sleeves decorated with black tribal tattoo-like patterns on the shoulders and sleeves, an open V neckline over a black undershirt, a crimson checkered sash tied at the waist, dark patterned wraps on the forearms, loose black trousers, black boots with thin red details.

No weapon: both hands are empty.

NEVER: No armor, no cape, no purple, no weapon, no halo, no wings.

Facing for ALL figures in this image: three-quarter front view, body and face turned toward the camera and toward screen-RIGHT at about 45 degrees.
Figure 1 — REST: relaxed standing pose, facing the camera and slightly to the right, weight even on both feet (this is the calibration figure).
Figure 2 — BREATH IN: identical pose and identical feet; shoulders and chest raised by only 2 to 3 px; cloth and hair shift by a hair's width.
Figure 3 — BREATH OUT: identical pose and identical feet; shoulders and chest settled slightly lower than REST; cloth and hair shift slightly the other way.
The three figures must be almost identical; only the tiny breathing and cloth/hair differences described. Same feet placement in all three.

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 2. `kayron_walk_e_r2_v01.png` — Caminhada e (A, P1, B, P2)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Kayron Lioran, an aasimar: a young slim man with short messy silver-white hair, pale skin, EYES COMPLETELY RED (one uniform red color over the whole eye, no white sclera and no pupil), a calm serious face. A loose white knee-length coat with wide three-quarter sleeves decorated with black tribal tattoo-like patterns on the shoulders and sleeves, an open V neckline over a black undershirt, a crimson checkered sash tied at the waist, dark patterned wraps on the forearms, loose black trousers, black boots with thin red details.

No weapon: both hands are empty.

NEVER: No armor, no cape, no purple, no weapon, no halo, no wings.

Facing for ALL figures in this image: pure side view in profile, facing screen-RIGHT.
The character walks at a normal pace; head height stays about the same. Both hands empty and relaxed; the loose sleeves and sash sway.
Figure 1 — CONTACT with the NEAR leg leading (the near leg is the leg closest to the camera): the NEAR leg is the leading leg, extended forward with only the heel just touching the ground; the FAR leg is the trailing leg, behind the body with only the toes on the ground. The arm on the side opposite to the leading leg swings forward and the other arm swings back; the arm that carries the item stays steady.
Figure 2 — PASSING 1, the FAR leg passes (this is the calibration figure, standing height): the NEAR leg is the straight supporting leg with the foot flat on the ground; the FAR leg passes forward with the knee bent and the foot lifted, partly hidden behind the near leg; hips and head at their highest; arms close to the body.
Figure 3 — OPPOSITE CONTACT with the FAR leg leading: the exact opposite of figure 1. The FAR leg (the leg farthest from the camera) is the leading leg, extended forward with only the heel touching the ground; the NEAR leg (closest to the camera) is the trailing leg, BEHIND the body, only its toes touching the ground, its boot clearly visible BEHIND the body. This figure must NOT be a copy of figure 1: the near boot is in FRONT in figure 1 and BEHIND in this figure. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 4 — PASSING 2, the NEAR leg passes: the FAR leg is the straight supporting leg; the NEAR leg passes forward with the knee bent and the foot clearly lifted, in FRONT of the supporting leg and fully visible to the camera; hips and head at their highest; arms close to the body. This figure must NOT be a copy of figure 2: in figure 2 the lifted foot is the far one (mostly hidden); here it is the near one (fully visible).

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 3. `kayron_walk_se_r2_v01.png` — Caminhada se (A, P1, B, P2)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Kayron Lioran, an aasimar: a young slim man with short messy silver-white hair, pale skin, EYES COMPLETELY RED (one uniform red color over the whole eye, no white sclera and no pupil), a calm serious face. A loose white knee-length coat with wide three-quarter sleeves decorated with black tribal tattoo-like patterns on the shoulders and sleeves, an open V neckline over a black undershirt, a crimson checkered sash tied at the waist, dark patterned wraps on the forearms, loose black trousers, black boots with thin red details.

No weapon: both hands are empty.

NEVER: No armor, no cape, no purple, no weapon, no halo, no wings.

Facing for ALL figures in this image: three-quarter front view, body and face turned toward the camera and toward screen-RIGHT at about 45 degrees.
The character walks at a normal pace; head height stays about the same. Both hands empty and relaxed; the loose sleeves and sash sway.
Figure 1 — CONTACT with the NEAR leg leading (the near leg is the leg closest to the camera): the NEAR leg is the leading leg, extended forward with only the heel just touching the ground; the FAR leg is the trailing leg, behind the body with only the toes on the ground. The arm on the side opposite to the leading leg swings forward and the other arm swings back; the arm that carries the item stays steady.
Figure 2 — PASSING 1, the FAR leg passes (this is the calibration figure, standing height): the NEAR leg is the straight supporting leg with the foot flat on the ground; the FAR leg passes forward with the knee bent and the foot lifted, partly hidden behind the near leg; hips and head at their highest; arms close to the body.
Figure 3 — OPPOSITE CONTACT with the FAR leg leading: the exact opposite of figure 1. The FAR leg (the leg farthest from the camera) is the leading leg, extended forward with only the heel touching the ground; the NEAR leg (closest to the camera) is the trailing leg, BEHIND the body, only its toes touching the ground, its boot clearly visible BEHIND the body. This figure must NOT be a copy of figure 1: the near boot is in FRONT in figure 1 and BEHIND in this figure. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 4 — PASSING 2, the NEAR leg passes: the FAR leg is the straight supporting leg; the NEAR leg passes forward with the knee bent and the foot clearly lifted, in FRONT of the supporting leg and fully visible to the camera; hips and head at their highest; arms close to the body. This figure must NOT be a copy of figure 2: in figure 2 the lifted foot is the far one (mostly hidden); here it is the near one (fully visible).

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 4. `kayron_walk_ne_r2_v01.png` — Caminhada ne (A, P1, B, P2)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Kayron Lioran, an aasimar: a young slim man with short messy silver-white hair, pale skin, EYES COMPLETELY RED (one uniform red color over the whole eye, no white sclera and no pupil), a calm serious face. A loose white knee-length coat with wide three-quarter sleeves decorated with black tribal tattoo-like patterns on the shoulders and sleeves, an open V neckline over a black undershirt, a crimson checkered sash tied at the waist, dark patterned wraps on the forearms, loose black trousers, black boots with thin red details.

No weapon: both hands are empty.

NEVER: No armor, no cape, no purple, no weapon, no halo, no wings.

Facing for ALL figures in this image: three-quarter back view, walking away from the camera toward screen-RIGHT at about 45 degrees (face mostly hidden).
The character walks at a normal pace; head height stays about the same. Both hands empty and relaxed; the loose sleeves and sash sway.
Figure 1 — CONTACT with the NEAR leg leading (the near leg is the leg closest to the camera): the NEAR leg is the leading leg, extended forward with only the heel just touching the ground; the FAR leg is the trailing leg, behind the body with only the toes on the ground. The arm on the side opposite to the leading leg swings forward and the other arm swings back; the arm that carries the item stays steady.
Figure 2 — PASSING 1, the FAR leg passes (this is the calibration figure, standing height): the NEAR leg is the straight supporting leg with the foot flat on the ground; the FAR leg passes forward with the knee bent and the foot lifted, partly hidden behind the near leg; hips and head at their highest; arms close to the body.
Figure 3 — OPPOSITE CONTACT with the FAR leg leading: the exact opposite of figure 1. The FAR leg (the leg farthest from the camera) is the leading leg, extended forward with only the heel touching the ground; the NEAR leg (closest to the camera) is the trailing leg, BEHIND the body, only its toes touching the ground, its boot clearly visible BEHIND the body. This figure must NOT be a copy of figure 1: the near boot is in FRONT in figure 1 and BEHIND in this figure. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 4 — PASSING 2, the NEAR leg passes: the FAR leg is the straight supporting leg; the NEAR leg passes forward with the knee bent and the foot clearly lifted, in FRONT of the supporting leg and fully visible to the camera; hips and head at their highest; arms close to the body. This figure must NOT be a copy of figure 2: in figure 2 the lifted foot is the far one (mostly hidden); here it is the near one (fully visible).

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 5. `kayron_walk_s_r2_v01.png` — Caminhada s (A, P1)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1024x1024, square. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gap between the figures. Draw exactly 2 full-body figures of the SAME character side by side, left to right, with at least 140 px of empty background between them. Neither figure touches the other or the canvas edge, and each is completely visible including item, hair and cloth. Both figures have the same scale (about 75 percent of the canvas height) and both stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Kayron Lioran, an aasimar: a young slim man with short messy silver-white hair, pale skin, EYES COMPLETELY RED (one uniform red color over the whole eye, no white sclera and no pupil), a calm serious face. A loose white knee-length coat with wide three-quarter sleeves decorated with black tribal tattoo-like patterns on the shoulders and sleeves, an open V neckline over a black undershirt, a crimson checkered sash tied at the waist, dark patterned wraps on the forearms, loose black trousers, black boots with thin red details.

No weapon: both hands are empty.

NEVER: No armor, no cape, no purple, no weapon, no halo, no wings.

Facing for ALL figures in this image: front view, facing the camera.
The character walks at a normal pace; head height stays about the same. Both hands empty and relaxed; the loose sleeves and sash sway.
Figure 1 — CONTACT with the leg on the SCREEN-LEFT side leading: the leg on the screen-left half of the figure is the leading leg (it steps toward the camera with the heel just touching the ground when the character faces the camera, or away from the camera, appearing slightly higher on the ground, when seen from behind); the leg on the screen-right half trails with only the toes on the ground. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 2 — PASSING 1 (this is the calibration figure, standing height): the leg on the SCREEN-LEFT side is the straight supporting leg, foot flat; the leg on the SCREEN-RIGHT side passes with the knee bent and the foot lifted; hips and head at their highest; arms close to the body.
(The opposite contact and the second passing are produced later by mirroring figures 1 and 2, so only two figures are drawn.)

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 6. `kayron_walk_n_r2_v01.png` — Caminhada n (A, P1)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1024x1024, square. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gap between the figures. Draw exactly 2 full-body figures of the SAME character side by side, left to right, with at least 140 px of empty background between them. Neither figure touches the other or the canvas edge, and each is completely visible including item, hair and cloth. Both figures have the same scale (about 75 percent of the canvas height) and both stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Kayron Lioran, an aasimar: a young slim man with short messy silver-white hair, pale skin, EYES COMPLETELY RED (one uniform red color over the whole eye, no white sclera and no pupil), a calm serious face. A loose white knee-length coat with wide three-quarter sleeves decorated with black tribal tattoo-like patterns on the shoulders and sleeves, an open V neckline over a black undershirt, a crimson checkered sash tied at the waist, dark patterned wraps on the forearms, loose black trousers, black boots with thin red details.

No weapon: both hands are empty.

NEVER: No armor, no cape, no purple, no weapon, no halo, no wings.

Facing for ALL figures in this image: back view, walking directly away from the camera.
The character walks at a normal pace; head height stays about the same. Both hands empty and relaxed; the loose sleeves and sash sway.
Figure 1 — CONTACT with the leg on the SCREEN-LEFT side leading: the leg on the screen-left half of the figure is the leading leg (it steps toward the camera with the heel just touching the ground when the character faces the camera, or away from the camera, appearing slightly higher on the ground, when seen from behind); the leg on the screen-right half trails with only the toes on the ground. The arm opposite to the leading leg swings forward; the item arm stays steady.
Figure 2 — PASSING 1 (this is the calibration figure, standing height): the leg on the SCREEN-LEFT side is the straight supporting leg, foot flat; the leg on the SCREEN-RIGHT side passes with the knee bent and the foot lifted; hips and head at their highest; arms close to the body.
(The opposite contact and the second passing are produced later by mirroring figures 1 and 2, so only two figures are drawn.)

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 7. `kayron_attack_se_v01.png` — Ataque (calibração + 3 desenhos)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Kayron Lioran, an aasimar: a young slim man with short messy silver-white hair, pale skin, EYES COMPLETELY RED (one uniform red color over the whole eye, no white sclera and no pupil), a calm serious face. A loose white knee-length coat with wide three-quarter sleeves decorated with black tribal tattoo-like patterns on the shoulders and sleeves, an open V neckline over a black undershirt, a crimson checkered sash tied at the waist, dark patterned wraps on the forearms, loose black trousers, black boots with thin red details.

No weapon: both hands are empty.

NEVER: No armor, no cape, no purple, no weapon, no halo, no wings.

Facing for ALL figures in this image: three-quarter front view, body and face turned toward the camera and toward screen-RIGHT at about 45 degrees.
Figure 1 — CALIBRATION: neutral standing pose facing the camera and slightly to the right, arms relaxed, feet together, holding the item (if any) in a relaxed resting carry in the same hand as in the other poses (used to match scale; keep it exact).
Figure 2 — ATTACK 1 of 3, wind-up: the arms drawn in, crossed at the chest.
Figure 3 — ATTACK 2 of 3, strike: the arms flung wide, head raised, wide stance.
Figure 4 — ATTACK 3 of 3, follow-through: the arms still wide, the body slightly arched.

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 8. `kayron_active_se_v01.png` — Habilidade ativa (calibração + 3 desenhos)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Kayron Lioran, an aasimar: a young slim man with short messy silver-white hair, pale skin, EYES COMPLETELY RED (one uniform red color over the whole eye, no white sclera and no pupil), a calm serious face. A loose white knee-length coat with wide three-quarter sleeves decorated with black tribal tattoo-like patterns on the shoulders and sleeves, an open V neckline over a black undershirt, a crimson checkered sash tied at the waist, dark patterned wraps on the forearms, loose black trousers, black boots with thin red details.

No weapon: both hands are empty.

NEVER: No armor, no cape, no purple, no weapon, no halo, no wings.

Facing for ALL figures in this image: three-quarter front view, body and face turned toward the camera and toward screen-RIGHT at about 45 degrees.
Figure 1 — CALIBRATION: neutral standing pose facing the camera and slightly to the right, arms relaxed, feet together, holding the item (if any) in a relaxed resting carry in the same hand as in the other poses (used to match scale; keep it exact).
Figure 2 — ACTIVE ABILITY 1 of 3, fists clenched at the hips, chin down.
Figure 3 — ACTIVE ABILITY 2 of 3, fists raised at the shoulders, shoulders squared.
Figure 4 — ACTIVE ABILITY 3 of 3, head thrown back, fists pulled down and back (power-up pose).

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

### 9. `kayron_death_se_v01.png` — Morte (calibração + 3 desenhos)

```text
Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.

CHARACTER (identity authority: the attached canon views; they win over any other description): Kayron Lioran, an aasimar: a young slim man with short messy silver-white hair, pale skin, EYES COMPLETELY RED (one uniform red color over the whole eye, no white sclera and no pupil), a calm serious face. A loose white knee-length coat with wide three-quarter sleeves decorated with black tribal tattoo-like patterns on the shoulders and sleeves, an open V neckline over a black undershirt, a crimson checkered sash tied at the waist, dark patterned wraps on the forearms, loose black trousers, black boots with thin red details.

No weapon: both hands are empty.

NEVER: No armor, no cape, no purple, no weapon, no halo, no wings.

Facing for ALL figures in this image: three-quarter front view, body and face turned toward the camera and toward screen-RIGHT at about 45 degrees.
Figure 1 — CALIBRATION: neutral standing pose facing the camera and slightly to the right, arms relaxed, feet together, holding the item (if any) in a relaxed resting carry in the same hand as in the other poses (used to match scale; keep it exact).
Figure 2 — DEATH 1 of 3, HIT: recoiling backward from a blow, head thrown back, one foot just off the ground, the arms flung out.
Figure 3 — DEATH 2 of 3, FALL: dropping to the knees, head down, the hands dropping to the ground.
Figure 4 — DEATH 3 of 3, DOWN: lying collapsed on the ground on one side, eyes closed, one arm stretched out on the ground; no blood, no gore. This figure is wide: keep it fully inside its quadrant.

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```
