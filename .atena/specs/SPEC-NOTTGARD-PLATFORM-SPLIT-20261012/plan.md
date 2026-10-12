# Plano de separação PC e web

PLAN-NOTTGARD-PLATFORM-SPLIT-20261012, DRAFT r1. Modo `per-plan`, escolhido pelo dono em 2026-10-12. CP-SPLIT-01: APPROVED_LOCAL_R1 em 2026-10-12 (“aprovado”). Implementação local: 5 de 5 etapas executadas; CP-SPLIT-02 aguarda playtest humano.

| Ordem | Lote e etapa | Objetivo e entradas | Saída e checks |
| --- | --- | --- | --- |
| 1 | B-SPLIT-001 / S-SPLIT-001 | Fixar a base a partir da origem, estados ADD atuais e alvos confirmados | Manifesto seletivo, hashes, baseline comum, engine/templates confirmados, suspensão delimitada com retorno PLAN-071 B-006/S-011; destino disponível |
| 2 | B-SPLIT-001 / S-SPLIT-002 | Criar os dois projetos a partir do manifesto | Fontes/recursos locais, contratos ADD e estados próprios com procedência, imports válidos; nenhum arquivo da origem alterado exceto registro operacional delimitado autorizado |
| 3 | B-SPLIT-002 / S-SPLIT-003 | Especializar o projeto PC | Somente presets Windows; controle de computador e evidência local; sem caminhos ativos mobile/web; suíte pertinente e candidato Windows |
| 4 | B-SPLIT-002 / S-SPLIT-004 | Especializar o projeto web | Somente preset Web; shell/bridge preservados; sem caminhos ativos mobile/nativos; suíte pertinente e candidato HTML/WASM/PCK |
| 5 | B-SPLIT-003 / S-SPLIT-005 | Validar isolamento e compatibilidade | Matriz comum/específico, save sintético, smoke e checks dos candidatos, orientação de playtest, relatório e retorno operacional preservado |

O dono aprova o escopo concreto r1 no CP-SPLIT-01 antes de iniciar S-SPLIT-001. Autorização por plano permite seguir as cinco etapas sem aprovações repetidas no mesmo escopo. Falha material, necessidade de dependência, sobrescrita, migração de save ou expansão de plataforma exige nova decisão delimitada.

CP-SPLIT-02 é a revisão dos dois candidatos e aceite humano, após validação técnica. Teste físico de controle e feel permanecem pendentes até feedback; nenhuma evidência automatizada substitui esse aceite. Publicação e commits não estão autorizados por nenhum destes checkpoints.

Responsável pela integração: Atena neste chat. Sem delegação ou especialistas. Identidade visual/bible: preservar referências e revisões existentes; não há produção nem revisão artística neste plano.

Após cada etapa, registrar resultado, evidência, contagem e próxima entrada/saída/checks. Revalidar hashes se a origem mudar; nunca substituir alterações de outro chat por um snapshot anterior. Ao concluir, reler estados antes de reconciliar fatos e registrar retorno, sem declarar resolvidos os aceites pendentes do PLAN-071.

Entrega e limites: [revisão local](../../generated/platform-split-execution-20261012/REVIEW.md).
