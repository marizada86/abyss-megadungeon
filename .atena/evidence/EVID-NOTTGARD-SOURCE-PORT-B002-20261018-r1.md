# Portagem — B-PORT-002 concluído, r1

PLAN-NOTTGARD-SOURCE-PORT-20261018; S-PORT-003/004 concluídas em 2026-10-18.
Autorização do dono: “aprovado o lote 2. Pode integrar os assets, leitores e
animações, mantendo DRAFT e as retenções pendentes”. Modo por lote; somente
B001/B002 autorizados. B003 pendente. Sem promoção canônica.

## Entrega

394 arquivos de assets copiados da origem, incluindo 201 PNGs sem qualquer
transformação raster, fontes/OFL, áudio e metadados. 445 caminhos no conjunto
de escrita: 439 cópias e 6 adaptações PC; 53 arquivos já existentes alterados,
todos com backup validado por hash. Recibos em
`.atena/generated/source-port-20261018/b002/authorized-write-set.json`,
`admission-r1.json`, `final-write-set.json` e `verification-r1.json`.

- HeroView acompanha tiras de 512 px, direções reais de Durvall sem espelho,
  N/NE novos de Zynara/Leoric, células/contagem corretas de Arlindo/Erik.
  O adaptador de velocidade é inicializado somente pelo laboratório opt-in;
  navegação/sweep/colisões PC preservados e velocidade padrão mantida.
- EnemyView lê animações de Juiblex/Mímico, idle de Turíbulo e morte dos
  12 quebráveis. Nenhuma definição ou mecânica de chefe novo foi ativada.
- InteractionAnim/HappeningArt ligados ao overlay e aos metadados visuais
  existentes: idles/NPCs, itens/alvos, Eco, câmara aberta/selada, ruínas;
  fallback estático conservado. Baús normal/chefe têm aberturas distintas,
  células 256 e base visual preservada; altar usa ciclo de 900 ms da origem.
- Leitores/consumidores de projéteis, pulsos, ampulheta e habilidades ligados
  a eventos já existentes, com fallback para impacto reduzido e isolamento
  de HP/posição/RNG verificado. Campos pitch do áudio e famílias melee
  acompanham recursos. Não modificados dano, alcance, regras ou progressão.
- Leitores de fontes, retratos e lettering disponíveis. A ativação das novas
  opções de UI, fonte padrão/tema, novos menus/HUD e migrações de settings
  permanece no lote 3; Lettering mantém estilo atual e ganha helpers novos.

Eventos foram conciliados por ID e somente campos asset/assets foram
mesclados (16 campos). Comparação recursiva sem esses campos prova que
nenhum outro dado de evento mudou. core/battle recebeu apenas ruin_art;
core/happenings recebeu propagação visual sem alterar contagem/recompensa/RNG.
run PC manteve campanha, leitura/retomada de HQs, objetivos e overlays locais.
Os ganhos L4/L5 incompatíveis com APIs ainda ausentes ficam para B003.

## Preservação e DRAFT

Origem inteira do manifesto B001 permanece com hashes válidos: seu baseline
de 111 arquivos de teste, smoke e controles foi reutilizado, sem repetição
desnecessária ou escrita na origem. Todos os arquivos testados na cópia B002
coincidem com os entregues no workspace (exceto caches/descritores gerados).

163 caminhos protegidos conferidos: HQs aprovadas, catálogo/leitor/legendas,
campanha, cenas de mapas, ResourceLoader dos decals, configurações PC,
definições de armas/inimigos/dificuldade, perfil e Nyrelia. Nenhum deles mudou.
Importação do workspace não gerou mudanças extras de descritores fora do
conjunto de escrita. Backups/recibo deixam os estados pré/pós auditáveis.

Tiras M1 continuam DRAFT; G-D4 e dívidas de base/massa/movimento continuam
abertos. Nyrelia 03/04, P9 antiga, UI01, NE06/GR, RU05/RU07/RU08/LOT12,
FC02/FJ e ruptura TD não foram admitidos por inferência. Verificação comprova
ausência dos quatro idles retidos na tabela e de morte do Turíbulo. Arte
estática anteriormente admitida, como Graz'zt, não se confunde com seu idle
retido. Não copiados candidatos de `.atena/generated/` para runtime.

## Validação

Testes em tmp/port-b2/candidate, APPDATA/LOCALAPPDATA e perfis sintéticos,
com probe user:// antes de iniciar Godot. Imports da cópia e do workspace
passaram com 0 erros de script/motor. Diretórios descartáveis deste chat
receberam .gdignore para não entrar no import do jogo. Nenhum save real usado.

- Suíte completa: mesmas 30 falhas herdadas do PC e os 2 erros de script de
  test_fog_edge. Uma falha de execução adicional ocorreu no teste novo do
  pulso ao exigir constelacao_de_silva, evolução reservada a B003. A expectativa
  foi delimitada por fase, conservando validação de roteamento, atlas e armas
  já existentes. Teste corrigido repetido isoladamente: PASS.
- 18 testes direcionados: PASS, 0 falhas e 0 SCRIPT ERROR; cobrem pulso,
  projéteis/habilidades, atores/quebráveis/idles/NPCs, heróis, laboratório,
  ampulheta/retratos, compilação, HQs/campanha, navegação Yggdrasil/Raiz,
  encontro Dagruve e contrato PC. Não reexecutada suíte inteira após a mudança
  somente da expectativa de um teste; resultado original e retry preservados.
- Smoke: 11 fases, ok, sem erros. Controle sintético: 94/0, sem erros.
- Prova no runtime com renderização: 37 checks, 0 falhas, 0 SCRIPT ERROR;
  direções/células, aberturas, consumidores VFX, fallback, retenções e
  preservação HP/posição/RNG. Capturas 1280×720 e 1920×1080 geradas e vistas.
  São fixtures sobrepostas para exercitar os leitores, não aceite de composição,
  conforto, fluidez, dificuldade ou diversão. Ao encerrar, a prova GL emitiu
  7 mensagens de cleanup de texturas/RenderingServer; não alegar execução
  sem mensagens do motor ou resolução dessa dívida de teardown.

Adaptações dos testes de VFX validam presença de gameplay somente para armas
já admitidas; raio_da_ruina, dominio_coletivo e constelacao_de_silva conservam
roteamento visual preparado, mas suas definições devem ser exigidas na
integração B003. Teste de Turíbulo usa Enemy sintético, sem adicionar gameplay.

A prova visual teve duas tentativas de preparação com erro de identificação
do singleton no script inicial; corrigido o harness para resolver Game após
autoload. Nenhum arquivo de runtime foi alterado por essa correção. A terceira
execução produziu o resultado válido 37/0 e as capturas.

Logs/JSON em `b002/validation/`: results, targeted-results, native-results,
runtime-probe, workspace-import, isolation, capturas e logs individuais.
Dívidas PC do B001 permanecem abertas; não declarar suíte/release limpos.

## Próximo checkpoint e retorno

CP-PORT-B003-APPROVAL: S-PORT-005/006, integrar combate/progressão/chefes,
segredos, feedback/atmosfera e interface/entrada/telemetria local conforme r1,
preservando mapas/campanha/HQs e gates canônicos independentes. Entradas:
contrato B001, dívidas, hashes finais B002 e matrizes. Saída: paridade dessas
funcionalidades e validação isolada, sem instalar dependências ou publicar.
Antes de escrever usar hashes finais B002 para caminhos tocados e B001 para
demais caminhos; não comparar alterações autorizadas contra uma cópia antiga.

Lote 3 ainda não autorizado. HQ05 segue suspensa em S-V05-001/CP-V05-01 com
seleção visual aguardando aprovação; retornar somente ao concluir a portagem
ou por mudança explícita da rota. Sem exportação, commit, push ou publicação.
