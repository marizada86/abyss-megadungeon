---
id: SCOPE-NOTTGARD-MAP004-PROTOTYPE-20261017-r1
status: COMPLETE_TECHNICAL_QA_PROTOTYPE
origin: planned
implementation_preceded_spec: false
---

# S-MAP-004 — execução delimitada de Domwieck

Fechamento em 2026-10-17: oito caminhos alterados, cinco checks e smoke dos dois mapas aprovados. [Evidência final](../../evidence/EVID-NOTTGARD-MAP004-PROTOTYPE-20261017-r1.md). S-MAP-004 concluída, 4/7; CP-MAP-005 pendente. O escopo abaixo preserva a definição anterior à implementação.

Pedido explícito: “Atena, aprovado. Pode iniciar a S-MAP-004, criando o protótipo funcional de Domwieck conforme o dossiê r1, com testes isolados e aprovação por etapa.” Modo per-step; contrato de mapas CANON e dossiê r1 aceito permanecem autoridade. Escopo IN_PLAN; prioridade e retorno existentes preservados.

Entregar protótipo QA 60×60 em data/prototype_stages.json, nunca no catálogo final. Chegada (30,45), praça (30,33), laterais (15,30)/(45,30), alvo (30,15), jardim (30,7). Objetivo de 420 s e presença de 3 s/raio 2. Ondas/elites, cap 54 e multiplicadores do contrato r1. Sem Adam como chefe, escolta ou vida da estrela. Conclusão/resultado isolados; integração narrativa/migração/HQ03 são S-MAP-005.

Prontidão visual: terreno/volumes anônimos têm identidade N/A por não retratar personagem. Ailalore segue decisões CANON de jardim vermelho, floresta circular, estrela azul-clara e feixe até a Tarn. Representação inteiramente geométrica e provisória, com calçamento, volumes élficos, flores vermelhas, silhuetas de floresta e estrela/feixe/domo. Não usar flor branca, cristal vermelho ou casa de Dagruve como equivalentes. Reusar somente carga_01/02/03 já conferida como obstáculos pequenos fora das reservas. Fogo apenas geométrico/decorativo, sem novo dano. Sem geração de PNG, NPC, boss ou Véu Vivo antecipado.

Orçamento desta etapa: **8 arquivos de jogo/teste**: data/prototype_stages.json, data/level_design.json, core/terrain_layout.gd, ui/ground.gd, ui/run.gd, ui/hud.gd, ui/stages/domwieck.tscn (novo), tests/test_map_objectives.gd. Permanecem dentro do teto operacional conservador de 13; os caminhos comuns já constam do dossiê e catálogo de protótipos foi aprovado no CP-MAP-003A. Nenhum outro arquivo de jogo precisa de alteração. Registros/helper ADD separados. Sem novas dependências, escrita Web, commits ou publicação.

Baseline por caminho/hash e cópia antes de edição; comparar Reino Abissal e catálogo final para preservar o trabalho anterior. RESOLVABLE: geometria/legibilidade e reutilização do HUD precisam de verificação executável nesta etapa. Não há BLOCKING para iniciar o protótipo autorizado. Arte final e avaliação humana de diversão/dificuldade ficam DEFERRED. Não declarar playtest humano por simulação técnica.

Validação: objetivo nos dois mapas (limiar/raio/presença, pausa, dano, morte/abandono, idempotência, cessar diretor, limpeza sem recompensa); grade de alcance com props reais e reservas do dossiê; simulação integral de Domwieck; mapa novo ausente de seleção/catálogo normal; bloqueio fora de QA; resultado sem mutação de perfil. Capturas 1280×720/1920×1080 para orientação, jardim/estrela e resultado. Revalidar isolamento antes de Godot com sonda mínima, APPDATA/LOCALAPPDATA e perfil sintéticos. Regressão dirigida por alterações de dados/layout/render, sem repetir checks não afetados gratuitamente.

Saída: protótipo QA, evidência e estado reconciliado; S-MAP-004 completa tecnicamente significa 4/7 etapas, três restantes. Próximo CP-MAP-005, integração da campanha, depende de aprovação própria e orçamento/preflight delimitados. Não alterar estado dos outros chats nem restaurar cursor antigo da HQ14.
