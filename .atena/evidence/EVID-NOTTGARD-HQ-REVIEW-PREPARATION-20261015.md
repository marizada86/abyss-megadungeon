# Evidência de preparação das HQs — 2026-10-15

Pedido: planejamento Guided ADD para validar individualmente textos e imagens e refazer o necessário. Classificação: PLAN_DEVIATION proposto, sem execução do desvio.

Leituras: regras globais, RTK, guia games-and-visuals, .atena/add.yaml, estado compartilhado, procedência, spec da separação PC/Web, data/hqs.json, core/hq_catalog.gd, ui/hq_screen.gd, tests/test_hqs.gd e referências históricas pertinentes na origem: SPEC-080, SPEC-095, SPEC-098 e PLAN-040. SPEC-080 é histórico anterior ao catálogo atual; não reutilizar suas antigas pendências como se fossem o estado corrente.

Constatações: catálogo atual hqn_01–hqn_14, quatro pares image/text por HQ; legenda separada da imagem; catálogo resolve ordem e desbloqueios por progresso/conquista. Os 56 PNGs estão listados em assets/hq. O teste existente valida catálogo, gatilhos, quatro quadros, recursos, proporção aproximada 16:9, leitor, replay e perfis. Nenhum teste Godot, playtest, auditoria visual ou produção de imagem foi executado nesta preparação; existência textual não prova qualidade visual.

O ADD PC preserva procedência histórica, mas não contém bíblia visual/narrativa completa em seu canon local. Fontes por cena e referências de personagens devem ser identificadas antes da revisão visual e produção. As regras históricas lidas incluem perspectiva do grupo, restrições de spoilers, identidade relativa de personagens e candidatas aprovadas individualmente. Essas aprovações históricas não equivalem ao novo aceite pedido pelo dono.

Plano preservado: PLATFORM-SPLIT r1, 5/5, CP-SPLIT-02, playtest humano pendente. Antes desta preparação, Git registrava project.godot modificado e quatro .attempt1 não rastreados em generated/resource-cleanup-execution-20261012; não foram alterados.

Saída: spec DRAFT r1 e registro das 14 HQs. Modo e escopo PC/Web aguardam decisão; nenhum conteúdo narrativo promovido a CANON e nenhum arquivo de runtime alterado. Não foi acessado serviço remoto nesta preparação.

Decisão posterior do dono, ainda em 2026-10-15: "3, aprovado". Registrada aprovação da revisão r1 e seleção per-step. A resposta não explicita a escolha entre PC+Web e somente PC, solicitada separadamente; GAP-HQ-002 permanece aberto. Nenhuma aprovação já recebida será repetida. Execução 0/16, suspensão do plano anterior não iniciada.
