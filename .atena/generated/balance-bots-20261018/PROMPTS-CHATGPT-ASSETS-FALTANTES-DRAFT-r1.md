---
id: PROMPTS-NOTTGARD-ASSETS-FALTANTES-20261018
revision: r1
status: DRAFT_AWAITING_OWNER_APPROVAL
origin: asset-gap audit (asset_gaps.gd) em 4de71c2
content_state: DRAFT
generation: NOT_PERFORMED
---

# Prompts para ChatGPT — assets faltantes (Windows x86_64)

Lista produzida por `asset_gaps.gd` (somente leitura) sobre a revisão `4de71c2`.
Cada bloco abaixo é **independente**: cole o prompt, anexe as referências citadas
(caminhos relativos à raiz do projeto) e salve a candidata no destino indicado.
Nada aqui altera runtime, dados ou canon; o aceite e a admissão seguem o fluxo
habitual (candidata → QA → aceite do dono → integração).

## Regras globais (valem para todos os prompts)

- Pixel art detalhada e sóbria, no mesmo acabamento dos assets existentes; contornos nítidos, paleta escura/fria, luz superior esquerda quando houver personagem ou objeto.
- **Sem texto, rótulo, logotipo, marca-d'água, grade visível ou moldura.** Sem lore nova: quando houver sprite estático de referência, a identidade vem dele.
- PNG RGBA com alfa real onde indicado (nada de xadrez de transparência gravado). Entregar na dimensão pedida; se o gerador não permitir, na mesma proporção, para reduzir depois.
- Folhas de animação: células lado a lado, **todas do mesmo tamanho**, mesma linha de base dos pés/contato, sem invasão entre células, câmera três-quartos isométrica 2:1.
- Para qualquer lote novo de personagem, direções só `move_n/ne/e/se/s` (regra vigente desde 2026-09-24); os inimigos usam a folha única `move`.
- Itens marcados **[PRECISA DECISÃO]** dependem de escolha de conteúdo do dono (não inventei lore).

## Prioridade 1 — mapas novos (Reino Abissal, Domwieck, Raiz de Yggdrasil)

Contexto: os três mapas jogáveis não têm miniatura de seleção, decais de chão, quebráveis temáticos nem ícone de regra no HUD. Música/ambiência são dívida conhecida (ver fim do documento); não são imagem.

### P1-01 · Miniatura de seleção — Reino Abissal
- Destino: `assets/stages/reino_abissal_thumb.png` · 480×320, opaco.
- Referências a anexar: `assets/stages/molor_thumb.png` (enquadramento/acabamento), `assets/hq/chapter1_r1/hq_n16_q5_roots_v02.png`, `assets/tiles/reino_abissal_roots_r1/surface.png`.
- Prompt: *Cena de paisagem em pixel art detalhada, 480×320, vista elevada em perspectiva de profundidade: raízes colossais entrelaçadas formam o único chão, cascas castanho-escuras com sulcos frios e reflexos avermelhados discretos; abaixo, um vazio cilíndrico profundo em violeta apagado; ao longe, pontos de fogo âmbar de um acampamento de legião sobre as raízes. Atmosfera pesada, sem criaturas em primeiro plano, sem texto. Mesmo acabamento e enquadramento da imagem de referência de miniatura.*

### P1-02 · Miniatura de seleção — Domwieck
- Destino: `assets/stages/domwieck_thumb.png` · 480×320, opaco.
- Referências: `assets/stages/molor_thumb.png`, `assets/hq/chapter1_r1/hq_n18_q3_domwieck_invasion_v01.png`, `assets/tiles/domwieck_r1/architecture.png`, `assets/tiles/domwieck_r1/garden.png`.
- Prompt: *Cena em pixel art detalhada, 480×320, distrito élfico sob invasão: calçamento frio, arquitetura élfica elegante parcialmente em ruínas, vegetação escura, incêndios âmbar periféricos, ao fundo um jardim circular de flores vermelhas e uma luz azul-clara vertical. Ruas vazias, sem personagens identificáveis, sem texto. Mesmo acabamento e enquadramento da miniatura de referência.*

### P1-03 · Miniatura de seleção — Raiz de Yggdrasil
- Destino: `assets/stages/raiz_yggdrasil_thumb.png` · 480×320, opaco.
- Referências: `assets/stages/molor_thumb.png`, `assets/tiles/yggdrasil_r1/trunk.png`, `assets/tiles/yggdrasil_r1/ground.png`, `assets/hq/` HQ20 aprovada (Q1/Q3/Q4 citadas em `.atena/specs/SPEC-NOTTGARD-YGGDRASIL-ART-20261017/`).
- Prompt: *Cena em pixel art detalhada, 480×320: raízes e ramificações monumentais de madeira castanha com grão longitudinal e nós, formando caminhos largos de casca; passagem com brilho roxo discreto ao fundo; profundidade escura nas bordas. Sem personagens, sem construções, sem texto. Mesmo acabamento da miniatura de referência.*

### P1-04/05/06 · Decais de chão (remendo + trilha) — um par por mapa
`data/ground_decals.json` usa dois decais por fase (~1774×887 de origem, exibidos ~320×160 em losango isométrico). Existe teste que exige os dois por mapa (ou desativação explícita).
- Destinos: `assets/decals/{reino_abissal,domwieck,raiz_yggdrasil}_{remendo,trilha}_01.png` · 1774×887, alfa real, bordas suaves.
- Referências: `assets/decals/dagruve_remendo_01.png`, `assets/decals/dagruve_trilha_01.png` + a textura de chão do mapa (`assets/tiles/<mapa>_*/ground|surface.png`).
- Prompt (trocar `<MATERIAL>`: *casca de raiz escura com sulcos frios* | *calçamento frio de pedra élfica com musgo e fuligem* | *casca de madeira castanha com fibras longitudinais*):
  - **remendo:** *Decal de chão em pixel art, vista isométrica 2:1 (losango achatado), 1774×887, fundo transparente. Um remendo irregular de desgaste/sujeira sobre <MATERIAL>, bordas dissolvidas em alfa, baixo contraste para não esconder projéteis, sem objetos nem texto.*
  - **trilha:** *Decal de chão em pixel art, vista isométrica 2:1, 1774×887, fundo transparente. Uma trilha estreita e sinuosa de pegadas/desgaste atravessando <MATERIAL>, extremidades dissolvidas em alfa, baixo contraste, sem objetos nem texto.*

### P1-07/08/09 · Quebrável temático por mapa (folha de morte 5 quadros)
Hoje os três mapas caem no fallback `arbusto_quebravel`. Formato do existente: `death.png` 2560×512 (5 células de 512×512). **[PRECISA DECISÃO]** do objeto de cada mapa; abaixo, proposta neutra derivada do dossiê dos mapas (sem lore nova):
- Reino Abissal → *carga/caixote de suprimentos da legião sobre raízes* (dossiê cita "carga/braseiros"). Destino: `assets/animations/enemies/carga_da_legiao_quebravel/death.png`.
- Domwieck → *vaso/urna de pedra élfica* (dossiê cita colunas/destroços). Destino: `assets/animations/enemies/urna_elfica_quebravel/death.png`.
- Raiz de Yggdrasil → *nó de raiz oco e quebradiço*. Destino: `assets/animations/enemies/no_de_raiz_quebravel/death.png`.
- Referências: `assets/animations/enemies/caixote_quebravel/death.png`, `assets/animations/enemies/urna_funeraria_quebravel/death.png`.
- Prompt: *Folha de animação em pixel art, 2560×512, 5 quadros de 512×512 lado a lado, fundo transparente. O objeto **<OBJETO>** intacto no quadro 1 e se despedaçando em lascas/fragmentos até restar um pequeno monte de destroços no quadro 5; mesma linha de base em todos os quadros, câmera três-quartos isométrica, luz superior esquerda, sem fogo, sem sangue, sem texto. Mesmo estilo e tamanho de objeto da folha de referência.*
- Depois de aprovado, falta só registrar em `Battle.BREAKABLE_TYPES_BY_STAGE` (código; não é assunto do prompt).

### P1-10 · Ícone da regra de fase — Docas
`hud.gd` mapeia ícones só para 7 fases; Docas tem regra ("Corrosão das Docas": poças que corroem) e não tem ícone. Destino: `assets/icons/stages/docas_puddles.png` · 128×128, alfa real. Referências: `assets/icons/stages/shedaklah_puddles.png`, `assets/icons/stages/molor_bubbles.png`.
- Prompt: *Ícone de interface em pixel art, 128×128, fundo transparente: uma poça de metal corroído verde-acinzentado borbulhando, vista isométrica, contorno nítido escuro, centralizado, sem texto. Mesmo acabamento dos ícones de referência.*
- Os mapas novos só precisam de ícone se ganharem regra (`stage_rules.json` não tem entrada para `raiz_yggdrasil`): **[PRECISA DECISÃO]**.

## Prioridade 2 — inimigos e chefes

### P2-01 · Molydeus (comum) — animações (hoje só sprite estático)
Aparece em Pilares como inimigo comum. Destino: `assets/animations/enemies/molydeus_menor/{idle,move,attack,death}.png`.
- Formatos (iguais a `zumbi`): `idle` 1024×384 (4 quadros 256×384), `move` 1536×384 (6), `attack` 1024×384 (4), `death` 1536×384 (6). Alfa real.
- Referências: `assets/enemies/molydeus_menor.png` (**identidade fixa**), `assets/animations/enemies/molydeus_chefe/idle.png` (estilo de animação do mesmo demônio), `assets/animations/enemies/zumbi/move.png` (ritmo/base).
- Prompts (substituir `<SEQ>` e quadros):
  - *Folha de animação em pixel art, **<N> quadros de 256×384** lado a lado (<W>×384), fundo transparente. Personagem exatamente igual ao sprite de referência anexado (Molydeus, mesma silhueta, cores e proporções), **<AÇÃO>**, câmera três-quartos isométrica, luz superior esquerda, mesma linha de base dos pés em todos os quadros, sem sombra projetada, sem texto, sem anatomia extra.*
  - idle → *respiração/balanço lento e ameaçador, 4 quadros, 1024×384* · move → *caminhada pesada para a direita da tela, ciclo de passada em 6 quadros, 1536×384* · attack → *golpe com a arma/garra do sprite, antecipação–impacto–recuperação, 4 quadros, 1024×384* · death → *colapsa e desfaz-se sem gore explícito, 6 quadros, 1536×384*.

### P2-02 · Ilusão de Súcubo e Ilusão de Socothbenoth (1 HP, só sprite estático)
São invocações efêmeras de 1 PV; o estático (`assets/enemies/ilusao_de_sucubo.png`, `…/ilusao_de_socothbenoth.png`) pode bastar. **[PRECISA DECISÃO]** se vale animar. Se sim, usar o prompt de P2-01 com os respectivos sprites como identidade e apenas `idle` + `death` (efeito de dissolução translúcida), mesmos formatos.

### P2-03 · Cartazes de introdução de chefe (640×360) — 7 chefes sem apresentação
Só o Sacerdote da Mente Derretida tem `boss_presentations.json` + imagem; os demais chefes entram sem pausa/cartaz. Cada cartaz: PNG opaco 640×360, `assets/ui/boss-intros/<id>.png`. Depois do arquivo, a entrada em `boss_presentations.json` (título/subtítulo/cor de transição) é dado, não imagem.
- Referências comuns: `assets/ui/boss-intros/sacerdote_mente_derretida.png` (enquadramento: personagem à direita em três quartos, cenário da fase ao fundo, noite/névoa), mais a miniatura da fase e o sprite estático do chefe.
- Molde: *Ilustração em pixel art detalhada, 640×360, cena cinematográfica de apresentação de chefe: **<CHEFE>** (idêntico ao sprite de referência anexado) em destaque à direita, três quartos, iluminado por luz lateral dramática; ao fundo **<CENÁRIO>** no mesmo estilo da miniatura de fase anexada. Sem texto, sem moldura, sem outros personagens.*

| id do chefe | Fase | `<CHEFE>` / sprite a anexar | `<CENÁRIO>` (miniatura a anexar) |
| --- | --- | --- | --- |
| zuggtmoy | Shedaklah | Zuggtmoy, Dama dos Fungos — `assets/enemies/zuggtmoy.png` | caverna fúngica — `assets/stages/shedaklah_thumb.png` |
| blogbog | Molor | Blogbog — `assets/enemies/blogbog.png` | caverna de bolhas viscosas — `assets/stages/molor_thumb.png` |
| molydeus_chefe | Durao | Molydeus, Carcereiro-Chefe — `assets/enemies/molydeus_chefe.png` | a jaula e o rio de almas — `assets/stages/durao_thumb.png` |
| discipulo_pestilento | Feng-tu | O Discípulo Pestilento — `assets/enemies/discipulo_pestilento.png` | templo de Tou Um — `assets/stages/feng_tu_thumb.png` |
| malcanthet | Shendilavri | Malcanthet, Rainha das Súcubos — `assets/enemies/malcanthet.png` | reino das súcubos — `assets/stages/shendilavri_thumb.png` |
| socothbenoth | Goranthis | Socothbenoth, Âncora de Juiblex — `assets/enemies/socothbenoth.png` | o verdadeiro Paraíso — `assets/stages/goranthis_thumb.png` |
| sintese_abissal | Pilares | A Síntese Abissal — `assets/enemies/sintese_abissal.png` | o céu sendo puxado para cá — `assets/stages/pilares_thumb.png` |

(Se algum `assets/enemies/<id>.png` não existir com esse nome, usar `assets/animations/enemies/<id>/idle.png`, quadro 1.)

### P2-04 · Folha `special` dos chefes com mecânica L5 sem ela (cosmético)
`sacerdote_mente_derretida` e `discipulo_pestilento` têm mecânica própria (L5) e não têm `special.png`. Destino: `assets/animations/enemies/<id>/special.png` · 1536×384 (6 quadros 256×384), alfa real. Referências: `…/<id>/idle.png` e `assets/animations/enemies/blogbog/special.png` (estilo). Prompt: igual ao de P2-01, ação = *conjuração/gesto de poder do chefe (a mecânica já existente), 6 quadros, efeito contido e dentro da célula*. **[PRECISA DECISÃO]** do que a mecânica mostra; ver `data/boss_mechanics.json`.

## Prioridade 3 — ícones 128×128 (alfa real)

Estilo: ícone pixel art centralizado, contorno escuro nítido, fundo transparente, sem texto. Referências a anexar em todos: `assets/icons/boons/ghaunadaur_fome.png` (bênçãos), `assets/icons/weapons/adaga.png`/`bola_de_fogo.png` (armas), `assets/icons/items/adaga.png` (itens). Molde: *Ícone de interface em pixel art, 128×128, fundo transparente: **<OBJETO>**, vista frontal ligeiramente inclinada, contorno escuro nítido, destaque de cor da divindade/elemento, centralizado, sem texto. Mesmo acabamento dos ícones de referência.*

### Armas sem ícone próprio → `assets/icons/weapons/<id>.png`
| id | `<OBJETO>` (do `weapons.json`) |
| --- | --- |
| maca_demolidora | Maça Demolidora — maça pesada que racha a guarda e atordoa |
| raio_da_ruina | Raio da Ruína — três raios que atravessam e quebram a guarda |
| dominio_coletivo | Domínio Coletivo — três projéteis de vontade que atravessam e atordoam |
| martelo_da_luz | Martelo da Luz — martelo cuja luz varre um arco largo |
| constelacao_de_silva | Constelação de Silva — constelação caindo sobre os alvos |
| memoria_alterada | Memória Alterada — projétil de memória que deixa o alvo lento |
| tocha_do_incendiario | Tocha do Incendiário — tocha em chamas em golpe de arco |

### Bênçãos sem ícone próprio → `assets/icons/boons/<id>.png`
| id | Divindade · nome | `<OBJETO>` sugerido (a partir da descrição; ajustar se o canon pedir outro símbolo) |
| --- | --- | --- |
| mask_faca_sombra | Mask · Faca na Sombra | faca escura envolta em sombra |
| mask_fechaduras | Mask · Mestre das Fechaduras | chave/gazua sobre fechadura |
| lliira_passo_leve | Lliira · Passo Leve | pegada leve com acento dourado de alegria |
| shar_pacto_perda | Shar · Pacto da Perda | selo/pacto rompendo com lágrima negra |
| shar_veu_noite | Shar · Véu da Noite | véu de noite com lua apagada |
| selune_prata | Selûne · Luar Prateado | lua crescente prateada |
| ghaunadaur_massa | Ghaunadaur · Massa Faminta | massa gelatinosa faminta com boca |
| helion_tarn | Helion · Resto da Tarn | fragmento azul-claro da Tarn |
| lu_yueh_praga | Lu Yueh · Imunidade à Praga | máscara/amuleto contra praga |
| zuggtmoy_esporos | Zuggtmoy · Esporos Benfazejos | cogumelo soltando esporos |
| zuggtmoy_guarnicao | Zuggtmoy · Guarnição Fúngica | escudo/armadura de fungos |
| juiblex_gelatina | Juiblex · Corpo Gelatinoso | gota de gelatina verde translúcida |
| juiblex_colmeia | Juiblex · Mente-Colmeia | colmeia/mente fúngica interligada |

### Item único sem ícone → `assets/icons/items/espelho_das_almas_desejantes.png`
`<OBJETO>` = *espelho de mão ornado, amuleto, com reflexo enevoado de rostos*. **[PRECISA DECISÃO]**: `items.json` não traz descrição e o Vault pode ter descrição canônica; consultar `F:\dev\nottgard-vault` antes de gerar.

## Fora de escopo de imagem (para o dono / outras ferramentas)

- **Áudio** (3 mapas): faltam música e ambiência para `reino_abissal`, `domwieck` e `raiz_yggdrasil` (`audio_manifest.json`); o dossiê dos mapas diz explicitamente que não é necessário ao protótipo. Não há gerador de áudio neste projeto (`tools/generate_audio.js` citado no manifesto não existe aqui).
- **Texto/dados** que dependem de lore aprovada: `chronicles.json` (3 mapas), `stage_story.json` e `stage_rules.json`/`stage_events.json` (`raiz_yggdrasil`), `atmosphere.json` (3 mapas). Não escrevi conteúdo: exige decisão do dono (vault prevalece).
- Quatro testes da suíte já falham por esses itens (dívida DEBT-PORT registrada na B004): é esperado até serem preenchidos ou os mapas serem tratados como protótipo nos contratos globais.

## Observação — Tentáculo do Kraken

`tentaculo_kraken` tem `idle/attack/death` mas não `move`; é um tentáculo (provavelmente estacionário em Docas), então a falta de `move` não exige prompt. Se o dono quiser que ele se mova, usar o molde de P2-01 com `assets/animations/enemies/tentaculo_kraken/idle.png` como identidade.
