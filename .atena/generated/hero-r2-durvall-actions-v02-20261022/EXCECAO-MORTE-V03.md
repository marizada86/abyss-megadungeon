# Exceção documentada: Durvall, morte v03 (2026-10-22)

Status: DRAFT. Registro de decisão do dono. **O verificador não foi alterado** e nenhum limite foi mudado; esta é uma exceção a **uma imagem**, escrita e com escopo, não uma regra nova.

## Decisão

Dono, 2026-10-22: "Opção A: registre a morte v03 como aceita à vista com as duas exceções documentadas, sem mudar o verificador; a montagem trata a âncora e os pontos no R4."

## Imagem

`assets_incoming/hero-r2/durvall/durvall_death_se_v03.png`
SHA-256 `0860C7FB048DA31BE9EEB9DAC83F8B4218D696D706969ED713F8FE83D8E1A6D8` (conferido em 2026-10-22 contra o `ACEITE-VISUAL.md`; arquivo idêntico).

Aceite visual do dono: já registrado em `ACEITE-VISUAL.md` ("atena aprovado, qual o proximo passo?"). Esta exceção não repete a avaliação visual.

## O resultado técnico que continua valendo

O verificador v3 (`grid`, `magenta`, 4 figuras) **continua dando REPROVA** para esta imagem: critério 4 (pés) FALHA em 18,8% e critério 6 (pontos soltos) FALHA com 7 pontos. Os demais passam: 1 (4 figuras, margem mínima de 69 px), 2 (fundo, excesso de 3,5 pontos), 5e (poses diferentes, a menor diferença 41,2%); 5f é decisão à vista. O resultado oficial não foi reescrito.

## As duas exceções

| # | Critério | Por que não se aplica a esta imagem | Evidência |
|---|---|---|---|
| 1 | 4, linha dos pés (18,8%) | O critério foi definido para poses em pé. Na fileira de baixo, uma figura deitada não tem pés na linha do chão, e a base da figura de joelhos é a ponta da espada, não o apoio do corpo. A fileira de cima (em pé e recuo) está alinhada: 442 e 440, variação de 0,7% | `death-v03-INSPECAO.md`, seção 3 |
| 2 | 6, pontos soltos (7) | Seis dos sete pontos são pontas de fios de cabelo branco com tinta rosada do fundo; o sétimo é uma marca clara de poucos pixels sobre a calça. Visíveis só com ampliação de 3×; no jogo (64 px) ficam abaixo de 1 pixel | `death-v03-INSPECAO.md`, seção 2; `death-v03-pontos-soltos-recortes.png` |

## O que a exceção não faz

- Não declara a imagem pronta para integração, não a promove a CANON e não altera nenhum limite do verificador.
- Não vale para outras imagens, heróis ou animações: cada uma continua medida pelo verificador como está. Ataque v02 e habilidade v02 continuam "passa com itens à vista", sem exceção.
- Não é precedente para dispensar o critério 4 ou o 6 em poses em pé.
- Não reabre a geração: as três tentativas de morte seguem usadas.

## Obrigações transferidas para o R4 (montagem; exigem aprovação própria)

1. **Âncora vertical dos quadros de morte pelo contato do corpo com o chão**, não pelo ponto mais baixo da figura (a ponta da espada no quadro de joelhos). Sem isso, esse quadro paira cerca de 3,6 px a 64 px.
2. **Remover componentes soltos na escala de produção** (3 a 60 px² a 400 px de altura) e despill do rosa nas pontas de cabelo, sem apagar partes do desenho. Conferir à vista depois.
3. Registrar no relatório do R4 que a morte v03 entrou com esta exceção.

## Preservado

PNGs v01, v02 e v03 e seus hashes; `RESULTADO.md`, `ACEITE-VISUAL.md`, `death-v03-INSPECAO.md` e os JSONs de medição; verificadores v1, v2 e v3 sem alteração; o contrato r2; os demais planos. Sem geração, integração, commit ou push.
