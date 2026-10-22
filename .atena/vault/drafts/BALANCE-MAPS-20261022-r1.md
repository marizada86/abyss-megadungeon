# Playtest de equilíbrio dos mapas — 2026-10-22 (r1)

Status: DRAFT. Bots headless (`.atena/generated/balance-bots-20261018`, `bot.gd`, `bot2.gd`, `bot3.gd`), perfil sintético isolado, nenhum save real. Baseline: `9351270` (antes das decisões B1–B4). Herói imortal ("smart-god") mede pressão (dano por minuto, tempo, conclusão); bot mortal mede piso de sobrevivência. Não prova diversão nem dificuldade para jogador humano.

## Ajuste de método
O bot original jogava todo mapa em 40×40. `bot2.gd` passa a ler o lado da cena (60 ou 84) como `ui/run.gd`; `bot3.gd` faz o mesmo ao encadear fases e permite 10 segmentos. Os números absolutos das rodadas antigas dos mapas de 60 e 84 estavam inflados.

## Resultados (base → novo)
| Mapa | Conclui | Dano/min | Leitura |
|---|---|---|---|
| Dagruve (gárgulas movidas para cá) | 100 → 100% | 334 → 355 | +6%, aceitável |
| Shedaklah (sem gárgulas) | 58 → 67% | 1049 → 1017 | neutro |
| Domwieck (eventos novos) | 100 → 100% | 1295 → 1224 | neutro |
| Reino Abissal (Ezro, Shu, Death Tyrant) | 92 → 75% | 645 → 1082 | **piorou muito, 3 mortes** |
| Shendilavri, Goranthis, Pilares | — | — | **não medido**: o bot isolado morre no nível 1; a campanha encadeada não passa de Durao/Feng-tu |

Piso mortal (sobrevive em s): Dagruve 103 → 109, Pilares 56 → 55, Domwieck 59 → 59.

## Reino Abissal: causa e variantes (6 heróis × 2–3 sementes)
| Variante | Conclui | Dano/min | Mortes |
|---|---:|---:|---:|
| Base | 93% | 649 | 0 |
| Atual (antes do ajuste) | 79% | 1092 | 3 |
| Sem Death Tyrant | 83% | 1073 | 2 |
| Death Tyrant leve | 92% | 1077 | 1 |
| Sem Ezro, Shu raro, DT leve | 100% | 923 | 0 |
| Sem Ezro/Shu, DT original aos 140 s | 92% | 720 | 1 |
| **v5: sem Ezro/Shu, DT leve aos 140 s** | **100%** | **702** | **0** |
| v6: v5 + Shu máx. 2 | 89% | 744 | 2 |

O dano só caiu quando Ezro e Shu saíram das ondas; tirar o Death Tyrant não mudou o dano. O Shu (velocidade 2, ondas contínuas) é o principal culpado.

## Aplicado (v5)
- Reino Abissal: removidas as ondas de Shu (70–180 s) e de Ezro (100–180 s) em `data/stages.json` e `data/chapter_flow.json`. Ezro continua como elite do covil.
- Death Tyrant: elite aos 140 s (antes 120 s); vida 500 → 300 e dano 2d10 → 2d8 em `data/enemies.json` (só o Reino Abissal o usa).
- Confirmação com o estado aplicado: 18 runs, 100% conclusão, 702 dano/min, 0 mortes.

## Pendências
- Shendilavri, Goranthis e Pilares seguem sem medição; as trocas de elenco ali (Crueldades → súcubo, Death Tyrant → Guardião de Goranthis e Receptáculo) põem inimigos de 130–200 de vida no lugar dos de 420–500 e devem aliviar. Medir exige bot com progressão (campanha completa ou nível/build inicial).
- Playtest humano do Reino Abissal e de Dagruve.

## Adendo — build inicial sintética (bot4), Shendilavri, Goranthis e Pilares
`bot4.gd`: sobe o herói até o nível 36, 38 e 40 (por mapa) escolhendo ofertas com a política do bot, equipa 3 itens raros e começa a fase. No modo imortal, um golpe acima do PV máximo conta como "golpe letal" e a partida segue. 144 runs (6 heróis × 2 sementes × imortal/mortal × base `9351270`/atual). Build resultante: 5 armas evoluídas e PV máximo ~85 (sem meta).

| Mapa | Conclui (imortal) | Dano/min | Golpes letais/min | Pico de inimigos | Mortal sobrevive |
|---|---|---|---|---|---|
| Shendilavri | 67 → 67% | 2851 → 2800 | 3,06 → 2,50 | 59 → 62 | 121 → 121 s |
| Goranthis | 42 → 50% | 3373 → 3163 | 3,87 → 4,13 | 100 → 73 | 135 → 157 s |
| Pilares | 0 → 0% (chefe nunca morre, 0/12) | 4356 → 4108 | 4,82 → 3,18 | 99 → 96 | 65 → 66 s |

Leitura: as trocas de elenco (B3/B4) ficaram neutras ou um pouco mais leves, como esperado; nada a reverter. A rampa de pressão entre os três mapas é +13% e +30% (2,8 mil → 3,2 mil → 4,1 mil por minuto). Limite: o bot sem meta tem ~85 de PV, então o piso mortal (1 a 3 minutos) não representa um jogador com Quartel e equipamento; só vale a comparação base × novo.
Ponto aberto: a Síntese Abissal não morreu em nenhuma das 12 runs de Pilares (45 timeouts no total); precisa de playtest humano ou de rodada com meta completa.

## Adendo 2 — Pilares com meta completa (bot5)
`bot5.gd` = bot4 + `--meta full`: todas as melhorias do Quartel no nível máximo e todas as recompensas de conquista (sem ler o save; PV máx. 75 → 98, 5 slots de arma), nível 40, 3 itens raros, estado atual (`a792cca`). 24 runs: 6 heróis × 2 sementes × imortal/mortal. Sem marcas do Abismo, sem equipamento do Quartel além dos 3 itens e dificuldade 1,0.

| | Sem meta (adendo 1) | Meta completa |
|---|---|---|
| Chefe morto (imortal, 660 s) | 0/12 | **4/12** (Durvall, Kayron, Maelor, Sylas, seed 2; aos 396–557 s) |
| Dano/min (imortal) | 4108 | 3657 (−11%) |
| Golpes letais/min (imortal) | 3,18 | 2,26 |
| Pico de inimigos | 96 | 28–82 |
| Mortal sobrevive | 66 s | 97 s (46–275 s; Korrak seed 2 foi o máximo) |

Leitura: a meta completa move o chefe de "nunca morre" para "morre em 1/3 das runs imortais", mas a fase continua letal para o bot (nenhuma run mortal passou de 5 min, 0/12 chefe) e ainda exige ~2 golpes letais por minuto mesmo no modo imortal. O ganho de sobrevivência (+31 s) é pequeno diante dos 300 s de duração. Isto aponta Pilares como o pico de dificuldade do jogo, em linha com a rampa já vista (+13% e +30% sobre Shendilavri/Goranthis), mas o bot não esquiva, não usa terreno/fontes nem marcas, então não prova que um humano com Quartel cheio falhe. Nenhum dado de jogo foi alterado.

Decisão (dono, 2026-10-22): manter Pilares como está até o playtest humano; sem variante agora.
Arquivos: `.atena/generated/balance-bots-20261018/{bot5.gd,run-bot5.sh,launch-bal22i.sh,results/i-meta-*.jsonl}`.
