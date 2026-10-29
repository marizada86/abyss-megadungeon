# Assets que faltam para fechar o beta (0.5.2) — índice de prompts (2026-10-28, r1)

> Revisão de 28/10: consultar [r2](PROMPTS-ASSETS-0-5-2-20261028-r2.md) antes de gerar. A conferência do consumer identificou aliases animados e especiais existentes que a auditoria por caminhos não reconhece. As recomendações abaixo foram preservadas como histórico.

Status: DRAFT. Nenhuma imagem foi gerada nem integrada por esta tarefa (geração e aceite são do dono). Base: `asset_gaps.gd` rodado hoje (19 lacunas, 0 erros).
Os prompts completos, com destino, formato e referências, estão em `.atena/generated/balance-bots-20261018/PROMPTS-CHATGPT-ASSETS-FALTANTES-DRAFT-r1.md` (regras globais no topo dele). Este arquivo diz **quais ainda valem** e em que ordem.

## Ordem sugerida (maior ganho de acabamento primeiro)
| # | Lacuna hoje | Prompt no pacote antigo | Observação |
|---|---|---|---|
| 1 | `ilusao_de_sucubo`, `ilusao_de_socothbenoth` (Shendilavri, Goranthis) só estáticos | P2-02 | Recomendo animar `idle` + `death` (dissolução translúcida): elas são o alvo central da fase de imunidade do chefe, o jogador as olha durante 12 s |
| 2 | `molydeus_menor` (Pilares) só estático | P2-01 | 4 folhas (idle, move, attack, death) |
| 3 | `special.png` do Sacerdote e do Discípulo | P2-04 | A pose de conjuração dá leitura ao aviso que o jogador deve interromper; **decisão**: o que a pose mostra (ver `data/boss_mechanics.json`) |
| 4 | Quebráveis temáticos do Reino Abissal e Domwieck (hoje usam o arbusto) | P1-07/08 | Falta, além da arte, registrar em `Battle.BREAKABLE_TYPES_BY_STAGE` (código; faço junto quando a arte chegar). Raiz de Yggdrasil não entra no beta |
| 5 | Ícone de regra de fase: Docas, Reino Abissal, Domwieck | P1-10 (Docas) | Docas tem regra (poças corrosivas); Reino Abissal e Domwieck só precisam de ícone se ganharem regra: **decisão** |
| 6 | Música/ambiência próprias para Reino Abissal, Domwieck e Pilares | — (áudio, fora de imagem) | Dívida já listada nas notas da 0.5.1 |

## Já resolvido (não gerar)
- Ícones de bênção, de arma e de item: a auditoria de hoje não aponta mais nenhum (o relatório de 18/10 estava desatualizado).
- `tentaculo_kraken` sem folha `move`: ele é estacionário em Docas; não precisa de arte.
- Entrada órfã `prompt_clique` em `data/lettering.json`: removida nesta tarefa (a peça nunca existiu e nada a usava).
- Raiz de Yggdrasil (miniatura, regra, atmosfera, decais, crônica): só se a fase entrar no beta.

## Ideias de imagens novas que complementam o jogo (não geradas)
1. Selo "Interrompido!" (arte única, para o aviso da primeira interrupção bem-sucedida).
2. Ícones de status sobre o chefe: blindado (turíbulos), imune (servos), enfurecido (enrage).
3. Cartão de causa da morte na tela de resultado (hoje só texto: "Último golpe: ...").
4. Abertura do capítulo 2 (cartaz de título).
