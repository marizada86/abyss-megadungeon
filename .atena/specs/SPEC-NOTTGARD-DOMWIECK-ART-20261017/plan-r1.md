---
id: SPEC-NOTTGARD-DOMWIECK-ART-20261017
revision: r1
status: COMPLETE_OWNER_APPROVED_R1
origin: planned
implementation_preceded_spec: false
classification: PLAN_CHANGE_REQUEST
approval_mode: per-step
---

# Domwieck — plano de arte final r1

Pedido: “Atena, vamos planejar a arte final de Domwieck, usando as HQs como referência.” Autoriza planejamento documental. Modo por etapa reutilizado do fluxo já escolhido; nenhuma nova autorização de produção, admissão ou implementação inferida. Plano das raízes concluído em 5/5 e preservado. Integração responsável: Atena, sem delegação.

## Escopo e autoridade

Acabar o cenário jogável de Domwieck no PC Windows x86_64: calçamento, seis conjuntos arquitetônicos existentes, vegetação do jardim circular, flores vermelhas, Ailalore intacta, feixe e representação ambiental da Tarn. Manter câmera isométrica 2:1, escala 64×32, mapa 60×60, seis props bloqueantes existentes, rotas, reservas e objetivo 420 s + presença de 3 s/raio 2. Preservar ondas, cap 54, inimigos, combate, HUD, saves, acesso e sequência da campanha integrada. O resultado deve substituir os volumes provisórios, sem redesenhar a planta.

Autoridades: [dossiê aceito](../../vault/canon/DEC-NOTTGARD-MAPS-DOSSIER-20261017-r1.md), [ambientes e planta r1](../SPEC-NOTTGARD-MISSING-MAPS-20261017/environments-resources-r1.md), [contrato do capítulo](../SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/chapter1-maps-transitions-r1.md) e [capítulo integrado aceito](../../vault/canon/DEC-NOTTGARD-CHAPTER1-ACCEPTANCE-20261017-r1.md). A restrição QA-only dos primeiros protótipos é histórica; não restaurá-la sobre a campanha atual.

| Referência inspecionada | Autoridade e uso proposto |
| --- | --- |
| HQ18 Q3 v01 | [Sequência CANON r1](../../vault/canon/DEC-HQ18-SEQUENCE-APPROVAL-20261017-r1.md): cidade de pedra clara, arcos ogivais, pináculos, telhados frios, vegetação e pavimento sob Tarn azul; fogo âmbar da invasão |
| HQ03 Q1 v03 | [Sequência CANON r1](../../vault/canon/DEC-HQ03-SEQUENCE-APPROVAL-20261017-r1.md): floresta circular, jardim vermelho, estrela caída central, feixe reto até o domo |
| HQ03 Q2 v03 | Mesma sequência e [correção de escala/cor](../../vault/canon/DEC-AILALORE-STAR-SCALE-COLOR-20261017-r1.md): massa cristalina grande, azul mais claro. Usar somente a identidade material de Ailalore; excluir Adam, ataque, fissuras/colapso da Tarn e alteração atmosférica do acontecimento |
| Direção do jardim | [CANON r1](../../vault/canon/DEC-AILALORE-GARDEN-VISUAL-20261017-r1.md): flores vermelhas, floresta circular e fonte azul da barreira |

Paths e SHA-256 conferidos contra manifestos aprovados em [auditoria](../../generated/domwieck-art-20261017/reference-audit-r1.json). Nenhum quadro posterior da HQ03 serve como estado ambiental do mapa: Véu Vivo, raízes protetoras e estrela apagada pertencem ao encerramento narrativo. A parte abissal/portal da HQ18 Q3 não é cenário a importar para Domwieck.

Identidade de personagens N/A: não haverá novos retratos, NPCs ou tropas desenhadas no chão. Ailalore é entidade nomeada, não N/A: respeitar referências acima. Arquitetura é identidade ambiental élfica existente, sem nomear novos edifícios ou inventar lore. A bíblia geral de HQs continua DRAFT; esta proposta não a promove em bloco.

## Bíblia operacional — DRAFT r1

**Cidade:** piso cinza azulado, pedra clara envelhecida nos edifícios, arcos finos, relevos vegetais discretos, coberturas azul escuras e silhuetas verticais. A escala jogável pede fachadas reconhecíveis e pouco ruído. Usar a HQ como referência de materiais e formas, sem copiar perspectiva cinematográfica ou escadarias que sugiram desnível obrigatório. Piso regular, com desgaste e fragmentos rasos; sem buracos, degraus, novas paredes ou obstáculos aparentes atravessáveis no centro das rotas.

**Jardim:** vegetação verde escura, flores vermelhas em massas legíveis e solo menos contrastado que ataques. Conservar centro (30,7), flores no disco de raio 4 e floresta circular entre raios 4 e 7. O alvo permanece em (30,15), antes do jardim; nunca é a estrela. Ailalore deve parecer uma estrela caída cristalina irregular, com múltiplas pontas, em vez do ícone geométrico de cinco pontas atual. Azul-clara, núcleo claro limitado e tamanho reconhecível na câmera normal. A amostra comparará essa escala ao herói sem fixar medida como lore.

**Luz e invasão:** Tarn azul translúcida ativa, feixe vertical contínuo ligado à estrela, brilho contido; nada de filtro azul cobrindo ataques ou HUD. Incêndios âmbar localizados nos conjuntos já queimando, sem dano, expansão, fumaça opaca ou animação nova. Não aumentar a presença de fogo sobre o jardim. Sem verde de colapso, Véu Vivo ou chuva de partículas. Janelas acesas ajudam a distinguir volumes; reflexos no chão são sutis.

**Composição e leitura:** conservar seis âncoras arquitetônicas (7,20), (23,22), (37,38), (53,40), (7,39), (53,21). Entrada (30,45), raio 6; praça (30,33), raio 6; alvo (30,15), raio 4, desobstruídos. Eixo x=27..33/y=11..51, laterais x=13..17 e 43..47/y=15..45, conexões y=13..17 e 43..47/x=15..45 preservados. Comparar a projeção dos telhados/copas com o herói, não só a base em chão. Reduzir footprint/altura visual e abrir a composição onde necessário, mantendo a distribuição circular. Não criar colisão para corrigir oclusão. Edifícios e árvores altos precisam respeitar a ordenação por base; sombra e base no chão, copa/fachada na camada ordenada. Fallback provisório deve permanecer recuperável.

HUD e sinais de objetivo conservam forma, texto e contraste próprios; o azul decorativo não substitui o círculo de presença. Sem nova interface, áudio, animação de personagens ou mecânica. Miniatura/menu, panorama integral, novos inimigos, civis, Adam jogável, outros mapas, Web e publicação ficam fora do escopo.

## Produção proposta e limites

S-DART-002: produzir com imagegen **duas amostras DRAFT**, rua/praça e jardim/santuário, cada uma com vista isométrica e indicação de escala comparável ao jogo, sem desenhar novos personagens identificáveis. Usar exclusivamente HQ18 Q3 v01, HQ03 Q1 v03 e HQ03 Q2 v03, cada qual limitado ao papel acima. Saída até dois PNGs de revisão, sem admissão no runtime. Revisar material, arquitetura, Ailalore, continuidade e leitura em tamanho normal antes do conjunto. Geração só após aprovação explícita da direção r1 e uso dessas três referências.

S-DART-003: após aceite das duas amostras, até **seis PNGs** versionados: `ground.png` (atlas de calçamento), `architecture.png` (módulos de fachadas/telhados), `vegetation.png` (árvores/copas), `garden.png` (solo/flores), `ailalore.png` (estrela íntegra) e `ambient.png` (fogo/glow/motivos da Tarn). Sprites e overlays com alfa real; piso opaco. Feixe e arco da Tarn podem ser compostos pelo render com formas simples, sem exigir um panorama gigante. Motivos de atlas separados por margens, sem sombra duplicada ou perspectiva aplicada duas vezes.

Destino inicial de importação: até 1024×1024 por PNG, até 24 MiB em RGBA8 por cópia para seis imagens sem mipmaps; não representa memória total do jogo/GPU. Dimensões nativas do gerador preservadas; tamanho final, recorte, pivôs e UV definidos no manifesto após inspeção. Não afirmar que um módulo específico cabe antes da produção; se detalhe ou empacotamento exigir mais imagens/resolução, apresentar revisão concreta antes de expandir. Registrar origem, referência, finalidade, hashes e aceite individual/conjunto. Recursos existentes continuam como props funcionais; casa de Dagruve, flor branca e cristal vermelho não equivalem aos assets finais.

S-DART-004: integração proposta em **até 12 caminhos de jogo/teste**: os seis PNGs sob `assets/tiles/domwieck_r1/`; `data/domwieck_art.json`; `ui/ground.gd` somente ramo Domwieck; novo `ui/domwieck_art.gd`; `ui/stages/domwieck.tscn`; opcional `ui/shaders/domwieck_art.gdshader`; novo `tests/test_domwieck_art.gd`. Metadados `.import`/`.uid` são derivados. Controlador local de cenário instancia somente nós visuais no Sorted existente; sem nova arquitetura global. Técnicas exatas condicionadas às amostras e à confirmação do escopo no checkpoint de integração. Não editar terreno, props, batalha, catálogo ou campanha; necessidade fora da lista exige revisão prévia.

Sem especialistas delegados, instalação ou serviço pago adicional. A necessidade de geração é material/arquitetura/vegetação próprios inexistentes no protótipo; insumos e saída delimitados acima. Atena integra e revisa os resultados.

## Validação, aceite e recuperação

- Revalidar hashes no início da implementação e preservar mudanças de outros chats. Comparar navegação, dados de combate/objetivo, props e fluxo da campanha antes/depois; nenhuma alteração por efeito da arte.
- Conferir arquivos, alfa, limites UV, importação, pivôs e ausência de placeholders acidentais. Capturas em 1280×720 e 1920×1080: chegada, praça, duas ruas laterais, santuário/jardim e combate com até 54 inimigos sintéticos e recursos sobrepostos. Conferir copas/fachadas à frente e atrás do herói, seta/alvo, feixe/Tarn, ausência de halos e repetição dominante. Inspecionar também em tons de cinza.
- Executar `test_domwieck_art`, `test_map_objectives`, `test_level_design`, `test_terrain`, `test_root_art`, `test_root_navigation`, `test_chapter_flow` e `test_scripts_compile`. Teste de arte deve verificar invariantes de dados, escopo Domwieck, caminhos/recursos, fallback e composição visual; não apenas espelhar implementação.
- Regressão visual dirigida de Reino Abissal com sua arte aprovada, sem interferência de material. Comparação A/B de Domwieck com arte provisória/final no mesmo cenário, seed/dt e população 54. Investigar aumento sustentado acima de 10% na mediana/p95 ou novas pausas. Informar método e limites; não prometer FPS por headless ou tempo de simulação.
- Godot somente com APPDATA, LOCALAPPDATA e perfil sintéticos; sonda sem autoload confirma isolamento antes de carregar o projeto. Reutilizar launchers existentes. Nunca save real. Testes anteriores ainda válidos podem ser reutilizados se arquivos/aceitação não mudaram.
- Playtest humano próprio: usuário avalia continuidade com HQs, leitura das ruas/jardim/objetivo, escala da estrela, oclusão e conforto no combate. Atena verifica funcionamento; capturas e métricas não substituem aceite subjetivo.
- Preservar fontes e candidatas. Recuperação por fallback e reversão apenas dos próprios arquivos comparados ao baseline recente; não restaurar snapshot antigo do estado compartilhado. Sem commits, sincronização Web ou publicação.

## Gaps

| Ponto | Tratamento |
| --- | --- |
| Identidade, época e fontes | RESOLVED: CANON pertinente e três imagens reinspecionadas; hashes auditados |
| Paleta/escala/composição final | RESOLVABLE nas duas amostras e aceite explícito r1; proposta concreta acima |
| Empacotamento/alfa/oclusão | RESOLVABLE por produção delimitada, captura e fallback; sem expansão automática |
| Desempenho | RESOLVABLE com comparação A/B isolada na integração |
| Outros mapas, panorama/menu, efeitos animados, áudio, Web | DEFERRED, fora deste plano |

Zero gaps BLOCKING para o planejamento e a proposta de amostras. Aprovação pendente é checkpoint de execução, não falta de referência. Bíblia operacional continua DRAFT até aceite explícito desta revisão.

## Etapas e checkpoints

| Etapa | Entrada → saída | Checkpoint |
| --- | --- | --- |
| S-DART-001 | CANON, protótipo e HQs → auditoria e plano/bíblia DRAFT r1 | Concluída documentalmente: 1/5 |
| S-DART-002 | Direção r1 e três referências autorizadas → duas amostras rua/jardim | CP-DART-002; aceite das amostras antes de seguir |
| S-DART-003 | Amostras aceitas + autorização → até seis PNGs/manifesto | CP-DART-003; aceite do conjunto antes de integração |
| S-DART-004 | Conjunto aceito + autorização → integração em até 12 caminhos e checks isolados | CP-DART-004 |
| S-DART-005 | Build validada + autorização → playtest humano e aceite final | CP-DART-005 |

Próximo objetivo: aprovar a direção r1 e autorizar somente S-DART-002, imagegen com HQ18 Q3 v01, HQ03 Q1 v03 e HQ03 Q2 v03, duas amostras sem integração. Produção do conjunto, aplicação e playtest mantêm checkpoints próprios. Nenhuma imagem nova ou código de jogo produzido neste planejamento.


## Execução S-DART-002 — 2026-10-17

Direção r1 e uso delimitado das três HQs aprovados explicitamente. [Direção CANON](../../vault/canon/DEC-DOMWIECK-ART-DIRECTION-20261017-r1.md). Duas amostras DRAFT entregues: rua/praça v01 e jardim/santuário v02, após correção de enquadramento da v01 preservada. [Revisão](../../generated/domwieck-art-20261017/sample-review-r1.md), [evidência](../../evidence/EVID-NOTTGARD-DOMWIECK-ART-SAMPLES-20261017-r1.md). Etapa atual 2/5, uma encerrada; entrega pronta, aceite pendente CP-DART-002-ACCEPTANCE. Menções anteriores a direção/produção não autorizadas são históricas e foram resolvidas somente para este recorte. Conjunto, integração e playtest mantêm checkpoints próprios.


## Aceite das amostras — 2026-10-17

O usuário respondeu “aprovado” ao aceite explícito de rua/praça v01 e jardim/santuário v02 como referência para o conjunto final. [Evidência](../../evidence/EVID-NOTTGARD-DOMWIECK-ART-SAMPLES-ACCEPTANCE-20261017-r1.md). Hashes revalidados. S-DART-002 encerrada: **2/5 etapas, três restantes**. Registros anteriores de aceite pendente são históricos. CP-DART-003 aguarda autorização para produção de até seis PNGs; não houve produção nem integração adicional por efeito deste aceite.


## Entrega S-DART-003 — 2026-10-17

Produção explicitamente autorizada: seis PNGs gerados, copiados sem edição e conferidos por hash/alfa. [Conjunto para revisão](../../generated/domwieck-art-20261017/kit-r1/review.md) e [evidência](../../evidence/EVID-NOTTGARD-DOMWIECK-ART-KIT-20261017-r1.md). Duas de cinco etapas encerradas, terceira com entrega pronta e aceite pendente em CP-DART-003-ACCEPTANCE. Observações e exclusão da variante de entulho do jardim documentadas no manifesto; dimensões nativas preservadas e UV/pivôs/importação condicionados à validação da integração. Nenhuma admissão no jogo. Menções anteriores à produção não autorizada representam checkpoints históricos.


## Aceite do conjunto — 2026-10-17

O usuário respondeu “aprovado” ao conjunto r1 de seis PNGs com limites de uso apresentados. [Evidência](../../evidence/EVID-NOTTGARD-DOMWIECK-ART-KIT-ACCEPTANCE-20261017-r1.md). Seis hashes reconferidos. S-DART-003 concluída: **3/5 etapas, duas restantes**. Pendências anteriores de aceite do conjunto são históricas. CP-DART-004 aguarda autorização para admissão/integração e testes isolados, em até 12 caminhos já propostos. Nenhuma implementação autorizada por efeito deste aceite visual.


## Integração S-DART-004 — 2026-10-17

Autorização explícita recebida e integração concluída em 11 caminhos, preservando bytes dos seis PNGs aprovados e dados de navegação/combate/campanha. Oito testes passaram; capturas nas duas resoluções, transparência, ameaças sintéticas, regressão pixel a pixel de Reino Abissal e A/B com 54 inimigos verificados. [Evidência técnica](../../evidence/EVID-NOTTGARD-DOMWIECK-ART-INTEGRATION-20261017-r1.md). **4/5 etapas concluídas; uma restante.** CP-DART-005 aguarda autorização para playtest visual isolado e posterior aceite humano. Pendências de integração anteriores são históricas; nenhum aceite visual do jogo aplicado inferido.


## S-DART-005 — playtest visual aberto em 2026-10-17

Abertura explicitamente autorizada. Build conferida por hash; janela de Domwieck respondendo com perfil sintético e isolamento confirmado. [Evidência](../../evidence/EVID-NOTTGARD-DOMWIECK-ART-PLAYTEST-LAUNCH-20261017-r1.md). Etapa 5/5 ativa, quatro concluídas; aceite visual humano pendente. Nenhuma conclusão subjetiva inferida da abertura técnica.


## Conclusão S-DART-005 — 2026-10-17

O usuário respondeu “aprovado” ao visual integrado após abertura do playtest isolado. [Resultado](../../evidence/EVID-NOTTGARD-DOMWIECK-ART-PLAYTEST-ACCEPTANCE-20261017-r1.md) e [aceite CANON](../../vault/canon/ASSET-APPROVAL-DOMWIECK-ART-INTEGRATED-R1-20261017-r1.md). **5/5 etapas concluídas, zero restantes, CP-DART-005 encerrado.** Onze hashes de jogo/teste idênticos à build validada; verificações anteriores reutilizadas. Pendências anteriores de autorização/execução/aceite do plano são históricas e resolvidas pelos registros subsequentes. Escopos DEFERRED permanecem fora deste plano. Nenhuma nova etapa iniciada.
