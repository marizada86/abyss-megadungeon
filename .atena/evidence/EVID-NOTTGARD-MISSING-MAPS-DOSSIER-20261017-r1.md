---
id: EVID-NOTTGARD-MISSING-MAPS-DOSSIER-20261017-r1
status: COMPLETE_DOCUMENTARY
step: S-MAP-002
date: 2026-10-17
---

# Evidência — ambientes e recursos dos mapas

Autorização explícita do dono: priorizar mapas e iniciar S-MAP-002, detalhando Reino Abissal e Domwieck. Executada somente documentação/pesquisa local. Responsável: Atena, sem delegação. Plano PLAN-NOTTGARD-MISSING-MAPS-20261017 r1, modo per-step.

Entrega: [dossiê DRAFT r1](../specs/SPEC-NOTTGARD-MISSING-MAPS-20261017/environments-resources-r1.md), [baseline](../generated/missing-maps-20261017/baseline-r1.json), [validação](../generated/missing-maps-20261017/validation-r1.json) e [auditoria reproduzível](../generated/missing-maps-20261017/audit-r1.ps1). Baseline é informativa; não contém blobs de recuperação e deve ser revalidada antes de escrita futura.

Leituras dirigidas: add.yaml, estado vigente, plano de mapas, contrato e aceites do capítulo 1, guia de jogos, bíblia consolidada DRAFT r2, decisões de solo de raízes/jardim/estrela, aceites HQ17/18/03, catálogos e consumidores delimitados. Não foi necessário consultar serviços remotos ou reler relatos pessoais do vault externo.

Inspeção visual direta: HQ17 Q3 v02, HQ18 Q3 v01, HQ03 Q1 v03; braseiro_01/02/03, carga_01/02/03, coluna_01, flor_01, cristal_01, dagruve_estrutura_01 e dagruve_ground_atlas_v3. Raízes integram todo o piso abissal; cidade/jardim têm outra matéria. Flor existente branca/violeta não atende jardim vermelho, cristal vermelho não atende estrela azul-clara, casa de Dagruve não é arquitetura élfica pronta. Variantes de braseiro 02/03 são violetas, por isso família omitida do protótipo recomendado; carga 01/02/03 serve ao reuso genérico proposto. Sprites dos cinco inimigos tiveram existência conferida, sem alegação de nova auditoria visual individual.

Achados técnicos: menu indexa enemies[d.boss] diretamente; QA tem _spawn_qa_boss sem guarda para boss vazio; conclusão comum está acoplada a _on_boss_dead e cria drops/Maré. StageProgress possui modos fase/chefe/Maré, sem objetivo. SceneryLayout pode substituir props da cena, prioriza scenery sobre level_design e usa folga 5, menor que os 6 exigidos. TerrainLayout aplica scale sobre desenho 40×40; level_design usa 60×60. Estrutura decorativa pode reposicionar e não deve definir alvo lógico. Registrados no dossiê com orçamento futuro, sem alterações de jogo.

Auditoria final PASS_DOCUMENTARY_CHECKS: dois documentos, 14 links, 88 caminhos delimitados (83 existentes e cinco novos previstos), nove mapas atuais, três IDs de mapas ausentes, cinco inimigos do contrato existentes e três hashes das referências aceitas coincidentes com manifestos. Hashes existentes permaneceram iguais entre captura e conferência da auditoria. Não comprova ausência de mudanças em áreas fora do inventário e não substitui preflight futuro. Script teve correção local de literal booleano antes do resultado final; nenhuma falha foi suprimida.

Arte final ainda ausente/prontidão de integração pendente. Dossiê oferece opção concreta de protótipo DRAFT sem bitmap novo; aceite/execução CP-MAP-003 pendente. Plantas são propostas textuais, não verificação executável de alcance. Não executados Godot, testes de jogo ou playtest. Nenhum save real/sintético carregado, recurso gerado/adaptado/admitido, dependência instalada, arquivo Web editado, commit/push/publicação efetuado.

Estado concorrente preservado: HQ14 avançou durante a documentação, de Q2 em produção para Q2 aprovada/Q3 pendente. Outro trabalho também atualizou seu cursor de retorno; não restaurar o snapshot inicial. O bloco missing_maps registra a prioridade documental e conserva o retorno vigente. Planos anteriores e autorizações individuais permanecem.

S-MAP-002 concluída: 2/7 etapas, cinco restantes. Próximo objetivo S-MAP-003 = suporte de conclusão por objetivo e Reino Abissal funcional apenas em QA sintética, dentro de orçamento de 13 arquivos de jogo/teste, sem Domwieck/fluxo/saves novos. Entradas: contrato CANON, aceite do dossiê/protótipo, baseline recapturada e checks de preflight. Saída: protótipo verificável e evidência focada. CP-MAP-003 exige autorização própria pelo modo per-step, não satisfeita pelo pedido documental atual. Web/capítulo 2/arte final continuam pendentes conforme o dossiê.
