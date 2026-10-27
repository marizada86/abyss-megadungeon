# Lote 3: veredito técnico das 9 folhas restantes, 2026-10-27

DRAFT. Revisão de arte e de separabilidade das candidatas recomendadas na entrega (`remaining-generation-20261027.md`); **não** é aceite visual do dono nem aceite técnico de atlas. Pranchas em `review-remaining/` (A, B e C).

## Medidas (segmentação por vazios, limiar 24/255, fundo preto puro)

Em todas as nove, os cortes entre quadros caem em colunas com **0 px acesos**, exceto: E07 (6 e 7 px em duas fronteiras) e D02 (3 e 1 px). São fagulhas soltas, descartáveis no corte pelo menor vão. Nenhum quadro vazio.

As fontes excedem a célula nominal, como nos lotes anteriores (E07 até 367 px, D02 até 410 px de altura, E04/E05 até 407 px nos impactos): a normalização por fator comum resolve, medindo a elipse ou o anel dominante antes de escalar por raio.

## Recomendação (uma candidata por ID)

| ID | Candidata | Leitura | Para a preparação |
|---|---|---|---|
| E01 melee_fisico_evo_arco | **v02** | crescente carmim com fissuras e estilhaços, claramente mais pesado que o arco-base | orientação como a base (convexo à direita); âncora no atacante, centro da célula |
| E02 melee_rajada_evo | **v02** | três cortes finos que se cruzam e estouram em faíscas; lê como "rajada" | quadros até 279 px de altura: escala comum; simétrico, sem pivô de direção |
| E04 orbe_arcano_evo | v01 | orbe violeta com cauda de fragmentos de runa; impacto em estrela de cristais | voo ancorado na cabeça; tingir por arma (Domínio Coletivo mais rosado) |
| E05 onda_cortante_evo | v01 | lâmina de vento ciano-branca com redemoinho e raios; impacto em X | voo ancorado no arco de ataque; pivô medido depois da escala |
| E06 pulso_evo | **v03** | anel duplo com coroa de raios, círculo plano visto de cima | medir o raio do anel dominante no pico para `PEAK_RING_RADIUS`; 3 de 3 tentativas usadas |
| E07 explosao_fogo | v01 | explosão de fogo vertical bem progressiva, dissipação limpa | altura 367 px: escala ~0,65; usar em Bola de Fogo (pequena) e Tormenta (grande) |
| D02 detonacao_magica | v01 | anel de runas elíptico 2:1 com coluna de cristais violeta | medir a largura do anel no pico (`RING_PX`) antes da escala por raio |
| T01 tentaculos_emergem | **v02** | rachaduras no chão, tentáculos irrompendo e terminando em pé | âncora na base com centro por quadro; conferir transição 6 → T02 quadro 1 |
| H01 dano_heroi | v01 | corte diagonal vermelho e branco com fagulhas, curto e discreto | reduzir na preparação (efeito ~130 px); neutro para tingir por dtype |

## Pontos de atenção

- **E06:** v03 é a mais contida e a que não forma pontes entre quadros. Esgotou as 3 tentativas; se o dono quiser mais, é decisão dele.
- **D02:** o prompt original tinha o conflito "sem magenta" × paleta magenta; a fonte saiu violeta e magenta e funciona. Não precisa de nova tentativa.
- **E05:** a lâmina tem núcleo claro mais difuso que a cabeça do orbe; o pivô de voo será o centroide do brilho, a validar em captura.
- **Fundo claro:** continua a ressalva dos lotes anteriores; mapas são escuros e o contorno de perigo fica por baixo.

## Veredito

As nove candidatas recomendadas passam no portão técnico. Nenhuma exige nova geração. Recomendo aceitar a seleção da entrega: **E01, E02, T01 v02; E06 v03; E04, E05, E07, D02, H01 v01**, pelos hashes de `remaining-source-audit-20261027.json`.
