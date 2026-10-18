---
id: SPEC-NOTTGARD-PATH-REVISION-20261017
revision: r1
status: DRAFT_AWAITING_DIRECTION_APPROVAL
origin: planned
implementation_preceded_spec: false
classification: PLAN_CHANGE_REQUEST
approval_mode: per-step
---

# Revisão dos caminhos de Yggdrasil e da primeira incursão abissal

## Evidência e intenção

Pedido do titular: Yggdrasil deve ter troncos mais finos, revertendo a preferência anterior por maior espessura; galhos com tamanhos e caminhos aleatórios, em maior quantidade. A primeira ida ao plano abissal deve ter mais caminhos e lembrar uma espiral subindo/descendo. Registrar este feedback não equivale a promover as soluções propostas abaixo a CANON.

Base local: data/root_navigation.json contém Yggdrasil r3 com sete nós, oito ligações, largura principal12 e lateral9; Reino Abissal r2 com nove nós, doze ligações e largura6. data/prototype_stages.json identifica reino_abissal como Primeira incursão, duração360s; Yggdrasil dura240s. A revisão r3 anterior foi aprovada e permanece histórica para a build então avaliada. A geometria atual é fixa; variantes de textura por semente não constituem geração de caminhos. Consumo da geometria: core/terrain_layout.gd; representação: ui/ground.gd.

## Escopo proposto DRAFT r1

Yggdrasil: troncos transitáveis mais finos, mantendo aparência de madeira resistente das HQ20 aprovadas. Faixa inicial para o estudo: principal7–9 unidades e ramificações4–6, comparadas às atuais12/9; não são medidas liberadas para implementação. Comprimentos, larguras, posições e bifurcações devem variar de maneira controlada por semente por partida. Meta inicial: pelo menos16 ligações úteis, com alternativas conectadas, evitando simples pontas extras que não ampliem o percurso. Áreas de junção podem ser mais largas para combate. O estudo deve provar que a área transitável não se funde em um piso contínuo nem cria estreitamentos incompatíveis com os corpos.

Reino Abissal, primeira incursão: espiral reconhecível como percurso dominante, com ramificações e retornos adicionais; meta inicial de pelo menos20 ligações úteis, a confirmar no desenho. A proposta é representar subida/descida visualmente na perspectiva atual. Não pressupõe física de altura, plataformas sobrepostas ou travessia de um caminho sobre outro. O contrato deve delimitar início, destino, voltas, atalhos e leitura da espiral para que as alternativas não apaguem sua forma. Aleatoriedade neste mapa não foi solicitada; manter a espiral desenhada como padrão proposto.

Preservar bordas travadas, vazio intransitável para criaturas terrestres, concordância entre piso visível e colisão, alvos acessíveis, identidade visual/HQs e recursos locais aprovados. Duração, ondas, limites de inimigos, progressão, IDs e saves ficam fora da revisão. Sem novas imagens, dependências ou serviços. Personagens/identidades: N/A para alteração de malha; manter arte existente, sem produzir ou revisar personagens. O contrato verificará se o kit visual cobre curvas e junções antes da aplicação.

## Gaps e decisões

RESOLVABLE no estudo: limites quantitativos, distribuição das sementes, algoritmo compatível com navegação/renderização existentes, orçamento exato de arquivos, alcance de impacto e registro de portagem/checks na origem. Mudanças comuns exigem portagem registrada e checks em ambos; esta proposta não autoriza escrever ou sincronizar a origem. O contrato deve definir rota autorizável para isso antes da execução correspondente.

Escolhas propostas para aprovação da direção: aleatoriedade de Yggdrasil por partida, reprodutível por semente; espiral abissal com indicação visual de altura. Se forem desejados desníveis reais, analisar impacto e revisar o contrato antes de implementar. Não há gap BLOCKING para apresentar esta proposta documental. O contrato executável ainda não está autorizado nem concluído. DEFERRED: campanha, outras visitas ao Abismo, balanceamento e produção de nova arte.

## Plano e checkpoints

Modo per-step reutilizado do fluxo de mapas, sem solicitar nova escolha. Cinco etapas ordenadas:

1. S-PATH-001: detalhar contrato/desenhos de ambos os mapas, medidas, algoritmo, sementes de referência, arquivos e testes. Entrada: direção r1 aprovada. Saída: contrato concreto para aprovação CP-PATH-001. Nenhuma implementação nesta etapa.
2. S-PATH-002: implementar somente Yggdrasil conforme contrato aprovado; checks isolados da alteração. CP-PATH-002 antes de iniciar.
3. S-PATH-003: implementar somente a primeira incursão abissal; checks isolados da alteração. CP-PATH-003 antes de iniciar.
4. S-PATH-004: validar integração, sementes, rotas, colisão, representação e regressões. CP-PATH-004 antes de iniciar.
5. S-PATH-005: abrir playtests isolados e registrar avaliação humana separada dos dois mapas. CP-PATH-005 antes de abrir; concluir somente com aceite humano.

Checkpoint atual CP-PATH-DIRECTION: aprovar direção r1 e autorizar somente o detalhamento S-PATH-001. Implementação aguarda contrato concreto e checkpoint próprio.

## Validação, aceitação e recuperação

Planejar testes de conectividade chegada/destino, repetição exata da mesma semente, diversidade entre sementes, limites de geração com fallback explícito, larguras compatíveis com herói/inimigos, confinamento nas bordas, spawn/objetivos sobre piso, caminhos alternativos úteis, correspondência raster/colisão e desempenho no limite de inimigos. Testes isolados de navegação/terreno/mapas/arte e compilação afetados; conjunto exato definido no contrato. Capturas de visão geral e combate devem mostrar galhos finos com vazio legível e espiral reconhecível. Validar com APPDATA/LOCALAPPDATA e perfis sintéticos, probe sem autoload antes de carregar o jogo; jamais save real.

Aceitação subjetiva depende de playtest: variedade, orientação, leitura da altura e espaço de combate. Métricas não declaram conforto aprovado. Antes de alterar runtime, registrar baseline próprio e conferir concorrência; recuperação somente dos trechos desta revisão, sem restaurar estado compartilhado antigo. Canon anterior não será sobrescrito: aprovação da revisão concreta produzirá decisão vinculada, mantendo histórico.

## Relação com planos existentes

Novo pedido classificado PLAN_CHANGE_REQUEST dos mapas concluídos, sem reabrir silenciosamente seus aceites antigos. Dagruve S-DAG-005 continua aguardando feedback; nenhuma aprovação inferida. HQ19/HQ20 e demais chats preservados. Antes de execução aprovada, registrar suspensão/cursor de retorno do fluxo Dagruve (CP-DAG-005, 4/5, abertura autorizada, aceite pendente). Nesta fase há apenas proposta documental, sem suspensão executiva nem alteração do jogo.
