# Auditoria de ritmo — duração dos mapas, ampulheta e aleatoriedade (2026-10-29, r1)

Status: DRAFT, proposta para decisão do dono. Nenhuma alteração de código ou dados foi feita. Origem: pedido do dono após o playtest do Vitão (mapas longos ficam monótonos do 6º/7º em diante; a ampulheta não apareceu; dúvida sobre a aleatoriedade dos spawns).

Base: `data/stages.json`, `data/chapter_flow.json`, `data/stage_events.json`, `data/difficulty.json`, `core/battle.gd` (ondas, interativos, ampulheta, chefe), `core/happenings.gd`, `core/enemy.gd`. As contas de probabilidade abaixo vêm de uma simulação minha sobre as regras do código (20 000 campanhas); **não há telemetria real do playtest** neste repositório. O que foi medido está marcado como "medido"; o que é inferência está marcado como tal.

## 1. Diagnóstico

### 1.1 Duração e ordem da campanha (medido nos dados)

| # | Mapa | Duração | Eventos fixos + opcionais (média) | Eventos por minuto |
|---|---|---|---|---|
| 1 | Docas | 180 s | 3 | 1,00 |
| 2 | Reino Abissal | 180 s | 2 | 0,67 |
| 3 | Domwieck | 180 s | 2 | 0,67 |
| 4 | Dagruve | 300 s | 2 | 0,40 |
| 5 | Shedaklah | 540 s | 2 fixos + 0 a 1 de 2 opcionais = 2,5 | 0,28 |
| 6 | Molor | 570 s | 1 fixo + 0 a 1 de 2 opcionais = 1,5 | 0,16 |
| 7 | Durão | 600 s | 3 fixos + 0 a 1 de 1 opcional = 3,5 | 0,35 |
| 8 | Feng-tu | 600 s | 2 fixos + 0 a 1 de 2 opcionais = 2,5 | 0,25 |
| 9 | Shendilavri | 630 s | 2 fixos + 0 a 1 de 1 opcional = 2,5 | 0,24 |
| 10 | Goranthis | 660 s | 1 fixo + 0 a 1 de 2 opcionais = 1,5 | 0,14 |
| 11 | Pilares | 300 s (sem fim; o relógio volta a zero a cada chefe) | 3 | 0,60 |

Tempo total de mapa até Pilares: 4 740 s (cerca de 79 min). Os três primeiros têm 1 evento por minuto ou perto disso; Molor e Goranthis têm 0,14 a 0,16, ou seja, **de 6 a 7 vezes menos coisa acontecendo por minuto**, num mapa 3 a 3,7 vezes mais longo. Isso confirma a impressão do Vitão com números.

Causa: `optional_min` é 0 em `data/difficulty.json` (`happenings`), então um mapa pode sortear nenhum acontecimento opcional, e os cronogramas de acontecimentos não foram densificados quando os mapas foram alongados.

### 1.2 Ondas: a lista de inimigos para de mudar muito antes do fim (medido)

Último inimigo novo que entra em cada mapa longo (`t0` da onda mais tardia) contra a duração:

- Shedaklah: 240 de 540 s. Durão: 300 de 600 s. Goranthis: 240 de 660 s.
- Em Goranthis, de 240 a 660 s (7 minutos) o elenco é exatamente o mesmo: 4 tipos, 3 elites em 180, 360 e 520 s.

Somado ao crescimento de PV dentro do mapa (`core/enemy.gd`: PV × (1 + 0,10 × minuto), bônus de ataque + minuto/4), o mapa longo vira "os mesmos inimigos, só mais encorpados".

### 1.3 Ampulheta (medido e simulado)

- Peso 1 de 19,2 na tabela de interativos de **todas** as fases: 5,2 % por sorteio. Não há peso próprio para fases longas.
- Cadência (`data/difficulty.json`): primeiro interativo fixo em 45 s (sempre baú), depois a cada 80 a 115 s. Um mapa de 600 s tem cerca de 5 sorteios aleatórios; um de 180 s tem 1.
- Chance de aparecer pelo menos uma ampulheta em um mapa (simulação, limite superior, ignora o teto de 3 vivos): 5 % nos mapas de 180 s, 10 % em 300 s, **23 a 27 % nos mapas longos**. Na campanha inteira: 87 %; do 6º mapa em diante: 78 %.
- Portanto, "não apareceu nenhuma vez" no playtest do Vitão é o resultado esperado (cerca de 3 em 4 mapas longos não têm ampulheta), não um defeito de sorteio.
- Mesmo quando aparece, o efeito é pequeno: `skip_seconds = 60`, ou seja, 10 % de um mapa de 600 s, e os spawns acumulados chegam de uma vez (até 18 inimigos). A ampulheta recusa-se a funcionar depois que o chefe chega ou nos últimos 5 s antes dele.

### 1.4 Aleatoriedade dos spawns (medido no código, efeito inferido)

1. **Sorteio puro e independente** em `_spawn_random_interaction`: cada interativo é uma rolagem com reposição. Ferreiro, loja, arcanista e curandeiro têm 5,2 % cada. Chance de pelo menos um ferreiro em um mapa longo: 22 a 27 %; de pelo menos uma loja/ferreiro/arcanista/curandeiro: 66 a 74 %; nos mapas de 180 s: 21 %. Secas e repetições são normais.
2. **Descartes silenciosos**: com 3 interativos vivos (`max_alive`), ou perto de um interativo fixo, ou com Pedra do Eclipse já ativa, a função só retorna. A rolagem é perdida e o próximo sorteio só vem 80 a 115 s depois. Interativos não usados nunca expiram, então um jogador que ignora baús e altares trava o próprio fluxo de novidades.
3. **RNG compartilhada com o combate**: os interativos usam `rng` da Battle, a mesma consumida por dano, esquivas e inimigos. A ordem e o tipo dos interativos não são reproduzíveis por semente da fase. Os acontecimentos (`Happenings.select`) já usam fluxo próprio (semente da run + fase); os interativos não.
4. **Cadência não acompanha a duração**: 80 a 115 s vale para todos os mapas. Ao encurtar mapas, sem ajuste os de 300 s ficam com 2 a 3 sorteios e os de 180 s com 1.
5. **Acontecimentos opcionais**: 0 a 1 por mapa, com horário ± 10 % (`jitter`). A variação de 0 a 1 domina o ritmo dos mapas com poucos fixos (Molor, Goranthis).

### 1.5 Velocidade e tempo entre mapas (parcialmente medido)

- `Battle.can_speed_2x()` só libera 1,5x/2x depois de **vencer o mesmo mapa**. Todo mapa novo da campanha, justamente os mais longos, roda em 1x na primeira vez.
- Depois do chefe: três baús, portal e névoa pós-chefe; o tempo de saída é decidido pelo jogador. HQs de campanha são exibidas com a simulação pausada (`_present_hq`, awaited). Não medi o tempo real entre mapas; `RunRecord` já grava `boss_spawn`, `boss_dead`, `stage_reached` e `stage_cleared`, o que basta para medir isso (ver M0).
- O jogo avança pela duração do mapa: o chefe só chega em `time >= stage.duration`, e `can_speed_2x` e a ampulheta são as únicas formas de acelerar.

## 2. Recomendações

Ordem sugerida por impacto sobre a queixa e risco. Cada item é independente, exceto onde indicado.

### R1 — Encurtar os mapas 4 a 10 com cronogramas reescalados

O método já existe: o lote B da r2 de 20/10 reescalou os três primeiros mapas "por fator 180/duração original" (`t0`, `t1`, `at` de elites, eventos de fase, regras, level design). Repetir o mesmo procedimento por mapa. O fator `k` = nova duração / duração atual.

Três opções para decidir (os três primeiros mapas ficam em 180 s):

| Mapa | Atual | A (−18 %) | B (−29 %, recomendada) | C (−39 %) |
|---|---|---|---|---|
| Dagruve | 300 | 270 | 240 | 240 |
| Shedaklah | 540 | 420 | 330 | 300 |
| Molor | 570 | 450 | 360 | 300 |
| Durão | 600 | 450 | 390 | 300 |
| Feng-tu | 600 | 450 | 390 | 300 |
| Shendilavri | 630 | 480 | 420 | 300 |
| Goranthis | 660 | 510 | 420 | 300 |
| Pilares (ciclo) | 300 | 300 | 300 | 300 |
| Campanha | 79 min | 64,5 min | **56,5 min** | 48 min |

Recomendo **B**: rampa 180, 180, 180, 240, 330, 360, 390, 390, 420, 420, 300. Mantém a sensação de "mapas ficando maiores" sem passar de 7 minutos, e o fator ficou perto de 0,6 a 0,67 nos mapas que mais incomodam, perto do 0,5 a 0,6 já aplicado e validado no capítulo 1.

Pontos de cuidado ao reescalar (a conferir um a um, como no lote B anterior):
- `HORDE_AT = 0,45` e os cortes de 60 % da duração para retomada de ondas escalam sozinhos com `stage.duration`; `t0`, `t1`, `every`/`max` das ondas, elites, `stage_events`, `stage_rules` e `skip_seconds` de névoa **não** escalam e precisam de reescala manual.
- **Pressão do mapa**: PV dos inimigos cresce 10 % por minuto dentro do mapa. Com B, o fim de Goranthis passa de ×2,1 para ×1,7 e o herói tem menos XP e menos baús. Alavancas a testar nos bots: subir o crescimento por minuto em proporção a `1/k`, ou `hp_mult`/`xp_mult` do mapa, ou o teto de inimigos (`cap`). Não há dado para escolher agora.
- Chefes nascem com minuto zero (sem o crescimento acima), então o chefe não encolhe com o mapa; o efeito é só no herói chegando com menos nível e menos coletas.
- Mapas encurtados exigem rever `cadência de interativos` (R4) para não ficarem com 2 sorteios.

### R2 — Densidade mínima de acontecimentos (corrige o "não tem o que fazer")

1. `optional_min` de 0 para 1 em `data/difficulty.json` (todo mapa passa a ter pelo menos 1 opcional). Sozinho já tira Molor e Goranthis do pior caso (1 evento em 10 a 11 minutos).
2. Meta de projeto: **nenhum intervalo maior que cerca de 90 a 120 s sem uma "batida"** (acontecimento, elite, onda-evento, interativo importante), nos mapas 4 a 10. Com a rampa B (330 a 420 s) isso pede 3 a 4 batidas por mapa; hoje Molor e Goranthis entregam 1,5.
3. Antes de criar acontecimentos novos, aproveitar os que já existem e estão como opcionais ou sem uso: Molor tem `vigilia_em_thullgrime` e `diario_do_chefe`; Feng-tu tem `enxame_pestilento` e `altar_disputado_feng_tu`; Goranthis tem `a_luz_prateada` e `o_nome_tres_vezes`. Promover opcionais a fixos e reescalar os horários dá o ganho sem arte nem sistema novos.
4. **Introduzir elenco ao longo do mapa**: distribuir `t0` das ondas e elites até 70 a 80 % da duração (hoje a última entrada é em 36 a 50 %), em vez de deixar o terço final sem novidade. Isso depende de conteúdo já existente (outros inimigos da mesma fase, elites de outras fases já usados em Pilares); inimigos novos ficam fora desta proposta.

### R3 — Ampulheta que aparece e faz diferença

1. **Garantia por mapa nos mapas longos** (do 5º em diante): se não houve ampulheta até o 2º sorteio aleatório do mapa, o próximo sorteio é ampulheta (piedade) ou, mais simples, um slot fixo de ampulheta entre 35 e 50 % da duração, que o jogador pode ignorar.
2. **Efeito proporcional**: `skip_seconds` de 60 fixos para algo como `max(60, 0,2 × duração)` (um mapa de 390 s adianta 78 s) e `burst_max` de 18 para um teto que dependa de `cap`, para o jogador receber a recompensa de tempo sem ser soterrado de uma só vez. Alternativa: em vez de despejar os inimigos acumulados, converter parte do tempo pulado em XP/moedas.
3. Conferir a regra "nos últimos 5 s antes do chefe a ampulheta não ajuda" e a mensagem (já correta, só vale para o fim do mapa).
4. Ampulheta do arsenal (`weapon: ampulheta`, Zynara, Silêncio Eterno) **não** é a mesma coisa; não mexer.

### R4 — Aleatoriedade de interativos mais justa e previsível

1. **Saco embaralhado por mapa**: montar uma lista com os tipos pelos pesos atuais (cada tipo no mínimo uma vez nos mapas longos) e sortear sem reposição, reabastecendo quando acabar. Mantém a variedade e elimina repetições e secas. Pesos continuam em `stages.json`.
2. **Cadência proporcional**: `min_seconds` e `spread_seconds` como fração da duração (por exemplo 80/35 s a 600 s equivale a cerca de 55/25 s a 390 s), para manter 4 a 5 sorteios por mapa depois de R1.
3. **Não perder a rolagem**: quando houver 3 vivos, sobreposição ou eclipse ativo, tentar de novo em 5 a 10 s em vez de esperar o intervalo inteiro, ou aposentar o interativo comum mais antigo e não usado (com aviso) em vez de bloquear. Decisão de design para o dono: expirar ou acumular.
4. **Fluxo de RNG próprio** para interativos e quebráveis (semente da run + fase + contador), como `Happenings.select`, para testes reproduzíveis e para o combate não "puxar" a sequência de interativos.
5. Manter o primeiro interativo fixo em baú aos 45 s, mas **escalar o instante com a duração** nos mapas curtos já decididos (hoje 45 s é 25 % de um mapa de 180 s).

### R5 — Velocidade e tempo entre mapas

1. **Liberar 1,5x/2x após vencer qualquer mapa**, ou depois do 3º mapa, em vez de só no mapa já vencido. Isso ataca a lentidão de mapas novos sem mexer em duração; é só uma condição em `can_speed_2x`. O botão já existe e já registra a marca "accelerated" na run.
2. **Medir antes de mexer no entre-mapas**: usar os checkpoints do `RunRecord` (`boss_dead` → `stage_reached` do mapa seguinte) em uma run sintética/bot para ver quanto tempo é HQ, baús, portal e carregamento. Se for o HQ, oferecer pular ou reduzir quadros no primeiro contato; se for o saque, é decisão do jogador.
3. Chefes: o tempo de luta com o chefe fora do relógio do mapa não foi medido; vale registrar `boss_spawn` → `boss_dead` nos bots antes de decidir se a duração do mapa B já está boa.

## 3. Plano de execução proposto (aguarda sua decisão e autorização)

| Etapa | O que | Verificação | Risco |
|---|---|---|---|
| M0 | Medir: tempo entre mapas, duração real da luta com chefe, e quantas ampulhetas/ferreiros uma run vê (bots `tools/playtest_maps.ps1` ou runs sintéticas). Sem salvamento real. | Relatório com números reais, para confirmar ou corrigir as contas deste documento | Baixo |
| M1 | Decisões do dono: opção A/B/C de duração, R2.1 (`optional_min`), política de interativos (R4.3), velocidade (R5.1). | Decisão registrada | Nenhum |
| M2 | Dados primeiro: R2.1, R2.3, R3.1/R3.2 e R5.1. Mudanças pequenas, reversíveis. | `run_all`, `audit_projeto`, testes de happenings e de ampulheta (`test_battle`) | Baixo |
| M3 | Código de interativos: saco embaralhado, cadência proporcional, retry em vez de descarte, RNG próprio (R4). Testes novos de distribuição e determinismo. | Testes de semente; simulação de 20 000 mapas confirmando a ausência de secas | Médio |
| M4 | Reescala dos mapas 4 a 10 para a duração escolhida, um mapa por vez, na ordem do jogo, com o método do lote B (tabela de campos que não escalam sozinhos acima). | `test_game_design`, `test_chapter1_chain`, testes de duração por mapa, bots por mapa, ajuste de pressão (R1) | Médio a alto |
| M5 | Playtest humano com o Vitão em janela, mapa a mapa; registrar tempo por mapa, batidas, ampulhetas vistas. | Relatório do playtest | — |

Dependências: M2 e M3 podem ir antes de M4 e já melhoram os mapas atuais. M4 só deve começar depois de M0 e M1.

## 4. Limites deste documento

- As probabilidades são de simulação sobre as regras do código e **ignoram** o teto de 3 interativos vivos e as exclusões por sobreposição; na prática a ampulheta aparece **menos** do que o simulado. Não usei saves nem telemetria reais.
- O ganho de tempo das opções A/B/C é aritmético; o efeito no equilíbrio (XP, nível, risco de morte) não foi simulado e deve ser medido nos bots.
- Não analisei o HQ nem a tela de resultado quanto ao tempo percorrido; só li o fluxo em `ui/run.gd`.
- Alterações comuns neste jogo exigem portagem registrada e checks em ambos os repositórios, segundo as regras do projeto; este documento não registra portagem.

## 5. Atualização 2026-10-31 — decisão B, M0 medido e M2 aplicado (local, sem commit)

Decisão do dono: **opção B** de duração (180, 180, 180, 240, 330, 360, 390, 390, 420, 420, 300; 56,5 min). A reescala dos mapas (M4) ainda **não foi feita**: depende de M3 e do ajuste de pressão.

### M0 — medição no código real (`.atena/generated/pacing-m0-20261031-r1/`)

Sonda `probe.gd`: 100 sementes por mapa, sem combate (ondas e elites vazias), herói parado e invulnerável, `Battle.step` de 0,5 s até o chefe. "Coletor" usa cada interativo na hora; "ignorador" deixa acumular. Resultados antes das mudanças (`resultado.txt`):

| Mapa | Interativos (coletor / ignorador) | P(ampulheta) coletor / ignorador | P(ferreiro) coletor |
|---|---|---|---|
| Docas, Reino, Domwieck (180 s) | 2,0 a 2,5 / igual | 2 a 6 % / igual | 1 a 5 % |
| Dagruve (300 s) | 3,0 / 3,0 | 13 % / 13 % | 11 % |
| Shedaklah (540 s) | 5,2 / 2,4 | 14 % / 2 % | 17 % |
| Molor (570 s) | 6,5 / 3,5 | 23 % / 7 % | 20 % |
| Durão (600 s) | 5,7 / 3,5 | 20 % / 7 % | 22 % |
| Feng-tu (600 s) | 5,7 / 2,2 | 19 % / 7 % | 25 % |
| Shendilavri (630 s) | 6,0 / 2,5 | 18 % / 5 % | 27 % |
| Goranthis (660 s) | 6,8 / 2,7 | 21 % / 6 % | 17 % |
| Pilares (300 s) | 3,0 / 2,9 | 11 % / 10 % | 8 % |

Conclusões: (1) a ampulheta aparece em **no máximo 23 %** dos mapas longos para quem coleta tudo, e em **2 a 7 %** para quem deixa interativos pelo chão, abaixo da simulação teórica (confirma o efeito do teto de 3 vivos); (2) o jogador que não coleta recebe a **metade** dos interativos (2,2 a 3,5 contra 5,2 a 6,8), pois o teto de 3 descarta rolagens em silêncio; (3) a contagem de "acontecimentos" da sonda só vê objetivos (coleta, escolta, pacto etc.); ondas, perigos e quakes não aparecem nela, mas Goranthis chegou a **0** objetivos em algumas sementes, o que confirma o sorteio opcional como causa.

### M2 — aplicado (dados e código pequenos)

- `data/difficulty.json`: `happenings.optional_min` 0 → 1 (com `optional_max` 1: exatamente 1 opcional por mapa); `hourglass.skip_pct` 0,2, `guarantee_after_rolls` 1 e `guarantee_min_duration` 300.
- `core/battle.gd`: ampulheta garantida no 1º sorteio aleatório de mapas com duração ≥ 300 s (a menos que já tenha vindo ou o chefe tenha chegado); `_use_hourglass` adianta `max(60 s, 20 % da duração)`; `can_speed_2x` libera 1,5x/2x depois de vencer **qualquer** mapa (mensagem ajustada).
- `tests/test_pacing.gd` novo (garantia em 8 sementes de Molor, salto proporcional, 1 opcional em 20 sementes, liberação da velocidade).
- Verificação: sonda repetida em Molor, Goranthis e Dagruve: ampulheta em 100 % dos mapas para o coletor; `run_all`: apenas as 3 falhas de UI que já existiam. Goranthis ignorador ficou em 52 %, porque o teto de 3 vivos ainda descarta rolagens (item R4.3, parte de M3).

Pendente: M3 (saco embaralhado, cadência proporcional, retry em vez de descarte, RNG própria), M4 (reescala B, mapa a mapa) e M5 (playtest). Com B, Dagruve (240 s) deixa de entrar na garantia (limite 300 s) e Shedaklah (330 s) entra.

## 6. Atualização 2026-10-31 — M3 aplicado (interativos), local

Mudanças em `core/battle.gd` e `data/difficulty.json` (`interactions`):
- **Saco embaralhado** por mapa (`_fill_inter_bag`): cada tipo entra com `round(peso)` fichas (mínimo 1; 21 fichas nos mapas padrão) e sai sem reposição; vazio, é refeito. O baú fixo dos 45 s consome uma ficha de baú. Efeito colateral aceito: tipos de peso 0,6 a 0,8 passam a ter 1 ficha, perto do dobro da chance relativa anterior.
- **Fluxo de RNG próprio** (`_inter_rng`, semente da run + fase): ordem, ângulo e distância dos interativos deixam de depender do combate.
- **Sem vaga, tenta de novo**: com o teto de vivos cheio, ou eclipse já ativo (a ficha vai para o fim do saco), o sorteio se repete em 8 s (`retry_seconds`); sobreposição com interativo fixo repete em 3 s. Antes a rolagem era perdida e o intervalo inteiro de 80 a 115 s esperado.
- **Cadência proporcional** (`_interaction_interval`): mapas com mais de 200 s multiplicam 80/35 s por `clamp(duração/600, 0,55, 1)`; os de 180 s ficam como estavam. Com a opção B (330 s) o intervalo cai para 44 a 63 s.
- A garantia da ampulheta passa a tirar a ficha do saco para não haver duas.

Medição repetida com a sonda (60 sementes, `resultado-m3.txt`): ampulheta em **100 %** dos mapas de 300 s ou mais (Shedaklah ignorador 93 %); interativos por mapa para quem coleta: Dagruve 5,0 e Pilares 5,1 (eram 3,0 pela cadência proporcional), 6,1 a 6,8 nos longos; quem não coleta segue com 2 a 3,5 (o teto de 3 vivos é regra de projeto). Tipos de serviço (loja/ferreiro/arcanista/curandeiro) ainda faltam em muitos mapas: P(ao menos 1 ferreiro) 12 a 28 % para quem coleta tudo. **Decisão aberta**: garantir 1 serviço por mapa de 300 s ou mais (mesma ideia da ampulheta), que não apliquei por ser escolha de jogo.

`run_all`: só as 3 falhas de UI de antes. Pendente: M4 (reescala B), M5 (playtest).
