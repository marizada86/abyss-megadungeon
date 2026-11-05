# Estilo de arte do Abyss Megadungeon — guia de produção (2026-11-05, r1)

Status: **DRAFT**. Documento descritivo: extrai o que o jogo e os prompts já aceitos fazem hoje. Não cria direção nova, não promove nada a CANON e não substitui as decisões de direção aprovadas (Domwieck e Yggdrasil, em `.atena/vault/canon/`). Cada regra cita a fonte; o que não está definido está na seção 9.

Uso: anexar este guia e as pranchas de referência de cada lote nos prompts de geração de imagens, e consultá-lo na preparação e no QA.

Fontes de outras sessões consideradas: `PROMPTS-GOLPES-TELEGRAFADOS-COMUNS-20261105-r1.md` (rascunho de prompts T20 a T22, nenhuma imagem gerada) e as seções `telegraph_skins_20261104` e `telegraph_comuns_prompts_20261105` do `plan.yaml` (22 peles de aviso de chefes).

## 1. Identidade visual

- Jogo de ação 2D isométrico, dark fantasy. Arte **pintada e ornamentada**, com acabamento denso inspirado em pixel art, silhueta legível e contorno escuro (prompts de ícones e VFX aceitos em `.atena/generated/asset-evolucoes-20261104-r1/prompts` e `vfx-evolucoes-20261104-r1/prompts`).
- Molduras de UI: ouro sobre ferro escuro, cantos ornamentados e rebites (ex.: `assets/ui/ficha/ficha_moldura_painel.png`, chips de HUD em `assets/ui/hud/`).
- Efeitos: luz sobre fundo escuro, com realces controlados (ouro, violeta, prata no lote de evoluções).
- Isto não é pixel art de grade fixa nem vetor liso. A avaliação da forja 2D (2026-11-05) concluiu que arte procedural limpa destoa deste acabamento (`.atena/generated/forge-2d-proposal-20261105-r1/f1-levantamento.md`).

## 2. Paleta

### Interface (`ui/ui_kit.gd`)

| Papel | Valor |
|---|---|
| Ouro | `#EDC766` |
| Ouro apagado | `#9E8047` |
| Ferro | `#5C596B` |
| Texto | `#EBE6DB` |
| Texto apagado | `#9E9EAD` |
| Título de painel (`ui/abyss_panel.gd`) | `#E6BF6B` |
| Texto secundário (`ui/abyss_panel.gd`) | `#BFB3CC` |

### Raridade (`core/items.gd`, texto e destaque)

| Raridade | Valor |
|---|---|
| Comum | `#D9D9D9` |
| Mágico | `#7399FF` |
| Incomum | `#66D973` |
| Raro | `#FFE64D` |
| Único | `#FF8C26` |

A gema do cartão de oferta usa um conjunto próprio e levemente diferente (`ui/offer_card.gd`, `RARITY_GEM`): comum `#9E9EA8`, mágico `#5999FF`, incomum `#66D980`, raro `#FFB340`, único `#C773FF`. O único é laranja no texto e violeta na gema; é assim hoje (ver seção 9).

### Tipo de dano (avisos de ataque, `core/danger_feedback.gd`)

| Tipo | Principal | Realce |
|---|---|---|
| Físico | `#FF452E` | `#FFB85C` |
| Mágico | `#AD61FF` | `#E6C7FF` |
| Fogo | `#FF801A` | `#FFE066` |
| Radiante | `#FFD966` | `#FFFACC` |

### Deuses e heróis

Cada herói tem cor base em `data` (campo `color`), e deuses têm temas próprios em `core/divine_visuals.gd` (cor primária, acento de aura e de impacto, contorno e motivo). Os VFX de projétil e de área são **matizados pelo deus do herói** em jogo (o QA de 2026-11-04 registra a cor seguindo o tema do deus). Famílias com `own_color` (ex.: Memória Alterada) já vêm coloridas e só são matizadas. A arte-fonte deve ser neutra o bastante para aceitar a matização, ou declarar `own_color`.

## 3. Acessibilidade (restrição de arte)

- **Cor nunca é a única pista.** O dano tem glifo ao lado do número: fogo ▲, radiante ●, mágico ◆, físico sem marca (`core/accessibility.gd`).
- Existem modos para protanopia, deuteranopia e tritanopia, com paletas próprias de raridade e dano (`core/accessibility.gd`). A arte nova não deve depender de distinguir só por matiz.
- Existe modo de **contraste alto**: janelas opacas, escurecimento maior, contorno de 4 px `#050509` (`HC_OUTLINE_SIZE`, `HC_OUTLINE_COLOR`) e limites de luminância 0,3 a 0,82. Fundos de UI e texturas devem continuar legíveis com isso.
- O ajuste **"Impacto reduzido"** congela o quadro dos avisos (`PROMPTS-GOLPES-TELEGRAFADOS-COMUNS-20261105-r1.md`) e o plano de UI/Quartel manda preservá-lo nas ofertas; arte animada precisa funcionar parada em um quadro.
- Não alterar mecânica, raio, dano, cadência ou acessibilidade para acomodar arte (regra dos handoffs de VFX).

## 4. Regras gerais de produção

1. **Sem texto na arte.** Nada de letras, números, rótulos, símbolos que lembrem escrita, logotipo ou marca d'água. O texto vem do jogo (localizável e escalável).
2. **Uma coisa por célula ou ícone.** Sem efeitos, símbolos ou personagens "bônus".
3. **Sem cenário nem sombra** em fontes de efeito e de ícone: o fundo é uma chave de cor pura (seção 6 e 7).
4. **Margem** dentro da célula: os prompts pedem 40 px de margem escura em folhas de VFX; a preparação usa 23 px em células de 256 e o QA exige no mínimo 20 px (`tools/asset_prep.gd`, QA de 2026-11-04).
5. **Uma escala por animação.** Não normalizar quadro a quadro: crescimento e dissipação precisam ser preservados; pivô medido, nunca só o centro da caixa.
6. **Fonte gerada não é arte final.** Toda fonte passa por aceite visual humano por ID e hash, depois preparação, depois QA. Aceite de fonte não é aceite de integração. Conteúdo visual permanece DRAFT até decisão do dono.
7. **Nomes de armas e personagens não vão para a arte**, e há renomeação por direitos autorais a fazer antes de divulgação pública (decisão do dono para o alpha demo, 2026-11-04); isso reforça a regra 1.

## 5. Tamanhos e formatos observados

Exemplos reais do repositório; não são limites, e há mistura entre categorias.

| Categoria | Exemplo | Formato |
|---|---|---|
| Ícones (armas, itens, bênçãos, passivas, fases) | `assets/icons/items/adaga.png` | 128×128 RGBA |
| Retrato de HUD | `assets/portraits/hud/arlindo.png` | 256×256 RGBA |
| Retrato da ficha | `assets/portraits/ficha/arlindo.png` | 768×432 RGBA |
| Retrato completo | `assets/portraits/arlindo.png` | 1536×1024 RGB |
| Herói (estático) | `assets/heroes/arlindo.png` | 512×512 RGBA |
| Inimigo | `assets/enemies/aberracao_shu.png` | 320×480 RGBA |
| Prop | `assets/props/barril_01.png` | 256×256 RGBA |
| Chão (ladrilho) | `assets/tiles/molor_ground.png` | 128×64 RGB |
| Decalque | `assets/decals/dagruve_remendo_01.png` | 1774×887 RGBA |
| Barra de HUD | `assets/ui/hud/hud_barra_pv.png` | 300×28 RGBA |
| Botão de HUD | `assets/ui/hud/hud_botao_pausa.png` | 56×56 RGBA |
| Botão do Quartel | `assets/ui/quartel/botao_bloqueado.png` | 240×48 RGBA |
| Janela padrão | `ui/ui_kit.gd` | janela 1088×612 sobre tela 1280×720; arte de moldura 1280×720 com 22×24 px transparentes; recuo de conteúdo 64×56 |
| Atlas de VFX de projétil | `assets/vfx/orbe_radiante.png` | 2048×256: 8 células de 256, voo 0–3 em laço, impacto 4–7 de disparo único |
| Atlas de VFX de área | `assets/vfx/pulso_evo.png` | 1536×256: 6 células de 256 |

Importação: filtro de canvas padrão (`default_texture_filter=0`).

## 6. VFX

Fonte: prompts do lote de evoluções (`vfx-evolucoes-20261104-r1/prompts`), `core/projectile_vfx.gd`, `tools/asset_prep.gd`.

- **Fundo preto puro `#000000`** na fonte, para mistura **aditiva** (a escuridão é ausência de luz). Sem cinza de tela, sem contorno preto pintado. A chave de preto vira alfa a partir do brilho na preparação.
- Fonte típica: 1536×1024. Projétil: grade 4×2 (células 384×512), linha de cima com 4 quadros de **voo em laço**, linha de baixo com 4 de **impacto em disparo único** (faísca de contato, explosão, dispersão, faíscas finais), todos no mesmo centro. Área: grade 3×2 (células 512×512), 6 quadros.
- Voo: escala e pivô fixos, pulso sutil; a arma anda para a direita, com rastro à esquerda. Impacto: não é cena de explosão, e sim o impacto daquele projétil.
- Runtime: voo a 12 fps, impacto em 0,30 s, pivô no centro da célula (`pivot_x` é o centroide de luz medido nos quadros de voo), escala por família.
- Pulsos de área são desenhados como círculo visto de cima; a projeção isométrica é aplicada na preparação ou no runtime.
- **Brilho constante entre os quadros de voo** (QA de 2026-11-05): a razão mínimo/máximo da energia deve ficar perto das outras famílias (0,92 a 0,95). Se a fonte variar muito, equalizar na preparação.

### 6.1 Avisos de golpes inimigos (telegrafados)

Fontes: `telegraph_skins_20261104` (plano), `core/boss_vfx.gd`, `ui/overlay.gd`, `PROMPTS-GOLPES-TELEGRAFADOS-COMUNS-20261105-r1.md`.

- **O que a arte cobre:** o *corpo* do aviso. O avanço (preenchimento que enche até o disparo, linha de frente, mira que fecha) continua desenhado em código. A detonação posterior tem arte própria (`detonacao_fisica`, `detonacao_magica`); o aviso não a repete.
- **Cor pelo jogo, não pela arte.** O jogo tinge cada aviso pelo tipo de dano (tabela da seção 2) e troca a cor principal nos modos de daltonismo. As folhas dos comuns são **neutras e tingíveis**: núcleo branco-amarelado, bordas âmbar quentes, saturação baixa. Se o tingimento ficar lavado em violeta ou radiante, gera-se uma variante por tipo; isso só depois de ver o resultado.
- **Leitura de perigo pela forma e pelo pulso**, não só pela cor (reforça a seção 3).
- **Fundo preto puro aditivo**, sem contorno escuro, **sem cinza e sem magenta** (nem na fronteira entre tons).
- **Projeção:** corpos que ficam no chão (faixa de investida, círculo de área) são desenhados **vistos de cima, sem perspectiva**; o jogo projeta no piso isométrico. A mira do atirador fica em tela, como o feixe do chefe (linha fina na altura do peito, elevação de 16 px).
- **Fatiamento:** feixes e faixas em três pedaços (tampa esquerda, meio esticável, tampa direita), com meio uniforme. Âncora fixa, laço contínuo, mesmo centro em todos os quadros.
- **Margem na fonte:** 20 px (faixa e mira, células de 256) e 48 px (círculo, células de 384). Nas peles de chefes a margem mínima preparada foi 22 px.
- **Peles de chefes (integradas, 22 folhas, 9 chefes):** `assets/vfx/boss_*_<chefe>.png`. Calibração: corpo de varredura de 184 px (aviso) e 195 px (feixe), selo de 72 px e marca de 73,5 px de meia extensão, carga com base em 198,5 px. Quando o chefe ou o arquivo não tem pele, o jogo usa a folha neutra.
- **Contrato de fallback:** o código usa a folha quando ela existe e cai no desenho atual quando falta o arquivo.
- **Avisos dos comuns (fontes aceitas em 2026-11-05):** T20 faixa de investida, T21 mira do atirador e T22 círculo de golpe em área, em `assets_incoming/queue-20261105-r1/`. Preparadas e integradas localmente em 2026-11-05 (`assets/vfx/aviso_comum_*.png`, `ui/telegraph_art.gd`, `ui/overlay.gd`; sem commit): 1536×256 (T20, T21) e 1024×256 (T22), **neutras** (branco com o brilho no alfa) para o jogo tingir por `warn.main`. As fontes saíram em âmbar saturado e T20/T21 em 2172×724, o que a preparação resolveu (ver `.atena/generated/asset-queue-20261105-r1/prep/LEIA-ME.md`). Convenção para folhas que o jogo tinge: cor neutra no arquivo, nunca âmbar; as folhas "neutras" de chefe já aceitas não seguem isso, são temáticas e saturadas.
- **Referências:** estes prompts anexam nenhuma imagem de referência e descrevem a geometria por coordenadas; os lotes de VFX e ícones anexam uma prancha de referência. Qualquer das duas formas vale; o importante é a geometria exata no prompt.

## 7. Ícones

Fonte: prompt de ícones de evoluções e passivas.

- Cada ícone é **um objeto centrado**, pintura densa inspirada em pixel art, **contorno escuro**, forma legível, **paleta limitada com um acento brilhante por ícone**, leve luz de borda vinda de cima à esquerda, sem moldura.
- Fundo: **cinza sólido claro `#B4B4B4`**, sem gradiente, sem sombra de chão, sem vinheta; ícones separados por grandes vãos para corte automático. Folha 1536×1024, cada ícone ocupando cerca de 65% da célula.
- Passivas: emblema levemente mais simbólico e menos detalhado que os ícones de arma.
- Saída final 128×128 RGBA, cantos e borda transparentes, sem cinza de fundo residual (QA de 2026-11-04: margem de pelo menos 3 px e menos de 2% de resíduo).

## 8. Ambientes e interface

- **Ambientes:** a direção é por região e vem de decisões próprias. Domwieck: cidade élfica de pedra clara, pavimento frio, fogo âmbar localizado, estrela caída cristalina azul-clara. Yggdrasil: casca orgânica e fibras, junções naturais, bordas profundas, tronco monumental. Preservar escala, câmera, rotas e combate (`DEC-DOMWIECK-ART-DIRECTION-20261017-r1`, `DEC-YGGDRASIL-ART-DIRECTION-20261017-r1`).
- **Interface:** moldura e peças dos assets aprovados; cartões de oferta combinam arte e desenho em código (`StyleBoxFlat` com ornamentos). Caixas planas em código são usadas em pontos pequenos (chips, banners).

## 9. Lacunas e decisões do dono pendentes

- **Mistura de estilos nos ícones:** ícones novos são pintados e detalhados; alguns antigos (`forca`, `carisma`, `cota_de_malha`) são mais simples. O QA de 2026-11-04 registrou isso como decisão estética do dono.
- **Dois conjuntos de cor de raridade** (texto e gema do cartão) divergem, em especial no Único. Não há regra dizendo se é intencional.
- **Sem especificação formal** de tamanho para heróis, inimigos, props e retratos; os valores da seção 5 são observações, não contrato.
- **Sem guia de cor para ambientes** além das duas direções acima.
- **Renomeação por direitos autorais** em andamento (trabalho separado do dono): prompts e arte não devem carregar nomes.
- **Avisos dos comuns:** folha neutra tingida pelo jogo ou variantes por tipo de dano (3 imagens contra 12) é decisão do dono ao revisar (`PROMPTS-GOLPES-TELEGRAFADOS-COMUNS-20261105-r1.md`). T20 a T22 foram geradas em âmbar saturado e aceitas como fontes; a neutralização de cor fica para a preparação (ver recibo).
- **Regra "sem magenta" contra a fronteira violeta/rosa** em cinco folhas de chefes (T04, T09, T13, T15, T18): o dono aprovou essas folhas como entregues em 2026-11-05 (`telegraph_skins_20261104`). Fica sem registro se a regra vale só para o fundo da fonte ou também para o conteúdo da arte; para folhas novas, tratar a fronteira violeta/rosa como risco a avisar, não como erro.
- **Aceite das 19 folhas de chefes da segunda leva:** dado pelo dono em 2026-11-05 (recibo em `.atena/generated/asset-queue-20261104-r2/visual-acceptance.json`). A decisão sobre a regra "sem magenta" nas cinco folhas citadas acima foi aprovada em seguida (mesma data).
- Este guia é DRAFT: pede revisão do dono antes de virar referência obrigatória.

## 10. Esqueletos de prompt (extraídos dos lotes aceitos)

VFX de projétil: "Use case: stylized-concept. Production animation sprite sheet for Abyss Megadungeon, a 2D isometric dark fantasy action game. Dense pixel-art-inspired painted luminous effects, crisp readable silhouette, controlled <realces>. Pure uniform BLACK #000000 background for additive blending... no floor, scenery, shadows, characters, labels, text, numbers, grid lines, borders, logo or watermark. Canvas 1536x1024. Every effect fully contained within its invisible cell, at least 40px black margin... Exactly EIGHT frames in a FOUR-column TWO-row grid, each cell 384x512... Top row: four seamless looping FLIGHT frames... Bottom row: four ONE-SHOT IMPACT frames..."

Ícones: "Use case: stylized-concept. Sheet of game icons in the style of the attached reference icons: each icon is a single centered object, dense pixel-art-inspired painting, dark outline, strong readable shape, limited palette with one glowing accent per icon, slight rim light from upper left, no frame, no text, no numbers. Flat solid light-gray background #B4B4B4... Each icon fills 65% of its cell..."

Anexar sempre a prancha de referência do lote (por exemplo `ref-existing-vfx.png` nos lotes de VFX); ela guia o acabamento, e o prompt indica quais linhas usar.
