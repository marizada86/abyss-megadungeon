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
| 7 | Durao | 600 s | 3 fixos + 0 a 1 de 1 opcional = 3,5 | 0,35 |
| 8 | Feng-tu | 600 s | 2 fixos + 0 a 1 de 2 opcionais = 2,5 | 0,25 |
| 9 | Shendilavri | 630 s | 2 fixos + 0 a 1 de 1 opcional = 2,5 | 0,24 |
| 10 | Goranthis | 660 s | 1 fixo + 0 a 1 de 2 opcionais = 1,5 | 0,14 |
| 11 | Pilares | 300 s (sem fim; o relógio volta a zero a cada chefe) | 3 | 0,60 |

Tempo total de mapa até Pilares: 4 740 s (cerca de 79 min). Os três primeiros têm 1 evento por minuto ou perto disso; Molor e Goranthis têm 0,14 a 0,16, ou seja, **de 6 a 7 vezes menos coisa acontecendo por minuto**, num mapa 3 a 3,7 vezes mais longo. Isso confirma a impressão do Vitão com números.

Causa: `optional_min` é 0 em `data/difficulty.json` (`happenings`), então um mapa pode sortear nenhum acontecimento opcional, e os cronogramas de acontecimentos não foram densificados quando os mapas foram alongados.

### 1.2 Ondas: a lista de inimigos para de mudar muito antes do fim (medido)

Último inimigo novo que entra em cada mapa longo (`t0` da onda mais tardia) contra a duração:

- Shedaklah: 240 de 540 s. Durao: 300 de 600 s. Goranthis: 240 de 660 s.
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
| Durao | 600 | 450 | 390 | 300 |
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
| Durao (600 s) | 5,7 / 3,5 | 20 % / 7 % | 22 % |
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

## 7. Atualização 2026-10-31 — serviço garantido por mapa longo (local)

Decisão do dono: "Garantir serviço". Em `core/battle.gd` (`_spawn_random_interaction`) e `data/difficulty.json` (`interactions.service_after_rolls` 2, `service_min_duration` 300): em mapas de 300 s ou mais, se ainda não saiu loja, ferreiro, arcanista ou curandeiro, o 2º sorteio aleatório vira um deles (sorteado entre os que o mapa tem, só os que a marca "Sem trégua" não removeu). A ampulheta continua no 1º sorteio. A ficha forçada sai do saco.

Sonda (60 sementes, `resultado-m3b.txt`), quem coleta tudo: **P(pelo menos um serviço) 98 a 100 %** nos mapas longos (antes 66 a 74 %); P(ferreiro) 25 a 45 %. Quem deixa interativos no chão: 0 a 100 % conforme o mapa (Shedaklah e Shendilavri 0 %, Feng-tu 22 %, Goranthis 53 %), porque os interativos dos acontecimentos também contam no teto de 3 vivos e a vaga não abre. Isso pede uma decisão futura sobre o teto (contar só interativos comuns, ou subir para 4 em mapas longos); não foi mexido.

Teste novo em `tests/test_pacing.gd` (serviço em 8 sementes de Molor). `run_all`: só as 3 falhas de UI de antes.

## 8. M4 — Shedaklah 540 → 330 s (2026-11-01, local, sem commit)

Fator k = 330/540 = 0,611. Arredondado a inteiros; `every`, `n`, `max`, `cap` das ondas, prazos (`deadline`), avisos (`warning`) e regras periódicas (poças a cada 8 s) **não** foram escalados (dependem da caminhada e do ritmo do combate, não da duração). Editado em `data/stages.json`, no espelho `data/chapter_flow.json` (`legacy_stages`) e em `data/stage_events.json`.

| Campo | Antes | Depois |
|---|---|---|
| `duration` / chefe | 540 | 330 |
| servo_de_zuggtmoy `t1` | 200 | 122 |
| cogumelo_fungico `t1` | 240 | 147 |
| esporo_voador `t0`–`t1` | 60–400 | 37–244 |
| slime_de_juiblex `t0`–`t1` | 120–540 | 73–330 |
| pudim_negro `t0`–`t1` | 240–540 | 147–330 |
| Elites (pudim_negro, receptáculo de Juiblex) | 150, 400 | 92, 244 |
| `pedido_de_zuggtmoy` | 45 | 28 |
| `altar_disputado_shedaklah` | 150 | 92 |
| `portal_sem_vao` (prazo 75 s mantido) | 250 | 153 |
| `barqueiro_do_estige` | 380 | 232 |

**Bots** (`balance-bots-20261018/bot5.gd`, política `smart-god`, dt 0,05, durvall/brook/maelor × sementes 1 a 3 = 9 runs por cronograma, resultados em `balance-bots-20261018/results/m4-shed-old.jsonl` e `m4-shed-new.jsonl`; amostra pequena, sem valor estatístico forte):

| | Antes (540 s) | Depois (330 s) |
|---|---|---|
| Chefe derrotado | 6/9 | 6/9 |
| Tempo até derrotar o chefe (média dos vencidos) | 684 s (11,4 min) | 447 s (7,5 min) |
| Nível do herói no fim (média) | 15,7 | 13,6 |
| Abates (média) | 560 | 418 |
| Ouro (média) | 151 | 111 |

Leitura: a taxa de vitória se manteve, o tempo total do mapa caiu cerca de 35 %, e o herói chega ao chefe com cerca de 2 níveis a menos, 25 % menos abates e 27 % menos ouro. Sem compensação, os mapas seguintes (já reescalados) acumulam esse déficit; alavancas: `xp_mult`/`coin_mult` do mapa, ou o crescimento de PV por minuto. Não ajustei nada para isso ainda, pois com 9 runs a diferença de taxa de vitória não é distinguível de ruído.

Acontecimentos (sonda): 3 objetivos por mapa em 5,5 min (≈0,55 por minuto, antes ≈0,28). Ampulheta 100 %, serviço 98 % para quem coleta; quem ignora ainda sofre o teto de 3 vivos (decisão aberta).

`run_all`: só as 3 falhas de UI de antes.

## 9. M4 — Molor 570 → 360 s (2026-11-01, local, sem commit)

Fator k = 360/570 = 0,632, mesmo método da seção 8 (`stages.json`, espelho em `chapter_flow.json`, `stage_events.json`).

| Campo | Antes | Depois |
|---|---|---|
| `duration` / chefe (Blogbog) | 570 | 360 |
| bolha_de_slime `t1` | 200 | 126 |
| slime_de_juiblex `t0`–`t1` | 30–400 | 19–253 |
| cultista_thullgrime `t0`–`t1` | 90–570 | 57–360 |
| pudim_negro `t0`–`t1` | 180–570 | 114–360 |
| cogumelo_fungico `t0`–`t1` | 300–570 | 189–360 |
| Elites (pudim_negro, receptáculo ×2) | 140, 270, 420 | 88, 171, 265 |
| `vigilia_em_thullgrime` | 120 (opcional) | 76 (**fixo**) |
| `ritual_de_estagnacao` | 230 | 145 |
| `diario_do_chefe` (prazo 60 s mantido) | 400 (opcional) | 253 (**fixo**) |

Os dois acontecimentos opcionais de Molor viraram fixos (R2.3): Molor tem 3 acontecimentos em 6 min, em vez de 1 a 2 em 9,5 min.

**Bots** (mesmo conjunto: durvall/brook/maelor × sementes 1 a 3; `results/m4-molor-old.jsonl` e `m4-molor-new.jsonl`; as duas rodadas foram feitas **antes** de fixar os opcionais):

| | Antes (570 s) | Depois (360 s) |
|---|---|---|
| Chefe derrotado | 3/9 | 3/9 |
| Tempo até derrotar o chefe (vencidos) | 793 s (13,2 min) | 589 s (9,8 min) |
| Nível do herói no fim (média) | 17,0 | 14,9 |
| Abates (média) | 902 | 666 |
| Ouro (média) | 243 | 170 |

Leitura: a taxa de vitória dos bots é baixa nos dois cronogramas (3/9), então Molor já é duro para eles e a redução não piorou isso; o tempo cai cerca de 26 %, e o herói chega com 2 níveis a menos, 26 % menos abates e 30 % menos ouro. Mesmo ressalva de amostra pequena.

Testes: `tests/test_pacing.gd` passou a medir o opcional em Shedaklah (Molor não tem mais opcionais) e a fixar 570 s no teste de cadência. `run_all`: só as 3 falhas de UI de antes.

## 10. M4 — Durao 600 → 390 s (2026-11-01, local, sem commit)

Fator k = 390/600 = 0,65, mesmo método (`stages.json`, espelho em `chapter_flow.json`, `stage_events.json`). Grafia do mapa: **Durao** (decisão do dono, sem til).

| Campo | Antes | Depois |
|---|---|---|
| `duration` / chefe (Molydeus) | 600 | 390 |
| alma_penada `t1` | 220 | 143 |
| demonio_de_gehenna `t0`–`t1` | 30–400 | 20–260 |
| carcereiro_de_pedra `t0`–`t1` | 120–600 | 78–390 |
| aberracao_shu `t0`–`t1` | 240–600 | 156–390 |
| ezro `t0`–`t1` | 300–600 | 195–390 |
| Elites (carcereiro, molydeus_menor ×2) | 160, 300, 450 | 104, 195, 293 |
| `desertores` (prazo 50 s) | 200 | 130 |
| `patrulha_do_carcereiro` (6 s depois dos desertores, como antes) | 206 | 136 |
| `arena_do_testador` (prazo 45 s) | 380 | 247 |
| `vhaerith_na_jaula` (opcional, único: sempre sai com `optional_min` 1) | 470 | 306 |

**Bots** (durvall/brook/maelor × sementes 1 a 3; `results/m4-durao-old.jsonl` e `m4-durao-new.jsonl`): o chefe só foi derrotado em **1/9** partidas nas duas versões (Durao já é muito duro para os bots), então a taxa de vitória e o tempo até o chefe não discriminam. Nível médio 14,6 → 14,3; abates 312 → 226 (−28 %); ouro 100 → 79 (−21 %). Pouca informação; o jogo humano é a prova.

Sonda de interativos: 4 acontecimentos em 6,5 min (≈0,6/min, antes 3,5 em 10 min), ampulheta 100 %, serviço 100 %. `run_all`: só as 3 falhas de UI de antes.

## 11. M4 — Feng-tu 600 → 390 s (2026-11-01, local, sem commit)

Fator k = 390/600 = 0,65, mesmo método (`stages.json`, espelho em `chapter_flow.json`, `stage_events.json`).

| Campo | Antes | Depois |
|---|---|---|
| `duration` / chefe (Discipulo Pestilento) | 600 | 390 |
| larva_de_lu_yueh `t1` | 240 | 156 |
| cultista_de_feng_tu `t0`–`t1` | 30–420 | 20–273 |
| estatua_do_templo `t0`–`t1` | 150–600 | 98–390 |
| cultista_ghaunadaur `t0`–`t1` | 240–600 | 156–390 |
| Elites (estatua_do_templo ×2, cultista_de_feng_tu) | 150, 300, 450 | 98, 195, 293 |
| `enxame_pestilento` | 120 (opcional) | 78 (**fixo**) |
| `escolta_do_peregrino` | 230 | 150 |
| `altar_disputado_feng_tu` (opcional, único: sempre sai) | 170 | 110 |
| `peregrinacao_da_estrela` | 420 | 273 |
| Maldição da peregrinação (`curse.duration`) | 150 s | **100 s** |

A maldição da peregrinação foi encurtada de 150 para 100 s porque 273 + 150 = 423 s passaria do chefe (390 s): sem achar a estrela o herói entraria doente (−20 % de dano) na luta. Com 100 s ela acaba em 373 s.

**Bots** (durvall/brook/maelor × sementes 1 a 3; `results/m4-feng-old.jsonl` e `m4-feng-new.jsonl`; rodada nova com o enxame já fixo): nenhuma partida derrotou o chefe nas duas versões (0/9), então vitória e tempo não discriminam. Nível médio 14,6 → 12,8; abates 741 → 568 (−23 %); ouro 187 → 131 (−30 %).

Sonda: 3 acontecimentos de objetivo em 6,5 min mais o enxame (onda). Ampulheta 100 %, serviço 100 % para quem coleta. `run_all`: só as 3 falhas de UI de antes.

### 12. M4: Shendilavri 630 → 420 s

Fator 0,667 aplicado em `stages.json`, no espelho de `chapter_flow.json` e em `stage_events.json`. Mantidos `every`, `n`, `max`, `cap` e o prazo de 55 s das vítimas.

| Campo | Antes | Depois |
|---|---|---|
| Duração (chefe, Malcanthet) | 630 | 420 |
| escravo_de_rivenheart, fim | 240 | 160 |
| sucubo `t0`–`t1` | 30–500 | 20–333 |
| ilusao_de_sucubo `t0`–`t1` | 30–630 | 20–420 |
| guarda_do_castelo `t0`–`t1` | 200–630 | 133–420 |
| cultista_ghaunadaur `t0`–`t1` | 300–630 | 200–420 |
| Elites (guarda, sucubo ×2) | 160, 320, 480 | 107, 213, 320 |
| `mercador_de_rivenheart` (opcional, único: sempre sai) | 160 | 107 |
| `o_convite` (jitter 0,1) | 310 | 207 |
| `vitimas_drenadas` (prazo 55 s) | 450 | 300 |

Os horários dos acontecimentos já ficam antes do chefe com folga: a última tarefa termina em 355 s. Nenhum efeito longo foi alterado.

**Bots** (durvall/brook/maelor × sementes 1 a 3, nível inicial 1; `results/m4-shen-old.jsonl` e `m4-shen-new.jsonl`): nenhuma partida chegou ao chefe nas duas versões (0/9, `reach false`), pois os bots entram no nível 1 em um mapa de tier 6 e ficam sem vida. A comparação não discrimina. Nível médio 4,8 → 4,6; abates 651 → 536 (−18 %); o ouro (14,6 → 23,4) é ruído de amostra.

Sonda (30 sementes): 3 acontecimentos por mapa, ampulheta 100 %, serviço 100 % para quem coleta e 0 % para quem ignora. `run_all`: só as 3 falhas de UI de antes (`test_ui_kit` ×2, `test_accessibility` ×1).

Medalhas: os limiares de abates (600/950/1250) foram calibrados para 630 s. Com −18 % a 25 % de abates, a medalha de ouro fica mais difícil; fica para o playtest humano (M5).

### 13. M4: Goranthis 660 → 420 s

Fator 0,636 em `stages.json`, no espelho de `chapter_flow.json` e em `stage_events.json`. Mantidos `every`, `n`, `max`, `cap`. Os dois opcionais (`a_luz_prateada`, `o_nome_tres_vezes`) foram **promovidos a fixos**, como previsto no item 3 da seção de recomendações: o mapa passa de 1,5 para 3 acontecimentos.

| Campo | Antes | Depois |
|---|---|---|
| Duração (chefe, Socothbenoth) | 660 | 420 |
| ilusao_de_socothbenoth, fim | 240 | 153 |
| guardiao_de_goranthis `t0`–`t1` | 20–660 | 13–420 |
| cultista_de_socothbenoth `t0`–`t1` | 60–660 | 38–420 |
| slime_de_juiblex `t0`–`t1` | 240–660 | 153–420 |
| Elites (guardião, receptáculo de Juiblex, guardião) | 180, 360, 520 | 115, 229, 331 |
| `a_luz_prateada` | 200 (opcional) | 127 (**fixo**) |
| `do_trono_ao_lodo` (jitter 0,08) | 400 | 255 |
| `o_nome_tres_vezes` (varre o mapa e chama Graz'zt) | 520 (opcional) | 331 (**fixo**) |

O Graz'zt e a terceira elite continuam coincidindo (331 s), como no original (520 s): a varredura poupa elites e chefe. A boon da luz (60 s) e a de 45 s terminam antes do chefe.

**Bots** (durvall/brook/maelor × sementes 1 a 3, nível inicial 1; `results/m4-gor-old.jsonl` e `m4-gor-new.jsonl`): nenhuma partida chegou ao chefe nas duas versões (0/9, `reach` falso), mesmo problema de Shendilavri; não discrimina. Nível médio 3,8 → 3,1; abates 632 → 548 (−13 %); ouro 13,2 → 10,2.

Sonda (30 sementes): 2 acontecimentos com objetivo mais a troca de mapa (sem objetivo, por isso a sonda não conta), ampulheta 100 %, serviço 100 % para quem coleta e 0 % para quem ignora. `run_all`: só as 3 falhas de UI de antes.

Medalhas: limiares de abates (1400/2200/3000) calibrados para 660 s; com menos abates a medalha de ouro fica mais difícil. Fica para o M5.

### 14. M4: Dagruve 300 → 240 s

Fator 0,8 em `stages.json`, no espelho de `chapter_flow.json` e em `stage_events.json`. Mantidos `every`, `n`, `max`, `cap`.

| Campo | Antes | Depois |
|---|---|---|
| Duração (chefe, Sacerdote da Mente Derretida) | 300 | 240 |
| zumbi `t0`–`t1` | 0–94 | 0–75 |
| slime_corrosivo | 12–125 | 10–100 |
| cultista_adaga | 38–188 | 30–150 |
| cultista_arqueiro | 75–225 | 60–180 |
| notivago | 94–262 | 75–210 |
| cultista_cajado | 131–300 | 105–240 |
| criatura_corrompida, gargula | 150–300 | 120–240 |
| Elites (criatura, cajado, gárgula) | 94, 188, 240 | 75, 150, 192 |
| `ritual_da_nevoa` (câmara selada) | 115 | 92 |
| `pulso_da_fratura` | 290 | 232 |

**Guardas de teste alteradas.** Três testes protegiam o valor antigo: `test_chapter1_chain` ("Dagruve deve ficar como está (decisão D5)", exigia 300 s), `test_dagruve_encounter` (exigia `duration == 300`) e `test_secrets` (exigia o texto «Ritual da Névoa» aos 1:55; agora 1:32). Os três agora exigem os valores novos. O texto original da decisão D5 não foi encontrado em `.atena/vault` nem em `plan.yaml`; a rampa B, aprovada pelo dono, lista Dagruve em 240 s. **Reverter é trivial** (restaurar os 3 testes e os 3 arquivos de dados).

**Bots** (durvall/brook/maelor × sementes 1 a 3; `results/m4-dag-old.jsonl` e `m4-dag-new.jsonl`): vitórias 8/9 → 9/9; duração da partida 387 → 282 s (−27 %); nível 15,0 → 13,9; abates 611 → 490 (−20 %); ouro 182 → 152 (−17 %). Este é o único mapa da rampa em que os bots vencem, então é o dado mais confiável: a derrota do chefe não ficou mais difícil.

Sonda (30 sementes): Dagruve sai da garantia de ampulheta (limite 300 s), como previsto: ampulheta em 10 % dos mapas para quem coleta tudo, aceitável num mapa de 4 min. Serviço 67 % para quem coleta. `run_all`: só as 3 falhas de UI de antes.
