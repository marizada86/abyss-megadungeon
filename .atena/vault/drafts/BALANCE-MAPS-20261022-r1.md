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
