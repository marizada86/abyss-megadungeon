# Piloto do Lote 2 (M01, P02, G03), veredito técnico v01, 2026-10-24

DRAFT. Revisão de leitura e de medidas das fontes; **não** é aceite visual do dono nem aceite técnico de atlas. Sem integração de runtime.

## Medidas (segmentação por vazios, limiar 24/255, fundo preto puro nos quatro cantos)

| Folha | Quadros | Centros | Excesso de tamanho | Observação |
|---|---|---|---|---|
| M01 | 6 | cx 130, 369, 634, 908, 1165, 1394; cy ~500 | pico 249×300 px (célula nominal 256) | o sétimo segmento (x 1470–1488) são 193 px de brilho no fim do quadro 6, sobra a descartar na preparação |
| P02 | 6 | cx 133, 386, 640, 895, 1150, 1406; cy ~495 | alturas até 295 px | último quadro ainda tem brilho (4937 px acesos), conferir o desaparecimento em animação |
| G03 | 4 + 4 | linha de cima cx 193, 575, 959, 1342; linha de baixo ~190, 575, 960, 1343 | sigilo de 341 px de diâmetro na linha de cima; detonação até ~378 px | a detonação é ~11% maior que o selo; os quadros 1 a 3 da detonação se tocam (vazio < 6 px) |

Nenhum quadro vazio. Todas as fontes têm 1536×1024.

## Leitura

- **Fundo escuro, 160/48/32 px:** M01 e P02 leem bem até 32 px. A progressão de M01 (clarão, nuvem, dissipação) e a de P02 (estrela, espiral, anel, faíscas) são nítidas e distintas.
- **Fundo claro simulado (aditivo sobre cinza-lilás):** os dois viram manchas brancas; o M01 pálido quase some. Esperado em mistura aditiva; os mapas do jogo são escuros. Se algum mapa for claro, o M01 precisa de revisão.
- **G03:** o selo da linha de cima é quase radialmente simétrico (oito pontas, as quatro cardinais maiores). Os centros caem nas células nominais, o que permite recortar a grade de 384 px sem perder nada, com folga de ~2 px nos quadros mais largos.

## Preparação (a fazer, não é defeito de estilo)

1. Normalizar escala por folha com um fator comum (M01 e P02 em ~0,70; G03 ~0,55), centralizando pelo centro do efeito e, no G03, pelo centro da estrela.
2. Descartar o resíduo à direita do quadro 6 do M01.
3. G03: cortar nos limites de célula (384 px) e escalar linha de cima e de baixo juntas; no código, limitar a detonação ao raio do telégrafo (a arte passa ~11%).
4. No código do G03, decidir o ângulo de corte dos quadrantes em relação às pontas cardinais, que são as maiores.

## Veredito

As três passam no portão do piloto quanto a estilo, leitura e separabilidade. Recomendo liberar as outras 19 folhas com os mesmos blocos de estilo, sujeito ao aceite visual do dono por ID/revisão/hash.

SHA-256 em `pilot-sources-v01.json`.
