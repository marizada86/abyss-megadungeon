# S-C1-006 — abertura do playtest humano / r1

Plano PLAN-NOTTGARD-CHAPTER1-CLOSEOUT-20261016 r1; modo per-step; checkpoint CP-C1-06. Autorização “autorizado” em 2026-10-17, após proposta concreta do playtest. Classificação IN_PLAN. Cinco de seis etapas concluídas. S-C1-006 em execução; aceite humano PENDING_OWNER_FEEDBACK.

Preparação: hashes do runtime pertinente iguais à entrega aprovada da regressão S-C1-005. Sem mudanças de código de produção. Versão local pelo Godot, em janela 1280×720; não foi exportado um executável.

Sessão isolada: `.atena/generated/chapter1-human-playtest-20261017/s006-20261017-174635-269`. Registro `launch.json`; PID inicial 42424. Sonda confirmou user_data_dir dentro desta sessão antes da abertura do projeto. APPDATA/LOCALAPPDATA exclusivos e `--controller-profile` aponta para synthetic-profile.json. Perfil novo, sem ativar atalhos de QA ou carregar save real. Saída inicial sem erro de script ou parsing. Janela de jogo solicitada explicitamente pelo dono.

Orientação fornecida antes da abertura: avaliar Docas → Reino Abissal → Domwieck, ordem das HQs e fim no sacrifício de Helion; observar leitura, objetivos, dificuldade e registrar falhas por mapa/quadro. Arte dos dois mapas provisória; retomada restrita à HQ, sem retomada integral de combate. Procedimento detalhado: `../specs/SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/chapter1-playtest-r1.md`.

Verificação da área de trabalho: consulta fora do isolamento confirmou PID 42424, Responding=True e janela “Nottgard - Abyss Megadungeon (DEBUG)”. A consulta isolada anterior não enxergava o processo; não foi aberta outra instância para contornar essa ausência.

Reabertura da mesma sessão autorizada no escopo do playtest: usar launch.ps1 com SessionDirectory indicado no recibo, preservando o perfil sintético existente e repetindo a sonda. Não substituir esse perfil por um save real. A abertura não prova execução da campanha nem aprovação de legibilidade/dificuldade/diversão. Feedback do dono e controle físico permanecem pendentes. Não concluir capítulo ou avançar capítulo 2 por efeito deste registro.

## Resultado final — 2026-10-17

APPROVED_BY_OWNER: “Atena, playtest aprovado. Vamos finalizar o capítulo 1.”. S-C1-006 concluída; seis de seis etapas. O registro de abertura acima é histórico. Aceite final e limites em `../vault/canon/DEC-NOTTGARD-CHAPTER1-ACCEPTANCE-20261017-r1.md`.
