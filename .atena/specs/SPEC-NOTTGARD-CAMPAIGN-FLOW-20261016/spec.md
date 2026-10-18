---
id: SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016
revision: r1
status: DRAFT_AWAITING_SCOPE_APPROVAL
origin: planned
implementation_preceded_spec: false
created: 2026-10-16
---

# Novos mapas e HQs — progressão PC

## Objetivo e autoridade

Entregar no PC uma campanha que comece nas Docas, distinga a primeira incursão abissal da jornada posterior e intercale HQs na sequência solicitada pelo dono. Capítulo 1 termina no sacrifício de Helion; capítulo 2 abre em Dagruve e leva à separação pelo antagonista Thalion, que permanece vivo.

Proposta DRAFT r1, baseada na [pesquisa local](../../evidence/EVID-NOTTGARD-CAMPAIGN-FLOW-20261016.md), nos roteiros HQ01/HQ02 aprovados e nas decisões locais de capítulos e chegadas. Aprovação do modo per-step e da plataforma PC já foi dada neste turno; aprovação do escopo completo e dos próximos checkpoints está pendente. Nenhum runtime foi alterado.

## Escopo proposto

- Reordenar abertura para Docas; adaptar Dagruve existente ao encontro com Thalion.
- Acrescentar três mapas: `reino_abissal` (primeira incursão), `domwieck` (retorno durante a invasão) e `raiz_yggdrasil` (segunda travessia). Nomes técnicos novos são propostas; conferir colisões na etapa técnica. Não renomear IDs existentes.
- Adicionar sete HQs, com IDs candidatos `hqn_15` a `hqn_21`, mantendo os 14 existentes. A posição narrativa é independente do número do ID. Quantidade de quadros será definida nos roteiros.
- Manter HQ01/HQ02 aceitas; usar HQ03 para sacrifício/Véu Vivo no marco de Domwieck; reaproveitar roteiro HQ03 r1 em revisão e abertura de capítulo 2 r2 como DRAFT.
- Integrar ordem, mapas, encontros, gatilhos, diário/replay e progressão nova/legada com testes isolados. Não apagar conteúdo herdado; retirar elementos do caminho principal preservando registros/assets quando necessário.
- PC Windows x86_64 somente, por escolha explícita do dono em 2026-10-16. Registrar divergência e portagem Web pendente. A revisão HQ anterior conserva seu escopo PC/Web; este pedido não cancela os compromissos anteriores.

## Sequência proposta

| Ordem | Tipo / ID | Conteúdo e saída |
| --- | --- | --- |
| 1 | HQ existente `hqn_01` | Uma Noite Sem Fim; abertura antes da primeira partida |
| 2 | Mapa existente `docas` | Galpões/porão ritual; primeiro mapa liberado |
| 3 | HQ existente `hqn_02` | Seremos um só, preservada após Docas |
| 4 | HQ nova `hqn_15` | Encontro com Erik além da Tarn; elipse de deslocamento por Skygomork |
| 5 | HQ nova `hqn_16` | Igreja das Sombras e descoberta da passagem |
| 6 | HQ nova `hqn_17` | Descida/portal para a primeira incursão; sem criar mapa adicional da igreja |
| 7 | Mapa novo `reino_abissal` | Raízes, acampamento e caminho do ritual. Primeira incursão; não substituir por Shedaklah |
| 8 | HQ nova `hqn_18` | Kein abre a passagem do exército; contextualizar contra-ritual e portal de retorno; Adam lidera a invasão |
| 9 | Mapa novo `domwieck` | Invasão de Nottgard, avanço até Ailalore; clímax sem matar Adam |
| 10 | HQ existente `hqn_03` | Sacrifício de Helion/Véu Vivo; encerra capítulo 1 |
| 11 | Mapa existente `dagruve` | Abre capítulo 2. Contextualizar Aila e passagem do tempo antes do encontro; Thalion é antagonista do clímax |
| 12 | HQ nova `hqn_19` | Thalion divide o grupo; envio forçado. Distinguir Leoric/Korrak de prisão/interrogatório e envio posterior de Maelor |
| 13 | Mapa novo `raiz_yggdrasil` | Travessia interplanar após o envio; identidade de Yggdrasil distinta do Véu Vivo |
| 14 | HQ nova `hqn_20` | Marciela encontra Leoric/Korrak; Maelor escapa de Nidhogg (mordida falha), reencontra a mãe; linhas paralelas |
| 15 | HQ nova `hqn_21` | Núcleo material e portal do laboratório de Zynara/QG; Durvall usa essa passagem; reunião sem Aila |
| 16 | Mapas existentes | Shedaklah → Molor → Durao → Feng-tu → Shendilavri → Goranthis → Pilares; HQs restantes mantidas nos seus contextos, salvo revisão aprovada |

As sete HQs novas são divisão editorial recomendada, não roteiros finais. A etapa 3 pode propor fusão sem omitir acontecimentos, mas deve apresentar nova revisão antes de alterar essa contagem. O mapa `raiz_yggdrasil` representa uma rota de campanha; não impõe restrição de herói selecionável nem cria protagonista adicional.

## Decisões firmes e propostas técnicas

Decisões explícitas deste turno: capítulo 1 termina com Helion; combate de Thalion termina com envio e ele sobrevive; somente PC; aprovação por etapa. Mantidas as correções anteriores: Aila fica com Thalion, Nidhogg erra a mordida, Durvall atravessa no laboratório de Zynara. Falas e composições adicionais continuam DRAFT.

Propostas para detalhar na etapa 2:

- Primeira incursão culmina no ritual, com o evento do exército na HQ seguinte. A pesquisa inclui Kein, Beholder e Death Tyrant; escolher quais são jogáveis e quais entram na montagem, sem tratar inimigos ausentes como assets disponíveis.
- Domwieck usa defesa/avanço até o evento de Ailalore; a saída é o sacrifício de Helion, sem inventar morte de Adam.
- Thalion encerra o clímax por evento de captura/envio, não por morte. A conclusão do mapa deve liberar a sequência sem contabilizar assassinato, cadáver, loot de morte ou conquista de abate de Thalion.
- Raiz de Yggdrasil usa travessia/sobrevivência até a saída, sem Nidhogg morto como condição. O ataque fracassado a Maelor pertence à HQ.
- Liberar mapas por predecessores explícitos da nova rota; HQs em fila ordenada, sem repetições obrigatórias em cada partida, com replay no Diário.
- Preservar moedas, personagens, melhorias, conquistas, HQs vistas e mapas antes acessíveis de perfis antigos; não converter a antiga conclusão de Dagruve em vitória sobre Thalion. Oferecer acesso/replay do conteúdo novo sem reset do perfil nem bloquear progresso já conquistado. Contrato exato será fechado na etapa 2.

## Fora do escopo

Mobile; reescrever o vault externo; dependências/instalações; produção remota; compartilhamento; commits, push, publicação, merge ou deploy. Sem nova classe/herói selecionável, sincronização automática Web ou revisão geral das camadas posteriores. Arte e roteiro têm checkpoints próprios; aprovação operacional não promove todo o conteúdo a CANON.

## Gaps e prontidão

| ID | Classe / limite | Tratamento |
| --- | --- | --- |
| GAP-FLOW-001 | RESOLVED | Dono decidiu PC, per-step, fronteira de capítulo e sobrevivência/envio por Thalion |
| GAP-FLOW-002 | BLOCKING para implementação | Fechar contrato dos três mapas: objetivos, ondas/duração, encontros e saídas; etapa 2, sem produção nessa etapa |
| GAP-FLOW-003 | BLOCKING para implementação | Fechar migração, gatilhos/fila, interrupção/retomada e critérios de conclusão sem morte; etapa 2 |
| GAP-FLOW-004 | BLOCKING para arte/integração narrativa | Aceitar roteiros, ligação Aila/pós-Helion, elenco por quadro e referências visuais; etapa 3 e prontidão da etapa 5 |
| GAP-FLOW-005 | RESOLVABLE | IDs novos/consumidores: inventário dirigido na etapa 2; sugestões acima evitam reutilizar hqn_04+ |
| GAP-FLOW-006 | DEFERRED | Portagem Web: registrar proposta, arquivos/revisões e checks necessários; nova autorização antes de escrever/validar destino |
| GAP-FLOW-007 | DEFERRED | Reconciliação externa Sessão 15; correções do dono já prevalecem localmente |

Há zero gaps BLOCKING para aprovar e executar somente o desenho da etapa 2. O plano ainda não está pronto para implementação; todos os BLOCKING aplicáveis precisam estar resolvidos antes da etapa 4 e antes da arte. Não declarar a r1 inteira executável.

## Aceitação e validação planejadas

1. Perfil novo inicia em Docas e segue a tabela sem atalhos involuntários por `unlock`, partidas diretas ou menu. HQ inicial precede o jogo; as demais aparecem na ordem definida.
2. HQ02 e suas imagens/textos aprovados são preservados; HQ03 ocorre no fim de Domwieck. Novos IDs não colidem com existentes; HQs herdadas continuam acessíveis quando já conquistadas.
3. Três mapas novos têm objetivo, encontros, ambiente e saída legíveis; Dagruve termina com envio, sem morte/abate de Thalion. Adam e Nidhogg também não são mortos por esse fluxo.
4. Capítulo 2 explica Aila, separação, interrogatório, Marciela e portal de Zynara sem simultaneidade inventada. Yggdrasil não é confundida com a árvore de Helion.
5. Perfis sintéticos novos e legados cobrem conclusão antiga de Dagruve, Docas e camadas posteriores, HQ03 já vista, conquistas, retomada após interrupção e fila de várias HQs. Carregamento repetido é idempotente e preserva dados.
6. Checks pertinentes: test_catalog, test_profile, test_hqs, test_stage_story, test_stage_structures, test_stage_progress e test_playtest; verificar referências a chefes, arte, mapas/IDs e ordem. Atualizar testes para contratos reais, sem suprimir falhas. Rodar testes de combate somente para os encontros afetados.
7. Godot e prévias sempre com APPDATA/LOCALAPPDATA exclusivos do processo, sonda de user_data_dir e perfil sintético explícito, conforme procedimento de validação herdado. Nunca acessar save real.
8. Conferir teclado/controle, menu, transições, pausa, leitor 1280x720/1920x1080 e replay no Diário. Playtest humano tem build, objetivo, passos e critérios comunicados antes; diversão/dificuldade/arte dependem do dono.
9. Referências ADD, evidências e portagem Web pendente reconciliadas. Testes Web não executados por este escopo; nenhuma alegação de paridade nova.

## Impactos e recuperação

Sistemas previstos: data/stages.json, stage_story/rules/events/structures, enemies/apresentações de chefes, hqs e eventuais conquistas; core/profile.gd, hq_catalog.gd, battle.gd e game.gd; ui/run.gd/menu e apresentação; assets novos/aprovados e testes pertinentes. Lista exata/hashes e contratos serão saída da etapa 2. Não trocar motor ou arquitetura por efeito do planejamento.

Antes da execução, reler estado compartilhado, registrar suspensão/cursor da revisão HQ e preservar sua autorização per-step e compromissos PC/Web. Separação de plataformas permanece CP-SPLIT-02, B-SPLIT-003/S-SPLIT-005, 5/5 com aceite humano pendente. A aprovação da nova proposta pode autorizar trabalho neste escopo e retorno; não deve apagar HQ03 DRAFT nem marcar HQ02/navegador concluída.

Baseline por arquivos/hashes e alterações concorrentes antes de implementar. Recuperação restaura somente arquivos deste plano, após conferir mudanças posteriores, sem reset global e sem migração inversa sobre save real. Registrar explicitamente o encontro antigo de Dagruve preservado e sua retirada do caminho principal. Aprovação de regras/lore/visual é explícita e por revisão; não promover a spec DRAFT automaticamente a canon.

## Reconciliação

Pesquisa e decisões registradas na evidência; proposta e próximo checkpoint no estado sem substituir planos anteriores. Resultado final exigirá evidência dos testes/aceites e registro da divergência PC/Web. Origem planejada; implementação não precedeu a spec.
