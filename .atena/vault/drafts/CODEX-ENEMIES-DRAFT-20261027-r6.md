# CODEX-ENEMIES-DRAFT-20261027-r6 · S-C03b · lote 6: Pilares, Reino Abissal, Domwieck e sem fase (aguardando aceite)

Último lote. Fontes lidas: `07_Criaturas/A Síntese Abissal`, `Master of Cruelties`, `Death Tyrant`, `12_Lore/Ghaunadaur`, `04_Locais/Templo de Ghaunadaur`, `12_Lore/Pilares Ativos e Plano Abissal`, a nota de Nidhogg nos dados do jogo, e o texto das HQs `hqn_10` e `hqn_20`.
`req`: `base` (visto), `hq:<id>`. `[jogo]` = sem lastro no Vault. Os comuns a Reino Abissal e Domwieck (notívago, cultistas, criatura corrompida) já estão nos lotes 1 e 2; só o Death Tyrant é exclusivo do Reino Abissal.

## Cuidado de sigilo (decisão Sy-1, abaixo)
O Vault diz que a Síntese Abissal nasce da fusão de Durvall com a armadura de Astherion. O jogo, na HQ `hqn_10`, mostra só "A Síntese Abissal." e preserva o segredo do Durvall. Este rascunho segue o jogo: **a origem da Síntese não aparece**. Também ficam de fora Astherion, o Colar de Ghaunadaur como selo, Adam e a razão pela qual Ghaunadaur precisava de Ailalore.

## Pilares

### Fanático de Ghaunadaur — `cultista_ghaunadaur` · Feng-tu, Shendilavri, Pilares
**Quem é.** Seguidor de Ghaunadaur. A rede de cultos que o segue se estende pelas camadas do Abismo por onde corre o Rio Estige.
1. `base` Um livro que Sylas leu descreve Ghaunadaur como muito antigo, anterior a muitos deuses e quase primordial. — *12_Lore/Ghaunadaur, Sessão 03*
2. `base` Ghaunadaur domina também animais e criaturas normalmente independentes, como Ezro e Shu. — *12_Lore/Ghaunadaur*
3. `base` Quem usa o Colar de Ghaunadaur é dominado pela consciência dele. — *12_Lore/Ghaunadaur, S7-04*

### Crueldades — `master_of_cruelties` · Pilares
**Quem é.** Criatura encontrada no ritual do Castelo da Fome. Fala Abissal, voa e enfeitiça com uma presença cativante.
1. `base` Afirmou que o grupo a usava para invadir a casa do mestre dela, que ainda teria um mestre próprio. — *07_Criaturas/Master of Cruelties, Sessão 23*
2. `base` É imune a fogo e resistente à maior parte dos danos. O dano radiante é eficaz. — *07_Criaturas/Master of Cruelties*
3. `base` O grupo a matou ali mesmo, na Sessão 23. — *07_Criaturas/Master of Cruelties*

### A Síntese Abissal — `sintese_abissal` · Pilares (chefe)
**Quem é.** Monstruosidade grande e aberrante, a última do primeiro arco. Ocupa quatro espaços no grid.
1. `base` Resiste a dano psíquico e a armas não mágicas, e é imune a Enfeitiçado e Amedrontado. Só o dano radiante a fura. — *07_Criaturas/A Síntese Abissal*
2. `hq:hqn_10` Carrega a presença de Ghaunadaur, que causa medo em área, e invoca e absorve slimes. — *07_Criaturas/A Síntese Abissal*
3. `hq:hqn_10` Usou as runas do salão para erguer o Castelo da Fome à superfície. — *07_Criaturas/A Síntese Abissal*
4. `boss` Foi derrotada sem nenhuma morte entre os personagens-jogadores. A última gota de Slime deixou a cabeça de Ailalore, que acordou livre. — *07_Criaturas/A Síntese Abissal*

## Reino Abissal

### Death Tyrant — `death_tyrant` · Reino Abissal
**Quem é.** Forma criada quando o cadáver de Kein se fundiu ao de um Beholder, depois do ritual no Reino Abissal.
1. `base` O grupo o destruiu, e o martelo de Bromnor deu o golpe final. — *07_Criaturas/Death Tyrant; 03_NPCs/Bromnor, Sessão 12*
2. `hq:hqn_11` Bella apontou Kein como o assassino de Bromnor, disfarçado de Guarda Celestial. — *Sessão 09, S9-31*
3. `base` Kein desprezava os traços élficos de Maelor e não agradeceu quando ele o escoltou ao Conselho. — *02_Personagens/Maelor, Relações*

## Sem fase

### Nidhogg — `nidhogg` · sem fase
**Quem é.** Criatura enorme numa raiz de Yggdrasil, à qual a mesa não deu nome.
1. `base` Mordeu Maelor gravemente quando ele caiu isolado numa passagem pela raiz. — *Sessão 15*
2. `hq:hqn_20` Maelor escapou em direção a um portal e, mais tarde, reencontrou Marciela. — *Sessão 15*
3. `base` O nome Nidhogg é do jogo. A mesa só falou de “uma criatura enorme”. — *divergência entre o jogo e o Vault* `[decisão N-1]`

## Quebrável

| Id | Nome | Linha | Fonte |
|---|---|---|---|
| relicario_instavel_quebravel | Relicário Instável | Relicário dos Pilares. Quebra e não ataca. | jogo |

## Resumo para aceite

5 inimigos e 1 quebrável; 16 curiosidades (Fanático 3, Crueldades 3, Síntese 4, Death Tyrant 3, Nidhogg 3). Sem lastro (`jogo`): o relicário.

Decisões:
- **Sy-1:** a Síntese fica sem a origem (nada de Durvall nem de Astherion), seguindo o jogo. Se você quiser revelar a origem, é decisão sua, e eu pediria que ficasse atrás de uma HQ específica. Recomendo manter assim.
- **K-1:** a curiosidade sobre Kein ser o assassino de Bromnor fica atrás da HQ da Concórdia Eterna (`hqn_11`), como a morte do Bromnor nos heróis. Recomendo manter.
- **N-1:** a curiosidade "o nome Nidhogg é do jogo" fica? Mesmo padrão de Zuggtmoy, Shu e Ezro. Recomendo manter.
- Ao entrar no JSON, `relicario_instavel_quebravel` fecha os 12 quebráveis, e os 52 inimigos ficam todos com entrada.
