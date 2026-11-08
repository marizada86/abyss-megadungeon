# Arlindo: Memória Alterada mais ágil (DRAFT r1, 2026-11-08)

Estado: **DRAFT**. Mudança aplicada na árvore de trabalho, **sem commit**.

## Mudança
- `memoria_alterada`: recarga 2,2 → 1,7 s; perfuração 0 → 1.
- `memoria_reescrita` (evolução): perfuração 0 → 1.
- Habilidade, passiva e atributos intactos.

## Medição (bots imortais, 3 sementes por mapa; a6 = antes, a7 = depois)
Tabela completa: `.atena/generated/balance-bots-20261018/results/a7-aggregate.md`.

- Total: **28/33 → 31/33**. Docas 2/3 → 3/3, Reino Abissal 2/3 → 3/3, Pilares 0/3 → 1/3.
- Docas: dano/min 900 → 714 e abates 84 → 162 (o começo, antes o ponto mais frágil, melhorou claro).
- Mapas finais: Goranthis 2 618 → 2 454, Shendilavri 1 907 → 1 837, Pilares 3 427 → 3 823; PV mínimo de Durao e Shendilavri caiu (42% → 24%, 22% → 15%). Com 3 sementes isto é ruído.
- Mortal (capítulo 1): 0/9 nos dois, como com todos os heróis; o bot não desvia.

## Limites
Amostra de 3 sementes, só bots. Arlindo ainda tem dano por minuto alto em Goranthis e Pilares; Nyrelia e Zynara não foram tocadas. Só a playtest humana diz se a sensação de jogo melhorou.

## Reverter
Voltar as três linhas em `data/weapons.json` (recarga 2,2, perfuração 0 em ambas as armas).
