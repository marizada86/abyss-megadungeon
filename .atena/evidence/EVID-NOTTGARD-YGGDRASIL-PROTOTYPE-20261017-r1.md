---
id: EVID-NOTTGARD-YGGDRASIL-PROTOTYPE-20261017
revision: r1
status: IMPLEMENTED_MINIMAL_QA_PASS_AWAITING_CP_YGG_004
---

# S-YGG-003 — protótipo geométrico implementado

Usuário aprovou contrato r1 e autorizou S-YGG-003: “apraovado e autorizado”. [Aceite CANON do contrato](../vault/canon/DEC-YGGDRASIL-PROTOTYPE-CONTRACT-20261017-r1.md). Plano r1, **3/5 etapas concluídas**, duas restantes. Esta etapa implementa e comprova carregamento/entrada/retorno; validação completa não antecipada.

Treze caminhos aprovados alterados; [lista e hashes finais](../generated/yggdrasil-map-20261017/s003-final-validation.json). Novo cadastro QA-only, malha de sete discos/oito cápsulas com eixo8/desvios6, cena60×60 e chegada(30,48). Objetivo240s+presença3s/raio2, cap40, quatro ondas provisórias, zero chefe/elites/NPCs e sem interativos/quebráveis automáticos. Dados de protótipo/malha idênticos ao contrato estruturado.

TerrainLayout seleciona malha por ID explícito e mantém defaults Reino Abissal; larguras opcionais preservam arestas antigas. Hero repassa seu terrain_id; Battle repassa stage_id para apoio/mobilidade/recursos e inclui ID no cache, reserva a chegada certa e aplica guardas opcionais do protótipo. Sentinelas de spawn recusado não entram na lista viva. Desenho geométrico em madeira e tronco distante de baixo contraste não recebem status de arte final. Launcher admite terceira escolha sem liberação na campanha.

Preservação conferida: todos os dezesseis arquivos protegidos do baseline; entradas prévias dos três JSONs semanticamente idênticas; ui/ground.gd removida a adição Yggdrasil é idêntica ao baseline. Nenhum bitmap, pacote, motor, perfil real, direito de acesso, HQ ou dado da campanha alterado. Arquivos de testes novos e regressão intercalada preparados para S-YGG-004, sem remover expectativas r2.

## Verificação mínima executada

- Importação e test_scripts_compile PASS: .atena/generated/yggdrasil-map-20261017/validation-20261017-223417-653/results.json.
- Testes novos de Yggdrasil e teste_root_navigation carregados/compilados sem executar seus métodos run na verificação de cena final.
- Entrada QA real com Durvall/seed7502, chegada apoiada e sem bloqueadores; três capturas 1280×720 e retorno ao menu; perfil fonte sintético e assinatura preservados. [Relatório](../generated/yggdrasil-map-20261017/validation-20261017-223830-412/smoke-result.json).
- Entrada/retorno pelo launcher existente com --map raiz_yggdrasil -VerifyLaunch PASS: [registro](../generated/map-playtest-sessions/20261017-223703-195-8b640699/launch-verification.json). Execução offscreen para verificação, sem abrir sessão de playtest humano ou reclamar avaliação do dono.
- Antes de alterar código de jogo, baseline de desempenho de Reino Abissal50 capturada para comparação S-YGG-004, seed7204/dt1/60,30+600frames. Loop mediana 13.328ms/p95 15.767ms; simulação 9.06/11.431ms. [Baseline](../generated/yggdrasil-map-20261017/validation-20261017-223045-406/smoke-result.json). Não é conclusão de desempenho da implementação nova.

Todas as execuções Godot precedidas de probe sem autoload, APPDATA/LOCALAPPDATA e perfil sintéticos. Logs finais sem erros; primeira captura revelou dois erros de inferência de tipo nos novos testes, corrigidos antes do PASS final. Registro da falha preservado; não tratado como execução aprovada dos testes.

[Chegada](../generated/yggdrasil-map-20261017/validation-20261017-223830-412/yggdrasil-1280x720-arrival.png) e [alvo](../generated/yggdrasil-map-20261017/validation-20261017-223830-412/yggdrasil-1280x720-target.png) inspecionados como prova de carregamento/composição provisória, sem certificar colisão completa, combate, pressão ou diversão.

## Próximo checkpoint

CP-YGG-004: autorizar validação completa de acordo com [contrato](../specs/SPEC-NOTTGARD-YGGDRASIL-MAP-20261017/technical-contract-r1.md): doze conjuntos planejados, simulação integral, bordas/deslocamentos/spawns/loot/cap, capturas1280×720/1920×1080/tons de cinza e regressões visuais/técnicas dos mapas aceitos; comparar custos de navegação ao baseline pré-código. Método de tempo de loop não é timestamp GPU nem certificação de FPS. S-YGG-005 é o playtest humano posterior, com autorização própria. Arte final e integração capítulo2/Web/publicação fora do recorte.
