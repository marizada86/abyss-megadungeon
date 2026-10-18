# S-PATH-004 — validação conjunta e desempenho

Estado: INCOMPLETA, aguardando CP-PATH-004-R2 para18º arquivo de teste. Etapa4/5,3 etapas concluídas,2 restantes. Relatório: .atena/generated/path-revision-20261017/s004-validation-progress.json. Build/hash: s004-build.json. Nenhuma abertura ou aceite humano S-PATH-005.

## Resultado permitido

11/12 suítes passaram no PC (.atena/generated/path-revision-20261017/s004-20261018-021014-969); as7 suítes de geometria/arte/compilação passaram também na cópia candidata (.atena/generated/path-revision-20261017/s004-20261018-021028-537). test_map_objectives nativo retornou86 falhas por chegada/destinos/eixo/spawns do desenho anterior. Arquivo original preservado; patch DRAFT r2 preparado e sua prévia isolada passou (.atena/generated/path-revision-20261017/s004-20261018-021129-690/r2-preview.json), sem contar esse preview como suíte aprovada. Teto atual17/17 mantido.

## Medição comparável

Baseline .atena/generated/path-revision-20261017/s004-20261018-020257-450: cópia do PC com contexto não relacionado atual e somente os17 caminhos da revisão restaurados ao estado anterior à S-PATH-002. Candidata final .atena/generated/path-revision-20261017/s004-20261018-021214-634. Godot4.7.2 debug, OpenGL3/Compatibility, GTX1650, i5-9400F,1280×720, VSync/FPS cap desligados somente no harness, plano de energia Equilibrado sem mudança. Cada mapa usou30frames de aquecimento+600 medidos, dt1/60, Yggdrasil seed7504/40 inimigos e Abismo seed7202/50. Contagem permaneceu fixa; fixture usa HP alto, sem armas/ondas/interações, nos dois lados. As partidas e dados de usuário são sintéticos, com probe prévio sem autoload.

CPU de simulação medida em Battle.step por relógio monotônico; script+sync e parede também registrados como métricas secundárias. Render CPU = viewport+setup; GPU via instrumentos do RenderingServer. Metodologia/unidades documentadas em [Godot RenderingServer](https://docs.godotengine.org/en/stable/classes/class_renderingserver.html#class-renderingserver-method-viewport-get-measured-render-time-cpu). Não são promessa de FPS em outros dispositivos nem prova de significância estatística/causalidade.

| Mapa | CPU mediana baseline→final (ms) | CPU p95 (ms) | Render CPU p95 (ms) | GPU p95 (ms) |
|---|---|---|---|---|
| Yggdrasil |2,559→2,782|5,131→3,861|1,447→1,361|1,626→1,899|
| Abismo |4,459→3,007|8,737→3,545|1,194→1,249|3,359→2,555|

Todos os critérios finais passaram: CPU mediana/p95≤1,15×baseline, render CPU e GPU p95≤1,20×baseline. Primeira candidata falhou; medidas e hashes históricos preservados em s004-performance-initial.json, s004-performance-opt1.json e logs brutos selados por SHA256 no comparador. Duas rodadas delimitadas de ajuste nos arquivos já aprovados: índice de primitivas por célula na definição da própria batalha, invalidação desse índice quando o gerador muda nós, e poda por limites geométricos no shader Yggdrasil preservando distâncias relevantes/duas texturas mais próximas. Não mudaram medidas, sementes, arte fonte ou critérios de aceitação.

## Correção e evidência reutilizada

Referência CPU anterior versus otimizada:288.000 consultas, três sementes Yggdrasil e espiral abissal, raios0/0,3/0,4/0,8/1,2;zero diferenças. Base previamente indexada foi exercitada para evitar cache de outra geometria.128 sementes novamente aprovadas,128 variantes/zero fallback. Máscaras/capturas renovadas dos dois mapas,zero divergências interiores; overview Yggdrasil pós-otimização inspecionado. Simulações e aceites técnicos S002/S003 reutilizados quando ainda válidos; a paridade cobre a alteração do predicado de suporte e a suíte atual inclui simulação integral de Yggdrasil. Sombras não constituem chão. Conforto/subida-descida/dificuldade continuam pendentes de relato humano.

Portagem candidata atualizada com hashes novos, projeto original não alterado, pacote pendente de aplicação autorizada. S003 é histórico; candidata sintética agora corresponde à S004 conforme s004-portage.json. Sem commits, publicação ou save real.

## Próximo checkpoint

Revisão r2 propõe apenas incluir tests/test_map_objectives.gd como18º caminho, admitir o patch apresentado, verificar a suíte nativa no PC e na candidata com pré-requisitos explícitos, e concluir S-PATH-004 se passar. Critérios de desempenho não serão relaxados e benchmark não será repetido por alteração exclusiva de teste. Abertura S-PATH-005 continua com checkpoint independente.
