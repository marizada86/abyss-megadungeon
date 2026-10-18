# Fechamento do capítulo 1 — proposta delimitada r1

Estado operacional final — 2026-10-17: COMPLETE_OWNER_ACCEPTED, seis de seis etapas concluídas, CP-C1-06 fechado. O dono aprovou o playtest e pediu finalizar o capítulo 1. [Aceite CANON](../../vault/canon/DEC-NOTTGARD-CHAPTER1-ACCEPTANCE-20261017-r1.md). A proposta original abaixo fica preservada como histórico; mapas com arte provisória e demais limites constam do aceite.


ID: PLAN-NOTTGARD-CHAPTER1-CLOSEOUT-20261016. Data: 2026-10-16. Estado operacional: recorte r1 e S-C1-002 aprovados; desenho documental concluído, próximo checkpoint CP-C1-02 pendente. Modo: per-step já escolhido. Plataforma: PC Windows x86_64. Origem: planned; implementation_preceded_spec: false.

Autorização: “Atena, aprovado. Vamos detalhar os mapas e as transições do capítulo 1”. Resultado S-C1-002: [contrato detalhado r1](chapter1-maps-transitions-r1.md) e [evidência](../../evidence/EVID-NOTTGARD-CHAPTER1-MAPS-DESIGN-20261016.md). Duas etapas concluídas de seis, quatro restantes. A sequência abaixo preserva o planejamento de origem; o estado operacional deste parágrafo e state/plan.yaml prevalecem para o cursor. O pedido autorizou elaborar o desenho, não implementar as novas regras propostas.

Pedido do dono: “Atena, vamos finalizar o capítulo 1 primeiro”. Classificação PLAN_CHANGE_REQUEST quanto à prioridade de fechamento: concentrar preparação e execução futura no capítulo 1, deixando revisão/produção do capítulo 2 pendentes. Não presumir aceite do capítulo 2 nem aprovação irrestrita da proposta FLOW r1.

## Escopo e situação real

Texto CANON: [capítulo 1 aprovado](../../vault/canon/CHAPTER1-SCREENPLAYS-APPROVED-20261016-r1.md), oito HQs/46 quadros. Ordem principal: HQ01 → Docas → HQ02 → HQ15 → HQ16 → HQ17 → primeira incursão abissal → HQ18 → Domwieck → HQ03/fim. HQ14 — A Máscara permanece complementar do capítulo. HQ11/12/13 saem da seleção, preservando acervo, IDs e progresso herdados. HQ16 Q3 é Kayron incendiando a Igreja de Nott; o corte não confunde as duas igrejas.

HQ01/HQ02 já integradas; 13 quadros aceitos. Seis HQs ainda requerem seleção/prontidão/arte: HQ15/16/17/18/03/14, 33 quadros. Isso não significa gerar 33 imagens novas: verificar reutilização e adaptação quadro a quadro. Não foram localizados resultados de produção identificados como HQ15/16/17/18/03 sob os nomes pesquisados em generated; isso não é prova de ausência de referências reutilizáveis no acervo.

No runtime, HQ15–18 ainda não existem; HQ03 ainda usa stage_reached/shedaklah e quatro quadros. Mapas reino_abissal/domwieck não existem; Dagruve ainda abre a progressão e Docas vem depois. HQ11/12/13 continuam no catálogo atual. Portanto o capítulo está aprovado editorialmente, mas não concluído no jogo.

## Sequência delimitada

| Ordem | Etapa | Entrada / saída | Checkpoint |
| --- | --- | --- | --- |
| 1/6 | S-C1-001 | Conferir aceites e runtime → inventário de pendências e proposta de fechamento | Concluída pelo pedido atual; sem produção |
| 2/6 | S-C1-002 | Fontes/CANON → contrato técnico só do capítulo 1: objetivos de Reino Abissal/Domwieck, eventos, retorno, fila HQ, desbloqueios, saves antigos, retirada das três HQs, transição final e arquivos/checks delimitados | CP-C1-01 pendente; autorização somente de desenho/documentação |
| 3/6 | S-C1-003 | CANON + acervo + bíblia → seleção/prontidão e produção das seis HQs, começando pela HQ15; candidatas e sequências aceitas individualmente | Própria autorização operacional e gates visuais; sem lote cego de geração |
| 4/6 | S-C1-004 | Contratos e conteúdo aceitos → mapas/recursos necessários e integração PC da sequência do capítulo 1 | Aprovação própria; zero BLOCKING aplicável antes de implementação |
| 5/6 | S-C1-005 | Build integrada → regressão e leitura/fluxo com perfis sintéticos novos/legados | Aprovação própria; isolamento antes de Godot |
| 6/6 | S-C1-006 | Build verificada → playtest do dono, correções delimitadas e aceite do capítulo | Aprovação própria; registrar resultado e próximo cursor |

Etapa 1 concluída: uma de seis, cinco restantes. Próxima: S-C1-002. Seu escopo é fechar decisões técnicas em documentos, sem arte/código. Não requer refazer roteiros aceitos nem concluir capítulo 2. Suspensão de execução/retorno dos planos existentes deve ser persistida após aceite deste recorte, antes de avançar por CP-C1-01.

## Gaps e aceitação

- BLOCKING para código: contrato dos dois mapas, objetivos/encontros (incluindo sobrevivência de Adam), gatilhos/fila e migração. Resolver em S-C1-002; não há BLOCKING para o desenho documental dessa etapa.
- BLOCKING para arte: seleção e referências de personagens/ambientes por HQ; resolver na preparação de S-C1-003 antes de cada candidata. Preservar bíblia aprovada, identidade e contexto; sem delegação ou serviços externos por efeito deste plano.
- RESOLVABLE: encaixe de A Máscara como HQ complementar e retirada das três HQs sem perda de conquistas/replay históricos; definir em S-C1-002. A narrativa do capítulo 2 não é necessária para decidir isso.
- DEFERRED: revisão das dez HQs do capítulo 2; mapas/confrontos de Dagruve/Thalion e segunda incursão; portagem Web deste novo fluxo.

Concluir significa: perfil novo inicia em Docas e segue até o sacrifício de Helion; oito HQs selecionadas com textos/arte aceitos e replay; três HQs retiradas da seleção sem perda histórica; duas novas fases verificadas; contratos antigos de save preservados; nenhuma revelação secreta nova; noite/névoa/Tarn/Véu coerentes; aceitação humana do capítulo registrada. Entrada do capítulo 2 precisa ser definida como transição, sem reformular o restante da campanha por efeito deste recorte.

Testes previstos, quando pertinentes: test_hqs, test_profile, test_catalog, test_stage_story, test_stage_structures, test_stage_progress, test_playtest e testes de combate afetados. Capturas do leitor em 1280x720/1920x1080, fila, pausa, menu, controle/teclado e replay. APPDATA/LOCALAPPDATA exclusivos, sonda de user_data_dir e perfil sintético explícito; nunca save real. Avaliação de diversão/dificuldade depende do playtest do dono.

## Salvaguardas e retorno

Preservar HQ review r1 no S-HQ-004, roteiro HQ03 aprovado e produção pendente; HQ02/navegador pendente de seu escopo PC/Web anterior. Preservar CP-FLOW-01 técnico pendente e CP-SPLIT-02 com aceite humano da separação pendente. Este suplemento não declara nenhuma dessas tarefas concluída.

Baseline por arquivos/hashes antes da integração, sem sobrescrever trabalho concorrente; recuperação limitada a arquivos deste recorte. Sem mudança de motor, dependências, instalação, commits, push ou publicação. Portagem Web registrada como pendente pela escolha PC-only já dada pelo dono. O próximo checkpoint pede aprovação deste recorte r1 e execução apenas de S-C1-002.
