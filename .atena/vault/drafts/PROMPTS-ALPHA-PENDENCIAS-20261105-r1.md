# Prompts das pendências do Alpha Demo, 2026-11-05, r1

Status: DRAFT, pedido do dono ("gerar todos os prompts que estiverem pendentes para fecharmos a versão alpha demo sem pendências"). Nenhuma geração, integração, aceite, commit ou publicação autorizados por este rascunho. Checkpoints dos demais planos preservados. Segue o formato de `PROMPTS-ASSETS-PEDRA-RUNICA-DURAO-20261104-r1.md`.

Não revelar nada de "cânone do mestre": os prompts descrevem só o que o jogo já mostra (epígrafes de fase, atmosfera, regras de combate).

## 0. Levantamento: o que realmente falta gerar

Rodei de novo `asset_gaps.gd` (16 lacunas) e conferi cada uma contra o código. **Cinco lacunas apontadas pela auditoria são falsos positivos** (ela procura pastas por convenção de nome e não lê `source_id`, `states` e o mapa de ícones do HUD):

| Lacuna da auditoria | Por que não é lacuna | Onde está a prova |
|---|---|---|
| `tentaculo_kraken` "falta `move`" | a velocidade é 0: o tentáculo é fixo e não anda; `idle`, `attack` e `death` existem | `data/enemies.json` (`speed: 0.0`), `ui/enemy_view.gd` (`states` sem `move`) |
| `molydeus_menor`, `ilusao_de_sucubo`, `ilusao_de_socothbenoth` "só sprite estático" | os três usam as animações do original via `source_id` (`molydeus_chefe`, `sucubo`, `cultista_de_socothbenoth`) | `ui/enemy_view.gd`, tabela `ANIMATED` |
| `sacerdote_mente_derretida` "sem `special.png`" | a sequência é dividida em `special_a` e `special_b` (mais `phase`), ambas presentes | `ui/enemy_view.gd`, pasta `assets/animations/enemies/sacerdote_mente_derretida/` |
| ícone de regra de fase em Docas | `docas_puddles.png` existe e está no mapa do HUD | `ui/hud.gd` (`stage_icons`) |
| `raiz_yggdrasil` (8 lacunas) | é fase de protótipo (`data/prototype_stages.json`), fora da campanha de 11 mapas | `data/stages.json` não a lista |

**Pendências reais para fechar o alpha** (e os lotes abaixo):

| Lote | O que | Necessário para o alpha? |
|---|---|---|
| A | Música e ambiência próprias de Docas, Reino Abissal e Domwieck (hoje reusam as de Dagruve, Pilares e Goranthis) | sim, é a pendência declarada no checkup |
| B | Ícone de regra de fase "alcançar o destino" (Reino Abissal e Domwieck; hoje sem ícone no HUD) | cosmético; fecha o conjunto de 11 mapas |
| C | 12 sons próprios das evoluções de armas (hoje reusam a base com tom 8% mais grave) | cosmético; fecha o plano de evolução |

Fora do alpha, só registrado (não geram prompt): HQ05 visual (pausada pelo dono: `generation_authorized: PAUSED_BY_OWNER_20261022`), Raiz de Yggdrasil (protótipo), idle animado dos altares (opcional), textos de Codex e nomes finais das evoluções (texto, dependem do Vault e do dono), e as 19 peles temáticas de chefe (já integradas; se o dono reprovar alguma na revisão, o prompt de refazer por chefe está em `PROMPTS-GOLPES-TELEGRAFADOS-TEMATICOS-20261104-r1.md`).

## Lote A — Música e ambiência de Docas, Reino Abissal e Domwieck

### Situação atual

`data/audio_manifest.json`, mapas `music` e `ambience`:
- `docas` usa `dagruve.wav`; `reino_abissal` usa `pilares.wav`; `domwieck` usa `goranthis.wav`.
- As faixas atuais são WAV PCM 16 bits, mono, 22 050 Hz, **24 s** de música e **12 s** de ambiência, em laço.
- São os três mapas de abertura do capítulo 1, de **180 s** cada, e o jogador ouve a trilha por 3 minutos, repetida.

Contexto de cada mapa (só o que o jogo já mostra):

| Mapa | Epígrafe | Atmosfera (`data/atmosphere.json`) | Pressão |
|---|---|---|---|
| Docas (M1) | "No porão de um galpão, um ritual espera. Num navio abandonado, outro traz uma Arch-hag e um Kraken." | maresia fria, azul-acinzentado, partículas lentas | introdutória, chefe ao fim |
| Reino Abissal | "Raízes colossais conduzem ao acampamento da legião e ao acesso ao ritual." | esporos de raiz, violeta, vinheta forte | incursão, objetivo de chegada (3 s no destino) |
| Domwieck | "Nottgard está sob invasão. Alcance o jardim de Ailalore." | cinzas e brasas da invasão, laranja quente | invasão, pico de pressão do capítulo 1 |

### Entrega (por mapa)

1. **Música**: 1 faixa em laço, **24 s** (laço sem estalo: o último compasso emenda no primeiro). WAV PCM 16 bits, mono, 22 050 Hz (pode vir em qualidade maior; a preparação converte e recorta).
2. **Ambiência**: 1 faixa em laço, **12 s**, sem melodia (camada de fundo sob a música).
Total: 3 músicas + 3 ambiências. Referências a anexar (estilo e nível sonoro): `assets/audio/music/dagruve.wav`, `shedaklah.wav`, `durao.wav` (música) e `assets/audio/ambience/dagruve.wav`, `durao.wav` (ambiência).

### Prompts de música (colar no gerador de música)

> **Docas** — Instrumental dark-fantasy game loop, exactly 24 seconds, seamless loop. A cold harbor at night: slow tension, around 84 BPM, minor mode. Low sustained cello and bowed double bass, a sparse muted piano figure like drops on wet wood, distant ship bell and creaking timber used as soft percussion, a faint whistling wind pad. Mood: foreboding but calm, an introduction to danger, no heroic fanfare. Medium-low dynamic range, no drums build, no vocals, no lyrics. Ending phrase resolves back into the first bar so it loops without a click.

> **Reino Abissal** — Instrumental dark-fantasy game loop, exactly 24 seconds, seamless loop. Descending into a root-choked underworld where a demonic legion camps: slow, heavy, around 70 BPM, minor mode with a lowered second. Deep drones, slow low brass swells, bowed metal and rumbling taiko-like deep drum hits spaced widely, a thin breathy choir-like pad (no words), faint violet shimmer on top. Mood: oppressive, vast, ritual menace, never melodic or cheerful. No vocals, no lyrics, no solo instrument stealing focus. Last bar blends into the first so it loops without a click.

> **Domwieck** — Instrumental dark-fantasy game loop, exactly 24 seconds, seamless loop. An elven garden district under invasion, warm embers and ash: urgent but sorrowful, around 96 BPM, minor mode with a lifted sixth. Plucked harp and a lonely solo flute or cor anglais for the lost beauty of the place, steady low string ostinato, soft war drums entering on beats 1 and 3, brief brass stabs, a crackling-fire texture. Mood: tragic, desperate defense, higher pressure than the harbor and the abyss. No vocals, no lyrics, no heroic victory cadence. Last bar blends into the first so it loops without a click.

### Prompts de ambiência

> **Docas** — Seamless ambience loop, exactly 12 seconds, no melody and no rhythm: cold harbor at night, gentle water lapping on wood and stone, distant creaking hulls and rigging, soft sea wind, an occasional faraway bell or gull kept very quiet. Stereo-to-mono friendly, low level, no sudden peaks, no music.

> **Reino Abissal** — Seamless ambience loop, exactly 12 seconds, no melody and no rhythm: a vast underground cavern of colossal roots, deep room tone, slow creaking wood, distant muffled legion camp noises (metal, murmurs, no intelligible words), dripping, faint spore-like airy hiss. Oppressive but quiet, no sudden peaks, no music.

> **Domwieck** — Seamless ambience loop, exactly 12 seconds, no melody and no rhythm: a burning garden district, steady crackling fire and drifting ash, distant shouting and clashing metal far away and blurry (no intelligible words), wind through leaves, falling stone dust. Tense but low level, no sudden peaks, no music.

### Destino e integração (após aceite do dono)

- Arquivos: `assets/audio/music/{docas,reino_abissal,domwieck}.wav` e `assets/audio/ambience/{docas,reino_abissal,domwieck}.wav`.
- Preparação: conversão para WAV PCM 16 bits, mono, 22 050 Hz; recorte exato em 24 s e 12 s; costura do laço (fade cruzado curto) e nivelamento pelo RMS das faixas de referência.
- `data/audio_manifest.json`: trocar `music.docas`, `music.reino_abissal`, `music.domwieck` e `ambience.docas`, `ambience.reino_abissal`, `ambience.domwieck` para os caminhos novos; manter `raiz_yggdrasil` apontando para `pilares.wav`. Rodar a importação do Godot e `tests/test_audio.gd` (toda fase com música e ambiência, arquivos existentes).
- Conferir em jogo uma partida de cada mapa (transição para a música de chefe, sem estalo no laço).

### Fora de escopo
- Não alterar músicas já aceitas (Dagruve, Shedaklah, Molor, Durao, Feng-tu, Shendilavri, Goranthis, Pilares, menu, chefe, vitória, derrota).
- Não mudar a mecânica de áudio, os volumes por barramento nem o sistema de transição.

## Lote B — Ícone de regra de fase "alcançar o destino"

### Lacuna
`ui/hud.gd` mapeia o ícone da regra de fase por mapa (`stage_icons`). Reino Abissal e Domwieck têm regra `kind: "none"` ("Sobreviva e permaneça três segundos no destino após o tempo indicado", `data/stage_rules.json`) e ficam sem ícone, como Durao (vazio de propósito). Como a regra aparece no HUD nos outros 8 mapas, o ícone fecha o conjunto.

### Entrega
1 ícone, **PNG RGBA 128×128** (exibido a 32×32 no HUD: a leitura precisa funcionar bem pequena), fundo realmente transparente.
Referências (acabamento): `assets/icons/stages/docas_puddles.png`, `feng_tu_strikes.png`, `pilares_rotation.png`.

### Prompt (STYLE-ICON de `ASSET-GENERATION-LIST-20261021-r1.md`)

> Single game icon in the style of the attached icons: centered object, dense pixel-art-inspired painting, dark outline, strong readable shape, limited palette with one glowing accent, slight rim light, no frame, no text, fills 80% of the canvas. Flat solid light-gray background #B4B4B4, no gradient, no floor shadow, no vignette. The icon: a destination marker, a glowing stone ring set on the ground seen at a slight three-quarter angle, with a bright upward beam of pale-gold light in its center and a small hourglass-like ring of three tiny glowing dots around the rim (three seconds to hold). Dark stone, cold gold glow. Must read clearly at 32 px: simple silhouette, high contrast, no fine detail.

### Destino e integração
Arquivo `assets/icons/stages/destino.png`. Em `ui/hud.gd`, no `stage_icons`, `"reino_abissal": "destino"` e `"domwieck": "destino"`. Preparar com a tarefa de ícones (chave de cinza, 128×128, margem 6) de `tools/asset_jobs/icons_v01.json`, importar, e conferir no HUD dos dois mapas a 100% e a 150% de escala de interface.

### Fora de escopo
Não criar ícone para Durao (vazio de propósito) nem alterar os 8 ícones existentes.

## Lote C — Sons próprios das 12 evoluções de armas

### Lacuna
`data/audio_manifest.json` tem os 12 eventos `weapon.<evolução>.fire` apontando para os WAV da arma base, com `pitch` 0,92. É o provisório do plano de evolução (`PLANO-EVOLUCOES-20261104-r1.md`).

### Entrega
Por evolução, **2 variações** de disparo, **0,3 a 0,8 s** cada, WAV mono PCM 16 bits 22 050 Hz, sem cauda longa (o jogo repete o som a cada 0,35 a 5 s), nível parecido com os `weapon.*.fire` atuais. Total 24 arquivos. Nome de saída: `weapon.<id>.fire_01.wav` e `_02.wav` em `assets/audio/sfx/weapon/`. Referências a anexar: o som atual da arma base de cada uma (para contraste) e `weapon.espada_do_receptaculo.fire_01.wav` (evolução já aceita).

Molde: *Game sound effect, [descrição], duration [x] seconds, dry with a short natural tail, no music, no voice, no background noise, punchy attack, mixed to sit under music.*

| Evolução (id) | Descrição | Duração |
|---|---|---|
| `estocada_transfixante` | thin arcane rapier thrust, fast metallic "shing" with a violet glass chime on the tip | 0,35 s |
| `vigilia_perpetua` | warm radiant bell swell with a soft candle-flame whoosh, healing feel | 0,8 s |
| `selo_da_retidao` | a luminous sigil stamp: bright ring-tone impact plus a short golden whoosh, two quick pulses | 0,5 s |
| `chicote_da_cobica` | whip crack with a bright jingle of coins | 0,45 s |
| `machado_devorador` | heavy demonic axe swing, low growl, fire crackle on the edge | 0,7 s |
| `abraco_dos_tentaculos` | wet slithering emergence of many tentacles with a low abyssal pulse | 0,8 s |
| `lamina_dissolvente` | blade slash followed by acid sizzle and hiss | 0,5 s |
| `cajado_dos_desejos_realizados` | airy whispered chorus into five quick sparkling chimes in a fan | 0,7 s |
| `ampulheta_do_tempo_parado` | time stopping: reversed clock tick, deep low thud, falling sand tail | 0,8 s |
| `lamina_do_eclipse` | dark triple blade whoosh with a low eclipse sub-bass swell | 0,6 s |
| `memoria_reescrita` | ghostly whispers with crystalline shimmer, a memory being overwritten | 0,6 s |
| `pira_do_incendiario` | big torch turning into a pyre: roaring fire whoosh with crackling embers | 0,7 s |

### Destino e integração
Em `data/audio_manifest.json`, trocar `files` de cada `weapon.<evolução>.fire` pelos dois arquivos novos e **remover o `pitch` 0,92** (o tom de reserva deixa de ser necessário). Rodar a importação, `tests/test_audio.gd` e `tests/test_vfx_sfx_coverage.gd`. Cada evolução continua cobrindo o evento (o teste exige assinatura sonora por arma).

### Fora de escopo
Não alterar os sons das armas base nem dos eventos de interface; não mexer em volume, prioridade ou `cooldown_ms`.

## Resumo para a decisão do dono

- Para fechar o alpha: **Lote A** (6 faixas de áudio). É a única pendência de conteúdo declarada no checkup.
- Para fechar o conjunto visual e o plano de evolução: **Lote B** (1 ícone) e **Lote C** (24 sons, 12 eventos). Cosméticos; o jogo roda sem eles.
- Nenhum sprite de inimigo, imagem de fase ou ícone de arma/passiva está pendente de geração.
- Sugestão de ordem: A, depois B, depois C. Geração e integração dependem da sua autorização e do aceite.
