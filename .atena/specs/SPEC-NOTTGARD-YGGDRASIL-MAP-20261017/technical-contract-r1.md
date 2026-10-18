---
id: CONTRACT-NOTTGARD-YGGDRASIL-MAP-20261017
revision: r1
status: DRAFT_AWAITING_OWNER_ACCEPTANCE_AND_CP_YGG_003
origin: planned
implementation_preceded_spec: false
step: S-YGG-002
approval_mode: per-step
---

# Raiz de Yggdrasil — contrato do protótipo r1

Autorização desta etapa: “aaprovado e autorizado”, após apresentação do recorte r1 e pedido explícito de detalhamento documental. Escopo IN_PLAN, S-YGG-002, etapa 2/5. A aprovação anterior aceita o recorte e o trabalho de desenho; os detalhes abaixo são proposta DRAFT para aceite antes de código. Responsável pela implementação futura: Atena, sem delegação.

Entradas: [plano r1](plan-r1.md), [HQ20 textual CANON](../../vault/canon/HQ20-SCREENPLAY-APPROVED-20261017-r1.md), HQ19/21 e decisão das chegadas ali referenciadas; navegação, objetivo e QA existentes. [Contrato estruturado, geometria e consumidores](../../generated/yggdrasil-map-20261017/contract-r1.json), [baseline documental](../../generated/yggdrasil-map-20261017/s002-baseline.json). São artefatos ADD, não tabelas de jogo ativas.

## Escopo funcional fechado para revisão

Novo ID `raiz_yggdrasil`, somente em data/prototype_stages.json com qa_only=true. Cena 60×60, Ground/Sorted/Hero/SpawnPoints existentes, sem personagem/áudio/bitmap novo. Nenhuma entrada no catálogo normal data/stages.json, menu de campanha ou progressão. Game.start_run continua rejeitando o ID fora do catálogo; ui/run mantém a barreira contra protótipo sem sandbox. QA explícita pelo launcher de mapas é a única entrada proposta.

Representação de travessia, não simulação literal de todos os personagens chegando juntos. HQ20, Marciela, Nidhogg e passagem narrativa para Shedaklah não são implementados nesta fase. Conclusão mostra resultado QA e retorna à seleção, sem carregar Shedaklah, tocar HQs/Diário, salvar milestone ou alterar capítulo 1. Sem chefe, captura, escolta, mordida, portal de transição utilizável ou bônus por matar Nidhogg.

## Planta, superfície e deslocamento

| Nó | Centro | Raio de apoio | Papel |
| --- | --- | --- | --- |
| E | (30,48) | 6 | Entrada livre |
| C | (30,32) | 7 | Junção/combate central |
| G | (30,12) | 4 | Saída, presença em raio 2 |
| W1 | (16,28) | 5 | Desvio oeste, combate/circulação |
| W2 | (18,18) | 5 | Retorno do desvio oeste |
| L1 | (44,28) | 5 | Desvio leste, combate/circulação |
| L2 | (42,18) | 5 | Retorno do desvio leste |

Oito cápsulas de apoio: E–C e C–G com largura 8; C–W1, W1–W2, W2–G e C–L1, L1–L2, L2–G com largura 6. União com os sete discos cria dois ciclos de navegação. Não são nove nós/doze ligações de Reino Abissal. Nenhum prop inicial ou obstáculo sólido; discos de entrada/saída e largura útil protegidos após considerar raio dos corpos. Herói começa em E; na cena, Iso.to_screen(30,48)=(-576,1248).

Proposta concreta: terrestres só apoiam o corpo inteiro sobre a união erodida dos discos/cápsulas; bordas travadas. Sem sair, cair, tomar dano de queda ou teleportar para corrigir passo comum. Sweep com subdivisão e deslizamento em eixos mantém diagonais, alto dt, dash, avanço, investida, empurrão e separação em superfície válida. Nenhuma nova capacidade aérea: air_ids vazio; teste aéreo sintético exercita o mecanismo existente sem conceder voo a espécie real.

Superfície e desenho provisório derivam da mesma definição. Chão de raiz largo e sulcos de madeira, fundo escuro; tronco distante apenas como forma esquemática sem colisão, sem esconder combate ou sugerir caminho. Nada do kit final de Reino Abissal é admitido neste ambiente. Objetivo: círculo/presença e texto existentes; marca roxa de passagem sem runa definitiva e sem função de portal jogável. Sem relevo que aparente parede/buraco no piso.

Análise documental independente: a grade de quatro vizinhos com margem circunscrita +0,71 tem todos os pontos conectados e saída acessível para corpos de raio 0,3, 0,4 e 0,8. Herói e três unidades usam raio 0,3; criatura_corrompida usa 0,4. Essa análise usa JS de documentação, sem importar runtime, e não substitui teste contínuo no Godot. Dados/resultados no contrato estruturado.

## Objetivo, dificuldade e ondas

| Parâmetro | Proposta r1 |
| --- | --- |
| Duração mínima | 240 s de simulação ativa |
| Presença | 3 s em raio 2 de G; só conta a fração de passo posterior a 240 s |
| Cap de combatentes | 40, sem crescimento por minuto; admissão estrita neste protótipo |
| Tier / HP / dano / moeda | 2 / ×1,5 / ×1,4 / ×1,0 |
| Elites/chefe/ambiente | Listas vazias; boss=""; sem Maré pós-chefe |
| Interativos/quebráveis automáticos | Desligados somente para este protótipo |
| Recursos de combate | XP, ouro e poções normais de inimigos; restritos à superfície e ao sandbox |
| Perfil-base QA | Durvall, seed 7502, dificuldade ×1, sem Marcas Abissais, profundidade 0 |

| Unidade provisória existente | Janela (s) | Intervalo-base (s) | Quantidade | Máximo vivo da onda |
| --- | --- | --- | --- | --- |
| cultista_adaga | 0–150 | 4 | 2 | 12 |
| notivago | 30–210 | 5 | 2 | 14 |
| cultista_arqueiro | 90–240 | 7 | 1 | 6 |
| criatura_corrompida | 150–240 | 9 | 1 | 8 |

Intervalos-base passam pelas fórmulas de abertura/SPAWN_SLOW já existentes; não se promete um relógio de spawn diferente do diretor atual. Limites por onda seguem também as regras existentes de abertura, sempre subordinados ao cap 40. Sem elites programadas ou bônus globais novos. Sprites/IDs/raios conferidos no acervo, hashes registrados; não houve adaptação nem nova revisão visual individual desses sprites. Uso como pressão QA é proposta de gameplay, não afirmação canônica de fauna/cultistas em Yggdrasil.

Antes do tempo: saída acessível, mas não conclui. Em 240 s cessam admissões ofensivas; inimigos e projéteis existentes continuam até concluir. Ficar no alvo antes disso não acumula presença; sair reinicia, dano não reinicia, pausa não conta. Conclusão idempotente limpa inimigos/perigos sem _kill, sem XP/loot/abates por essa limpeza; nenhum chefe ou Maré é criado. Morte/abandono antes da condição não vence. Recursos já obtidos na run são sintéticos, e nenhuma moeda/conquista/HQ/milestone do perfil fonte é alterada pelo resultado QA.

Três campos limitados ao novo protótipo: `prototype_no_interactions`, `prototype_no_breakables`, `prototype_strict_cap`, todos true. O primeiro é necessário porque interactions={} não desliga a criação atual: a rotina ainda força o primeiro baú. O segundo evita barris genéricos sem referência; o terceiro impede que admissão por invocação/divisão ultrapasse 40. Guardas opcionais/default false, sem alterar outros mapas. Não declarar o cap só pela tabela: verificar todos os chamadores de _spawn, divisão/invocação e período pós-240 s.

## Navegação: mudanças delimitadas e compatibilidade

Adicionar somente a entrada `raiz_yggdrasil` a data/root_navigation.json; entrada Reino Abissal r2 semanticamente idêntica. Novo formato aceita largura opcional por ligação (terceiro item); ligações antigas de dois itens continuam usando width=6. Não reinterpretar sua malha, arte ou orientação.

TerrainLayout.root_definition(stage_id="reino_abissal") passa a selecionar definição por ID e cache independente. root_supports(p, radius=0, stage_id="reino_abissal") e root_nearest(p,radius,stage_id="reino_abissal") ganham argumento final opcional, preservando assinatura de uso antigo. Não usar seleção global mutável de mapa. has_roots reconhece exatamente os dois IDs; ID desconhecido não herda o mapa abissal. MATERIAL_YGGDRASIL_ROOT distingue material provisório; is_blocked usa o ID recebido. A erosão usa metade da largura da ligação corrente, não um único half_width para todas.

Hero.can_stand repassa terrain_id; os sweeps existentes passam a receber a malha certa por esse caminho. Enemy já usa movimentação/apoio via Hero em Battle; core/enemy.gd não precisa mudar. Battle repassa stage_id em chegada, apoio, projeção de recursos e mobilidade. Chaves dos caches de grid/campos incluem stage_id; limpeza no load_stage continua. _root_spawn_valid consulta arrival/arrival_clearance da definição, usando o fallback antigo (30,45)/6,4 para Reino Abissal; Yggdrasil usa (30,48)/6,4. Nenhum spawn dentro da reserva de entrada, a menos de oito unidades do herói, em vazio ou componente inacessível. Falta de candidato retorna sentinela sem dívida de spawn, recompensa ou teleporte.

Loot e magnetismo percorrem raízes válidas para o mapa correto, sem atravessar vazio nem pagamento automático por lotação. Diretivas opcionais do protótipo só afetam seu ID/cadastro. Partidas de mapas distintos podem coexistir como objetos de teste e alternar consultas sem contaminar cache/material/apoio.

## Inventário exato de implementação — teto 13

| Caminho | Alteração permitida |
| --- | --- |
| data/prototype_stages.json | Adicionar ID/parametrização acima, mantendo dois registros anteriores |
| data/root_navigation.json | Nova malha e larguras por ligação; preservar Reino Abissal |
| data/level_design.json | Entrada com props=[] e material/chegada declarados, sem afetar outros layouts |
| core/terrain_layout.gd | Seleção explícita por ID, larguras, cache/material e defaults compatíveis |
| core/hero.gd | Repassar terrain_id ao apoio de corpo; preservar sweep e controles |
| core/battle.gd | ID em consultas/caches/spawn/recursos e três guardas restritos ao protótipo |
| ui/ground.gd | Ramo geométrico próprio de Yggdrasil; não trocar arte/procedural dos outros mapas |
| ui/stages/raiz_yggdrasil.tscn — novo | Contrato de cena 60×60 e chegada sem props |
| tests/test_yggdrasil_navigation.gd — novo | Corpo/sweep/caminhos/spawn/loot e nova geometria |
| tests/test_yggdrasil_map.gd — novo | Cadastro/QA, objetivo, diretor/cap, isolamento, cena e regressões de contrato |
| tools/playtest_maps.gd | Terceira escolha e --map autorizado; instruções distinguem artes aceitas e protótipo |
| tools/playtest_maps.ps1 | Admitir novo ID no ValidateSet; conservar isolamento/probe/importação |
| tests/test_root_navigation.gd | Regressão intercalada das duas malhas/cache, mantendo todas as expectativas r2 |

**Contagem: 13 caminhos, dez existentes e três novos** (cena + dois testes). Confirmar existência e baseline antes de editar; o contrato estruturado registra o estado observado. Metadados .uid/.import são derivados; documentos/helpers em .atena não são código de jogo. Não abrir exceção de contagem por mover mudança para helper de runtime.

Consumidores lidos e preservados sem edição: core/game.gd (start_run/start_qa_run), core/enemy.gd (raio e integração), ui/run.gd (barreira QA, carregamento por ID, cena, props, resultado), ui/scenery_layout.gd (level_design fallback), ui/stage_structures.gd (sem entrada fixa nova), ui/hud.gd, core/profile.gd, ChapterFlow e data/stages/hqs/chapter_flow. Launcher Testar-Mapas.cmd já abre o seletor, dispensa alteração. Testes existentes de objetivos continuam cobrindo seus dois mapas, sem enfraquecer expectativas específicas de geometria/props; novo teste cobre Yggdrasil. Scripts de teste individuais são carregados pelo runner existente, sem registro global novo.

Qualquer consumidor adicional necessário ao comportamento deve ser apresentado antes de editar o 14º caminho. Não adaptar catálogo normal, HQ, menu, cena do capítulo 1 ou save para fazer a QA funcionar. Nenhuma dependência, configuração global, instalação, asset externo ou publicação.

## Checks e evidências por etapa

S-YGG-003 implementa apenas este contrato depois do aceite explícito. Antes de executar Godot: perfil, APPDATA e LOCALAPPDATA sintéticos e probe mínimo sem autoload com user_dir dentro da sessão; falha encerra o lançamento. Verificação mínima da implementação: importação/compilação e entrada/cena/retorno QA, sem aceite humano inferido. Não adiar erro de carregamento para o playtest. Guardar baseline atualizado dos 13 caminhos e protegidos, comparar mudanças de outros chats e criar cópias somente dos próprios arquivos existentes.

S-YGG-004 executa os checks completos, conserta apenas dentro do contrato e registra resultado:

- test_yggdrasil_navigation: corpos 0,3/0,4/0,8, raio real do herói e dos quatro inimigos, todos os nós/arestas e ambos os sentidos; bordas, diagonal, dt alto, dash/avanço/investida/empurrão/separação, terrestre contorna vazio, aéreo exclusivamente sintético; spawns/invocações/divisões/loot/magnetismo com apoio válido, zero debt spikes/softlocks.
- test_yggdrasil_map: absent no catálogo normal, qa_only, acesso fora de QA recusado, cena/chegada/sem blockers; tempo antes/exato/depois de 240 s, passo que cruza limiar, raio/saída/reentrada, dano, pausa, morte/abandono, fim sem abate/drop, cap40 em todos os caminhos e nenhuma admissão ofensiva depois do tempo. Simulação integral seed7502/dt0,1 até ≥243 s, herói sintético invulnerável, sem usar resultado para afirmar dificuldade.
- Regressões: test_root_navigation, test_root_art, test_domwieck_art, test_map_objectives, test_level_design, test_terrain, test_chapter_flow, test_scripts_compile; mais test_battle dirigido aos ramos tocados e test_playtest para a entrada. **12 conjuntos ao todo:** dois novos e dez regressões. A lista completa também consta no contrato estruturado.
- Capturas nas duas resoluções: entrada, centro, dois desvios, borda/vazio, alvo, combate com quarenta inimigos/ataques/recursos, overview e tons de cinza. Fonte de apoio do desenho comparada à colisão; raízes de Reino Abissal e render de Domwieck comparados ao baseline atual.
- Medir seed7504, dt1/60, população40, trinta frames de aquecimento e seiscentos medidos, método/frame/simulação descritos. Para a generalização da navegação, repetir cenário comparável de Reino Abissal50 antes/depois na mesma máquina com baseline anterior ao código; comparar mediana/p95 e investigar >10%. Não comparar diretamente tempos de mapas/populações diferentes nem afirmar FPS por headless.
- Testes humanos e métricas de controle físico não são inventados. Não repetir checks inalterados sem motivo; generalização de terreno/Battle justifica regressão dirigida dos dois mapas aceitos. Preservar exigências existentes dos testes; falha não autoriza remover asserts ou ampliar escopo.

S-YGG-005 exige autorização própria para abrir o protótipo. Informar build provisória, percurso, objetivo, controles e feedback desejado antes da sessão. Usuário avalia caminhos, bordas, pressão e espaço de combate; arte final ausente fica explícita. Após seu relato, registrar aceite/ajustes, nunca inferi-los de janela aberta ou números técnicos.

## Aceitação, recuperação e reconciliação

Aceitação técnica: malha conectada renderizada sem suporte falso; três rotas úteis, corpos confinados, objetivo acessível e idempotente, cap40 respeitado, sem novas espécies/voo/chefe, perfil fonte preservado, nada de campanha alterado, treze caminhos ou menos, checks pertinentes aprovados e referências ADD válidas. Aceitação subjetiva somente no playtest autorizado.

Recuperação: interromper admissão da QA se contrato de cena/isolamento falhar. Reverter apenas os próprios treze caminhos após comparar baseline e mudanças concorrentes; remover unicamente arquivos novos desta entrega se necessários à recuperação e com destino verificado. Não resetar projeto, plano editorial ou saves. Não restaurar prototype_stages inteiro de baseline antiga se outro chat mudou o cadastro. Estado compartilhado atualizado por bloco próprio, releitura nas fronteiras; material canônico novo só mediante aceite concreto.

Zero gaps BLOCKING de desenho para apresentar S-YGG-003. A implementação continua não autorizada até aprovação deste contrato/escopo. Ausência de arte específica segue BLOCKING somente para acabamento final; é N/A para representação geométrica provisória proposta. Integração Dagruve/HQs/Shedaklah, identidade visual de Nidhogg, efeitos/áudio, Web, exportação e publicação DEFERRED fora do recorte. Roteiro do capítulo 2 mantém autoridade/revisão independente; não se promove sua arte por este contrato.
