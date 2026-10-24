# Proposta — VFX e "dopamina", Lote 2: chefes, morte de inimigos, coleta e XP (2026-10-23, r1)

Status: **DRAFT, escopo aprovado em 2026-10-23** (22 folhas, piloto M01, P02 e G03; seção `vfx_lote2_2026_10_23` no `plan.yaml`, fila `ASSET-QUEUE-VFX-LOTE2-20261023-r1.md`). Decisões 3 a 5 da seção 8 seguem em aberto. Nada foi gerado, integrado, commitado ou publicado. Continua `PROPOSTA-vfx-lote1-20261023-r1.md` (cera, projéteis inimigos, golpes, faíscas de acerto), que segue no piloto F03/F06/F13. Geração manual no ChatGPT, mesmo fluxo e mesmos contratos de folha do Lote 1; numeração da série **G** (chefes), **M** (morte) e **P** (coleta), para não colidir com as séries A–F.

## 1. Problema (evidência no código)

| Ponto | Hoje | Onde |
|---|---|---|
| Telégrafos e ataques de chefe | tudo desenhado com linhas e polígonos chapados, igual para todos os chefes: varredura = linha de 3 px que vira 7 px; quadrantes = fatia vermelha translúcida; marca = anel com contagem; conjuração = barra de 68×8 px; imunidade e armadura = um arco; totem = linha e círculo | `core/boss_mechanics.gd` `draw_fx`; telégrafo comum em `ui/overlay.gd` `_draw_telegraph` |
| Troca de fase e enrage | só um toast de texto (`announcement`) e o enrage muda velocidade; sem estouro visual | `data/boss_phases.json`, `ui/run.gd` |
| Morte comum | 5 faíscas da cor do inimigo e o quadro de morte da tira | `ui/run.gd` `_kill_burst`, `ui/enemy_view.gd` `play_death` |
| Morte de elite | anel dourado de 1,2, 10 faíscas e hit-stop de 0,05 s | idem |
| Morte de chefe | anel de 2,4, 16 faíscas, som de explosão grave e hit-stop de 0,12 s; sem clímax visual | idem |
| Itens de coleta | quatro PNGs estáticos de 64 px desenhados a 22–32 px, sem brilho nem animação; o ímã só pulsa um disco | `ui/overlay.gd` (laço `battle.pickups`), `assets/pickups/` |
| Coleta | som com tom crescente na sequência (bom), faíscas só para ouro, pulso na barra de XP; sem absorção visual nem rastro | `ui/run.gd` `_pickup_feedback` |
| Subir de nível | folha 2×2 de 4 quadros, 1,8 s | `ui/run.gd` evento `levelup`, `assets/vfx/vfx_subida_de_nivel.png` |
| Maré (sequência de abates) | só toast e som | `ui/run.gd` evento `streak` |

O que **não** falta: as tiras de morte já existem para 60 dos 61 inimigos (`assets/animations/enemies/*/death.png`; só `totem_de_chefe` não tem), a arte de abertura de chefe existe (`assets/ui/boss-intros`), e as mecânicas de chefe (L5) já estão implementadas. O buraco é a **camada de efeito** por cima: poeira, alma, clímax, brilho, absorção.

## 2. Escopo proposto: 22 folhas em três grupos

Formatos iguais aos do Lote 1: **6 quadros, 1536×256** (uma vez ou loop, pivô no centro) e **8 quadros, 2048×256** (4 de voo/loop + 4 de impacto). Aditivas sobre preto, exceto onde indicado. Margem mínima de 8% por célula.

### Grupo G — Chefes (9)

| ID | Nome | Formato | Ciclo | Consumidor e efeito |
|---|---|---|---|---|
| G01 | `boss_varredura_aviso` | 6 quadros | loop | feixe de `sweep` em aviso: faixa de energia estreita e tremida, esticada ao longo do comprimento |
| G02 | `boss_varredura_feixe` | 6 quadros | loop | feixe de `sweep` ativo: coluna larga, núcleo branco, bordas serrilhadas |
| G03 | `boss_quadrante_runas` | 8 quadros | 4 loop + 4 detonação | `quadrants`: chão de runas pulsando e a detonação (a fatia é recortada por polígono com UV) |
| G04 | `boss_marca_alvo` | 8 quadros | 4 persegue + 4 trava/impacto | `mark`: retículo que gira e segue o herói, trava com estalo e explode |
| G05 | `boss_conjuracao_carga` | 6 quadros | loop | `cast`: aura crescendo no chefe durante o windup (substitui a barra como protagonista; a barra fica) |
| G06 | `boss_conjuracao_estouro` | 6 quadros | uma vez | liberação da conjuração (Sussurro, Grito Abissal, Beijo da Rainha) |
| G07 | `boss_conjuracao_interrompida` | 6 quadros | uma vez | o "Q interrompe" funcionou: vidro quebrando e fagulhas; é o prêmio de uma jogada hábil |
| G08 | `boss_escudo` | 8 quadros | 4 loop + 4 quebra | `immune_adds` e `armor`: cúpula (tingida azul ou prata) e a quebra ao cair |
| G09 | `boss_fase_estouro` | 6 quadros | uma vez | troca de fase a 70% e 35%: onda grande no chefe; o `enrage` ganha aura em loop tingida no código |

Fora do Lote 2, de propósito: o projétil de chefe (já é a F10), os totens (a linha e o arco de hoje funcionam e são legíveis; revisitar só se o playtest pedir), e arte nova de abertura.

### Grupo M — Morte de inimigos (6)

| ID | Nome | Formato | Ciclo | Consumidor e efeito |
|---|---|---|---|---|
| M01 | `morte_poeira` | 6 quadros | uma vez | abate comum: nuvem de poeira e fagulhas, tingida pela cor do inimigo; é o efeito mais visto do jogo, por isso o piloto |
| M02 | `morte_alma` | 6 quadros | uma vez | elite (afixo ou baú): fiapo de alma subindo e anel |
| M03 | `morte_elite_estouro` | 6 quadros | uma vez | elite: onda de choque curta com brilho dourado |
| M04 | `morte_chefe_colapso` | 6 quadros | uma vez | chefe: pilar de luz e explosão radial grande |
| M05 | `morte_detritos` | 6 quadros | uma vez | objetos quebráveis (caixote, carroça, arbusto, candelabro, casulo): lascas e poeira |
| M06 | `morte_explosivo` | 6 quadros | uma vez | afixo "explosivo" (`_affix_explode`): hoje só um anel; vira bola de impacto |

### Grupo P — Coleta, XP e progressão (7)

| ID | Nome | Formato | Ciclo | Consumidor e efeito |
|---|---|---|---|---|
| P01 | `xp_brilho` | 6 quadros | loop | cintilar do cristal de XP parado no chão (some a sensação de sprite estático) |
| P02 | `xp_coleta` | 6 quadros | uma vez | absorção no herói: espiral e flash; o tom sobe com a sequência (já existe no som) |
| P03 | `moeda_coleta` | 6 quadros | uma vez | brilho dourado e faíscas ao coletar ouro, no lugar do disco de faíscas atual |
| P04 | `pocao_coleta` | 6 quadros | uma vez | cura: símbolos subindo ao redor do herói |
| P05 | `ima_pulso` | 6 quadros | uma vez | ímã: onda de atração que puxa todos os itens, com os itens ganhando rastro no código |
| P06 | `subida_de_nivel_v2` | 6 quadros | uma vez | substitui a folha 2×2 de 4 quadros: pilar de luz, anel e raios (mantém a atual como fallback) |
| P07 | `mare_aura` | 6 quadros | loop | aura no herói enquanto a Maré dá bônus de XP; some ao zerar a sequência |

Código sem folha nova, no mesmo lote: flash curto de tela e câmera lenta de 0,5 s na morte de chefe (hoje só `_hit_stop(0.12)`), brilho da barra de XP ao encher, e contador de "Maré" pulsando.

## 3. Prioridade e ordem

Ordem por **frequência × ganho de dopamina**, não por ordem de grupo:

1. **P (coleta/XP)** e **M (morte)**: acontecem dezenas de vezes por minuto; um bom `M01` e `P02` mudam a sensação de cada run.
2. **G (chefes)**: pouco frequentes, mas são o clímax e o que mais deve ser legível; entra com piloto próprio e playtest de leitura.

Sugestão de **piloto de três** (uma folha por grupo, as três linguagens do lote): `M01 morte_poeira` (efeito curto tingido), `P02 xp_coleta` (efeito sobre o herói) e `G03 boss_quadrante_runas` (telégrafo com loop e detonação, o mais difícil de acertar).

## 4. Código

Só apresentação: posição, dano, colisão, RNG e hitbox de telégrafo **continuam no `Battle` e no `BossMechanics`**; a arte nunca define o que acerta.

1. **`core/death_vfx.gd` novo:** `kind_for(enemy)` → comum, elite, chefe, quebrável ou explosivo; `create_effect`; chamado em `_kill_burst` (`ui/run.gd`). Tinta por `enemy.color`, escala por `enemy.scale`, limite de efeitos vivos (~12) e sem efeito em "Reduzir efeitos de impacto", que mantém as faíscas de hoje.
2. **`core/pickup_vfx.gd` novo:** brilho em loop para XP e ímã desenhado no laço de `ui/overlay.gd` (poucos nós, ou desenho direto com textura atlas); efeito de coleta disparado em `_pickup_feedback`. Limite de brilhos simultâneos (os pickups já têm teto `MAX_PICKUPS`).
3. **`core/boss_mechanics.gd` `draw_fx`:** cada verbo usa a folha quando existe e cai no desenho atual quando não existe ou com impacto reduzido. Fatia dos quadrantes por `draw_polygon` com UV; feixe da varredura esticado em x. **A forma de contorno atual (linha/polígono vermelho) permanece sempre visível por baixo**, para a leitura de perigo não depender da arte.
4. **`ui/run.gd`:** evento de troca de fase (hoje só `announcement`) toca `G09`; `levelup` usa `P06`; novo estado `streak` liga `P07` no herói; câmera lenta e flash de chefe.
5. **Carregador:** reaproveita o padrão de atlas dos Lote 1 (`ProjectileVfx`, `MeleeVfx`); portanto **o código do Lote 2 vem depois do código do Lote 1**, que já cria o carregador compartilhado.

Sem mudança em dados de armas, balanceamento, saves, IDs ou nas tiras de morte existentes.

## 5. Preparação técnica

Mesmo `tools/asset_prep.gd` e jobs JSON do Lote 1 (`tools/asset_jobs/vfx_lote2_v01.json`): chave preta, recorte por grade, normalização para células de 256 px, galeria de revisão sobre fundo escuro e **sobre fundo claro** (os efeitos são aditivos e precisam ser lidos nos mapas claros). Sem pacote novo. Um passo novo pode ser necessário para o feixe (G01, G02): validar que a faixa estica sem emendar ruim.

## 6. Testes

Pelo runner existente (`tools/run_one_test.gd`), com diretório de dados sintético; nunca o save real.

- **`test_death_vfx.gd`:** `kind_for` cobre comum, elite, chefe, quebrável e explosivo a partir dos dados; limite de vivos; impacto reduzido não cria sprite; folhas 1536×256 com seis células não vazias e margem de 8%; RNG do `Battle` intocado.
- **`test_pickup_vfx.gd`:** todo `kind` de pickup (`xp`, `gold`, `potion`, `magnet`) mapeia efeito; sem estouro do limite; fallback quando a folha falta.
- **`test_boss_vfx.gd`:** cada verbo de `data/boss_mechanics.json` (`sweep`, `quad`, `mark`, `cast`, `immune_adds`, `armor`, fase) tem folha ou fallback; o contorno de perigo continua desenhado com a folha presente; a geometria do telégrafo no `BossMechanics` não muda (hitbox).
- **Ajuste** em `test_l5_boss_mechanics.gd` só se o desenho em `draw_fx` for coberto por ele (a verificar na implementação).
- **Desempenho:** cenário de estresse no `tools/smoke.gd` com ~40 mortes e ~100 pickups em 10 s e um chefe em fase 2 com os quatro verbos, medindo o tempo de quadro (`core/frame_stats.gd`) antes e depois.
- **Suíte completa** (`tests/run_all.gd`), com as falhas e o timeout herdados confirmados como inalterados.

## 7. Passos e checkpoints

1. **Aprovação de escopo** (esta proposta); só então registrar a seção no `plan.yaml`.
2. **Gerar prompts e fila** (`ASSET-QUEUE-VFX-LOTE2-…`, `prompts/`), no mesmo formato do Lote 1.
3. **Piloto de três** (M01, P02, G03) no ChatGPT; revisão de estilo, tamanho e legibilidade (a 24–48 px nos itens e a 96–160 px nos chefes), também sobre fundo claro.
4. **Demais 19 folhas**, até três candidatas por peça; aceite visual do dono por ID/revisão/hash.
5. **Preparação** e galeria de revisão.
6. **Código e testes**, na ordem: coleta/XP (P), morte (M), chefes (G); só depois do código do Lote 1.
7. **Validação no jogo:** captura por cena, medição de desempenho e **playtest com chefe** para confirmar que o telégrafo continua legível; o aceite das fontes não prova diversão em jogo.

Sem commit, push, build ou publicação; cada um exige pedido do dono.

## 8. Decisões que preciso de você

1. Aprovar o escopo das 22 folhas, ou cortar: sugestão de corte mínimo = P02, P03, P06, M01, M02, M04, G03, G04, G06 (9 folhas), que cobrem o mais visto e o clímax do chefe.
2. Piloto de três (M01, P02, G03), ou trocar.
3. Aceitar que o contorno atual de perigo dos telégrafos de chefe **fica sempre por baixo** da arte (recomendado, por legibilidade e acessibilidade), ainda que isso reduza a liberdade visual.
4. Aprovar câmera lenta de 0,5 s e flash curto na morte de chefe (código, sem arte); respeitam "Reduzir efeitos de impacto".
5. Confirmar que o Lote 2 só entra em código **depois** do Lote 1 (carregador compartilhado) ou preferir inverter a ordem de prioridade (coleta e morte antes de cera e projéteis).

## 9. Riscos

- **Legibilidade do telégrafo de chefe:** mitigada pelo contorno permanente e pelo teste de hitbox; validar em playtest com a arte aditiva sobre chão claro.
- **Poluição visual:** morte e coleta acontecem em volume; mitigada por limites de efeitos vivos e por tamanho/opacidade moderados nos efeitos comuns, e por reservar o grande para elite e chefe.
- **O ChatGPT não garante pixels nem loops perfeitos:** piloto, três candidatas e normalização na preparação, como no Lote 1.
- **Feixe de varredura esticado:** pode emendar mal; mitigado por gerar G01/G02 com núcleo uniforme e validar o esticamento antes de liberar.
- **Escopo grande:** 22 folhas somadas às 17 do Lote 1; por isso a prioridade, o corte mínimo e o piloto de três.
