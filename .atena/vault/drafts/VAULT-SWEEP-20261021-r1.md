# Varredura Jogo × Vault — 2026-10-21 (r1)

Status: DRAFT. Somente leitura: nenhum arquivo do jogo ou do Vault foi alterado. Nada aqui é promovido a CANON; cada correção abaixo depende de aprovação (e, por AGENTS.md, de portagem registrada e checks nos dois projetos quando o conteúdo é comum).

Vault lido em `F:\dev\nottgard-vault` (HEAD `50008c9`, 2026-10-20). Decisões CANON relevantes: `DEC-CASTLE-SERVICE-001`, `DEC-PLANOS-CRONO-001` (r8–r14), `DEC-ELF-ERAS-001`, `DEC-SINTESE-PURPLE-20261019-r1`, `DEC-GUARDIAO-ORIGIN-004-r1`, `DEC-IDADES-*`, `DEC-ANO-DESGRACA-20261019-r1`.

## A. Inconsistências com o Vault (corrigir)

| # | Onde no jogo | Problema | Vault diz | Correção proposta | Gravidade |
|---|---|---|---|---|---|
| A1 | `heroes.json:11`, `achievements.json:35` (nome e desc de `bio_sylas`) | "Sylas **Malafas**" | "Sylas **Malafaia**" (376 ocorrências; só `16_Histórias/…Aluris.md:51` tem a grafia errada, e o próprio vault deve corrigir) | Trocar o nome de exibição. ID `sylas` fica. | Média (nome) |
| A2 | `hero_bios.json:4` (Brook) e `items.json:50` (Broche Celestial) | "**Guardiões de Nottgard**" | Título **retirado** (`DEC-CASTLE-SERVICE-001`, 18/10): o grupo está "a serviço de Castle Rodhe". Nem o broche nem a organização usam o nome. | Brook: "recomendado por ele para acompanhar o grupo a serviço de Castle Rodhe". Broche: "Emblema de quem serve a Castle Rodhe." | Alta (decisão do dono) |
| A3 | `hqs.json:339` (`hqn_13`, "O Cerco de Aluris") | "Eléstria, **ano 700**: um presente rasgou o céu" | S9-07: **ano 1400** (Calendário Comum). 700 é o início da era Rhenaveth e do ano élfico do cerco. | "Eléstria, ano 1400…" (ou data élfica explícita). `hqn_13` está em `removed_from_active_selection` (`chapter_flow.json`): corrigir se a HQ voltar. | Baixa (HQ inativa) |
| A4 | `hqs.json:347` (`hqn_13`) | "**Setenta** anos de cerco" | `DEC-PLANOS-CRONO-001` r8: **78 anos** (1400–1478); "cerca de setenta" foi sucedido. | "Setenta e oito anos de cerco…". Mesma ressalva: HQ inativa; checar se o texto está dentro da imagem. | Baixa (HQ inativa) |
| A5 | `hqs.json:601` (`hqn_20`, "Entre Raízes") | "Nidhogg tentou mordê-lo. **Não conseguiu.**" | S15 e `Maelor.md`: Maelor "sofre uma **mordida grave**" de uma "criatura enorme". "Nidhogg" só existe como referência visual DRAFT (`CNCR-r02/nidhogg`), sem nota de texto. | Trocar para "mordida grave" (ou manter a criatura sem nome). Nomear Nidhogg é decisão do dono. | Média |
| A6 | `data/stage_story.json:15` (Docas) | "o Guardião Alado **não tem página no Vault**" | `10_Sessões/Sessão 02` e `16_Histórias` registram o guardião alado (primeira cópia derrotada; o verdadeiro deixa sangue negro). `DEC-GUARDIAO-ORIGIN-004` promoveu os sprites verdadeiro e cópia a CANON. | Atualizar `fonte_chefe` para "Sessão 02" e fechar a pendência SPEC-117. | Baixa (texto de fonte) |
| A7 | `items.json:43 e 53` (`colar_dos_tentaculos` e `olho_de_ghaunadaur`) | Dois itens distintos | `Olho de Ghaunadaur` é **o mesmo objeto** que o Colar dos Tentáculos (nome dado pela mesa na S14; 9 usos de invocação). Não é o Colar de Ghaunadaur de Sylvaris nem o colar de visão verdadeira do Santuário. | Fundir (manter um item, `note` já diz "Também chamado Olho de Ghaunadaur") ou renomear o segundo para algo sem vínculo canônico. | Média |
| A8 | `data/enemies.json:1200` | "Master of Cruelties" | Título da nota: "**Crueldades**" (alias: Master of Cruelties). | Exibir "Crueldades" (alias no códex). | Baixa |
| A9 | `assets/enemies/sintese_abissal.png` | Sprite de **tronco fúngico com asas** e sinos | Canon: armadura preta/dourada, energia **roxa** (`SINTESE-ABISSAL/roxo-r01`, `DEC-SINTESE-PURPLE`; fusão de Durvall com a armadura de Astherion, 4 espaços). O sprite parece resíduo da origem. | Substituir pelo canônico ou marcar como placeholder visível no plano. | Alta (chefe final) |
| A10 | `heroes.json:2`, `hero_bios.json:3`, `weapons.json:35,50` | "Drow · **Receptáculo**", bio "…como receptáculo", armas "Espada/Muralha do **Receptáculo**" | Durvall ser receptáculo de Ghaunadaur é **cânone do mestre**, não conhecido pelo grupo (`Durvall.md`, S7-34). O próprio projeto proíbe revelar ("receptáculo de Durvall", `HQ-REVIEW-VISUAL-BIBLE-r1`, `stage_story.json` pilares). | Título "Drow · Capitão do 3º Batalhão" ou "Drow · Armadura Negra"; renomear as duas armas. **Só o dono decide** o que revelar. | Alta (segredo) |

## B. Divergências de ordem, local e design (decidir)

| # | Item | Observação |
|---|---|---|
| B1 | Gárgula em Shedaklah (`stages.json:338,351`) | Vault: gárgulas moram na **Biblioteca Corrompida (Dagruve, S4)**. Natural em Dagruve. |
| B2 | Ezro e Shu em Durao/Goranthis/Pilares | Vault: vistos na **Vila das Sombras (S11)**, controlados por Ghaunadaur. Natural no Reino Abissal. |
| B3 | Death Tyrant em Goranthis e Pilares | Vault: surge no **ritual do Reino Abissal (S12, Kein + Beholder)**. Candidato natural a chefe/elite do Reino Abissal (hoje sem chefe, saída por "chegada"). |
| B4 | Master of Cruelties em Shendilavri | Vault: **Castelo da Fome (S23)**. Bem em Pilares; em Shendilavri não tem base. |
| B5 | Molydeus menor e Súcubo em Pilares | Sem base: Molydeus é de Durao, súcubos de Shendilavri. Aceitável como modo infinito; registrar como escolha de design. |
| B6 | Pilares como mapa do chefe | Vault: a Síntese cai em arena de fogo azul no **Morro Zapomoni** e os pilares só **depois** da derrota. Ordem do enredo inverte; sugerir arena do Castelo da Fome/Zapomoni para o chefe e pilares como epílogo. |
| B7 | Ordem da campanha: Docas → Reino Abissal → Domwieck → Dagruve | Cronologia do Vault: Dagruve (S3–S9) vem **antes** do Reino Abissal (S11) e da invasão de Domwieck (S12). É decisão de design aprovada (contrato r2), mas Dagruve passa a ser "retorno"; vale uma linha de contexto no mapa. |
| B8 | Sopro de Estrela como arma inicial de Leoric (`heroes.json:21`) | Vault: concha dada por João Barbosa na S18; Leoric entra na S10. Mesmo ponto para a Ampulheta de Zynara (`heroes.json:27`): o grupo a guarda, sem dono individual. |
| B9 | Martelo da Glória → evolução "Martelo da Luz" | Vault: o nome **antigo** é Martelo da Luz; virou Glória na S12. A evolução reverte a ordem. |
| B10 | Reino Abissal e Domwieck sem `stage_events`, sem Ecos/POIs/relíquia, sem conquistas de Eco | `secrets.json` não cobre os dois nem Pilares (previsto como adiado em B9 da release 0.5.0). |
| B11 | Hub "Quartel" | Vault: **QG** (galpão na Rua Miraval). Nome próprio do jogo; só alinhar se quiserem. |

## C. Raça e detalhes sem apoio no Vault (informativo)

- **Brook "Halfling"** vem da decisão do jogo `CHARACTER-IDENTITY-003`; o Vault diz que a raça "não foi definida". Idade canônica 53 em 1690 é compatível. Candidato a retroalimentar o Vault (decisão do dono).
- **Coração da Dominância** (`items.json:62`) não existe no Vault: lore nova do jogo.
- Idades canônicas novas (Sylas 25, Brook 53, Korrak 28, Leoric 45, Erik ~26) não aparecem nas bios; Durvall segue sem idade.
- Maelor: adicionar "meio-elfo, Maelor Menezes" ao título/bio é opcional.
- Inconsistências **dentro do Vault** (avisar o dono): "Fimbulnott" em `Domwieck.md` (S9-46) vs "Finbulnott" oficial; "Silvaris" (Thalion.md) vs "Sylvaris"; "Sylas Malafas" em `16_Histórias`.

## D. O que o Vault tem e o jogo ainda não usa (candidatos para a finalização)

**Personagens/NPCs:** Marciela (já nas HQs, falta no jogo), Gilly, Wonka e Willie (Docas), Aila, Kein, Thalion, Kūkan Shito (observador ilusório em Feng-tu, S18), Nyxara e Vaelis, Vhaerith (já há evento), Hrothgar e Zerak (Massacre Celestial/Skygomork), Satanaxe (a voz do machado de Korrak).

**Criaturas:** Reaper do Estige (há evento, sem inimigo), Mímico (definido e sem uso, Espeto de Pau), Kraken completo e Arch-hag como chefes de evento das Docas.

**Itens:** Livrinho (companheiro de Durvall), Baralho de Muitas Coisas, Cadernos Vinculados (há bênção), Poção de Sopro de Fogo, Jarra do Navio das Docas, Luz Mais Pura de Thalion, Diário de Willie, Diário de Manutenção das Gárgulas, Carta de Trégua de 1400 e de 1480, Plantas do Túmulo, Papiros Diários (jornal pós-Kraken, edição extraordinária 10/10).

**Locais para Ecos/POIs:** Praça da Loucura e Santuário de Astherion (Dagruve), Espeto de Pau, Laboratório de Marciela, Vila das Sombras e as três igrejas, Ponte Aluris, Templo de Sendrinah em Domwieck (pós-S24), Castelo da Fome e Morro Zapomoni.

**Arte CANON pronta no Vault** (output/referencias-personagens): Síntese roxa (4 vistas), Death Tyrant, Beholder, Blogbog, Arch-hag, Reaper do Estige, Zuggtmoy, Socothbenoth, Malcanthet (os 3 últimos já batem com os sprites do jogo), Graz'zt, Thalion, Nyrelia, Marciela, Aranel, Astherion, Nidhogg (DRAFT), Illithar e Temenus. Conferi Molydeus (próximo; a segunda cabeça é verde no canon e vermelha no jogo), Zuggtmoy, Blogbog, Socothbenoth e Malcanthet: iguais. Master of Cruelties: o sprite alado do jogo difere da referência do usuário (demônio encouraçado, de chifres, com rosto de caveira); o texto do Vault diz que "voa".

**Capítulo 2 e Arco 02 (Mystralia):** eventos datados de 10/10 a 30/10/1690, epílogo de Nottgard (19–24/10, festa, eleições, partida de Zynara com Arlindo) e a nova "variedade de HQs" do Vault (`output/hq/stanley-c01-c06`). Candidatos a pós-créditos/epílogo, ainda DRAFT no Vault.

## E. Verificado e consistente

Chefes e narrativa de Shedaklah, Molor, Durao, Feng-tu, Shendilavri e Goranthis (camadas, andares, Juiblex como mente-colmeia, Blogbog/núcleo verde, três Molydeus, Tou Um/Lu Yueh/Discípulo Pestilento, Irmãs Radiantes, Espelho, chifre, mural das sete runas, Graz'zt), crônicas de Dagruve e Docas, barks (Arlindo, Erik, Korrak, Leoric, Zynara, Nyrelia), nomes de heróis (exceto A1), itens únicos principais (Machado, Martelo, Lâmina, Anéis, Wave of Terror, Cajado Infernum, Dispositivos) e a Zuggtmoy/Blogbog/Socothbenoth/Malcanthet em arte.

## F. Limites desta varredura

Li os dados textuais (`data/*.json`), os retratos/sprites citados e as notas do Vault pertinentes; não li as 27 sessões inteiras nem rodei o jogo. Não verifiquei se o lettering das HQs está embutido na imagem (A3/A4). Não comparei os 12 retratos de herói com as referências CANON (a regra dos olhos de aasimar de Kayron fica para a conferência visual).
