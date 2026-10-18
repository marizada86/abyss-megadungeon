---
id: SPEC-NOTTGARD-DAGRUVE-CHAPTER2-20261017
revision: r1
status: S_DAG_004_COMPLETE_AWAITING_CP_DAG_005
origin: planned
implementation_preceded_spec: false
classification: PLAN_CHANGE_REQUEST
approval_mode: per-step
---

# Dagruve — proposta de continuação após Yggdrasil

Pedido: “vamos continuar”, após encerramento da arte de Yggdrasil em5/5. Autoriza examinar a continuidade e preparar esta proposta documental; não constitui autorização de novo encontro, gatilho, alteração de save ou implementação. Plano anterior permanece concluído, sem suspensão/retorno pendente. Não substituir o plano geral de campanha nem os planos de produção HQ concorrentes.

## Evidência e recomendação

[Yggdrasil concluída](../../vault/canon/DEC-YGGDRASIL-ART-PLAYTEST-ACCEPTED-20261017-r1.md), Reino Abissal e Domwieck aceitos. [Roteiros capítulo2 CANON r2](../../vault/canon/CHAPTER2-SCREENPLAYS-APPROVED-20261017-r2.md): HQ19 Q1–4 antes de Dagruve e Q5–12 depois; Thalion sobrevive, Maelor é enviado depois do interrogatório e Aila permanece com Thalion. [HQ21](../../vault/canon/HQ21-SCREENPLAY-APPROVED-20261017-r1.md) reúne os núcleos em Shedaklah sem sincronizar suas chegadas.

data/stages.json já contém Dagruve. data/chapter_flow.json implementa somente capítulo1; Yggdrasil continua QA-only. Portanto a prioridade proposta é preparar a adaptação de Dagruve e seu encontro com Thalion antes de ligar Yggdrasil à campanha. Não há evidência de necessidade de outro mapa inteiramente novo neste recorte. Planejamento da integração completa do capítulo2 permanece separado.

## Escopo e não objetivos

Inventariar Dagruve atual, terreno, rotas, inimigos/chefe, objetivos, recursos locais, consumidores e regras herdadas. Elaborar contrato para confronto que termine sem matar Thalion, sem atribuir mecânica nova ao roteiro por inferência. Identificar o que pode ser reutilizado e o que exige aprovação específica; propor valores iniciais apenas como DRAFT. Conservar IDs, saves, capítulo1 e mapas aceitos. PC Windows x86_64; sem sincronização ou escrita na origem.

Não objetivos: produzir HQs, gerar arte, adaptar Yggdrasil novamente, criar personagens/inimigos ou instalar dependências, alterar campanha/saves neste planejamento, publicar ou portar Web. Responsável pela integração futura: Atena, sem delegação. Bíblia visual/identidade de Thalion e evidência dos recursos serão verificadas antes de qualquer ação visual; nenhuma produção visual autorizada aqui.

## Etapas propostas

1. S-DAG-001 — auditoria inicial de continuidade e proposta r1: concluída documentalmente por este pedido,1/5.
2. S-DAG-002 — dossiê do mapa existente e contrato DRAFT do encontro, incluindo saída sem morte, recursos, lacunas, consumidores, teto de arquivos e validação; CP-DAG-002 após aprovação deste recorte. Somente documentos.
3. S-DAG-003 — protótipo funcional QA isolado, com recursos locais/provisórios explicitamente aprovados, preservando campanha e perfis; implementação exige contrato aprovado e autorização própria.
4. S-DAG-004 — testes isolados e capturas do protótipo, navegação, saída do encontro, morte/abandono, regressões e comparação de custo conforme risco; checkpoint próprio.
5. S-DAG-005 — playtest humano, ajustes delimitados, aceite e registro; checkpoint próprio, sem integração automática à campanha.

Modo per-step reutilizado do fluxo já escolhido pelo dono; não exige escolher modalidade novamente. Próximo checkpoint CP-DAG-002: aprovar prioridade/recorte e autorizar o dossiê documental. As etapas futuras não estão autorizadas.

## Aceitação, gaps e recuperação

S-DAG-002 entrega inventário com caminhos/hash e uso permitido; separação CANON/DRAFT; proposta concreta de objetivos e encerramento sem morte; preservação de rotas/regras existentes; orçamento de implementação e checks proporcionais; zero BLOCKING antes de apresentar execução. Não executar Godot para validar apenas a proposta.

RESOLVED: roteiro e sobrevivência de Thalion, mapas anteriores aceitos, plataforma e modo por etapa. RESOLVABLE no dossiê: terreno, recursos de Thalion, identidade visual, mecânica de encerramento, valores de combate e orçamento. BLOCKING para implementar: contrato do encontro e recursos ainda não inventariados/aprovados. DEFERRED: campanha completa, transições/HQ19 técnica, saves e arte final caso necessite produção própria.

Validação desta proposta: referências locais e consistência com roteiro/estado atual. Recuperação documental limitada aos arquivos deste recorte; nenhuma restauração de estado compartilhado antigo. Autorização do dossiê não autoriza implementação nem promoção canônica de propostas de mecânica.


## Aprovação e entrega

Usuário aprovou o recorte r1 e autorizouS-DAG-002: “aprovado autorizado”. [Dossiê r1](dossier-r1.md) preparado,2/5 entregas; três restantes. CP-DAG-003 exige aprovação própria do contrato e do protótipo. O aceite do recorte não promove mecânica nova a CANON.


## Contrato aprovado e protótipo entregue — 3/5

Usuário aprovou o contrato r1 e autorizouS-DAG-003 nos oito caminhos. [Evidência](../../evidence/EVID-NOTTGARD-DAGRUVE-PROTOTYPE-20261017-r1.md). Quatro testes básicos e inicialização/conclusão/abandono isolados passaram. Rotas oeste contornam props preservados; encerramento rápido teve retenção intermitente e diagnóstico final limpo, observação específica da [S-DAG-004](validation-r1.md), ainda não autorizada. Duas etapas restantes. Texto DRAFT/autorizações pendentes acima é histórico; não promove arte/Thalion final.


## Validação concluída — 4/5

[Resultado técnico](../../evidence/EVID-NOTTGARD-DAGRUVE-VALIDATION-20261017-r1.md):19 checks distintos válidos, Dagruve padrão equivalente ao baseline320s, capturas e A-B dentro do limite. Encerramento do harness limpo ao finalizar áudio antes de sair; sem alteração global de Sfx. [Playtest S-DAG-005](playtest-r1.md) aguarda autorização. Uma etapa restante.
