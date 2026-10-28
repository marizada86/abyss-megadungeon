# CODEX-ITEMS-SOURCES-20261027-r1 · S-C09 · inventário de fontes (armas, feitiços e itens únicos)

Escopo: as duas categorias que o Códex ainda mostra só com os números e a `note` de `weapons.json` e `items.json`: **43 armas e feitiços** e **25 itens únicos**. Fonte: `F:\dev\nottgard-vault\06_Itens` (49 arquivos), `12_Lore`, `03_NPCs`, `02_Personagens` e as Sessões. Mesma regra de sigilo dos heróis e inimigos: nada de cânone do mestre, nada do segredo do Durvall.
Cobertura: **A** arquivo do Vault com conteúdo próprio; **B** arquivo curto (uma a duas frases) mais o que as Sessões dizem; **C** sem lastro (só o jogo).

## O que o jogador vê hoje

| Categoria | Detalhe atual (`Catalog.detail`) |
|---|---|
| Armas e feitiços | nome, escola, `Origem: Carta: ...`, tipo, dano, recarga, dica de escola, `desc` |
| Itens únicos | nome, casa, modificadores, `note` (uma frase) |

Nada de história do objeto. O mecanismo para isso já existe (`enemy_lore`/`req`) e só precisa de uma versão para armas e itens.

## Os 25 itens únicos

| Id | Nome no jogo | Cob. | O que o Vault tem | Cuidado |
|---|---|---|---|---|
| machado_de_xargath | Machado de Xar'gath | A | +1, +1d6 de fogo, Fire Breath e Fade Breath; guarda a alma do demônio Xar'gath, a entidade se chama Satanaxe; olho que sussurra; provações; cobra almas; Goliath infernal (S23) | já usado nas curiosidades do Korrak; não repetir |
| martelo_da_gloria | Martelo da Luz (vira Martelo da Glória) | A | forjado por Bromnor com uma lasca de Ailalore; Redenção Divina; condutor de rituais de portal; S12: Kein o usou, o grupo o recuperou; a luz muda de amarela para vermelha | a troca de nome é do Vault (antes Martelo da Luz); a morte do Bromnor fica atrás da hqn_11 |
| colar_visao_verdadeira | Colar de visão verdadeira do Santuário | A (4 KB) | colar do Santuário, concede visão verdadeira; Sylas o usou nas Sessões 8 e 9 | **o texto atual do jogo já cita Astherion e o olho de Ghaunadaur**; o arquivo é sensível, entra só o uso do colar |
| broche_celestial | Broche Celestial | A | recebido na Sessão 03; representa quem trabalha em Castle Rodhe; autoriza entrar e sair do castelo | usar "a serviço de Castle Rodhe" (DEC-CASTLE-SERVICE-001), nunca "Guardiões de Nottgard" |
| amuleto_da_luz | Amuleto da Luz | A | ilumina o caminho na névoa e protege Erik; destruído (S13); refazê-lo pede lasca de Ailalore, Erik e o Martelo da Glória | autor do original é Sylvaris e Frank Blackthorn, não Bromnor (DEC-AMULETO-ARANIS-20261018-r1) |
| lamina_da_digestao | Lâmina da Digestão | B | Thullgrime (S17): espada +1, 1d6 de ácido, dissolve armadura em crítico; ficou com Erik | |
| chicote_avarento | Chicote Avarento +1 | B | arquivo de 204 B; fica na sala de música do Castelo Argento com o Espelho (S19) | |
| cajado_dos_desejos | Cajado dos Desejos Sussurrantes | B | Malcanthet o empresta ao grupo (S18), amaldiçoado, sussurra desejos; Sylas o usa com cargas de re-rolagem | |
| colar_dos_tentaculos | Colar dos Tentáculos | B | achado no navio das Docas; invoca criatura tentacular até nove vezes (S14) | a nota do jogo o chama também de Olho de Ghaunadaur (fusão da frente A7); o Vault tem arquivo separado do Olho |
| sopro_de_estrela | Sopro de Estrela | B | concha que Sylas usa para ativar o portal do segundo andar do templo de Tou Um, rumo a Shendilavri (S18) | |
| ampulheta | Ampulheta do Silêncio Eterno | B | atrai Maelor na biblioteca; o grupo a guarda com a permissão de Helion; guarda a magia Silêncio | posse não atribuída a ninguém (V-3 dos heróis) |
| anel_resistencia_abissal | Anel da Resistência Abissal | B | Thullgrime (S17): vantagem para escapar de agarrão; Leoric | |
| anel_passagem_sombria | Anel da Passagem Sombria | B | forjado por Bromnor com lasca de Ailalore; teleporte entre sombras e invisibilidade em ~9 m, 1×/descanso | |
| aneis_de_grazzt | Anéis de Invocação de Graz'zt | B | dádiva de Graz'zt (S19): invoca o Lorde do Abismo uma vez, ao dizer o nome três vezes; o grupo carrega dois | |
| manto_do_pantano | Manto do Pântano | B | Thullgrime (S17): imune a ácido, vantagem contra veneno; Marciela | |
| luneta_de_korrak | Luneta de Korrak | B | oficial, dada por Gilly | já na curiosidade do Korrak |
| lasca_de_ailalore | Lasca de Ailalore | B | fragmento da estrela; base do Martelo, do Anel da Passagem Sombria e (para refazer) do Amuleto da Luz | |
| colar_runico_de_thalion | Colar Rúnico de Thalion | B | emana magia Primordial; as runas trincaram quando Thalion puxou o Kraken (S21) | |
| cajado_familia_infernum | Cajado da Família Infernum | B | relíquia de Yggdrasil com pedras da estrela de Eléstria | |
| wave_of_terror | Wave of Terror | B | espada mágica de ácido; o grupo a carrega ao fim do arco | |
| detector_arcano | Detector Arcano | B | de John Tobias, numa caravana fora do Véu Vivo | |
| dispositivo_antimagia_gilly | Dispositivo Antimagia de Gilly | B | escudo antimagia; o custo é sentido por quem o usa | |
| dispositivo_das_docas | Dispositivo das Docas | B | mecanismo do porto que afasta criaturas do mar; associado a Wonka | |
| espelho_das_almas_desejantes | Espelho das Almas Desejantes | B | mostra o maior desejo de quem o encara; Graz'zt o roubou de Malcanthet; sala de música do Castelo Argento (S18-19) | |
| coracao_da_dominancia | Coração da Dominância | **C** | sem arquivo no Vault; a nota do jogo diz que nasceu quando o portador resistiu à Rainha das Súcubos (Sylas resistiu a Malcanthet na S18) | só o que a nota diz; marcar `jogo` |

Resumo: 5 A, 19 B, 1 C.

## As 43 armas e feitiços

**Grupo I, o mesmo objeto de um único (10).** Aparecem nas duas categorias; a história vive no item e a arma aponta com `igual_a`:
machado_de_xargath, martelo_da_gloria, **martelo_da_luz** (a evolução do Martelo; vira "Martelo da Glória" no jogo), lamina_da_digestao, chicote_avarento, cajado_dos_desejos, colar_dos_tentaculos, sopro_de_estrela, ampulheta, dominio_da_vontade (→ coracao_da_dominancia).

**Grupo II, com âncora no Vault (10).**

| Id | Nome | Âncora | Cuidado |
|---|---|---|---|
| sentenca_de_lliira | Sentença de Lliira | Brook, paladino de Lliira | |
| julgamento_da_gloria | Julgamento da Glória | `12_Lore/Julgamento da Glória` (S21: o martelo apaga diante de todos até Brook pedir perdão) | liberar atrás de `hq:hqn_19` |
| raio_de_luz | Raio de Luz | Maelor, devoto de Sendrinah; no jogo a carta se chama "Luz Reveladora" | |
| luz_mais_pura | Luz Mais Pura | `06_Itens/Luz Mais Pura de Thalion` (Maelor a trouxe com um desejo, S14) | |
| memoria_alterada | Memória Alterada | Arlindo: *Modify Memory* mostrou a Brook o Massacre Celestial (S8-11) | |
| dominar_pessoa | Dominar Pessoa | Sylas (S23) e Nyrelia | **não** citar que Sylas dominou o Durvall |
| tocha_do_incendiario | Tocha do Incendiário | Erik incendiou navios nas Docas | |
| constelacao_de_silva | Constelação de Silva | Leoric: Modo de Constelação (S18) e Silva, mestre dele e de Korrak | |
| espada_sombria | Espada Sombria | arma do Durvall | **só o que é mecânico**: nada do segredo |
| espada_do_receptaculo | Espada da Armadura Negra | evolução da anterior (id mantido, nome já neutralizado em 2026-10-21) | idem; sem lore |

**Grupo III, cartas do Nottcard e evoluções sem âncora no Vault (23).** golpe_esmagador, maca_demolidora, adaga_rapida, rajada_infinita, golpe_atordoante, golpe_do_juizo, raio_enfraquecedor, raio_da_ruina, descarga_estelar, chuva_de_estrelas, estocada_mistica, cera_fervente, inferno_de_cera, vela_sagrada, lamina_trovejante, tempestade, dominio_coletivo, marca_da_retidao, bola_de_fogo, tormenta_de_fogo, lamina_de_sombra, romper_armadura, esmagar_defesas.
O Vault não tem nada sobre a maioria desses nomes (as buscas por "Raio Enfraquecedor", "Descarga Estelar", "Vela Sagrada", "Lâmina Trovejante", "Romper Armadura" voltam vazias). São cartas e magias do jogo de cartas; inventar história para elas violaria a regra de não preencher com texto plausível.

## Esquema proposto

Mesmo arquivo `data/codex_lore.json`, duas chaves novas:
```
"items":   { "<id do único>": { "quem": "...", "igual_a": "<opcional>", "curiosities": [ {req, text, fonte} ] } }
"weapons": { "<id da arma>":  { "igual_a": "<id do único>"  ou  "quem": "...", "curiosities": [...] } }
```
`req`: `base` (visto) ou `hq:<id>`. `Catalog.detail` ganha o mesmo tratamento dos inimigos: com perfil, a `quem` substitui a `note` e aparecem as curiosidades; a pausa fica como está. Teste novo: todo único tem entrada, `igual_a` aponta para algo que existe, termos proibidos, fontes preenchidas.

## Lotes recomendados

| Lote | O quê | Entradas | Cob. |
|---|---|---|---|
| A | os 5 itens A (Machado, Martelo, Colar de visão verdadeira, Broche, Amuleto da Luz) mais as armas do Grupo I que apontam para eles | 5 itens + 3 armas | A |
| B | os 10 itens B de mais conteúdo (Lâmina da Digestão, Chicote, Cajado dos Desejos, Colar dos Tentáculos, Sopro de Estrela, Ampulheta, Anel da Resistência Abissal, Anel da Passagem Sombria, Anéis de Graz'zt, Manto do Pântano) mais armas do Grupo I | 10 itens + 6 armas | B |
| C | os 9 itens restantes (Luneta, Lasca, Colar Rúnico, Cajado Infernum, Wave of Terror, Detector, Dispositivo Antimagia, Dispositivo das Docas, Espelho) e o Coração da Dominância (`jogo`) | 10 itens + 1 arma | B/C |
| D | o Grupo II | 10 armas | B |
| (fora) | o Grupo III | 23 armas | sem texto novo |

## Decisões para você

- **W-1:** as 23 cartas e evoluções do Grupo III ficam como estão (nome, origem, `desc`), sem história nova? Recomendo que sim.
- **W-2:** Espada Sombria e Espada da Armadura Negra ficam sem lore, só com o que já mostram? Recomendo que sim, para proteger o segredo do Durvall.
- **W-3:** o Colar de visão verdadeira entra só com o uso (Sylas, Sessões 8 e 9), sem o Santuário de Astherion e o olho de Ghaunadaur que a nota do jogo já cita? Recomendo que sim; e, se você quiser, eu proponho trocar a nota atual do jogo por uma sem Astherion (mudança de dados, só com a sua aprovação).
- **W-4:** o texto do item aparece igual nas duas categorias (arma e item único) por meio de `igual_a`? Recomendo que sim.
- **W-5:** ordem dos lotes A, B, C, D, com aceite de texto por lote, como nos heróis e inimigos?
