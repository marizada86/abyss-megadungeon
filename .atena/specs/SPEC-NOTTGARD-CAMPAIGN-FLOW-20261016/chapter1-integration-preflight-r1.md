---
id: SCOPE-NOTTGARD-CHAPTER1-INTEGRATION-20261017
revision: r1
status: DRAFT_AWAITING_APPROVAL_AND_MAP_HANDOFF
origin: planned
implementation_preceded_spec: false
platform: windows-x86_64
---

# S-C1-004 — preparação da integração PC

Pedido “autorizado” em 2026-10-17 aprova somente a preparação solicitada, não implementação. IN_PLAN, PLAN-NOTTGARD-CHAPTER1-CLOSEOUT-20261016 r1, per-step; três etapas de seis completas. Contrato de mapas/transições r1 aceito por DEC-NOTTGARD-CHAPTER1-MAPS-CONTRACT-20261016-r1 prevalece sobre o cabeçalho histórico DRAFT do contrato. Seis sequências visuais aprovadas totalizam 33 quadros. HQ01/HQ02 já integradas não serão substituídas.

## Situação observada e impactos

Catálogo final ainda inicia Dagruve, HQ15–18 ausentes, HQ03/HQ14 antigas. Profile ainda infere Docas de qualquer Dagruve concluída; Game.start_run não valida permissões. HQCatalog usa ordem numérica e desbloqueio como indicador de apresentação. Leitor sempre inicia em zero, não persiste cursor; run restaura pausa como false, sem preservar estado anterior. Portanto colar somente novas imagens não resolve o fluxo aprovado.

Trabalho concorrente identificado: missing_maps_proposal, S-MAP-004/CP-MAP-004, com Domwieck QA autorizada e em andamento. Reino Abissal está em data/prototype_stages.json e cena QA. Battle já tem timed_reach, hold/radius e complete_stage sem abates artificiais; objetivo ainda termina em state=won por ser protótipo. Run ignora marcos em QA. Domwieck tem entrada de protótipo em preparação; não se infere entrega/aceite só pela existência. Não reimplementar, reverter ou promover esses arquivos silenciosamente. Estado desse plano deve ser relido antes de qualquer escrita.

Os mapas usam geometria provisória aceita como protótipo, não acabamento final. Não atribuir a esta preparação aprovação estética de mapa ou conclusão de playtest. Mudanças locais existentes, inclusive project.godot, pertencem a trabalhos anteriores/concorrentes; preservar.

## Escopo concreto proposto

1. Admitir os 33 PNGs aceitos em caminhos versionados de assets/hq/chapter1_r1/, com manifesto de origem/hash, preservando artes antigas. Atualizar HQ03 (6), HQ14 (5), adicionar HQ15 (5), HQ16 (5), HQ17 (4), HQ18 (8), legendas literais dos manifestos. Preservar HQ01/02 e IDs históricos.
2. Novo data/chapter_flow.json define sete HQs principais em ordem, HQ14 complementar após Docas e arquivo histórico HQ11/12/13. Diário distingue ativo/complementar/histórico, sem retirar conquistas, moedas ou replay já adquirido. Conteúdo posterior não é novo desbloqueio de perfil novo.
3. Progresso aditivo campaign_progress v1 com milestones, pending_hqs e panel_index, presentation_done, direitos legados congelados e next_stage. Capturar acesso original antes da migração antiga; migração idempotente, preserva campos desconhecidos, sem recompensas de migração ou vitórias novas inferidas. Validar acesso também em Game.start_run, preservando QA sintética.
4. Fila persistente antes de abrir HQ, leitura integral versus dispensa versus interrupção diferenciadas. HQ01 antes do combate; Docas → HQ02/15/16/17 → Reino Abissal → HQ18 → Domwieck → HQ03. HQ14 só Diário. Salvar cursor por quadro; retomar sem restaurar run inexistente. Pausar dano/ondas/Maré e restaurar pausa anterior. Replay não muda campanha nem duplica recompensa.
5. Consumir handoff dos dois mapas, sem redesenho: promover definições aprovadas para catálogo final, conservar Docas/balanço existente, retirar comportamento QA-only apenas na trilha integrada. Reino Abissal 360 s + presença 3 s/raio 2; Domwieck 420 s + presença 3 s/raio 2. Objetivo limpa perigos sem abate/XP/drop/boss fake. Continuar/extrair após fila, preservando build na mesma run. Adam só na HQ, permanece vivo.
6. Domwieck concluída salva marco; chapter1_closed apenas após HQ03 lida ou dispensada explicitamente. Resultado “Capítulo 1 concluído” e menu, sem iniciar capítulo 2, Shedaklah ou Dagruve automaticamente.

## Caminhos e coordenação

Orçamento máximo herdado: 48 arquivos texto/cena/teste, mais 33 PNGs aceitos e metadados gerados Godot pertinentes. Sem aumento automático do teto. Manifesto baseline contém caminhos candidatos; alterações somente nos efetivamente necessários.

Núcleo da integração: data/hqs.json, novo data/chapter_flow.json, core/hq_catalog.gd, core/profile.gd, core/game.gd, ui/hq_screen.gd, ui/menu.gd, ui/run.gd; suporte de objetivo/transição: core/battle.gd, ui/hud.gd, ui/stage_progress.gd, core/data.gd e adaptadores QA/playtest apenas se a carga de dados exigir. Cenas do leitor só se necessária indicação de conclusão/retomada.

Após handoff: data/stages.json, data/prototype_stages.json, dados de story/events/rules/structures/level_design/scenery/prop_visuals dos mapas, ui/stages/reino_abissal.tscn e domwieck.tscn, core/terrain_layout.gd e ui/ground.gd somente ajustes de admissão necessários. Não restaurar versão antiga dos arquivos comuns nem alterar geometria/estética por efeito desta integração.

Testes existentes pertinentes: test_hqs, test_profile, test_save_resilience, test_data, test_stage_progress/story/structures, test_map_scale, test_terrain, test_reach_grid, test_battle, test_map_objectives, test_qa_sandbox, test_playtest e catálogo. Novo tests/test_chapter_flow.gd cobre fila persistente, migração/permissões e encerramento, sem espelhar apenas constantes. Sem alterações project.godot, heróis/armas/inimigos/conquistas, dependências ou Web por padrão.

Antes de editar arquivo compartilhado: reler estado e hash, comparar baseline e diff local atual, registrar responsável/handoff de mapas e baseline novo. Se houver implementação concorrente ainda ativa no mesmo caminho, preservar preparação e aguardar estabilização desse caminho; trabalho de arte/catálogo sem colisão pode prosseguir após aprovação delimitada. Recuperação somente hunks deste escopo, jamais checkout/reset/restauração de pasta inteira.

## Checks e aceitação

- Preflight documental: 33 hashes, seis sequências e aceites, 2 mapas sem colisão de ID, inimigos existentes e paths de arte válidos. Nenhum Godot ou save real nesta preparação.
- Antes de Godot: criar diretório sintético de teste, isolar APPDATA/LOCALAPPDATA e perfil, executar sonda user_data_dir, provar destino exclusivo. Se isolamento falhar, não abrir jogo. Usar D:/Godot/godot.exe e roteiro de isolamento já adotado, sem instalar ferramentas.
- Checks de implementação: parse/validação JSON, import e testes dirigidos aos arquivos alterados. Novos perfis sem atalhos; sete classes de saves legados da tabela do contrato e campos desconhecidos; fila em início/meio/fim, dispensa/retomada, ordem e leitura/recompensa uma vez; objetivo limiar/raio/pausa/morte/idempotência; transição mantendo build e fechamento sem capítulo 2. Provar que objetivos não somam boss kill/loot.
- Capturas em 1280×720/1920×1080: HQs/leitor, Diário, HUD de objetivo, transição e resultado, com teclado/controle. Não alegar conforto visual ou diversão sem feedback do dono. Regressão ampliada e playtest humano continuam S-C1-005/006 com aprovação própria; checks mínimos de implementação integram S-C1-004.

## Prontidão e decisões pendentes

BLOCKING para escrever integração de mapas: handoff estável de S-MAP-004 e reconciliação com S-MAP-005, que também prevê integração narrativa. Os dois planos não devem executar a mesma integração em paralelo. Proposta: S-C1-004 é a execução única do contrato de capítulo; resultado pode servir de evidência para S-MAP-005, sem marcar a etapa do outro plano concluída por inferência. Aceite desta coordenação deve identificar qual escopo passa a ser executor, preservando demais checkpoints.

BLOCKING para implementação: aprovação desta ficha r1. Sem BLOCKING para concluir a preparação. RESOLVABLE: uso dos mapas geométricos como integração funcional inicial, mantendo acabamento final explicitamente pendente; não promover protótipo a arte final. DEFERRED: polimento dos mapas, capítulo 2, portagem Web e mudança retroativa da roupa de Kayron em quadros já aceitos.

Próximo checkpoint CP-C1-04: aprovar escopo de integração r1 e coordenação proposta. Executar conteúdo/fila/progresso após aceite; mapas somente após handoff e prontidão. Este documento não implementa, autoriza ou declara aceito qualquer resultado ainda não entregue.
