# PLAN-NOTTGARD-HERO-ART-RESET-20261021 · r1

Classificação: PLAN_CHANGE_REQUEST · modo: por lote · conteúdo: DRAFT · estado: R0 e R1 concluídos (texto); R2 aguarda aprovação. Contrato: `animation-contract-r1.md`. Prompts: `.atena/generated/hero-art-reset-20261021/prompts/`.
Origem: dono, 2026-10-21 — refazer os prompts dos personagens jogáveis, "desapegar" das tiras piloto (o Durvall demorou demais para ter arte aceitável), usar animações a 5 fps, o Vault atualizado e o que foi aprendido na construção do jogo.
Relação com `PLAN-NOTTGARD-HERO-WALK-FIX-20261021`: se aprovado, este plano o substitui para os heróis cuja arte for refeita (a auditoria L1/L1b continua valendo como linha de base e critério de aceite). O walk-fix fica como está até a decisão.

## 1. Por que os prompts atuais não servem

`ART-PROMPTS-016` (2026-09-23) foi escrito antes do Vault atual e de tudo abaixo. Exemplos concretos de erro herdado:
- **Brook:** o prompt manda "anão, orelhas curtas e arredondadas, barba castanho-escura, jovem". O jogo (`data/heroes.json`) e a biografia dizem halfling; o CANON do Vault (CHAR-011) e as tiras em uso mostram cabelo e barba brancos, orelhas pontudas, capa vermelha e maça com cabeça de espinhos. O prompt descreve outra pessoa. A raça do Brook precisa ser fechada contra a imagem CANON antes de gerar (o dossiê do Vault diz que a raça não foi definida pelas cenas).
- **Kayron:** `DEC-AASIMAR-EYES-001` (18/10/2026) exige olhos de uma só cor (vermelhos, os dois). As tiras atuais têm pupila escura (item V10 da lista de 21/10).
- **Durvall:** o termo "Receptáculo" está oculto no jogo, mas prompt e Vault ainda o usam. O prompt precisa de uma regra explícita do que nunca aparece em arte ou texto visível.
- **Maelor:** a classe foi corrigida no Vault (de Druida para Clérigo da Luz) em setembro.
- **Pipeline:** o prompt pede tira pronta com "grade-fonte 3×2" e células de 256×384. É exatamente o que produziu tiras fora do grid, com escala ×1,08–1,39, pés fora da base e recorte (auditoria L1).

## 2. O que o projeto já aprendeu (vira regra do novo pacote)

| # | Lição | Evidência |
|---|---|---|
| 1 | **Uma pose por imagem**, não tira. O ChatGPT acerta uma pose em 1024×1024 com fundo cinza liso (#B4B4B4); a Atena recorta, remove o fundo, ancora e monta a folha com `tools/asset_prep.gd`. | Lista de 21/10 ("já validado com Síntese e Nidhogg"); tiras piloto desalinhadas no L1 |
| 2 | **Âncora e escala vêm do idle.** Todas as poses de um herói têm a mesma altura de figura e a mesma base dos pés; o jogo escala pelo idle (`HERO_IDLE_ART_HEIGHT`). | `ui/hero_view.gd`; Korrak oeste ×1,34 |
| 3 | **Identidade só com referência CANON anexada.** Sem anexos a figura deriva (Korrak oeste virou outra pessoa). Anexar frente, perfil e costas CANON do Vault e gerar um herói por conversa. | L1b; o catálogo do Vault tem turnarounds CANON de 11 dos 12 |
| 4 | **Gerar só 5 direções** (n, ne, e, se, s) e espelhar; **onde o espelho troca a mão de um objeto de identidade, gerar o oeste real.** | Regra global de 2026-09-24; Durvall; L2 (Erik, Maelor, Zynara) |
| 5 | **Silhueta primeiro.** O herói aparece com 40–76 px de altura; detalhe que não lê a 64 px é desperdício. | `HERO_DISPLAY_HEIGHT`; STYLE-CHAR ("legível a 150 px") |
| 6 | **Passada precisa de poses que diferem de verdade** (contato e passagem, pernas e braços opostos). Tiras com variação de pixels de 2–4% deslizam. | L1 P3 (Zynara se/s, Sylas s, Maelor n) |
| 7 | **Sem partículas, sombras, fragmentos ou fundo.** Pontos soltos ao lado dos pés apareceram em Maelor, Sylas, Kayron e Leoric. | `specks-r1.json` |
| 8 | **Vault vence Nottcard e prompts antigos**; o CANON do Vault vence o texto. Segredos de "cânone do mestre" nunca entram em arte visível. | `AGENTS.md` global; `DEC-AASIMAR-EYES-001` |
| 9 | **Aceite é humano.** Nada vira CANON nem entra no jogo sem seu aceite; testes não encerram o gate. | Gates retidos, H-PORT-002 |

## 3. Referências CANON disponíveis no Vault (HEAD local 50008c9, 2026-10-20)

Frente, costas e perfil esquerdo (e direito quando existe), por herói: Durvall (CHAR-015), Brook (CHAR-011), Maelor (CHAR-035), Sylas (CHAR-051), Kayron (CHAR-028, pós-S24, 4 vistas), Korrak (CHAR-030), Leoric (CHAR-033), Zynara (CHAR-066), Bromnor (CHAR-010), Arlindo (CHAR-005 e VAFGIN-r1), Erik (EEEE-r01, 4 vistas). **Nyrelia só tem a frente CANON**: precisa de costas e perfil antes de gerar as direções dela.
Não busquei nada na rede: se existir Vault mais novo que o local, preciso da sua aprovação para baixar.

## 4. Animação a 5 fps: o que isso implica (decisão aberta)

Dados do jogo: velocidade visual `SPEED_PX = 190`; alturas em tela de 40 a 76 px; o laboratório de passada usa passo-alvo de 0,55 × altura.
- Passo = velocidade × quadros ÷ (2 × fps). Com 4 quadros a 5 fps o passo seria ~76 px, cerca de 1,2 × a altura de um herói de 64 px: **o herói patina**. Sem patinar, 4 quadros pedem ~11 fps e 6 quadros ~16 fps.
- Para valer 5 fps literal no jogo, a velocidade visual teria de cair para ~88 px/s (4 quadros), o que muda a jogabilidade, ou se aceita o patinar.
- Se "5 fps" é a taxa de **autoria** (poucas poses-chave bem desenhadas, cada uma gerada separada), o jogo pode tocar a ~10–11 fps com 4 poses sem patinar, e a qualidade vem de menos quadros e mais cuidado em cada um.

Recomendação: ciclo de **4 poses-chave** por direção (contato, passagem, contato oposto, passagem oposta), geradas uma a uma e tocadas pelo jogo entre 10 e 12 fps. Idle de 4 quadros a 5 fps (respiração lenta; aí o 5 fps literal serve). Ataque 4 e morte 6 como hoje, a menos que você decida outro número.

## 5. Lotes propostos

| Lote | Escopo | Gera arte? |
|---|---|---|
| R0 | Ficha visual por herói a partir do Vault e das referências CANON: identidade, "nunca aparece", mão de cada objeto, mirror-safe sim/não, lista de poses. Corrige as divergências da seção 1. | Não |
| R1 | Contrato de animação e pacote de prompts: formato de pose (1024², fundo #B4B4B4, margem, base dos pés), blocos de estilo e de negativos, anexos obrigatórios por herói, numeração das poses, critério de aceite (altura, base, diferença entre poses, sem pontos soltos), receita de montagem em `asset_prep`. | Não |
| R2 | **Validação do contrato com 3 heróis** (proposta: Durvall, que deu mais trabalho; Korrak, simétrico; Erik, assimétrico com oeste real). Você gera no ChatGPT; a Atena monta e mede. Ajustar o contrato com o que aparecer. | Sim, por você, com autorização |
| R3 | Os 9 heróis restantes, em lotes de 3. Nyrelia depende das vistas CANON novas. | Sim, por você, com autorização |
| R4 | Integração: montar folhas, ligar em `hero_view.gd`, ajustar `HERO_IDLE_ART_HEIGHT` e `HERO_FEET_Y`, testes, capturas e aceite visual H-PORT-002. Portagem registrada à origem. | Não |

Tudo só começa por lote aprovado. Nada de gerar, commit ou push sem pedido. As tiras atuais ficam no jogo até cada herói novo ser aceito; nada é apagado.

## 6. Decisões abertas

1. Significado de 5 fps (seção 4).
2. Escopo de R2: 3 heróis de validação (recomendado) ou os 12 de uma vez.
3. Raça e traços do Brook: seguir a imagem CANON (recomendado) ou o texto antigo.
4. Existe Vault mais novo que o HEAD local 50008c9?
