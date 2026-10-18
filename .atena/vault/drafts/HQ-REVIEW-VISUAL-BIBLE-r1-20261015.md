---
id: HQ-REVIEW-VISUAL-BIBLE-20261015
revision: r2
status: DRAFT_REFERENCE_CONSOLIDATION
---

# Referências para revisão das HQs

Consolidação de regras já registradas, para orientar as fichas por HQ. Não promove lore, identidades ou direção nova a CANON. Autoridade e revisões das referências estão no manifesto baseline.json de S-HQ-001; reler somente arquivos alterados ou pertinentes à HQ seguinte.

## Direção preservada

Fonte histórica ART-PROMPTS-027 (2026-09-29): ilustração de fantasia sombria com acabamento de pixel art denso e dithering controlado, bordas nítidas, sem suavização pictórica. Paisagem aproximadamente 16:9; nenhum texto, balão, UI, moldura, logo ou marca-d'água no PNG. Legendas ficam em data/hqs.json. Terço inferior calmo para a faixa do leitor; nada essencial cortado. Alternar plano aberto, médio e detalhe conforme a função narrativa. Grupo preferencialmente de costas/silhueta, sem tornar essa preferência uma regra absoluta para todo quadro.

Correção aprovada pelo dono em 2026-10-15, CANON [DEC-NOTTGARD-TARN-20261015 r1](../canon/DEC-NOTTGARD-TARN-20261015-r1.md): **a Tarn é um domo mágico de energia azul translúcida que cobre toda a cidade, incluindo seu teto, e a protege da névoa verde**. Mostrar curvatura contínua; não representar como muralha, cortina vertical, cristal ou vidro. A descrição histórica de ART-PROMPTS-027 como cortina de luz vertical está superada por esta decisão. A névoa é verde, visivelmente concentrada do lado externo; não substituir sua cor por cinza. Corrupção arcana usa roxo como acento quando pertinente; luz de tochas/lanternas em âmbar discreto; gótico, pedra molhada e reflexos conforme a cena. Sem gore explícito. Não aplicar a névoa/ausência de sol indistintamente a flashbacks de outras épocas: conferir tempo e lugar de cada HQ.

O arquivo conserva seu caminho original por estabilidade das referências; a revisão atual é r2. Somente a correção da Tarn/névoa acima tem a aprovação canônica específica; o restante desta consolidação permanece DRAFT.

## Identidade e referências

Dez retratos por versão estão disponíveis e preservados no baseline: kayron, durvall, sylas, maelor, brook, korrak, leoric, zynara, bromnor, nyrelia, em assets/portraits/<id>.png. Data/heroes.json fornece raça/papel; retrato atual fornece aparência. Ler as referências pertinentes antes de inspeção/produção e anexá-las quando gerar/editar. Não descrever identidade de memória. Confirmar continuidade entre os quatro quadros e escala relativa; SPEC-095 é referência histórica para goliath, halfling, gnomo e adultos do grupo, sem substituir as fontes atuais.

NPC sem retrato/identidade aprovada exige ficha e decisão de enquadramento; não inventar aparência canônica. Cena sem personagem: registrar identidade N/A porque o assunto é lugar/objeto. Helion não é N/A numa cena que o representa, mesmo se uma descrição antiga disser genericamente "sem personagens nomeados".

## Contexto e prontidão narrativa

Fonte primária local encontrada: D:/dev/nottgard/vault. O manifesto indexa sessões, história, personagens e lugares pertinentes sem copiar relatos pessoais. As sessões 01–24 do Arco 01 existem; a existência foi verificada, a leitura integral fica delimitada por HQ. Não consultar cânone do mestre/dossiês ou revelar segredos por efeito do inventário. A Sessão 01 declara status canônica; a narrativa Aluris se declara concluída e contém tags de história canônica. Esses estados pertencem à origem; não são promoção ao canon ADD deste projeto.

Mapa inicial conforme PLAN-040 e ART-PROMPTS-027/028/029:

| HQ | Fonte narrativa prevista |
| --- | --- |
| 01 | Sessão 01; prólogo e capítulo 1 de Histórias de Nottgard — Aluris |
| 02 | Sessão 02; capítulo 2 |
| 03 | Sessões 12–13; Ailalore |
| 04 | Sessão 15; Shedaklah |
| 05 | Sessão 16; Molor |
| 06 | Sessão 17; Durao |
| 07 | Sessão 18; Feng-tu |
| 08 | Sessão 19, fonte conjunta 19 e 20 parte 1; Shendilavri |
| 09 | Sessões 19–20; Goranthis |
| 10 | Sessões 23–24; Pilares |
| 11 | Sessões 8 e 10; Bromnor |
| 12 | Sessão 9; Ponte Aluris |
| 13 | Sessão 9; Cerco de Aluris — 1478 |
| 14 | Sessão 9; Sylas/Nyrelia |

Aplicar perspectiva do grupo e restrições já registradas. Não revelar por inferência a identidade secreta de Adam/Astherion, o receptáculo de Durvall, fatos de Nyrelia posteriores à cena ou assassino de Bromnor. Quando a narrativa mostra alianças com Zuggtmoy/Malcanthet, a vitória mecânica não autoriza retratar sua morte. Roteiros históricos são evidência da intenção anterior, não prova de acerto das legendas atuais.

## Entrada preparada para HQ 01

ID hqn_01, título Uma Noite Sem Fim, first_run. Elenco esperado em ART-PROMPTS-027: Kayron, Durvall, Sylas e Maelor. Q1: cidade/barreira, identidade N/A por não conter personagem relevante. Q2–Q4: quatro retratos oficiais necessários. Contexto: investigação nas Docas, ritual de enfraquecimento, contato da névoa e pista para masmorra da sessão seguinte. A Sessão 01 confirma uma missão anterior de Zynara para Kayron e Durvall; sua atribuição como fala na legenda Q2 precisa de revisão contextual, sem presumir sua presença física nas Docas. Não é erro declarado ou correção aprovada nesta etapa.

S-HQ-002 deverá exibir os quatro PNGs atuais e legendas literais, ouvir os apontamentos do dono e registrar a classificação de cada quadro. Nenhuma inspeção visual ou reescrita desta HQ foi executada em S-HQ-001.

## Produção e apresentação

Cada ficha identifica fonte/hash/revisão, personagens, época/lugar, ação e limite de revelação. Aprovar texto e descrição visual antes de produzir. Cada candidata terá nome versionado, histórico preservado e aceite individual; mostrar a sequência final antes da admissão em PC e Web. Técnica de edição/geração só será escolhida depois dos apontamentos; não há geração/delegação nesta etapa.

Animação é N/A para PNGs estáticos; feedback/navegação pertencem ao leitor existente. Reproduzir sua legibilidade em 1280x720 e 1920x1080, sem pressupor que teste de proporção prova leitura confortável. Limite de produção: somente os quadros identificados e aceitos pelo dono.
