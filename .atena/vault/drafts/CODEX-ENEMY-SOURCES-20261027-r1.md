# CODEX-ENEMY-SOURCES-20261027-r1 · S-C03a · inventário de fontes (inimigos)

Escopo: os 64 ids de `data/enemies.json` (52 inimigos e 12 quebráveis). Fonte: `F:\dev\nottgard-vault` (somente leitura). Mesma regra de sigilo dos heróis: nada de "cânone do mestre", nada do segredo do Durvall (sem o termo Receptáculo ligado a ele, sem Astherion como "armadura" dele).

Cobertura: **A** arquivo próprio no Vault; **B** coberto por Local, NPC ou Lore; **C** pouco ou nenhum lastro (entra só o que o jogo já diz, marcado `fonte: "jogo"` e listado em "lacunas").
A coluna de cobertura dos lotes 2 a 6 é **estimativa** por contagem de menções nos arquivos do Vault; cada lote só vale depois que eu ler as fontes dele.

## Lotes por região (ordem de entrega)

| Lote | Fases | Ids | Cobertura | Estado |
|---|---|---|---|---|
| 1 | Docas, Dagruve (e os comuns de Reino Abissal e Domwieck) | zumbi, notivago, cultista_adaga, cultista_arqueiro, cultista_cajado, slime_corrosivo, criatura_corrompida, sacerdote_mente_derretida, gargula, guardiao_copia, guardiao_verdadeiro, arch_hag, tentaculo_kraken, totem_de_chefe, mimico + 5 quebráveis (pilha_carga, carroca, candelabro, caixote, arbusto) | A: notívago, gárgula, Arch-hag, Kraken. B: sacerdote, cultistas, guardião, slime, mímico. C: cajado, criatura corrompida, totem, candelabro, arbusto | **rascunho pronto** |
| 2 | Shedaklah, Molor | cogumelo_fungico, servo_de_zuggtmoy, esporo_voador, pudim_negro, slime_de_juiblex, zuggtmoy, bolha_de_slime, cultista_thullgrime, receptaculo_de_juiblex, manifestacao_de_juiblex, blogbog + saco_de_esporos, casulo_viscoso | A: Blogbog, Receptáculo de Juiblex. B: Zuggtmoy, Juiblex, Thullgrime. C: esporo voador, pudim negro | a ler |
| 3 | Durao | alma_penada, demonio_de_gehenna, carcereiro_de_pedra, molydeus_menor, molydeus_chefe, aberracao_shu, ezro + urna_funeraria | A: Molydeus, Ezro, Shu. B: Gehenna, Durao | a ler |
| 4 | Feng-tu | larva_de_lu_yueh, cultista_de_feng_tu, estatua_do_templo, discipulo_pestilento, lu_yueh + lanterna_de_papel | B: Lu Yueh, Tou Um, Feng-tu. C: estátua | a ler |
| 5 | Shendilavri e Rivenheart, Goranthis | escravo_de_rivenheart, sucubo, ilusao_de_sucubo, guarda_do_castelo, malcanthet, ilusao_de_socothbenoth, guardiao_de_goranthis, cultista_de_socothbenoth, socothbenoth + espelho_ilusorio, estatua_rachada | B: Malcanthet, Rivenheart, Castelo Argento, Socothbenoth, Goranthis. C: guarda do castelo | a ler |
| 6 | Pilares, Reino Abissal, Domwieck e sem fase | master_of_cruelties, sintese_abissal, death_tyrant, cultista_ghaunadaur, nidhogg, lu_yueh (já no 4) + relicario_instavel | A: Crueldades, Síntese, Death Tyrant. B: Nidhogg (Sessão 15), Ghaunadaur | a ler; **Síntese e Death Tyrant pedem cuidado de sigilo** |

Ids que não aparecem em nenhuma fase do jogo (`stages.json`): totem_de_chefe, mimico, nidhogg, manifestacao_de_juiblex, lu_yueh e os 12 quebráveis. A seção "Onde aparece" desses usa o Local do Vault, não a fase.

## Lote 1: fonte por inimigo

| Id | Cobertura | Arquivos do Vault |
|---|---|---|
| zumbi | B | `10_Sessões/.../Sessão 03` (S3-49, S3-50); `04_Locais/Praça da Loucura` |
| notivago | A | `07_Criaturas/Notívagos`; `04_Locais/Dagruve` (S7-15); `Sessão 03` (S3-47) |
| cultista_adaga, cultista_arqueiro | B | `05_Organizações/A Mente Derretida` (S3-39, S3-45); `04_Locais/Praça da Loucura` |
| cultista_cajado | C | só o jogo (lampião de cera); culto = `A Mente Derretida` |
| slime_corrosivo | B | `04_Locais/Docas` (Sessão 02) |
| criatura_corrompida | C | `04_Locais/Docas` (Sessão 02: "criaturas sem identidade individual") |
| sacerdote_mente_derretida | B | `Sessão 03` (S3-47 a S3-50); `05_Organizações/A Mente Derretida` |
| gargula | A | `07_Criaturas/Gárgulas da Biblioteca Corrompida`; `04_Locais/Biblioteca Corrompida`; `06_Itens/Diário de Manutenção das Gárgulas` |
| guardiao_copia, guardiao_verdadeiro | B | `Sessão 02` (guardião alado, cópia e sangue negro); `04_Locais/Docas`; DEC-GUARDIAO-ORIGIN-004 (sprites) |
| arch_hag | A | `07_Criaturas/Arch-hag das Docas`; `12_Lore/Ritual de Invocação Autossustentável`; `02_Personagens/Maelor` (golpe final) |
| tentaculo_kraken | A | `07_Criaturas/Kraken` (Sessão 13 e Sessão 21) |
| totem_de_chefe | C | só o jogo (regra L5); sem equivalente no Vault |
| mimico | B | `04_Locais/Espeto de Pau`; `Sessão 10` |
| pilha_carga_quebravel | B | `04_Locais/Docas` (galpões de suprimentos e carga) |
| carroca_quebravel | B | `04_Locais/Docas` (carroças); `02_Personagens/Kayron` (S5-37, perseguição de carroças) |
| candelabro_quebravel, arbusto_quebravel | C | nada específico |
| caixote_quebravel | B | `04_Locais/Docas` (suprimentos) |

## Trechos que ficam fora (lote 1)

| O quê | Por quê |
|---|---|
| Para que o ritual da Praça da Loucura buscava o garoto acorrentado | o Vault liga o ritual à busca do "receptáculo" de Ghaunadaur; o texto do jogo só diz que o ritual tinha um garoto acorrentado sobre um símbolo de sangue |
| Astherion e o santuário como origem dos notívagos | o santuário aparece só como lugar onde dois notívagos entraram; a identidade de Astherion fica de fora |
| "Aboleth" como nome da criatura do Kraken | é registro de mesa; entra só como curiosidade, não como identidade |

## Esquema proposto para os inimigos em `codex_lore.json`

```
"enemies": { "<id>": { "quem": "2 a 4 frases", "onde": ["docas", "dagruve"], "igual_a": "<id opcional>",
  "curiosities": [ { "req": "base | boss | hq:<id>", "text": "...", "fonte": "arquivo e sessão" } ] } }
```
- `base`: inimigo já visto. `boss`: esse chefe já foi derrotado (`stats.boss_kills`, já existe). `hq:<id>`: HQ já vista (`hqs_seen`). Nada muda no save.
- `onde` lista ids de fase; o texto "Onde aparece" mostra o nome da fase. Um teste confere `onde` contra os spawns reais de `stages.json`.
- Inimigo sem fonte do Vault: só `quem`, `fonte: "jogo"` e entrada neste relatório.

## Lacunas do lote 1 (aguardam decisão do dono)

L-1 cultista_cajado, criatura_corrompida, totem_de_chefe, candelabro e arbusto não têm lastro no Vault: entram só com o que o jogo já diz, ou ficam sem texto? Recomendo entrar com 1 linha, marcadas "jogo".
