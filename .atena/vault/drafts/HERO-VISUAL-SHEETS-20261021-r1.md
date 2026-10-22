# Fichas visuais dos 12 heróis jogáveis — R0 (2026-10-21, r1)

Status: DRAFT. Plano: `PLAN-NOTTGARD-HERO-ART-RESET-20261021`, lote R0 (somente leitura; nada gerado, nada do jogo alterado).
Fontes: Vault `F:\dev\nottgard-vault` HEAD local `50008c9` (2026-10-20), referências CANON em `output/referencias-personagens/`, dossiês `02_Personagens` e `03_NPCs`, `data/heroes.json`, `data/weapons.json`, `data/abilities.json`, `data/hero_bios.json`, `ui/hero_view.gd` e as tiras atuais. Onde divergem, o Vault vale mais que o Nottcard e que o prompt antigo (`ART-PROMPTS-016`).

Como ler: **CANON** = o que as imagens do Vault mostram (identidade e roupa); **Jogo** = arma, habilidade e efeitos que o jogo define (as referências CANON são sem arma); **Diverge** = arte atual ou prompt antigo contra o CANON; **Espelho** = se o oeste pode ser o leste espelhado.

Altura em tela (`HERO_DISPLAY_HEIGHT`): Korrak 76, Kayron 66, Sylas 64, Maelor 64, Erik 64, Nyrelia 62, Arlindo 62, Durvall 60, Zynara 60, Bromnor 48, Leoric 40, Brook 40 (px). Qualquer detalhe menor que ~3 px nessa altura some.

## Decisões do dono aplicadas (2026-10-21)

A1 Kayron pelo CANON pós-S24; A2 Erik raspado; A3 luz de Maelor dourada-branca e não desenhada; A4 Leoric com a concha; A5 Brook sem arma, mão livre; A6 vistas CANON da Nyrelia antes do R3. Pendente: A7 (existe Vault mais novo que `50008c9`?). Efeitos no pacote de prompts: `.atena/generated/hero-art-reset-20261021/prompts/`.

## Divergências que mudam o trabalho (resumo)

| # | Herói | Divergência | Efeito |
|---|---|---|---|
| D1 | **Kayron** | CANON pós-S24: roupão branco com tatuagens negras tribais, faixa vermelha, calça preta, botas pretas; cabelo branco, olhos totalmente vermelhos. Jogo (retrato e tiras): armadura escura e capa roxa. Só existe CANON pós-S24 (a pasta `CHAR-028/S01` está vazia). | Trocar o figurino inteiro ou manter o atual: decisão do dono (A1). |
| D2 | **Erik** | Texto do Vault e bio do jogo: "raspa a cabeça e a barba para não ser reconhecido". Imagens CANON e tiras atuais: cabelo preto e barba por fazer. | Decisão do dono (A2). |
| D3 | **Brook** | Prompt antigo: anão jovem, barba castanha, orelhas curtas. CANON e jogo: cabelo e barba brancos, orelhas pontudas, baixo e largo, armadura rebitada, capa vermelha rasgada. Decidido: seguir a imagem CANON. Raça escrita no jogo: halfling. | Prompt reescrito pelo CANON. |
| D4 | **Leoric** | Jogo: arma é a "Concha de Feng-tu" (Sopro de Estrela); Feng-tu é um andar da campanha, mas o dossiê de Leoric não cita a concha. Tira atual: cajado com gema azul, que também não está no Vault. | Nenhum dos dois objetos é CANON: decisão do dono (A4). |
| D5 | **Sylas** | CANON: capuz preto com chifres curvos, máscara escura cobrindo o rosto, olhos violeta, robe com bordas magenta. Tira atual: com adagas nas mãos; as adagas não estão no Vault. Arma do jogo é um raio. | Tirar as adagas; efeito sai das mãos. |
| D6 | **Maelor** | Meio-elfo, devoto de Sendrinah, arma "Raio de Luz". Tira atual: chama azul na mão. O Vault não fixa a cor da luz. | Cor do efeito: decisão do dono (A3). |
| D7 | **Bromnor** | A tira atual mostra dois martelos dourados nas costas. O Vault tem um martelo (Martelo da Luz, forjado com lasca de Ailalore; vira Glória). | Um martelo só. |
| D8 | **Durvall** | Prompt e Vault usam "Receptáculo"; o jogo oculta o termo. A referência CANON é sem arma; a arma do jogo é a Espada Sombria. | Regra de "nunca aparece" explícita. |
| D9 | **Brook (arma)** | Tira atual: maça de espinhos. O Vault não dá arma ao Brook; o martelo de Bromnor é objeto procurado, não dele. Jogo: "Sentença de Lliira", pulso radiante. | Arma visível: decisão do dono (A5). |

## 1. Durvall — Drow, Armadura Negra — prova de contrato (R2)
- **CANON** (`CHAR-015/historico-S01-S09`, 4 vistas): drow alto e magro, pele cinza-azulada, cabelo branco longo e liso até o meio das costas, orelhas pontudas, rosto severo. Armadura negra de placas em forma de folha com pontas, ombreiras com espinhos, grevas pontudas, luvas de placas. **Faixa vermelha rasgada na cintura**, com um pano que cai pela frente-lado.
- **Jogo**: Espada Sombria (golpe em arco à frente). Ruptura Sombria: golpe frontal que rasga a armadura. Passiva Armadura Negra.
- **Nunca aparece**: Receptáculo, Ghaunadaur como ocupante, Astherion, A Síntese Abissal, qualquer símbolo do segredo do mestre.
- **Silhueta**: alto e fino, cabelo branco é o marcador mais legível a 60 px; ombreiras com ponta.
- **Espelho**: não. Pano vermelho de um lado e espada: oeste real (já existe).
- **Aprendido no piloto**: demorou demais a aceitar; passou a ter tiras reais de oeste em célula larga. Reusar a lição, não a arte.

## 2. Korrak Nammat — Goliath — prova de contrato (R2)
- **CANON** (`CHAR-030/S10-S12`): goliath de pele cinza-pedra com veios, dois metros e trinta, músculo enorme. Cabeça raspada com crista de cabelo escuro no meio, barba preta cheia. Colete de couro rebitado, **ombreira de metal com espinhos no ombro esquerdo e manto de pele marrom no direito**, bracers de couro, cinto largo com disco, saiote de tiras e botas altas com pele.
- **Jogo**: Machado de Xar'gath, lâmina infernal com veios de lava, queima e devolve vida. Impacto de Xar'gath: impacto de fogo em área. Passiva: +20% de dano, −10% de velocidade.
- **Nunca aparece**: nada de cânone do mestre.
- **Silhueta**: o maior sprite (76 px); massa de ombros e machado grande. Passada pesada e curta (a passiva o deixa mais lento).
- **Espelho**: sim, com ressalva: ombreira e manto trocam de lado. Machado de duas mãos fica natural.
- **Diverge**: tira atual `move_w/sw/nw` (sem uso) é outro personagem, magro e alto. Descartar.

## 3. Erik Blackthorn — Humano, batedor dos Grimholders — prova de contrato (R2, assimétrico)
- **CANON** (`EEEE-r01`, 4 vistas com `B-FALT-005-04`): humano de cabelo preto desgrenhado, barba por fazer, cicatriz no rosto; capuz verde-acinzentado, pele de animal nas ombreiras, túnica rasgada verde e cinza, **amuleto dourado brilhante no peito (Amuleto da Luz)**, correias de couro cruzadas, **espada nas costas com o cabo acima do ombro**, botas de fivelas.
- **Jogo**: Tocha do Incendiário (golpe de tocha em arco, queima). Navios em Chamas: faixa de fogo à frente por 8 s. Passiva de fogo e área.
- **Nunca aparece**: nada de cânone do mestre. Sem fogo cobrindo o corpo.
- **Silhueta**: tocha acesa de um lado e cabo da espada atrás do ombro. A chama é o marcador a 64 px.
- **Espelho**: não. A tocha troca de mão, a alça e o cabo trocam de ombro: **oeste real** (proposta do L2).
- **Pendente (A2)**: cabeça e barba raspadas ou não.

## 4. Brook França — Paladino de Lliira
- **CANON** (`CHAR-011/S03-S09`): baixo e largo (halfling), cabelo branco volumoso, bigode e barba curta brancos, orelhas pontudas, olhar severo. Armadura completa de placas rebitadas e malha, ombreiras grandes com disco, joelheiras, botas de placas. **Capa vermelha-escura rasgada** caindo pelas costas.
- **Jogo**: Sentença de Lliira (pulso radiante). Guarda de Lliira (bloqueia o golpe e responde com onda radiante). Passiva Guarda (−1 de dano). Acento dourado de Lliira.
- **Nunca aparece**: nada de cânone do mestre; sem o Martelo da Glória (procurado por ele, não dele).
- **Silhueta**: 40 px, o menor junto com Leoric; capa vermelha e cabelo branco são o que lê.
- **Espelho**: sim se não houver arma em uma só mão (A5). Capa e armadura simétricas.

## 5. Maelor Menezes — Devoto de Sendrinah
- **CANON** (`CHAR-035/S01-S09`): humano jovem de cabelo cobre-avermelhado, meio-elfo (orelhas levemente pontudas). Casaco longo branco com painéis azuis e bordas douradas, gola alta dourada, ombreiras brancas, bolsa marrom no quadril, joelheiras de couro, botas marrons.
- **Jogo**: Raio de Luz (projétil de luz que atravessa). Comunhão (cura e marca). Passiva: regeneração.
- **Nunca aparece**: nada de cânone do mestre; Ailalore pode aparecer só como luz, nunca revelar a pedra.
- **Silhueta**: casaco branco e azul e cabelo cobre.
- **Espelho**: condicional. Bolsa de um lado; efeito de luz sai de uma mão (A3 decide a cor).

## 6. Sylas Malafaia — Tiefling, devoto de Mask
- **CANON** (`CHAR-051/S01-S09`): tiefling de chifres curvos grandes, capuz preto, **máscara escura cobrindo o rosto com olhos violeta brilhantes**, orelhas pontudas, robe preto com bordas magenta de arabescos, ombreiras escuras, luvas de placas negras, faixa na cintura, botas pretas.
- **Jogo**: Raio Enfraquecedor (reduz CA e CAM). Passo pelas Sombras (dash que deixa uma cópia sombria). Passiva Visão Verdadeira.
- **Nunca aparece**: nada de cânone do mestre; sem adagas (não estão no Vault).
- **Silhueta**: chifres, capuz e olhos violeta; tons escuros, o acento violeta/magenta precisa de contraste contra o piso.
- **Espelho**: sim (robe e máscara simétricos; o efeito sai das duas mãos).

## 7. Kayron Lioran — Aasimar, Leitor Abissal
- **CANON** (`CHAR-028/pos-S24/r03-turnaround`, 4 vistas, DRAFT aceito para uso delimitado): cabelo branco curto e desgrenhado, **olhos inteiramente vermelhos (uma só cor, sem esclera nem pupila; `DEC-AASIMAR-EYES-001`)**, pele clara (`DEC-KAYRON-WHITE-SKIN`), rosto jovem e magro. Casaco branco de manga larga com **tatuagens negras tribais nos ombros e braços**, faixa vermelha xadrez na cintura, antebraços com padrão escuro, calça preta larga, botas pretas com detalhe vermelho.
- **Jogo**: Descarga Estelar (atinge tudo em volta). Sobrecarga Mística (acelera as armas). Passiva Poder Místico.
- **Nunca aparece**: nada de cânone do mestre.
- **Silhueta**: roupão branco largo contra calça preta; faixa vermelha.
- **Espelho**: sim (tatuagens diferem entre os braços, mas pouco).
- **Diverge (D1, A1)**: o jogo mostra armadura escura e capa roxa; CANON pós-S24 é o roupão branco.

## 8. Leoric — Gnomo, Modo de Constelação
- **CANON** (`CHAR-033/S10-S12`): gnomo de um metro, orelhas pontudas, barba grisalha longa e cheia, bigode, sobrancelhas grossas, **cartola preta com faixa de cobre**, sobretudo de couro marrom com ombreiras e botões de latão, colete escuro, cinto com bolsas, calça marrom escura e botas de fivela.
- **Jogo**: Sopro de Estrela (Concha de Feng-tu, onda que desacelera). Constelação (projéteis em todas as direções). Passiva: alcance e área.
- **Nunca aparece**: nada de cânone do mestre.
- **Silhueta**: 40 px; cartola e barba cinza são o que lê.
- **Espelho**: sim se a concha ficar na cintura ou em uma mão sem peso (A4).
- **Diverge (D4)**: nem o cajado com gema azul da tira atual nem a concha do jogo aparecem no dossiê de Leoric no Vault.

## 9. Zynara Vellen — Alta Conselheira de Rodhe's Bridge
- **CANON** (`CHAR-066/S01-S03-conselheira`): elfa alta, cabelo prateado ondulado até a cintura, orelhas pontudas longas, tiara dourada pequena, olhar frio. Capa e vestido longos pretos com **bordados de folhas douradas** nas bordas e no peito, cinto fino, botas de salto pretas.
- **Jogo**: Ampulheta do Silêncio Eterno (todos ao redor param); no campo é ela quem a empunha. Suspensão Temporal. Passiva: mais uma opção no level-up.
- **Nunca aparece**: nada de cânone do mestre.
- **Silhueta**: capa longa preta com contorno dourado; cabelo prata.
- **Espelho**: condicional. Ampulheta numa mão (L2: oeste real opcional).
- **Observado**: as tiras `se` e `s` atuais quase não mudam entre quadros (auditoria L1).

## 10. Bromnor Martelo da Luz — Anão, Alto Conselheiro de Fateridge
- **CANON** (`CHAR-010/historico-em-vida`): anão largo, **barba branca longa e trançada até o peito**, cabelo branco longo preso, sobrancelhas grossas. Armadura dourada ornamentada com padrões rúnicos, ombreiras enormes, **tabardo azul-royal com bordas douradas**, joelheiras e botas de metal dourado.
- **Jogo**: Martelo da Luz (luz que empurra; vira Glória quando herdado). Concórdia (guarda e repele). Passiva: −2 de dano e +2 de CA.
- **Nunca aparece**: a morte de Bromnor, o espírito no martelo e a trama que o cerca (cânone do mestre). A referência é "em vida".
- **Silhueta**: 48 px; barba branca e tabardo azul.
- **Espelho**: sim, com um só martelo na mão e brilho do lado de fora.
- **Diverge (D7)**: dois martelos nas costas na tira atual.

## 11. Arlindo Orlando — Humano, líder dos Grimholders
- **CANON** (`CHAR-005/S03-S09-andarilho`): homem de meia-idade, rosto marcado, cabelo grisalho curto, barba curta. **Chapéu de feltro marrom**, **lenço vermelho-escuro**, sobretudo de lã marrom longo, colete, luvas escuras, calça e botas marrons.
- **Jogo**: Memória Alterada (projétil de memória, o alvo fica lento). Passiva: Ecos brilham de mais longe.
- **Nunca aparece**: nada de cânone do mestre.
- **Silhueta**: chapéu, lenço vermelho e sobretudo longo; figura esguia.
- **Espelho**: sim (nada na mão; o feitiço sai de qualquer mão).

## 12. Nyrelia — Sacerdotisa de Mask, Grimholders
- **CANON** (`ACHADOS-TRES-20261018-r1` e `CANON-SEIS-20261018-r1`; **só há frente**): figura alta encapuzada, **máscara metálica escura lisa que cobre todo o rosto**, capuz e manto verde-escuro com bordas rasgadas em franjas, lenço verde com borlas douradas, vestido preto com faixa bordada dourada, luvas escuras, botas com fivelas douradas. Aura amarela.
- **Jogo**: Dominar Pessoa (o alvo perde os ataques). Dominação (converte um inimigo comum). Passiva Aura Amarela (+10% de moedas e XP).
- **Nunca aparece**: o rosto e a espécie (o Vault diz que "nunca foi dita"); nada de cânone do mestre. Sem olhos visíveis.
- **Silhueta**: manto verde em franjas e máscara; aura amarela como acento.
- **Espelho**: sim (simétrica).
- **Bloqueio**: faltam costas e perfil CANON. Sem eles não dá para fixar a identidade das direções n, ne e e.

## Decisões abertas para o dono

| ID | Pergunta | Recomendação |
|---|---|---|
| A1 | Kayron: figurino pós-S24 do Vault (roupão branco, tatuagens, faixa vermelha) ou o traje escuro e a capa roxa atuais? | Seguir o CANON do Vault; o traje atual vem do Nottcard e não tem referência no Vault. |
| A2 | Erik: cabeça e barba raspadas (texto do Vault e bio do jogo) ou cabelo e barba (imagens CANON)? | Raspado, como o texto; usar as imagens só para roupa e rosto. |
| A3 | Maelor: cor da luz (chama azul atual ou luz dourada/branca)? | Luz dourada-branca, por ser clérigo da luz; o azul fica só na roupa. |
| A4 | Leoric: objeto de mão (concha de Feng-tu do jogo, cajado atual ou mão livre com o brilho estelar)? | Concha, como a arma do jogo, pequena e na cintura ou numa mão, sem peso na silhueta. |
| A5 | Brook: arma visível (maça atual, símbolo sagrado de Lliira ou nenhuma)? | Símbolo sagrado ou mão livre com o pulso dourado; evita o martelo de Bromnor. |
| A6 | Nyrelia: gerar vistas CANON de costas e perfil antes? | Sim, antes do R3. |
| A7 | Existe Vault mais novo que `50008c9`? | Dizer; não baixo nada sem aprovação. |
