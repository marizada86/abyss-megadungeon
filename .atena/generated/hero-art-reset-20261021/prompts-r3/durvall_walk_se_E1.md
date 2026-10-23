# E1 — Durvall walk SE, contrato r3 (prompt, DRAFT, 2026-10-22)

Status: **nada foi gerado.** Preparado por autorização do dono em 2026-10-22. Contrato: `.atena/specs/SPEC-NOTTGARD-HERO-ART-RESET-20261021/animation-contract-r3.md`. Roteiro: `r2-roteiro-r3.md`. Verificador: `r2_check_v3.gd`. Este é o **experimento E1** (1 geração, das 4 do teto). O texto de identidade, item e proibições é o mesmo do pacote r2 do Durvall; só mudam o formato (fila de 3), o guia de pose e as poses.

## Anexos (exatamente 5, nesta ordem)

1. `F:\dev\nottgard-vault\output\referencias-personagens\CHAR-015\historico-S01-S09\r01\durvall-front-candidate-v01.png`
2. `F:\dev\nottgard-vault\output\referencias-personagens\CHAR-015\historico-S01-S09\r01\durvall-left-v01.png`
3. `F:\dev\nottgard-vault\output\referencias-personagens\CHAR-015\historico-S01-S09\r01\durvall-back-v01.png`
4. `F:\dev\abyss-megadungeon\assets_incoming\hero-r2\durvall\durvall_idle_se_v01.png` (idle APROVADO)
5. `F:\dev\abyss-megadungeon\assets_incoming\hero-r2\guides\pose_guide_walk_se_A_P1_P2_r3.png` (guia de pose)

A vista direita do Durvall sai desta vez para caber o guia. **Não anexe nenhuma caminhada anterior.** Conversa nova.

## Salvar como

`F:\dev\abyss-megadungeon\assets_incoming\hero-r2\durvall\durvall_walk_se_r3_E1_v01.png` (PNG sem editar; nome novo, não sobrescreve nada).

## Prompt (cole inteiro)

```text
Dark-fantasy 2D game character illustration in the exact style of the approved idle image (attached image 4): dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.

Canvas 1536x1024, landscape. Perfectly uniform flat pure magenta #FF00FF background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps between figures. Draw exactly 3 full-body figures of the SAME character in ONE horizontal row, left to right. Each figure stands inside its own third of the canvas (512 px wide) with at least 60 px of empty margin on every side; no figure touches another figure, the edge of its third or the canvas edge, and every figure is completely visible including sword, hair and cloth. All figures have the same scale (about 75 percent of the canvas height) and the foot that stands on the ground rests on the same invisible horizontal ground line in all three.

CHARACTER (identity authority: the attached canon views; they win over any other description): Durvall, a tall, lean male drow, about 1.9 m: blue-gray skin, long straight white hair falling past the shoulder blades, pointed ears, a stern angular face with a calm closed expression. Black plate armor made of overlapping leaf-shaped segments with sharp points, spiked pauldrons, pointed greaves and plate gauntlets. A torn dark-red sash tied at the waist with a ragged red cloth hanging from it (seen from the front, the cloth hangs on the screen-left hip). Slender, athletic build.

Item (game weapon, not in the canon views): a straight black-steel longsword with a plain cold edge highlight (no glow), held in the RIGHT hand.

NEVER: No helmet, no glowing eyes, no cape, no tentacles, no black ooze or sludge, no extra weapons, no ghostly or divine imagery.

POSE GUIDE (attached image 5): it is made of stick figures and it is NOT a character reference. It shows, for the three figures in the same left-to-right order and layout, the exact positions of the legs and feet. Red = the leg NEAREST the camera (drawn on top), blue = the leg FARTHEST from the camera (behind it). Reproduce the leg, knee and foot positions and the foot heights of the guide for each figure, redrawn as Durvall. Do NOT draw the stick figures, the red and blue colors, the guide background or any line of the guide.

Facing for ALL figures in this image: three-quarter front view, body and face turned toward the camera and toward screen-RIGHT at about 45 degrees. The character walks at a normal pace; head height stays about the same. The sword is carried in the RIGHT hand, point down and slightly back, held low and steady exactly as in the approved idle (attached image 4); it does not swing.

Figure 1 — CONTACT (matches the left stick figure of the guide): a wide stride. The leg nearest the camera is the leading leg, stepping forward to the screen-RIGHT with only the heel just touching the ground; the leg farthest from the camera is the trailing leg, behind the body toward the screen-LEFT with only the toes touching the ground. The two feet are about 45 percent of the figure height apart. The arm opposite to the leading leg swings forward; the sword arm stays steady.
Figure 2 — PASSING 1 (matches the middle stick figure of the guide; this is the calibration figure, standing height): the leg nearest the camera is the straight supporting leg, foot flat on the ground. The leg farthest from the camera is lifted: its foot is raised to about mid-shin height of the supporting leg and held RIGHT NEXT TO the supporting ankle (neither behind the body nor ahead of it), with the knee bent and pointing forward to the screen-RIGHT. The two feet are almost together; hips and head at their highest; arms close to the body. This is NOT a kick backward and NOT a high step forward.
Figure 3 — PASSING 2 (matches the right stick figure of the guide): the same passing pose with the legs exchanged. The leg farthest from the camera is the straight supporting leg, foot flat on the ground. The leg nearest the camera is lifted, drawn in FRONT of the supporting leg and fully visible: its foot is raised to about mid-shin height and held right next to the supporting ankle, knee bent and pointing forward to the screen-RIGHT. The two feet are almost together; hips and head at their highest. This figure must NOT be a copy of figure 2: in figure 2 the lifted leg is the far one (mostly hidden behind the support leg); here it is the near one (fully visible in front).

No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.
```

## Depois de gerar

Diga "mede o E1 do Durvall". Eu rodo o verificador v3, o recorte das pernas e a prévia animada (A, P1, A, P2) e respondo com o veredito. Se o resultado não seguir o guia, **não refaça**: o E2 (uma pose por imagem, editando o idle) é decisão sua e eu preparo o prompt antes.
