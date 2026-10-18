# S-C1-005 — regressão ampliada / r1

Resultado: PASS. Autorização: “autorizado”, 2026-10-17, em resposta à etapa de regressão ampliada. Plano PLAN-NOTTGARD-CHAPTER1-CLOSEOUT-20261016 r1, modo per-step. Classificação IN_PLAN. Cinco etapas concluídas de seis; S-C1-006 aguarda CP-C1-06.

Sessão: `.atena/generated/chapter1-integration-20261017/s004-validation-20261017-174216-717`. Relatório: `../generated/chapter1-integration-20261017/regression-delivery-r1.json`. Sonda confirmou user_data_dir sob APPDATA exclusivo antes de executar o projeto; perfil sintético explícito. Nenhum save real foi lido.

Dois processos Godot distintos: o primeiro gravou 46 perfis intermediários pelo Game.save atômico e copiou os arquivos resultantes. O segundo recarregou todos os quadros das oito HQs, conferiu a imagem correspondente, cursor, fila seguinte, dispensa sem leitura/recompensa e conclusão/repetição sem recompensa duplicada. A inicialização normal de Game também recuperou o último perfil gravado pelo primeiro processo.

Sete perfis legados: moedas; run/morte; antiga Dagruve concluída; Docas concluída/Shedaklah alcançada; fases avançadas concluídas; conquistas/HQ histórica; melhorias/códex/configuração. Conferidos acessos herdados mais Docas inicial, preservação dos campos, nenhuma nova fila ou conclusão fictícia de Domwieck, arquivos históricos HQ11/12/13 e migração idempotente após JSON.

Entrada: 21 verificações com eventos sintéticos, incluindo Enter/Espaço/Enter numérico, eco e soltura ignorados, Esc, controle padrão/legado, botão mantido/solto, mouse, perda de foco e notas F5. Quatro combinações do apresentador real de run: pausa anterior ligada/desligada × completar/dispensar; restauram a pausa anterior e persistem a resolução correta. Duas aberturas pelo Diário real: retomar HQ14 no quadro salvo e reler desde o início, sem prêmio duplicado.

Primeiras execuções preservadas: uma expectativa de teste esquecia que Docas é acesso inicial na nova rota; outra comparava estritamente inteiros em memória com floats retornados pelo JSON. Diagnóstico dos sete pares serializados confirmou igualdade de dados. As expectativas foram corrigidas na matriz, sem alteração de código de produção. Também foi corrigida uma tipagem na extensão do teste de Diário e acrescentado tempo de encerramento para os recursos pendentes da cena. A execução final com diagnóstico detalhado passou sem falhas, erros de script ou avisos de recursos no encerramento.

Reutilizados os 16 testes aprovados da integração e suas 15 capturas (1280×720/1920×1080). Hashes do runtime pertinente permanecem iguais ao início de S-C1-005. Nenhuma alteração de motor, dependência, arte ou regra canônica nesta etapa.

Limites: eventos simulados não substituem controle físico. Retomada integral de combate continua fora do contrato. Cenários dos dois mapas têm geometria provisória. Ritmo, legibilidade percebida, dificuldade e diversão dependem do dono. Próximo: proposta operacional `../specs/SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/chapter1-playtest-r1.md`; execução não autorizada por S-C1-005.
