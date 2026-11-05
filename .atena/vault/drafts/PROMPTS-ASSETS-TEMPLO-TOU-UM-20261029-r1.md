# Asset — Templo de Tou Um (Feng-tu), 2026-10-29, r1

Status: DRAFT, pedido do dono após o playtest do Vitão. Nenhuma geração, integração, aceite, commit ou publicação autorizados por este rascunho. Checkpoints dos demais planos preservados. Segue o formato de `PROMPTS-ASSETS-0-5-2-20261028-r2.md`.

## Lacuna

No evento `escolta_do_peregrino` (Feng-tu, `data/stage_events.json`), o destino "templo de Tou Um" não tinha arte: aparecia como marcador vazio. Como paliativo, o evento usa `arco_pedra` (208×248, reaproveitado do Portal de Shedaklah). A arte própria substitui o paliativo.

Contexto de lore (vault, Sessões 17 e 18): João Barbosa, devoto de Tou Um, segue a Estrela do Norte até o templo; o templo está degradado pela peste de Lu Yueh (a arte de cenário C05, "Feng-tu: templo de Tou Um degradado pela peste", já existe como referência de paleta e ruína). Não revelar nada de "cânone do mestre".

## A05 — Templo de Tou Um (objeto proposto, não aprovado)

Entrega: 1 sprite estático. A tira de idle (`assets/animations/interactions/<id>_idle.png` via `data/interaction_anims.json`) é opcional e fica para outra decisão; `arco_pedra` e `estrela_do_norte` têm idle, mas a ausência dele não quebra nada.

Formato normalizado: PNG RGBA com alfa real, cerca de 208×248 a 256×300 (mesma escala visual de `arco_pedra.png` 208×248 e `trono_zuggtmoy.png` 199×248), margem transparente livre, base apoiada no mesmo ponto das outras interações.

Referências: `assets/interactions/arco_pedra.png` e `assets/interactions/estrela_do_norte.png` (escala e acabamento), arte de cenário C05 do discípulo pestilento (paleta de Feng-tu), `assets/interactions/trono_zuggtmoy.png` (altura).

Prompt: Sprite de objeto em pixel art sóbria, câmera três-quartos isométrica 2:1, fundo realmente transparente. Um pequeno templo de pedra de um deus das estrelas, de fachada estreita com degraus de entrada, um disco ou estrela de oito pontas discreto no frontão (sem inscrições legíveis), colunas curtas, pedra cinza fria com manchas esverdeadas e doentias da peste, uma lanterna fraca azulada na entrada ecoando a Estrela do Norte. Silhueta clara em tamanho pequeno, contorno escuro nítido, luz superior esquerda. Mesmo acabamento e escala visual das referências anexadas. Sem texto, logotipo, moldura, sombra projetada, chão desenhado, personagens ou xadrez gravado.

Destino futuro: `assets/interactions/templo_de_tou_um.png`; depois, em `data/stage_events.json`, trocar `"asset": "arco_pedra"` do evento `escolta_do_peregrino` por `"templo_de_tou_um"`, e rodar `tests/test_happening_art.gd` (a checagem já exige arte no destino) e a importação do Godot.

## Fora de escopo

- Não regerar assets já aceitos.
- Não alterar `estrela_do_norte`, que pertence à peregrinação.
- Integração depende de aceite visual do dono.
