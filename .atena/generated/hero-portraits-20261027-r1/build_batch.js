// PLAN-ABYSS-HERO-PORTRAITS-20261027 · S-P06: gera um arquivo de colar no ChatGPT por herói (HUD + Ficha) e copia as referências.
// Uso: node .atena/generated/hero-portraits-20261027-r1/build_batch.js
// Saída: colar/<id>.md, colar/INDEX.md; referências em .atena/generated/art-candidates/hero-portraits-r1-refs/<id>/ (pasta ignorada pelo git).
const fs = require("fs");
const path = require("path");
const ROOT = path.resolve(__dirname, "../../..");
const VAULT = "F:/dev/nottgard-vault/output/referencias-personagens/";
const OUT = path.join(__dirname, "colar");
const REFS = path.join(ROOT, ".atena/generated/art-candidates/hero-portraits-r1-refs");
const INCOMING = "assets_incoming/hero-portraits-r1";
const STYLE_GAME = "assets/enemies/zuggtmoy.png";

const H = [
  {
    id: "arlindo", name: "Arlindo Orlando", dir: "CHAR-005/S03-S09-andarilho/refhq-r01/",
    front: "orlando-front-candidate-v01.png", left: "arlindo-orlando-left-candidate-v01.png",
    character: "Arlindo Orlando, a lean middle-aged human man with short gray hair and short gray stubble, a weathered face; a brown felt fedora, a dark-red scarf, a long dark-brown wool coat, a vest, dark leather gloves, brown trousers and boots.",
    never: "No weapon, no glow in the hands, no memory imagery drawn.",
    hud: "The head in the brown felt fedora fills about 62 percent of the canvas height; the dark-red scarf and the wool coat collar fill the bottom. Weary, watchful, knowing expression with a faint half-frown, eyes fixed on the viewer.",
    hudBg: "very dark warm brown-black, nearly flat, with a faint dusty amber halo behind the hat",
    scene: "a lonely dirt road at dusk at the edge of a mist-covered ruined town: a leaning wooden signpost, a gnarled dead tree, low gray fog, a thin amber line of sky on the horizon; cold blue-gray overall",
    pose: "standing at the roadside, relaxed, one gloved hand holding the lapel of his coat, the other hanging at his side, eyes looking toward the right of the frame",
    item: "",
  },
  {
    id: "bromnor", name: "Bromnor Martelo da Luz", dir: "CHAR-010/historico-em-vida/r01/",
    front: "bromnor-front-candidate-v01.png", left: "bromnor-left-v01.png", expr: "bromnor-expressions-v01.png",
    character: "Bromnor Martelo da Luz, a dwarf, broad and powerful: a long white braided beard down to the chest, long white hair tied back, thick brows. Ornate gold plate armor with rune-like geometric patterns, huge pauldrons, a royal-blue tabard with gold borders, gold knee plates, heavy gold-trimmed boots.",
    item: "The Hammer of Light, a single large one-handed warhammer with a golden head and a pale-white inlay (painted on the metal, not a glow), held low in the RIGHT hand with the head resting on the floor beside his boot.",
    never: "ONE hammer only. No ghost, no spirit, no transparency, no wounds, no blood, no light effect.",
    hud: "The head with the long white braided beard fills about 66 percent of the canvas height; the huge gold pauldrons and the top of the blue tabard are visible at the bottom corners. Stern but benevolent authority, steady gaze at the viewer.",
    hudBg: "very dark warm brown-black, nearly flat, with a faint dim gold halo behind the head",
    scene: "a dwarven stone forge hall: thick rune-carved pillars, a heavy anvil on the left, the glow of a distant forge and a few drifting embers as the only warm light, smoky air, a flagstone floor",
    pose: "standing firmly, broad and grounded, weight even on both feet, chin level, looking toward the right of the frame",
  },
  {
    id: "brook", name: "Brook França", dir: "CHAR-011/S03-S09/r01/",
    front: "brook-front-candidate-v01.png", left: "brook-left-v01.png", expr: "brook-expressions-v01.png",
    character: "Brook França, short and stocky (halfling proportions, about 1.2 m, a large head on a broad body), about 53 years old: voluminous wavy white hair, a short trimmed white beard and mustache, pointed ears, a weathered stern face. Full riveted steel plate armor over mail, large round shoulder discs, knee guards, plate boots, a wide brown belt; a tattered dark-crimson cape hanging from the shoulders to the knees.",
    never: "No mace, no hammer (the hammer of Bromnor is not his), no shield, no holy-symbol prop, no glow.",
    hud: "The head with the voluminous white hair and short white beard fills about 66 percent of the canvas height; the riveted plate collar and the round shoulder discs fill the bottom corners, with a hint of the crimson cape. Severe, resolute expression, eyes fixed on the viewer.",
    hudBg: "very dark blue-black, nearly flat, with a faint cold halo behind the white hair",
    scene: "a stone castle rampart at dawn, fog rolling in the valley behind, tattered crimson banners on the battlements, a pale cold sky with a thin warm line at the horizon",
    pose: "standing proudly with a wide stance, fists at his sides (the right hand closed, the left hand open, both EMPTY), chin up, looking toward the right of the frame; the crimson cape hangs behind him",
    item: "",
  },
  {
    id: "erik", name: "Erik Blackthorn", dir: "EEEE-r01/", front: "fronts/erik-front-v01.png", left: "views/erik-left-v01.png", back: "views/erik-back-v01.png", right: "../B-FALT-005-04/r01/erik-right-candidate-v01.png",
    character: "Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.",
    item: "A wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand low at his side.",
    never: "No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.",
    hud: "The bald head fills about 62 percent of the canvas height; the gray-green cowl around the neck, the fur shoulder pads and a hint of the golden amulet disc fill the bottom. Alert, wry half-smile, one eyebrow slightly raised, eyes fixed on the viewer. A faint warm orange rim light from the right edge of the frame only (no visible fire).",
    hudBg: "very dark brown-black, nearly flat, with a faint warm orange glow behind the head on the right",
    scene: "burned harbor docks at night: charred wooden piers, a wrecked ship burning far in the background, orange reflections on black water, drifting smoke far away, a cold dark sky",
    pose: "standing on the pier, weight on the back foot, torch held low at his side with the flame lighting his face a little from below, head slightly turned, looking toward the right of the frame; the sword hilt rises above his right shoulder",
  },
  {
    id: "kayron", name: "Kayron Lioran", dir: "CHAR-028/pos-S24/r03-turnaround/", front: "kayron-front-v01.png", left: "kayron-left-v01.png", back: "kayron-back-v01.png", right: "kayron-right-v01.png",
    character: "Kayron Lioran, an aasimar: a young slim man with short messy silver-white hair, pale skin, EYES COMPLETELY RED (one uniform red color over the whole eye, no white sclera and no pupil), a calm serious face. A loose white knee-length coat with wide three-quarter sleeves decorated with black tribal tattoo-like patterns on the shoulders and sleeves, an open V neckline over a black undershirt, a crimson checkered sash tied at the waist, dark patterned wraps on the forearms, loose black trousers, black boots with thin red details.",
    never: "No armor, no cape, no purple, no weapon, no halo, no wings.",
    hud: "The head with the short messy silver-white hair fills about 66 percent of the canvas height; the open V neckline of the white coat and the black tribal patterns on the shoulders fill the bottom corners. Calm, serious, unblinking gaze; the uniformly red eyes (no pupil, no white) are the focal point. Keep the red limited to the eyes.",
    hudBg: "very dark blue-black, nearly flat, with a faint dim cold halo behind the head",
    scene: "a chamber of black stone whose walls are covered with faint carved abyssal script and rows of narrow glyphs, a few small red candles on the floor far to each side, cold dim light, thin dust in the air",
    pose: "standing calmly, hands relaxed at his sides, face turned slightly up toward the carved wall on the right of the frame as if reading it; the wide white sleeves and the crimson sash are clearly visible",
    item: "",
  },
  {
    id: "korrak", name: "Korrak Nammat", dir: "CHAR-030/S10-S12/r01/",
    front: "korrak-front-candidate-v01.png", left: "korrak-left-v01.png", expr: "korrak-expressions-v01.png",
    character: "Korrak, a goliath, about 2.3 m, enormously muscled: stone-gray skin with faint darker veins like granite; shaved head with a dark crest of hair along the center, a full black beard, heavy brow. A rivet-studded brown leather cuirass with a diagonal strap, a spiked steel pauldron on his LEFT shoulder and a thick tawny fur mantle on his RIGHT shoulder, studded leather bracers, a wide belt with a round buckle disc, a skirt of ragged leather strips, tall wrapped boots with fur cuffs.",
    item: "The Axe of Xar'gath, a huge two-handed battle axe with a black iron head whose lava-like orange-red cracks are painted on the metal (not an effect) and a long dark wooden haft, held with both hands, the axe head resting on the ground in front of him.",
    never: "No helmet, no armor change, no flames or sparks around the axe, no second weapon.",
    hud: "The head with the dark crest and the full black beard fills about 62 percent of the canvas height; the spiked pauldron (screen-left side as in the canon front view) and the fur mantle fill the bottom corners. Fierce, stoic stare with a heavy brow, jaw clenched, eyes fixed on the viewer.",
    hudBg: "very dark gray-brown, nearly flat, with a faint dim ember-orange rim behind the head",
    scene: "a rocky mountain pass under an ash-gray sky, broken war banners on spears planted in the ground, gray boulders on both sides, a few distant torch glows, wind-blown ash",
    pose: "standing planted and heavy, both hands on the haft in front of him, head lowered a little, glaring toward the right of the frame",
  },
  {
    id: "leoric", name: "Leoric", dir: "CHAR-033/S10-S12/r01/",
    front: "leoric-front-candidate-v01.png", left: "leoric-left-v02.png", expr: "leoric-expressions-v01.png",
    character: "Leoric, a male gnome about 1 m tall, 45 years old: pointed ears, a long full gray beard and mustache, bushy brows, a black top hat with a copper band, a long brown leather trench coat with brass buttons and shoulder epaulettes, a dark vest, a belt with small pouches, dark trousers, buckled boots.",
    item: "A small spiral conch shell, pale cream with faint gold star flecks, the size of his palm, carried in the RIGHT hand at belt height.",
    never: "No staff, no cane, no wand, no glow, no stars drawn around him.",
    hud: "The face under the black top hat with the copper band fills about 62 percent of the canvas height, the long gray beard reaching the bottom edge, the trench coat collar and brass buttons at the bottom corners. Warm, sly, good-humored expression with bushy brows slightly raised, eyes fixed on the viewer.",
    hudBg: "very dark green-blue night tone, nearly flat, with a faint cool halo behind the hat",
    scene: "a moonlit forest clearing at night: enormous ancient tree trunks and giant roots that dwarf him, pale mist between the trunks, a starry sky through the canopy, a few small ferns; cool blue-green palette",
    pose: "standing, upright and jaunty, the conch held in his right hand at belt height, the left hand touching the brim of his hat, looking toward the right of the frame",
  },
  {
    id: "maelor", name: "Maelor Menezes", dir: "CHAR-035/S01-S09/r01/",
    front: "maelor-front-candidate-v01.png", left: "maelor-left-v01.png", expr: "maelor-expressions-v01.png",
    character: "Maelor Menezes, a young half-elf man (slightly pointed ears), copper-auburn hair swept back to the nape, clean-shaven, a kind but focused face. A long white coat with blue side panels and gold trim, a tall stiff gold collar, white shoulder pads, a brown leather satchel on the LEFT hip, leather knee guards, brown boots, brown leather gloves.",
    never: "No blue flame, no glowing hands, no light effect drawn, no staff, no holy symbol.",
    hud: "The head with the copper-auburn hair fills about 62 percent of the canvas height; the tall stiff gold collar and the white shoulder pads fill the bottom. Kind but focused expression, a calm steady gaze at the viewer.",
    hudBg: "very dark navy, nearly flat, with a faint warm golden-white halo behind the head (background only)",
    scene: "the inside of a pale stone shrine: tall arched windows letting long shafts of golden-white light fall across the flagstone floor, floating dust, stone pillars and simple wooden benches in soft shadow",
    pose: "standing in one shaft of light, the right hand open at chest height with the palm up and EMPTY (no light drawn in it), the other hand at his side, looking toward the right of the frame; the satchel is visible on his left hip",
    item: "",
  },
  {
    id: "nyrelia", name: "Nyrelia", dir: "ACHADOS-TRES-20261018-r1/", front: "nyrelia-front-v01.png",
    character: "Nyrelia: a tall hooded figure, the face completely hidden behind a smooth dark metal mask (no eyes visible, no skin visible); a deep green ragged hooded cloak with fringed edges, a green scarf with gold tassels, a black dress with a gold embroidered sash, dark gloves, black boots with gold buckles.",
    never: "Never show the face, skin, eyes or any trait that reveals her species. No weapon. No yellow aura drawn (the game draws it).",
    hud: "The hooded head with the smooth dark metal mask fills about 66 percent of the canvas height, centered, facing the camera; the fringed hood edge, the green scarf with its gold tassels and the cloak shoulders fill the bottom. Still, composed, unreadable presence; the mask has no eye holes visible and no skin shows. Only one view of this character exists, so keep the head facing the camera.",
    hudBg: "very dark green-black, nearly flat, with a faint dim halo behind the hood",
    scene: "a damp underground stone cellar used as a hideout: hanging lanterns with small warm flames, stacked crates and barrels, a rough stone arch, drifting mist, deep green-black shadows",
    pose: "standing nearly front-on, only slightly turned toward the right of the frame, hands folded in front of her, the fringed cloak hanging heavy; the face stays hidden behind the mask. Only one canon view exists, so keep the pose close to it",
    item: "",
  },
  {
    id: "sylas", name: "Sylas Malafaia", dir: "CHAR-051/S01-S09/r01/",
    front: "sylas-front-candidate-v01.png", left: "sylas-left-v01.png", expr: "sylas-expressions-v01.png",
    character: "Sylas Malafaia, a tiefling: tall curved black horns sweeping up from a black hood, a smooth dark mask covering the whole lower face and brow with glowing violet eyes, pointed ears, a black robe-tabard with magenta-violet interlaced trim along the hems, dark pauldrons, black plate gauntlets, a belt with a metal buckle, black boots with violet details.",
    never: "No daggers, no blades, no wings, no tail, no visible skin on the face, no glow beyond the eyes.",
    hud: "The hooded head with the curved horns fills about 70 percent of the canvas height, with BOTH horn tips fully inside the frame; the dark mask and the two glowing violet eyes are the focal point; the pauldrons and the magenta-violet trim of the robe fill the bottom corners. Calm, cold, unreadable stare at the viewer.",
    hudBg: "very dark blue-black, nearly flat, with a faint cool gray halo behind the hood to separate the black hood from the dark",
    scene: "a rain-wet cobblestone alley in a ruined city at night: leaning broken walls on both sides, one dim hanging lantern, puddles reflecting a little violet-tinged light, thin mist; very dark palette",
    pose: "standing in the alley, relaxed and silent, arms loose at his sides, head slightly turned, looking toward the right of the frame; the horns and the hood are clearly readable against the lighter wall behind",
    item: "",
  },
  {
    id: "zynara", name: "Zynara Vellen", dir: "CHAR-066/S01-S03-conselheira/r01/",
    front: "zynara-front-candidate-v01.png", left: "zynara-left-v01.png", expr: "zynara-expressions-v01.png",
    character: "Zynara Vellen, a tall elf woman: long wavy silver hair to the waist, long pointed ears, a small gold circlet on the forehead, a pale face with a cold composed gaze. A long black high-collar dress under a long black cloak, both with gold embroidered leaf patterns along the hems and chest, a slim belt, black heeled boots.",
    item: "The Hourglass of Eternal Silence, a hand-sized hourglass of dark metal and glass with pale sand, held upright in the RIGHT hand at chest height.",
    never: "No glow, no floating particles of sand, no extra props, no crown.",
    hud: "The head with the long wavy silver hair, the long pointed ears and the small gold circlet fills about 62 percent of the canvas height; the high collar with gold leaf embroidery fills the bottom. Cold, composed, evaluating gaze at the viewer.",
    hudBg: "very dark blue-black, nearly flat, with a faint pale moonlit halo behind the silver hair",
    scene: "a council chamber of a bridge-fortress at night: a tall arched window with moonlit fog outside, a long dark wooden table, heavy drapes and a stone floor, cold blue light with a few small amber candles",
    pose: "standing upright and still, the hourglass held upright in the right hand at chest height, the long black cloak hanging behind her, head slightly raised, looking toward the right of the frame",
  },
];

const STYLE = "Style comes from the attached game portrait and enemy art ONLY (the last two attached images); do NOT copy the pose, the framing, the costume details, the weapon or the background of the attached game portrait.";
const LOOK = "dense pixel-art-inspired painting with painterly shading, crisp dark outlines on the armor and clothing, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur and no photorealistic skin";
const BLOCK = "No text, letters, numbers, labels, frame, border or watermark.";

function refsFor(h, kind) {
  const list = [];
  const add = (file, role) => file && list.push({ src: VAULT + h.dir + file, role });
  add(h.front, "canon front view of the character (body, costume and colors)");
  if (kind === "hud") {
    add(h.expr, "canon face and expressions sheet of the same character");
    if (!h.expr) add(h.left, "canon side view of the same character");
  } else {
    add(h.left, "canon side view of the same character");
    add(h.back, "canon back view of the same character");
    add(h.right, "canon other side view of the same character");
  }
  list.push({ src: path.join(ROOT, "assets/portraits", h.id + ".png"), role: "a game portrait used ONLY for painting style and color mood", style: true });
  list.push({ src: path.join(ROOT, STYLE_GAME), role: "a game enemy used ONLY for painting style", style: true });
  return list;
}

function stage(h, kind, list) {
  const dir = path.join(REFS, h.id, kind);
  fs.rmSync(dir, { recursive: true, force: true });
  fs.mkdirSync(dir, { recursive: true });
  const names = [];
  const missing = [];
  list.forEach((r, i) => {
    if (!fs.existsSync(r.src)) { missing.push(r.src); return; }
    const tag = r.style ? (r.role.includes("portrait") ? "estilo_menu_SO_ESTILO" : "estilo_jogo") : r.role.includes("front") ? "canon_corpo" : r.role.includes("expressions") ? "canon_rosto" : r.role.includes("back") ? "canon_costas" : r.role.includes("other side") ? "canon_perfil2" : "canon_perfil";
    const n = `${names.length + 1}_${tag}.png`;
    fs.copyFileSync(r.src, path.join(dir, n));
    names.push({ name: n, role: r.role });
  });
  return { dir: path.relative(ROOT, dir).replace(/\\/g, "/"), names, missing };
}

function roles(names) {
  return names.map((n, i) => `(${i + 1}) ${n.role}`).join(", ");
}

function hudPrompt(h, names) {
  const canonCount = names.filter((n) => n.role.includes("canon")).length;
  const canonIdx = Array.from({ length: canonCount }, (_, i) => i + 1);
  const idList = canonIdx.length > 1 ? `images ${canonIdx.slice(0, -1).join(", ")} and ${canonIdx[canonIdx.length - 1]}` : "image 1";
  return `Generate ONE image, square 1024x1024, using the ${names.length} attached images as references in this order: ${roles(names)}.

Dark-fantasy character portrait in the exact style of the attached game references: ${LOOK}. ${STYLE}

Composition: a tight head-and-shoulders close-up that will be shrunk to 76 px, so the face must read instantly, centered, facing the camera. ${h.hud} Strong contrast between the character and a very dark background.

CHARACTER (identity authority: the canon views, ${idList}; they win over any other description): ${h.character}

Background: ${h.hudBg}. No scenery, no weapon or prop, no particles, no lightning, no glow effects.

NEVER: ${h.never} No frame, no extra people, no text.

${BLOCK} Keep every asymmetric detail of the canon views (scars, ear edges, which side each item is on) on the same side as in the references. No redesign.`;
}

function fichaPrompt(h, names) {
  const canonCount = names.filter((n) => n.role.includes("canon")).length;
  const canonIdx = Array.from({ length: canonCount }, (_, i) => i + 1);
  const idList = canonIdx.length > 1 ? `images ${canonIdx.slice(0, -1).join(", ")} and ${canonIdx[canonIdx.length - 1]}` : "image 1";
  const item = h.item ? `\n${h.item}` : "\nThe hands carry no weapon or prop.";
  return `Generate ONE image, landscape 1536x1024, using the ${names.length} attached images as references in this order: ${roles(names)}.

Dark-fantasy character illustration in the exact style of the attached game references: ${LOOK}. ${STYLE}

IMPORTANT LAYOUT: this image will be cropped to a 16:9 frame taken from the central horizontal band between 8 percent and 92 percent of the image height (the full width). The character must be BIG in that frame: ONE character, the whole body from the top of the head (including hat, horns or hair) to the soles of the boots, standing in the exact center of the image horizontally, with the top of the head at about 14 percent and the feet at about 84 percent of the image height, so the figure is about 70 percent of the image height. The camera is close: the environment frames the character tightly on both sides (walls, trunks, ships, pillars) so there are no wide empty side areas. Nothing important within the outer 10 percent of the left and right edges; the top 8 percent and the bottom 8 percent are only plain continuation of the background.

Composition: ${h.pose}. The mood is somber and quiet, not an action scene.

CHARACTER (identity authority: the canon views, ${idList}; they win over any other description): ${h.character}${item}

ENVIRONMENT: ${h.scene}. The background is softly darker and less contrasted than the character so the character stays the brightest and most readable shape in the image.

NEVER: ${h.never} No extra people, no monsters.

${BLOCK} No motion blur, speed lines, particles, sparks or magic effects. No redesign: costume, hair and face follow the canon views, and every asymmetric detail stays on the same side as in the references.`;
}

fs.mkdirSync(OUT, { recursive: true });
const index = [];
const problems = [];
for (const h of H) {
  const hud = stage(h, "hud", refsFor(h, "hud"));
  const fic = stage(h, "ficha", refsFor(h, "ficha"));
  [hud, fic].forEach((s) => s.missing.forEach((m) => problems.push(`${h.id}: sem ${m}`)));
  fs.mkdirSync(path.join(ROOT, INCOMING, h.id), { recursive: true });
  const list = (s) => s.names.map((n) => `\`${n.name}\``).join(", ");
  const doc = `# ${h.name} — HUD e Ficha: copiar e colar no ChatGPT

Use **uma conversa nova por imagem**. Para cada uma: arraste os arquivos da pasta indicada **nesta ordem** (os nomes já são numerados), cole o texto do bloco e envie. O HUD e a Ficha do Durvall já foram aprovados; este herói segue o mesmo contrato.

${h.id === "nyrelia" ? "> Só existe a vista de frente da Nyrelia no Vault (sem costas nem perfil). Por isso as poses dela ficam quase de frente e o rosto nunca aparece.\n\n" : ""}---

## IMAGEM 1 — HUD (quadrada)

**Anexar** (pasta \`${hud.dir}/\`, ${hud.names.length} arquivos, na ordem): ${list(hud)}

**Colar:**

\`\`\`text
${hudPrompt(h, hud.names)}
\`\`\`

**Salvar como:** \`${INCOMING}/${h.id}/${h.id}_hud_v01.png\`

Se o rosto não parecer com o CANON, responda no mesmo chat: \`The face does not match the canon views. Keep the same composition and fix only the face and costume details to match the first reference images exactly.\`

---

## IMAGEM 2 — Ficha (cena 16:9)

O ChatGPT só gera 1024×1024, 1536×1024 ou 1024×1536; por isso a cena é pedida em 1536×1024 e eu recorto o 16:9 depois.

**Anexar** (pasta \`${fic.dir}/\`, ${fic.names.length} arquivos, na ordem): ${list(fic)}

**Colar:**

\`\`\`text
${fichaPrompt(h, fic.names)}
\`\`\`

**Salvar como:** \`${INCOMING}/${h.id}/${h.id}_ficha_v01.png\`

Se o herói sair pequeno ou fora do centro, responda no mesmo chat: \`Keep the same image but redraw it with the character larger and exactly centered: full body from head to boots about 70 percent of the image height, feet at about 84 percent of the height, and no wide empty areas on the sides.\`

---

Quando as duas imagens estiverem em \`${INCOMING}/${h.id}/\`, me avise.
`;
  fs.writeFileSync(path.join(OUT, `${h.id}.md`), doc);
  index.push(`| ${h.name} | [${h.id}.md](${h.id}.md) | ${hud.names.length} + ${fic.names.length} | \`${INCOMING}/${h.id}/\` |`);
}
fs.writeFileSync(path.join(OUT, "INDEX.md"), `# Lote de retratos dos 11 heróis (S-P06)

Um arquivo por herói, no mesmo formato do Durvall (já aprovado). Cada arquivo tem 2 conversas: HUD (1024×1024) e Ficha (1536×1024, recortada depois em 16:9).

Referências copiadas em \`.atena/generated/art-candidates/hero-portraits-r1-refs/<id>/hud\` e \`.../ficha\` (pasta ignorada pelo git).

| Herói | Arquivo para colar | Anexos (HUD + Ficha) | Salvar em |
|---|---|---|---|
${index.join("\n")}

Ordem sugerida: começar por Korrak e Sylas (silhuetas mais difíceis), depois os demais. Gerar um herói por vez e me avisar; recorto, integro e mostro.

Decisões do dono já aplicadas nos prompts: Kayron pelo CANON pós-S24 (A1), Erik raspado (A2), Maelor sem luz desenhada (A3), Leoric com a concha (A4), Brook sem arma (A5).
`);
console.log(problems.length ? "PROBLEMAS:\n" + problems.join("\n") : "refs ok");
console.log(H.length, "heróis");
