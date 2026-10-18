---
id: SPEC-NOTTGARD-YGGDRASIL-ART-20261017
revision: r1
status: COMPLETE_OWNER_APPROVED_ART_R1_GEOMETRY_R3
origin: planned
implementation_preceded_spec: false
classification: PLAN_CHANGE_REQUEST
approval_mode: per-step
---

# Raiz de Yggdrasil — plano de arte final r1

Pedido: “Atena, vamos planejar a arte final da Raiz de Yggdrasil, usando as HQs como referência.” Planejamento documental autorizado; modo por etapa reutilizado dos mapas/arte, sem nova pergunta de modalidade. Usuário escolheu preparar/aprovar primeiro os quadros pertinentes da HQ20. Direção abaixo DRAFT r1. Responsável pela integração: Atena, sem delegação. Protótipo r3 concluído5/5 permanece preservado, não é reaberto por este plano.

## Autoridade, escopo e referências

[Protótipo aceito r3](../../vault/canon/DEC-YGGDRASIL-PROTOTYPE-PLAYTEST-ACCEPTED-20261017-r3.md), [galhos r3](../../vault/canon/DEC-YGGDRASIL-THICKER-BRANCHES-20261017-r3.md), [HQ20 textual CANON](../../vault/canon/HQ20-SCREENPLAY-APPROVED-20261017-r1.md) e [auditoria de referências/baseline](../../generated/yggdrasil-art-20261017/reference-audit-r1.json). HQ19 r2 e HQ21 r1 informam continuidade, não uma chegada simultânea do grupo. Bíblia geral de HQs é DRAFT r2 e não é promovida em bloco.

Acabamento visual do piso de raiz, junções, borda/face lateral, profundidade próxima e tronco distante no Windows x86_64. Preservar mapa60×60, sete discos/oito ligações, eixo12/desvios9, discos E8/C9/G6/laterais7, chegada(30,48), alvo(30,12), bordas travadas, dois vazios e ausência de props. Espessura visual de referência28px; textura acompanha essa projeção, não cria suporte lateral. Preservar corpos, sweep, controle, loot, ondas, cap40, duração240s+presença3s/raio2, QA-only e retorno ao seletor.

HQ20 Q1/Q3/Q4 são **referências propostas, ainda sem PNGs aprovados localizados no escopo consultado**. [Brief preparado](hq20-reference-brief-r1.md). Q1 define raiz/tronco/escala; Q3 passagem; Q4 borda/vazio. HQ19 Q6 v01 inspecionada, hash confere aceite: apenas continuidade do roxo/magia, não identidade material de Yggdrasil. HQ17 Q3 inspecionada para comparação, pertence ao Reino Abissal e fica excluída dos insumos de geração deste plano. Não reutilizar seu kit final como solução de identidade de Yggdrasil.

## Bíblia operacional — DRAFT r1

**Massa e materiais:** galhos colossais, largos e contínuos, casca orgânica com fibras longitudinais, nós e junções naturais. O visual deve tirar a aparência de faixas geométricas, sem estreitar sua área útil. Material/paleta exatos serão derivados das imagens HQ20 aprovadas; proposta inicial de madeira em tons contidos, sulcos escuros e realces suaves, sem fissuras luminosas ou musgo inventados como característica canônica. Não aplicar automaticamente o negro/corrupção do Reino Abissal.

**Borda e vazio:** topo claramente sólido, face lateral mais escura e sombra que comunica volume. Irregularidade decorativa contida na máscara de apoio; nenhum ramo fino, extensão ou ilha fora dela pode parecer transitável. Sem buracos no chão sólido, degraus aparentes, novo obstáculo, queda ou bloqueio criado pela arte. Não mudar o collider para acomodar a imagem.

**Tronco e atmosfera:** fundo deve sugerir árvore monumental cujo fim não aparece, com leitura de profundidade. Baixo contraste atrás da ação, sem sobrepor herói/rotas/HUD, sem falsa parede ou ponte. Não transformar a HQ inteira em panorama gigante. Luz e cores definitivas dependem de Q1/Q4; passagem segue a continuidade roxa, com brilho contido e sinal funcional existente legível. A aparência do portal de Q3 não autoriza transição de campanha.

**Estilo e leitura:** fantasia sombria, detalhe pixelado controlado, bordas nítidas e adaptação isométrica2:1/64×32. Escala da madeira legível na câmera normal; evitar padrão dominante/repetição evidente. Ataques, inimigos, recursos e alvo têm prioridade de contraste. Perspectiva aplicada uma vez; nada de texto/runa definitiva/HUD gravado nas texturas. Sombras consistentes, alfa sem halos e composição legível em tons de cinza.

Identidade ambiental de Yggdrasil é relevante e aguarda HQ20 visual; não é N/A. Personagens/NPCs/monstros são N/A para os assets do mapa porque nenhum será gerado ou incorporado por este recorte. Leoric/Korrak/Maelor/Marciela exigem identidades próprias se houver produção dos quadros da HQ20, conforme brief separado. Nidhogg, escolta de Marciela, mordida, novos habitantes, runas canônicas, áudio, animações, clima, menu/miniatura, Web, exportação e publicação ficam fora deste plano. Arte final não integra o capítulo2 automaticamente.

## Etapas e checkpoints

| Ordem | Etapa | Entrada → saída e checkpoint |
| --- | --- | --- |
| 1/5 | S-YART-001 | Protótipo aceito + roteiro/HQs → auditoria, direção e plano DRAFT; concluída documentalmente |
| 2/5 | S-YART-002 | Direção e referências HQ20 selecionadas/aceitas → até duas amostras DRAFT com imagegen; CP-YART-002 |
| 3/5 | S-YART-003 | Amostras aceitas + autorização → conjunto final de até quatro PNGs e manifesto; CP-YART-003 |
| 4/5 | S-YART-004 | Conjunto aceito + autorização concreta → integração delimitada e testes isolados; CP-YART-004 |
| 5/5 | S-YART-005 | Build validada + autorização → playtest visual humano e registro de aceite/ajustes; CP-YART-005 |

**Dependência prioritária antes de S-YART-002:** preparar, produzir sob escopo próprio e aprovar HQ20 Q1/Q3/Q4. A preferência do usuário autoriza organizar esse trabalho; não aprova identidades/prompts/arquivos ainda ausentes nem a geração. O brief de seleção é a entrada para o próximo checkpoint documental; não usar uma autorização de amostras do mapa para gerar novos quadros narrativos. Nenhuma produção avança enquanto faltarem referências e aceite concreto.

## Produção e integração propostas

Duas amostras: (A) passagem de galho, junção e borda, com indicação de escala compatível com a câmera; (B) tronco/vazio/passagem como estudo de fundo e leitura. Sem novos personagens identificáveis. Anexar somente PNGs HQ20 explicitamente selecionados, por versão/hash; texto CANON continua limitando o conteúdo. Aceite das amostras precede o conjunto.

Conjunto proposto: até quatro PNGs — ground (casca/fibras do topo), edge (face lateral/sombra), detail (nós/junções) e trunk (fundo distante). Alfa real onde necessário, fundo de piso opaco; sem cenário inteiro numa só imagem. Importação até1024×1024 por PNG, até16MiB RGBA8 por cópia para quatro imagens sem mipmaps; isso não representa memória total/GPU. Nativos preservados; recorte, pivôs/UV, margens e dimensões definidos após inspeção, nunca presumidos como adequados antes da produção. Se o empacotamento exigir expansão, apresentar revisão antes de executar.

Integração proposta em **até10 caminhos de jogo/teste**: quatro PNGs em assets/tiles/yggdrasil_r1/; data/yggdrasil_art.json; ui/ground.gd apenas ramo Yggdrasil; novo ui/yggdrasil_art.gd local; ui/stages/raiz_yggdrasil.tscn; novo ui/shaders/yggdrasil_root_art.gdshader; novo tests/test_yggdrasil_art.gd. Lista/arquitetura definitiva depende das amostras e será confirmada antes do checkpoint de integração. Metadados derivados .import/.uid não contam; não mover código de runtime para helpers para contornar o teto. Navegação, Hero, Battle, catálogos, HQs e campanha permanecem preservados. Manter fallback geométrico r3.

## Validação e recuperação

Registrar baseline recente por caminho e conferir concorrência. Testar novo test_yggdrasil_art e dez regressões: test_yggdrasil_navigation, test_yggdrasil_map, test_root_navigation, test_root_art, test_domwieck_art, test_map_objectives, test_level_design, test_terrain, test_chapter_flow e test_scripts_compile. Verificar invariantes funcionais, caminhos/recursos, máscara raster versus apoio, fallback e ausência de suporte visual falso; não apenas espelhar a implementação.

Capturas1280×720/1920×1080: entrada, centro, dois desvios, borda/vazio, alvo, tronco e combate com40 inimigos/recursos/ataques, overview e tons de cinza. Conferir leitura, repetição, costuras, alfa, oclusão e marca de objetivo. Regressão visual dirigida dos pisos Reino Abissal/Domwieck. A/B de Yggdrasil geométrica/final na mesma sessão/câmera/seed7504,dt1/60,população40,30frames de aquecimento+600 medidos. Investigar aumento sustentado acima de10% em mediana/p95 e novas pausas; relatar CPU/loop sem prometer FPS GPU.

Toda execução Godot usa APPDATA/LOCALAPPDATA/perfil sintéticos com probe sem autoload antes de carregar o jogo. Jamais save real. Nenhum Godot executado neste planejamento. Checks anteriores reutilizáveis com arquivos/aceitação inalterados. Aceite humano avalia continuidade com HQ20, escala/volume, leitura das bordas/passagem e conforto visual em combate; testes não certificam diversão.

Recuperação: manter fontes/candidatas, manifesto e fallback; reverter somente arquivos próprios após conferir alterações concorrentes. Não restaurar planos compartilhados antigos, dados de campanha ou saves. Nenhuma dependência, instalação, contexto remoto, serviço pago adicional, commit ou publicação autorizado. Imagegen é a ferramenta proposta para amostras/kit, ainda sem execução ou contratação de especialista delegado.

## Gaps e prontidão

| Item | Estado |
| --- | --- |
| Geometria e jogabilidade r3 | RESOLVED por aceite humano; imutáveis neste plano de arte |
| Identidade ambiental / PNGs HQ20 | BLOCKING para produção de amostras; preparar/aprovar Q1/Q3/Q4 primeiro, conforme preferência do usuário |
| Identidades para produzir quadros narrativos HQ20 | RESOLVABLE em seleção própria antes de gerar; não inventar Marciela |
| Paleta/textura/escala fina | RESOLVABLE pelas referências selecionadas e duas amostras |
| UV/alfa/oclusão/desempenho | RESOLVABLE no conjunto e integração delimitados |
| Arte de outros mapas, lore nova e capítulo2 funcional | DEFERRED; escopos próprios |

Planejamento S-YART-001 concluído, **1/5 etapas concluídas e quatro restantes**. Zero BLOCKING para apresentar o plano/brief documental; produção de amostras não está pronta. Próximo checkpoint: aprovar direção/plano r1 e recorte Q1/Q3/Q4 para detalhar a seleção visual da HQ20 antes de qualquer geração. Não solicitar autorização de imagegen com referências ausentes.


## Direção e recorte aprovados — seleção detalhada

Usuário aprovou direção r1 e HQ20 Q1/Q3/Q4 e autorizou detalhamento documental. [Decisão CANON](../../vault/canon/DEC-YGGDRASIL-ART-DIRECTION-20261017-r1.md). Propostas futuras de produção/integração continuam condicionadas aos seus checkpoints. [Seleção visual HQ20 DRAFT r1](../SPEC-NOTTGARD-HQ20-REFERENCE-SELECTION-20261017/selection-r1.md) preparada com identidades e composição. CP-V20-01 aguarda aceite, incluindo Marciela em vista indireta. Plano de arte permanece1/5; amostras aguardam referências produzidas e aceitas.


## Reconciliação de identidade de Yggdrasil

Durante a revisão da Q1, o usuário definiu árvore gigantesca no universo, rota entre todos os planos. [Definição CANON](../../vault/canon/DEC-YGGDRASIL-COSMIC-TREE-20261017-r1.md). A futura arte de fundo deve refletir essa identidade; não basta um tronco genérico em vazio escuro. Q1 será corrigida e submetida novamente; a implementação do mapa continua sem autorização e sua geometria r3 permanece preservada.


## Dependência HQ20 resolvida

Q1 v03, Q3 v01 e Q4 v01 aceitas; [manifesto aprovado](../../generated/yggdrasil-art-20261017/approved-reference-audit-r2.json). Restrições antigas de ausência de PNGs e material indefinido são históricas; geração cósmica segue as definições do dono e as imagens aceitas. Plano de arte1/5, pronto para CP-YART-002, [duas amostras delimitadas](samples-r1.md). Produção das amostras ainda não autorizada.


## Amostras aprovadas — 2/5

Usuário aprovou A/B v01. [Evidência de aceite](../../evidence/EVID-NOTTGARD-YGGDRASIL-ART-SAMPLES-ACCEPTANCE-20261017-r1.md). S-YART-002 concluída; três etapas restantes. CP-YART-003 aguarda autorização de [quatro PNGs/manifesto](kit-r1.md), sem integração.


## Aceite do conjunto — 3/5

Kit r1 aprovado: ground/edge/trunk v01 e detail v02. [Aceite registrado](../../evidence/EVID-NOTTGARD-YGGDRASIL-ART-KIT-ACCEPTANCE-20261017-r1.md). S-YART-003 concluída; duas etapas restantes. [Integração delimitada](integration-r1.md) aguarda CP-YART-004. Restrições históricas sobre ausência de referências/amostras não representam o estado atual.


## Integração validada — 4/5

S-YART-004 concluída nos10 caminhos previstos. [Evidência](../../evidence/EVID-NOTTGARD-YGGDRASIL-ART-INTEGRATION-20261017-r1.md),11 testes aprovados e auditoria final sem divergência de máscara. [Playtest visual S-YART-005](playtest-r1.md) aguarda autorização própria e avaliação humana. Uma etapa restante.


## Encerramento — 5/5

Usuário aprovou o playtest visual r1. [Resultado registrado](../../evidence/EVID-NOTTGARD-YGGDRASIL-ART-PLAYTEST-ACCEPTANCE-20261017-r1.md). S-YART-005 concluída; cinco etapas encerradas e nenhuma restante. Referências a checkpoints pendentes acima são históricas. Arte r1 aceita sobre geometria r3; demais escopos permanecem separados.
