# Contrato de animação dos heróis — r3 (2026-10-22)

Status: DRAFT, **preparado por autorização do dono em 2026-10-22** ("Autorizo preparar o contrato r3, o verificador v3, o guia de pose do se e o prompt do E1, sem gerar nada. Três desenhos A, P1, P2 tocando A, P1, A, P2 é aceitável; espada: mantenha para baixo na caminhada por enquanto; teto de 4 gerações"). **Só a caminhada muda.** Idle, ataque, habilidade e morte seguem o `animation-contract-r2.md`. r1 e r2 ficam como histórico (r1 gerou as v01/v02 do formato antigo; r2 gerou as três tentativas 2×2 do walk SE do Durvall).

**Este contrato é uma hipótese a validar no E1** (seção 9). Nada nele vira regra para os 12 heróis antes do E1 passar e você aceitar. Diagnóstico de origem: `.atena/generated/hero-r2-durvall-walk-se-r2-diagnosis-20261022/DIAGNOSTICO-E-PROPOSTA.md`.

## 1. O que mudou em relação ao r2 (só a caminhada)

| # | Mudança | Evidência |
|---|---|---|
| 1 | **Três desenhos: A, P1, P2.** O jogo toca **A, P1, A, P2**; o contato B não é gerado | Os pés dos contatos A e B ficam nas mesmas posições (±0,22 da altura) nas três tentativas r2: em silhueta B = A, e o modelo nunca produziu B diferente. O que faz o olho ler alternância é a passagem |
| 2 | **Pose descrita em coordenadas de tela e por profundidade, com guia de pose anexado** (boneco colorido). Fim de "perna direita/esquerda do personagem" | A linguagem de perna do r1 e do r2 foi ambígua em três-quartos nas cinco tentativas |
| 3 | **Geometria da passagem definida em números** (pé levantado ao lado do tornozelo de apoio, na altura da canela, joelho à frente) | Nas tentativas r2 o pé levantado ficou atrás (P1) ou longe à frente (P2) e voltou ao mesmo lugar: marcha no lugar |
| 4 | **Montagem alinha pelo tronco**, não pela caixa da figura nem pelo centro dos pés | Alinhando pela caixa o corpo treme 4 a 5 px (a 64 px de altura) entre quadros da v01 e da v02 r2; pelo tronco, 0 |
| 5 | **Verificador v3** (`r2_check_v3.gd`): figuras por espaço, pés apoiados, passagem decidida à vista | v2 fundia figuras; 5b e 5c por silhueta não separavam as tentativas |
| 6 | **Espada para baixo na caminhada, por enquanto** (decisão do dono); risco registrado: a lâmina cruza as pernas e esconde a do lado da câmera | Recortes de pernas das tentativas r2 |
| 7 | **Teto de 4 gerações** para o experimento do Durvall walk SE (E1 + E2), além da regra de 3 tentativas por imagem do r2 | Decisão do dono |

## 2. O que o jogo toca (caminhada)

| Animação | Quadros no jogo | Desenhos únicos | Ordem |
|---|---|---|---|
| move por direção | 4 | 3 (A, P1, P2) | A, P1, A, P2 |

`s` e `n` de herói simétrico geram só A e P1; P2 é o `flip_x` de P1 (vista frontal ou traseira). fps, idle, ataque, ativa e morte: como no r2.

## 3. Direções

Gerar `e`, `se`, `s`, `ne`, `n`; oeste por espelho, exceto Durvall e Erik (oeste real, mais `w`, `sw`, `nw`). **Guias por direção:** só o `se` existe (`pose_guide_walk_se_A_P1_P2_r3.png`). Os de `e`, `ne`, `s`, `n` e os de oeste real são produzidos por script **depois** de o E1 passar e você aceitar.

## 4. Formato da imagem de caminhada

- **Fila de 3 figuras em 1536×1024** (A à esquerda, P1 no meio, P2 à direita), fundo magenta liso (Sylas em cinza #B4B4B4), mesma escala e mesma linha do chão, nenhuma figura encostando na outra, na borda ou no limite do seu terço (512 px por figura, margem de 60 px). `s` e `n` de herói simétrico: fila de 2 (A, P1) em 1024×1024.
- **P1 é a figura de calibração.**
- **Anexos (máximo 5, nesta ordem):** vista CANON de frente, de perfil esquerdo e de costas; o **idle aprovado** do herói; o **guia de pose** da direção. A vista direita sai para caber o guia (o idle aprovado já traz o lado direito). Nunca anexar caminhada reprovada.
- **Nome:** `assets_incoming/hero-r2/<herói>/<herói>_walk_<direção>_r3_<experimento>_v01.png` (ex.: `durvall_walk_se_r3_E1_v01.png`); não sobrescreve nenhum arquivo anterior.
- Demais regras do formato (fundo, proibições, câmera e luz): as do r2.

## 5. Poses da caminhada (direções `e`, `se`, `ne` e oeste real; viradas para a direita da tela, quando as de oeste são espelhos)

Linguagem: coordenadas da tela e profundidade. **Perna do lado da câmera** = a mais próxima do observador (vermelha no guia, desenhada por cima); **perna do lado oposto** = a mais afastada (azul no guia, por baixo). O guia dá **só a pose**; as cores e o boneco não aparecem no resultado; o personagem é o do idle aprovado.

- **A, contato:** passada larga; a perna do lado da câmera à frente com o calcanhar tocando o chão, a perna do lado oposto atrás com só a ponta do pé no chão. Pés afastados cerca de 0,45 da altura da figura (mínimo 0,30). Braço do lado oposto à perna da frente à frente; o braço da espada firme.
- **P1, passagem (calibração):** a perna do lado da câmera é o apoio, reta, pé plano no chão. A perna do lado oposto está levantada: **o pé fica ao lado do tornozelo de apoio, na altura da canela, o joelho à frente**; os dois pés quase juntos; corpo no ponto mais alto. **Não** é chute para trás nem passo alto à frente.
- **P2, passagem:** a mesma geometria com as pernas trocadas: a perna do lado oposto é o apoio; a perna do lado da câmera está levantada, **por cima da perna de apoio** (totalmente visível), pé ao lado do tornozelo de apoio na altura da canela, joelho à frente.
- P1 e P2 diferem só por qual perna está levantada (a de trás, quase escondida, em P1; a da frente, visível, em P2).

## 6. Receita de montagem (a Atena; nada roda sem aprovação)

Como no r2, com estas mudanças:
- **Tira de 4 quadros na ordem A, P1, A, P2.**
- **Âncora horizontal: centróide do tronco** (faixa de 15% a 50% da altura da figura), não a caixa nem o centro dos pés. Âncora vertical: o ponto mais baixo da figura na linha dos pés (448 em 512×512).
- Escala pela figura de calibração (P1), como no r2.
- A prévia de avaliação usa `make_walk_preview.ps1` (painéis: caixa, tronco, tamanho de jogo a 64 px ampliado 4×), em GIF.

## 7. Critérios de aceite (verificador v3)

Estados PASSA, FALHA, INCERTO; **REPROVA** com qualquer FALHA; **PASSA_COM_ITENS_A_VISTA** com INCERTO; código de saída 0, 1 e 3. **O veredito de uma caminhada nunca é PASSA:** a passagem é decisão à vista (5c). Limites marcados PROVISÓRIO são calibrados na primeira imagem aceita; não foram ajustados para aprovar imagem.

| # | Critério | Como é medido |
|---|---|---|
| 1 | Figuras | uma em cada espaço (terço ou quadrante), inteiras, sem tocar a borda da imagem nem o limite do espaço |
| 2 | Fundo (halo) | resíduo magenta depois do recorte de produção, a partir de 3 px, menos a linha de base: PASSA ≤ 5 pontos, FALHA > 10, entre os dois INCERTO (PROVISÓRIO) |
| 3 | Escala | altura a ±6% da calibração |
| 4 | Linha dos pés | variação ≤ 3% da altura |
| 5a | **A com passada larga** | A tem exatamente 2 pés no chão, afastados ≥ 0,30 da altura (PROVISÓRIO) |
| 5d | **Passagens com um pé no chão** | P1 e P2 têm exatamente 1 pé no chão (faixa dos 6% mais baixos). Necessário, não suficiente: a v01 e a v02 r2 passam e foram reprovadas |
| 5c | **Passagem a olho** | INCERTO sempre: pé levantado ao lado da perna de apoio, na altura da canela, joelho à frente. Decide-se pelo recorte das pernas (`--crops`) e pela prévia |
| 6 | Pontos soltos | escala de produção (400 px): 0 PASSA; 1 a 6 INCERTO (listados com posição; fios de cabelo e o pomo da espada são tolerados); > 6 FALHA (PROVISÓRIO) |
| 7 a 9 | Identidade, estilo, assimetrias | você |

Informativo: **tremor horizontal** (centro da caixa − tronco, em alturas): mostra quanto a montagem precisa alinhar pelo tronco.

## 8. Quantidade de imagens e desenhos

Imagens por herói: não muda (9; 12 com oeste real). Desenhos únicos da caminhada: herói de espelho 13 (A, P1, P2 em `e`, `se`, `ne`; A e P1 em `s` e `n`); Durvall e Erik 24 (A, P1, P2 nas 8 direções).

## 9. Experimentos do Durvall walk SE (teto de 4 gerações no total)

- **E1:** 1 geração: fila de 3 figuras (A, P1, P2) com o guia. Prompt e roteiro em `prompts-r3/` e `r2-roteiro-r3.md`.
- **E2** (só se o E1 não seguir o guia): até 3 gerações, uma pose por imagem, editando o idle aprovado só nas pernas com o mesmo guia (um recorte do guia por pose). O prompt do E2 só é preparado se o E1 falhar e com a sua autorização.
- **Fim:** E1 aceito por você → o contrato r3 vira regra, preparo os guias das demais direções e o pacote r3 do Durvall; E1 e E2 sem sucesso → volto a você com a medição e a alternativa F (tiras piloto do Durvall como caminhada provisória).
- O idle v01 aprovado, as tentativas anteriores e os PNGs não são alterados.

## 10. O que este contrato não resolve

- Se o ChatGPT segue um guia de pose: é o que o E1 testa.
- Direções `e`, `ne`, `s`, `n` e oeste real: dependem do E1.
- Espada na caminhada: decisão do dono pendente para depois do E1 (hoje, para baixo).
- Mudanças em `hero_view.gd` e `asset_prep.gd` (R4): continuam exigindo aprovação e testes.
