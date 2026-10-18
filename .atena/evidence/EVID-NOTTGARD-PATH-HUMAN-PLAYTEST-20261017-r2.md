# S-PATH-005 — playtests aprovados e concluídos, revisão r2

Estado atual: CONCLUÍDA, plano5/5, zero etapas restantes. O titular confirmou que testou e aprovou caminhos, bordas e combate em Yggdrasil e na primeira incursão abissal, incluindo a leitura da espiral.

> Atena, testei e aprovei os caminhos, as bordas e o combate nos dois mapas, incluindo a leitura da espiral abissal. Pode concluir a S-PATH-005 e registrar os resultados dos playtests.

Aceites separados: **Yggdrasil — APPROVED_OWNER** (caminhos, bordas, combate); **primeira incursão abissal — APPROVED_OWNER** (caminhos, bordas, combate, leitura da espiral). Fonte do aceite: relato humano explícito acima. Não se atribui cobertura individual de sementes, duração de partida ou observações adicionais que não foram informadas.

Build r2 preservada:18/18 hashes conferidos na conclusão; nenhum arquivo de jogo/teste alterado nesta etapa documental. Logs das duas sessões inspecionados, sem erros de script/shader/carregamento. Validação técnica12/12 e desempenho dentro dos limites do contrato reutilizados da S-PATH-004, pois o runtime permanece igual. Não houve nova execução do jogo ou repetição de benchmark.

Recibo final: .atena/generated/path-revision-20261017/s005-final-validation-r2.json. Decisão de aceite: .atena/vault/canon/DEC-MAP-PATH-HUMAN-ACCEPTANCE-20261017-r2.md. Checkpoint CP-PATH-005 concluído; estado do plano reconciliado em .atena/state/plan.yaml. O fluxo de caminhos encerra-se aqui. Cursor Dagruve CP-DAG-005 preservado, com seu feedback humano ainda pendente; nenhuma execução de retorno iniciada. Aplicação do pacote na origem continua pendente de autorização própria. Nenhuma alteração de processos, saves reais, origem, commits ou publicação nesta conclusão.

## Registro histórico da abertura

O conteúdo abaixo descreve o estado anterior ao aceite e é preservado como histórico.

# S-PATH-005 — abertura dos playtests r2

Etapa5/5 em andamento;4 concluídas e1 restante. Titular autorizou abertura de Yggdrasil e primeira incursão abissal para avaliar caminhos, bordas, combate e leitura da espiral. Contrato r1 + ajuste r2; build s004-build-r2.json com18/18 hashes conferidos. Nenhum arquivo de jogo/teste foi alterado nesta abertura.

Duas janelas visíveis foram abertas, com handles válidos, cenas corretas e recibos ready.json. Yggdrasil: PID18540, seed7502, chegada(30,48). Abismo: PID29732, seed4401, chegada(30,54). Ambas começaram pausadas após captura do mapa, para permitir testar uma por vez. Recibo completo: .atena/generated/path-revision-20261017/s005-opening.json.

Cada sessão possui APPDATA/LOCALAPPDATA/perfil sintéticos próprios e probe sem autoload anterior à importação/jogo. O runtime confirmou qa_sandbox e save_path em user://qa-sandbox/. Logs sem erros de script/shader/carregamento na verificação da abertura. Capturas mapa-aberto.png dos dois mapas foram inspecionadas: chão e personagem renderizados; isso não substitui avaliação humana. Uma primeira tentativa parou no tratamento de aviso do RTK durante o probe, antes do jogo; launcher corrigido sem mudar gameplay.

Harness local derivado do seletor existente, somente para títulos, recibos, capturas, pausa inicial e alternância de sementes7502/7503/7504 de Yggdrasil ao reabrir pela seleção. Durvall e combate normais, sem invulnerabilidade ou mudanças de ondas/caps. WASD/setas ou mouse para andar, Q/botão direito para habilidade, Esc para pausa/continuar; retornar à seleção pela saída da partida e reabrir Yggdrasil para comparar variantes.

Critérios Yggdrasil: espessura dos caminhos, diferenças entre sementes, alternativas, bordas e espaço/congestionamento no combate. Critérios Abismo: percurso espiral e alternativas, leitura de subida/descida, orientação, bordas e combate. Feedback esperado separadamente para cada mapa: aprovado ou problema com trecho/situação. Nenhum dos aceites humanos foi concedido; etapa e plano permanecem incompletos até relato explícito dos dois. Checkpoint CP-PATH-005-HUMAN-FEEDBACK. Outros planos e feedback Dagruve preservados.
