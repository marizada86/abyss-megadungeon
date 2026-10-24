# Lote 2: veredito técnico das 19 folhas restantes, 2026-10-24

DRAFT. Revisão de arte e de separabilidade das fontes; **não** é aceite visual do dono nem aceite técnico de atlas. Sem integração de runtime. Pranchas em `review-20261024/` (rev-P, rev-M, rev-G1, rev-G2).

## Candidatas recomendadas (uma por ID)

v02 em **M04, G06 e G09** (as v01 de contato lateral e excesso ficam só para comparação); v01 nas outras 16. Hashes em `remaining-source-audit-20261024.json`.

| ID | Candidata | Leitura | Observação para a preparação |
|---|---|---|---|
| P01 xp_brilho | v01 | brilho azul em loop, sutil | ok |
| P03 moeda_coleta | v01 | fonte de moedas douradas, distinta | altura 347 → escala ~0,7 |
| P04 pocao_coleta | v01 | verde com cruzes, lê "cura" | altura 346 → escala ~0,7 |
| P05 ima_pulso | v01 | pulso e implosão dourado/azul | 2 fiapos soltos no quadro 6 (10 e 6 px) a descartar; fronteira dos quadros 3-4 tem ~40 px de brilho a cortar |
| P06 subida_de_nivel_v2 | v01 | pilar, anéis, raios; bem mais rico que a atual | altura 473 → escala ~0,45; ~14 px de brilho cruzando a fronteira 3-4 |
| P07 mare_aura | v01 | dupla hélice ciano-lilás em loop | **intenso para "sutil"**: o código deve usar opacidade baixa (~0,35) |
| M02 morte_alma | v01 | espírito encapuzado sobe e se desfaz | altura 476 → escala ~0,45; vai ficar pequeno, é feito para elite/narrativa, não para volume |
| M03 morte_elite_estouro | v01 | dourado, anel e moedas | ~34 px de brilho cruzando a fronteira 2-3 |
| M04 morte_chefe_colapso | **v02** | pilar, cristais, anel; v02 sem contato | v02 tem fronteiras limpas |
| M05 morte_detritos | v01 | estilhaços de madeira e pó | fronteiras limpas |
| M06 morte_explosivo | v01 | bola de fogo, a melhor do lote | ~53 e ~25 px cruzando as fronteiras 2-3 e 3-4: cortar no menor vão; sem v02 necessária |
| G01 boss_varredura_aviso | v01 | barra horizontal com pontas | **esticar em três fatias** (pontas fixas, miolo esticado); as duas pontas têm seta, não esticar a folha inteira |
| G02 boss_varredura_feixe | v01 | feixe com núcleo branco | fronteiras limpas; mesmo esticamento em três fatias |
| G04 boss_marca_alvo | v01 | mira (linha de cima) e detonação (de baixo) | os raios horizontais do quadro 2-3 da detonação cruzam ~20 px a fronteira: cortar e esmaecer as pontas |
| G05 boss_conjuracao_carga | v01 | hélice roxa em loop | altura 440 → escala ~0,55 |
| G06 boss_conjuracao_estouro | **v02** | anel de energia que explode | v02 tem fronteiras limpas |
| G07 boss_conjuracao_interrompida | v01 | selo ciano que se estilhaça | o quadro 1 encosta a 3 px da borda esquerda; escalar já resolve |
| G08 boss_escudo | v01 | cúpula hexagonal (4 loop) e quebra (4) | a melhor do grupo; fronteiras limpas, 353 px cabem na célula de 384 |
| G09 boss_fase_estouro | **v02** | explosão roxa/vermelha de troca de fase | v02 tem fronteiras limpas |

## Conclusões

- As 19 IDs têm uma candidata utilizável; **nenhuma exige nova tentativa** de geração. Tentativas usadas: 2 de 3 em M04, G06 e G09; 1 de 3 nas demais.
- As fontes excedem a célula de 256 px (e 384 px), como já visto no piloto; a normalização por fator comum resolve. Nas fronteiras entre quadros há, no máximo, dezenas de pixels soltos (centenas só em P05, M06, M03, G04), que se descartam no corte pelo menor vão.
- Fundo claro: continua a ressalva do piloto. Os efeitos são aditivos e, sobre chão claro, viram manchas brancas; os mapas atuais são escuros. Perigo de chefe depende do contorno fixo por baixo (decisão do dono de 2026-10-23).
- Leitura nos tamanhos de jogo (24–48 px nos itens, 96–160 px nos chefes) ainda deve ser conferida em prancha própria na preparação.

## Pontos de atenção para o código

1. G01/G02: esticamento em três fatias, miolo uniforme.
2. G03/G04: o selo é círculo visto de cima; a detonação de G04 ultrapassa o selo, limitar ao raio do telégrafo.
3. P07: opacidade baixa e fade na entrada e na saída.
4. P06 substitui a subida de nível atual; a antiga fica como fallback.
5. M02: efeito grande e raro; usar só em mortes de "alma" definidas por dados, não em toda morte comum.
