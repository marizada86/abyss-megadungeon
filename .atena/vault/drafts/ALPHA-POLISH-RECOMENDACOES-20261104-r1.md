# Recomendações de polimento para o Alpha Demo (DRAFT r1, 2026-11-04)

Estado: rascunho de análise. **Nada foi aplicado no jogo** além do que está em `ALPHA-CHECKUP-20261104-r1.md`. Cada recomendação diz o custo, o risco e o que exige decisão sua.

## 0. Como ler este documento e o que é evidência

- **Dados do próprio jogo** (bots, código, dados): medidos, com número. Seção 1.
- **Pesquisa de mercado**: as buscas na web foram fracas (blogs genéricos, páginas de loja, pouca análise de autor). Só o que está listado em "Fontes" abaixo foi confirmado por uma fonte. O restante da seção 2 é **conhecimento geral meu sobre os jogos do gênero** (Vampire Survivors, Brotato, Hades, Halls of Torment, Deep Rock Galactic: Survivor, Death Must Die) e deve ser lido como hipótese de design, não como fato verificado agora.
- **Bots não são jogadores.** Eles medem pressão e piso de sobrevivência, não diversão. Qualquer conclusão de "difícil demais" precisa de playtest humano.

## 1. Varredura de bots (168 trabalhos, 12 heróis × 11 mapas × 3 sementes)

Método: cópia congelada do código às ~05:00 de 04/11 (`tmp/base-alpha-20261104`, para as sessões ativas não contaminarem), perfil sintético isolado, `dt` 0,05. Imortal (`smart-god`) mede pressão com nível de referência por mapa e Quartel cheio (mapas 4–11); mortal (`smart`) só nos 3 mapas do capítulo 1, sem Quartel, nível inicial 1/5/10.
Resultados brutos: `.atena/generated/balance-bots-20261018/results/a4-*.jsonl`; agregação: `aggregate-alpha.js`.

Tabela completa (por mapa, por herói, desfechos): [a4-aggregate.md](../../generated/balance-bots-20261018/results/a4-aggregate.md). Os 168 trabalhos terminaram sem erro de script.

**Nota de método.** Na última fase (Os Pilares) o bot não detecta `final_victory`; por isso a partida aparece como `timeout` aos 660 s mesmo depois de o chefe morrer. Conto vitória = chefe morto, como na auditoria anterior. Confirmei no código (`core/battle.gd`, `final_victory`) que isso é limite do bot, não defeito do jogo.

### 1.1 O que os números mostram (imortal, 396 partidas)

| Mapa | Vitórias | Dano/min | PV mínimo médio | Leitura |
|---|---:|---:|---:|---|
| Docas | 34/36 | 669 | 34% | 2 timeouts (Arlindo, Brook), sem Quartel e nível 1 |
| Reino Abissal | 32/36 | 515 | 26% | 4 timeouts (Arlindo, Maelor, Nyrelia, Sylas) |
| Domwieck | 36/36 | 1 080 | 30% | pico de pressão do capítulo 1, em 180 s |
| Dagruve | 36/36 | **41** | **87%** | trivial no nível de referência (24) |
| Shedaklah | 36/36 | 241 | 67% | |
| Molor | 36/36 | 507 | 53% | |
| Durao | 36/36 | 476 | 30% | |
| Feng-tu | 36/36 | 925 | 18% | |
| Shendilavri | 36/36 | 1 526 | 13% | |
| Goranthis | 35/36 | 2 059 | **1%** | o imortal quase zera o PV |
| Pilares | **13/36** | 3 136 | **0%** | só aqui o bot deixa de vencer |

Achados, em ordem de importância:
1. **Rampa de pressão muito íngreme no fim.** De Feng-tu (925) a Pilares (3 136) o dano por minuto triplica, e o PV mínimo cai para 1% e 0% em Goranthis e Pilares, mesmo com nível 40–46 e Quartel cheio. Um humano sem essa build vai morrer muito nesses dois mapas. Pode ser o desejado (chefe final duro), mas **não está validado por humano**.
2. **Dagruve é quase um passeio** (87% de PV mínimo, 41 dano/min) no nível de referência. A auditoria já apontava Dagruve como o mapa mais sensível ao nível; se na campanha real o jogador chegar com nível bem menor que 24, vira outro mapa. Precisa de uma partida humana encadeada Docas→Reino→Domwieck→Dagruve para ver o nível real de chegada.
3. **Desigualdade entre heróis nos mapas finais.** Dano por minuto em Goranthis: Zynara 814, Bromnor 1 294, Erik 1 314, Korrak 1 338 contra Leoric **3 395**, Brook 2 578, Arlindo 2 886. Em Pilares, Erik venceu 3/3 e Bromnor/Korrak 2/3, enquanto Durvall, Maelor e Arlindo fizeram 0/3. Totais: Erik 33/33 e Arlindo 28/33. Os dois extremos são justamente os heróis cuja arma inicial ganha evolução no plano em andamento (Memória Alterada e Tocha do Incendiário), então **a sessão de evoluções vai mexer neste quadro**. **Correção na 1.1b:** com 6 sementes por célula o destaque de Erik desaparece (era ruído de 3 sementes); só Zynara (forte) e Arlindo/Nyrelia (fracos) se sustentam.
4. **Mortais** (só Docas, Reino, Domwieck, sem Quartel, níveis 1/5/10): 108/108 morrem, em 54 a 82 s. Isto repete a conclusão da auditoria anterior: o bot mortal não desvia e não discrimina. Não prova que a primeira partida humana seja dura, mas também não prova que seja boa: **a primeira partida humana em Docas é o teste mais importante do alpha**.
5. **Heróis fortes e fracos no capítulo 1** (imortal sem Quartel): Arlindo falha em Docas e Reino; Nyrelia, Sylas, Maelor e Brook falham uma vez cada. Nada grave, mas Arlindo é o herói mais frágil no começo.

### 1.1b Rodada de sensibilidade (864 partidas imortais, 6 sementes por célula)

Shendilavri, Goranthis e Pilares com o nível de referência −8, −4 e 0, Quartel cheio, mais o nível de referência **sem Quartel**. Tabela completa: [a5-aggregate.md](../../generated/balance-bots-20261018/results/a5-aggregate.md).

| Mapa | nível −8 | nível −4 | nível ref. | ref. sem Quartel |
|---|---:|---:|---:|---:|
| Shendilavri | 97% | 100% | 99% | 88% |
| Goranthis | 82% | 88% | 97% | **60%** |
| Pilares | 28% | 39% | 31% | **8%** |

(Percentual de partidas em que o chefe morre. Com 72 partidas por célula, a margem é de ±5 a 10 pontos.)

Leituras:
1. **O Quartel pesa muito mais que o nível.** Em Goranthis, tirar o Quartel derruba de 97% para 60%; em Pilares, de 31% para 8%. Variar o nível em 8 pontos muda bem menos.
2. **Pilares não responde ao nível** (28% → 39% → 31%, dentro do ruído). A parede ali parece ser mecânica do chefe/pressão, não força da build. O PV mínimo é 0% em todas as configurações.
3. **Economia do Quartel (alerta).** O custo para maximizar o Quartel soma ≈ 229 mil de ouro (`data/upgrades.json`, 18 melhorias); uma campanha inteira rende em média ≈ 3,6 mil de ouro de partida pelos bots (soma dos 11 mapas). Isso é ordem de **60 campanhas** para o Quartel cheio. A unidade do ouro de partida pode diferir da moeda que entra no Quartel (a conversão usa `meta_coin_exponent`), então trate como ordem de grandeza, mas o aviso é claro: **os números "Quartel cheio" acima são o teto**. O amigo testador que chega em Goranthis na primeira campanha estará mais perto da coluna "sem Quartel" (Goranthis 60%, Pilares 8% para um bot imortal).
4. **Desigualdade entre heróis** com 6 sementes por célula: Zynara é a mais robusta nos mapas finais (3/6 em Pilares até sem Quartel); Nyrelia, Arlindo, Brook e Durvall são as mais fracas em Pilares. Com a amostra maior, o destaque de Erik na primeira rodada some (era ruído); a conclusão sobre "extremos" fica apenas para Zynara (forte) e Arlindo/Nyrelia (fracos).

### 1.2 Ações sugeridas a partir dos dados (nenhuma aplicada)
- **A0 (decisão sua, a mais importante).** Que build o jogador da demo deve ter ao chegar em Goranthis/Pilares? Três saídas: (a) aceitar que a demo é difícil no fim e dizer isso no LEIA-ME; (b) conceder ouro/Quartel inicial na demo (ex.: bônus de ouro por mapa ou um pacote básico de Quartel liberado ao vencer Dagruve); (c) diminuir `hp_mult`/`dmg_mult` dos dois últimos mapas. Recomendo **(a)+(b) leve**, só depois do playtest humano de Shedaklah a Durao, e não (c) às cegas.
- **A1 (decisão sua).** Se o playtest humano confirmar que Goranthis e Pilares são brutais, a alavanca mais barata é um multiplicador por mapa em `data/stages.json` (`hp_mult`/`dmg_mult`), −10% a −15% como primeiro passo; ou deixar assim e deixar o jogador usar as Marcas e o nível de dificuldade. Não mudar antes do playtest.
- **A2.** Repetir esta varredura **depois** que a sessão de evoluções terminar (comando abaixo). É a verificação objetiva de que Arlindo e Erik ficaram dentro do intervalo dos demais.
- **A3.** Playtest humano encadeado do começo da campanha (Docas → Dagruve) anotando o nível ao chegar em Dagruve.
- **A4.** Se Docas matar o jogador novo em ~80 s, suavizar só Docas (PV inicial ou dano dos primeiros 60 s) e não os mapas seguintes.

Reexecução idêntica da varredura (≈ 15 minutos no PC atual, 5 processos em paralelo; cria a cópia do código no momento):
```bash
# 1) cópia congelada do código atual
R=/f/dev/abyss-megadungeon; S=$R/tmp/base-alpha-NOVA; rm -rf "$S"; mkdir -p "$S"
cp -r $R/core $R/data $R/ui $S/; cp $R/project.godot $R/export_presets.cfg $R/icon.svg $R/icon.svg.import $S/
for d in .atena .godot assets tests tools; do cmd //c "mklink /J $(cygpath -w $S/$d) $(cygpath -w $R/$d)" >/dev/null; done
# 2) trocar o caminho da cópia no arquivo de trabalhos e disparar
cd $R/.atena/generated/balance-bots-20261018
sed -i "s#base-alpha-20261104#base-alpha-NOVA#; s#a4-#a5-#g" jobs-alpha.txt
bash launch-alpha.sh
```
(depois ajustar `a4-` para `a5-` em `aggregate-alpha.js`, ou manter `a4-` e arquivar os resultados antigos antes).

## 2. O que o gênero faz bem e o que o jogo já tem

Já presente no Abyss (verificado no código/dados): ofertas ao subir de nível com rerrolagem e pular; evoluções de arma por passiva; passivas; heróis com habilidade ativa (Q); chefes com mecânicas de raide e telégrafo; elites com afixos; extrair-ou-descer; quartel com metaprogressão; "Marcas do Abismo" (dificuldade opcional em 9 eixos, equivalente ao Heat do Hades e aos Danger do Brotato); Favor divino (bênção/maldição com deuses rivais); conquistas, medalhas, segredos; acessibilidade (escala, contraste, modos de cor, impacto reduzido, teclas remapeáveis); dicas de primeira vez.

Lições do gênero que valem confrontar (itens marcados **[F]** têm fonte; os demais são conhecimento geral):

| # | Lição | Onde o jogo está | Recomendação |
|---|---|---|---|
| G1 | **Escada de dificuldade desbloqueada por vitória** **[F]** (Brotato: Danger 0→5, cada nível herda o anterior e abre ao vencer) | Marcas do Abismo existem, mas dependem de conquistas por marca; há também "dificuldade" 0..n no perfil | Para o alpha: mostrar no resultado da campanha "Marca X liberada" de forma explícita e deixar claro o que cada marca multiplica. Pós-alpha: considerar um seletor único "Perigo 0–5" que ativa pacotes de marcas |
| G2 | **Aleatoriedade limitada à corrida** **[F]** (Hades: bênçãos duram só a corrida, o que sustenta rejogabilidade) | Igual: build zera a cada tentativa | Manter. Garantir que o texto da tela de derrota reforce "o que fica" (ouro, conquistas, marca liberada) |
| G3 | **Sinergias multiplicativas descobertas pelo jogador** **[F]** (Brotato/RoR2: empilhar o mesmo tipo de atributo) | Evoluções por passiva + 43 armas; 13 sem evolução (plano em andamento) | Concluir as evoluções (sessão em andamento) e dar uma dica visual de "esta passiva evolui sua arma X" na carta de oferta quando a arma já está no Nv 5. A ficha já mostra "pronta para evoluir" |
| G4 | **Reduzir ruído na reta final** **[F fraca]** (queixa comum em survivors: "os últimos minutos parecem iguais") | Auditoria de ritmo reduziu mapas em 16–35%; roster de inimigos estático após 36–50% do mapa | A redução de tempo já ataca isso. Falta variar o roster na segunda metade dos mapas longos (pendência da auditoria) |
| G5 | **Seleção de itens com controle do jogador** (travar, banir, rerrolar — Brotato/Vampire Survivors) | Rerrolar e pular existem; não há banir nem travar | Banir/travar é mecânica nova (custo médio, risco médio no equilíbrio). **Não para o alpha**; registrar como candidata |
| G6 | **Feedback de dano legível** (todos os survivors lidam com tela cheia de efeitos) | Já tem `damage_feedback`, `danger_feedback`, `hurt_vfx`, "impacto reduzido" | Playtest em janela real em Pilares/Goranthis (item B5 do checkup) |
| G7 | **Primeira corrida curta e perdoável** | Docas (180 s) e Reino Abissal/Domwieck (180 s) abrem a campanha; dicas de primeira vez existem | Ver resultados dos bots: se a taxa de morte do mortal em Docas/Reino/Domwieck for alta com nível 1/5/10, suavizar só Docas (+vida do herói ou −dano inicial) e não os mapas seguintes |
| G8 | **Heróis com identidade clara na escolha** | 12 heróis, retratos, ficha, bio | Conferir se os 12 têm diferença de desempenho muito grande (tabela de vitórias por herói acima) e não deixar um herói inútil na demo |
| G9 | **Fecho de progressão visível** (barra da campanha, "falta N mapas") | Mapa da campanha/Quartel existe | Playtest: conferir se o jogador sabe qual é o próximo mapa e quantos faltam |

## 3. Recomendações visuais e de apresentação (para a demo)

Todas baixas em risco; nenhuma exige código novo de combate.
1. **Primeira impressão.** Tela de título, primeira HQ e Quartel são o que o amigo vê antes de jogar. Conferir em 1366×768 e 1920×1080 que nada corta (o jogo foi medido em 1366×768 em Docas). Custo: 20 min seus.
2. **Telégrafo dos chefes** (anel de cast, tecla remapeada, som) já entrou na 0.5.2. Os prompts dos golpes temáticos (sessão ativa) e a pedra rúnica de Durao estão em rascunho; **não integrar para o alpha** sem aceite visual, ficam como "pós-alpha".
3. **Assets pendentes que mais aparecem na tela**: ícone de regra da fase no HUD (3 mapas sem ícone), quebráveis temáticos do Reino Abissal e Domwieck (usam arbusto de fallback), animações de Molydeus menor e das ilusões. São as três lacunas mais visíveis; nenhuma impede jogar. Se houver tempo de gerar, essa é a ordem.
4. **Áudio**: Reino Abissal, Domwieck e Pilares reaproveitam música. É o maior ganho de atmosfera por custo; fora do alcance desta noite.
5. **Texto de ajuda do alpha.** O LEIA-ME da build de Produção deve dizer em uma linha o que testar e como relatar (F5/F6 não existem na Produção): definir o canal de retorno (mensagem direta, formulário) antes de enviar.

## 4. O que NÃO recomendo mudar antes do alpha
- Novas mecânicas (banir/travar, novos eixos de dificuldade, novos tipos de chefe): risco alto, sem playtest humano para calibrar.
- Reescrever números de equilíbrio com base só em bots (eles "morrem 100%" nos mapas finais).
- Qualquer renomeação de IDs.

## Fontes
- Brotato, escada de Danger 0–5, cumulativa e liberada por vitória: [Brotato Wiki – Dangers](https://brotato.wiki.spellsandguns.com/Dangers) e [guia de Danger 5](https://gameplay.tips/guides/brotato-danger-5-guide.html).
- Hades, bênçãos aleatórias que duram só a corrida e sustentam a rejogabilidade: [The Gamer](https://www.thegamer.com/hades-boon-replay-escape/).
- Brotato, loja com travar/rerrolar: [Brotato Wiki – Shop](https://brotato.wiki.spellsandguns.com/Shop).
- Queixa de repetição na reta final em survivors (fonte fraca, opinião de usuários): [Grind Survivors review](https://www.indie-games.eu/?p=40125).
- As buscas sobre Vampire Survivors (evoluções, banir, rerrolar), Halls of Torment e Death Must Die não retornaram análise de design utilizável; tudo o que digo sobre eles é conhecimento geral, sem fonte.
