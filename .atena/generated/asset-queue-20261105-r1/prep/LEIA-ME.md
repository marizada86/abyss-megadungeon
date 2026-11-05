# Preparação dos avisos dos comuns (T20, T21, T22), 2026-11-05

Status: **DRAFT**. Preparação feita em 2026-11-05. **Atualização, mesma data:** o dono aceitou os defaults e autorizou a integração, que foi aplicada localmente (ver a seção "Integração aplicada" no fim). Aceite de fonte não é aceite de integração em jogo. Sem commit, push ou build.

Autorização: dono, 2026-11-05 ("pode seguir o próximo passo na sequência proposta ... pode ter um escopo grande"). A seção `telegraph_comuns_prompts_20261105` do plano mantém `runtime_integration` como não autorizada, então a integração abaixo é só proposta.

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `aviso_comum_faixa.png` | T20, faixa de investida: 6 quadros, 1536×256 |
| `aviso_comum_mira.png` | T21, mira do atirador: 6 quadros, 1536×256 |
| `aviso_comum_area.png` | T22, círculo de golpe em área: 4 quadros, 1024×256 |
| `*.report.json` | medições de cada folha (margens, laço, pulso, fatias, âncoras de origem) |
| `previa_*.png` | cada folha tingida como o jogo fará, por tipo de dano e modos de daltonismo, sobre preto e sobre um trecho de chão (última linha) |

Ferramentas (novas, em `tools/`): `telegraph_prep_comuns.gd` (preparação e medição), `telegraph_preview_comuns.gd` (prévias) e o job `asset_jobs/telegraph_comum_v01.json`. Rodadas num projeto Godot sintético com `--root <raiz>`, sem autoload nem save real; ver o cabeçalho de cada script.

## O que a preparação fez

1. **Segmentou por conteúdo.** O canvas real de T20 e T21 é 2172×724; os 6 quadros saem exatos (limiar de alfa 60 e vão mínimo de 8 px). T22 tem 3 faíscas soltas entre os anéis, ignoradas na segmentação.
2. **Neutralizou a cor.** O pixel vira branco e o brilho fica no alfa. Antes a luz era âmbar saturada (por exemplo T22: 188/137/62); multiplicada por violeta dava marrom-rosado. Verificado: canal mínimo de todo pixel visível = 255 nas três folhas, e as prévias mostram violeta, azul e verde (modos de daltonismo) limpos.
3. **Uma escala por folha** e centro medido por quadro (corpo no T20 e T21, anel no T22). Escalas: T20 0,5768, T21 0,6235 (limitada pela margem; pedida 0,6376), T22 0,6291 (limitada; pedida 0,7273).
4. **Desvaneceu o halo do T22** além do anel (de 8 a 32 px), removendo as faíscas soltas sem deixar borda nítida (a primeira versão, com corte duro, deixou um disco escuro em volta do anel do quadro de pico).

## Resultado medido

| | T20 faixa | T21 mira | T22 área |
|---|---|---|---|
| Tamanho | 1536×256 | 1536×256 | 1024×256 |
| Borda de cada célula com alfa 0 | sim | sim | sim |
| Margem mínima ao conteúdo | 25 px | 25 px | 25 px |
| Cor neutra (canal mínimo visível) | 255 | 255 | 255 |
| Centro dos quadros | altura do corpo 127 a 128,5 | 127,5 a 128,5 | anel em (128±1, 127,5 a 132) |
| Laço (último para o primeiro / média entre vizinhos) | 0,75 | 0,28 | 0,74 |
| Brilho min/max entre quadros | 0,60 | 0,63 | 0,37 |
| Quadro sugerido para "Impacto reduzido" (energia mais próxima da média) | quadro 3 | quadro 2 | quadro 2 |
| Fatias da barra: esquerda / miolo / direita | 28% / 41% / 31% | 33% / 39% / 28% | não se aplica |
| Altura visível do miolo na célula | 58 a 68 px | 28 a 36 px | raio do anel 80 a 88 px |
| Uniformidade do miolo (variação entre colunas) | 5,8 a 8,3% | 3,1 a 6,1% | não se aplica |

Observações:
- T20 e T21 cabem nas fatias de `BossVfx.BEAM` (tampa esquerda 24–80, miolo 80–176, tampa direita 176–232): nenhuma energia fora delas e o miolo é uniforme, então estica sem repetir arranhões ou a mira.
- O quadro 1 e o 6 do T20 são bem mais fracos que o 4 (pulso). Foi mantido como veio; decisão pendente (abaixo).
- As marcas do T22 (3 por quadro) giram, mas o passo de rotação não foi medido com segurança; só animação em jogo confirma.

## Decisões que ficam com o dono (defaults propostos, reversíveis)

1. **Neutralização total** (`neutralize` = 1,0 no job). Alternativa: manter um pouco de âmbar (valor menor) e aceitar tingimento mais fraco em violeta e azul.
2. **Pulso de brilho:** manter (0,37 a 0,63) como sinal de urgência, ou equalizar como nos voos de VFX (a equalização não foi aplicada aqui).
3. **Quadro de "Impacto reduzido":** os sugeridos acima.
4. **Raio do anel e tamanho do corpo:** T22 raio 80 a 88 px em célula de 256; T20 corpo de 184 px (como o aviso de chefe); T21 corpo de 195 px (como o feixe de chefe).

## Plano de integração proposto (não aplicado)

1. **Entrega:** copiar para `assets/vfx/` como `aviso_comum_faixa.png`, `aviso_comum_mira.png`, `aviso_comum_area.png`. Importar com `--headless --editor --import` em perfil isolado (como `tools/playtest_maps.ps1`) para gerar os `.import`, com os mesmos parâmetros das folhas de VFX aceitas, e versionar os `.import`.
2. **Mistura aditiva.** `ui/overlay.gd` desenha em mistura normal e não troca de material por desenho. Para a luz aditiva, desenhar as folhas num nó filho com `CanvasItemMaterial` aditivo (como `BossVfx._additive()`), ou aceitar mistura normal com `modulate`, mais opaca e menos luminosa.
3. **Tingimento:** `modulate = _warn(dtype).main` no corpo da folha (já respeita o modo de daltonismo), com o alfa subindo com o progresso; os realces `warn.hot` (linha de frente, setas, pontas) continuam desenhados em código.
4. **Mira (`_draw_aim_beam`):** fatiar em três pedaços como `BossVfx.BeamNode`, com `k` de espessura ≈ 0,5 (altura visível ≈ 15 px, mira de ≈ 20 px, perto dos 22 px de hoje) e o comprimento do raio no miolo. Manter a mira que fecha (escala da tampa direita).
5. **Faixa (`_draw_charge_lane`):** projetar as três fatias no chão (paralelogramo isométrico), com a meia largura do jogo (`raio + 0,35`) definindo a altura; o preenchimento até `progress` e a linha de frente seguem no código.
6. **Área (`_draw_telegraph`):** escalar o anel (raio de arte ≈ 84 px) à elipse do golpe (`z.radius`, raio de 1,3 a 2,0 tiles) por `draw_set_transform`; 4 quadros em laço; o preenchimento e as marcas `warn.hot` seguem no código.
7. **Fallback:** cada função usa a folha só se `ResourceLoader.exists(...)` (já existe um cache de texturas em `overlay.gd`) e cai no desenho atual se faltar o arquivo, como as peles de chefe.
8. **"Impacto reduzido":** congelar no quadro sugerido, sem animar.
9. **Testes** (perfil sintético): `tests/test_telegraph_comuns_art.gd` com presença, tamanhos (1536×256, 1536×256, 1024×256), borda com alfa 0, margem ≥ 22 px, cor neutra, fallback sem arquivo, tingimento por tipo de dano e por modo de daltonismo, e quadro congelado em "Impacto reduzido". Mesmo estilo dos testes de margem de `tests/test_weapon_evolution_vfx.gd`.
10. **Portagem:** alteração comum; `AGENTS.md` exige portagem registrada para a outra versão. Não avaliada.

## Integração aplicada (2026-11-05, após "aceito os defaults")

Defaults aceitos: neutralização total, pulso mantido, quadros congelados 3 (faixa), 2 (mira) e 2 (área), tamanhos como preparados.

- **Assets:** as três folhas em `assets/vfx/` (`aviso_comum_faixa.png`, `aviso_comum_mira.png`, `aviso_comum_area.png`) com `.import` de parâmetros idênticos aos das folhas de chefe.
- **Código:** `ui/telegraph_art.gd` (novo: nó aditivo com funções puras e fila de comandos) e `ui/overlay.gd` (`_draw`, `_telegraph_art`, `_draw_lane_art`, `_draw_charge_lane`, `_draw_aim_beam`, `_draw_telegraph`). Sem a folha, cada aviso cai no desenho por código de antes.
- **Camadas:** faixa e anel no chão (sob os personagens); mira na frente, para o alvo aparecer sobre o herói. Progresso, frente, setas e fim da faixa seguem por código.
- **Teste:** `tests/test_telegraph_comuns_art.gd`. Suíte completa em perfil sintético: 0 falhas; `tools/audit_projeto.gd`: 0 erros e 0 avisos.
- **Captura em jogo** (`tools/telegraph_comuns_capture.gd`, 11 imagens em `integration/`): arte contra desenho antigo, por tipo de dano, protanopia, tritanopia e "Impacto reduzido". Violeta limpo; protanopia em azul.
- **Dois defeitos achados na captura e corrigidos:** a faixa aditiva por cima do herói o tingia de vermelho (movida para a camada de baixo) e a mira do alvo ficava fraca e atrás do herói (ponta direita reforçada, arte da mira na frente).

Pendente: portagem para a outra versão (`AGENTS.md`), conferência em partida real (marcas giratórias do T22, naturalidade do pulso), commit, push e build. Avisos de vazamento no encerramento da suíte apareceram em 2 de 4 rodadas completas com o teste novo (0 de 6 no teste sozinho; a última saiu limpa).
