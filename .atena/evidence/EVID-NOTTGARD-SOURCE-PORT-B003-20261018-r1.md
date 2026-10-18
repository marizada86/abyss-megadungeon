# Evidência B-PORT-003 — mecânicas, progressão e interface, r1

Data: 2026-10-18. Plano PLAN-NOTTGARD-SOURCE-PORT-20261018 r1.
Conteúdo DRAFT; implementação autorizada pelo dono para S-PORT-005/006:
“aprovado o lote 3. Pode integrar as mecânicas, a progressão e a interface,
seguindo o contrato e preservando os mapas, as HQs, DRAFT e as retenções pendentes”.
Resultado: COMPLETE_TECHNICAL_WITH_INHERITED_DEBTS. Não equivale a aceite
humano, promoção canônica ou aprovação do lote 4.

## Entrega e conciliação

116 caminhos alterados/adicionados, com pré/pós SHA-256, hashes da origem e
backups dos arquivos substituídos em
`.atena/generated/source-port-20261018/b003/final-write-set.json` e `before/`.
Base histórica `b83f188a6dae9d32f78420a318bffedcac4ff4a3` extraída em leitura
do Git da origem; comparação por arquivo, sem merge de branches ou commits.

- S-PORT-005: BossMechanics e dados L5, cinco evoluções e requisitos de
  atributo, ordenação/foco de itens, campo de chefe/corrosão L2, inimigos L4,
  dano contínuo, avisos/vinheta e atmosfera. Segredos recebem distância de
  descoberta e pistas da câmara por ID estável, conservando os demais campos.
- S-PORT-006: HUD, ficha, ofertas, menus/pausa, questlog, retratos/fontes,
  lettering, filtros, atmosfera, dicas/revisão e preferências. Áudio separado
  de reaplicação da janela e saves agrupados. FrameStats/MachineInfo e
  relatórios permanecem locais; não há envio, download, serviço novo ou touch.
- Perfil: migração aditiva das preferências, mantendo Campaign.initialize,
  campaign_progress, desbloqueios, IDs e diretório técnico legado de saves.
- Campanha/mapas: ordem, next/unlock, objetivos reach/timed_reach, ChapterFlow,
  raízes/caminhos, HQs/legendas e configurações de plataforma preservados.
- Orçamento de chefes: `boss_mech.combat_orders` conserva os índices dos nove
  mapas da origem para o cálculo de caos; não renumera a campanha PC.
- Encontro QA Dagruve/Thalion: L2/L4/L5 desligados nesse contexto; regras,
  spawns válidos, duração de ondas e suporte PC mantidos.
- Domwieck/Reino Abissal: atmosfera sem perfil continua desligada pelo fallback
  existente. Nenhuma nova direção visual ou associação de trilha foi inventada.
- BossMechanics usa referência fraca à batalha para evitar ciclo de posse.
  Smoke final limpo comprova encerramento sem os recursos presos observados
  na primeira execução com referência forte.

Não houve edição de assets neste lote. 3.130 caminhos protegidos conferidos
por hash, incluindo todos os assets existentes após B002, cenas dos mapas,
HQs/leitor/catálogo/dados, ChapterFlow, terrain_layout, Hero e configurações.
Origem inteira permanece igual ao manifesto B001. A candidata testada contém
os mesmos bytes entregues nos 116 caminhos; não é a autoridade dos backups.

## Validação e limites

Godot 4.7.2. Candidata `tmp/port-b3/candidate`. APPDATA/LOCALAPPDATA e perfis
sintéticos em `tmp/port-b3/user`, probe de user:// aprovado antes de iniciar
o projeto. Nenhum save real aberto/copied. Baseline da origem B001 reutilizado
após revalidar todos os hashes de entrada; a origem não foi reexecutada sem mudança.

| Check | Resultado |
|---|---|
| Importação da candidata | exit 0, zero erros |
| Importação do workspace entregue | exit 0, zero erros |
| Suíte final | 30 assertivas falhas, exatamente o conjunto herdado B001; zero novas |
| Scripts da suíte final | 2 erros herdados em test_fog_edge, zero parse errors |
| Smoke integrado | 11 mapas, PASS, zero erros inclusive encerramento |
| Controle sintético | 94 verificações, zero falhas/erros de script |
| Probe nativo do runtime | 37 checks, zero falhas/erros de script |
| Probe nativo do Quartel/opções | 13 checks, zero falhas/erros de script |
| Capturas | runtime 720p/1080p e opções topo/novos campos 720p/1080p |
| Integridade, preservação e candidata | PASS em verification-r1.json |

As novas suites L1–L5, evoluções, fontes/filtros/dicas/atmosfera, feedback,
telemetria e regressões PC de HQ/campanha/navegação/encontro não aparecem no
conjunto de falhas. A suíte global NÃO é limpa: permanecem as dívidas
explicitadas em b001-baseline-debts-r1.md (afixos/ordem antiga, áudio/crônicas
dos dois mapas PC, descida antiga, decals, contagem antiga de HQs e pesos de
eventos). Os dois erros de test_fog_edge continuam causados por tentar gerar
chefe vazio em mapa de objetivo. Não mascarados como PASS.

A suíte final emite quatro mensagens de encerramento/recursos ainda vivos;
as capturas nativas emitem mensagens de limpeza de texturas GL, também
observadas em B002. Controle inicial emitiu um recurso em uso no encerramento;
o smoke após a correção do ciclo não emite erros. Essas ocorrências são
registradas, sem afirmar teardown global limpo. Nenhum ganho de desempenho
ou exportação foi medido/comprovado neste lote.

Primeira suíte identificou duplicação de cinco helpers de VFX por conciliação
textual com B002; removidas cópias idênticas, suíte e probe repetidos. Também
identificou orçamento L5 dependente da ordem PC e expectativas de atmosfera
em mapas sem perfil: corrigidos por compatibilidade acima. As assertivas da
origem para ordem de itens, evoluções, fonte e câmara foram portadas conservando
os testes exclusivos PC. O probe de UI precisou adiar referências a classes
dependentes do autoload Game; falha do harness corrigida, sem mudança runtime.
Escrita intermediária com encoding incorreto foi restaurada somente quando
os bytes corresponderam ao script conhecido; a aplicação final usa UTF-8 e
valida backups/manifestos. Logs das tentativas e relatório final delimitam o resultado.

Inspeção das capturas: novas opções acessíveis por rolagem em 720p e 1080p,
texto e controles visíveis; o probe exercita gravação de filtro/atmosfera/dicas
e confirma preservação do progresso. A captura runtime é uma composição de
teste com efeitos/interações sobrepostos, não um playtest humano.

## Retenções e próximo checkpoint

DRAFT permanece DRAFT. Nenhuma promoção de arte/lore/arquitetura; G-D4,
BUG-025/027/028/029, Nyrelia YN/YE e demais retenções do contrato continuam
pendentes. HQ05 permanece suspensa em S-V05-001/CP-V05-01, com aprovação de
seleção ainda pendente e cursor de retorno preservado.

S-PORT-005 e S-PORT-006 encerradas; 6/8 etapas concluídas, 2 restantes.
Próximo: B-PORT-004, S-PORT-007/008. Entradas: entrega verificada, matrizes,
baseline/dívidas e capturas. Saída: relatório técnico final, medição comparável
e roteiro/aceite humano ou pendências explícitas, depois retorno à HQ05.
Checks: repetir somente os afetados por mudanças ou incertezas, integridade,
smoke e comparabilidade, avaliação humana separada. B004 depende de aprovação
própria no modo per-batch. Exportação/publicação continuam fora da autorização.

Relatórios: `.atena/generated/source-port-20261018/b003/verification-r1.json`,
`functional-matrix-r3.json`, `final-write-set.json`, `validation/results.json`,
`results-initial.json`, `suite-final.log`, `smoke-final.log`, `controller.log`,
`workspace-import.json`, `native-results.json`, `ui-native-results.json`,
`runtime-probe.json` e `ui-probe.json`.
