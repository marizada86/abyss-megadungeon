# Reconciliação de UI/HUD e Quartel — 2026-10-22, r1

Classificação: IN_PLAN_READ_ONLY_RECONCILIATION. Autorização: «seguir recomendações», após a recomendação de conferir o jogo atual e delimitar somente o que falta antes da execução da proposta. Modo per-plan preservado. Nenhum arquivo de runtime, asset, ID ou save foi alterado.

## Resultado

HEAD inspecionado: `02f898552fc8bea7bff90b801274bef5283a9820`. A integração `a5b0121` já está no histórico deste checkout. A proposta transferida r1 ainda descrevia como futuros vários usos que esse commit implementou; ela continua preservada como registro histórico.

- 125 fontes aceitas conferidas por SHA-256 tanto na produção transferida quanto em `assets_incoming`: nenhuma ausente ou divergente.
- 158 derivados conferidos contra o recibo de preparação: nenhuma ausência ou divergência.
- As 62 peças U/Q da preparação já têm cópias idênticas em `assets/`. Copiar o arquivo não significa integrá-lo a uma tela.
- 18 grupos de evidências de uso/retenção registrados com arquivo e linha em `audit.json`; hashes dos dez arquivos de código/dados/cena consultados também registrados.

## Matriz reconciliada

| Grupo | Estado no código atual | Encaminhamento |
|---|---|---|
| U01–U08 | Integração anterior preservada nos cartões/HUD | Sem reaplicação |
| U09 | Ornamentos e halo desenhados em código; PNG de brilho sem uso | Integrar em composição aditiva; verificar versão compacta e impacto reduzido |
| U10 | Textura sem uso; repetição não aprovada | Reter |
| U11 | Preço em Label, sem a placa preparada | Integrar placa preservando valor, bloqueio e legibilidade |
| U12 | Comentário explícito retém molde fixo do painel | Reter para layout próprio; nenhuma nova geração nesta frente |
| U13/U14/U15/U16 | Barras PV/XP, anel de habilidade e chips já usados | Preservar e verificar regressões |
| U17 | Helper existe, mas HUD não o chama por colisão com fase | Integrar após ajuste do topo; medir fase, regra e painel de chefe em conjunto |
| U18 | Ajuda e velocidade já usam arte; pausa sem botão próprio no HUD | Preservar; não criar botão novo |
| U19 | Helper existe, mas moldura de uma linha foi retida na lista variável | Reter |
| U20/U21 | Modais de reviver/resultado e tooltip já usam arte | Preservar |
| Q01/Q04/Q06 | Integração anterior preservada | Sem reaplicação |
| Q02/Q03 | HeroList e StageList continuam ItemList | Implementar cartões preservando seleção, nomes, bloqueios, rolagem e controle |
| Q05 | Pips e botões de compra já integrados | Preservar |
| Q07/Q08 | Q08 em conquistas, emblema apagado quando bloqueado; Q07 sem uso | Preservar Q08; reter Q07 sem inventar faixas bronze/prata/ouro |
| Q09 | Três categorias existentes usam ícones; demais sem abas correspondentes | Preservar; não criar abas |
| Q10 | PNGs presentes, resultado ainda composto em texto | Usar seis ícones com rótulos e valores existentes |
| N01 | Reaper já referenciado no evento e animação idle de quatro quadros | Preservar, sem reintegração |
| N02–N10/V10 | Reserva de personagens / sprite de Kayron retido | Fora desta frente |

## Baseline técnico e limites

O runner PowerShell usa o Godot já existente, redireciona APPDATA/LOCALAPPDATA e comprova `OS.get_user_data_dir()` em projeto sem autoload antes de carregar o jogo. Perfil sintético isolado; save real não carregado. `baseline.json` contém os caminhos e os resultados, e a pasta sintética conserva os logs completos.

Quatro testes existentes executados: `test_offer_cards`, `test_offer_keyboard`, `test_ability_hud`, `test_controller_experience`: todos encerraram com código 0, zero falhas de asserção e sem SCRIPT ERROR/Parse Error. `audit_projeto`: zero erros e zero avisos de conteúdo.

Todas essas execuções também emitiram `ERROR: Failed to read the root certificate store.` do Godot/Windows. Por isso `assertions_passed=true` e `passed=false` no recibo: não declarar execução inteiramente limpa. Não houve acesso remoto nem alteração de certificados. Esse resultado não substitui o `controller_check` completo histórico, a suíte inteira, capturas ou playtest visual.

Python disponível no PATH era apenas o atalho da Microsoft Store; nada instalado. O runner PowerShell supriu a necessidade. Os arquivos globais apontados por AGENTS.md (`C:/Users/gui-m/.codex/AGENTS.md` e `RTK.md`) não existem neste ambiente; aplicadas as instruções locais e ADD disponíveis. Backlog histórico em D: indisponível nesta máquina; nenhum relato histórico copiado.

## Continuidade

Proposta revisada em `integration-proposal-r2.md`, limitada a U09/U11/U17/Q02/Q03/Q10 e verificação do conjunto preservado. O checkpoint original `S-I01/INTEGRATION_SCOPE_APPROVAL_PENDING` continua sem avanço de runtime; a reconciliação está concluída em subregistro próprio. A avaliação visual das fontes continua aprovada; o aceite das telas permanece pendente.

Nenhuma sincronização com a origem histórica, geração de imagem, promoção a CANON, exportação, commit ou push. Os demais planos e alterações preexistentes foram preservados.
