---
id: SPEC-NOTTGARD-PATH-VALIDATION-ADJUSTMENT-20261017
revision: r2
status: APPROVED_OWNER_R2
origin: planned
implementation_preceded_spec: false
classification: PLAN_CHANGE_REQUEST
approval_mode: per-step
---

# Ajuste delimitado da validação — 18º arquivo de teste

S-PATH-004 em andamento, etapa4/5;3 etapas concluídas e2 restantes. Contrato r1, medidas, geometria e critérios de desempenho preservados. A aprovação deste ajuste permite somente atualizar o teste abaixo, verificá-lo e concluir a validação técnica se todos os critérios estiverem satisfeitos. Não abre nem aprova o playtest S-PATH-005.

## Evidência

O teste existente tests/test_map_objectives.gd ainda fixa chegada(30,45), destinos(30,15)/(15,15), um corredor central contínuo de seis unidades e amostragem de spawns no layout anterior. O contrato r1 aprovado move a chegada abissal para(30,54), o destino para(30,31) e troca o eixo pelo percurso espiral com alternativas. A suíte nativa retornou86 falhas nessas expectativas de geometria/spawn. Os testes de navegação, simulação360s e máscaras da nova malha passaram separadamente.

O teto atual de17 caminhos já foi usado. O contrato determina: “Se outro arquivo/decisão for necessário, apresentar ajuste antes de editar.” Esta proposta cumpre esse checkpoint; o arquivo original ainda não foi alterado.

Patch concreto DRAFT: [objective-test-r2.patch](../../generated/path-revision-20261017/r2-review/objective-test-r2.patch). Conteúdo integral proposto: [test_map_objectives.gd.candidate.txt](../../generated/path-revision-20261017/r2-review/test_map_objectives.gd.candidate.txt). A prévia foi executada em harness isolado e passou; isso não substitui a suíte nativa nem aprova sua admissão.

## Escopo exato

Elevar o teto da união do plano17→18 arquivos de jogo/testes. Única inclusão: **tests/test_map_objectives.gd**; o UID automático já declarado permanece separado. Reaproveitar todos os arquivos e recursos dos17 já aprovados, sem mudar os mapas, ondas, caps, duração, progressão ou critérios de desempenho.

No teste de raízes, usar a chegada autoritativa da malha e todos os nós/destino atuais para alcance e origens de spawn; verificar percurso das arestas nos dois sentidos em vez de exigir piso no vazio do antigo corredor central. A cena base mantém sua âncora histórica; a injeção da chegada real é validada pelo harness de abertura de ui/run. Preservar integralmente as verificações de Domwieck, tempo, raio/presença, pausa, morte, abandono, idempotência, limpeza sem recompensa, caps, ausência de chefe, Docas e Pilares. Não remover falhas para forçar aprovação: substituir somente hipóteses geométricas incompatíveis com o contrato já aprovado.

## Plano de voo e checks

Após aceite r2: registrar baseline/hash do18º arquivo e aprovação; aplicar exatamente a candidata revisada; executar a suíte nativa test_map_objectives isoladamente. Preservar as11 suítes já aprovadas e repetir apenas checks afetados por nova mudança/falha. Comparar a mesma adaptação na cópia sintética da origem, registrando seus pré-requisitos PC anteriores. Se necessário, admitir nessa cópia de teste somente os blocos reino_abissal/domwieck de data/stages.json, data/scenery.json e data/level_design.json do PC como fixtures explícitos de integração já existente; a origem real não será alterada, nem isso constitui certificação de release da origem. Registrar diferenças, portagem e pacote pendente de aplicação.

Reutilizar medições de desempenho, sementes, simulações, capturas e paridade somente enquanto hashes do código/recursos relevantes permanecerem válidos. Não repetir benchmark aprovado por alteração exclusiva de teste. Toda execução Godot exige perfil/APPDATA/LOCALAPPDATA sintéticos e probe sem autoload antes do jogo. Sem save real, dependências, commits, push ou publicação.

Aceitação:12/12 suítes nativas planejadas aprovadas, comparações de CPU mediana/p95≤baseline×1,15 e renderp95≤baseline×1,20 mantidas; portagem candidata documentada, orçamento18 respeitado e referências/estado reconciliados. Falha não é dispensada silenciosamente; ajuste fora deste recorte exige novo checkpoint. Recuperação somente do18º arquivo para seu baseline após checar concorrência, sem restaurar arquivos compartilhados antigos.

## Estado e checkpoint

Zero gaps BLOCKING para apresentar este ajuste. A autorização do18º arquivo é a decisão pendente; sua implementação não começou. S-PATH-004 continua incompleta até admissão e aprovação da suíte nativa. CP-PATH-004-R2: aprovar revisão r2, teto18 e execução delimitada acima. S-PATH-005 continua exigindo autorização própria e avaliação humana dos dois mapas.

## Aceite r2

O titular aprovou a revisão r2 e autorizou explicitamente o 18º arquivo, a adaptação e a validação para concluir S-PATH-004. O texto de proposta acima é preservado como histórico anterior à implementação. Decisão canônica: .atena/vault/canon/DEC-MAP-PATH-VALIDATION-ADJUSTMENT-20261017-r2.md.

## Verificação r2

Aplicação exata e suíte nativa aprovadas no PC e na candidata sintética. S-PATH-004 concluída, 12/12 suítes consolidadas, desempenho mantido e teto18 respeitado. Evidência: .atena/evidence/EVID-NOTTGARD-PATH-JOINT-VALIDATION-20261017-r2.md. S-PATH-005 continua pendente de autorização própria.
