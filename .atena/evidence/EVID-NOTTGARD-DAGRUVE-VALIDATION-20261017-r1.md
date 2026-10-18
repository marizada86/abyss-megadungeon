---
id: EVID-NOTTGARD-DAGRUVE-VALIDATION-20261017
revision: r1
status: TECHNICAL_VALIDATION_PASS_HUMAN_PLAYTEST_PENDING
---

# S-DAG-004 — validação ampliada

Usuário autorizou “autorizado”. [Build final/hashes e relatórios](../generated/dagruve-chapter2-20261017/s004-build.json), [revisão com capturas](../generated/dagruve-chapter2-20261017/s004-review.md), [portagem e limites](../generated/dagruve-chapter2-20261017/s004-portability.json). Nenhuma ampliação do teto: oito caminhos de jogo/teste, metadados derivados à parte.

## Regressões e comportamento

Quinze regressões adicionais passaram: battle, data, stage_progress, chapter_flow, stage_structures, prop_grounding, blocker_index, reach_grid, terrain, level_design, yggdrasil_map, yggdrasil_navigation, root_navigation, root_art e domwieck_art. Quatro básicos da etapa anterior reutilizados; test_dagruve_encounter repetido após refinamento de rótulo, também passou. Total19 checks distintos válidos. Test_battle usa runner anterior que libera somente fixtures órfãos alocados pelo próprio teste; asserções não foram alteradas.

Dagruve padrão versus métodos do baseline anterior:1280 passos de0,25s/320s, zero diferenças nos estados amostrados a cada passo (PV/posição/XP/ouro/estado/estatísticas/inimigos/projéteis/zonas/interações), atravessando rituais e chegada do chefe. Snapshot de métodos em subclass Battle mantém compatibilidade de tipos com consumidores, corpos anteriores preservados; campos/constantes compatíveis herdados. Não é restauração da árvore nem cópia para runtime. Código de origem também compilado e verificado deterministicamente120passos no harness PC; a origem não foi escrita e não se alega execução completa do projeto de origem com seus próprios assets/dependências.

## Visual e custo

Capturas1280×720 e1920×1080: chegada, oeste/leste, alvo, pressão32 com ataques/recursos, tons de cinza, objetivo liberado, resultado, morte/abandono e visões gerais padrão/variante. Rótulo de substitutos movido para canto inferior direito para não sobrepor toast; target_label agora “Área marcada”, removendo fallback “Ritual”. Refinamentos restritos aos caminhos já aprovados: JSON da variante, apresentação local e teste focal. Não há Thalion atacável nem interior final do templo. Resultado sincronizado conferido após atualizar HUD/visuais, sem inimigos residuais ou recompensa de chefe.

A-B padrão, mesma sessão, seed7603/dt1/60/32 inimigos,30frames aquecimento+600 medidos por lado; ondas/regras desligadas igualmente para carga fixa. CPU mediana0,905→0,895ms,p95 1,093→1,066ms. Ciclo mediana3,984→3,972ms,p95 4,637→4,532ms, máximos5,989→6,071ms. Sem aumento sustentado>10% ou nova pausa relevante nessa amostra. Métodos antigos e atuais ligados diretamente à mesma UI/render, construtor não medido. Loop inclui sincronização/escalonamento/dispatch OpenGL fora da tela, não GPU nem FPS certificado. Variante medida separadamente (não comparação de trabalho idêntico); valores completos no relatório.

## Encerramento e isolamento

Aviso foi reproduzido também em Dagruve padrão; diagnóstico verbose identificou AudioStreamWAV de assets/audio/music/menu.wav retido. Não houve nó órfão em nenhum dos pontos de retorno consultados. Apenas esperar0,5s não eliminou consistentemente a retenção. Teardown explícito do harness chama Sfx.stop_music(0)/stop_ambience(0) e aguarda0,25s antes de sair: duas sessões padrão e duas variante encerraram sem ERROR/recursos retidos. Render final também encerrou limpo com essa limpeza. Assim, a observação foi delimitada ao encerramento do processo com áudio ativo/crossfade; não foi declarada uma correção global de Sfx ou garantia de toda saída rápida da aplicação. core/sfx.gd não foi editado.

Falhas de preparação dos helpers preservadas em seus logs: callback de órfãos chamado na classe incorreta; adaptação inicial do snapshot falhou por tipos/multilinha de string; corrigidos somente helpers de validação. Nenhuma falha de asserção de produto nas regressões finais.

Todas execuções Godot com APPDATA/LOCALAPPDATA/perfis sintéticos e probe sem autoload confirmado antes do jogo. Perfis sintéticos originais preservados, nenhum save real carregado. Assets/catálogos released/HQs/navegação e outros protótipos conferidos por hashes. Sem instalação, geração, sincronização da origem, commit ou publicação.

Plano r1:4/5 concluídas, uma restante. CP-DAG-005 solicita autorização própria para [playtest humano](../specs/SPEC-NOTTGARD-DAGRUVE-CHAPTER2-20261017/playtest-r1.md), ainda não aberto.
