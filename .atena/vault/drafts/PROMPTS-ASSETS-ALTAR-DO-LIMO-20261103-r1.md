# Assets — Altares disputados (Shedaklah e Feng-tu), 2026-11-03, r1

Status: DRAFT, pedido do dono ("altar de limo está sem asset"; depois "Incluir Feng-tu"). Nenhuma geração, integração, aceite, commit ou publicação autorizados por este rascunho. Checkpoints dos demais planos preservados. Segue o formato de `PROMPTS-ASSETS-TEMPLO-TOU-UM-20261029-r1.md`.

## Lacuna

Os eventos opcionais `altar_disputado_shedaklah` ("o altar do limo") e `altar_disputado_feng_tu` ("o altar disputado") em `data/stage_events.json` são `kind: "pact"` e não têm chave `asset`. `core/happenings.gd` (ramo `pact`) lê `def.get("asset", "")`, então ambos aparecem como marcador sem arte. Não há PNG correspondente em `assets/interactions/` (existem só `altar_active.png` e `altar_spent.png`, o altar genérico de bênção/maldição). Nenhuma seção `asset_*` do `plan.yaml` nem lote de `.atena/generated/` cobre estes objetos.

Não revelar nada de "cânone do mestre".

## A06 — Altar do limo (Shedaklah) — objeto proposto, não aprovado

Lore (evento): o limo de Juiblex sobe pelo altar de Zuggtmoy; o jogador escolhe um lado e o outro se revolta. O objeto mostra o altar de Zuggtmoy (fúngico) sendo tomado pelo limo de Juiblex.

Entrega: 1 sprite estático. Formato normalizado: PNG RGBA com alfa real, cerca de 192×208 a 208×248 (escala de `arco_pedra.png` 208×248 e `trono_zuggtmoy.png` 199×248; altar um pouco mais baixo que o trono), margem transparente livre, base apoiada no mesmo ponto das outras interações.

Referências (estilo/escala, não alvo de edição): `assets/interactions/trono_zuggtmoy.png`, `assets/interactions/limo_juiblex.png`, `assets/interactions/altar_active.png`, `assets/interactions/arco_pedra.png`.

Prompt: Sprite de objeto em pixel art sóbria, câmera três-quartos isométrica 2:1, fundo realmente transparente. Um altar de pedra escura e baixo, com tampo largo e degrau de base, coberto de fungos e esporos pálidos (domínio de Zuggtmoy) enquanto um limo verde-ácido translúcido escorre pelo tampo e pelas laterais e começa a engolir os fungos (Juiblex), com poças e fios de gosma pingando pela base. Dois lados legíveis em silhueta pequena: fungos de um lado, limo do outro, sem símbolos ou inscrições legíveis. Contorno escuro nítido, luz superior esquerda, mesmo acabamento e escala das referências anexadas. Objeto inteiro visível e centrado. Sem texto, logotipo, moldura, sombra projetada, chão desenhado, personagens, criaturas ou xadrez gravado.

Destino futuro: `assets/interactions/altar_do_limo.png`.

## A07 — Altar disputado de Feng-tu — objeto proposto, não aprovado

Lore (evento): dois altares dividem a mesma pedra, a Estrela do Norte de Tou Um e a epidemia de Lu Yueh; Feng-tu se equilibrava pelo conflito entre os dois. O jogador escolhe um deus e o outro se revolta.

Entrega: 1 sprite estático, mesmo formato e escala de A06 (192×208 a 208×248), para que os dois altares leiam como a mesma família de objeto.

Referências (estilo/escala, não alvo de edição): `assets/interactions/estrela_do_norte.png` (luz azul), `assets/interactions/templo_de_tou_um.png` (pedra fria e estrela de oito pontas), `assets/interactions/altar_active.png`, `assets/interactions/arco_pedra.png`; paleta de peste da arte de cenário C05.

Prompt: Sprite de objeto em pixel art sóbria, câmera três-quartos isométrica 2:1, fundo realmente transparente. Uma única laje de pedra fria cinza, baixa, de tampo largo e degrau de base, dividida ao meio. Metade esquerda limpa, com um disco de estrela de oito pontas discreto gravado e uma chama azul pálida em cima, ecoando a Estrela do Norte; metade direita tomada pela peste, com pedra manchada de verde doentio, rachaduras, pústulas e um brilho esverdeado fraco. Dois lados legíveis em silhueta pequena, sem inscrições legíveis. Contorno escuro nítido, luz superior esquerda, mesmo acabamento e escala das referências anexadas. Objeto inteiro visível e centrado. Sem texto, logotipo, moldura, sombra projetada, chão desenhado, personagens, criaturas ou xadrez gravado.

Destino futuro: `assets/interactions/altar_disputado_feng_tu.png`.

## Integração futura (após aceite visual do dono)

Em `data/stage_events.json`, adicionar `"asset": "altar_do_limo"` a `altar_disputado_shedaklah` e `"asset": "altar_disputado_feng_tu"` a `altar_disputado_feng_tu`. Estender `tests/test_happening_art.gd` (`_check_event_consumption` e a checagem de importação) com os dois eventos e rodar a importação do Godot. Idle (`data/interaction_anims.json`) é opcional e fica para outra decisão.

## Fora de escopo

- Não regerar assets já aceitos.
- Não alterar `trono_zuggtmoy`, `limo_juiblex`, `estrela_do_norte`, `templo_de_tou_um` nem o altar genérico `altar_active`/`altar_spent`.
- Geração, idle animado e integração dependem de autorização e de aceite visual do dono.
