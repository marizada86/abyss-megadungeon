---
id: SPEC-NOTTGARD-SOURCE-PORT-20261018
plan: PLAN-NOTTGARD-SOURCE-PORT-20261018
revision: r1
status: COMPLETE_TECHNICAL_HUMAN_PREPARED_WITH_PENDING_GATES
origin: planned
implementation_preceded_spec: false
classification: PLAN_DEVIATION
content_state: DRAFT
approval_mode: per-batch
implementation_authorized: false
---

# Portagem completa da atualização da origem para PC — r1

## Pedido e recomendação

Trazer os assets, mecânicas e funcionalidades existentes na cópia local de
`D:/dev/nottgard/games/godot/nottgard-survivors` para este projeto PC.
Recomendação: integrar por diferenças e dependências, preservando os avanços
exclusivos do PC. A origem é insumo da portagem; não substitui a autoridade
local nem os aceites canônicos deste projeto. Não sobrescrever a árvore inteira.

O pedido autoriza diagnóstico e proposta. Este documento não autoriza código,
promoção canônica, exportação, commit, push, publicação ou alteração da origem.
Planejamento aprovado pelo dono em 2026-10-18, por lote, com execução agora
e retorno à HQ05. Somente B-PORT-001 autorizado; lotes seguintes exigem
aprovação própria. Registro de autorização em state/plan.yaml.

## Evidência de partida

Auditoria: `.atena/generated/source-port-20261018/audit-r1.json`.
Comparação SHA-256 dos arquivos das árvores locais, incluindo arquivos não
commitados e metadados `.import`/`.uid`, com diretórios de infraestrutura,
cache, builds e ADD separados do conteúdo do jogo.

- Origem HEAD observado: `a558cd8532ffa39cabfe49bb7b4d1c1cb978a783`.
- PC HEAD observado: `2bc4d247944be7cef1f4470340178c219908d8b0`.
- Base de separação registrada em add.yaml: `b83f188a6dae9d32f78420a318bffedcac4ff4a3`.
- 2.824 arquivos idênticos; 853 somente na origem; 127 diferentes; 229 somente no PC.
- Esses números são de arquivos, não de funcionalidades ou imagens únicas.
- Git status da origem retornou “this operation must be run in a work tree”.
  O HEAD e o histórico foram legíveis; não assumir árvore limpa nem identidade
  entre HEAD, arquivos locais e release remoto. Revalidar em S-PORT-001.
- PC contém alterações locais em catálogo/dados/leitor de HQs e testes;
  os PNGs recentes também existem fora dos commits. Preservar seu estado atual.

Referências consultadas: add.yaml e plan.yaml de ambos os projetos; SPEC-176
(M1), SPEC-185 (pacotes de arte); evidência local da separação de plataforma;
registros de integração HQ21/HQ04; contratos project.godot; testes disponíveis
e tools/validate_release.py. O histórico recente sustenta os grupos abaixo;
a matriz funcional definitiva será fechada antes de alterar o jogo.

## Escopo de portagem

| Frente | Conteúdo constatado e tratamento |
|---|---|
| Combate e progressão | boss_mechanics e seus dados, mecânicas de chefes nos nove mapas, evoluções de armas e requisitos, correções de combate/inimigos/itens e segredos; integrar com os encontros e mapas PC |
| Resposta visual e sonora | dano contínuo, avisos de perigo, vinheta, números legíveis, atmosfera por fase, VFX de projéteis, habilidades, pulso radiante, ampulheta, cobertura SFX e dados de áudio |
| Interface e entrada | filtros visuais, fontes, lettering, logo, cursores, retratos com fallback, questlog, dicas iniciais, HUD, pausa, ofertas e opções; manter teclado/mouse/controle PC |
| Arte e animações | pacotes FILA-028/LOT02–LOT17 efetivamente integrados, interações/NPCs, quebráveis, baús, inimigos/chefes, ícones e tiles; resolver cada referência transitiva e seus metadados |
| Heróis M1 | Durvall com célula larga e oito direções; costas N/NE de Zynara/Leoric; leitor de tiras e laboratório; preservar DRAFT e pendências do dono, sem liberar Nyrelia por inferência |
| Telemetria local e QA | frame_stats, machine_info, playtest, testes e ferramentas úteis; usar dados sintéticos e não copiar perfis, evidências pessoais nem habilitar envio remoto |
| Avanços PC | preservar chapter_flow, mapas Domwieck/Raiz/Yggdrasil/Reino Abissal, encontro Dagruve/Thalion, caminhos/arte aprovados, HQs e legendas, ordem/gatilhos e enquadramento HQ21/HQ04 |

Todos os recursos da origem entram na matriz de disposição: idêntico,
copiar, integrar, preservar PC, candidato retido ou exclusão de plataforma.
Nenhum arquivo ausente pode ficar sem justificativa. Recursos experimentais
e fontes de produção relevantes terão catálogo de proveniência e dependências;
candidatos não admitidos permanecem em área DRAFT delimitada, fora do runtime.
Não copiar indiscriminadamente `.atena/generated/`, seus perfis e caches.

“Tudo” significa paridade funcional do conteúdo existente aplicável ao PC,
com registro explícito dos gates ainda pendentes. Não significa completar
roadmap ainda não implementado na origem. Se o dono quiser admitir um
candidato retido, detalhar revisão e aceite antes de ativá-lo.

## Não objetivos

Mobile/touch, exportação web e serviços externos não entram no alvo Windows
x86_64. Os arquivos mobile identificados serão registrados como exclusão de
plataforma, sem eliminar funcionalidade equivalente de teclado/controle.
Não copiar executável Godot, .github, .claude, segredos, históricos pessoais,
perfis reais, caches, builds, export_templates ou substituir AGENTS/add/plan.
Não instalar dependências, sincronizar automaticamente projetos, editar a origem,
regenerar cenas por ferramenta que sobrescreva edições manuais, promover
lore/arquitetura/arte a CANON, publicar ou fazer commits neste escopo.

## Preservação, conflitos e recuperação

Preservar nome técnico, IDs, UIDs quando válidos, diretório legado de saves,
schema e chaves anteriores. Testar compatibilidade com fixtures sintéticas
antigas e novas; jamais abrir ou copiar o save real.

Os 127 arquivos diferentes exigem revisão; atenção especial a core/game,
battle, hero, profile, happenings, terrain_layout e hq_catalog; ui/run,
overlay, hero_view, ground_decals, stage_structures e hq_screen;
dados de fases, regras, estruturas, história, segredos e HQs.
Comparar com a base histórica quando disponível para separar alterações
da origem das alterações PC. Não aplicar cherry-pick/merge amplo.

project.godot e export_presets.cfg serão conciliados explicitamente;
preservar GL Compatibility, alvo PC e salvaguardas de perfil. Conservar a
correção PC de ResourceLoader em ground_decals para recursos exportados.

Antes de escrever: manifesto e cópia reversível somente dos arquivos tocados,
incluindo não rastreados. Registrar pré/pós hashes e arquivos criados.
Recuperação por lote deve restaurar somente alterações desta portagem;
não usar reset/clean nem apagar trabalho de outro chat. Se houver mudança
concorrente em arquivo planejado, interromper sua integração e reconciliar.

## Plano de voo proposto

Cada etapa termina com evidência, disposição dos itens, arquivos tocados,
checks executados e objetivo/entradas/saída da próxima etapa.

| Lote | Etapa | Entrada e atividade | Saída e checkpoint |
|---|---|---|---|
| B-PORT-001 | S-PORT-001 | Auditoria r1 e árvores atuais; fixar manifestos/hash, explicar estado Git da origem, identificar mudanças desde o diagnóstico e dependências fora de assets; capturar rollback | Matriz funcional/arquivos e baseline imutável; CP-PORT-001 |
| B-PORT-001 | S-PORT-002 | Matriz e contratos PC; executar baseline isolado nos dois projetos, separar falhas preexistentes de novas; especificar conflitos e gates de arte, licenças/proveniência e DRAFT | Contrato de integração sem gaps BLOCKING; CP-PORT-002 |
| B-PORT-002 | S-PORT-003 | Manifesto de assets admitidos e referências; portar fontes/recursos/metadados, fontes/áudio/logo/ícones/tiles e leitores indispensáveis, conservando arte PC | Recursos resolvidos, importação limpa, testes de assets/fontes/áudio; CP-PORT-003 |
| B-PORT-002 | S-PORT-004 | Assets e contratos; integrar heróis M1, NPCs/interações, quebráveis/baús e VFX com suas tabelas/estado de aceite | Animações e efeitos ligados, candidatos retidos catalogados, checks de escala/base/cortes/identidade; CP-PORT-004 |
| B-PORT-003 | S-PORT-005 | Dados/código da origem e PC; integrar chefes, combate, progressão, segredos, feedback e atmosfera com mapas/campanha PC | Paridade de mecânicas e regressões de campanha/mapas/HQs PASS; CP-PORT-005 |
| B-PORT-003 | S-PORT-006 | Contratos UI/entrada; integrar fontes/filtros/HUD/dicas/menus/questlog/retratos e telemetria local, reconciliar atalhos e opções PC | Fluxo título→Quartel→run→resultado, controles e perfil sintético validados; CP-PORT-006 |
| B-PORT-004 | S-PORT-007 | Integração completa; suítes e smoke nos dois projetos, integridade de recursos, compatibilidade sintética, medição comparável de desempenho e capturas PC | Relatório técnico e matriz 100% reconciliada; CP-PORT-007 |
| B-PORT-004 | S-PORT-008 | Relatório, capturas e build/sessão local identificada; preparar roteiro e avaliação humana de movimentos/legibilidade/combate/áudio; reconciliar resultado e retorno | Aceite humano ou pendências explícitas; CP-PORT-008 |

Recomendação de aprovação: **por lote** (4 checkpoints de autorização), pois
permite conferir conflitos antes da portagem e separar arte, gameplay/UI e
aceite final. Por plano ou por etapa continuam disponíveis. Gates de conteúdo,
dependências e publicação independem desse modo.

## Validação e aceitação

1. Manifesto cobre 100% das diferenças e referências transitivas; nenhum asset
   omitido sem disposição justificada. Hash idêntico ao original para cópias
   sem transformação; toda adaptação tem motivo e evidência.
2. Funcionalidades da origem aplicáveis a PC constam da matriz com fluxo de
   entrada, resultado esperado, arquivos/testes e resultado observado.
3. Suítes existentes nos dois projetos executadas em sandbox comprovado antes
   de iniciar Godot. Acrescentar só testes de conflitos/contratos relevantes;
   portar testes da origem, conservar os exclusivos PC. Não repetir suite sem
   mudança/falha/incerteza. Executar checks mobile somente na origem quando
   exigidos por seu contrato, sem reintroduzi-los no PC.
4. Cobrir importação, scripts, dados, assets/animações, VFX/SFX, chefes,
   combate/progressão, controle, perfis/save resilience, QA, HQs/chapter_flow,
   caminhos/mapas e encounter Dagruve. Smoke das nove fases da origem e
   fases/protótipos/capítulos PC. Falhas herdadas exigem disposição explícita,
   sem alegar regressão zero se não houver baseline válido.
5. Capturas em 1280×720 e 1920×1080: heróis/ataques/direções, HUD, alertas,
   encontros, menus, mapas e HQs. Medir desempenho contra baseline nas mesmas
   condições; propor limiar antes de aceite se não houver contrato aplicável.
6. Aceite humano: testar movimento/identidade, legibilidade, conforto visual,
   dificuldade e áudio percebido; controles físicos quando disponíveis.
   Informar build/escopo, procedimento e critérios antes do playtest; não
   inferir diversão de testes automáticos. Pendências permanecem visíveis.
7. Completude técnica não promove DRAFT nem comprova exportação. Smoke de
   pacote executável será gate adicional quando exportação for autorizada;
   até lá, declarar entrega local pelo editor/runtime e limitação do pacote.

## Gaps e decisões

| ID | Classe | Disposição |
|---|---|---|
| GAP-PORT-001 | RESOLVABLE | Identidade da versão: usar árvore local auditada, não release remoto; fixar hashes em S-001 e registrar situação Git sem modificar configuração |
| GAP-PORT-002 | RESOLVABLE | Conteúdo M1 DRAFT e gates G-D4 pendentes: portar somente o estado admitido preservando DRAFT; candidatas restantes retidas até aceite concreto |
| GAP-PORT-003 | RESOLVABLE | Dependências de laboratório em generated: mapear referências em S-001; levar apenas o fechamento necessário e permitido, sem perfis/caches/histórico pessoal |
| GAP-PORT-004 | RESOLVABLE | Arquivos compartilhados: revisão de conflitos S-002 antes de alteração; conflito canônico não resolvido interrompe o item e exige decisão |
| GAP-PORT-005 | DEFERRED | Roadmap não implementado/aceito na origem, incluindo candidatos retidos; catalogar sem prometer sua conclusão nesta portagem |
| GAP-PORT-006 | DEFERRED | Exportação executável, publicação e testes de hardware/aceites indisponíveis; manter limites explícitos |

Não há gap BLOCKING para entregar este planejamento. A implementação exige
CP-PORT-000 aprovado, modo escolhido e rota de desvio aprovada. A saída de
S-002 deve estar sem gaps BLOCKING para liberar integração. Novas dependências,
permissões, mudança canônica ou escopo além da matriz exigem gate próprio.

## Desvio, retorno e reconciliação

Proposta: fazer esta portagem agora e retornar ao fluxo HQ05 em
`PLAN-NOTTGARD-HQ05-VISUAL-20261018 / S-V05-001 / CP-V05-01`, seleção r1
aguardando aprovação, com continuidade em S-CONT-002. Não substituir nem
suspender o plano existente durante a elaboração. Após autorização, reler
estado compartilhado e persistir suspensão/cursor atualizados antes de executar.
Também preservar o playtest Dagruve ainda pendente em seu plano próprio.

Registrar por lote portagem, validações nos dois projetos, mudanças PC
específicas e exceções. Ao concluir, reconciliar somente fatos operacionais
permitidos, manter pendências humanas e devolver cursor/autorizações anteriores
sem transformar aceite desta portagem em aceite da seleção HQ05.


## Fechamento B-PORT-003 — 2026-10-18

Autorização do dono para mecânicas, progressão e interface registrada no estado.
S-PORT-005/006 concluídas; 6/8 etapas completas. Implementação deste lote
encerrada. 116 caminhos conciliados, mapas/HQs/campanha/retidos preservados.
Importação limpa; smoke de 11 mapas limpo; 94 checks de controle e 50 de
runtime/UI sem falhas. Suíte global permanece com as mesmas 30 falhas e
2 erros de script herdados; mensagens de teardown registradas separadamente.
Evidência: `.atena/evidence/EVID-NOTTGARD-SOURCE-PORT-B003-20261018-r1.md`.
Verificação: `.atena/generated/source-port-20261018/b003/verification-r1.json`.
Próximo checkpoint exige aprovação de B-PORT-004 (S-PORT-007/008), para
validação final, medição comparável e aceite humano ou pendências explícitas.
DRAFT e retenções permanecem; HQ05 conserva o cursor de retorno suspenso.


## Fechamento B-PORT-004 e retorno — 2026-10-18

Lote 4 aprovado pelo dono para validação e preparação humana. S-PORT-007/008
entregues, 8/8: matriz final de 4.037 caminhos sem disposição indefinida,
origem/entrega intactas e candidata equivalente por hash. Checks B001/B003
reutilizados com entradas válidas; benchmark ABBA novo e iniciador isolado
verificado. Suíte global mantém 30 falhas e 2 erros de script herdados.
Custo p95 observado 1,725 → 2,283 ms no cenário delimitado; não é aceite de
desempenho ou playtest humano. Roteiro e formulário preparados; parecer
humano explicitamente PENDENTE. Evidência B004 e relatórios vinculados no
estado. DRAFT e todas as retenções preservados. Sem exportação/publicação.
Retorno à HQ05 efetuado no cursor S-V05-001/CP-V05-01, seleção r1 ainda
aguardando aprovação e geração ainda desautorizada. Feedback humano da
portagem permanece pendência independente; conclusão da preparação não
comprova aceite humano nem release limpo.
