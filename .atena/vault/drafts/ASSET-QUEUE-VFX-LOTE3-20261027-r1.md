# Fila de arte — VFX e "dopamina", Lote 3: evoluções, detonação, tentáculos e dano no herói (2026-10-27, r1)

Status: DRAFT. Escopo das 12 folhas **aprovado pelo dono em 2026-10-27** (`PROPOSTA-vfx-lote3-20261027-r1.md`), com **piloto E03, D01 e T02**. Prompts e fila prontos; **nenhuma imagem foi gerada** e nada foi integrado. Continua as séries dos lotes anteriores (`ASSET-QUEUE-VFX-LOTE1-…` e `…LOTE2-…`) com as séries **E** (evoluções), **D** (detonação), **T** (tentáculos) e **H** (herói).

## Como gerar (ChatGPT, manual)

Igual aos Lotes 1 e 2. Tudo está em `.atena/generated/vfx-lote3-20261027-r1/`:

- `COLAR-PILOTO-E03-D01-T02.md`: os três prompts do piloto, em blocos prontos para copiar. **Comece por aqui.**
- `COLAR-NO-CHATGPT-9-FOLHAS.md`: as outras 9, **retidas até o aceite do piloto**.
- `prompts/<ID>_<nome>_prompt.txt`: cada prompt completo, igual ao do bloco de colar.
- `ref-existing-vfx.png`: a mesma prancha dos lotes anteriores. **Anexar em toda geração**; é referência de acabamento. Nas evoluções (E01, E03, E04, E05, E06) o prompt indica a linha da prancha que é a **base** a ser evoluída.
- `queue.json`: manifesto com estado, nome de arquivo esperado, grade, âncora (centro ou base), ciclo e consumer.

Ao receber a imagem, salvar nesta pasta com o `expected_file` do manifesto (`E03_orbe_radiante_evo_v01.png` e assim por diante). Até três candidatas por peça (`_v02`, `_v03`); depois, bloqueio para decisão. O aceite visual é do dono, por ID/revisão/hash.

Todas as 12 são **aditivas** (preto puro #000000 vira transparente). Grade de geração 1536×1024: folhas de 6 quadros em uma fileira de células de 256 px; folhas de 8 quadros (E03, E04, E05) em grade 4×2 de células de 384 px (linha de cima = voo em laço, linha de baixo = impacto uma vez), recompostas em 2048×256.

## Piloto primeiro

Gerar **E03, D01 e T02** antes das demais. Cobrem as três linguagens do lote: projétil evoluído com voo e impacto (`E03`), detonação curta no chão (`D01`, a mais frequente) e zona em laço sem emenda ruim (`T02`, a mais difícil). Se estilo, tamanho e legibilidade passarem (a 36–56 px nos projéteis e no dano, ~110 px de raio nas detonações, também sobre fundo claro), liberar as outras 9 com o mesmo bloco de estilo.

## Fila

| ID | Nome | Quadros | Final | Âncora | Ciclo | Obs. |
|---|---|---|---|---|---|---|
| E01 | `melee_fisico_evo_arco` | 6 quadros | 1536x256 | centro | uma vez |  |
| E02 | `melee_rajada_evo` | 6 quadros | 1536x256 | centro | uma vez |  |
| E03 | `orbe_radiante_evo` | 4 voo + 4 impacto | 2048x256 | centro | 4 laço + 4 uma vez | **piloto** |
| E04 | `orbe_arcano_evo` | 4 voo + 4 impacto | 2048x256 | centro | 4 laço + 4 uma vez |  |
| E05 | `onda_cortante_evo` | 4 voo + 4 impacto | 2048x256 | centro | 4 laço + 4 uma vez |  |
| E06 | `pulso_evo` | 6 quadros | 1536x256 | centro | uma vez |  |
| E07 | `explosao_fogo` | 6 quadros | 1536x256 | centro | uma vez |  |
| D01 | `detonacao_fisica` | 6 quadros | 1536x256 | centro | uma vez | **piloto** |
| D02 | `detonacao_magica` | 6 quadros | 1536x256 | centro | uma vez |  |
| T01 | `tentaculos_emergem` | 6 quadros | 1536x256 | base | uma vez |  |
| T02 | `tentaculos_laco` | 6 quadros | 1536x256 | base | laço | **piloto** |
| H01 | `dano_heroi` | 6 quadros | 1536x256 | centro | uma vez |  |

Destinos finais em `assets/vfx/<nome>.png`. Consumers por item estão em `queue.json`.

## Notas por grupo

- **Evoluções (E01–E07):** devem parecer da mesma família da base, só que mais densas, mais ornamentadas e de outra cor, para que o jogador veja que evoluiu. As bases não mudam. E04 e E06 são neutras de propósito: o código as tinge por arma (Domínio Coletivo mais rosado; Chuva de Estrelas, Julgamento e Constelação em tons próprios). E07 serve à Bola de Fogo (pequena) e à Tormenta de Fogo (grande, mais escura por tinta).
- **Detonações (D01, D02):** a elipse do chão tem proporção 2:1 e o código a recorta ao **raio exato do telégrafo**, para a arte nunca passar do que acerta. O contorno de perigo continua por baixo.
- **Tentáculos (T01, T02):** vistos em 3/4, âncora na base (o chão fica em torno de y=172 da célula). T01 termina na mesma pose em pé com que T02 começa, para a transição não saltar. Sem olhos nem rostos.
- **Dano no herói (H01):** curto e discreto: acontece a cada golpe recebido, então não pode cobrir o herói.

## Fora deste lote

Estouro de morte de elite além da M03, zonas de outros itens além do Colar dos Tentáculos, variantes de evolução das armas de projétil de heróis sem evolução e o brilho de cura além da P04.
