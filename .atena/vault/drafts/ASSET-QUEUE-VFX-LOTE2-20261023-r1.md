# Fila de arte — VFX e "dopamina", Lote 2: chefes, morte e coleta (2026-10-23, r1)

Status: DRAFT. Escopo das 22 folhas **aprovado pelo dono em 2026-10-23** (`PROPOSTA-vfx-lote2-20261023-r1.md`), com **piloto M01, P02 e G03**. Prompts e fila prontos; **nenhuma imagem foi gerada** e nada foi integrado. Continua a série **F** do Lote 1 (`ASSET-QUEUE-VFX-LOTE1-20261023-r1.md`) com as séries **G** (chefes), **M** (morte) e **P** (coleta e progressão).

## Como gerar (ChatGPT, manual)

Igual ao Lote 1. Tudo está em `.atena/generated/vfx-lote2-20261023-r1/`:

- `prompts/<ID>_<nome>_prompt.txt`: prompt completo e autossuficiente. Colar inteiro. Os três primeiros blocos (estilo, fundo preto aditivo, grade) são os mesmos do Lote 1, de propósito: se o piloto pedir ajuste de estilo, muda-se uma vez e vale para as duas séries.
- `ref-existing-vfx.png`: a mesma prancha de referência do Lote 1. **Anexar em toda geração**; é referência de acabamento, não de forma.
- `queue.json`: manifesto com estado, nome de arquivo esperado, grade, fundo, tamanho final e consumer.

Ao receber a imagem, salvar nesta pasta com o `expected_file` do manifesto (`M01_morte_poeira_v01.png` e assim por diante). Correção objetiva: até três candidatas por peça (`_v02`, `_v03`); depois, bloqueio para decisão. O aceite visual é do dono, por ID/revisão/hash.

Todas as 22 são **aditivas** (preto puro #000000 vira transparente); não há folha opaca neste lote.

Grade de geração 1536×1024. Folhas de 6 quadros: uma fileira de seis células de 256 px (recorte posterior para 1536×256). Folhas de 8 quadros (G03, G04, G08): grade 4×2 de células de 384 px, linha de cima = ciclo em loop, linha de baixo = detonação ou quebra uma vez, recomposta depois em 2048×256.

## Piloto primeiro

Gerar **M01, P02 e G03** antes das demais. Cobrem as três linguagens do lote: efeito curto tingido (`M01`), efeito sobre o herói (`P02`) e telégrafo de chão com loop e detonação (`G03`, o mais difícil). Se estilo, tamanho e legibilidade passarem (a 24–48 px nos itens, 96–160 px nos chefes e também sobre fundo claro), liberar as outras 19 com o mesmo bloco de estilo.

O piloto do Lote 1 (F03, F06, F13) segue pendente de imagens e independe deste.

## Fila

| ID | Nome | Quadros | Final | Fundo | Ciclo | Obs. |
|---|---|---|---|---|---|---|
| G01 | `boss_varredura_aviso` | 6 quadros | 1536x256 | preto (aditivo) | loop |  |
| G02 | `boss_varredura_feixe` | 6 quadros | 1536x256 | preto (aditivo) | loop |  |
| G03 | `boss_quadrante_runas` | 4 + 4 quadros | 2048x256 | preto (aditivo) | 4 loop + 4 uma vez | **piloto** |
| G04 | `boss_marca_alvo` | 4 + 4 quadros | 2048x256 | preto (aditivo) | 4 loop + 4 uma vez |  |
| G05 | `boss_conjuracao_carga` | 6 quadros | 1536x256 | preto (aditivo) | loop |  |
| G06 | `boss_conjuracao_estouro` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| G07 | `boss_conjuracao_interrompida` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| G08 | `boss_escudo` | 4 + 4 quadros | 2048x256 | preto (aditivo) | 4 loop + 4 uma vez |  |
| G09 | `boss_fase_estouro` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| M01 | `morte_poeira` | 6 quadros | 1536x256 | preto (aditivo) | uma vez | **piloto** |
| M02 | `morte_alma` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| M03 | `morte_elite_estouro` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| M04 | `morte_chefe_colapso` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| M05 | `morte_detritos` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| M06 | `morte_explosivo` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| P01 | `xp_brilho` | 6 quadros | 1536x256 | preto (aditivo) | loop |  |
| P02 | `xp_coleta` | 6 quadros | 1536x256 | preto (aditivo) | uma vez | **piloto** |
| P03 | `moeda_coleta` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| P04 | `pocao_coleta` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| P05 | `ima_pulso` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| P06 | `subida_de_nivel_v2` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| P07 | `mare_aura` | 6 quadros | 1536x256 | preto (aditivo) | loop |  |

Destinos finais em `assets/vfx/<nome>.png`. Consumers por item estão em `queue.json` (`core/boss_mechanics.gd`, `core/death_vfx.gd` e `core/pickup_vfx.gd` novos, e `ui/run.gd`).

## Notas por grupo

- **Chefes (G01–G09):** paleta hostil (âmbar, carmim, laranja) para perigo; azul-ciano só no que premia o jogador (`G07`, interrupção) e na cúpula neutra (`G08`). `G03` e `G04` são círculos **vistos de cima, sem perspectiva**: o código os achata no chão isométrico e recorta o `G03` em fatias, então o desenho não pode distinguir um quadrante do outro. `G01` e `G02` têm miolo uniforme para o código esticá-los ao comprimento da varredura. O contorno de perigo atual permanece sempre por baixo (decisão 3 da proposta, ainda a confirmar).
- **Morte (M01–M06):** `M01` é branco-quente neutro, para o código tingir pela cor do inimigo; os demais têm paleta própria (alma azul-esverdeada, elite e chefe dourados, detritos em tons de madeira, explosivo laranja). O efeito mais visto do jogo é `M01`: curto e discreto.
- **Coleta e progressão (P01–P07):** cada coleta tem a cor do item (XP azul, ouro dourado, poção verde com um toque de vermelho, ímã dourado com borda azul-magnética). `P06` substitui a subida de nível atual (4 quadros) por uma mais rica; a antiga fica de fallback. `P07` precisa ser sutil: fica vários segundos na tela.

## Fora deste lote

Totens de chefe, projéteis de chefe (já são a F10 do Lote 1), arte de abertura de chefe, tiras de morte por inimigo (já existem para 60 dos 61) e zonas de tentáculo.
