---
id: PLAN-NOTTGARD-MISSING-MAPS-20261017
spec_id: SPEC-NOTTGARD-MISSING-MAPS-20261017
revision: r1
status: COMPLETE_RECONCILED_PRIOR_ACCEPTED_DELIVERIES
origin: planned
implementation_preceded_spec: false
approval_mode: per-step
---

# Mapas faltantes — plano e especificação delimitada

Estado vigente em 2026-10-17: **7/7 entregas reconciliadas** com integração, regressão e aceites já concluídos nos planos do capítulo 1, navegação e arte. [Reconciliação autorizada](../../evidence/EVID-NOTTGARD-MAPS-RECONCILIATION-20261017-r1.md). Descrições de ausência de mapas, QA-only, arte provisória e checkpoints pendentes abaixo documentam o estado histórico de cada etapa; não são pendências atuais. Yggdrasil tem plano próprio DRAFT e não foi implementada.

Pedido: “Atena, vamos fazer um plano para fazer os mapas faltantes”, 2026-10-17. Autoriza pesquisa e planejamento documental. Classificação: PLAN_CHANGE_REQUEST, proposta de antecipar preparação dos mapas dentro de S-C1-004; não substitui automaticamente o plano de fechamento nem autoriza runtime/arte. Reutilizar modo per-step escolhido para a campanha; não inferir aprovação das etapas. Integração: Atena neste chat, sem delegação.

## Evidência e autoridade

Inspeção local de data/stages.json em 2026-10-17: nove mapas registrados; reino_abissal, domwieck e raiz_yggdrasil ausentes. Docas existe, mas ainda depende de Dagruve e aponta para Shedaklah. Dagruve já existe: sua adaptação para Thalion é trabalho futuro, não um quarto mapa novo.

Fontes: [fluxo original](../SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/spec.md), [contrato capítulo 1](../SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/chapter1-maps-transitions-r1.md), [aceite CANON r1](../../vault/canon/DEC-NOTTGARD-CHAPTER1-MAPS-CONTRACT-20261016-r1.md), [fechamento](../SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/chapter1-closeout-r1.md) e state/plan.yaml. O cabeçalho DRAFT antigo do contrato não revoga seu aceite CANON posterior. Estado registra S-C1-003, 2/6 concluídas, HQ14 Q2 pendente; HQ15/16/17/18/03 têm sequências aprovadas. Não declarar toda a produção visual encerrada.

## Escopo, não objetivos e impactos

Entregar primeiro Reino Abissal e Domwieck no PC Windows x86_64, ligando Docas ao fim do capítulo 1. Preservar contrato aceito: mapas 60×60, câmera/escala existentes, caminhos contínuos, objetivos por tempo e chegada, sem chefe fictício. Reino Abissal: 360 s e presença de 3 s no acesso ao ritual; Domwieck: 420 s e presença de 3 s no santuário. Ondas, multiplicadores e regras completas vêm do contrato r1, sem rediscuti-los silenciosamente.

Não objetivos: capítulo 2, novo encontro com Thalion, implementação da Raiz, reformulação das camadas existentes, novos heróis/inimigos, dependências, serviços externos, commits ou publicação. Não gerar arte por efeito de aprovar uma etapa técnica. Web permanece portagem pendente conforme exceção PC-only já aprovada para este fluxo; alterações comuns compartilhadas exigem registro e checks nos dois projetos quando autorizados.

Impactos previstos: data/stages.json, catálogos stage_story/rules/events/structures, core/battle.gd, game.gd, profile.gd, hq_catalog.gd, UI de objetivo/menu/resultado, fila narrativa e testes pertinentes. Inventário exato de caminhos/consumidores e baseline será entrega obrigatória antes de editar runtime. Reutilizar recursos locais somente quando adequação e autoridade forem verificadas.

## Plano de voo proposto

| Ordem | Lote / etapa | Entrega e checks | Checkpoint |
| --- | --- | --- | --- |
| 1/7 | B-MAP-001 / S-MAP-001 | Inventário documental dos mapas e contratos; esta proposta r1, sem jogo alterado | Concluída pelo pedido de planejamento |
| 2/7 | B-MAP-001 / S-MAP-002 | Dossiê dos dois ambientes: referências/bíblia aplicáveis, reutilização, planta textual detalhada, obstáculos, rotas, recursos disponíveis/ausentes, arquivos/consumidores e baseline. Confrontar com contrato CANON; zero BLOCKING para a etapa seguinte | CP-MAP-002: aprovar prioridade e autorizar somente preparação documental |
| 3/7 | B-MAP-002 / S-MAP-003 | Suporte comum de conclusão por objetivo e Reino Abissal funcional; usar recursos locais/provisórios explicitamente aceitos. Validar tempo/presença, alcance, limpeza sem XP/loot e conclusão idempotente | CP-MAP-003: aprovação própria após dossiê |
| 4/7 | B-MAP-002 / S-MAP-004 | Domwieck funcional, rotas até Ailalore, leitura da invasão; sem Adam matável, escolta ou vida da estrela. Validar saída/reentrada no alvo, morte/abandono e ausência de bloqueios | CP-MAP-004: aprovação própria |
| 5/7 | B-MAP-003 / S-MAP-005 | Integrar Docas → Reino Abissal → Domwieck → resultado/menu, HQs na ordem aceita, Diário e progresso aditivo novo/legado. Separar apresentação e leitura. HQ14 complementar, respeitando conteúdo efetivamente aceito | CP-MAP-005: aprovação própria e recursos narrativos prontos |
| 6/7 | B-MAP-003 / S-MAP-006 | Regressão dirigida, capturas PC 1280×720/1920×1080, teclado/controle, pausa, retomada, perfis sintéticos e registro de portagem | CP-MAP-006: aprovação própria |
| 7/7 | B-MAP-003 / S-MAP-007 | Playtest humano, ajustes delimitados e aceite dos mapas; reconciliar S-C1-004/005/006 sem duplicar conclusões | CP-MAP-007: aprovação própria e aceite humano |

Quatro etapas concluídas; três restantes. S-MAP-002 documental/dossiê aceitos; S-MAP-003 e ajuste CP-MAP-003A aprovados/executados, com [Reino Abissal validado](../../evidence/EVID-NOTTGARD-MAP003-PROTOTYPE-20261017-r2.md). S-MAP-004 também aprovada e concluída em 2026-10-17: [Domwieck validada](../../evidence/EVID-NOTTGARD-MAP004-PROTOTYPE-20261017-r1.md), oito arquivos delimitados, cinco checks e smoke dos dois protótipos aprovados. Catálogo final dos nove mapas preservado; mapas novos somente em QA. CP-MAP-005/S-MAP-005 integração aguarda aprovação própria e preflight delimitado. Não avançar automaticamente entre checkpoints per-step. A descrição original do pedido acima preserva a origem; esta atualização e o estado vigente governam a autorização atual.

## Prontidão e gaps

- BLOCKING para produção visual: identificar bíblia/referências de ambiente, revisão/autoridade e reaproveitamento. Resolver em S-MAP-002. Identidade de personagem N/A para terreno puro; Ailalore ou qualquer entidade visível exige identidade própria pertinente. Texto aprovado de ambiente não aprova automaticamente aparência nova.
- BLOCKING para runtime: orçamento exato de arquivos, consumidores, baseline concorrente e aceitação dos recursos provisórios; resolver antes de CP-MAP-003.
- BLOCKING para integração final: prontidão das HQs efetivamente admitidas, incluindo pendência HQ14; conferir estado atualizado, sem promover candidatas ou sequências silenciosamente.
- RESOLVABLE: detalhamento espacial e disponibilidade dos recursos locais; dossiê compara soluções ao contrato aceito e apresenta divergências antes de executá-las.
- DEFERRED: Raiz de Yggdrasil, revisão do capítulo 2 e Dagruve/Thalion. Abrir contrato próprio após revisão narrativa; não reutilizar Véu Vivo como identidade de Yggdrasil. Portagem Web e aceites humanos anteriores continuam visíveis.

Zero BLOCKING para executar apenas S-MAP-002 documental após aprovação. A revisão inteira não está pronta para implementação.

## Aceitação e validação

Dois mapas acessíveis e distintos, rotas caminháveis desde spawn, leitura clara de destino/tempo e obstáculos fora das passagens críticas. Respeitar contrato r1 completo de ondas, recompensas, transições e direitos históricos. Não fabricar vitória/abate de Adam, Thalion ou Nidhogg. Cumprir objetivo uma vez; limpeza não cria loot/XP/estatísticas de chefe. Sem conclusão em morte/abandono. Fila HQ recuperável e ordenada, dispensa separada de leitura, replay sem duplicação; capítulo 1 termina sem abrir capítulo 2.

Matriz sintética do contrato r1: perfil vazio, antigo sem vitórias, Dagruve vencida, Docas vencida, camadas avançadas/HQ03 conhecida, HQs arquivadas e fila interrompida. Migração idempotente, moedas/direitos/campos desconhecidos preservados. Nunca carregar save real. Antes de Godot: APPDATA/LOCALAPPDATA e perfil exclusivos, sonda confirmando user_data_dir sintético.

Selecionar checks pelos arquivos realmente alterados: test_data, test_profile, test_save_resilience, test_hqs, test_stage_progress/story/structures, test_map_scale, test_terrain, test_reach_grid, test_battle, test_qa_sandbox e test_catalog. Cobertura nova de fluxo quando necessária para fila/migração/permissões reais; não criar testes que só repitam dados. Não rodar jogo/testes para validar este plano documental.

Playtest futuro: informar build, rota, objetivos 360/420 s e presença 3 s, procedimento e feedback esperado sobre orientação, dificuldade, duração e continuidade. Funcionamento técnico não comprova diversão. Valores iniciais só mudam com evidência e aprovação pertinente.

## Recuperação, retorno e reconciliação

Antes de executar mudança de prioridade aprovada, reler state/plan.yaml e persistir suspensão/cursor efetivos do fechamento: plano r1, S-C1-003, CP-C1-HQ14-Q2-PRODUCTION, modo per-step, preservando autorizações individuais. Relê-lo novamente na volta; não restaurar cópia antiga sobre trabalho de outro chat. Planos de migração, HQ review e separação permanecem intactos. Aprovação de planejamento não os suspende automaticamente.

Antes de runtime registrar hashes e alterações locais; recuperação restrita às próprias edições, com comparação posterior, sem reset global nem migração inversa em save real. Registrar evidência por etapa e portagem pendente; concluir apenas após aceitação/checks e feedback exigidos. Este documento é DRAFT r1; nenhum conteúdo CANON novo, runtime ou arte foi produzido.


## Reconciliação operacional — 2026-10-17

S-MAP-005 satisfeita pela integração S-C1-004; S-MAP-006 pela regressão S-C1-005 e verificações técnicas posteriores; S-MAP-007 pelos aceites humanos do capítulo 1, navegação r2 e artes dos dois mapas. Fechamento do capítulo 1 não encerrara automaticamente este plano; esta reconciliação agora autorizada reúne as evidências e encerra o recorte em 7/7. Controle físico não relatado separadamente; não se fabrica validação de dispositivo. [Evidência](../../evidence/EVID-NOTTGARD-MAPS-RECONCILIATION-20261017-r1.md). Nenhum código alterado ou teste repetido.
