# Varredura de bots a6, depois das evoluções de arma (DRAFT r1, 2026-11-07)

Estado: **DRAFT**, medição somente leitura. Nada de equilíbrio foi alterado. Ação A2 de `ALPHA-POLISH-RECOMENDACOES-20261104-r1.md`.

## Método
Mesma varredura da a4: 168 trabalhos (12 heróis × 11 mapas × 3 sementes), imortal com nível de referência e Quartel cheio nos mapas 4 a 11, mortal só nos 3 do capítulo 1, `dt` 0,05, perfil sintético isolado. Código congelado do commit `841dab2` (`tmp/base-a6-20261107`). Resultado: 168 de 168 com saída 0 e 0 SCRIPT ERROR. Tabela completa: `.atena/generated/balance-bots-20261018/results/a6-aggregate.md` (a4 em `a4-aggregate.md`).

**Limite:** 3 sementes por célula dão ruído de ±1 vitória por herói e mapa. Bots medem pressão, não diversão; nada aqui substitui a playtest humana.

## O que mudou em relação à a4 (imortal)
| Mapa | dano/min a4 → a6 | PV mínimo a4 → a6 | Vitórias a4 → a6 |
|---|---|---|---|
| Domwieck | 1 080 → 1 027 | 30% → 27% | 36 → 35 |
| Shedaklah | 241 → 226 | 67% → 66% | 36 → 36 |
| Molor | 507 → 478 | 53% → 55% | 36 → 36 |
| Durao | 476 → 419 | 30% → 31% | 36 → 36 |
| Feng-tu | 925 → 876 | 18% → 21% | 36 → 36 |
| Shendilavri | 1 526 → 1 326 | 13% → 18% | 36 → 36 |
| Goranthis | 2 059 → 1 745 | 1% → 2% | 35 → 36 |
| Pilares | 3 136 → 2 825 | 0% → 0% | 13 → 15 |

Docas, Reino Abissal e Dagruve ficaram praticamente iguais (Dagruve segue com 87% de PV mínimo e 39 de dano/min).

## Leitura
1. **A pressão cai de 8% a 15% do meio ao fim** (Shendilavri, Goranthis, Pilares), compatível com as evoluções de arma deixando os bots mais fortes. A rampa continua íngreme: Goranthis e Pilares ainda terminam com PV mínimo de 2% e 0%.
2. **Pilares continua sendo a parede:** 15 de 36 contra 13 de 36, dentro do ruído. Quem não vence lá: Durvall, Nyrelia e Arlindo com 0/3.
3. **Desigualdade entre heróis diminuiu um pouco no topo:** Erik caiu de 33/33 para 32/33 e Kayron subiu para 33/33. O extremo fraco não mudou: Arlindo 28/33, e Nyrelia e Sylas com 29/33.
4. **Zynara é um valor fora da curva em robustez:** 538 de dano/min em Goranthis contra 1 124 a 2 618 dos demais (a4: 814). Leoric, Arlindo, Brook e Nyrelia recebem mais dano nos mapas finais (2 379 a 2 618).
5. **Mortais:** 0 de 108 de novo, como na a4. O bot mortal não desvia; isto não diz nada sobre a primeira partida humana em Docas.

## Recomendações (nenhuma aplicada)
- Manter os números de equilíbrio como estão até a playtest humana. A a6 não muda a conclusão da a4: só humano diz se Goranthis e Pilares são justos.
- Se a playtest confirmar que Pilares é brutal, a alavanca mais barata continua sendo `hp_mult`/`dmg_mult` por mapa em `data/stages.json` (−10% a −15% como primeiro passo).
- Candidatos a revisão pós-playtest: Arlindo e Nyrelia (fracos nos finais) e Zynara (forte demais em Goranthis).
- Não repetir a varredura antes de nova mudança em armas, evoluções ou mapas.
