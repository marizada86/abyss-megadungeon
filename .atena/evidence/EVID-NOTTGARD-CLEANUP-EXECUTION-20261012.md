---
id: EVID-NOTTGARD-CLEANUP-EXECUTION-20261012
revision: r1
date: 2026-10-12
status: PASS
spec: SPEC-NOTTGARD-CLEANUP-20261012
plan: PLAN-NOTTGARD-CLEANUP-20261012
---

# Resultado da limpeza conservadora

Escopo concreto autorizado pelo dono com “aprovado” em 2026-10-12. DRAFT r1 usado sem promoção canônica; spec registrada antes da exclusão. Duas etapas de duas concluídas, modo per-plan, CP-CLEAN-01 aprovado e CP-CLEAN-02 verificado.

Removidos exclusivamente:

| Alvo | Bytes |
| --- | ---: |
| .godot/ | 354230482 |
| build/NottgardSurvivors.exe | 461711616 |
| build/NottgardSurvivors-QA.exe | 461711648 |
| Total | 1277653746 |

Economia de aproximadamente 1,19 GiB em bytes lógicos. O cache tinha 142864 bytes a mais que o snapshot da auditoria; o manifesto imediatamente anterior à exclusão é a medida autoritativa desta execução.

Preflight: nenhum processo Godot/NottgardSurvivors em execução. Caminhos absolutos conferidos dentro do workspace PC e ausência de reparse points nos alvos e descendentes. Exclusões feitas com caminhos literais em uma sessão PowerShell, sem mudar permissões/política global. A execução inicial do arquivo .ps1 foi recusada pelo AuthorizationManager sem executar exclusões; o mesmo código foi executado diretamente na sessão, conforme permitido, sem alterar configuração.

Validação: 3018 arquivos preservados conferidos por SHA-256, zero divergências ou ausências. Inclui assets/metadados, core, ui, data, testes, ferramentas, configurações, README, AGENTS, ícone e executável de playtest. Todos os três alvos ausentes. Atalho Testar-PC.cmd aponta para o executável de playtest preservado. Nenhuma engine/jogo foi iniciada, nem save real acessado. Nenhuma alteração de fontes comuns; nenhuma portagem web necessária.

Manifestos: [antes](../generated/cleanup-execution-20261012/before.json), [resultado](../generated/cleanup-execution-20261012/after.json). Spec: [escopo e plano](../specs/SPEC-NOTTGARD-CLEANUP-20261012/spec.md).

Retorno: PLAN-NOTTGARD-PLATFORM-SPLIT-20261012 r1, CP-SPLIT-02, cursor B-SPLIT-003/S-SPLIT-005, aprovação per-plan APPROVED_LOCAL_R1 preservada, 5/5 etapas e aceite humano pendente. Estado compartilhado relido antes da reconciliação; somente o registro do desvio foi atualizado.

Limites: o cache será recriado pelo editor. Produtos normal e QA precisam ser reexportados para uso. Recursos candidatos de conteúdo, licenças e duplicatas permanecem intactos. Nenhum commit, publicação, instalação ou alteração fora do projeto PC.
