# Retomada no projeto Abyss Megadungeon — 2026-10-22

Este projeto F:/dev/abyss-megadungeon é a fonte operacional da frente de assets, conforme decisão explícita do dono. Nome de continuidade: Abyss Megadungeon. A worktree de nottgard-survivor é origem histórica, sem sincronização automática nem nova implementação.

## O que já terminou

- Produção 8/8: 129 PNGs e prompts; 125 candidatas selecionadas, quatro versões substituídas.
- Aceite visual: explícito para as 125 fontes por ID/revisão/hash em ../asset-production-20261021-r1/visual-acceptance.json. Não pedir novamente.
- Preparação 5/5: 158 derivados, 62 peças de UI/Quartel, 36 poses, 12 sprites estáticos e 48 folhas de transição. Auditoria e galeria em ../asset-preparation-20261021-r1/.
- Entregas assets_incoming e a integração parcial PC dc4a917 já existiam e foram preservadas. Verificar o HEAD atual antes de novas alterações.

## Onde retomar

Estado: .atena/state/plan.yaml, seções asset_preparation_2026_10_21, asset_production_proposal_2026_10_21 e asset_integration_proposal_2026_10_21. Modo per-plan preservado. Proposta executável somente após aprovação de escopo: ../asset-preparation-20261021-r1/integration-proposal.md. Checkpoint S-I01/INTEGRATION_SCOPE_APPROVAL_PENDING, 0/6 etapas.

Proposta: integrar UI/HUD e Quartel restantes e adaptar N01 ao consumer existente npc_reaper_barqueiro. N02–N10 ficam como reserva de arte; novos eventos/chefes não foram aprovados. N11 reutiliza mímico. V10 sprite permanece retido pela compatibilidade das folhas. Não interpretar a transferência como aprovação dessa proposta.

Conteúdo visual permanece DRAFT, apesar do aceite. Nenhuma promoção de arte/lore a CANON. Somente a decisão explícita de continuidade/nome foi registrada em DEC-ASSET-WORKFLOW-TRANSFER-20261022-r1.

## Integridade e execução local

As duas pastas asset-production e asset-preparation são irmãs: caminhos relativos dos jobs e do audit.ps1 funcionam no destino. Usar o Godot já existente na raiz deste projeto; nenhum pacote novo é necessário. Projeto sintético de preparação não carrega autoload ou save real.

A cópia foi conferida por SHA-256. Referências internas a imagens geradas foram resolvidas para as fontes transferidas, quando aplicável; generated_source e original_references preservam a proveniência. Caminhos históricos em evidências não foram reescritos como se sempre pertencessem ao destino. Referências CANON do Vault continuam somente leitura.

Antes de executar: conferir AGENTS.md, add.yaml, estado atual e backlog; preservar outros trabalhos. Executar checks de assets e integração no projeto atual; aceite das fontes não prova funcionamento, animação ou diversão em jogo. Sem commit/push/merge/exportação autorizados por esta transferência.

Limite da interface: este chat não foi movido no Codex. A ferramenta exigiu adicionar o repositório antigo como origem do projeto novo; essa mudança extra não foi confirmada. A continuidade operacional e todos os arquivos estão neste destino. Abra este projeto para retomar, ou use explicitamente este diretório nas operações.
