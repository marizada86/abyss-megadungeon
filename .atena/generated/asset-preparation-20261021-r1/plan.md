# Preparação após aceite — DRAFT r1

Origem: continuidade autorizada pelo dono (“aprovado o aceite, continue”), após aceite das 125 fontes selecionadas. Modo per-plan preservado. Esta continuação técnica é IN_PLAN para preparação reversível prevista na lista r1; não substitui PLAN-103 nem os planos do projeto PC.

1. S-P01 — registrar aceite por ID/revisão/hash e conferir integração existente no PC.
2. S-P02 — separar, remover fundos e dimensionar UI/HUD e Quartel restantes em pasta isolada.
3. S-P03 — preparar 36 poses, 12 sprites e folhas de transição do lote N, sem criar novos consumers/eventos.
4. S-P04 — conferir contagens, dimensões, alfa, margens, procedência e galeria; reter derivados com defeitos.
5. S-P05 — reconciliar com a integração PC existente e preparar a decisão sobre admissão dos derivados.

Escopo: U09–U21, Q02/Q03/Q05/Q07–Q10 e N01–N10 (doze entidades). N11 reusa fonte existente. V10 sprite mantém a retenção documentada pela integração PC por incompatibilidade com folhas atuais. Preservar U/V/Q/C já integrados em dc4a917. Não reexecutar jobs que escrevem em assets/.

Saídas versionadas em .atena/generated/asset-preparation-20261021-r1/; fontes e Vault somente leitura. Usar cópia local de tools/asset_prep.gd do PC, com origem/hash registrados, adaptada para caminhos isolados, recortes explícitos e remoção de fundo cinza conectada às bordas (preservar interiores cinza de roupas/cabelo). Nada de dependências novas. SceneTree isolado, sem autoload do jogo nem save real.

Identidade e contexto: visual-readiness.md da produção, revisões CANON já conferidas; adaptações permanecem DRAFT visualmente aceitas. UI sem personagem: identidade N/A. N = poses isoladas por entidade/época, sem novo evento narrativo. Continuidade não promove CANON. Animação procedural de transição é temporária e não equivale a animação desenhada nem playtest.

Aceite técnico: saída existente não vazia, dimensões do job, alfa transparente onde previsto, contagem por peça, sem corte aparente, PNG válido e fontes intactas. Nine-slice e repetição de U10 exigem inspeção separada. Recuperação: retirar apenas derivados novos; nenhum runtime é sobrescrito nesta preparação.

Pendente real: o lote N contém usos sugeridos sem consumers aprovados para a maioria das entidades. Preparar arte não autoriza criar chefes, eventos ou mecânicas. A decisão de admissão identifica os consumers existentes e as lacunas; novos usos exigem aprovação específica. Não presumir aceite de jogo do aceite das fontes.
