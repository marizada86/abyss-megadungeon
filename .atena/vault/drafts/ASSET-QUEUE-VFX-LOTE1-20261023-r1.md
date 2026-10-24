# Fila de arte — VFX e "dopamina", Lote 1 (2026-10-23, r1)

Status: DRAFT. **17 fontes aprovadas pelo dono e 17 atlas integrados/validados tecnicamente**, em 2026-10-23. F03 v02 e demais IDs v01; F03 v01 retida. Aceite por ID/revisão/hash em batch-acceptance.json. [Galeria de integração](../../generated/vfx-lote1-20261023-r1/integration-review.html), admission.json e integration-evidence.md no mesmo diretório. Revisão humana em jogo pendente; não repetir aceite das fontes.

## Protocolo de geração

Geração executada pela Atena via imagegen, uma imagem por prompt, por autorização explícita do dono. Protocolo manual abaixo preservado como instrução de referência; estado atual em queue.json e batch-generation.md. Arquivos em `.atena/generated/vfx-lote1-20261023-r1/`:

- `prompts/Fxx_<nome>_prompt.txt`: prompt completo e autossuficiente (estilo, fundo, grade, descrição). Colar inteiro.
- `ref-existing-vfx.png`: prancha com oito efeitos já aceitos (orbes, onda cortante, três golpes, pulso, habilidade), sobre fundo escuro. **Anexar em toda geração** como referência de acabamento. Não é para copiar as formas.
- `queue.json`: manifesto com estado, nome de arquivo esperado, grade, fundo, tamanho final e consumer de cada item.

Ao receber a imagem, salvar nesta pasta com o nome `expected_file` do manifesto (`F01_cera_fervente_lancamento_v01.png` e assim por diante). Correção objetiva: até três candidatas por peça (`_v02`, `_v03`); depois, bloqueio para decisão. O aceite visual é do dono, por ID/revisão/hash, como nos lotes anteriores.

Regras de fundo (já refletidas nos prompts):

- **Preto puro #000000, aditivo:** 16 das 17 folhas. O preto vira transparente; sem contorno escuro dentro do efeito.
- **Magenta #FF00FF, chave:** só `F02` (corpo opaco da poça de cera), sem rosa nem magenta no objeto.

Grade de geração: tela 1536×1024. Folhas de 6 quadros: uma fileira de seis células de 256 px (recorte posterior para 1536×256). Folhas de 8 quadros: grade 4×2 de células de 384 px (linha de cima = voo, linha de baixo = impacto), recomposta depois em 2048×256. O ChatGPT nem sempre obedece pixels exatos; a preparação técnica recorta e normaliza, e a revisão confere centro, margem de 8% e quadros vazios.

## Piloto primeiro

Gerar **F03, F06 e F13** antes das demais. Cobrem as três linguagens do lote (chama de zona em loop, projétil com voo e impacto, faísca curta de acerto). Se o estilo, o tamanho e a legibilidade passarem na revisão, liberar as outras 14 com o mesmo bloco de estilo. Se não passarem, ajustar o bloco de estilo uma vez em vez de corrigir 17 peças.

## Fila

| ID | Nome | Quadros | Final | Fundo | Ciclo | Obs. |
|---|---|---|---|---|---|---|
| F01 | `cera_fervente_lancamento` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| F02 | `cera_poca_corpo` | 6 quadros | 1536x256 | magenta (chave) | loop |  |
| F03 | `cera_poca_chama` | 6 quadros | 1536x256 | preto (aditivo) | loop | **piloto** |
| F04 | `inferno_de_cera_lancamento` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| F05 | `inferno_de_cera_chama` | 6 quadros | 1536x256 | preto (aditivo) | loop |  |
| F06 | `inimigo_flecha` | 4 voo + 4 impacto | 2048x256 | preto (aditivo) | loop | **piloto** |
| F07 | `inimigo_esporo` | 4 voo + 4 impacto | 2048x256 | preto (aditivo) | loop |  |
| F08 | `inimigo_orbe_abissal` | 4 voo + 4 impacto | 2048x256 | preto (aditivo) | loop |  |
| F09 | `inimigo_orbe_infernal` | 4 voo + 4 impacto | 2048x256 | preto (aditivo) | loop |  |
| F10 | `bala_de_chefe` | 4 voo + 4 impacto | 2048x256 | preto (aditivo) | loop |  |
| F11 | `melee_radiante_arco` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| F12 | `melee_fogo_arco` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| F13 | `hit_fisico` | 6 quadros | 1536x256 | preto (aditivo) | uma vez | **piloto** |
| F14 | `hit_magico` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| F15 | `hit_fogo` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| F16 | `hit_radiante` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |
| F17 | `hit_critico` | 6 quadros | 1536x256 | preto (aditivo) | uma vez |  |

Destinos finais em `assets/vfx/<nome>.png` (mesmo nome da coluna Nome). Consumers por item estão em `queue.json`.

## Notas por grupo

- **Cera (F01–F05):** a poça é montada em duas camadas, corpo (F02, normal) e chamas (F03/F05, aditivo). O corpo é neutro (bege) de propósito: o jogo o tinge de âmbar para a Cera Fervente e de carmim para o Inferno de Cera, então a evolução só precisa de lançamento e chamas próprios.
- **Projéteis inimigos (F06–F10):** paleta hostil (carmesim, verde-tóxico, violeta, vermelho-sangue) para nunca se confundir com os projéteis do herói (branco e dourado). Cada um precisa ler a ~36–40 px. A bala de chefe (F10) é neutra de propósito: o código a tinge por chefe.
- **Golpes (F11–F12):** seguem a convenção de orientação e âncora das folhas físicas existentes (anexadas na referência). A escala fina é calibrada na integração, não no prompt.
- **Faíscas (F13–F17):** efeito de ~150 px dentro de células de 256 px (crítico ~220 px); o jogo as reduz para ~56 px, então precisam ser nítidas e rápidas.

## Decisões registradas

- F12 é consumida pelo `FireSwingVfx` (o `MeleeVfx` não captura fogo); F11 pelo `MeleeVfx`, por ID de arma.
- F10 é tingida pela cor do inimigo, clareada até um brilho mínimo.
- F02 é avaliada tingida (âmbar e carmim) quando chegar; plano B **F02b**, corpo carmim do Inferno de Cera, só se o tingimento ficar barrento. Não gerar F02b sem essa avaliação.

## Fora deste lote

Chefes (varredura, quadrante, marca, totem, detonação, morte), variantes de evolução, estouro de abate e zonas de tentáculo ficam nos Lotes 2 e 3.
