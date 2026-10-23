// R2 do contrato (animation-contract-r2.md): caminhada com 4 desenhos, linguagem perna do lado da câmera, referências sem caminhada reprovada.
// Monta o pacote de prompts do R1 a partir do contrato (animation-contract-r2.md) e das fichas (HERO-VISUAL-SHEETS-20261021-r1.md).
// Uso: node build_prompts.js   (escreve em ./prompts/). Não gera imagens; só texto.
const fs = require('fs');
const path = require('path');
const OUT = path.join(__dirname, 'prompts-r2');
fs.mkdirSync(OUT, { recursive: true });

const V = 'F:\\dev\\nottgard-vault\\output\\referencias-personagens\\';
const GAME = 'F:\\dev\\abyss-megadungeon\\';
const STYLE_REFS = [GAME + 'assets\\enemies\\zuggtmoy.png', GAME + 'assets\\enemies\\malcanthet.png'];

const STYLE = 'Dark-fantasy 2D game character illustration in the exact style of the attached game references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights, strong rim light from the upper left, no soft airbrush blur. Camera: three-quarter isometric, looking down at about 30 degrees. The silhouette must stay readable when shrunk to 64 px tall.';
const NEG = 'No text, letters, numbers, labels, arrows, grid lines, frames or watermark. No cast shadow on the ground and no floor. No motion blur, speed lines, particles, sparks, smoke, glow effects or drawn magic effects (the game draws effects). No extra limbs, no duplicated or extra weapons, no redesign, and no costume, hair or face change between figures. Keep every asymmetric detail of the reference on the same side of the body in all figures.';

const DIRS = {
  e: 'pure side view in profile, facing screen-RIGHT',
  se: 'three-quarter front view, body and face turned toward the camera and toward screen-RIGHT at about 45 degrees',
  s: 'front view, facing the camera',
  ne: 'three-quarter back view, walking away from the camera toward screen-RIGHT at about 45 degrees (face mostly hidden)',
  n: 'back view, walking directly away from the camera',
  w: 'pure side view in profile, facing screen-LEFT',
  sw: 'three-quarter front view, body and face turned toward the camera and toward screen-LEFT at about 45 degrees',
  nw: 'three-quarter back view, walking away from the camera toward screen-LEFT at about 45 degrees (face mostly hidden)',
};

const WALK_DIAG = {
  A: 'CONTACT with the NEAR leg leading (the near leg is the leg closest to the camera): the NEAR leg is the leading leg, extended forward with only the heel just touching the ground; the FAR leg is the trailing leg, behind the body with only the toes on the ground. The arm on the side opposite to the leading leg swings forward and the other arm swings back; the arm that carries the item stays steady.',
  P1: 'PASSING 1, the FAR leg passes (this is the calibration figure, standing height): the NEAR leg is the straight supporting leg with the foot flat on the ground; the FAR leg passes forward with the knee bent and the foot lifted, partly hidden behind the near leg; hips and head at their highest; arms close to the body.',
  B: 'OPPOSITE CONTACT with the FAR leg leading: the exact opposite of figure 1. The FAR leg (the leg farthest from the camera) is the leading leg, extended forward with only the heel touching the ground; the NEAR leg (closest to the camera) is the trailing leg, BEHIND the body, only its toes touching the ground, its boot clearly visible BEHIND the body. This figure must NOT be a copy of figure 1: the near boot is in FRONT in figure 1 and BEHIND in this figure. The arm opposite to the leading leg swings forward; the item arm stays steady.',
  P2: 'PASSING 2, the NEAR leg passes: the FAR leg is the straight supporting leg; the NEAR leg passes forward with the knee bent and the foot clearly lifted, in FRONT of the supporting leg and fully visible to the camera; hips and head at their highest; arms close to the body. This figure must NOT be a copy of figure 2: in figure 2 the lifted foot is the far one (mostly hidden); here it is the near one (fully visible).',
};
const WALK_FRONT = {
  A: 'CONTACT with the leg on the SCREEN-LEFT side leading: the leg on the screen-left half of the figure is the leading leg (it steps toward the camera with the heel just touching the ground when the character faces the camera, or away from the camera, appearing slightly higher on the ground, when seen from behind); the leg on the screen-right half trails with only the toes on the ground. The arm opposite to the leading leg swings forward; the item arm stays steady.',
  P1: 'PASSING 1 (this is the calibration figure, standing height): the leg on the SCREEN-LEFT side is the straight supporting leg, foot flat; the leg on the SCREEN-RIGHT side passes with the knee bent and the foot lifted; hips and head at their highest; arms close to the body.',
  B: 'OPPOSITE CONTACT with the leg on the SCREEN-RIGHT side leading: the exact opposite of figure 1 (the screen-right leg leads, the screen-left leg trails). This figure must NOT be a copy of figure 1.',
  P2: 'PASSING 2: the leg on the SCREEN-RIGHT side is the straight supporting leg, foot flat; the leg on the SCREEN-LEFT side passes with the knee bent and the foot lifted. This figure must NOT be a copy of figure 2.',
};
const IDLE = [
  'REST: relaxed standing pose, facing the camera and slightly to the right, weight even on both feet (this is the calibration figure).',
  'BREATH IN: identical pose and identical feet; shoulders and chest raised by only 2 to 3 px; cloth and hair shift by a hair\'s width.',
  'BREATH OUT: identical pose and identical feet; shoulders and chest settled slightly lower than REST; cloth and hair shift slightly the other way.',
];
const DEATH = [
  'HIT: recoiling backward from a blow, head thrown back, one foot just off the ground, the held item loosening.',
  'FALL: dropping to the knees, head down, the held item falling from the hand.',
  'DOWN: lying collapsed on the ground on one side, eyes closed, the held item on the ground beside the hand; no blood, no gore. This figure is wide: keep it fully inside its quadrant.',
];
const DEATH_NOITEM = [DEATH[0].replace(', the held item loosening', ', the arms flung out'), DEATH[1].replace(', the held item falling from the hand', ', the hands dropping to the ground'), DEATH[2].replace(', the held item on the ground beside the hand', ', one arm stretched out on the ground')];
const CAL = 'CALIBRATION: neutral standing pose facing the camera and slightly to the right, arms relaxed, feet together, holding the item (if any) in a relaxed resting carry in the same hand as in the other poses (used to match scale; keep it exact).';

// key: cor de fundo. Sylas usa cinza porque o magenta é parte da roupa dele.
const KEY = { magenta: 'pure magenta #FF00FF', gray: 'light neutral gray #B4B4B4' };

const H = {
  durvall: {
    name: 'Durvall', pos: 'prova de contrato (R2)', key: 'magenta', west: 'real', snABP: true,
    refs: ['CHAR-015\\historico-S01-S09\\r01\\durvall-front-candidate-v01.png', 'CHAR-015\\historico-S01-S09\\r01\\durvall-left-v01.png', 'CHAR-015\\historico-S01-S09\\r01\\durvall-back-v01.png', 'CHAR-015\\historico-S01-S09\\r01\\durvall-right-v01.png'],
    identity: 'Durvall, a tall, lean male drow, about 1.9 m: blue-gray skin, long straight white hair falling past the shoulder blades, pointed ears, a stern angular face with a calm closed expression. Black plate armor made of overlapping leaf-shaped segments with sharp points, spiked pauldrons, pointed greaves and plate gauntlets. A torn dark-red sash tied at the waist with a ragged red cloth hanging from it (seen from the front, the cloth hangs on the screen-left hip). Slender, athletic build.',
    item: 'Item (game weapon, not in the canon views): a straight black-steel longsword with a plain cold edge highlight (no glow), held in the RIGHT hand.',
    never: 'No helmet, no glowing eyes, no cape, no tentacles, no black ooze or sludge, no extra weapons, no ghostly or divine imagery.',
    hold: 'The sword is carried in the RIGHT hand, point down and slightly back, held low along the leg; it does not swing.',
    attack: ['wind-up: the body turns and the RIGHT arm draws the sword back across the body to left-shoulder height, weight on the back leg', 'strike: the sword sweeps in a wide horizontal arc to the front-right, arm fully extended, front foot planted, torso twisted', 'follow-through: the sword ends low on the far side, torso turned past the strike, back foot lifting'],
    active: ['both hands on the sword raised overhead, knees bent', 'heavy downward cleave in front, arms extended, body leaning into the cut', 'sword low in front, crouched, shoulders dropped'],
  },
  korrak: {
    name: 'Korrak', pos: 'prova de contrato (R2)', key: 'magenta', west: 'mirror', snABP: false,
    refs: ['CHAR-030\\S10-S12\\r01\\korrak-front-candidate-v01.png', 'CHAR-030\\S10-S12\\r01\\korrak-left-v01.png', 'CHAR-030\\S10-S12\\r01\\korrak-back-v01.png', 'CHAR-030\\S10-S12\\r01\\korrak-right-v01.png'],
    identity: 'Korrak, a goliath, about 2.3 m, enormously muscled: stone-gray skin with faint darker veins like granite; shaved head with a dark crest of hair along the center, a full black beard, heavy brow. A rivet-studded brown leather cuirass with a diagonal strap, a spiked steel pauldron on his LEFT shoulder and a thick tawny fur mantle on his RIGHT shoulder, studded leather bracers, a wide belt with a round buckle disc, a skirt of ragged leather strips, tall wrapped boots with fur cuffs.',
    item: 'Item (game weapon, not in the canon views): the Axe of Xar\'gath, a huge two-handed battle axe with a black iron head whose lava-like orange-red cracks are painted on the metal (not an effect) and a long dark wooden haft.',
    never: 'No helmet, no armor change, no flames or sparks around the axe, no second weapon.',
    hold: 'The axe is held in both hands diagonally across the body, head on the leading side at chest height, steady. Heavy, short steps.',
    attack: ['wind-up: the axe drawn back behind the RIGHT shoulder, torso twisted', 'strike: a wide horizontal chop across the front, arms extended, front foot planted', 'follow-through: the axe low on the far side, momentum carrying the torso'],
    active: ['the axe raised overhead in both hands, torso arched back', 'the axe at the top of the swing, body leaning forward', 'the axe driven down in front, knees bent, head down'],
  },
  erik: {
    name: 'Erik', pos: 'prova de contrato (R2, assimétrico)', key: 'magenta', west: 'real', snABP: true,
    refs: ['EEEE-r01\\fronts\\erik-front-v01.png', 'EEEE-r01\\views\\erik-left-v01.png', 'EEEE-r01\\views\\erik-back-v01.png', 'B-FALT-005-04\\r01\\erik-right-candidate-v01.png'],
    note: 'IMPORTANTE (decisão A2): as referências mostram cabelo e barba; ignore isso. Erik está de cabeça raspada e sem barba.',
    override: 'REFERENCE OVERRIDE: the attached views show Erik with dark hair and a stubble beard. IGNORE the hair and the beard completely: in every figure he is bald and clean-shaven. Use the references only for his clothing, build and facial structure.',
    identity: 'Erik Blackthorn, a human man in his thirties, lean and weathered, with a SHAVED HEAD (completely bald) and a CLEAN-SHAVEN face (no beard, no stubble), a few small old scars on the face. A gray-green cowl worn down around the neck, fur-trimmed shoulder pads, a torn gray-green and dark-gray tunic, crossed brown leather straps, a small glowing golden amulet disc on the chest (the glow limited to the disc), brown leather bracers, worn trousers, tall brown buckled boots. A sheathed sword on his back, held by a diagonal strap, with the hilt rising above his RIGHT shoulder.',
    item: 'Item (game weapon, not in the canon views): a wooden torch with a small lit flame (about the size of his head), held in the RIGHT hand.',
    never: 'No hair, no beard, no stubble. No sparks, no smoke, no fire on the body or ground. The sword stays sheathed on the back.',
    hold: 'The torch is held in the RIGHT hand at hip height, flame up; the sword stays sheathed on the back.',
    attack: ['wind-up: the torch drawn back at right-shoulder height', 'strike: the torch sweeps in a wide arc to the front, the small flame only as part of the torch', 'follow-through: the torch low on the far side, torso turned'],
    active: ['crouching, the torch held low to the right', 'the torch swept along the ground in front, body lunging', 'standing up, the torch raised back to the shoulder'],
    deathNote: 'The torch lies on the ground beside the hand with the flame out.',
  },
  brook: {
    name: 'Brook', pos: 'R3', key: 'magenta', west: 'mirror', snABP: false, noItem: true,
    refs: ['CHAR-011\\S03-S09\\r01\\brook-front-candidate-v01.png', 'CHAR-011\\S03-S09\\r01\\brook-left-v01.png', 'CHAR-011\\S03-S09\\r01\\brook-back-v01.png', 'CHAR-011\\S03-S09\\r01\\brook-right-v01.png'],
    note: 'Decisão: seguir a imagem CANON. O prompt antigo (anão jovem de barba castanha) está errado e não vale.',
    identity: 'Brook França, short and stocky (halfling proportions, about 1.2 m, a large head on a broad body), about 53 years old: voluminous wavy white hair, a short trimmed white beard and mustache, pointed ears, a weathered stern face. Full riveted steel plate armor over mail, large round shoulder discs, knee guards, plate boots, a wide brown belt; a tattered dark-crimson cape hanging from the shoulders to the knees.',
    item: 'No weapon: both hands are empty, gauntleted, relaxed.',
    never: 'No mace, no hammer (the hammer of Bromnor is not his), no shield, no holy-symbol prop, no glow.',
    hold: 'Both hands empty, gauntleted fists relaxed at the sides; the cape sways.',
    attack: ['wind-up: the free right hand pulled back to the chest, palm in', 'strike: the right arm thrust forward, palm open outward, wide stance', 'follow-through: both arms spread slightly, head raised'],
    active: ['both forearms crossed in front of the chest (guard)', 'a braced wide stance, forearms crossed, leaning forward', 'arms thrown open outward, chest out'],
  },
  maelor: {
    name: 'Maelor', pos: 'R3', key: 'magenta', west: 'mirror', snABP: false, noItem: true,
    refs: ['CHAR-035\\S01-S09\\r01\\maelor-front-candidate-v01.png', 'CHAR-035\\S01-S09\\r01\\maelor-left-v01.png', 'CHAR-035\\S01-S09\\r01\\maelor-back-v01.png', 'CHAR-035\\S01-S09\\r01\\maelor-right-v01.png'],
    note: 'Decisão A3: nada de azul de magia; luz dourada-branca (e ela não é desenhada).',
    identity: 'Maelor Menezes, a young half-elf man (slightly pointed ears), copper-auburn hair swept back to the nape, clean-shaven, a kind but focused face. A long white coat with blue side panels and gold trim, a tall stiff gold collar, white shoulder pads, a brown leather satchel on the LEFT hip, leather knee guards, brown boots, brown leather gloves.',
    item: 'No weapon and no prop in the hands: hands are empty and open.',
    never: 'No blue flame, no glowing hands, no light effect drawn, no staff, no holy symbol.',
    hold: 'Both hands empty and relaxed; the coat sways.',
    attack: ['wind-up: the right hand drawn to the chest, palm up', 'strike: the right arm extended forward with the open palm facing out, left arm back for balance', 'follow-through: the arm still extended, body leaning, fingers spread'],
    active: ['both hands folded at the chest in prayer', 'both arms opened wide with palms up, face lifted', 'arms lowered slightly to the sides, head bowed'],
  },
  sylas: {
    name: 'Sylas', pos: 'R3', key: 'gray', west: 'mirror', snABP: false, noItem: true,
    refs: ['CHAR-051\\S01-S09\\r01\\sylas-front-candidate-v01.png', 'CHAR-051\\S01-S09\\r01\\sylas-left-v01.png', 'CHAR-051\\S01-S09\\r01\\sylas-back-v01.png', 'CHAR-051\\S01-S09\\r01\\sylas-right-v01.png'],
    note: 'Fundo cinza (não magenta): o magenta é parte da roupa dele.',
    identity: 'Sylas Malafaia, a tiefling: tall curved black horns sweeping up from a black hood, a smooth dark mask covering the whole lower face and brow with glowing violet eyes, pointed ears, a black robe-tabard with magenta-violet interlaced trim along the hems, dark pauldrons, black plate gauntlets, a belt with a metal buckle, black boots with violet details.',
    item: 'No weapon: both gauntleted hands are empty.',
    never: 'No daggers, no blades, no wings, no tail, no visible skin on the face, no glow beyond the eyes.',
    hold: 'Both gauntleted hands empty and relaxed, a quiet stealthy stride; the robe sways.',
    attack: ['wind-up: the right hand drawn back', 'strike: the right gauntlet thrust forward with fingers pointing, left hand low', 'follow-through: the arm extended, body leaning'],
    active: ['crouched and ready, one leg back', 'a lunging dash pose forward, body low, the robe streaming back', 'a landing crouch, one hand touching the ground'],
  },
  kayron: {
    name: 'Kayron', pos: 'R3', key: 'magenta', west: 'mirror', snABP: false, noItem: true,
    refs: ['CHAR-028\\pos-S24\\r03-turnaround\\kayron-front-v01.png', 'CHAR-028\\pos-S24\\r03-turnaround\\kayron-left-v01.png', 'CHAR-028\\pos-S24\\r03-turnaround\\kayron-back-v01.png', 'CHAR-028\\pos-S24\\r03-turnaround\\kayron-right-v01.png'],
    note: 'Decisão A1: figurino CANON pós-S24 (roupão branco). Ignore a armadura escura e a capa roxa das tiras atuais do jogo.',
    identity: 'Kayron Lioran, an aasimar: a young slim man with short messy silver-white hair, pale skin, EYES COMPLETELY RED (one uniform red color over the whole eye, no white sclera and no pupil), a calm serious face. A loose white knee-length coat with wide three-quarter sleeves decorated with black tribal tattoo-like patterns on the shoulders and sleeves, an open V neckline over a black undershirt, a crimson checkered sash tied at the waist, dark patterned wraps on the forearms, loose black trousers, black boots with thin red details.',
    item: 'No weapon: both hands are empty.',
    never: 'No armor, no cape, no purple, no weapon, no halo, no wings.',
    hold: 'Both hands empty and relaxed; the loose sleeves and sash sway.',
    attack: ['wind-up: the arms drawn in, crossed at the chest', 'strike: the arms flung wide, head raised, wide stance', 'follow-through: the arms still wide, the body slightly arched'],
    active: ['fists clenched at the hips, chin down', 'fists raised at the shoulders, shoulders squared', 'head thrown back, fists pulled down and back (power-up pose)'],
  },
  leoric: {
    name: 'Leoric', pos: 'R3', key: 'magenta', west: 'mirror', snABP: false,
    refs: ['CHAR-033\\S10-S12\\r01\\leoric-front-candidate-v01.png', 'CHAR-033\\S10-S12\\r01\\leoric-left-v02.png', 'CHAR-033\\S10-S12\\r01\\leoric-back-v01.png', 'CHAR-033\\S10-S12\\r01\\leoric-right-v01.png'],
    note: 'Decisão A4: a concha substitui o cajado; é pequena e não pesa na silhueta.',
    identity: 'Leoric, a male gnome about 1 m tall, 45 years old: pointed ears, a long full gray beard and mustache, bushy brows, a black top hat with a copper band, a long brown leather trench coat with brass buttons and shoulder epaulettes, a dark vest, a belt with small pouches, dark trousers, buckled boots.',
    item: 'Item (game weapon, not in the canon views): a small spiral conch shell, pale cream with faint gold star flecks, the size of his palm, carried in the RIGHT hand at belt height.',
    never: 'No staff, no cane, no wand, no glow, no stars drawn around him.',
    hold: 'The conch is held in the RIGHT hand at belt height; the left hand relaxed.',
    attack: ['wind-up: the conch raised toward the mouth', 'strike: leaning back and blowing into the conch', 'follow-through: the conch lowered, chest out'],
    active: ['both arms low, conch in hand', 'both arms thrown up over the head, conch high', 'arms spread wide, head tilted up'],
  },
  zynara: {
    name: 'Zynara', pos: 'R3', key: 'magenta', west: 'mirror (oeste real opcional)', snABP: true,
    refs: ['CHAR-066\\S01-S03-conselheira\\r01\\zynara-front-candidate-v01.png', 'CHAR-066\\S01-S03-conselheira\\r01\\zynara-left-v01.png', 'CHAR-066\\S01-S03-conselheira\\r01\\zynara-back-v02.png', 'CHAR-066\\S01-S03-conselheira\\r01\\zynara-right-v02.png'],
    identity: 'Zynara Vellen, a tall elf woman: long wavy silver hair to the waist, long pointed ears, a small gold circlet on the forehead, a pale face with a cold composed gaze. A long black high-collar dress under a long black cloak, both with gold embroidered leaf patterns along the hems and chest, a slim belt, black heeled boots.',
    item: 'Item (game weapon, not in the canon views): the Hourglass of Eternal Silence, a hand-sized hourglass of dark metal and glass with pale sand, held upright in the RIGHT hand.',
    never: 'No glow, no floating particles of sand, no extra props, no crown.',
    hold: 'The hourglass is held upright in the RIGHT hand at waist height; the left hand relaxed; the cloak sways. A calm, measured walk.',
    attack: ['wind-up: the hourglass drawn to the chest', 'strike: the arm extended forward holding the hourglass up toward the target', 'follow-through: the hourglass tilted slightly in the extended hand'],
    active: ['both hands holding the hourglass in front of the chest', 'the hourglass lifted overhead', 'the hourglass flipped upside down in the raised hand, the other arm extended'],
  },
  bromnor: {
    name: 'Bromnor', pos: 'R3', key: 'magenta', west: 'mirror', snABP: false,
    refs: ['CHAR-010\\historico-em-vida\\r01\\bromnor-front-candidate-v01.png', 'CHAR-010\\historico-em-vida\\r01\\bromnor-left-v01.png', 'CHAR-010\\historico-em-vida\\r01\\bromnor-back-v01.png', 'CHAR-010\\historico-em-vida\\r01\\bromnor-right-v01.png'],
    note: 'Um martelo só (a tira atual tem dois). Bromnor aparece em vida.',
    identity: 'Bromnor Martelo da Luz, a dwarf, broad and powerful: a long white braided beard down to the chest, long white hair tied back, thick brows. Ornate gold plate armor with rune-like geometric patterns, huge pauldrons, a royal-blue tabard with gold borders, gold knee plates, heavy gold-trimmed boots.',
    item: 'Item (game weapon, not in the canon views): the Hammer of Light, a single large one-handed warhammer with a golden head and a pale-white inlay (painted on the metal, not a glow), in the RIGHT hand.',
    never: 'ONE hammer only. No ghost, no spirit, no transparency, no wounds, no blood, no light effect.',
    hold: 'The warhammer in the RIGHT hand, head resting on the right shoulder, handle angled forward.',
    attack: ['wind-up: the hammer drawn back over the right shoulder', 'strike: the hammer swung forward and down in a strong arc', 'follow-through: the hammer low at the front, torso bent'],
    active: ['the hammer raised overhead in both hands', 'the hammer driven into the ground in front (head at the ground, no crack)', 'standing braced on the planted hammer, chest out'],
  },
  arlindo: {
    name: 'Arlindo', pos: 'R3', key: 'magenta', west: 'mirror', snABP: false, noItem: true,
    refs: ['CHAR-005\\S03-S09-andarilho\\refhq-r01\\orlando-front-candidate-v01.png', 'CHAR-005\\S03-S09-andarilho\\refhq-r01\\arlindo-orlando-left-candidate-v01.png', 'CHAR-005\\S03-S09-andarilho\\refhq-r01\\arlindo-orlando-back-candidate-v01.png', 'CHAR-005\\S03-S09-andarilho\\refhq-r01\\arlindo-orlando-right-candidate-v01.png'],
    identity: 'Arlindo Orlando, a lean middle-aged human man with short gray hair and short gray stubble, a weathered face; a brown felt fedora, a dark-red scarf, a long dark-brown wool coat, a vest, dark leather gloves, brown trousers and boots.',
    item: 'No weapon: both hands are empty, gloved.',
    never: 'No weapon, no glow in the hands, no memory imagery drawn.',
    hold: 'Both gloved hands empty and relaxed; the long coat sways; an unhurried wanderer\'s walk.',
    attack: ['wind-up: the right hand brought to the temple', 'strike: the right hand thrown forward with fingers open', 'follow-through: the arm extended forward, body leaning'],
    active: ['both hands raised to the temples', 'arms thrown wide, the hat tilted back', 'arms lowered, shoulders slumped'],
  },
  nyrelia: {
    name: 'Nyrelia', pos: 'R3 (BLOQUEADA até as vistas CANON de costas e perfil, decisão A6)', key: 'magenta', west: 'mirror', snABP: false, noItem: true, blocked: true,
    refs: ['ACHADOS-TRES-20261018-r1\\nyrelia-front-v01.png', 'assets_incoming\\hero-r2\\nyrelia\\ref\\nyrelia-back-v01.png (a gerar, seção vistas)', 'assets_incoming\\hero-r2\\nyrelia\\ref\\nyrelia-left-v01.png (a gerar)', 'assets_incoming\\hero-r2\\nyrelia\\ref\\nyrelia-right-v01.png (a gerar)'],
    identity: 'Nyrelia: a tall hooded figure, the face completely hidden behind a smooth dark metal mask (no eyes visible, no skin visible); a deep green ragged hooded cloak with fringed edges, a green scarf with gold tassels, a black dress with a gold embroidered sash, dark gloves, black boots with gold buckles.',
    item: 'No weapon: both gloved hands are empty.',
    never: 'Never show the face, skin, eyes or any trait that reveals her species. No weapon. No yellow aura drawn (the game draws it).',
    hold: 'Both gloved hands folded loosely in front; the fringed cloak sways.',
    attack: ['wind-up: the right hand rising, palm out', 'strike: the right arm extended, open palm toward the target, mask forward', 'follow-through: the same, left hand raised too'],
    active: ['both hands at the chest', 'both arms extended, palms forward', 'arms lowered slowly, head tilted'],
  },
};

function fmtRow(h, n) {
  const k = KEY[h.key];
  if (n === 3) return `Canvas 1536x1024, landscape. Perfectly uniform flat ${k} background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps between figures. Draw exactly 3 full-body figures of the SAME character in ONE horizontal row, left to right, evenly spaced with at least 140 px of empty background between figures. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All figures have the same scale (about 75 percent of the canvas height) and all feet rest on the same invisible horizontal ground line.`;
  return `Canvas 1024x1024, square. Perfectly uniform flat ${k} background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gap between the figures. Draw exactly 2 full-body figures of the SAME character side by side, left to right, with at least 140 px of empty background between them. Neither figure touches the other or the canvas edge, and each is completely visible including item, hair and cloth. Both figures have the same scale (about 75 percent of the canvas height) and both stand on the same invisible horizontal ground line.`;
}
function fmtGrid(h) {
  const k = KEY[h.key];
  return `Canvas 1536x1024, landscape. Perfectly uniform flat ${k} background (no gradient, no floor, no ground shadow, no vignette, no texture), including the gaps. Draw exactly 4 full-body figures of the SAME character in a 2x2 arrangement, in reading order (top-left, top-right, bottom-left, bottom-right), each figure inside its own 768x512 quadrant with at least 60 px of empty margin around it. No figure touches another figure or the canvas edge, and every figure is completely visible including item, hair and cloth. All four figures have the same scale (about 80 percent of the quadrant height); the two figures of the same row stand on the same invisible horizontal ground line.`;
}

function attachBlock(h, isIdle) {
  const lines = h.refs.map((r, i) => `${i + 1}. ${/^(assets_incoming|F:)/.test(r) ? r : V + r}`);
  if (isIdle) lines.push(`${h.refs.length + 1}. ${STYLE_REFS[0]}  (estilo do jogo)`);
  else lines.push(`${h.refs.length + 1}. F:\\dev\\abyss-megadungeon\\assets_incoming\\hero-r2\\${h.id}\\${h.id}_idle_se_v01.png  (idle APROVADO do herói; use a versão aprovada; não anexe nenhuma caminhada)`);
  return lines.join('\n');
}

function figuresList(items) {
  return items.map((t, i) => `Figure ${i + 1} — ${t}`).join('\n');
}

function build(id) {
  const h = H[id];
  h.id = id;
  const images = [];
  const common = (extra) => [STYLE, extra.format, `CHARACTER (identity authority: the attached canon views; they win over any other description): ${h.identity}`, h.override, h.item, `NEVER: ${h.never}`, extra.poses, NEG].filter(Boolean).join('\n\n');
  const dirFacing = (d) => `Facing for ALL figures in this image: ${DIRS[d]}.`;
  const dirs = ['e', 'se', 'ne', 's', 'n'];
  if (String(h.west).startsWith('real')) dirs.push('w', 'sw', 'nw');
  const idleFmt = fmtRow(h, 3);
  images.push({ file: `${id}_idle_se_v01.png`, title: 'Idle (3 desenhos, voltado para se)', layout: '1×3 · 1536×1024', figs: 3, verify: 'idle', prompt: common({ format: idleFmt, poses: `${dirFacing('se')}\n${figuresList(IDLE)}\nThe three figures must be almost identical; only the tiny breathing and cloth/hair differences described. Same feet placement in all three.` }) });
  for (const d of dirs) {
    const front = d === 's' || d === 'n';
    const four = !front || h.snABP;
    const keys = four ? ['A', 'P1', 'B', 'P2'] : ['A', 'P1'];
    const tab = front ? WALK_FRONT : WALK_DIAG;
    const poses = `${dirFacing(d)}\nThe character walks at a normal pace; head height stays about the same. ${h.hold}\n` + figuresList(keys.map((k) => tab[k])) + (four ? '' : '\n(The opposite contact and the second passing are produced later by mirroring figures 1 and 2, so only two figures are drawn.)');
    images.push({ file: `${id}_walk_${d}_r2_v01.png`, title: `Caminhada ${d} (${keys.join(', ')})`, layout: four ? '2×2 · 1536×1024' : '1×2 · 1024×1024', figs: keys.length, verify: four ? 'walk4' : 'walk2', prompt: common({ format: four ? fmtGrid(h) : fmtRow(h, 2), poses }) });
  }
  const grid = (kind, arr) => `${dirFacing('se')}\n${figuresList([CAL, ...arr.map((t, i) => `${kind} ${i + 1} of 3, ${t}.`)])}`;
  images.push({ file: `${id}_attack_se_v01.png`, title: 'Ataque (calibração + 3 desenhos)', layout: '2×2 · 1536×1024', figs: 4, verify: 'grid', prompt: common({ format: fmtGrid(h), poses: grid('ATTACK', h.attack) }) });
  images.push({ file: `${id}_active_se_v01.png`, title: 'Habilidade ativa (calibração + 3 desenhos)', layout: '2×2 · 1536×1024', figs: 4, verify: 'grid', prompt: common({ format: fmtGrid(h), poses: grid('ACTIVE ABILITY', h.active) }) });
  images.push({ file: `${id}_death_se_v01.png`, title: 'Morte (calibração + 3 desenhos)', layout: '2×2 · 1536×1024', figs: 4, verify: 'grid', prompt: common({ format: fmtGrid(h), poses: `${dirFacing('se')}\n${figuresList([CAL, ...(h.noItem ? DEATH_NOITEM : DEATH).map((t, i) => `DEATH ${i + 1} of 3, ${t}${i === 2 && h.deathNote ? ' ' + h.deathNote : ''}`)])}` }) });

  let md = `# ${h.name} — pacote de prompts (contrato r2, DRAFT)\n\nStatus: nada foi gerado. Substitui o pacote r1 (\`prompts/\`), que gerou as v01 e v02 do Durvall e fica como histórico. ${h.pos}. Fundo: ${KEY[h.key]}. Oeste: ${h.west}. Verificador: \`r2_check_v2.gd\` (tipo na última coluna). Contrato: \`.atena/specs/SPEC-NOTTGARD-HERO-ART-RESET-20261021/animation-contract-r2.md\`. Ficha: \`.atena/vault/drafts/HERO-VISUAL-SHEETS-20261021-r1.md\`.\n`;
  if (h.note) md += `\n> ${h.note}\n`;
  if (h.blocked) md += `\n> **BLOQUEADA:** não gerar os sprites antes de aceitar as vistas de costas e perfil (arquivo \`nyrelia-vistas.md\`).\n`;
  md += `\n## Anexos (máximo 5 por pedido, nesta ordem)\n\n**Idle:**\n\n${attachBlock(h, true)}\n\n**Todas as outras imagens (caminhada, ataque, ativa, morte):**\n\n${attachBlock(h, false)}\n\nUm herói por conversa. Salvar como \`F:\\dev\\abyss-megadungeon\\assets_incoming\\hero-r2\\${id}\\<arquivo>\`.\n\n## Imagens (${images.length})\n\n| # | Arquivo | Conteúdo | Layout | Figuras | Tipo |\n|---|---|---|---|---|---|\n` + images.map((im, i) => `| ${i + 1} | \`${im.file}\` | ${im.title} | ${im.layout} | ${im.figs} | ${im.verify} |`).join('\n') + '\n';
  images.forEach((im, i) => { md += `\n### ${i + 1}. \`${im.file}\` — ${im.title}\n\n\`\`\`text\n${im.prompt}\n\`\`\`\n`; });
  fs.writeFileSync(path.join(OUT, `${id}.md`), md);
  return { id, name: h.name, pos: h.pos, key: h.key, west: h.west, count: images.length, blocked: !!h.blocked };
}

const rows = Object.keys(H).map(build);

// Vistas CANON da Nyrelia (apoio; referência DRAFT, não sprite)
const VIEW_BASE = 'Character turnaround reference sheet image for a dark-fantasy game, matching the attached canon front view and the attached turnaround examples in format and style: one full-body figure, neutral standing pose with arms relaxed at the sides and feet together, perfectly uniform flat light neutral gray #B4B4B4 background, soft even lighting, no cast shadow, no text or labels. Same character, same scale and exactly the same costume, mask, cloak, scarf, tassels, embroidery and boots as the front view; do not redesign anything. The face stays completely hidden behind the smooth dark mask in every view.';
const views = [
  ['nyrelia-back-v01.png', 'BACK view: the figure seen from directly behind, facing away from the camera; the hood, the ragged fringed cloak and the scarf tassels hang naturally; show how the cloak falls behind.'],
  ['nyrelia-left-v01.png', 'LEFT profile view: pure side view with the figure facing screen-RIGHT (the nose side of the mask points right), like the other canon left views.'],
  ['nyrelia-right-v01.png', 'RIGHT profile view: pure side view with the figure facing screen-LEFT, like the other canon right views.'],
];
let vmd = `# Nyrelia — vistas CANON de apoio (R1, DRAFT)\n\nStatus: nada foi gerado. Pré-requisito do R3 (decisão A6). São **referências**, não sprites. Salvar em \`F:\\dev\\abyss-megadungeon\\assets_incoming\\hero-r2\\nyrelia\\ref\\\`. A promoção a CANON é decisão do dono e acontece no Vault; aqui elas só valem como referência DRAFT. Tamanho sugerido: 1024×1536 (retrato).\n\n## Anexar (nesta ordem)\n\n1. ${V}ACHADOS-TRES-20261018-r1\\nyrelia-front-v01.png  (frente CANON)\n2. ${V}CHAR-028\\pos-S24\\r03-turnaround\\kayron-left-v01.png  (exemplo de formato)\n3. ${V}CHAR-028\\pos-S24\\r03-turnaround\\kayron-back-v01.png  (exemplo de formato)\n\nA frente CANON também aparece em \`CANON-SEIS-20261018-r1\\nyr-19-nyrelia_v01.png\` (versão em pixel art): não anexar a versão pixel art junto, para não misturar estilos.\n`;
views.forEach(([f, t], i) => { vmd += `\n### ${i + 1}. \`${f}\`\n\n\`\`\`text\n${VIEW_BASE}\n\n${t}\n\`\`\`\n`; });
fs.writeFileSync(path.join(OUT, 'nyrelia-vistas.md'), vmd);

const total = rows.reduce((a, r) => a + r.count, 0);
let idx = `# Pacote de prompts dos heróis — índice (contrato r2, DRAFT, 2026-10-22)\n\nNada foi gerado. Gerado por \`build_prompts_r2.js\` a partir do contrato r2 e das fichas; o pacote r1 (\`../prompts/\`) fica como histórico. Prompts em inglês (é o idioma que o ChatGPT recebe); notas em português.\n\n| Herói | Arquivo | Lote | Fundo | Oeste | Imagens |\n|---|---|---|---|---|---|\n` + rows.map((r) => `| ${r.name} | [${r.id}.md](${r.id}.md) | ${r.pos} | ${KEY[r.key]} | ${r.west} | ${r.count}${r.blocked ? ' (bloqueada)' : ''} |`).join('\n') + `\n| Nyrelia (vistas) | [nyrelia-vistas.md](nyrelia-vistas.md) | pré-requisito do R3 | cinza #B4B4B4 | — | 3 |\n\nTotal de imagens de sprite: ${total}. R2 (Durvall, Korrak, Erik): ${rows.filter((r) => ['durvall', 'korrak', 'erik'].includes(r.id)).reduce((a, r) => a + r.count, 0)}.\n\nOrdem sugerida no R2: idle → caminhada \`se\` → \`e\` → \`ne\` → \`s\` → \`n\` → (oeste, onde houver) → ataque → ativa → morte. Comece pelo Durvall: se o idle e o \`se\` passarem nos critérios, siga; senão volte comigo antes de gerar o resto.\n`;
fs.writeFileSync(path.join(OUT, 'index.md'), idx);
console.log(rows.map((r) => `${r.id}:${r.count}`).join(' '), 'total', total);
