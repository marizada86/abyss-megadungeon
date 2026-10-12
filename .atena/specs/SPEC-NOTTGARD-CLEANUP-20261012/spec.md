---
id: SPEC-NOTTGARD-CLEANUP-20261012
revision: r1
status: DRAFT_AUTHORIZED_LOCAL_R1
origin: guided-add
implementation_preceded_spec: false
---

# Limpeza conservadora local

Escopo aprovado em 2026-10-12 pela resposta do dono “aprovado” à proposta concreta do relatório EVID-NOTTGARD-CLEANUP-AUDIT-20261012. Autorização interpretada como aprovação única de todo esse escopo, modo per-plan, conforme a opção de continuação apresentada no chat. CP-CLEAN-01: APPROVED_LOCAL_R1. Sem promoção canônica.

Remover somente `.godot/`, `build/NottgardSurvivors.exe` e `build/NottgardSurvivors-QA.exe` deste projeto PC. Preservar executável de playtest, atalho, fontes, assets, .import/.uid externos ao cache, testes, ferramentas, presets e contratos ADD. Não remover os candidatos de conteúdo da auditoria nem modificar web/origem. Não instalar, abrir jogo, acessar saves, publicar ou executar exports.

Aceitação: três alvos ausentes; hashes de todos os recursos/fontes/configurações/ferramentas/testes e produto de playtest preservados; atalho continua apontando para produto existente; registrar bytes removidos e retorno ao checkpoint de separação. Arquivos gerados localmente não exigem portagem de fontes comuns.

Impactos: cache reaparece no próximo uso do editor; variantes normal/QA precisam de novo export para uso. Recuperação consiste em reimportar com engine existente e reexportar presets existentes, mediante pedido futuro; não há recuperação byte a byte do cache apagado. Nenhum conteúdo material de autoria está no escopo de exclusão.

Evidência: [auditoria](../../evidence/EVID-NOTTGARD-CLEANUP-AUDIT-20261012.md), [inventário](../../generated/cleanup-audit-20261012/inventory.json). Gaps BLOCKING: zero após preflight confirmar processos fechados, limites literais do workspace e inexistência de reparse points nos alvos. Candidatos de assets são DEFERRED, sem autorização de exclusão.

Plano PLAN-NOTTGARD-CLEANUP-20261012 r1, B-CLEAN-001:

1. S-CLEAN-001: confirmar limites/processos, registrar manifesto e hashes, excluir exclusivamente os três alvos autorizados.
2. S-CLEAN-002: verificar ausência dos alvos e integridade dos arquivos preservados, registrar resultado e restabelecer o checkpoint original.

Checks estáticos e hashes são suficientes para esta remoção de produtos gerados. Rodar Godot recriaria o cache e invalidaria a economia pretendida; não executar smoke/engine nesta etapa. Revisão humana/playtest do plano original permanece pendente. Responsável: Atena neste chat; sem delegação.

Classificação PLAN_DEVIATION: suspensão delimitada somente durante execução, com retorno a PLAN-NOTTGARD-PLATFORM-SPLIT-20261012 r1, CP-SPLIT-02, B-SPLIT-003/S-SPLIT-005, 5/5 etapas, aprovação per-plan APPROVED_LOCAL_R1 preservada. Não substituir nem encerrar o plano original.
