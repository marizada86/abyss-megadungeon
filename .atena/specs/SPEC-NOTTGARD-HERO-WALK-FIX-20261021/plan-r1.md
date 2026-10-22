# PLAN-NOTTGARD-HERO-WALK-FIX-20261021 · r1

Classificação: PLAN_CHANGE_REQUEST · modo: por lote · conteúdo: DRAFT
Origem: pergunta do dono em 2026-10-21 ("existe um plano para corrigir as passadas dos personagens jogáveis?"). Não havia plano; a passada constava só como gate retido ("bugs visuais de identidade/passada") em `playtest-r1.md` e `EVID-NOTTGARD-SOURCE-PORT-B004-20261018-r1.md`.

## Lotes

| Lote | Escopo | Estado |
|---|---|---|
| L1 | Auditoria somente leitura das tiras `move_*` dos 12 heróis | CONCLUÍDO (este documento) |
| L2 | Decidir a rota de correção por herói/direção (decisão do dono) | AGUARDA APROVAÇÃO |
| L3 | Executar a correção aprovada (arte nova e/ou normalização) | NÃO AUTORIZADO |
| L4 | Teste automático das métricas + checagem humana H-PORT-002 | NÃO AUTORIZADO |

## L1 · método

`audit_walk.gd` (Godot headless, rodado fora do projeto; nenhum arquivo do jogo aberto para escrita, save real intocado) mede, por quadro de cada tira, o retângulo de alfa > 16: altura, base dos pés, centro de massa, pixels opacos, recorte na borda da célula e quadros vazios ou duplicados em sequência. Compara com o idle do mesmo herói (`HERO_IDLE_ART_HEIGHT`, `HERO_FEET_Y` em `ui/hero_view.gd`), que define a escala em tela. Saída bruta: `.atena/generated/hero-walk-fix-20261021/audit-r1.json`.

Limites: o alfa não enxerga identidade, lado da arma nem estilo. Um defeito só é "confirmado" onde olhei a imagem (Korrak oeste). O resto é suspeita medida.

## L1 · resultado

Sem problema estrutural: todas as tiras têm a largura esperada (6 quadros; Erik `move_e` 7), nenhum quadro vazio, nenhum duplicado em sequência, nenhum recorte em idle.

### P1 · arte dormente: tiras de oeste de Korrak, Maelor, Sylas e Kayron divergem do herói

**Não afeta o jogo hoje.** `ui/hero_view.gd` só carrega tiras de oeste reais para o Durvall (`REAL_WEST_WALK`, linha 107). Os outros quatro andam para oeste espelhando `move_e/se/ne` (`WALK_SOURCE_DIRECTIONS` não inclui oeste). Os arquivos `move_w/sw/nw` deles ficam no repositório sem uso (só entram pelo laboratório `--walk-candidate`). A tabela abaixo mede essa arte parada: serve para decidir se ela pode ser aproveitada ou descartada.

Alvo: altura ≈ idle (×1,00) e base dos pés constante (célula 256×384: ~375 para Kayron/Sylas, 363 Maelor, 349 Korrak).

| Herói | Tira | Altura vs idle | Base dos pés | Quadros recortados |
|---|---|---|---|---|
| Korrak | sw / w / nw | ×1,34 / ×1,33 / ×1,39 | 366–376 / 358–374 / 365–374 | 0 / 2 / 0 |
| Maelor | sw / w / nw | ×1,09 / ×1,23 / ×1,20 | 352–375 / 369–377 / 342–380 | 6 / 0 / 6 |
| Sylas | sw / w / nw | ×1,12 / ×1,00 / ×1,16 | 355–375 / 320–358 / 342–370 | 6 / 6 / 5 |
| Kayron | sw / w / nw | ×1,08 / ×1,08 / ×1,10 | 338–368 / 346–371 / 354–372 | 6 / 6 / 6 |

Se fossem ligadas como estão, o sprite (ancorado pela base do idle e escalado pela altura do idle) cresceria andando para oeste, os pés subiriam e desceriam da sombra e o corpo ou a arma seria cortado na borda da célula. Confirmação visual: `korrak/move_w.png` é outra figura (mais alta e magra, pelagem em outro tom, machado do lado oposto ao de `move_e.png`). Isso explica por que essa arte não foi ligada. Depois, na L2, olhei `move_w` de Maelor, Sylas e Kayron: é a mesma figura do leste (rosto, roupa, adereços), só maior, com os quadros deslocados do grid de 256 px (por isso o recorte). Sylas tem a capa cruzando a borda da célula. `sw` e `nw` desses três não foram vistos individualmente.

### P2 · direções com oscilação acima do normal

- Durvall `nw` (altura 207–235, base 418–440) e `ne` (212–235, 424–440): pé levanta 16–22 px, contra 6–10 nas outras direções. Verificar se é passada exagerada ou quadro com pé fora de lugar.
- Sylas `se`: centro oscila 26 px. Sylas `e`: base 372–378; Kayron `e`: base 375–378; Kayron `ne`: 371–377.
- Erik `n`/`ne`: altura ×1,05/×1,04 (302–316 / 297–311).

### P3 · passada quase parada (variação de pixels opacos ≤ 4%)

Sylas `s` (2%), Maelor `n` (3%), Zynara `se` e `s` (3%), Bromnor `s` (4%). Os quadros existem e não se repetem, mas a diferença é mínima: deslizamento provável. Precisa de olho humano.

### P4 · oeste por espelhamento (11 dos 12 heróis)

Todos menos Durvall andam para oeste espelhando leste/nordeste/sudeste (`MIRRORED_WALK_ANIMATIONS`). Para Durvall o dono já decidiu por tiras reais "porque a espada não é simétrica". Como o espelho é o caminho real do jogo, é o principal suspeito do "bug de identidade" do gate retido (arma e ornamentos trocam de lado ao virar para oeste). Falta decidir, herói a herói, se arma, cicatriz ou ornamento assimétrico torna o espelho inaceitável. Esta análise não responde isso.

### Saudáveis nas métricas

Sem problema nas métricas, salvo os pontos de P2 e P3: Arlindo, Bromnor, Brook, Erik, Leoric, Nyrelia, Zynara, Korrak, Maelor, Sylas e Kayron nas cinco tiras em uso (`e`/`se`/`s`/`n`/`ne`); Durvall `e`/`se`/`s`/`w`/`n`.

## L1b · folha de contato (2026-10-21, somente leitura)

Geradas por `contact_sheet.gd` e `specks.gd` (Godot headless fora do projeto; nada do jogo alterado), em `.atena/generated/hero-walk-fix-20261021/contact-r1/`:
- `<herói>.png`: uma folha por herói, como o jogo mostra. Linhas: e, se, s, sw, w, nw, n, ne. Colunas: quadros da tira. **Barra laranja no topo = virada por espelho** (sw, w, nw; Durvall não tem, usa tira real). Linha amarela = base dos pés do idle. Todos os heróis na mesma escala de pixel da arte.
- `overview-1.png` (Arlindo, Bromnor, Brook, Durvall, Erik, Kayron) e `overview-2.png` (Korrak, Leoric, Maelor, Nyrelia, Sylas, Zynara): um quadro por direção, heróis em linhas, direções em colunas na mesma ordem.
- `korrak-n-fundo-claro.png`: checagem da cabeça do Korrak de costas.
- `specks-r1.json`: pontos soltos por quadro.

O que vi (olhei as folhas de Brook, Zynara, Korrak e Kayron; os outros oito só nas visões gerais):
- **Orientação correta.** `e` olha para a direita e as viradas espelhadas olham para a esquerda. Nenhuma inversão.
- **O espelho troca a mão do objeto.** O objeto de uma mão só vai para a mão oposta ao virar para oeste: maça do Brook, ampulheta da Zynara e, nas visões gerais, cajado de Leoric, chama de Maelor e tocha de Erik. No Korrak o machado é de duas mãos e o espelho fica natural. Nenhum erro de arte; é a escolha da Frente 1 de L2.
- **Brook confere com o retrato** (halfling, cabelo branco, capa vermelha, maça). Não há desvio de identidade nas tiras dele; o texto de `ART-PROMPTS-016` ("jovem, barba castanho-escura") é que está desatualizado.
- **Korrak de costas tem cabeça**; só é escura contra o fundo do jogo. Não é defeito.
- **Passada estática confirmada à vista:** Zynara `se` e `s` quase não mudam entre quadros. Kayron `s` e Brook `s` parecem parecidos entre si, mas não medi (não estavam no corte da métrica de P3). Entram em P3 como "a verificar em jogo".
- **Pontos soltos** (componentes ≤ 120 px fora do corpo, nas tiras em uso): Erik 51 (todas as tiras; provavelmente brasas da tocha, a confirmar), Maelor 20 (`s` e `se` em todos os quadros, `e`, `n`), Sylas 7, Kayron 5, Leoric 4, Brook 3, Nyrelia 3, Bromnor 1, Korrak 1; Arlindo, Durvall e Zynara 0. São resíduo de geração visível ao lado dos pés; só Maelor (`s`/`se`) e Sylas/Kayron (`e`/`se`) têm padrão repetido.

## L2 · proposta por herói (2026-10-21, nada executado; aguarda aprovação)

Critério (recomendação aprovada): manter o espelho onde o herói é simétrico ou o objeto de mão tem pouco peso; propor correção só onde o espelho troca a mão de um adereço de identidade. Folhas vistas individualmente: Brook, Zynara, Korrak, Kayron, Erik, Maelor, Sylas. Arlindo, Bromnor, Leoric e Nyrelia só nas visões gerais (confiança menor).

| Herói | Oeste | Proposta |
|---|---|---|
| Arlindo | espelho | **Manter.** Casaco e chapéu, nada na mão. |
| Bromnor | espelho | **Manter.** Dois martelos dourados, simétrico. Verificar `s` em jogo (P3). |
| Brook | espelho | **Manter.** A maça muda de mão, mas pende ao lado e pesa pouco. Verificar `s` (P3). |
| Durvall | real | **Sem mudança de oeste.** Verificar `nw`/`ne` em jogo (pé sobe 16–22 px, P2). |
| Erik | espelho | **Mudar (rota B): oeste real novo.** A tocha vai de uma mão à outra e a alça da espada nas costas troca de ombro. Tem a chama como identidade. Gerar `move_w/sw/nw` das tiras de leste e ligar em `REAL_WEST_WALK`/`WIDE_CELL_STRIPS`. Exige geração de arte. |
| Kayron | espelho | **Manter.** Capa e figura simétricas. A arte de oeste parada é a mesma figura, mas desnecessária; fica parada. Limpar 5 pontos soltos em `e` (opcional). Verificar `s` (P3). |
| Korrak | espelho | **Manter.** Machado de duas mãos, o espelho fica natural. A arte de oeste parada é outra figura: não usar. |
| Leoric | espelho | **Manter.** Cajado ereto; peso baixo. 4 pontos soltos em `e`/`se` (opcional). |
| Maelor | espelho | **Decidir (rota C): ligar o oeste parado normalizado.** A chama muda de mão. A arte de oeste parada é a mesma figura e mostra a chama à frente, melhor que o espelho. Precisa reduzir ×1,1–1,23, fixar a âncora dos pés e refatiar os quadros (recorte em `sw`/`nw`). Sem geração de arte. Se o dono preferir, manter o espelho. Limpar pontos soltos (20) em `e`/`s`/`se`/`n`. |
| Nyrelia | espelho | **Manter.** Figura encapuzada simétrica, sem objeto de mão visível. |
| Sylas | espelho | **Manter.** Adagas nas duas mãos, simétrico. A arte de oeste parada fica parada (cruza a borda da célula). **Verificar `s`** (quase estática, P3): se confirmar, refazer a tira. Limpar 7 pontos soltos. |
| Zynara | espelho | **Opcional (rota B), baixa prioridade.** A ampulheta e a bolsa do quadril trocam de lado. Prioridade maior: `se` e `s` quase estáticas à vista; refazer essas duas tiras. |

### Trabalho agrupado (para o lote 3, se aprovado)

1. **Sem arte nova (barato):** limpar pontos soltos e, em Maelor, normalizar o oeste parado (`tools/asset_prep.gd`); ajustar fps/passo pelo laboratório de passada onde a verificação em jogo pedir.
2. **Verificação em jogo antes de qualquer arte (decisão sua):** `s` de Bromnor, Brook, Kayron e Sylas, `n` de Maelor, `nw`/`ne` de Durvall, `se`/`s` de Zynara.
3. **Arte nova (só com aprovação de geração):** Erik oeste real (prioridade), Zynara `se`/`s` e, opcional, Zynara oeste real.
4. **Arte parada:** Korrak `move_w/sw/nw` (outra figura), Kayron e Sylas `move_w/sw/nw` seguem sem uso. Nenhuma remoção sem aprovação.

Qualquer ligação nova exige portagem registrada e checks nos dois projetos. Aceite visual humano (H-PORT-002) continua pendente.

## Regras que valem

- Dado comum de herói/arma exige portagem registrada e checks nos dois projetos (`AGENTS.md`). Tiras de herói são comuns: L3 só termina com portagem registrada.
- Sem geração de arte, commit, push ou publicação sem aprovação explícita.
- Testes com diretório sintético isolado; jamais carregar o save real.
- Aceite visual humano (H-PORT-002) segue pendente; nada aqui promove arte a canônica.
