# Varredura de consistência do jogo — 2026-10-22 (r1)

Status: DRAFT. Somente leitura: nenhum dado do jogo foi alterado. Perfil sintético isolado (APPDATA/USERPROFILE no scratchpad); nenhum save real. Estado verificado: HEAD `dce57dd` + árvore local.

## Resultado das checagens
| Checagem | Resultado |
|---|---|
| `tests/run_all.gd` | 0 falhas (avisos de vazamento de ObjectDB/recursos no encerramento do Godot, já conhecidos) |
| `tools/audit_projeto.gd` | 0 erros, 0 avisos |
| Referências cruzadas em `data/*.json` (`xref.cjs`: fases, inimigos, heróis, armas, itens, conquistas, arquivos citados) | 0 ids quebrados; 4 observações abaixo |
| Pendências da varredura Jogo × Vault de 2026-10-21 (A1–A10) | A1, A2, A5–A8 e A10 já corrigidos; **A3 e A4 seguem** (HQ `hqn_13`) |

## Achados (corrigir ou decidir)
| # | Onde | Problema | Proposta | Gravidade |
|---|---|---|---|---|
| C1 | `data/secrets.json` · `goranthis.pois[gor_covil].elite = "death_tyrant"` | O covil de Goranthis ainda gera um **Death Tyrant**, apesar da decisão B3 (Death Tyrant só no Reino Abissal) e de o relatório de equilíbrio dizer que ele saiu de Goranthis. Os 300 PV / 2d8 ajustados para o Reino também valem ali. As medições de Goranthis (adendo 1 do equilíbrio) incluíam esse elite. | Trocar o elite do covil por um inimigo do elenco de Goranthis (ex.: o Guardião de Goranthis) e renomear "Covil do tirano de olhos". Texto do Eco em `secrets.json:361` junto. | Média · **CORRIGIDO** |
| C2 | `data/secrets.json` · `shedaklah.pois[she_covil].elite = "gargula"` | Gárgulas foram movidas para Dagruve (B1); o covil de Shedaklah ainda gera uma. | Trocar por inimigo do elenco de Shedaklah. | Média · **CORRIGIDO** |
| C3 | `data/hqs.json:339,347` (`hqn_13`) | "ano 700" e "Setenta anos de cerco" (Vault: ano 1400 e 78 anos). HQ inativa. | Corrigir o texto se a HQ voltar; checar se há texto dentro da imagem. | Baixa |
| C4 | `data/lettering.json` · `prompt_clique` | Entrada aponta para `assets/ui/title/prompt_clique.png`, que não existe e não é usada em `ui/`. O loader trata peça sem arte com fallback. | Remover a entrada ou gerar a arte. | Baixa |
| C5 | `data/stages.json` · `unlock: "start"` em Dagruve e Docas | Valor sentinela, não é id de fase. Esperado. | Nenhuma. | Informativo |

Falsos positivos descartados: `raiz_yggdrasil` e `dagruve_thalion_r1` não estão em `stages.json` por serem fases de protótipo/QA; `mimico`, `nidhogg`, `lu_yueh`, `manifestacao_de_juiblex` e `totem_de_chefe` não aparecem em ondas, mas são usados por código, eventos e fases de chefe.

Observação de método: `rei_covil` (Ezro) também não está nas ondas do Reino Abissal, mas isso é intencional (Ezro ficou só como elite do covil, v5 do equilíbrio).

## Não coberto
Textos longos (crônicas, bios, HQs) contra o Vault além das 10 verificações A1–A10; coerência de números entre `chapter_flow.json` e `stages.json` (durações, tetos); sprites contra canon visual. Um próximo passo seria rodar o bot nos covils de Goranthis/Shedaklah após C1 e C2.

Arquivos: `.atena/generated/consistency-sweep-20261022/xref.cjs` (`node xref.cjs`, só lê `data/`).

## Correção de C1 e C2 (autorizada pelo dono em 2026-10-22)
`data/secrets.json`: covil de Goranthis passa a gerar o **Guardião do Paraíso** (`guardiao_de_goranthis`, já no elenco e nas elites da fase; nome "Covil do guardião do paraíso"); covil de Shedaklah passa a gerar o **Pudim Negro** (`pudim_negro`, já nas ondas e elites; combina com o poço de lodo). Reino Abissal mantém Ezro no covil (decisão do equilíbrio v5). Nenhum outro dado alterado.

Conferência: `run_all` 0 falhas; `audit_projeto` 0 erros e 0 avisos; reexecução do cruzamento: só o covil de Ezro (intencional) fica fora das ondas. Bot (`bot5`, build sem meta, 6 heróis × 2 sementes, perfil sintético; antes = resultados anteriores ao ajuste):

| Mapa | Modo | Antes | Depois |
|---|---|---|---|
| Goranthis (nível 38, 3 itens) | imortal | 6/12 chefes mortos · 3171 dano/min · 4,20 golpes letais/min | 7/12 · 3200 · 4,12 |
| Goranthis | mortal | 0/12 · sobrevive 157 s | idêntico (morre antes de chegar ao covil, em (66,66)) |
| Shedaklah (nível 1) | imortal | 8/12 · 1041 dano/min · 2 mortes | 10/12 · 1025 · 0 mortes |
| Shedaklah | mortal | sem medição anterior | 0/12 · sobrevive 129 s (referência nova) |

Leitura: troca neutra a levemente mais leve, como esperado (Death Tyrant 300 PV e gárgula de 40 PV saem; Guardião 130 PV e Pudim Negro 60 PV entram). O bot anterior de Shedaklah era uma versão mais antiga, então a comparação ali é aproximada. Resultados: `results/j-*.jsonl`; script `launch-bal22j.sh`.
