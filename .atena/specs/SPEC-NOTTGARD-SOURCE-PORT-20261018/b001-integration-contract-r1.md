# Contrato de integração da portagem — lote 1, r1 DRAFT aprovado para análise

PLAN-NOTTGARD-SOURCE-PORT-20261018, B-PORT-001, S-PORT-001/002.
Autorização: “aprovado por lote. Vamos fazer agora e depois retornar à HQ05.
Pode começar o primeiro lote”, em 2026-10-18. Este contrato detalha a rota
r1 aprovada; a integração continua condicionada à aprovação do lote 2.
Não promove conteúdo ou arquitetura a CANON.

## Baseline e fonte

Origem de conteúdo é a árvore local, não um release remoto. HEAD lido
diretamente de `.git/HEAD` e `refs/heads/main`:
`a558cd8532ffa39cabfe49bb7b4d1c1cb978a783`. `.git/config` confirma
`core.bare=false` e nenhum `core.worktree` configurado. Portanto o erro do
Git não comprova repositório bare: o sandbox negou `git -C` à origem.
Nenhuma configuração ou permissão foi alterada. Estado limpo não afirmado.
Hashes e snapshots dos arquivos, incluindo não commitados, fixam a versão.

Manifestos SHA-256 e tamanhos em `b001/source-manifest.json` e
`b001/pc-manifest.json`; cópias isoladas em `tmp/port-b1/source` e `pc`.
O escopo final contém 851 itens exclusivos da origem, 127 diferentes,
232 exclusivos PC e 2.827 idênticos. Diferença para o diagnóstico: o novo
inventário usa allowlist dos arquivos da raiz e inclui somente contratos ADD
não pessoais necessários aos testes; não representa atualização de gameplay.
Matriz por arquivo em `b001/disposition-matrix.json` e índice de conflitos
em `b001/conflict-index.json`, com diferenças textuais em `b001/diffs/`.

As cópias de teste são mutáveis por importação/fixtures; os hashes de entrada
continuam sendo a referência imutável. Antes de cada lote de escrita, verificar
hash atual contra manifesto e copiar somente arquivos efetivamente tocados
para backup daquele lote. Não restaurar indiscriminadamente a cópia de teste.

## Fronteiras para a integração

| Família | Ganho da origem | Regra de conciliação PC |
|---|---|---|
| core/game.gd | filtros/fontes/atmosfera/dicas; separar áudio de janela; telemetria da máquina | preservar stage inicial `docas`, validação QA, ChapterFlow.prepare_start e travas de desbloqueio; touch permanece desligado |
| core/profile.gd | defaults/migrações visual_filter, atmosphere, hints e hints_seen | mesclar aditivamente com Campaign.initialize, campaign_progress e stage_allowed; não resetar progresso nem carregar perfil real |
| core/battle.gd | BossMechanics, feedback, câmera selada, evoluções, inimigos L2/L4 | preservar objetivos timed_reach/reach, stage_definition, navegação/suporte das raízes, spawns válidos e overlay Dagruve; incluir capacidades por contexto, sem trocar o loop PC inteiro |
| core/hero.gd e enemy.gd | laboratório de velocidade e metadados de chefe/inimigos | manter sweep/can_stand com `air`, root_layout e limites; dev_speed_override somente sob --walk-debug, sem mudar velocidade padrão |
| terrain_layout/ground/run | efeitos, atmosfera e VFX | conservar raízes, caminhos, colisões, shaders e integrações PC; nenhuma geração de cenas destrutiva |
| ui/ground_decals.gd | arquivo da origem carrega PNG original | manter implementação PC com ResourceLoader; bloqueia regressão de pacote |
| ui/hero_view.gd | células 512, oeste real Durvall, laboratório e novas tiras | importar tabelas, âncoras, contagem e leitor junto dos PNGs; não ligar a tira larga com leitor antigo |
| ui/overlay.gd, prop/happenings | HappeningArt e InteractionAnim | portar estático e animado com fallback, preservando geometria/objetivos PC e IDs existentes |
| ui/hud/menu/options e theme | lettering, retratos, dicas, perigos, fonte de corpo/título | preservar controles desktop, fluxo de campanha/HQs, pausas/QA; não religar TouchUI/mobile |
| hq_catalog/hq_screen/hqs.json | decoração do leitor e alterações da origem | manter texto/arte/ordem/gatilhos CANON PC, retomada, legenda dupla e caption_below_image; decoração só se não cobre composição aprovada |
| data/stages/level_design/rules/story/structures | origem ainda tem campanha survivor antiga | manter definições PC de Docas, Dagruve, Domwieck, Raiz/Reino Abissal e progressão; aplicar novidades em campos independentes, não restaurar duração/chefes/next/unlock antigos |
| data/stage_events | campos asset, chamber_hint e assets de aliados | mesclar por ID estável dentro de cada fase, conservando eventos exclusivos PC; não trocar arrays em bloco |
| weapons/difficulty/enemies | 5 evoluções novas, atributos mínimos, regras L2/L4, totem_de_chefe | portar com suas funções e testes; preservar modificações PC compatíveis e isolar encontro Thalion de mecânicas não previstas |
| sfx/audio_manifest | campo pitch, famílias VFX/SFX novas | carregar arquivos e manifestos antes de consumidores; manter mix/opções e pitch próprio por evento |
| playtest/frame_stats/machine_info | métricas locais de quadro/máquina | manter saída local e sandbox; ramos web/download, rede, credenciais e envio remoto excluídos |

Os 127 conflitos têm disposição no índice. `.import` será conciliado com UID
válido e reimportação local; não copiar `.godot`. Diferentes PNGs de HQ01/02
permanecem com os aceites PC e entram como conflito de conteúdo, nunca como
substituição automática. `AGENTS.md`, project.godot, export_presets.cfg e
build_info.json preservam contrato PC. Ferramentas de desenvolvimento são
catalogadas, sem execução em massa nem transporte de dados pessoais.

## Dependências e ordem dos próximos lotes

Lote 2 pode adicionar recursos, dados visuais e leitores necessários para
importação/compilação: HeroView + suporte dev_speed_override guardado,
InteractionAnim + HappeningArt, resolvedores/frames de VFX e testes de assets.
Ligações de gameplay/novas mecânicas permanecem no lote 3. Quando um leitor
pedir API ainda ausente, incluir somente o adaptador de apresentação mínimo
do escopo r1, registrar o caminho e validar compilação. Não antecipar ativação
de chefes, migração de progresso ou regra de combate para fazer teste passar.

Dados visuais como interaction_anims, cursor e áudio podem acompanhar lote 2;
esquemas de combate/progressão e mapas entram no lote 3. Essa é a ordem de
dependências já prevista em S-PORT-003, sem instalar bibliotecas.

Não há referência literal de runtime `core/` ou `ui/` a `.atena/` na auditoria.
Os 118 candidatos da origem nessa área são principalmente saídas de
ferramentas, padrões formatados ou insumos de teste, não 118 dependências de
jogo. Somente os contratos de testes necessários acompanham a validação.
Parâmetros externos do laboratório são opcionais e não autorizam varrer ou
copiar diretórios generated indiscriminadamente.

## Arte, identidade e proveniência

Sem geração, transformação raster ou nova revisão visual neste lote.
Identidade/bible aplicáveis são os contratos já existentes e aceites PC;
documentos consultados da origem são insumos, não canon local novo.

- Durvall: 9 tiras 512; movimento 6 frames, ataque 4; pés 440; oeste sem
  espelho; demais tiras preservadas. EVID-274 mantém dívidas de massa/base,
  BUG-025/027/028/029 e gate G-D4. Ritmo padrão 10 fps; laboratório opcional.
- Zynara/Leoric: 4 tiras N/NE de 512; pés 440/432; NW segue espelho como na
  origem. EVID-275 não comprova spread/identidade final nem fecha bugs.
- Arlindo/Erik: fontes, células e contagem precisam mudar juntos; origem usa
  512×512 versus 384×384 daqui, e Erik NE passa a 6 frames.
- Nyrelia YN/YE (LOT15 03/04), P9 antiga, UI01, NE06/GR,
  RU05/RU07/RU08/LOT12, FC02/FJ e ruptura TD continuam retidos; IA06,
  FC01/LOT08 PR01–PR03 sem consumidor permanecem catalogados. Não inferir
  admissão a partir de presença no pacote.
- Fonte EB Garamond e fontes de título vêm com seus OFL em assets/fonts;
  conservar os 7 arquivos de licença, inclusive famílias já existentes.
- Arte integrada da origem conserva estado DRAFT e suas evidências de
  admissão; o aceite visual local é um gate separado. Usar hashes dos assets
  efetivamente ligados, não confundir licença/proveniência com aprovação.

## Checks de contrato e fronteira de aceitação

Baseline Godot 4.7.2 oficial; probe comprovando user:// em diretório sintético
antes de import/execução. Cada projeto tem APPDATA/LOCALAPPDATA e perfil
próprios. Sem leitura do diretório real. Cópias isoladas permitem os fixtures
que escrevem res://tmp e .atena/generated sem alterar origem ou runtime PC.

Executar suíte completa e smoke de cada cópia, controle sintético em ambas,
e mobile somente na cópia da origem. Não confundir input sintético com aceite
de hardware. Importação fria pode emitir erro de tema antes de gerar cache
de fontes; exigir segunda importação e carregamento limpos após materializar
cache, registrando ambas as tentativas. Não suprimir falha de script ou asset.

Falha de fixture devido a diretório de saída ausente é problema de preparação
do harness: criar somente diretório vazio sintético e repetir check afetado.
Falha herdada de jogo fica listada com teste/condição; não editar runtime
neste lote. Se revelar gap BLOCKING real, registrar e não liberar integração.

No lote 2: import/scripts, animações (base/escala/cortes/células/direções),
heróis próprios, VFX/áudio/fonts/lettering/idles/quebráveis e regressões PC.
No lote 3: todos esses contratos mais chefes/evoluções, perfil/save resiliente,
campanha/HQs/mapas/navegação/QA e controle. No lote 4: repetir apenas checks
afetados desde baseline, smoke integrado, desempenho comparável e playtest.

Não alegar exportação ou aceite humano. A aprovação do lote 2 autorizará
somente S-PORT-003/004 dentro desse contrato; o retorno à HQ05 segue pendente
até fechar a portagem ou o dono mudar explicitamente a rota.
