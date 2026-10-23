# Exceção documentada: Korrak, idle SE v01 (2026-10-22)

Status: DRAFT. Registro de decisão do dono. **O verificador não foi alterado** e nenhum limite foi mudado. É uma exceção a **uma imagem**, escrita e com escopo, não uma regra nova.

## Decisão

Dono, 2026-10-22: "Opção A: registre o idle do Korrak como aceito à vista com a exceção do critério 1 e dos 3 artefatos, sem mudar o verificador, e deixe a correção do critério (B) como proposta separada."

## Imagem

`assets_incoming/hero-r2/korrak/korrak_idle_se_v01.png`
SHA-256 `1EBB6780349A26A13B47284536D07928BF0DD79487CD1A9AF2260914813426C2` (conferido em 2026-10-22 contra o recibo `idle-generation-receipt-v01.json`; arquivo idêntico, sem pós-edição). Tentativas usadas: 1 de 3.

Aceite visual do dono: já registrado no recibo ("aprovado, proximo passo?"). Esta exceção não repete a avaliação visual.

## O resultado técnico que continua valendo

O verificador v3 (`idle`, `magenta`, 3 figuras) **continua dando REPROVA** para esta imagem: critério 1 FALHA; critério 6 INCERTO (3 pontos). Os demais passam: 3 (escala, 0,6%), 4 (pés, 0,0%), 2 (fundo, excesso de 0,2 ponto). O resultado oficial não foi reescrito.

## As exceções

| # | Critério | Por que não se aplica a esta imagem | Evidência |
|---|---|---|---|
| 1 | 1, figura toca o limite do seu terço de 512 px | As pontas do machado passam das linhas dos terços (512 e 1024) por 1 a 3 px. As figuras não se tocam: há **18 px** e **20 px** de fundo vazio entre elas (colunas 514 a 531 e 1025 a 1044), e o `asset_prep` separa componentes com folga padrão de 6 px. Margens à esquerda e à direita da imagem: 19 px e 8 px | `RESULTADO.md`, seção 2; `gaps.gd` |
| 2 | 6, pontos soltos (3, INCERTO) | Os três pontos estão exatamente nas linhas de corte dos terços (x=512 e x=1024): são pontas do machado cortadas pela partição do verificador e contadas como componentes pequenos. Não são pontos soltos da imagem | `RESULTADO.md`, seção 3 |

## O que a exceção não faz

- Não declara a imagem pronta para integração, não a promove a CANON e não altera nenhum limite do verificador.
- Não vale para outras imagens, heróis ou animações. Em especial, **não dispensa o critério 1 para ataque, habilidade ou morte do Korrak**: cada imagem é medida como está.
- Não é precedente. A correção do critério, que evitaria exceções repetidas, está na proposta separada `PROPOSTA-CRITERIO-1-SEPARACAO.md` e **não está aplicada**.
- Não reabre a geração.

## Obrigações transferidas para o R4 (montagem; exigem aprovação própria)

1. Separar as três figuras por componentes (`asset_prep`, `split: components`) e conferir que saem 3 figuras.
2. Alinhar pelo tronco (contrato r3 para a caminhada; para o idle, âncora pelo contato dos pés) e conferir à vista que o machado não foi cortado.
3. Registrar no relatório do R4 que o idle do Korrak entrou com esta exceção.

## Preservado

O PNG e seu hash; o recibo; `RESULTADO.md` e o JSON de medição; verificadores v1, v2 e v3 sem alteração; contrato r2; o aceite visual do dono; os demais planos. Sem geração, integração, commit ou push.
