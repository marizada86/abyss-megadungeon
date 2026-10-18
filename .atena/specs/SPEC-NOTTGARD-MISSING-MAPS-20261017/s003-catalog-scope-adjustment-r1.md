---
id: CHANGE-NOTTGARD-MAP003-CATALOG-20261017-r1
status: APPROVED_EXECUTED_VALIDATED
classification: PLAN_CHANGE_REQUEST_WITHIN_S_MAP_003
checkpoint: CP-MAP-003A
origin: planned
implementation_preceded_spec: false
---

# Ajuste delimitado — cadastro do protótipo

Atualização operacional de 2026-10-17: aprovado explicitamente pelo dono e executado. [Evidência final r2](../../evidence/EVID-NOTTGARD-MAP003-PROTOTYPE-20261017-r2.md) confirma orçamento, contratos existentes preservados e validação. O texto de proposta abaixo conserva o escopo apresentado para autorização; as pendências históricas nele descritas estão resolvidas pela evidência final. CP-MAP-003A satisfeito; S-MAP-003 concluída, 3/7; CP-MAP-004 pendente.

O protótipo funcional foi implementado dentro dos caminhos aprovados, mas a validação ampliada revelou que registrá-lo em data/stages.json o inclui em todos os contratos de fases finalizadas. Não é correto declarar S-MAP-003 concluída com esses contratos quebrados. Também não cabe completar história, crônica, estrutura oficial ou trilha final por efeito de um protótipo.

## Evidência concreta

Oito grupos focados passaram: test_map_objectives, test_data, test_battle, test_stage_progress, test_terrain, test_map_scale, test_level_design e test_qa_sandbox. A cobertura de objetivo foi repetida após adicionar simulação integral de 360 + 3 s, também passou. Smoke real em OpenGL passou após corrigir seleção de menu, com cinco capturas, perfil sintético preservado e nenhum erro na execução final.

Validação adicional falhou em três pontos confirmados: test_stage_story exige texto de história para reino_abissal; test_stage_structures exige estrutura oficial; test_game_design exige regra principal em stage_rules. Leitura dirigida identificou outros consumidores globais: test_audio exige música/ambiência próprias; test_chronicles exige crônica; test_ground_decals exige dois decais; test_fog_edge tenta criar chefe para toda fase. Esses quatro riscos foram identificados estaticamente, não apresentados como testes já executados.

## Mudança recomendada, ainda não executada

1. Acrescentar **data/prototype_stages.json**, contendo somente a definição QA de Reino Abissal, com qa_only=true, objetivo e ondas aprovados. Remover de data/stages.json exclusivamente a entrada acrescentada nesta etapa, preservando os nove mapas anteriores e eventuais mudanças concorrentes.
2. Em core/battle.gd, disponibilizar consulta delimitada da definição (catálogo final e, se ausente, catálogo de protótipos). A simulação pura continua utilizável pelos testes. A interface de run exige Game.qa_sandbox para qa_only antes de iniciar combate.
3. Adaptar apenas os consumidores já autorizados ui/run.gd e ui/hud.gd para consultar essa definição ao validar a entrada e apresentar resultado. Não alterar core/game.gd/profile.gd nem abrir acesso de campanha. O menu normal continua com os nove mapas; o protótipo usa pedido QA explícito e testes isolados.
4. Atualizar test_map_objectives para conferir que o protótipo permanece fora do catálogo final, abre por QA, não muda o perfil e mantém os comportamentos já verificados. Não remover nem afrouxar as exigências de fases finalizadas nos testes antigos.

## Orçamento e limites

Adicionar somente um caminho de jogo à lista aprovada: data/prototype_stages.json. Retirar tests/test_battle.gd da lista de edição de S-MAP-003, pois não precisou ser modificado; permanece teste de regressão. O teto continua **13 arquivos de jogo/teste**, incluindo restauração delimitada da entrada global. Demais caminhos e limites da etapa continuam os mesmos. Arquivos ADD/helper de validação permanecem registros operacionais.

Sem estrutura arquitetural nova, biblioteca, dependência, herói, inimigo, lore, arte final, áudio novo, migração, integração de HQs, Domwieck ou escrita Web. É separação local de catálogo do protótipo; não revisa o contrato final da campanha. Publicação/commit continuam sem autorização.

## Aceitação, checks e recuperação

Catálogo final deve conservar exatamente os nove registros anteriores; protótipo não pode aparecer no menu normal ou iniciar fora de QA. QA deve carregar cena/objetivo e apresentar resultado sem lookup ausente nem alteração de perfil. Repetir objetivo/smoke por mudança dos consumidores; executar os três checks que falharam e os quatro consumidores de risco identificados, mantendo seus contratos. Verificar que a remoção do cadastro global resolveu a causa, sem tratar conteúdo faltante como arte aprovada. Revalidar isolamento antes de Godot, jamais save real.

Baseline de recuperação anterior está em generated/missing-maps-20261017/s003-before; copiar apenas arquivos próprios após comparar mudanças posteriores. Preservar a implementação atual para revisão até aprovação; nenhuma restauração global ou modificação dos sete testes externos à lista foi feita.

CP-MAP-003A solicita autorização para esse único caminho adicional/troca de lista e adaptação delimitada. S-MAP-003 continua em andamento, 2/7 etapas concluídas, cinco restantes. Não solicitar S-MAP-004 enquanto regressões e ajuste de escopo estiverem pendentes.
