---
id: SPEC-NOTTGARD-YGGDRASIL-MAP-20261017
revision: r1
status: COMPLETE_OWNER_APPROVED_R3
origin: planned
implementation_preceded_spec: false
classification: PLAN_CHANGE_REQUEST
approval_mode: per-step
platform: windows-x86_64
---

# Raiz de Yggdrasil — ambiente e plano de protótipo r1

Autorização de planejamento: “VAMOS LÁ”, após proposta explícita de reconciliar o plano antigo de mapas e preparar ambiente, referências e recursos da Raiz de Yggdrasil, sem produção. Modo por etapa reutilizado. Responsável: Atena, sem delegação. Esta entrega não altera jogo, lore ou referências externas. A revisão editorial concorrente do capítulo 2 conserva seus próprios checkpoints.

## Autoridade e posição narrativa

| Fonte | Autoridade e limite |
| --- | --- |
| [HQ19 r1](../../vault/canon/HQ19-SCREENPLAY-APPROVED-20261017-r1.md) | CANON textual. Q1–4 antes de Dagruve, Q5–12 depois; envio de Leoric/Korrak separado da prisão/interrogatório e envio de Maelor. Thalion vivo; Aila permanece com ele |
| [HQ20 r1](../../vault/canon/HQ20-SCREENPLAY-APPROVED-20261017-r1.md) | CANON textual, sete quadros depois da travessia jogável. Raiz colossal/tronco aparentemente infinito, Marciela guia Leoric/Korrak, Maelor isolado, Nidhogg erra e permanece vivo, passagem para Shedaklah |
| [HQ21 r1](../../vault/canon/HQ21-SCREENPLAY-APPROVED-20261017-r1.md) | CANON textual. Outra trajetória pelo laboratório de Zynara; reunião em Shedaklah sem Aila; não sincronizar chegadas nem obrigar grupo completo neste mapa |
| [Chegadas ao Abismo](../../vault/canon/DEC-NOTTGARD-ABYSS-ARRIVALS-20261015-r1.md) | Correção direta CANON prevalece sobre relato divergente de mordida. Sem ferimento de mordida, morte de Nidhogg ou destino novo de Aila |
| Ficha local Yggdrasil | Fonte do vault consultada em leitura: D:/dev/nottgard/vault/04_Locais/Yggdrasil.md. Árvore interplanar, raiz conduz ao tronco aparentemente infinito; não foi editada/copied em bloco |
| Proposta ampla de campanha | [DRAFT r1](../SPEC-NOTTGARD-CAMPAIGN-FLOW-20261016/spec.md), útil como hipótese de rota, não contrato aprovado do capítulo 2 |

Não foram localizados HQ20/painéis aprovados de Yggdrasil entre assets/hq e o diretório de produções ADD consultados; o catálogo atual também não contém hqn_20. Existe roteiro aceito, não aparência final aceita. HQ17 e o kit de Reino Abissal representam outro local; o Véu Vivo é a transformação de Helion, não Yggdrasil. Não apresentar essas imagens como prova de identidade de Yggdrasil nem enviá-las automaticamente ao gerador.

Contexto proposto: após o trecho Q5–12 da HQ19, atravessar a raiz; ao concluir, apresentar HQ20 no fluxo futuro. Integração com HQ21/Shedaklah pertence ao contrato de campanha. O protótipo será isolado, sem mexer em Dagruve ou no capítulo 1. A percepção de anos não vira cronômetro literal.

## Ambiente e bíblia inicial — DRAFT r1

**Ideia:** uma raiz colossal funciona como caminho entre planos. O chão é madeira/casca contínua; ao fundo, um trecho do tronco descomunal comunica escala. Não representar floresta urbana, jardim de Ailalore, acampamento da legião, raiz morta ou árvore criada por Helion.

**Proposta visual para aprovação futura:** casca castanha fria com sulcos largos, nós e feixes longitudinais; fundo profundo azul-violeta apagado, sem definir nova cosmologia por cor. Tronco distante como silhueta vertical, separado do piso jogável. Contraste do chão menor que herói/ataques, profundidade reconhecível sem névoa opaca. Paleta e formas são hipóteses de produção, não fatos extraídos das HQs ausentes.

**Câmera:** manter Godot e projeção 2:1/64×32, escala e controles atuais. Corpos terrestres precisam de superfície contínua. Proposta de bordas travadas e nenhum dano/queda, sujeita a aceite específico deste mapa; a decisão anterior de Reino Abissal não é estendida automaticamente. Sem salto, plataforma móvel ou nova habilidade.

**Identidades:** terreno genérico não exige personagem novo; Yggdrasil é identidade ambiental nomeada, com texto CANON e aparência ainda pendente. Nidhogg, Marciela, Maelor, Leoric e Korrak têm presença narrativa, mas não serão sprites/NPCs novos deste protótipo. Nidhogg fica na HQ20; nenhuma mecânica de mordida, perseguição por criatura, vida de chefe ou modelo improvisado. Seleção de herói do jogador não é reescrita para simular elenco simultâneo. Animação e áudio novos N/A nesta entrega documental.

## Planta funcional proposta — DRAFT

Mapa de chão 60×60, sem promover a dimensão a lore. Entrada (30,48), disco livre raio 6; junção central (30,32), raio 7; acesso de saída (30,12), raio 4, com reconhecimento de objetivo raio 2. Caminho central largo de oito unidades de (30,48) a (30,12). Duas alternativas de seis unidades: centro → (16,28) → (18,18) → saída; centro → (44,28) → (42,18) → saída. Junções dos desvios com discos raio 5. Margens do piso recortadas pela mesma geometria que conterá os corpos. Esses valores serão demonstrados/validados no contrato, não copiados para runtime agora.

Proposta busca percurso principal legível e desvios para circulação durante combate. Não copiar a malha de nove nós/doze ligações de Reino Abissal; aquela era outro mapa. Entrada e objetivo sem props sólidos; obstáculos inicialmente zero. Nós/sulcos são relevo visual, sem barreira aparente atravessável. Tronco de fundo e raízes pendentes não podem parecer atalhos ou cobrir personagens.

## Mecânica candidata e recursos

Recomendação para o contrato S-YGG-002: sobrevivência/travessia de **240 s**, depois presença de **3 s**, raio **2**, junto à passagem. São números DRAFT para teste, não tempo canônico. Acesso à saída disponível desde o início; a conclusão aguarda o tempo. Usar suporte de objetivo já existente se o inventário confirmar compatibilidade. Sem chefe obrigatório, morte de Nidhogg, escolta, NPC recrutável, bônus de captura ou alteração de herói.

Pressão de combate ainda exige decisão: propor no contrato unidades já disponíveis e comportamento provisório explicitamente aprovado, sem inventar que essas espécies habitam canonicamente Yggdrasil. Recomendação inicial de teto 40, abaixo dos cenários de 50/54 já medidos; duração, ondas, multiplicadores e recompensas exatos serão fechados antes de código. Não importar estatísticas de Reino Abissal automaticamente. Pode-se avaliar primeiro apenas a circulação sem ondas, como check técnico, sem declarar esse ensaio uma fase completa.

| Recurso | Disponibilidade / tratamento |
| --- | --- |
| Projeção, herói/câmera, objetivo por tempo/presença, QA | Infraestrutura existente. Conferir consumidores exatos em S-YGG-002; não afirmar compatibilidade só por semelhança |
| Navegação das raízes de Reino Abissal | Algoritmos existentes como candidato de reutilização. Generalização exigirá escopo explícito, preservação da malha aceita e testes dos dois mapas; não ligar o ID novo ao mapa antigo |
| Arte Reino Abissal r1 | Aprovada somente para seu ambiente; não admitida como arte final de Yggdrasil. Geometria provisória em madeira é o caminho recomendado para o primeiro protótipo |
| Portal | Cor roxa sustentada para passagens abissais. No protótipo, marcador geométrico distinto de objetivo; representação não fixa símbolo/runa definitiva |
| HQ20 / Nidhogg / Marciela | Roteiro aprovado, sem pacote visual validado localizado para este trabalho. Produção das HQs/identidades tem plano e aprovação próprios |
| Tronco, casca final e fundo | Recursos específicos faltantes; propor seleção visual futura. Não gerar, recortar HQ ou instalar pacote neste planejamento |

## Escopo, validação e recuperação

O plano proposto cobre até um protótipo funcional QA e seu aceite. Arte final e ligação à campanha do capítulo 2 ficam fora dele, com contratos futuros. Não alterar direitos de acesso, saves, Dagruve/Thalion, HQ19 dividida, fila narrativa ou mapa Shedaklah por efeito deste protótipo. ID candidato raiz_yggdrasil está livre nas buscas dirigidas, mas será reconferido antes de código.

S-YGG-002 deve entregar inventário exato de consumidores, dados de navegação, objetivo/ondas, mapa de posições, arquivos e checks, baseline recente e recuperação. Teto proposto de 13 caminhos de jogo/teste; só executável depois de conferir que a implementação cabe nessa lista. Não improvisar arquivo extra nem suprimir exigências de testes. Sem dependência nova, escrita Web, commits ou publicação.

Checks futuros: conectividade e largura útil considerando corpos, chegada/saída, bloqueio de borda, diagonais/alto dt, dash/empurrões/separação, spawns/loot em apoio válido, nenhuma queda ou softlock, presença/tempo/pausa/idempotência e limpeza sem recompensa por abate. Preservar comportamento de voadores já existente; nenhum novo personagem passa a voar. Regressão dirigida dos dois mapas aprovados e do fluxo do capítulo 1. Cenário de desempenho com seed/dt e população definidos no contrato; investigar aumento sustentado acima de 10% em mediana/p95, sem prometer FPS.

Godot sempre precedido de sonda sem autoload, APPDATA/LOCALAPPDATA e perfil sintéticos; nunca save real. Capturas 1280×720/1920×1080 com vazios, objetivo e combate legíveis. Usuário avalia caminhos, bordas, pressão e conforto no playtest; testes não comprovam diversão. Recuperar somente arquivos próprios comparados ao baseline vigente, sem restaurar estado de outros chats.

## Gaps e checkpoints

| Ponto | Estado e encaminhamento |
| --- | --- |
| Narrativa pertinente | RESOLVED por HQ19/20/21 e correção CANON; HQ10 ainda em revisão concorrente, sem impedir este recorte documental |
| Referência visual específica | BLOCKING para arte final. Resolver seleção/identidades e aprovação própria antes de geração. Não bloqueia desenho textual ou futuro protótipo geométrico explicitamente autorizado |
| Bordas/planta/tempo/ondas/consumidores | BLOCKING para implementar; RESOLVABLE em S-YGG-002 com proposta/aceite delimitados |
| Integração Dagruve → raiz → Shedaklah | DEFERRED, contrato próprio de capítulo 2 e prontidão narrativa/visual |
| Arte final, personagens, áudio, Web/publicação | DEFERRED, sem produção neste plano |

Zero gaps BLOCKING para a etapa documental entregue e o detalhamento S-YGG-002. Não declarar o plano inteiro executável; os bloqueios de implementação/arte permanecem visíveis.

| Ordem | Etapa | Entrada → saída / checkpoint |
| --- | --- | --- |
| 1/5 | S-YGG-001 | Pesquisa + reconciliação → este plano DRAFT; concluída documentalmente |
| 2/5 | S-YGG-002 | Proposta aprovada → contrato técnico/planta/regras/arquivos/checks e prontidão; CP-YGG-002, sem código/arte |
| 3/5 | S-YGG-003 | Contrato aceito e zero BLOCKING → protótipo geométrico QA; CP-YGG-003 próprio |
| 4/5 | S-YGG-004 | Protótipo → testes isolados, capturas e ajustes dentro do contrato; CP-YGG-004 próprio |
| 5/5 | S-YGG-005 | Build validada → playtest humano e reconciliação; CP-YGG-005 próprio |

Próximo objetivo: aprovar o recorte r1 e autorizar somente S-YGG-002 para detalhar o contrato. Entrega exigida: regras e planta demonstráveis, recursos/limites honestos, lista fechada de arquivos e verificações, sem produção de bitmap ou jogo. Modo per-step permanece; nenhuma nova aprovação de modo necessária.


## Entrega S-YGG-002 — 2026-10-17

O usuário aprovou o recorte r1 e autorizou somente o detalhamento documental. [Contrato técnico DRAFT r1](technical-contract-r1.md) entregue com planta, objetivo/ondas, consumidores, teto de treze arquivos, doze conjuntos de testes e recuperação. [Evidência](../../evidence/EVID-NOTTGARD-YGGDRASIL-MAP-CONTRACT-20261017-r1.md). **2/5 etapas concluídas; três restantes.** CP-YGG-003 aguarda aceite concreto do contrato e autorização para protótipo geométrico QA. Nenhum código/bitmap/Godot executado; bloqueios documentais anteriores foram resolvidos pela proposta, enquanto arte final e integração continuam fora do recorte. Valores/pareceres antigos de estado são históricos.


## Implementação S-YGG-003 — 2026-10-17

Contrato r1 explicitamente aprovado e implementação autorizada. Protótipo geométrico entregue em treze caminhos, QA-only, com malha própria e parâmetros aprovados. Importação/compilação, entrada/capturas/retorno e launcher isolado passaram; perfil sintético preservado. [Evidência](../../evidence/EVID-NOTTGARD-YGGDRASIL-PROTOTYPE-20261017-r1.md). **3/5 etapas concluídas; duas restantes.** CP-YGG-004 aguarda autorização de validação completa; doze conjuntos e comparação de desempenho ainda pendentes. Nenhum playtest humano executado ou aceite visual inferido.


## Validação S-YGG-004 — resultado parcial

Etapa autorizada e executada: onze de doze conjuntos aprovados, simulação completa, capturas, auditoria de apoio visual e desempenho. [Evidência](../../evidence/EVID-NOTTGARD-YGGDRASIL-VALIDATION-20261017-r1.md). Falha remanescente: teste genérico exige props, contrariando o protótipo sem props aprovado. Teto13 preservado; [ajuste r2 DRAFT](validation-adjustment-r2-draft.md) propõe somente o14º caminho tests/test_level_design.gd. CP-YGG-004-R2 aguarda aceite do ajuste; 3/5 concluídas, etapa4 em andamento, duas restantes. S-YGG-005 não aberta.


## S-YGG-004 concluída com ajuste r2 aprovado

Usuário aprovou o14º caminho, somente test_level_design. Ajuste aplicado e teste afetado repetido com sucesso; demais onze resultados reutilizados com hashes conferidos. Validação12/12, teto14 e contrato ADD/referências conferidos. [Evidência final r2](../../evidence/EVID-NOTTGARD-YGGDRASIL-VALIDATION-20261017-r2.md). **4/5 concluídas, uma restante.** CP-YGG-005 aguarda autorização do playtest humano, com arte geométrica provisória; avaliação subjetiva ainda pendente.


## Ajuste r3 aplicado e reteste aberto

Galhos mais largos/volumosos conforme revisão r3 explicitamente aprovada. Três caminhos alterados no teto14; cinco testes afetados, capturas e auditoria raster/apoio aprovados. [Evidência r3](../../evidence/EVID-NOTTGARD-YGGDRASIL-THICKER-BRANCHES-20261017-r3.md). Playtest isolado reaberto mediante autorização já concedida; S-YGG-005 aguarda relato da nova build,4/5 concluídas.


## Encerramento S-YGG-005 — revisão r3

Usuário testou e aprovou largura dos galhos, bordas e espaço para combater, autorizando o encerramento. [Evidência do playtest](../../evidence/EVID-NOTTGARD-YGGDRASIL-PLAYTEST-ACCEPTANCE-20261017-r3.md). **5/5 etapas concluídas**, CP-YGG-005 encerrado. Hashes da build validada conferidos; sem repetição de testes ou mudanças de runtime. Arte geométrica continua provisória; arte final e integração capítulo2 permanecem fora do plano concluído.
