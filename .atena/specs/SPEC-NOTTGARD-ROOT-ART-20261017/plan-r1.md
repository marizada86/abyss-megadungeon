---
id: SPEC-NOTTGARD-ROOT-ART-20261017
revision: r1
status: COMPLETE_OWNER_APPROVED_R1
origin: planned
implementation_preceded_spec: false
classification: PLAN_CHANGE_REQUEST
approval_mode: per-step
---

# Reino Abissal — plano de arte final das raízes

Pedido de 2026-10-17: “Atena, vamos planejar a arte final das raízes do Reino Abissal, usando as HQs como referência.” Autoriza elaboração documental. Este plano não autoriza geração, admissão de imagens, alterações do render ou novo playtest automaticamente. Integração responsável: Atena, sem delegação. Modo por etapa reutilizado do mesmo trabalho de mapas/raízes, sem nova escolha de modo. Direção nova abaixo é **DRAFT r1**, aguardando aprovação; decisões CANON anteriores permanecem autoritativas.

## Contrato preservado e escopo

A [navegação r2](../SPEC-NOTTGARD-MISSING-MAPS-20261017/root-navigation-r2.md) está concluída em 3/3 etapas, com [aceite humano das bordas, caminhos e espaço para combater](../../evidence/EVID-NOTTGARD-ROOT-PLAYTEST-ACCEPTANCE-20261017-r1.md). Arte deve vestir a mesma superfície de nove junções e doze ligações, largura seis, quatro vãos e arenas aprovadas. A aparência orgânica virá do entrelaçamento, textura, sombras e espessura visual, preservando a fronteira jogável. Não redesenhar os caminhos para imitar a perspectiva da HQ.

Recorte: faces superiores, junções, bordas e profundidade imediatamente abaixo das raízes do Reino Abissal, no PC Windows x86_64. Preservar os quatro props, posições, colisões, movimentação, ondas, objetivo 360 s + 3 s/raio 2, HUD e transições. Fora: Domwieck, outras camadas, novos personagens, tendas/braseiros/legião decorativa, novo portal, miniatura/menu, fundo panorâmico integral, efeitos meteorológicos, áudio, animação, Web e publicação. Acabamento dessas outras partes exige escopo próprio.

## Referências e autoridade visual

| Fonte local inspecionada | Autoridade | Uso e limite |
| --- | --- | --- |
| [HQ17 sequência r1](../../vault/canon/DEC-HQ17-SEQUENCE-APPROVAL-20261016-r1.md), Q3 v02 | CANON aceita | Principal: raízes colossais entrelaçadas sustentam chão e acampamento; vãos profundos, casca escura e luz violeta distante. Não importar tropas/tendas para o mapa |
| HQ17 Q4 v01, mesma sequência | CANON aceita | Conferir fibras, nós, casca e brilho em vista mais próxima. Não reproduzir personagem, cajado ou portal |
| HQ17 Q1 v01, mesma sequência | CANON aceita | Continuidade da descida e raízes vivas; não transportar paredes de pedra nem luz âmbar do corredor para todo o Reino Abissal |
| [HQ16 sequência r1](../../vault/canon/DEC-HQ16-SEQUENCE-APPROVAL-20261016-r1.md), Q5 v02 | CANON aceita | Continuidade das raízes de chegada; igreja/matéria mineral/névoa verde pertencem à cena de origem |
| [Todo solo é raiz](../../vault/canon/DEC-ABYSS-ROOT-GROUND-20261016-r1.md) | CANON r1 | Madeira/casca de raízes entrelaçadas; reflexos vermelhos não significam solo mineral ou lava |
| [Consolidação visual das HQs](../../vault/drafts/HQ-REVIEW-VISUAL-BIBLE-r1-20261015.md), revisão interna r2 | DRAFT, não promovida em bloco | Fantasia sombria, detalhe pixelado e bordas nítidas como orientação de continuidade; evitar transferir regras de enquadramento de HQ para câmera jogável |

Paths, hashes e conferência contra manifestos aprovados constam em `.atena/generated/root-art-20261017/reference-audit.json`. HQs são referências autorizadas localmente para o planejamento; não são texturas prontas nem licença para recorte/redistribuição externa. Não inferir do inventário nominal que já exista um kit de raízes final: a busca dirigida em tiles/stages/props não localizou pacote nominal próprio. Pilares abissais encontrados não substituem casca de raiz.

## Bíblia operacional proposta — DRAFT r1

**Identidade/contexto:** terreno da primeira incursão após HQ17. Identidade de personagem N/A: nenhum personagem novo será produzido. Sprites atuais poderão servir de escala na avaliação local, sem edição. Todo apoio é raiz; os vazios mostram profundidade, sem piso sugerido ao fundo.

**Forma e material:** várias raízes espessas torcidas se unem em feixes largos; fibras menores acompanham a direção de cada passagem. Nas junções, feixes se entrelaçam e se alargam naturalmente, cobrindo a leitura atual de discos geométricos. A área superior continua calma e contínua para combater. Sem círculos de tronco cortado, tábuas, estradas minerais, tabuleiro, grade cruzada regular, troncos altos no eixo ou buracos aparentes dentro da área caminhável.

**Paleta e luz:** base carvão e marrom frio, reflexos vinho muito esparsos, sombras com violeta escuro, pequenos pontos de luz fria nas fibras. Centro do caminho com contraste baixo; borda reconhecível pela mudança de plano e sombra, sem linha neon uniforme. Vermelho é reflexo de ambiente sobre madeira, não emissão de lava, brasa ou telegráfico de dano. Iluminação estática suave e consistente com os sprites existentes; relâmpagos das HQs não serão flashes de tela nesta entrega. Cor não pode ser a única indicação de borda.

**Câmera/escala:** manter Godot 2D isométrico 2:1, tile de referência 64×32 e filtro nearest já existente. Textura deve ser preparada para o chão e receber a projeção uma só vez; não usar perspectiva cinematográfica pré-assada da HQ em cima da projeção do jogo. Examinar no zoom normal em 1280×720 e 1920×1080, além de detalhe para costuras. Densidade deve funcionar no jogo; o tamanho do quadro da HQ não define escala dos veios.

**Bordas e profundidade:** superfície superior recortada pela malha autoritativa de `data/root_navigation.json`; nenhuma transparência/relevo dentro do caminho pode sugerir queda ou obstrução. Face lateral e raízes pendentes descem apenas para áreas de vazio, sempre abaixo do chão/personagens. Sombras e fundo não formam novas pontes nem escondem os quatro vãos. Ornamentos periféricos não criam nova área aparentemente caminhável fora da borda travada. Rever a correspondência visual/apoio nas junções; não usar alfa do PNG como nova colisão.

**Leitura de combate/acessibilidade:** silhuetas de herói, inimigos, projéteis, círculos de ataque e ritual devem prevalecer sobre a casca. Sem partículas constantes ou brilhos semelhantes a loot/alertas. Trama mais simples nas arenas E/C/W/L e no alvo G; variação maior nas faces laterais. Conferir também em escala de cinza e com muitos inimigos. Sem mudança de UI, input ou feedback mecânico.

## Método e entregáveis propostos

Recomendo material raster modular recortado pela geometria existente, combinado com sombreamento estático de borda. Preserva a técnica 2D atual e evita um bitmap gigante preso à câmera. Amostra artística primeiro; a aprovação de uma referência não aprova automaticamente a candidata gerada.

**S-RART-002 — amostra:** uma candidata de material, uma passagem de seis unidades ligada a uma junção e uma borda suspensa, apresentada nas duas direções principais das raízes na projeção isométrica existente, com comparativo de referência e escala de personagem. Câmera não será girada ou alterada. Entrega em `.atena/generated/root-art-20261017/candidates/`, com versão e recibo. Não gravar em assets nem editar gameplay. Ferramenta proposta para a candidata raster: imagegen, condicionada ao aceite deste briefing e autorização do checkpoint. Contexto de referência estritamente HQ17 Q3 v02 e Q4 v01; não enviar vault, saves, código, outras HQs ou dados do projeto. Reconfirmar as instruções da skill no início da produção. Nenhum provedor pago adicional ou instalação é proposto. Até duas revisões da candidata mediante feedback; mudança de direção volta ao briefing, sem geração indefinida.

**S-RART-003 — conjunto:** após aceite individual da amostra, produzir no máximo quatro PNGs: material superior (atlas 1024×1024, quatro variantes 512×512), junções (atlas 1024×1024, quatro motivos 512×512), face lateral (1024×512, quatro faixas 1024×128) e profundidade discreta (1024×1024). São dimensões de destino propostas, não garantia de tamanho nativo do gerador. Preparação deve respeitar a ferramenta aplicável e validar bordas/transparência sem esticar ou borrar arte. Superiores sem sombras externas duplicadas; laterais/profundidade com alfa limpo. Memória bruta dos quatro PNGs decodificados em RGBA8: aproximadamente 14 MiB por cópia, sem afirmar custo total da GPU/processo. Sem animação ou ampliação ilimitada de resolução. Cada arquivo versionado, hash, finalidade, origem e aceite antes da admissão.

**S-RART-004 — integração:** somente após aprovação do conjunto. Proposta de até oito caminhos de jogo/teste: quatro imagens novas em `assets/tiles/reino_abissal_roots_r1/`, `data/root_art.json` (manifesto/UV/parâmetros), `ui/ground.gd` (somente ramo Reino Abissal), `ui/shaders/abyss_roots.gdshader` (se necessário ao recorte/sombra) e `tests/test_root_art.gd`. Os quatro nomes de imagem serão `surface.png`, `junctions.png`, `sides.png`, `depth.png`. Metadados `.import` são derivados. Necessidade de editar terreno, Battle, Hero, cenas ou ampliar orçamento exige revisão antes da edição. Render superior continua derivado da rede aprovada; composição local de amostra não vira arquitetura nova por efeito da geração.

Não há especialista delegado ou ferramenta de terceiros ativada neste plano. Necessidade visual demonstrada: produzir casca/entrelaçamento consistente em várias orientações; insumos, saída e integração delimitados acima. Atena responde pela revisão e integração. Se futura skill exigir fluxo adicional, conciliá-lo no checkpoint pertinente; não instalar nem delegar automaticamente.

## Aceitação, validação e recuperação

- O dono reconhece continuidade com as raízes da HQ17 e aprova material, escala, junções e borda na amostra; não apenas beleza em ampliação.
- Nove junções, doze ligações, largura seis, quatro vãos, reservas e quatro props mantidos. Hashes de navegação/colisão antes/depois idênticos. Nenhum novo bloqueio ou apoio decorativo aparente no vazio.
- Variantes sem repetição dominante ou costuras visíveis na escala normal; alfa das bordas sem halo claro; sem sobreposição que escureça junções em excesso, rotação de luz inconsistente ou dupla projeção isométrica.
- Capturas de chegada, trecho estreito, quatro tipos de junção/borda e ritual nas duas resoluções, com teste de combate e recursos sobrepostos. Candidata ou captura é evidência visual, não aprovação humana automática.
- Na integração, executar `test_root_art`, `test_root_navigation`, `test_map_objectives`, `test_level_design`, `test_terrain`, `test_chapter_flow` e `test_scripts_compile`; manter evidências anteriores quando ainda válidas. Regressão gráfica dirigida de Domwieck. Perfis e APPDATA/LOCALAPPDATA sintéticos com sonda antes de Godot; nunca save real.
- Medir o cenário de 50 inimigos com seed/dt equivalentes à referência técnica, incluindo comparação visual ativada/desativada na mesma máquina. Proposta: investigar aumento sustentado acima de 10% na mediana/p95 ou nova pausa perceptível; não prometer 60 FPS com base em medição headless antiga. Orçamento e técnica devem ser revistos se o conjunto exigir expansão relevante.
- Preservar fontes, candidatas e manifests; admissão por versão nova, sem sobrescrever HQs ou arte anterior. Se houver desalinhamento, regressão de borda ou leitura ruim, manter o protótipo aprovado como fallback. Recuperar somente os arquivos desta etapa com baseline recente, sem restaurar estado de outros chats.

## Gaps e plano por etapa

| Ponto | Estado e tratamento |
| --- | --- |
| Referência, identidade e contexto | RESOLVED para planejamento: imagens aprovadas inspecionadas; personagem N/A |
| Direção nova de material/escala e método | Proposta concreta DRAFT r1 acima; depende de aceite CP-RART-002, não de escolha não formulada |
| Correspondência da arte com borda aceita | RESOLVABLE pela máscara autoritativa e amostra; prova na integração |
| Texturas finais/qualidade do gerador | RESOLVABLE por candidata e aceite; não declarar qualidade ou continuidade já alcançadas |
| Uso de referências em geração | Não autorizado neste turno; CP-RART-002 deve autorizar explicitamente imagegen com somente HQ17 Q3/Q4 |
| Memória/desempenho | Orçamento proposto e comparação delimitada; medições futuras |
| Arte de outros ambientes, tendas, efeitos, Web | DEFERRED, fora deste plano |

Nenhum gap BLOCKING para entregar o plano. Produção continua não executável até o aceite do escopo concreto e das duas referências no checkpoint; isso é aprovação pendente, não fonte visual ausente. Antes de executar cada etapa, reler estado compartilhado e hashes; não retomar cursores históricos de campanha/HQs por snapshot.

| Etapa | Entrada → saída | Checkpoint |
| --- | --- | --- |
| S-RART-001 — planejamento | Referências CANON + navegação aceita → briefing/bíblia DRAFT e plano delimitado | Concluída documentalmente: **1/5** |
| S-RART-002 — amostra visual | R1 aceita + autorização das referências → candidata versionada e avaliação na escala do jogo | **CP-RART-002 pendente**; aceite individual antes de seguir |
| S-RART-003 — produção do conjunto | Amostra aprovada + autorização → até quatro PNGs e recibos; revisão do conjunto | CP-RART-003 próprio |
| S-RART-004 — integração e checks | Conjunto aprovado + autorização → render local e evidência técnica isolada | CP-RART-004 próprio |
| S-RART-005 — playtest visual e aceite | Build verificada + autorização → avaliação humana e reconciliação final | CP-RART-005 próprio |

Próximo objetivo concreto: autorizar S-RART-002 para produzir a amostra DRAFT com imagegen usando somente HQ17 Q3/Q4. Saída esperada: comparação de material, passagem, junção e borda em escala normal; checks: fidelidade, iluminação, continuidade de fibras e leitura de combate. Após sua revisão, novo checkpoint para produzir o conjunto completo. Nenhum código, bitmap novo ou teste de gameplay executado na S-RART-001.

## Execução S-RART-002 — 2026-10-17

Direção r1 aprovada explicitamente; autorização limitada à amostra via imagegen com HQ17 Q3/Q4. V01 preservada e v02 entregue para avaliação, conforme [evidência](../../evidence/EVID-NOTTGARD-ROOT-ART-SAMPLE-20261017-r1.md). As menções anteriores a produção não autorizada descrevem o checkpoint original: o aceite recebido autoriza S-RART-002, sem estendê-lo ao conjunto ou integração. Amostra continua DRAFT, aceite do dono pendente em CP-RART-002-ACCEPTANCE. Etapa atual 2/5, uma etapa encerrada e entrega artística da segunda pronta; não antecipar aceite ou S-RART-003.

## Aceite da amostra — 2026-10-17

O dono respondeu “aprovado” ao aceite explícito de material, entrelaçamento e bordas da v02. S-RART-002 encerrada: **2/5 etapas**; [registro do aceite](../../evidence/EVID-NOTTGARD-ROOT-ART-SAMPLE-ACCEPTANCE-20261017-r1.md). Referências anteriores a aceite pendente são históricas. Próximo checkpoint CP-RART-003: autorização para produzir até quatro PNGs do conjunto conforme escopo r1, sem integração automática.

## Entrega S-RART-003 — 2026-10-17

Produção autorizada explicitamente após aceite da amostra. Quatro PNGs gerados via imagegen com somente HQ17 Q3/Q4; [conjunto para revisão](../../generated/root-art-20261017/kit-r1/review.md) e [evidência](../../evidence/EVID-NOTTGARD-ROOT-ART-KIT-20261017-r1.md). Etapa atual 3/5, duas encerradas; entrega da terceira pronta, aceite individual pendente em CP-RART-003-ACCEPTANCE. Nenhuma admissão ou integração. Dimensões nativas preservadas (1254×1254 para três peças; 1774×887 para laterais); destino 1024 e limites UV deverão ser conferidos na importação/integração autorizada, sem ampliar silenciosamente o custo em runtime. Alfa real verificado em laterais/profundidade; emendas, halo no fundo final e leitura sob combate exigem checks no render.

## Aceite do conjunto — 2026-10-17

O dono respondeu “aprovado” ao aceite explícito das quatro peças r1. Hashes revalidados e aceite visual registrado; [evidência](../../evidence/EVID-NOTTGARD-ROOT-ART-KIT-ACCEPTANCE-20261017-r1.md). S-RART-003 encerrada: **3/5 etapas**. Referências anteriores a aceite pendente são históricas. Próximo checkpoint CP-RART-004: autorização para importar/admitir o conjunto aprovado, integrar no render e executar checks isolados no escopo previsto; S-RART-005 permanece posterior.

## Integração S-RART-004 — 2026-10-17

Autorizada explicitamente e concluída em oito caminhos de jogo/teste. Imagens aceitas preservadas por hash, importadas em 1024×1024/1024×512. Superfície renderizada deriva da malha aceita, com laterais/profundidade restritas ao vazio abaixo; desenho provisório disponível como fallback. Sete conjuntos de testes passaram, auditoria de máscara com 8157 probes sem divergência e captura dos dois mapas nas duas resoluções concluídas; [evidência técnica](../../evidence/EVID-NOTTGARD-ROOT-ART-INTEGRATION-20261017-r1.md). **4/5 etapas** encerradas; CP-RART-005 pendente de autorização para playtest visual humano e aceite final. Menções anteriores à integração não autorizada/pendente são históricas; nenhum aceite visual do dono sobre a aplicação foi inferido.


## S-RART-005 — playtest visual aberto em 2026-10-17

Autorizado pelo usuário: “autorizado”. Status ACTIVE_AWAITING_OWNER_FEEDBACK; quatro de cinco etapas concluídas. Reino Abissal aberto em janela responsiva com perfil sintético e isolamento confirmado, sem erros de carregamento. Evidência: .atena/evidence/EVID-NOTTGARD-ROOT-ART-PLAYTEST-LAUNCH-20261017-r1.md. Aceite visual final pendente do usuário.


## Conclusão S-RART-005 — 2026-10-17

O usuário informou que testou e aprovou o visual integrado das raízes, autorizando o registro e fechamento. [Resultado do playtest](../../evidence/EVID-NOTTGARD-ROOT-ART-PLAYTEST-ACCEPTANCE-20261017-r1.md) e [aceite CANON delimitado](../../vault/canon/ASSET-APPROVAL-ROOT-ART-INTEGRATED-R1-20261017-r1.md). **5/5 etapas concluídas; zero restantes; CP-RART-005 encerrado.** Aceite visual humano recebido; hashes dos oito arquivos de jogo/teste idênticos à validação técnica. Sete testes e auditorias anteriores reutilizados, sem alteração de jogo neste fechamento. Referências anteriores a pendências de autorização, produção, integração ou aceite são históricas e estão resolvidas pelos registros de execução e aceite deste plano. Escopos DEFERRED permanecem fora deste plano; nenhuma nova etapa iniciada.
