# Contrato de animação dos heróis — R1 (2026-10-21, r1)

Status: DRAFT. Plano `PLAN-NOTTGARD-HERO-ART-RESET-20261021`, lote R1 (texto; nada gerado). O contrato só vira regra depois do R2 (validação com Durvall, Korrak e Erik): os itens marcados **[validar no R2]** são hipóteses, não fatos.

Base: lições do plano (`plan-r1.md`, seção 2), fichas visuais (`.atena/vault/drafts/HERO-VISUAL-SHEETS-20261021-r1.md`), auditoria do walk-fix (L1/L1b) e `ui/hero_view.gd`, `tools/asset_prep.gd`.

## 1. Decisões aplicadas (A1 a A6)

| ID | Decisão | Efeito no pacote |
|---|---|---|
| A1 | Kayron pelo CANON pós-S24 | Roupão branco com tatuagens negras, faixa vermelha, olhos totalmente vermelhos. Sem armadura nem capa. |
| A2 | Erik raspado | Cabeça e rosto sem barba, sem restolho. As imagens CANON só valem para roupa e feições. |
| A3 | Luz de Maelor dourada-branca | Nenhum azul de magia; o azul fica só no casaco. |
| A4 | Leoric com a concha | Concha pequena na mão ou presa ao cinto; sem cajado. |
| A5 | Brook sem arma (mão livre) | Sem maça e sem martelo de Bromnor. O acento dourado vem do jogo, não é desenhado. |
| A6 | Nyrelia: vistas CANON antes do R3 | Pacote dela fica bloqueado; as vistas de costas e perfil têm prompt próprio (seção 9). |

Durante o R1 adotei também: 5 fps = autoria; 4 poses-chave por direção; R2 com 3 heróis.

## 2. O que o jogo toca (alvo de integração, R4)

| Animação | Quadros no jogo | fps | Desenhos únicos |
|---|---|---|---|
| idle | 4 | 5 | 3 (repouso, inspira, expira); toca R, I, E, I |
| move por direção | 4 | por herói (tabela abaixo) | 3 (contato A, passagem P, contato B); toca A, P, B, P |
| attack | 4 | 12 | 3 (preparo, golpe, seguimento) + repouso; toca 1, 2, 3, repouso |
| active | 4 | 12 | 3 + repouso |
| death | 4 | 9 | 3 (impacto, queda, caído); o último quadro se repete |

Hoje: idle 4, move 6, attack 4, active 6, death 6. O R4 ajusta `hero_view.gd` (`HERO_WALK_FRAME_COUNTS` e as contagens das demais).

**fps da caminhada.** Fórmula do laboratório (`lab_walk_fps`): fps = velocidade × quadros ÷ (2 × 0,55 × altura em tela), com `SPEED_PX = 190` e o limite de 8 a 30.

| Herói | Altura (px) | fps com 4 quadros |
|---|---|---|
| Korrak | 76 | 8 (velocidade −10%) |
| Kayron | 66 | 10 |
| Sylas, Maelor, Erik | 64 | 11 |
| Nyrelia, Arlindo | 62 | 11 |
| Durvall, Zynara | 60 | 12 |
| Bromnor | 48 | 14 |
| Leoric, Brook | 40 | 17 |

Leoric e Brook ficam a 17 fps por terem pernas curtas e velocidade igual à dos outros: podem parecer nervosos. **[validar no R2/R3]**; opções se parecer: reduzir a velocidade visual deles ou aceitar o ritmo.

## 3. Quantas direções

Gerar cinco: `e`, `se`, `s`, `ne`, `n`. Direções de oeste: espelho do leste, exceto nos heróis marcados **oeste real**, que geram também `w`, `sw`, `nw`.

| Herói | Oeste | `s` e `n` |
|---|---|---|
| Durvall | real (pano vermelho de um lado + espada) | A, P, B |
| Erik | real (tocha, alça e cabo trocam de lado) | A, P, B |
| Zynara | espelho; oeste real opcional (decidir no R3) | A, P, B (ampulheta numa mão) |
| Demais 9 | espelho | A, P; o B é o A espelhado |

## 4. Formato de cada imagem gerada (um arquivo = uma direção ou animação)

Uma imagem por direção ou animação, **nunca uma tira com grade pronta**. Cada imagem contém uma pequena fila de figuras do mesmo personagem; a Atena separa por componentes (`asset_prep` já faz `split: components`).

- **Tela:** 1536×1024, paisagem. **Fundo:** cor lisa, sem gradiente, sem chão, sem sombra, sem vinheta. Padrão **magenta puro #FF00FF**; **Sylas usa cinza #B4B4B4** (o magenta dele é parte da roupa). `asset_prep` suporta `magenta`, `gray` e `black`; verde não, por isso não uso. **[validar no R2]** o magenta contra pele cinza (Durvall, Korrak).
- **Disposição:**
  - `walk` e `idle`: uma fila horizontal de 3 figuras (A, P, B ou repouso, inspira, expira), espaçamento de pelo menos 140 px, nenhuma encosta na outra nem na borda.
  - `attack`, `active` e `death`: grade 2×2. Figura 1 (canto superior esquerdo) é a **de calibração**, em pé e neutra; as três seguintes são as poses da animação, em ordem de leitura.
- **Tamanho da figura:** o personagem ocupa cerca de 75% da altura do espaço dele, independentemente da altura real. A escala relativa entre heróis vem do jogo (`HERO_DISPLAY_HEIGHT`).
- **Linha do chão:** todos os pés na mesma linha horizontal invisível dentro da imagem.
- **Câmera e luz:** três-quartos isométrica vista de cima (cerca de 30°), luz superior esquerda, igual às referências atuais.
- **Proibido:** texto, números, rótulos, setas, linhas de grade, molduras, marca d'água, sombra no chão, desfoque de movimento, linhas de velocidade, partículas, fumaça, fagulhas, **efeitos mágicos desenhados** (raios, ondas, brilhos soltos). O jogo desenha os efeitos. Exceção: brasa e chama que fazem parte do objeto (a tocha do Erik, as veias de lava do machado).
- **Referências a anexar** (nesta ordem): vistas CANON do herói do Vault (frente, esquerda, costas, direita), mais duas imagens de estilo do jogo (`assets/enemies/zuggtmoy.png`, `assets/enemies/malcanthet.png`). Um herói por conversa; na mesma conversa, a primeira imagem aprovada (o idle) volta como referência de escala nas seguintes.
- **Nomeação:** `assets_incoming/hero-r2/<herói>/<herói>_<animação>_<direção>_v01.png` (por exemplo `durvall_walk_se_v01.png`); versões `_v02`, `_v03`.

## 5. Poses

Direções na tela, não no chão: `e` = perfil voltado para a direita da tela; `se` = três quartos de frente, para baixo e direita; `s` = de frente; `ne` = três quartos de costas, para cima e direita; `n` = de costas. Oeste real: `w`, `sw`, `nw` são o espelho visual dessas.

**Caminhada (3 desenhos).** O personagem caminha em ritmo normal, cabeça na mesma altura.
- **A, contato:** perna direita à frente com o calcanhar tocando o chão, perna esquerda atrás com só a ponta no chão; braço esquerdo à frente, direito atrás; corpo no ponto mais baixo, tronco reto.
- **P, passagem:** em pé na perna esquerda quase reta; a direita passa dobrada com o pé erguido junto à perna de apoio; quadris e cabeça no ponto mais alto; braços junto ao corpo. **P é a figura de calibração da imagem.**
- **B, contato oposto:** o inverso de A (perna esquerda à frente, braço direito à frente).
- Roupas, capa e cabelo acompanham o movimento, sem exagero. O objeto de mão segue a regra do herói (ficha), sem balançar.
- **Critério:** A e B devem diferir de P por pelo menos 8% dos pixels (senão a passada desliza, como em Zynara `se`/`s` e Sylas `s` hoje).

**Idle (3 desenhos, voltado para `se`).** Pés no mesmo lugar nos três. Repouso; inspira (ombros e peito sobem 2 a 3 px, capa ou cabelo mudam pouco); expira. Diferenças pequenas e cuidadosas.

**Attack, active e death (figura de calibração + 3 desenhos, voltados para `se`).** Gestos por herói na ficha de prompts. Morte: impacto (recuo), queda (de joelhos ou desabando), caído no chão. Sem sangue.

## 6. Receita de montagem (a Atena; nada disso roda sem aprovação)

1. Remover o fundo (`magenta` ou `gray`), com a chave passada por herói.
2. Separar as figuras por componentes e ordenar (linha ou ordem de leitura); conferir que o número de figuras bate com o esperado.
3. **Escala:** por imagem, escalar de modo que a figura de calibração (P, repouso ou calibração) tenha a altura do idle do herói. O idle define `HERO_IDLE_ART_HEIGHT`.
4. **Âncora:** o ponto mais baixo da figura na linha dos pés da célula (448 em célula 512×512); centralizar na horizontal pelo centro dos pés.
5. **Célula:** 512×512 para todos os heróis (já usada por Durvall, Arlindo e Erik); a figura com até ~400 px de altura para caber armas largas.
6. **Tira:** quadros na ordem do jogo; a passagem P repete (A, P, B, P); o último quadro de death repete.
7. **Limpeza:** remover componentes soltos de até 120 px longe do corpo (pontos), sem apagar o que é parte do objeto.
8. **Espelho:** `w`, `sw`, `nw` e, nos heróis de espelho, a pose B das direções `s` e `n` saem de `flip_x`.
9. **Atualizar** `HERO_IDLE_ART_HEIGHT`, `HERO_FEET_Y` e as contagens, no R4.

`asset_prep.gd` tem hoje o modo `sprite` (troca de poses para criaturas). **Falta um modo de herói** (poses nomeadas por direção, calibração, tira de 4 quadros). Isso é código novo no R4, com teste, e só com sua aprovação.

## 7. Critérios de aceite (medidos pela Atena; identidade e estilo, por você)

| # | Critério | Limite |
|---|---|---|
| 1 | Figuras na imagem | número esperado, todas inteiras, nenhuma encostando na borda |
| 2 | Fundo | sem resíduo da cor da chave depois da remoção (halo) |
| 3 | Escala entre figuras da mesma imagem | altura a ±6% da figura de calibração |
| 4 | Linha dos pés | variação de até 3% da altura da figura |
| 5 | Caminhada | A e B diferem de P por pelo menos 8% dos pixels |
| 6 | Pontos soltos | zero fora do corpo |
| 7 | Identidade | comparação visual com o CANON, por você |
| 8 | Estilo | igual ao das referências anexadas, por você |
| 9 | Simetria declarada | o que a ficha diz ser assimétrico é assimétrico (mão do objeto, ombreira, cabo da espada) |

Limite de tentativas: no máximo 3 gerações por imagem. Se não passar, volta para você com a medição e a imagem; não refaço em loop.

## 8. Quantidade de imagens (estimativa)

- Herói de espelho: idle 1 + walk 5 (`e`, `se`, `ne`, `s`, `n`) + attack 1 + active 1 + death 1 = **9 imagens**.
- Herói de oeste real: + 3 (`w`, `sw`, `nw`) = **12 imagens**.
- R2 (Durvall 12 + Korrak 9 + Erik 12) = **33 imagens**. Todos os 12 heróis: 10 de espelho × 9 + 2 de oeste real × 12 = **114**, sem contar as repetições por reprovação (e mais 3 se a Zynara ganhar oeste real).

Cada imagem tem 3 a 4 figuras. Se o R2 mostrar que o ChatGPT não segura 3 figuras iguais na mesma imagem, o fallback é **uma pose por imagem** (cerca de 4× mais imagens); o contrato aceita os dois, e a decisão sai do R2.

## 9. Nyrelia: vistas CANON (pré-requisito do R3)

Só existe a frente. Prompts de apoio (para gerar `back`, `left`, `right` a partir da frente CANON; são referências, não sprites). O destino é `assets_incoming/hero-r2/nyrelia/ref/`. A promoção a CANON é decisão sua e acontece no Vault, fora deste repositório; aqui elas servem como referência DRAFT. Texto em `prompts/nyrelia-vistas.md`.

## 10. O que este contrato não resolve

- A qualidade real do ChatGPT para filas de 3 figuras consistentes: só o R2 mostra.
- O ritmo de Leoric e Brook (17 fps).
- Oeste real da Zynara.
- Mudanças em `hero_view.gd` e em `asset_prep.gd`: R4, com aprovação.
