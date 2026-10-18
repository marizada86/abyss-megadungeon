# Capítulo 1 — desenho dos mapas e transições

ID: EVID-NOTTGARD-CHAPTER1-MAPS-DESIGN-20261016. Data: 2026-10-16. Etapa S-C1-002 concluída, 2/6 do plano de fechamento; quatro restantes. Autorização explícita: “Atena, aprovado. Vamos detalhar os mapas e as transições do capítulo 1”. Escopo aprovado é desenho documental PC; sem execução de código de jogo ou arte.

## Entregas

- [Contrato detalhado r1](../specs/SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/chapter1-maps-transitions-r1.md): mapas, objetivos, layouts textuais, ondas, multiplicadores, recompensas, transições, fila/cursor, dispensa/interrupção, permissões/migração, retirada de HQs e checks/arquivos.
- [Anexo estruturado r1](../specs/SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/chapter1-flow-contract-r1.json): três fases, duas novas; sete HQs principais e uma complementar; três HQs retiradas da seleção; gatilhos e campos propostos.
- [Baseline de leitura](../generated/chapter1-design-20261016/baseline.json): 40 arquivos pertinentes com hashes, definições antigas de fases/HQs/conquistas para desenhar o congelamento dos direitos legados. Não contém nenhum dado de save. Revalidar antes de implementar.
- [Validação documental](../generated/chapter1-design-20261016/validation.json): PASS_DOCUMENT_CONTRACT_ONLY.

## Evidências do runtime lido

- `core/profile.gd:15–31`: merge de campos e migração que infere Docas de Dagruve; `171–173`: desbloqueio depende de stages.unlock; `195–234`: liquidação de moedas/resultado; `72–85`: HQs vistas/recompensa de leitura. Justificam migração aditiva a partir do dicionário original e distinção de marcos, leitura e liquidação da run.
- `core/hq_catalog.gd:16–53`: desbloqueio por conquista/leitura/marco e supressão de HQ já liberada. `ui/run.gd:578–585`: marco salvo antes de apresentar. Recuperar a fila a partir apenas de desbloqueio não basta após queda de processo.
- `ui/hq_screen.gd:21–48`: leitor sempre começa no quadro zero, distingue completed de finish, sem cursor persistido. `ui/run.gd:591–613`: pausa/restauração e save da leitura. Proposta fecha a diferença entre dispensa explícita e interrupção inesperada.
- `core/battle.gd:1716–1748`: rotina de chefe contabiliza abates, drops e conclusão. `3082–3136`: diretor assume chefe ao fim da duração. Menu `288–301`, QA de chefe `451–453` e test_data assumem boss existente. Os objetivos novos exigem ramificação explícita; não bastaria boss vazio no JSON.
- `ui/run.gd:109–140`: carregamento de cena Ground/Sorted/Hero, escala de terreno e spawn. `ui/stages/docas.tscn`: tamanho 60×60. Layouts dos dois mapas propõem o mesmo contrato de cena/escala.
- `ui/menu.gd:441–540`: Diário agrega HQs, crônicas e ecos; replay marca leitura. Direitos de replay legado precisam sobreviver à retirada de HQ11/12/13 da seleção ativa.
- `data/achievements.json`: Fechadura Aberta/Marca Carapaça referenciam abate de Dagruve; Cronista conta cinco leituras completas. Não reinterpretar esses critérios como conclusão por objetivo nem pagar de novo na migração.
- `tests/test_hqs.gd`: expectativas fixas de 14 HQs, gatilho antigo de HQ03, quatro quadros nas demais e fallback de conquistas. Precisarão ser atualizadas para os contratos de fato aprovados, preservando casos de compatibilidade.

Fontes narrativas reutilizadas: S11–12 e CANON do capítulo 1, já lidos neste chat; nenhum fato novo do vault foi inferido do comportamento atual do jogo. Guia detalhado de jogos relido; texto/arte/mapa DRAFT permanecem distintos do roteiro CANON. Não houve pesquisa remota ou delegação.

## Decisões propostas, não promovidas

Reino Abissal com 360 s + presença de três segundos no acesso ao ritual; Domwieck com 420 s + presença no santuário; combate nomeado na HQ18 e Adam sobrevivendo na HQ03. Inimigos existentes, sem definir novas entidades; chefes ausentes tratados como objetivos. Domwieck encerra capítulo, sem abrir provisoriamente o capítulo 2. HQ14 complementar no Diário após Docas; HQs retiradas conservam replay apenas por direito histórico congelado.

O aceite da elaboração não promove automaticamente essas regras/arquitetura aditiva a CANON. A aprovação r1 do desenho é pendente no CP-C1-02 antes de código; roteiros aprovados não estão sendo reabertos.

## Checks executados e limites

JSON/YAML legíveis; ordem de campanha e fila consistente; grafo acíclico; novos IDs de fases/HQs sem colisões no catálogo atual; oito HQs ativas; três retiradas ainda preservadas no acervo; todas as ondas/elites referenciam inimigos existentes; horários, posições normalizadas e limites coerentes; referências Markdown locais válidas. Capturados hashes dos 40 arquivos de leitura. Nova conferência dos hashes após a documentação deve confirmar que continuam iguais.

Um comando inicial de leitura encontrou a limitação de codificação cp1252 ao imprimir uma seta, sem alterar arquivo. Leituras seguintes usaram saída UTF-8. A validação do contrato passou sem reparo do conteúdo.

Não foram executados Godot, testes do jogo ou playtest; o contrato ainda não é implementação. Não houve acesso a save real, edição de arquivos de runtime, produção/inspeção de candidatas visuais, instalação ou alteração Web. Os valores de tempo/dificuldade precisam de playtest e não comprovam diversão.

## Próxima etapa preparada

S-C1-003, começando pela HQ15 — O Homem na Névoa. Objetivo inicial: seleção e prontidão visual dos cinco quadros. Entradas: CANON do capítulo 1, bíblia visual de revisão existente, referências oficiais de Erik/Brook/Leoric e acervo local. Saída: ficha por quadro de manter/adaptar/gerar, referência/identidade/cenário, lacunas e proposta de candidata inicial. Checks: fonte/revisão, adequação ao roteiro e contexto, identidade e continuidade. Resolver BLOCKING antes de produzir; seleção aceita e autorização de produção antecedem ImageGen. Nenhuma delegação ou recurso externo autorizado por este checkpoint documental.

Preservados retorno HQ review S-HQ-004 (HQ03 texto aprovado, arte pendente), HQ02/navegador pendente do escopo anterior, CP-SPLIT-02/aceite humano e proposta FLOW ampla fora do recorte refinado. Capítulo 2 e portagem Web permanecem adiados.
