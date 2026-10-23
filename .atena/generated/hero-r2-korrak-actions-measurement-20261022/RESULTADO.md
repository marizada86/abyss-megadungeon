# Korrak, ações SE v01: medição (2026-10-22, r1)

Status: DRAFT. Somente leitura: nenhuma geração, nenhuma alteração no verificador, nas imagens ou no jogo. Pedido do dono: "mede o ataque do Korrak"; medi também a habilidade e a morte, que estavam na mesma pasta, para não gastar outra rodada. Imagens em `assets_incoming/hero-r2/korrak/`, sem pós-edição, com SHA-256 conferidos contra `actions-generation-receipt-v01.json`:

| Arquivo | SHA-256 | Confere com o recibo |
|---|---|---|
| korrak_attack_se_v01.png | F22F0112868BE1AC513DD1AC7C933CE4F4A556FED08C1128AF8B139EFB09F8F8 | sim |
| korrak_active_se_v01.png | F316D1F345535E2CFED19F69904951498E40B7E7CC4B82C79A9FE217C4314DAC | sim |
| korrak_death_se_v01.png | 27F9C1B7AE091BFECE766AFAAF467C312CDD721F1FE916284E4832671C3321E4 | sim |

Aceite visual do dono: **pendente** nas três (recibo). A exceção do idle do Korrak **não se aplica** a elas. Tentativas usadas: 1 de 3 em cada.

## 1. Resultado do verificador v3 (`grid`, `magenta`, 4 figuras)

| Critério | Ataque | Habilidade | Morte |
|---|---|---|---|
| 1 Figuras | PASSA | **FALHA** | **FALHA** |
| 4 Pés | PASSA (0,0%) | PASSA (2,2%) | **FALHA (11,2%)** |
| 2 Fundo | PASSA (0,1 ponto) | PASSA (0,2) | PASSA (1,3) |
| 6 Pontos soltos | PASSA (0) | INCERTO (1) | INCERTO (1) |
| 5e Poses diferentes | PASSA (menor 36,7%) | PASSA (menor 42,8%) | PASSA (menor 45,6%) |
| 5f Gesto | à vista | à vista | à vista |
| **Veredito** | **PASSA_COM_ITENS_A_VISTA** | REPROVA | REPROVA |

## 2. Ataque (o que foi pedido)

Sem nenhuma falha automática. Margens boas, nenhum ponto solto, fundo limpo, as quatro poses bem diferentes entre si (a menor diferença é 36,7%).

À vista:
- **Figura 1 (calibração):** em pé, machado atravessado, pele no ombro esquerdo da tela e pauldron de aço com espinhos no direito (o ombro esquerdo do personagem), como no CANON e no idle aprovado.
- **Figura 2 (preparo):** machado levantado atrás da cabeça, tronco girado; o pauldron de aço aparece à frente. Lê como preparo, mas o machado está **sobre a cabeça**, não "atrás do ombro direito" como o prompt descreve.
- **Figura 3 (golpe):** braços estendidos para a direita, machado na horizontal. Lê mais como **estocada** do que como golpe cortando em arco; a face da lâmina fica de frente.
- **Figura 4 (seguimento):** machado baixo, do lado de fora, tronco levado pelo movimento. Lê bem.
- Identidade, rachaduras de lava pintadas no metal, ausência de efeitos e estilo seguem o idle. Sem chamas, faíscas, brilho ou sombras no chão.

Pontos de decisão à vista, que são seus: se o preparo sobre a cabeça e o golpe em estocada servem como ataque do Korrak.

## 3. Habilidade e morte (medidas, sem aceite pedido)

Ambas reprovam pelo critério 1 (e a morte também pelo 4). **Olhei as duas imagens** e não vejo defeito de pose, mas há dois pontos reais de enquadramento.

**Habilidade (olhada):**
- Figura 2: machado erguido sobre a cabeça, torso arqueado. Figura 3: machado atrás da cabeça, no alto do arco, corpo inclinado para a frente. Figura 4: machado cravado à frente, agachado, cabeça baixa. As quatro poses são claramente diferentes e leem como descritas; identidade e assimetrias (pele à esquerda da tela, pauldron à direita, de frente) como no idle.
- **Enquadramento real:** o pomo do machado da figura 2 fica a **5 px** do topo da imagem (sem folga para o recorte); os pés da figura 1 chegam à linha entre as fileiras (y=511).

**Morte (olhada):**
- Figura 2: recuo, cabeça para trás, um pé fora do chão, machado frouxo na mão. Figura 3: de joelhos, cabeça baixa, machado indo ao chão. Figura 4: deitado de lado, olhos fechados, machado no chão ao lado da mão, sem sangue. Leem bem e são distintas.
- **Enquadramento real:** os pés das figuras 1 e 2 passam da linha entre as fileiras (y=511); no teste por componentes elas continuam separadas das figuras de baixo.
- **Critério 4 (11,2%):** o mesmo caso da morte do Durvall: a figura caída não tem linha de pés e a de joelhos tem o cabo do machado como ponto mais baixo.

Pelo teste do `asset_prep` (folga de 6 px), as quatro figuras de cada imagem são **componentes separados**: `sep_check_korrak_acoes.json`. A menor margem em relação à borda da imagem é 5 px na habilidade, 20 px no ataque e 41 px na morte.

## 4. Observação importante

O critério 1 do verificador por espaços fixos já reprovou, nesta sessão, o idle do Korrak, a E1 do Durvall, a habilidade e a morte do Korrak. Em **todos** os casos medidos com a definição alternativa, as figuras ficam separadas. É o padrão que a **proposta B** (`hero-r2-korrak-idle-measurement-20261022/PROPOSTA-CRITERIO-1-SEPARACAO.md`) trata. Continua **não aplicada**, sem decisão do dono, e eu **não** estendi a exceção do idle a estas imagens.

## 5. Opções (decisão do dono; nada aplicado)

| Opção | O que é |
|---|---|
| **Aceitar o ataque à vista** | Registrar o aceite visual do ataque; resultado oficial: PASSA_COM_ITENS_A_VISTA, sem exceção necessária |
| **Habilidade e morte** | Você olha e decide: aceitar à vista e pedir exceções escritas (critério 1, e o 4 na morte), aprovar a proposta B (criaria o `r2_check_v4.gd`), ou refazer pedindo figuras menores (restam 2 tentativas em cada) |

Não alterei o verificador nem dispensei critério.

## 6. Preservado

As três imagens e seus hashes; o recibo; os verificadores v1, v2 e v3 sem alteração; o contrato r2; o idle do Korrak e sua exceção; os relatórios do Durvall. Sem integração, promoção CANON, commit ou push.
