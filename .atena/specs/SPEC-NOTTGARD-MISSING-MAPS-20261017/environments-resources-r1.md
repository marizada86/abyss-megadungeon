---
id: DOSSIER-NOTTGARD-MISSING-MAPS-20261017
revision: r1
status: DRAFT_AWAITING_OWNER_ACCEPTANCE
origin: planned
implementation_preceded_spec: false
step: S-MAP-002
platform: windows-x86_64
---

# Reino Abissal e Domwieck — ambientes e recursos

S-MAP-002 autorizada em 2026-10-17: “Atena, aprovado. Vamos priorizar os mapas e iniciar a S-MAP-002, detalhando os ambientes e os recursos de Reino Abissal e Domwieck.” Entrega documental, sem geração, adaptação de imagens, código de jogo, admissão de assets ou execução Godot. Integração futura sob responsabilidade de Atena, sem especialistas/delegação. O modo per-step permanece; este dossiê não autoriza S-MAP-003.

## 1. Autoridade e bíblia aplicável

| Fonte local | Estado / revisão | O que governa |
| --- | --- | --- |
| [Contrato de mapas](../SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/chapter1-maps-transitions-r1.md) e [aceite](../../vault/canon/DEC-NOTTGARD-CHAPTER1-MAPS-CONTRACT-20261016-r1.md) | CANON aceito r1, apesar do cabeçalho antigo do documento técnico | Dimensão, objetivos, ondas, recompensas, migração, fila e limites do capítulo |
| [Todo solo é raiz](../../vault/canon/DEC-ABYSS-ROOT-GROUND-20261016-r1.md) | CANON r1 | Toda superfície de apoio do Reino Abissal, inclusive acampamento, é raiz entrelaçada; avermelhado só reflexo na casca |
| [HQ17 aceita](../../vault/canon/DEC-HQ17-SEQUENCE-APPROVAL-20261016-r1.md), Q3 v02 | CANON sequência r1 | Profundidade, raízes colossais, legião/acampamento e relâmpagos; referência inspecionada |
| [HQ18 aceita](../../vault/canon/DEC-HQ18-SEQUENCE-APPROVAL-20261017-r1.md), Q3 v01 | CANON sequência r1 | Domwieck material: arquitetura élfica, invasão, calçamento, Tarn azul; referência inspecionada |
| [Jardim](../../vault/canon/DEC-AILALORE-GARDEN-VISUAL-20261017-r1.md), [estrela](../../vault/canon/DEC-AILALORE-STAR-SCALE-COLOR-20261017-r1.md), [HQ03 aceita](../../vault/canon/DEC-HQ03-SEQUENCE-APPROVAL-20261017-r1.md), Q1 v03 | CANON r1 | Floresta circular, jardim de flores vermelhas, estrela grande azul-clara e feixe reto até a Tarn; referência inspecionada |
| [Consolidação visual de HQs](../../vault/drafts/HQ-REVIEW-VISUAL-BIBLE-r1-20261015.md) | DRAFT r2; correção específica da Tarn canônica | Referência de acabamento, não bíblia canônica integral do gameplay |
| core/iso.gd, ui/ground.gd e cenas existentes | Fato operacional, baseline desta etapa | Jogo isométrico 2:1, tiles projetados 64×32, Sorted com y-sort, herói/controles/câmera existentes |

Não foi localizada bíblia dedicada aos dois mapas entre as referências dirigidas consultadas. Este dossiê preenche a preparação textual como DRAFT; não promove a bíblia HQ inteira nem estabelece lore nova. Imagens das HQs são referências de identidade/contexto, não texturas de chão ou fundos prontos para recorte. Uso local neste projeto; não inferir licença de redistribuição externa dos recursos apenas por existirem no acervo.

Identidade N/A para terreno, arquitetura genérica e adereços: nenhum novo personagem representado. Ailalore não é N/A: objeto nomeado, governado pelas decisões acima. Herói jogável mantém identidade/runtime atuais. Não introduzir retratos de Erik, Ailalore personificada, Kein, Adam ou Helion como NPCs simulados. Legião usa inimigos existentes previstos no contrato; HQ panorâmica não autoriza todas as criaturas nela vistas como novas unidades.

## 2. Linguagem comum e legibilidade — proposta DRAFT

Conservar projeção, câmera e escala. Usar acabamento pixelado compatível com os recursos atuais, contornos nítidos, chão com contraste baixo e sinais de objetivo com contorno legível. Evitar textura miúda que esconda projéteis. Não transportar a faixa de legenda/16:9 de HQ para o piso do jogo.

Reino Abissal: casca castanha escura, sulcos frios, reflexos avermelhados discretos, fogo âmbar e fundo profundo violeta apagado. Domwieck: calçamento frio, vegetação escura, incêndios âmbar periféricos, jardim vermelho e luz azul-clara. Paletas são propostas operacionais, não novas regras cosmológicas. Manter Tarn como domo azul translúcido, sem convertê-la em vidro/muralha. Não aplicar névoa verde cobrindo Domwieck antes de sua queda na HQ03. Relâmpagos e fogo são decorativos, sem dano novo; relâmpagos discretos e sem flashes de tela inteira são recomendados para legibilidade.

HUD: objetivo textual, relógio regressivo, marcador de destino com seta quando fora da câmera, indicação de indisponível antes do tempo e progresso explícito dos 3 s. Cor nunca é o único sinal. Não inventar nova tecla: chegada/presença conclui objetivo; interação com portal mantém controles existentes. Áudio: nenhum arquivo novo necessário ao protótipo; conferir fallback existente antes de prometer trilha própria. Sem produção/compra de áudio nesta etapa. Animações novas de personagem são N/A; eventual brilho ambiente não cria mecânica nem altera telegráfos de combate.

## 3. Convenção espacial e invariantes

Coordenadas seguintes são de chão, x/y em [0,60], origem igual à usada por Iso, não pixels de tela. A conversão do contrato normalizado é (u×60,v×60); “entrada/sul” e “objetivo/norte” são orientação da planta, não direções verticais da tela. Conversão de implementação: Iso.to_screen, sem posicionamento em pixels copiado de Docas. Exemplo: entrada (30,45) projeta (-480,1200); alvo (30,15), (480,720). São ambos 60×60; não reutilizar escala 84×84 ou desenho 40×40 sem conversão explícita.

Invariantes: entrada livre num raio 6; alvo livre num raio 4; objetivo reconhece raio 2. Corridores mínimos medidos depois de colisões/raios de props. Alvo acessível desde o início; só a conclusão espera o tempo. Não usar portas dinâmicas, queda, salto ou colisões invisíveis. Spawn de ondas não deve cair dentro de bloqueios nem dentro da área livre de chegada; conservar regras existentes de aparição/distância do herói e verificar também geometria nova. Não prometer spawn invulnerável: área livre significa sem obstáculos.

## 4. Reino Abissal

**Contexto:** após HQ17 e antes de HQ18, primeira incursão. Região de raízes colossais sobre profundidade cilíndrica; legião acampada e aproximação do ritual. Sem Shedaklah, floresta fúngica, Marciela, Estige ou Yggdrasil por inferência. Kein/Beholder/Death Tyrant permanecem na HQ18.

| Zona / centro | Planta proposta | Recursos e colisões |
| --- | --- | --- |
| Chegada (30,45) | Área circular de raio 6, apoiada em raízes largas | Chão contínuo; indicação da direção do ritual. Nenhum prop bloqueante no disco |
| Raiz central (30,30) | Marco de união de grandes feixes, legível no próprio piso | Marco atravessável, sem tronco sólido no meio da rota |
| Acampamento oeste (15,30) | Clareira de combate sobre raízes, raio 6 | Carga/braseiro em bolsões fora do eixo de circulação; tendas só em acabamento posterior |
| Acampamento leste (45,30) | Segunda arena lateral, raio 6 | Mesmo princípio, composição diferente; evitar filas de props que virem paredes |
| Acesso ao ritual (30,15) | Disco livre raio 4 e alvo raio 2 | Marca temporária no protótipo; ritual narrativo além da saída, sem chefe inserido |
| Profundidade periférica | Fundo atrás/fora do chão caminhável | Raízes pendentes e vazio no acabamento; nenhum buraco real dentro da arena |

Rotas: central x=27..33, y=11..51 (largura 6); ramais horizontais y=27..33 ligando x=9..51; passagens laterais x=12..18 e x=42..48, y=15..45, ligadas nas travessas y=15 e y=45 com largura 6. Piso caminhável continua entre zonas; estes corredores são reservas mínimas de espaço livre, não trilhas estreitas sobre queda. A margem do mapa permanece contida pela regra existente, sem nova penalidade.

Obstáculos iniciais recomendados: somente pequenos conjuntos de carga/braseiros fora das reservas, raio bloqueante explícito até 0,4 por prop reaproveitado. Excluir todos os discos de entrada/alvo e corredores considerando o raio. Raízes colossais atravessando o piso devem ser relevo visual sem colisão inicial; raízes altas só no perímetro, sem encobrir o combate. A disponibilidade do acervo não autoriza usar rocha mineral para representar raiz.

Objetivo aceito: 360 s e 3 s de presença. A partir de 360 s cessam ondas/elites, sobreviventes continuam até presença. Dano não reinicia presença; sair do raio reinicia. Conclusão idempotente limpa perigos/inimigos sem rotina de abate/recompensa, salva marco e abre HQ18 na integração. Depois: portal de retorno para Domwieck ou extração. Sem Maré pós-chefe nova.

## 5. Domwieck

**Contexto:** retorno após HQ18, invasão em andamento, antes do ataque a Ailalore na HQ03. Distrito élfico, ruas/plaza e aproximação da floresta circular/jardim. Tarn ainda sustentada. Não antecipar Véu Vivo, queda da estrela, estrela apagada ou raízes protetoras nas muralhas.

| Zona / centro | Planta proposta | Recursos e colisões |
| --- | --- | --- |
| Chegada (30,45) | Disco livre raio 6 | Orientação para Ailalore; sem civil/escolta obrigatória |
| Praça de resistência (30,33) | Bolsão de combate de raio 6 | Colunas e destroços periféricos; manter o centro livre |
| Ruas laterais (15,30)/(45,30) | Duas alternativas conectadas ao eixo | Rotas de largura 4; fogo/carga fora da passagem |
| Acesso ao santuário (30,15) | Disco livre raio 4 e alvo raio 2, antes do jardim | Conclusão por chegada; não exigir atingir/coletar estrela |
| Jardim ao fundo (30,7) | Disco de flores vermelhas raio 4; floresta circular entre raios 4 e 7 | Zona de composição proposta, sem objetivo/NPC/vida própria. Manter passagem e alvo externos ao anel. Arte alta não pode cobrir alvo/herói |
| Estrela no jardim (30,7) | Ailalore azul-clara, relativamente grande, feixe vertical azul até a Tarn | Somente cenário; tamanho final sujeito à aprovação de arte, sem número canônico inventado |

Rotas: eixo x=27..33, y=11..51, largura 6; laterais x=13..17 e x=43..47, y=15..45, largura 4; conexões y=43..47 e y=13..17 entre x=15..45. Disco da praça raio 6 preservado, sem obstáculos nele. Bolsões laterais de raio 6 em (15,30)/(45,30). Corrigir qualquer combinação de copa/sombra/colisão que esconda a saída mesmo quando a rota geométrica estiver livre.

Arquitetura élfica exige recurso próprio no acabamento. A casa de Dagruve inspecionada é construção urbana deteriorada de madeira/pedra, não prédio élfico pronto. Coluna existente pode fornecer ruína genérica, não identificar templo/bairro específico. Nenhum fogo causa dano, cresce ou destrói prédio. Não introduzir civis com estado de morte. Adam não aparece como inimigo jogável ou chefe.

Objetivo aceito: 420 s e presença 3 s. Encerramento jogável limpa sem abate, salva Domwieck, abre HQ03 e só fecha capítulo após leitura/dispensa explícita. O ataque de Adam e a transformação do Véu continuam na HQ. Não ligar provisoriamente a Dagruve/Shedaklah.

## 6. Recursos existentes, inspeção e decisão proposta

| Recurso | Constatação | Uso recomendado |
| --- | --- | --- |
| ui/ground.gd, hero_view.tscn, prop.tscn, spawn_point.tscn, core/iso.gd | Infraestrutura existente lida; mapa/posições e render separados | Reutilizar contrato de cena Ground/Sorted/Hero/SpawnPoints; não copiar spawns/props de Docas como população dos mapas |
| assets/props/braseiro_01.png | Inspecionado: fogo âmbar em suporte metálico | Reuso funcional em acampamento/rua; não equivale a incêndio de prédio |
| assets/props/carga_01.png | Inspecionado: sacos/rolos atados | Reuso genérico nos bolsões, sem afirmar equipamento específico da legião |
| assets/props/coluna_01.png | Inspecionado: coluna clara quebrada com vegetação | Reuso em Domwieck como ruína genérica, fora das rotas; não usar como raiz abissal |
| assets/props/flor_01.png | Inspecionado: flores brancas/violetas | Não reutilizar como jardim vermelho de Ailalore. Precisa recurso próprio ou representação provisória explicitamente aceita |
| assets/props/cristal_01.png | Inspecionado: cristal vermelho com suporte | Não usar como Ailalore, mesmo que seja o cristal disponível |
| assets/props/dagruve_estrutura_01.png | Inspecionado: casa deteriorada de pedra/madeira | Não reutilizar como arquitetura élfica final |
| assets/tiles/dagruve_ground_atlas_v3.png | Inspecionado: pedra escura | Não serve como solo de raízes; no máximo comparação técnica de atlas, sem admissão nos mapas novos |
| HQ17 Q3 v02 / HQ18 Q3 v01 / HQ03 Q1 v03 | Imagens aceitas inspecionadas; hashes no baseline | Referências de ambiente e continuidade; não extrair chão/miniatura/fundo automaticamente |
| Sprites dos cinco inimigos do contrato | IDs conferidos em data/enemies.json; recursos localizados pelo inventário | Reusar unidades vigentes, sem criar aparências/espécies novas. Não houve nova auditoria visual individual desses sprites nesta etapa |

Inspeção complementar das variantes: carga_02/03 também são sacos/rolos genéricos, adequados ao mesmo reuso proposto. braseiro_02/03 têm chama violeta, diferente do âmbar de _01. ui/prop.gd escolhe variantes 1..3 pela posição: **omitir a família braseiro do protótipo recomendado**, usando apenas carga como bloqueio genérico. Não depender de mover o objeto até obter casualmente a cor desejada. Reuso futuro específico de braseiro_01 exige seleção determinística/adaptação delimitada e checkpoint correspondente. O fato de um prop estar no acervo não aprova automaticamente todas as suas variantes para o ambiente.

Não foram encontrados arquivos específicos de reino_abissal/domwieck entre assets/tiles, assets/stages e assets/props na busca dirigida. Ausência desses nomes não prova ausência de toda arte reaproveitável. A busca também não identificou pacote dedicado de raízes/tendas/árvores élficas sob nomes pertinentes; não alegar que um pacote completo existe.

## 7. Produção faltante e proposta de protótipo

| Pacote futuro | Necessário para acabamento | Limite |
| --- | --- | --- |
| RA-01 piso | Superfície contínua de raízes entrelaçadas e caminhos visualmente limpos | Sem mineral/fungo; padrões não podem esconder ataques |
| RA-02 cenário | Raízes grandes, acampamento/tendas e indicação do acesso ritual | Cenário não exige novas unidades nem ritual jogável |
| RA-03 fundo/miniatura | Profundidade de raízes e apresentação no menu | Produção separada; não recortar HQ como aprovação implícita |
| DO-01 piso/arquitetura | Calçamento e módulos élficos com destruição ambiental | Sem transplantar Dagruve inteira |
| DO-02 jardim | Floresta circular, flores vermelhas, Ailalore azul-clara e feixe/Tarn | Sem flor branca/cristal vermelho como equivalência |
| DO-03 fundo/miniatura | Distrito sob Tarn durante a invasão | Sem Véu Vivo antecipado |

**Recomendação concreta para CP-MAP-003:** aprovar primeiro um protótipo funcional DRAFT de Reino Abissal, com piso sem bitmap por formas/linhas de raízes no render existente, marcador geométrico de ritual, família carga_01/02/03 inspecionada e fundo escuro simples. Sem braseiros, tendas/fundo/miniatura finais e sem nova imagem gerada. As formas devem representar madeira/feixes contínuos, nunca lajes minerais; manter piso caminhável em toda arena. Esta opção exige adaptação delimitada de ui/ground.gd e entradas isoladas em terrain_layout, não altera arquitetura/engine. Revalidar os mapas antigos. Não confundir protótipo geométrico com acabamento aprovado.

Domwieck segue CP-MAP-004 próprio: propor então calçamento e volumes élficos provisórios, flores vermelhas geométricas, estrela azul-clara/feixe esquemáticos e silhuetas de floresta sem NPC. Não produzir esse protótipo na S-MAP-003. Se o dono preferir arte final antes do protótipo, é necessário um checkpoint de seleção/produção/admissão de recursos; não iniciar geração por efeito deste dossiê. Não há dependência/serviço externo necessário ao caminho funcional recomendado.

## 8. Inventário exato de consumidores e orçamento futuro

Baseline informativa: [baseline-r1.json](../../generated/missing-maps-20261017/baseline-r1.json). Hashes não autorizam sobrescrever mudanças posteriores. Antes de runtime recapturar e comparar arquivos, inclusive fontes aparentemente intactas. Arquivos novos devem continuar ausentes ou ser reconciliados se surgirem em outro chat.

**S-MAP-003: máximo 13 arquivos de jogo/teste**, excluindo registros ADD: data/stages.json, data/level_design.json, core/battle.gd, core/terrain_layout.gd, ui/ground.gd, ui/run.gd, ui/hud.gd, ui/stage_progress.gd, ui/menu.gd, ui/stages/reino_abissal.tscn (novo), tests/test_data.gd, tests/test_battle.gd, tests/test_map_objectives.gd (novo). Modificar somente o necessário; se outro consumidor/teste exigir mudança, apresentar ajuste de orçamento antes. Catálogo/menu/QA devem tolerar boss vazio; se QA depender de alteração fora dessa lista, bloquear o alvo de chefe ausente sem fabricar unidade, e solicitar ampliação delimitada.

S-MAP-003 não reordena Docas, não implementa migração/novos direitos e não altera hqs. Reino Abissal deve ser exercitado somente por QA sintética explícita até S-MAP-005, sem liberar atalhos de campanha. Estados/callbacks de objetivo ficam no combate; persistência narrativa/fila pertence à integração. Fase seguinte Domwieck ainda ausente: o protótipo não deve tentar carregar cena inexistente nem fingir entrega da transição; disponibilizar só conclusão/resultado isolado de QA. Essa limitação temporária precisa estar explícita na evidência, sem mudar o contrato final aceito.

**Orçamento total do recorte, máximo 45 arquivos de texto/cena/teste** (manifestos de arte aprovados separados):

| Grupo | Caminhos delimitados / consumidor |
| --- | --- |
| Catálogos (9) | data/stages.json, data/chapter_flow.json (novo), data/hqs.json, data/stage_story.json, data/stage_events.json, data/stage_rules.json, data/stage_structures.json, data/level_design.json, data/prop_visuals.json |
| Core (6) | core/battle.gd (diretor, _on_boss_dead/conclusão, limpeza/QA), core/terrain_layout.gd (material/passagem novos), core/profile.gd (progresso/migração), core/game.gd (início autorizado), core/hq_catalog.gd (direitos/fila), core/playtest.gd (atalhos de chefe) |
| UI (8) | ui/ground.gd (fallback/raiz), ui/prop.gd (somente famílias novas admitidas), ui/run.gd (cena/fila/transição), ui/menu.gd (hoje indexa enemies[d.boss] diretamente), ui/hud.gd (objetivo), ui/stage_progress.gd (hoje só chefe/Maré), ui/hq_screen.gd (cursor), ui/stage_structures.gd (somente se ajuste necessário à nova estrutura visual) |
| Cenas (2) | ui/stages/reino_abissal.tscn, ui/stages/domwieck.tscn, novas |
| Ferramenta (1) | tools/playtest_interop.gd, se caminho QA assumir chefe |
| Testes existentes (17) | tests/test_data.gd, test_profile.gd, test_save_resilience.gd, test_hqs.gd, test_stage_progress.gd, test_stage_story.gd, test_stage_structures.gd, test_map_scale.gd, test_terrain.gd, test_reach_grid.gd, test_battle.gd, test_playtest.gd, test_qa_sandbox.gd, test_catalog.gd, test_level_design.gd, test_prop_visuals.gd, test_game_design.gd, todos sob tests/ |
| Testes novos (2) | tests/test_map_objectives.gd, tests/test_chapter_flow.gd, apenas cobertura comportamental necessária |

Leituras adicionais, não escrita autorizada: core/iso.gd, core/data.gd, core/sfx.gd, core/hero.gd, ui/scenery_layout.gd, ui/edge_fog.gd, ui/ground_decals.gd, data/scenery.json, data/ground_decals.json, data/enemies.json, testes/run_all e procedimento de validação. ATENÇÃO: nome real do agregador é tests/run_all.gd. SceneryLayout consulta scenery antes de level_design e pode remover props da cena; colocar os clusters dos novos mapas em level_design, sem duplicá-los em scenery. Sua folga padrão 5 é menor que os 6 exigidos na entrada; o dossiê deve ser respeitado pelos dados e pelo teste de alcance, não pela suposição de fallback seguro. TerrainLayout usa desenho-base 40×40 com scale=1,5; ajustar só entradas novas, enquanto level_design opera no desenho 60×60. Estrutura dinâmica pode reposicionar-se: não usá-la como autoridade do alvo de objetivo, que deve permanecer fixo e validado.

Não alterar project.godot, dependências, heróis, armas, conquistas, paths técnicos/saves nem arquivos Web. Novos IDs entram sem renomear conteúdo herdado. core/sfx.gd é somente leitura inicialmente: confirmar fallback para IDs novos; alteração exige revisão do orçamento.

## 9. Gaps, validação e aceite da etapa

| Gap | Estado / resolução |
| --- | --- |
| Identidade dos ambientes | RESOLVED para preparação: referências CANON identificadas e três cenas aprovadas inspecionadas; bíblia operacional nova continua DRAFT |
| Planta e colisões | RESOLVABLE antes de admissão: reservas acima concretas; prova de alcance/margens exige protótipo e checks, não foi alegada nesta etapa |
| Recursos finais ausentes | DEFERRED para acabamento se protótipo recomendado for explicitamente aceito; BLOCKING para declarar arte final pronta |
| Aceitação de recursos provisórios | CP-MAP-003 pendente: aceitar exatamente piso de raízes geométrico, alvo geométrico e reuso delimitado. Não existe escolha de produção sem solução proposta |
| Variantes de props / áudio / consumidores de boss vazio | RESOLVABLE em preflight de S-MAP-003; conferir antes de admissão/executar, ampliar orçamento só com checkpoint se necessário |
| HQ14 e integração de HQs | DEFERRED para S-MAP-005; trabalho concorrente preservado, reler cursor então |
| Raiz de Yggdrasil / capítulo 2 / Web | DEFERRED, sem produção nesta rota |

**Não há lacuna de design sem proposta que impeça revisar CP-MAP-003.** Sua execução continua condicionada ao aceite explícito do dossiê/protótipo e ao preflight delimitado. Prontidão funcional e prontidão da arte final são distintas. Não declarar a entrega inteira sem BLOCKING: arte final e integração/aceites próprios ainda pendem.

Checks desta etapa: referências locais dos documentos, existência/ausência e hashes dos caminhos delimitados, IDs dos inimigos do contrato e correspondência com matriz de recursos. Sem Godot, teste de gameplay, save ou alteração Web. A geometria proposta não é prova de alcance renderizado, legibilidade ou diversão.

Checks S-MAP-003: isolamento user_data_dir sintético antes de Godot; compilação; ausência de crash para boss vazio; presença antes/exatamente/depois de 360 s, raio/saída/retorno, dano sem reinício, pausa, morte/abandono, conclusão duplicada, cessar ondas/elites e limpeza sem XP/loot/bosses; alcance entrada→alvo/laterais com colisões reais. Regressão dirigida do chefe/Maré de Docas e mapas antigos se render/terrain comuns mudarem. Captura técnica do protótipo não equivale a arte final aprovada. Somente testes pertinentes, sem ampliar por rotina.

Entrega S-MAP-002: dossiê DRAFT r1 + baseline + evidência. Plano r1 com 2/7 concluídas e 5 restantes. Próximo: S-MAP-003, entrada = contrato CANON + dossiê aceito + baseline revalidado; saída = Reino Abissal e conclusão por objetivo verificáveis em QA isolada. CP-MAP-003 solicita aceite do dossiê e autorização específica desse protótipo. Nenhuma autorização de arte final, Domwieck, migração ou integração narrativa é inferida.
