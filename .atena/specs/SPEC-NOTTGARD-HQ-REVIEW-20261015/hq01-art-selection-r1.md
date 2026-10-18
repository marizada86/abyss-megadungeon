# HQ01 — seleção de imagens r1

Status: APPROVED_SELECTION_CHARACTER_CONFORMANCE_REVIEWED. Pedido de 2026-10-15: validar artes que continuam e as que serão geradas para a HQ01. Dono aprovou uma imagem mantida/quatro adaptações/três cenas novas e pediu somente conferir personagens contra referências. IN_PLAN, S-HQ-002, roteiro CANON HQ01-SCREENPLAY-20261015 r2, oito quadros. Esta seleção não autoriza produção, admissão, alteração do roteiro ou avanço à HQ02. Resultado da conferência: ../../evidence/EVID-NOTTGARD-HQ01-CHARACTER-AUDIT-20261015.md; aprovação das bases como cenário não é aprovação do elenco atual para reutilização direta.

## Entradas e prontidão da revisão

Bíblia visual local r2 (arquivo de caminho estável r1), decisão CANON da Tarn, regra do dono sobre céu interno do domo e névoa verde, roteiro aprovado, candidata Q1 aprovada e baseline recuperável. Inspecionados: candidata Q1; antigos hq_n01_q2/q3/q4; retratos oficiais Kayron, Durvall, Sylas, Maelor e Zynara. Manifesto de entradas com hashes: ../../generated/hq-review-20261015/hq01-art-selection-inputs.json.

Contexto: primeira investigação das Docas, antes da queda da Tarn, sem novos spoilers. Q1 é paisagem sem entidade: identidade N/A. Q5 pode ser detalhe do ritual sem personagem: identidade N/A nesse enquadramento proposto. Os demais quadros possuem personagens e exigem suas referências. Foram verificadas somente informações pertinentes nas fichas de Gilly, Mago Helion e Willie; não converter revelações posteriores dessas fichas em elementos desta HQ.

## Proposta por quadro

| Quadro novo | Decisão proposta | Base e mudança necessária |
| --- | --- | --- |
| 1 — Nottgard | MANTER, já aprovado | Candidata hq_n01_q1_dome_v01.png; não usar o antigo PNG de muralha. Preservar imagem e legenda aceitas |
| 2 — Dois chamados | GERAR CENA NOVA | Não existe entre os quatro quadros antigos a dupla de encontros Zynara/Kayron e Helion/Durvall. Usar retratos oficiais dos três disponíveis e validar Helion. Falas ficam na interface, sem embuti-las no PNG |
| 3 — A missão | GERAR CENA NOVA | Gilly bêbado com os quatro; Durvall com suco de laranja. Não há essa composição nas artes da HQ01. Gilly precisa de identidade visual validada |
| 4 — As Docas e Willie | ADAPTAR ANTIGO Q2 | Preservar arquitetura, cais, barcos e luz; trocar elenco genérico pelos quatro oficiais, inserir Willie e substituir o céu pela parte interna do domo azul |
| 5 — As trincas | ADAPTAR ANTIGO Q3 | Preservar runas, contraste azul/verde e detalhe da ruptura. Reenquadrar como energia do domo com fissuras, sem material vítreo; preferir detalhe sem a mão/grupo para distinguir do contato seguinte |
| 6 — O contato | ADAPTAR ANTIGO Q3, saída distinta de Q5 | Preservar direção visual da névoa e reação coletiva; mostrar exatamente quatro protagonistas, três abalados e Durvall firme. A mão em primeiro plano mais quatro figuras não pode sugerir um quinto membro. Corrigir identidades e contexto do domo |
| 7 — Durvall observa | GERAR CENA NOVA | Novo enquadramento mais próximo: Durvall observa, três companheiros se recompõem. Deve ser legível como momento posterior a Q6, sem repetir a mesma imagem |
| 8 — O porão | ADAPTAR ANTIGO Q4 | Preservar porta, escada, ruína, lanterna e composição. Corrigir os quatro personagens e a geometria da Tarn/contexto do céu visível |

Resultado proposto: **uma imagem mantida sem alteração, quatro adaptações e três cenas novas — sete novas saídas candidatas**. Adaptar significa produzir candidata a partir da arte antiga como alvo/referência, não garantir preservação pixel a pixel ou edição simples. Cada uma continua sujeita a revisão individual e nomes versionados; originais preservados.

Nenhuma das três artes antigas com grupo está pronta para uso integral sem correção. Nos antigos Q2 e Q4 há arquétipos de arqueiro de capuz/mago de chapéu incompatíveis com os retratos do grupo inicial. Antigo Q3 sugere grupo extra e mantém representação de barreira problemática. A qualidade de cenário e linguagem visual é aproveitável; não confundir qualidade com identidade aprovada.

## Referências dos personagens

- Kayron, Durvall, Sylas, Maelor e Zynara: retratos oficiais locais inspecionados e disponíveis. Usá-los como referência de aparência em qualquer produção, com continuidade entre quadros. Não trocar Kayron por Durvall só porque ambos têm cabelo claro.
- Helion: fonte canônica consultada o descreve como elfo velho. Inspecionada arte existente assets/hq/hq_n03_q3.png, com mago idoso de barba longa e veste escura/dourada: **proposta de referência visual para o dono validar**, sem carregar a cena de sacrifício/incêndios para HQ01. Não existe retrato autônomo identificado com seu nome em assets/portraits.
- Gilly: fonte canônica o identifica como gnomo, Alto Conselheiro das Docas; embriaguez na missão foi definida pelo dono. Inspecionada assets/hq/hq_n12_q2.png como possível referência histórica, mas a figura que apresenta o grupo não estabelece claramente escala de gnomo. Não tratá-la como referência aprovada sem confirmação/correção.
- Willie: fonte canônica o identifica como gnomo local. Não foi localizado PNG nominal dele em assets no inventário por nome; isso não prova ausência de representação não identificada em outras HQs. Sua aparência para o encontro deve ser confirmada antes da geração de Q4. Não usar forma monstruosa de eventos posteriores.

Bloqueios de produção por cena: Q2 depende da identidade de Helion; Q3 depende de Gilly; Q4 depende de Willie. Isso não bloqueia a seleção das bases. Para produzir depois do aceite da seleção, preparar fichas textuais/referências faltantes e validar com o dono, sem inventar canon silenciosamente. Não houve delegação ou chamada a ImageGen nesta seleção.

## Próximo checkpoint

Apresentar a tabela e as bases antigas para validação. Preservar o aceite de Q1 sem pedir nova aprovação. Obter decisão sobre a divisão manter/adaptar/gerar e depois fechar identidades faltantes. Ainda reconciliar a spec de implementação e os oito quadros antes da admissão em PC/Web. Sem runtime alterado, não foram iniciados testes Godot, saves ou builds. A portagem de imagens aceitas e checks nos dois projetos continuam posteriores.
