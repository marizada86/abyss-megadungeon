# Piloto do Lote 3 (E03, D01, T02), veredito técnico, 2026-10-27

DRAFT. Revisão de separabilidade, alinhamento e leitura das candidatas **v02**, que o dono já aceitou visualmente por hash (`pilot-acceptance-20261027.json`). Não é aceite técnico de atlas nem integração. As v01 ficam preservadas para comparação.

## Medidas (segmentação por vazios, limiar 24/255, fundo preto puro)

| Folha (v02) | Quadros | Cortes entre quadros | Observação |
|---|---|---|---|
| E03 | 4 voo + 4 impacto | 3 cortes por linha, todos com **0 px acesos** nas fronteiras de 384 px | quadros de 303–331 px de largura dentro de células de 384; a linha de voo está ~50 px acima do centro nominal da linha, o que a preparação recentra |
| D01 | 6 | 5 cortes, todos com **0 px acesos** | larguras de 179 a 252 px; elipse do chão 2:1 reconhecível a partir do quadro 2 |
| T02 | 6 | 5 cortes, todos com **0 px acesos** | base dos tentáculos em y = 607–609 nos seis quadros (fixa, ±1 px) |

Os "2 px, 2 px, 1 px de margem nominal" da auditoria de origem vêm da grade nominal e de conteúdo de vizinhos; com o corte pelo menor vão não há perda nem contaminação. Nenhum quadro vazio.

## T02: laço

O centro do anel do chão **deriva** ~23 px para a esquerda ao longo dos seis quadros (140, 136, 131, 128, 124, 117 px nas células locais), mas a base fica na mesma altura. Medida de diferença média de luminância entre quadros consecutivos:

- sem alinhar: 1>2 26, 2>3 30, 3>4 26, 4>5 25, 5>6 39, **6>1 50**;
- alinhando cada quadro pelo centro do anel: 1>2 25, 2>3 24, 3>4 23, 4>5 24, 5>6 33, **6>1 8,8**.

Alinhado, o fechamento do laço 6>1 é o melhor de todos os pares. Ou seja, o defeito é só a deriva horizontal, que a preparação corrige centrando cada quadro pelo anel. As sete tentáculos aparecem nos seis quadros.

## Leitura

- **E03:** claramente da família do orbe radiante, mais denso e ornamentado (halo, raios em cruz, cauda longa). O impacto sai com **oito** pontas em vez das seis pedidas: não reprova, é estético. A evolução se distingue da base.
- **D01:** progressão física legível: clarão, anel elíptico, poeira, lascas e dissipação. A v02 é mais contida que a v01 e perde um pouco de drama, mas lê melhor em tamanho de jogo.
- **T02:** anel de sete tentáculos com ventosas e brilho violeta; sem olhos nem rostos, como pedido.
- **Fundo claro:** aditivos viram manchas claras, como nos lotes anteriores; os mapas são escuros e o contorno de perigo fica por baixo.

## Para a preparação

1. E03: âncora no **centro da linha**, e o pivô de voo (centroide da luz) medido depois da normalização, como nas famílias do Lote 1.
2. D01: medir a largura do anel dominante no pico para a escala por raio do telégrafo.
3. T02: âncora na base, **centro horizontal por quadro** e linha de base fixa.
4. Escala única por animação, margem mínima de 21 px.

## Veredito

As três passam no portão do piloto. Recomendo liberar as outras 9 folhas com os mesmos blocos de estilo. Tentativas usadas: 2 de 3 em cada ID do piloto.
