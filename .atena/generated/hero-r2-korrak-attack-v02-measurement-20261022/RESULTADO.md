# Korrak, ataque SE v02: medição (2026-10-22, r2)

Status: DRAFT. Somente leitura: nenhuma geração, nenhuma alteração no verificador, nas imagens ou no jogo. Pedido do dono: "mede o ataque v02 do Korrak". Imagem em `assets_incoming/hero-r2/korrak/korrak_attack_se_v02.png`, sem pós-edição.

| Arquivo | SHA-256 | Confere com o recibo |
|---|---|---|
| korrak_attack_se_v02.png | B3462FBDAC2D4F4A17618E8B4C630023AA5039522E23E4FE1D39606D7D690A16 | sim (`attack-generation-receipt-v02.json`) |
| korrak_attack_se_v01.png (preservado) | F22F0112868BE1AC513DD1AC7C933CE4F4A556FED08C1128AF8B139EFB09F8F8 | sim |

Aceite visual do dono: **pendente**. Tentativas usadas: 2 de 3 (resta 1).

## 1. Verificador v3 (`grid`, `magenta`, 4 figuras): `v3-korrak-attack-v02.json`

| Critério | v01 | v02 |
|---|---|---|
| 1 Figuras | PASSA | PASSA |
| 4 Pés | PASSA (0,0%) | PASSA (1,6%) |
| 2 Fundo | PASSA (0,1 ponto) | PASSA (0,1 ponto) |
| 6 Pontos soltos | PASSA (0) | PASSA (0) |
| 5e Poses diferentes | PASSA (menor 36,7%) | PASSA (menor 46,9%, pares 3-4) |
| 5f Gesto | à vista | à vista |
| **Veredito** | PASSA_COM_ITENS_A_VISTA | **PASSA_COM_ITENS_A_VISTA** |

Separação por componentes (`sep_check`, folga de 6 px): 4 componentes, **separadas**; menor margem da imagem **42 px** (v01: 20 px). Tremor do corpo 0,167 (alinhar pelo tronco na montagem).

## 2. O que o prompt pediu e o que veio

| Pedido | Resultado medido |
|---|---|
| Figura de no máximo 300 px de altura | **Não atendido**: alturas 457, 434, 437 e 428 px (iguais às do v01, 445-475) |
| Margem de 80 px em todos os lados | **Não atendido**: 42 px na pior borda (as figuras seguem separáveis; o verificador passa) |
| Balanço num único plano horizontal, sem machado sobre a cabeça | **Atendido** nas 4 figuras |
| Cabeça do machado inteira visível | **Atendido** nas 4 figuras |
| Duas mãos visíveis em toda pose | **Atendido nas figuras 1, 2 e 3; NÃO na figura 4** |

## 3. À vista (recortes ampliados: `recorte-fig2-maos.png`, `recorte-fig4-maos.png`)

- **Figura 1 (calibração):** duas mãos no cabo, machado atravessado, assimetrias do CANON corretas (pelo da pele à esquerda da tela, pauldron de aço com espinhos à direita).
- **Figura 2 (preparo):** machado puxado para a esquerda na altura do quadril, as duas mãos visíveis (a de trás junto do pomo, a da frente a meio do cabo). Resolve a falha do v01 (mão atrás da cabeça, machado sobre a cabeça).
- **Figura 3 (golpe):** braços à frente, as duas mãos visíveis, machado na horizontal à direita; ainda lê um pouco como estocada (a face da lâmina fica de frente e a borda não lidera o movimento), mas muito menos que no v01.
- **Figura 4 (seguimento):** machado baixo no extremo direito, **só uma mão aparece** (a da frente, com a braçadeira). A outra mão e o pomo ficam atrás do tronco; o cabo desaparece atrás do quadril. É a pendência já registrada pelo recibo; confirmada no recorte.
- Sem efeitos, sombras, brilho ou faíscas. Rachaduras de lava pintadas no metal. Identidade e estilo seguem o idle aprovado.

O verificador **não pega** a mão faltante (5e e 5f não medem isso), como já anotado em `REPROVACAO-ATAQUE-V01.md`.

## 4. Opções (decisão do dono; nada aplicado)

| Opção | O que é |
|---|---|
| Aceitar à vista com exceção escrita | Figuras 1 a 3 atendem a regra das duas mãos; registrar a figura 4 (segunda mão atrás do tronco, no seguimento) como exceção, só para este arquivo |
| 3ª tentativa (a última) | Mesmo prompt com pedido explícito de segunda mão visível na figura 4 (ex.: seguimento com o corpo girado menos, cabo cruzando a frente do tronco); gasta a tentativa restante e não garante que o tamanho melhore |
| Ataque com 4 desenhos | Muda o contrato (alternativa indicada no recibo); só com aprovação |

Observação: o tamanho (428-457 px contra 300 pedidos) e a margem (42 px contra 80) não são corrigíveis por prompt até agora (v01 e v02 ignoraram o pedido); para a montagem não bloqueiam, pois as figuras são separáveis.

## 5. Preservado

v01 e seu hash, o recibo v02, o prompt v02, os verificadores v1, v2 e v3 sem alteração, `sep_check.gd` original (copiei para `sep_check_v02.gd` só com outra lista de casos), a exceção do idle, os relatórios do Durvall. Sem integração, promoção CANON, commit ou push.
