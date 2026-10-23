# Durvall, morte v03: inspeção dos dois critérios que reprovam (2026-10-22, r1)

Status: DRAFT. Somente leitura: nenhuma geração, nenhuma alteração no verificador, nas imagens ou no jogo. Fecha o item "inspecionar os sete pontos soltos e o critério de alinhamento da morte" do plano (`death_next_activity`). Imagem: `assets_incoming/hero-r2/durvall/durvall_death_se_v03.png` (SHA-256 no `ACEITE-VISUAL.md`). Derivado: `death-v03-pontos-soltos-recortes.png` (cada ponto ampliado 3×).

## 1. Reprodução

Rodei o verificador v3 (`grid`, `magenta`, 4) nas três candidatas aceitas à vista e obtive os mesmos resultados da medição anterior:

| Imagem | Veredito | Itens |
|---|---|---|
| attack v02 | PASSA_COM_ITENS_A_VISTA | 6: 2 pontos (INCERTO); 5e mínima 48,9%; 5f à vista |
| active v02 | PASSA_COM_ITENS_A_VISTA | 6: 3 pontos (INCERTO); 5e mínima 36,2%; 5f à vista |
| death v03 | REPROVA | 4_pes FALHA (18,8%) e 6: 7 pontos FALHA; 5e mínima 41,2% |

## 2. Os sete pontos soltos

Recortes ampliados em torno de cada posição:

| # | Posição | Figura | O que é |
|---|---|---|---|
| 1 | (1077, 287) | 2, recuo | pontas de fios de cabelo branco com tinta rosada, à esquerda da cabeça |
| 2, 3, 4 | (362, 766), (362, 755), (354, 755) | 3, de joelhos | pontas de fios de cabelo com tinta rosada, junto ao ombro; três componentes do mesmo tufo |
| 5, 6 | (953, 781), (944, 789) | 4, caído | pontas de fios de cabelo ao lado da cabeça |
| 7 | (1191, 798) | 4, caído | marca clara minúscula sobre a calça; é o único ponto que não é cabelo |

**Seis dos sete pontos são cabelo.** A contagem passa de 6 porque o Durvall tem cabelo branco longo e, nas poses de queda, ele se espalha. Todos são visíveis só com ampliação de 3×; na escala de produção (400 px) já são 3 a 60 px² e, no jogo (64 px), ficam abaixo de 1 pixel. A tinta rosada nas pontas do cabelo é resíduo do fundo magenta; o recorte de produção a corrige parcialmente (o critério 2, de fundo, passa em 4,2%).

## 3. A linha dos pés na morte

| Fileira | Figuras | Base da caixa (px) |
|---|---|---|
| 1 | em pé · recuo | 442 · 440 (variação 0,7%, boa) |
| 2 | de joelhos · caído | 873 · 831 |

A variação de 18,8% sai da fileira 2: 42 px de diferença dividida por 224 px (a maior altura da fileira), mas a figura caída tem só 114 px de altura. Três observações:
1. **Uma figura deitada não tem "pés na linha do chão"** como uma em pé: o corpo deitado ocupa o plano do chão e o ponto mais baixo da caixa é a espada ou o ombro, não um pé.
2. **A base da figura de joelhos é a ponta da espada** (que desce abaixo dos joelhos), não o ponto de apoio do corpo. Ancorar o quadro pelo ponto mais baixo ergue o corpo em cerca de 25 px de 440 (≈ 3,6 px a 64 px).
3. O critério 4 foi definido para poses em pé (caminhada, ataque, habilidade). Aplicá-lo à morte mede o que as poses *devem* mudar.

O 4_pes da morte, tal como o verificador o calcula, **não é um defeito da imagem**. O ponto prático fica para a montagem: **a âncora vertical dos quadros de morte deve usar o contato do corpo com o chão, não a ponta da espada** (registrado para o R4).

## 4. O que eu proponho (nada aplicado; decisão do dono)

| Opção | O que é | Muda o verificador? |
|---|---|---|
| **A. Exceção documentada (recomendo)** | Registrar a morte v03 como aceita à vista com duas exceções escritas: o 4_pes não se aplica a uma figura deitada, e os sete pontos são fios de cabelo (seis) e uma marca de um pixel; no R4 a montagem ancora pelo contato do corpo e remove componentes soltos na escala de produção | Não |
| **B. Mudar o critério para a morte** | 4_pes compara só as figuras de pé (calibração e recuo); pontos soltos tolerariam até 12 | Sim, com aprovação; o limite de 12 sairia de uma única imagem |
| **C. Manter a retenção** | A v03 fica reprovada tecnicamente | Não; exigiria gerar de novo e o orçamento de morte está esgotado (3 de 3) |

Não alterei o verificador nem dispensei critério: a escolha é sua.

## 5. Preservado

PNGs v01, v02 e v03 e seus hashes; `RESULTADO.md`, `ACEITE-VISUAL.md`, relatórios JSON; verificadores v1, v2, v3; o aceite visual do dono (ataque v02, habilidade v02, morte v03). Sem integração, promoção CANON, portagem, commit ou push.
