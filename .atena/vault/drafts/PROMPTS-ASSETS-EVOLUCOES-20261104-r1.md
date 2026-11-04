# Assets — Evoluções de armas e novas passivas, 2026-11-04, r1

Status: DRAFT de preparação. Nenhuma imagem foi gerada, aceita, integrada ou commitada; a integração em `assets/` segue o fluxo habitual (geração pelo dono, preparação por script, aceite visual). Checkpoints dos demais planos preservados. Contexto: `PLANO-EVOLUCOES-20261104-r1.md`.

## Lacuna

O update de evolução (12 armas, 10 passivas novas) funciona hoje com **placeholders**:
- as 12 armas evoluídas usam o ícone da arma base via `icon_like` (`Items.weapon_icon`); os nomes são provisórios e dependem da aprovação do dono;
- as 10 passivas novas não têm PNG em `assets/icons/passives/`; a ficha (`ui/character_sheet.gd:487`) cai na letra inicial e a oferta (`ui/hud.gd:1064`) usa o caminho inexistente.

Entrega pedida: **25 ícones 128×128 RGBA** (13 passivas + 12 evoluções), em 6 folhas de grade para o ChatGPT, mais o job de preparação. Os nomes das evoluções são os **provisórios** do plano; se o dono trocar um nome, o ícone não muda (o arquivo leva o `id`, não o nome).

## Regras comuns (STYLE-ICON, de `ASSET-GENERATION-LIST-20261021-r1.md`)

Anexar em todas as folhas: 1 ícone de arma existente (`assets/icons/weapons/espada_do_receptaculo.png`, evolução já aceita, para mostrar o salto de qualidade) e 1 ícone de passiva existente (`assets/icons/passives/alcance.png`). Cada célula é um ícone com ~170 px de respiro; fundo cinza liso #B4B4B4 que o script remove (`"key": "gray"`).

Bloco de estilo (colar no começo de cada prompt):

> Sheet of game icons in the style of the attached icons: each icon is a single centered object, dense pixel-art-inspired painting, dark outline, strong readable shape, limited palette with one glowing accent per icon, slight rim light from upper left, no frame, no text, no numbers, fills 80% of its cell. Flat solid light-gray background #B4B4B4 with no gradient, no floor shadow, no vignette. Icons separated by wide empty gray gaps and arranged in the stated reading order (left to right, top to bottom) so they can be cut automatically.

## Folha E01 — passivas (parte 1) · `assets_incoming/E01_a_v01.png`

Grade de 5 emblemas (2 linhas: 3 + 2). Ordem e destino (`assets/icons/passives/<id>.png`):

| # | id | Passiva | Desenho |
|---|---|---|---|
| 1 | `precisao` | Mira Justa | alvo circular com um ponto central dourado e uma pequena seta cravada |
| 2 | `ponta_certeira` | Ponta Certeira | ponta de estoque fina e longa com um brilho de crítico na extremidade |
| 3 | `sede_de_sangue` | Sede de Sangue | gota de sangue escura sobre uma presa curva, brilho vermelho |
| 4 | `brasa` | Brasa Viva | carvão incandescente com chamas laranja subindo |
| 5 | `acido` | Ácido Corrosivo | frasco derramando gota verde-ácida que corrói um pedaço de metal |

Prompt: *[bloco de estilo]* + "Five different emblem icons in this order: 1) a round archery target with a golden bullseye and a small arrow stuck in it; 2) a long thin rapier point with a small sparkle of critical light at the tip; 3) a dark blood drop above a curved fang, red glow; 4) a glowing ember lump with orange flames rising; 5) a small flask pouring a green acid drop that eats into a piece of metal. Passive-skill emblem look: slightly more symbolic and less detailed than weapon icons."

## Folha E02 — passivas (parte 2) · `assets_incoming/E02_a_v01.png`

| # | id | Passiva | Desenho |
|---|---|---|---|
| 1 | `olhar_abissal` | Olhar Abissal | olho fendido púrpura com pupila vertical, luz violeta saindo em onda |
| 2 | `ventura` | Ventura | trevo de quatro folhas dourado com uma moeda e uma estrela pequena |
| 3 | `tempo_suspenso` | Tempo Suspenso | relógio de bolso congelado com uma gota parada no ar, tons azul-prata |
| 4 | `veu_de_sombras` | Véu de Sombras | capuz/véu de névoa preta com bordas fluidas e dois pontos de luz fria |
| 5 | `memoria_viva` | Memória Viva | cabeça em silhueta com uma luz dourada que se desfaz em partículas |

Prompt: *[bloco de estilo]* + "Five different emblem icons in this order: 1) a purple slit-pupil eye with a ripple of violet light; 2) a golden four-leaf clover with a small coin and a tiny star; 3) a frozen pocket watch with a single droplet hanging motionless in the air, blue-silver tones; 4) a flowing black mist veil shaped like a hood with two cold-white points of light; 5) a head silhouette whose inside is a golden light dissolving into drifting particles. Same passive-skill emblem look as sheet E01."

## Folha E06 — passivas das evoluções antigas · `assets_incoming/E06_a_v01.png`

Para desfazer a repetição de `cota_de_malha` e `sabedoria` entre evoluções antigas (decisão do dono, 2026-11-04). Grade de 3 emblemas, mesmo estilo de E01.

| # | id | Passiva | Desenho |
|---|---|---|---|
| 1 | `quebra_defesas` | Quebra-Defesas | escudo rachado ao meio por um golpe, faíscas laranja |
| 2 | `vigor_sagrado` | Vigor Sagrado | coração de luz dourada dentro de um halo, linhas radiantes |
| 3 | `presenca_dominante` | Presença Dominante | mão aberta estendida com um olho dourado na palma e ondas de comando |

Prompt: *[bloco de estilo]* + "Three different emblem icons in this order: 1) a round shield cracked in two by a blow, orange sparks; 2) a glowing golden heart inside a halo with radiant lines; 3) an open outstretched hand with a golden eye in the palm and ripples of command around it. Same passive-skill emblem look as sheet E01."

## Folhas E03–E05 — armas evoluídas · `assets_incoming/E03_a_v01.png`, `E04_a_v01.png`, `E05_a_v01.png`

Cada ícone é a versão **mais imponente da arma base** (anexar o ícone base de cada uma, que está em `assets/icons/weapons/<base>.png`): mesmo objeto reconhecível, mais detalhe, brilho de acento mais forte e um ornamento de evolução (filigrana dourada), como a distância entre `espada_sombria` e `espada_do_receptaculo`. Destino: `assets/icons/weapons/<id>.png`.

**E03 (4 ícones, 2×2)**
1. `estocada_transfixante` — estoque longo e fino, ponta cravada em um disco de energia, runas de carisma roxas ao longo da lâmina.
2. `vigilia_perpetua` — vela grande de cera dourada ardendo com chama branco-dourada que forma um halo; sem cera derretida.
3. `selo_da_retidao` — selo circular radiante com três marcas luminosas atravessadas por uma flecha de luz.
4. `chicote_da_cobica` — chicote longo dourado enrolado, ponta com uma moeda, brilho de ouro nos elos.

**E04 (4 ícones, 2×2)**
1. `machado_devorador` — machado grande de lâmina larga escura com fissuras de brasa vermelho-alaranjada e uma mandíbula esculpida no gume.
2. `abraco_dos_tentaculos` — colar de tentáculos que se desenrola em vários tentáculos roxos e um olho ao centro.
3. `lamina_dissolvente` — espada curta que derrete em gotas verdes, metal corroído, brilho ácido.
4. `cajado_dos_desejos_realizados` — cajado ornamentado coroado por cinco pequenas luzes em leque, tom violeta e dourado.

**E05 (4 ícones, 2×2)**
1. `ampulheta_do_tempo_parado` — ampulheta grande com a areia parada em suspensão e anéis de luz prateada ao redor.
2. `lamina_do_eclipse` — lâmina escura em arco com um eclipse (disco negro com coroa de luz) atrás.
3. `memoria_reescrita` — orbe de memória com figuras translúcidas se reescrevendo em partículas douradas.
4. `pira_do_incendiario` — tocha grande transformada em pira de chamas laranja e brasas, cabo de madeira escurecida.

Prompt-base (trocar o bloco de lista por cada folha): *[bloco de estilo]* + "Four different evolved fantasy weapon icons in this order: [lista da folha]. Each is a grander, more ornate evolved version of the attached base icon of the same weapon: same recognizable object, more detail, stronger glow, thin gold filigree."

## Preparação (script, sem geração)

Jobs de recorte em `.atena/generated/asset-evolucoes-20261104-r1/jobs.json` (mesmo formato de `tools/asset_jobs/icons_v01.json`: `key: gray`, `split: components`, `fit: [128,128]`, `pad: 6`). Eles ainda **não** foram incorporados a `tools/asset_jobs/` (apontam para folhas que não existem). Ao receber as folhas: copiar para `assets_incoming/`, rodar a preparação, conferir a ordem dos recortes, importar no Godot e rodar `tests/test_weapon_evolution_coverage.gd` e `tests/test_new_content.gd`. Depois remover o `icon_like` das 12 evoluções que ganharem PNG próprio (o fallback some sozinho, porque `Items.weapon_icon` prefere o arquivo próprio).

## Fora desta leva (decisão do dono)

- **VFX**: as 12 evoluções herdam a família visual da base. Quick wins sem arte nova, a decidir na integração: `chicote_da_cobica` e `lamina_dissolvente` (corpo a corpo físicos) podem entrar em `MeleeVfx.EVOLVED_SHAPES` com `arco_fisico_evo`, que já existe; o `test_evolution_art_vfx` hoje exige que a base não entre. Arte evoluída nova para as demais (projéteis do Selo, do Cajado, da Lâmina do Eclipse e da Memória; áreas da Vigília, do Abraço e da Ampulheta) só se o dono pedir.
- **SFX**: as 12 evoluções reaproveitam os sons da base com tom 8% mais grave (`data/audio_manifest.json`); sons próprios dependem de pedido.
- **Cinemática de evolução e Codex**: usam o ícone e o nome; textos de Codex dependem dos nomes finais e do Vault.
- Não regerar nem alterar ícones já aceitos.
