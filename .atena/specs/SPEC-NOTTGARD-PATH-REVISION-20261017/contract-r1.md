---
id: SPEC-NOTTGARD-PATH-CONTRACT-20261017
revision: r1
status: APPROVED_OWNER_R1_S_PATH_002_AUTHORIZED
origin: planned
implementation_preceded_spec: false
classification: PLAN_CHANGE_REQUEST
approval_mode: per-step
---

# Contrato dos caminhos r1 — S-PATH-001

Direção r1 aprovada explicitamente pelo titular, com autorização apenas para detalhamento. Este contrato, suas medidas e a arquitetura proposta continuam DRAFT até aceite. Etapa1/5 entregue documentalmente; próximas etapas: Yggdrasil, primeira incursão abissal, validação conjunta e playtests. Nenhuma alteração do jogo nesta etapa.

## Desenhos e medidas

[Prancha comparativa](../../generated/path-revision-20261017/drawings-r1.png), [Yggdrasil base](../../generated/path-revision-20261017/yggdrasil-plan-r1.svg), [exemplo semente7502](../../generated/path-revision-20261017/yggdrasil-seed-7502-r1.svg), [espiral abissal](../../generated/path-revision-20261017/abyss-plan-r1.svg). São vistas superiores técnicas; não representam arte final nem render Godot. Nós, raios e ligações exatos: [geometry-contract-r1.json](../../generated/path-revision-20261017/geometry-contract-r1.json). Coordenadas em unidades do mapa60×60, sem multiplicação pelo scale dos terrenos históricos40×40. Larguras são diâmetros; o terceiro componente de cada nó é raio.

| Parâmetro | Yggdrasil proposta | Primeira incursão abissal proposta |
|---|---|---|
| Malha |12 junções,16–17 ligações;5–6 ciclos independentes no grafo|18 junções,23 ligações;6 ciclos no grafo|
| Tronco/caminho principal |7–8 unidades, antes12|6 unidades, preserva largura principal anterior|
| Galhos/conexões |4,5–5,5, antes9|4,5 unidades|
| Junções |E/C1/C2 raio4,5;G4; laterais3–3,2, antes até9|raio3,5, antes até6|
| Chegada |(30,48), preservada|(30,54), antes(30,45)|
| Destino |(30,12), preservado|(30,31), antes(30,15)|
| Objetivo |240s +3s no raio2, cap40|360s +3s no raio2, cap50|
| Lateral visual |20px, antes28|32px nominal; variação visual24–40px|

A relocação da chegada e do destino abissais é parte explícita deste contrato: entrada na extremidade externa, chegada ao núcleo da espiral. Não há nova fase, transição ou alteração de progressão. As coordenadas antigas não devem continuar sendo usadas por cena, marcador ou spawn após a revisão.

Yggdrasil tem três trajetos longitudinais: E→C1→C2→G; E→W0→W1→W2→W3→G; E→L0→L1→L2→L3→G. Conexões C1–W1, C2–W2, C1–L1 e C2–L2 unem as alternativas, mantendo três ou quatro delas por semente. Os nós laterais variam±1,5 unidade em cada eixo; chegada/destino permanecem fixos. Comprimentos resultam dessas posições, sem impor comprimento igual aos galhos. Junções menores evitam a aparência de grandes plataformas circulares. Redução do piso transitável preserva madeira resistente e a escala cósmica da árvore nas HQ20; a imagem do tronco ao fundo fica preservada nesta revisão, pois representa contexto, não caminho transitável.

A espiral abissal é uma poligonal contínua E→A→B→C→D→F→H→I→J→K→L→M→N→O→P→Q→R→G. As seis conexões alternativas são B–O, C–P, F–P, H–Q, J–R e L–R. As subdivisões no trajeto dominante são pontos reais de encontro dessas alternativas. Diferentemente de apenas subdividir linhas, as conexões aumentam os ciclos do grafo de4 para6. O desenho é fixo; não adicionar aleatoriedade ao Abismo por inferência. Interseções existentes são junções transitáveis explícitas, sem viadutos.

## Aleatoriedade controlada e propriedade da geometria

Proposta de gerador local core/root_path_generator.gd, sem autoload, singleton mutável por fase ou consumo da RNG de combate. Versão path-r1-lcg32: estado inicial uint32(seed_da_batalha+24691), passo uint32(1664525×estado+1013904223), amostra estado/4294967296. Iteração dos nós e arestas conforme ordem do JSON; quantização0,25, arredondamento floor(x+0,5) inclusive para jitter negativo para reproduzir o estudo JS. Aplicar jitter aos dez nós móveis; sortear as três larguras principais em[7,8], demais em[4,5;5,5], depois sortear inteiro0–4 para omitir uma conexão ou preservar todas. Isto varia forma, comprimentos e a seleção das conexões; não é um grafo inteiramente livre nem mudança durante o combate.

Uma tentativa é aceita somente com nós dentro do mapa, ausência de arestas degeneradas/cruzamentos não declarados, distâncias entre nós não incidentes≥6,5, mínimo16 ligações,5 ciclos e malha transitável conectada para raios0,3/0,4/0,8/1,2, incluindo objetivo e chegada. Rejeitar candidatos cuja área suportada para raio0,3 exceda38% do mapa ou fique abaixo24%. Tentar até16 candidatos com a mesma RNG local continuada; sem loop indefinido. Fallback explícito: malha-base de17 ligações, larguras7,5/4,8/5, raios do JSON; registrar versão/semente/tentativas/fallback no recibo QA. Sementes inválidas nunca abrem piso falso. Não redesenhar a topologia a cada frame ou trocar semente quando um inimigo nasce.

Battle mantém uma cópia própria da geometria gerada por carregamento; Hero recebe a mesma definição de leitura. TerrainLayout conserva o cadastro-base e seus defaults estáticos existentes, oferecendo parâmetro opcional de definição para suporte/projeção. Cada Battle usa a sua definição nas consultas, grids e campos; invalida caches ao carregar fase. Não colocar a variante em cache global indexado apenas pelo stage_id. Testar duas batalhas com sementes diferentes, em ordem alternada, além de Abismo e Domwieck. A geometria do primeiro objeto não pode mudar quando o segundo é criado.

ui/run.gd injeta a definição no Ground e YggdrasilArt antes de adicionar a cena à árvore/prepare. Para mapas de raízes, sincroniza chegada a partir da definição após a configuração da cena, antes de scenery/spawns. O marcador e o objetivo usam a mesma definição/cadastro atualizado. Uma captura tardia de um singleton não é solução aceitável. Hero.can_stand/sweep, Battle movimento/empurrões/dash/IA/spawns/loot e os renderizadores usam a geometria autoritativa da respectiva batalha.

## Representação e prontidão visual

Reutilizar somente as texturas já admitidas: assets/tiles/yggdrasil_r1 e assets/tiles/reino_abissal_roots_r1, preservando seus hashes. Direções CANON: DEC-YGGDRASIL-ART-DIRECTION-20261017-r1 e DEC-YGGDRASIL-WOOD-STRENGTH-20261017-r1; referências admitidas de HQ20 no plano de arte; raízes abissais no kit r1 aprovado a partir de HQ17 Q3/Q4. A nova direção não autoriza inserir outras HQs. Não haverá imagegen, deformação das fontes, revisão de personagens ou novos assets; identidade de personagem N/A para este trabalho de geometria.

Ambos os shaders atuais têm arrays/loops fixos: Yggdrasil7/8 e Abismo9/12. Ampliar para capacidade32 nós/32 arestas por material, com contagens reais e validação de limites; apenas índices válidos participam da distância e do detalhe. Materiais são por instância. Abismo passa a receber meia largura por aresta; um half_width global não representa seus atalhos mais finos. Atualizar também fallback geométrico, máscaras de debug, bounds, raio dos detalhes e marcador. O kit cobre segmentos e junções por amostragem existente, não depende de uma imagem para cada curva. Inspeção no Godot ainda obrigatória para emendas e repetição.

No Abismo, progressão normalizada ao longo do trajeto dominante orienta variação de iluminação de até12% e profundidade lateral24–40px, com interpolação nas conexões. Essa profundidade fica abaixo do topo e não altera a projeção do piso/corpos: nenhuma região sombreada vira chão. Garantir leitura da espiral em overview, preservando o destaque dos inimigos/telegráfos. Sem camadas de altura física, pulo ou sobreposição de caminhos. Se a espiral continuar parecendo grade no render, ajustar a composição dentro deste contrato antes do playtest; não declarar sucesso pela contagem de ligações.

## Limites de implementação

Teto proposto:17 caminhos de jogo/testes, exclusivo desta revisão; metadados .uid automáticos do novo script são registrados separadamente, não escondidos. Nenhum teto histórico de14 é reaproveitado implicitamente. Lista exata:

1. data/root_navigation.json — somente os dois mapas.
2. core/root_path_generator.gd — novo gerador limitado.
3. core/terrain_layout.gd — consultas com definição opcional, defaults preservados.
4. core/hero.gd — referência à geometria por instância.
5. core/battle.gd — geração, propagação, consultas e caches de raízes.
6. ui/run.gd — injeção antes do prepare e chegada autoritativa.
7. ui/ground.gd — geometria recebida, Abismo e fallback dos dois mapas.
8. ui/yggdrasil_art.gd — remover exigência fixa7/8, geometria recebida e capacidade.
9. ui/shaders/yggdrasil_root_art.gdshader — contagens/arrays e limites.
10. ui/shaders/abyss_roots.gdshader — contagens/arrays, larguras e sinais de altura.
11. data/yggdrasil_art.json — revisão geométrica r4 e lateral20px.
12. data/prototype_stages.json — somente destino da primeira incursão abissal.
13. tests/test_yggdrasil_navigation.gd — sementes, instâncias e nova geometria.
14. tests/test_yggdrasil_art.gd — capacidade, lateral e definição por instância.
15. tests/test_root_navigation.gd — espiral, chegada, vazios e corpos.
16. tests/test_root_art.gd — larguras por aresta e arrays.
17. tests/test_yggdrasil_map.gd — substituir coordenadas de spawn fixas por pontos válidos da malha da batalha quando necessário, preservando assertions de comportamento.

S-PATH-002 inclui infraestrutura compartilhada necessária a Yggdrasil, preservando exatamente o cadastro/visual abissal anterior. S-PATH-003 aplica a nova malha, destino e shader abissais. Nenhuma etapa começa apenas pelo aceite desta entrega documental: exige aprovação do contrato e autorização da respectiva etapa. Se outro arquivo/decisão for necessário, apresentar ajuste antes de editar. Duração, ondas, cap, identidades, saves, campanha/HQs e outros mapas permanecem fora do recorte.

## Plano de voo, portagem e validação

Antes de S-PATH-002: reler estado compartilhado, registrar autorização e baseline dos17 caminhos/recursos, suspensão do fluxo Dagruve com cursor CP-DAG-005 e aceite humano ainda pendente. A mudança será local ao PC, sem sincronização ou escrita na origem. Registrar a portagem em pacote local com hashes de origem, trechos correspondentes e diffs, estado PENDING_APPLICATION_OWNER_APPROVAL. Para mudanças comuns, validar também cópia sintética da origem com o candidato correspondente, ajustando apenas harness e registrando incompatibilidades; não afirmar que a origem recebeu a alteração. Se não for possível executar esses checks sem ampliar escopo, isso bloqueia a conclusão técnica e exige reconciliação própria. Contrato não dispensa os checks em ambos nem autoriza atualização da origem.

S-PATH-002: aplicar Yggdrasil; testes navigation/map/art, root_navigation/root_art para regressão abissal, terrain e scripts_compile. Na S-PATH-003 repetir os afetados pela espiral, não repetir validação inalterada sem motivo. S-PATH-004: conjunto consolidado desses sete testes mais tests/test_qa_sandbox.gd, tests/test_battle.gd, tests/test_map_objectives.gd, tests/test_level_design.gd e tests/test_reach_grid.gd. A repetição determinística é adicionada às suítes de navegação existentes. Simular integralmente240/360s com contexto sintético, sem mudanças na mecânica real para viabilizar os testes. Confirmar saída sem progresso de campanha e limites40/50.

Critérios técnicos:128 sementes de Yggdrasil (0–119 mais7502,7503,7504,7601,7602,7603,1_000_001,2_147_483_647), mesmas sementes repetidas com hash idêntico, pelo menos120 variantes distintas entre128; 100% dos mapas aceitos/fallbacks conectados, pelo menos95% sem fallback. No estágio de teste, congelar HP apenas no harness de simulação longa e declarar isso; não confundir com teste de sobrevivência humana. Testar fronteiras para raios0,15/0,3/0,4/0,8/1,2, longos deslocamentos e todos os consumidores existentes de empurrão/dash/charge/loot. Preservar voo apenas sintético conforme contrato atual, sem dar voo a inimigos.

Raster: nas resoluções1280×720 e1920×1080, capturar visão geral e combate, incluindo sementes7502/7503/7504 e espiral; máscara de topo versus definição CPU, tolerância apenas de antialias de1pixel, sem suporte falso interior. Comparar sombra separadamente. Instrumentar pelo menos30frames de aquecimento+600frames de medição com seed7504/Ygg40 e seed7202/Abismo50, dt1/60; critério inicial mediana/p95 de CPU≤baseline×1,15 e renderp95≤baseline×1,20 sob mesmo ambiente. Falha exige ajuste dentro do teto ou checkpoint de desvio; não afrouxar critérios silenciosamente. Aumento do custo dos loops dos shaders é risco concreto a medir.

Toda abertura Godot usa APPDATA/LOCALAPPDATA/perfil novos e probe sem autoload antes do jogo. Nunca save real. S-PATH-005 tem dois aceites humanos separados: Yggdrasil (espessura, variedade real entre sementes, desvios, congestionamento e bordas); Abismo (leitura da espiral, alternativas, orientação/subida-descida e combate). Não concluir por métricas. Antes de abrir informar build, controles e objetivo; concluir somente após feedback explícito dos dois.

## Evidência, gaps e reconciliação

[study-r1.json](../../generated/path-revision-20261017/study-r1.json) registra análise independente em grade0,5 para quatro raios em duas malhas-base e oito sementes. Todas as áreas amostradas ficaram conectadas ao destino. Yggdrasil ocupa aproximadamente30% da grade para raio0,3, Abismo45%; são medidas de apoio ao estudo, não medições de arte nem teste da implementação. O desenho foi inspecionado; vazio e conexões são legíveis na prancha. A geração documental não implementa o runtime nem prova ausência de todas as interseções para sementes futuras: guardas e testes de128 sementes são requisitos da implementação.

Zero gaps BLOCKING para submissão deste contrato. Aprovação das medidas, nova chegada/destino abissais, arquitetura e teto17 é o checkpoint pendente CP-PATH-001. RESOLVABLE: implementar guardas/instâncias/arrays, conferir emendas e executar portagem/checks candidatos previstos; resultados ainda não existem. DEFERRED: arte nova, altura física, balanceamento e integração de campanha. Nenhuma aprovação histórica é contada como aceite desta nova build.

Recuperação: baseline por etapa, comparação de concorrência antes de escrever/reverter, restauração apenas dos trechos próprios; nunca substituir arquivo inteiro que recebeu alteração de outro chat. Registro final reconcilia hashes, portagem pendente e resultados reais. O plano Dagruve e a integração HQ19/HQ20 permanecem intactos nesta entrega.

## Aceite do contrato

Contrato r1 aprovado explicitamente, incluindo medidas, posições e teto17. Autorizada S-PATH-002 somente Yggdrasil e testes isolados. O texto DRAFT acima registra sua apresentação; decisão em DEC-MAP-PATH-CONTRACT-20261017-r1.

## Entrega S-PATH-002

Yggdrasil implementada e checks isolados concluídos; evidência .atena/evidence/EVID-NOTTGARD-PATH-YGGDRASIL-IMPLEMENTATION-20261017-r1.md.14/17 caminhos. Abismo S-PATH-003 aguarda autorização. S-PATH-004 desempenho/consolidação e S-PATH-005 aceite humano permanecem pendentes.

## Entrega S-PATH-003

Espiral implementada conforme autorização explícita. Evidência .atena/evidence/EVID-NOTTGARD-PATH-ABYSS-SPIRAL-20261017-r1.md;17/17 caminhos no plano. Validação conjunta/desempenho S-PATH-004 e playtests S-PATH-005 continuam nos seus checkpoints.

## Entrega S-PATH-004 e ajuste r2

O titular aprovou o ajuste validation-adjustment-r2-draft.md, elevando o teto17→18 somente para tests/test_map_objectives.gd. Etapa técnica concluída com 12/12 suítes PC, teste de objetivos também na candidata sintética e desempenho dentro dos limites originais. Evidência: .atena/evidence/EVID-NOTTGARD-PATH-JOINT-VALIDATION-20261017-r2.md. S-PATH-005 permanece pendente de autorização e dois aceites humanos.

## Entrega S-PATH-005 — aceite humano e conclusão

Titular testou e aprovou caminhos, bordas e combate nos dois mapas, incluindo leitura da espiral abissal, e autorizou a conclusão. S-PATH-005 e plano concluídos,5/5 etapas. Build r2 preservada,18/18 hashes; validação técnica12/12 e desempenho reutilizados sem mudanças. Evidência: .atena/evidence/EVID-NOTTGARD-PATH-HUMAN-PLAYTEST-20261017-r2.md. Portagem na origem e feedback Dagruve permanecem nos próprios checkpoints.
