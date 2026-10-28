# CODEX-SOURCES-20261027-r1 · S-C01 · inventário de fontes (heróis)

Escopo desta rodada: os 12 heróis. Inimigos entram no S-C03, por lote. Fonte: `F:\dev\nottgard-vault` (somente leitura). Regra de sigilo: seções "Cânone reservado ao mestre", "Lore canônico não revelado" e "História pessoal — revelação ao grupo não registrada" não entram no texto.

## Fontes por herói

| Herói | Arquivos do Vault | Material | HQs do jogo em que aparece (por nome no texto) | Arma inicial (`heroes.json`) |
|---|---|---|---|---|
| durvall | `02_Personagens/Durvall.md`; `06_Itens/Livrinho`; `12_Lore/Carta sobre o Messias` | médio, mas quase tudo sensível | hqn_01, hqn_21 | espada_sombria |
| brook | `02_Personagens/Brook França.md`; `06_Itens/Carta de Bromnor para Brook`, `Carta de Trégua de 1400` | bom | hqn_19, hqn_21 | sentenca_de_lliira |
| maelor | `02_Personagens/Maelor.md`; `06_Itens/Ampulheta do Silêncio Eterno`, `Diário de Manutenção das Gárgulas`, `Luz Mais Pura de Thalion` | bom | hqn_19, hqn_20 | raio_de_luz |
| sylas | `02_Personagens/Sylas Malafaia.md`; `06_Itens/Colar de visão verdadeira do Santuário` | bom | hqn_02, hqn_14, hqn_18 | raio_enfraquecedor |
| kayron | `02_Personagens/Kayron.md`; `06_Itens/Broche Celestial`, `Poção de Sopro de Fogo` | bom | hqn_02, hqn_16, hqn_19 | descarga_estelar |
| korrak | `02_Personagens/Korrak.md` + `03_NPCs/Korrak.md`; `06_Itens/Machado de Xar'gath`, `Luneta de Korrak` | bom, sem trecho reservado | hqn_06, hqn_19, hqn_20 | machado_de_xargath |
| leoric | `02_Personagens/Leoric.md` + `03_NPCs/Leoric.md`; `06_Itens` (Anel da Resistência Abissal) | bom, 1 trecho reservado (portal ritual) | hqn_03, hqn_16, hqn_19, hqn_20 | sopro_de_estrela |
| nyrelia | `03_NPCs/Nyrelia.md`; `05_Organizações/Grimholders.md` | **fraco** (pontos em aberto declarados no próprio Vault) | hqn_14 | dominar_pessoa |
| zynara | `03_NPCs/Zynara.md`; `12_Lore/Família Vellen.md`; `06_Itens/Relatório de Zynara…`, `Plantas do Túmulo` | médio | hqn_01, hqn_21 | ampulheta |
| bromnor | `03_NPCs/Bromnor Martelo da Luz.md`; `06_Itens/Diário Vinculado de Bromnor`, `Um breve conto sobre Bromnor…`, `Carta de Bromnor para Brook`, `Martelo da Glória` | muito bom | hqn_11, 16, 18, 19, 21 | martelo_da_gloria |
| arlindo | `03_NPCs/Arlindo Orlando.md`; `05_Organizações/Grimholders.md`; `04_Locais/Dagruve.md` | médio | nenhuma por nome (conferir se aparece sem nome na arte) | memoria_alterada |
| erik | `03_NPCs/Erik Blackthorn.md`; `06_Itens/Amuleto da Luz`, `Lâmina da Digestão` | curto | hqn_15, hqn_17, hqn_21 | tocha_do_incendiario |

Contagem de HQs foi feita por nome no texto dos painéis (`data/hqs.json`); aparição só na arte, sem nome, não foi medida.

## Trechos excluídos (cânone do mestre ou conhecimento do grupo duvidoso)

| Herói | Fica de fora | Motivo |
|---|---|---|
| durvall | Ser o receptáculo de Ghaunadaur, o termo "Receptáculo", passado como capitão do 3º Batalhão de Thalion, aliança com Thalion (S10), escritório na Biblioteca Luminaris, o sobrenome Gellad, a Síntese Abissal (S23–24) | cânone do mestre / segredo do Durvall (AGENTS e SPEC de retratos). **Astherion também fica de fora**: ligar a armadura dele à armadura negra do Durvall insinua o segredo. |
| maelor | Infância em Dagruve e preconceito (história pessoal reservada) | a bio atual já diz "cresceu em Dagruve"; marcar para revisão do dono (D-2) |
| kayron | Infância no Morro Zapomoni, asas brancas, ordem de Shar para se lançar, relatório de 1688 | reservado ao mestre |
| sylas | Dominar Durvall (S23) | revela o estado do Durvall |
| leoric | Ter cruzado o portal sob controle ritual; domínio por Ghaunadaur (S23–24) | "não marcado como revelado" / spoiler do arco final |
| brook | Raça halfling | **não é cânone de campanha**: vem da decisão do Survivors CHARACTER-IDENTITY-003; o Vault diz que raça e idade exata não são estabelecidas no recorte inicial (a idade foi fixada depois: 53 em 1690) |
| bromnor | Autoria do Amuleto da Luz | retificação DEC-AMULETO-ARANIS-20261018-r1: o original é de Sylvaris e Frank Blackthorn |
| arlindo | Qualquer coisa de "Arlindo Ruckus" | outro personagem (pai adotivo de Paulo, Rodhe's Bridge) |
| erik | Parentesco com Frank/Bárbara Blackthorn | não verificado no Vault |
| zynara | Visão S9-08 (Zynara jovem prometendo ajudar Thalion a "reivindicar a estrela") | conhecimento do grupo, mas muda a leitura da personagem; ver D-4 |

## Divergências entre o jogo e o Vault

| # | Onde | Jogo diz | Vault diz | Sugestão |
|---|---|---|---|---|
| V-1 | `heroes.json` título do Brook; bio do Brook | Halfling | Raça não estabelecida em campanha; halfling é decisão do Survivors | Manter no jogo; na curiosidade dizer "no Survivors" ou omitir |
| V-2 | bio do Leoric | "uma cartola que nunca perde"; "fama de azarado" | Terno marrom com detalhes pretos; sem cartola nem fama de azarado | Conferir a arte; se a cartola é do jogo, manter; se não, tirar da bio (decisão do dono) |
| V-3 | bio da Zynara | "a Ampulheta é do grupo; no campo, é ela quem a empunha" | Vault: posse da Ampulheta não atribuída a ninguém (atrai Maelor na biblioteca) | Confirmar que é regra do jogo, não fato |
| V-4 | bio do Kayron | "voltou lá uma única vez: para acender o fogo" | S11 do Vault confirma o incêndio, mas "uma única vez" não está escrito | Trocar por "voltou para acender o fogo" |
| V-5 | bio do Maelor | cresceu em Dagruve | trecho reservado | ver D-2 |
| V-6 | bio do Bromnor | "forjou o martelo com uma lasca de Ailalore" | S11: caderno achado na Igreja das Sombras; bate | Sem mudança |

## Mecanismo de liberação (sem mexer no save)

Cada curiosidade carrega `req`:

| `req` | Libera quando | Fonte no código |
|---|---|---|
| `base` | herói liberado (`hero_unlocked`) | `core/profile.gd` |
| `bio` | biografia liberada (vencer uma fase com o herói) | `hero_bio_unlocked` |
| `hq:<id>` | HQ já vista (`hqs_seen`) | `core/profile.gd` `mark_hq_seen` |

A morte do Bromnor já é dita pelo próprio jogo na hqn_11 ("Bromnor virou luz."), então os fatos dele sobre isso ficam atrás de `hq:hqn_11`, não omitidos.

## Pendências para o dono

D-1 Aceitar a regra de liberação acima. D-2 Maelor: manter ou tirar "cresceu em Dagruve". D-3 Resolver V-2 e V-3. D-4 Zynara/Thalion (visão S9-08) entra ou não. D-5 Kayron: o sacrifício dos três rebeldes a Shar (S6) entra como curiosidade ou fica fora por tom. D-6 Fatos do fim do arco (S24) entram atrás de `hq:hqn_21`? Afeta Brook (eleito Conselheiro), Sylas (Baralho de Muitas Coisas), Korrak (aspirante a oficial), Zynara e Arlindo (partem juntos).
