# Contrato de animação dos heróis — r2 (2026-10-22)

Status: DRAFT, aprovado pelo dono em 2026-10-22 ("Aprovo as correções"). Substitui `animation-contract-r1.md` (preservado como histórico: foi o contrato das v01 e v02 do Durvall). Plano `PLAN-NOTTGARD-HERO-ART-RESET-20261021`. Diagnóstico que originou esta revisão: `.atena/generated/hero-r2-durvall-gate1-diagnosis-20261022/DIAGNOSTICO.md`.

## O que mudou em relação ao r1

| # | Mudança | Motivo |
|---|---|---|
| 1 | **Caminhada com 4 desenhos** (A, P1, B, P2) em todas as direções que não são simétricas; toca A, P1, B, P2 | O r1 reusava uma só passagem (A, P, B, P): em perfil e três-quartos a segunda passagem é da outra perna, e o reuso produz o vai-e-volta que parece mancar (erro do contrato) |
| 2 | **Linguagem de perna do lado da câmera e do lado oposto** nas direções diagonais e de perfil; "perna do lado esquerdo/direito da tela" nas direções `s` e `n` | "Direita" e "esquerda" do personagem são ambíguas em três-quartos; a geração copiou A em B |
| 3 | **Referências de caminhada: vistas CANON + idle aprovado; nunca outra caminhada reprovada** | A v02 usou a walk v01 como referência e repetiu a cópia |
| 4 | **Máximo de 5 anexos por pedido** (limite real da ferramenta); regra de prioridade na seção 4 | O r1 pedia 6; a geração do Durvall só aceitou 5 |
| 5 | **Critérios de aceite medidos pelo verificador v2** (`r2_check_v2.gd`): halo depois do recorte de produção, pontos soltos na escala de produção, três estados (PASSA, FALHA, INCERTO) | O halo do v1 era artefato (contava a faixa que o `asset_prep` já corrige); os pontos eram fios de cabelo na escala errada |
| 6 | **Contador de tentativas reinicia para o formato novo da caminhada** (3 tentativas) | O formato mudou (4 figuras, outra linguagem, outra referência); o idle v01 do Durvall, aprovado, não é refeito |

O aceite visual do dono sobre o idle v01 e a walk v01 do Durvall continua registrado e não é alterado por este contrato.

## 1. Decisões aplicadas (inalteradas do r1)

A1 Kayron pelo CANON pós-S24; A2 Erik raspado; A3 luz de Maelor dourada-branca, não desenhada; A4 Leoric com a concha; A5 Brook sem arma; A6 vistas CANON da Nyrelia antes do R3. 5 fps = autoria; R2 com Durvall, Korrak e Erik.

## 2. O que o jogo toca (alvo de integração, R4)

| Animação | Quadros no jogo | fps | Desenhos únicos |
|---|---|---|---|
| idle | 4 | 5 | 3 (repouso, inspira, expira); toca R, I, E, I |
| move por direção | 4 | por herói (tabela abaixo) | **4 (A, P1, B, P2)**; **toca A, P1, B, P2** |
| attack | 4 | 12 | 3 + repouso |
| active | 4 | 12 | 3 + repouso |
| death | 4 | 9 | 3 (impacto, queda, caído); o último quadro repete |

**Exceção de economia (só `s` e `n` de herói de espelho):** a vista é frontal ou traseira e o herói é simétrico, então B e P2 são o `flip_x` de A e P1. Esses casos geram só A e P1 (2 desenhos).

fps da caminhada (fórmula `lab_walk_fps`, `SPEED_PX = 190`, 4 quadros): Korrak 8, Kayron 10, Sylas, Maelor, Erik 11, Nyrelia, Arlindo 11, Durvall, Zynara 12, Bromnor 14, Leoric e Brook 17. Leoric e Brook podem parecer nervosos (pernas curtas); validar no R2 e R3.

## 3. Direções e oeste

Gerar cinco: `e`, `se`, `s`, `ne`, `n`. Oeste: espelho de leste, exceto **oeste real** (também `w`, `sw`, `nw`) para Durvall e Erik. Zynara: espelho, oeste real opcional (R3).

| Herói | `s` e `n` |
|---|---|
| Durvall, Erik, Zynara | 4 desenhos (A, P1, B, P2); não espelha |
| Demais 9 | 2 desenhos (A, P1); B e P2 por `flip_x` |

## 4. Formato de cada imagem gerada

Uma imagem por direção ou animação; nunca tira com grade pronta.

- **Tela:** 1536×1024 (fila de 3 ou grade 2×2) ou 1024×1024 (fila de 2). **Fundo:** cor lisa, sem gradiente, chão, sombra ou vinheta; magenta puro #FF00FF, exceto **Sylas em cinza #B4B4B4**.
- **Disposição:**
  - `idle`: fila de 3 (repouso, inspira, expira); a 1ª é a calibração.
  - **`walk` com 4 desenhos: grade 2×2 em ordem de leitura: A (superior esquerdo), P1 (superior direito), B (inferior esquerdo), P2 (inferior direito). P1 é a calibração.**
  - `walk` com 2 desenhos (s/n de herói de espelho): fila de 2, A e P1; P1 é a calibração.
  - `attack`, `active`, `death`: grade 2×2, calibração no canto superior esquerdo + 3 poses.
- **Figura:** ~75% da altura do espaço, mesma escala e mesma linha do chão invisível em todas; sem encostar umas nas outras nem na borda.
- **Câmera e luz:** três-quartos isométrica de cima (~30°), luz superior esquerda.
- **Proibido:** texto, rótulos, setas, grade, moldura, sombra no chão, desfoque, linhas de velocidade, partículas, efeitos mágicos desenhados (o jogo desenha). Exceção: chama e brasa que são parte do objeto.
- **Anexos (máximo 5, em ordem de prioridade):**
  1. idle: as 4 vistas CANON do herói + `zuggtmoy.png` (referência de estilo do jogo).
  2. **todas as outras imagens: as 4 vistas CANON + o idle aprovado do herói.** O idle carrega o estilo e a escala; não anexar caminhada reprovada nem imagem de outra versão não aprovada.
  - Um herói por conversa.
- **Nomeação:** `assets_incoming/hero-r2/<herói>/<herói>_<animação>_<direção>_v01.png` (versões `_v02`, `_v03`).

## 5. Poses

Direções na tela: `e` perfil para a direita; `se` três-quartos de frente para baixo e direita; `s` de frente; `ne` três-quartos de costas para cima e direita; `n` de costas; `w`, `sw`, `nw` os espelhos visuais. **Câmera: a perna do lado da câmera (perna próxima) é a mais próxima do observador; a perna do lado oposto (perna distante) é a mais afastada.** Em `s` e `n` não há perna próxima: usar o lado da tela.

### Caminhada (direções `e`, `se`, `ne`, `w`, `sw`, `nw`)

- **A, contato com a perna próxima à frente:** a perna próxima é a de frente, estendida, só o calcanhar tocando o chão; a perna distante é a de trás, com só a ponta do pé no chão. O braço do lado oposto à perna da frente balança à frente, o outro vai atrás; o braço que carrega o objeto fica firme.
- **P1, passagem, a perna distante passa (calibração):** a perna próxima é o apoio, quase reta, pé plano; a perna distante passa à frente com o joelho dobrado e o pé levantado, em parte escondida atrás da perna próxima; quadris e cabeça no ponto mais alto; braços junto ao corpo.
- **B, contato com a perna distante à frente:** o **oposto** de A. A perna **distante** é a de frente, estendida; a perna **próxima** fica **atrás do corpo**, só a ponta do pé no chão, com a bota **visivelmente atrás**. **Não pode ser cópia de A:** a bota próxima está à frente em A e atrás em B. O braço do lado oposto à perna da frente balança à frente (o do objeto fica firme).
- **P2, passagem, a perna próxima passa:** a perna distante é o apoio, quase reta; a perna próxima passa à frente com o joelho dobrado e o pé **claramente levantado, à frente e totalmente visível**; quadris e cabeça no ponto mais alto.

### Caminhada (direções `s` e `n`, herói de espelho: só A e P1; herói assimétrico: A, P1, B, P2)

Usar o lado da tela. **A:** a perna do lado ESQUERDO da tela é a que lidera (em `s`, o pé desce em direção à câmera; em `n`, afasta-se dela, parecendo mais alto no chão); a do lado direito fica atrás. **P1:** a perna do lado esquerdo é o apoio; a do lado direito passa levantada. **B:** a perna do lado DIREITO da tela lidera. **P2:** a perna do lado direito é o apoio; a do lado esquerdo passa levantada.

### Idle, attack, active, death

Inalterados do r1: idle com 3 desenhos quase idênticos (respiração); ação e morte com figura de calibração + 3 desenhos; sem sangue; gestos por herói no pacote.

## 6. Receita de montagem (a Atena; nada roda sem aprovação)

1. Remover o fundo (`magenta` ou `gray`).
2. Separar as figuras por componentes e ordenar (fila ou ordem de leitura); conferir a contagem.
3. **Escala:** por imagem, a figura de calibração (P1, repouso ou calibração) tem a altura do idle do herói; o idle define `HERO_IDLE_ART_HEIGHT`.
4. **Âncora:** o ponto mais baixo da figura na linha dos pés da célula (448 em 512×512); centralizar pelo centro dos pés.
5. **Célula:** 512×512 para todos; figura com até ~400 px.
6. **Tira da caminhada: 4 quadros na ordem A, P1, B, P2.** Idle R, I, E, I. Death repete o último.
7. **Limpeza:** componentes soltos na escala de produção (3 a 60 px²).
8. **Espelho:** `w`, `sw`, `nw` de herói de espelho; B e P2 de `s` e `n` de herói de espelho.
9. Atualizar `HERO_IDLE_ART_HEIGHT`, `HERO_FEET_Y` e contagens no R4.

Falta um modo de herói no `tools/asset_prep.gd` (R4, com aprovação e teste).

## 7. Critérios de aceite

Medidos por `r2_check_v2.gd`. Estados PASSA, FALHA, INCERTO. **REPROVA** se houver FALHA; **PASSA_COM_ITENS_A_VISTA** se houver INCERTO; código de saída 0, 1 e 3. Limites marcados PROVISÓRIO são calibrados na primeira imagem aceita pelo dono; não são ajustados para aprovar imagem.

| # | Critério | Como é medido |
|---|---|---|
| 1 | Figuras | número esperado, todas inteiras, nenhuma na borda |
| 2 | Fundo (halo) | resíduo magenta depois do recorte de produção, a partir de 3 px de profundidade, menos a linha de base (8 a 10 px): PASSA ≤ 5 pontos, FALHA > 10, entre os dois INCERTO (PROVISÓRIO). Cinza: informativo |
| 3 | Escala | altura a ±6% da calibração (a grade de ação não se aplica) |
| 4 | Linha dos pés | variação de até 3% da altura, por linha de figuras |
| 5a | Contato x passagem | silhueta de A e B contra P1 ≥ 8% |
| 5b | **A diferente de B** | cor das pernas A x B ÷ ruído de "mesma pose" do idle da mesma série: PASSA ≥ 1,6; senão INCERTO. **Nunca reprova sozinho.** Decidir pelo recorte das pernas (`--crops`) |
| 5c | **P1 diferente de P2** | silhueta P1 x P2 ÷ ruído: PASSA ≥ 2,0, FALHA ≤ 1,3, entre os dois INCERTO (PROVISÓRIO) |
| 6 | Pontos soltos | na escala de produção (figura a 400 px): componentes de 3 a 60 px²; zero |
| 7 | Identidade | comparação com o CANON, por você |
| 8 | Estilo | igual ao das referências, por você |
| 9 | Assimetrias | o que a ficha diz ser assimétrico fica do mesmo lado |

**Alternância de pernas (A diferente de B) é decisão à vista.** O verificador entrega o recorte das pernas de A, B, P1 e P2 lado a lado; quem decide é a Atena junto com você olhando as imagens. Um INCERTO no 5b nunca é tratado como aprovação.

Limite de tentativas por imagem: 3. Se não passar, volta com a medição e as imagens; não refaço em loop.

## 8. Quantidade de imagens

Não muda: idle 1 + walk 5 + attack 1 + active 1 + death 1 = 9 por herói (+3 de oeste real: Durvall e Erik = 12). Total 114 sem as repetições por reprovação. **Desenhos únicos por herói de espelho:** caminhada 16 (A, P1, B, P2 em `e`, `se`, `ne`; A e P1 em `s`, `n`) em vez de 13; para Durvall e Erik, 24 (mais 8 em `s`, `n`, `w`, `sw`, `nw`); idle 3, ataque 3, ativa 3, morte 3.

## 9. Nyrelia

Sem mudança: vistas CANON de apoio em `prompts-r2/nyrelia-vistas.md` antes do R3.

## 10. O que este contrato não resolve

- Se o ChatGPT segura 4 figuras consistentes na grade 2×2 e diferencia de fato A e B: só a nova tentativa do Durvall mostra. Plano B se falhar de novo: **uma pose por imagem** (cerca de 4× mais imagens), com B pedido numa imagem à parte anexando A.
- O ritmo de Leoric e Brook (17 fps).
- Mudanças em `hero_view.gd` e `asset_prep.gd`: R4.
