# F1: levantamento de slots e estilo (somente leitura)

Data: 2026-11-05. Estado: DRAFT. Nada foi alterado no runtime, em `plan.yaml` ou em assets. A forja continua sem dependências instaladas em `F:\dev\noct-asset-forge2d`.

## 1. Estilo real do jogo

- Não existe `STYLE.md`. O estilo está implícito nas fontes aceitas e em `ui/ui_kit.gd`.
- **Paleta do kit de UI** (convertida para hex): ouro `#edc766`, ouro apagado `#9e8047`, ferro `#5c596b`, texto `#ebe6db`, texto apagado `#9e9ead`.
- **Arte aceita:** dark fantasy pintada e ornamentada. Exemplos vistos: moldura da ficha 1280×720 com cantos dourados e rebites, chips de HUD 120×36 com ouro e ferro, ícones 128×128 com sombreado e textura ricos (ex.: `passives/acido.png`), chão pintado com textura orgânica (`tiles/molor_ground.png`, 128×64, RGB).
- **Importação:** `default_texture_filter=0` (filtro linear nos canvas). Pixel art nítida não é o padrão do projeto.

## 2. Como a UI usa arte e código

- A UI usa arte PNG para molduras, abas, slots, barras e chips (ex.: `ficha_moldura_painel`, `hud_chip_*`, `casela_*`), via `StyleBoxTexture` e `draw_texture`.
- Caixas planas em código (`StyleBoxFlat` / `UiKit.box`) existem só em pontos pequenos: `offer_card.gd` (6, desenho deliberado em código com ornamentos), `character_sheet.gd` (3), `status_chip.gd` (2), `hud.gd` (2), `hero_panel.gd` (2), `hud_art.gd` (1), `eco_banner.gd` (1).
- **Nenhum PNG referenciado em `data/`, `core/` ou `ui/` está faltando:** 323 caminhos únicos, 0 ausentes. Não há lacuna de arte a preencher com placeholder.
- Existem modos de acessibilidade (contraste alto, janelas opacas) que qualquer arte nova de UI teria de respeitar.

## 3. Candidatos avaliados

| # | Candidato | Aderência | Motivo |
|---|---|---|---|
| 1 | Ícones pequenos em pixel art | Nenhuma | Ícones do jogo são pintados 128×128; pixel art destoaria e não há slot vazio. |
| 2 | Tiles/texturas de chão repetíveis | Baixa | Chão é pintado por fase (atlas e `baked`); granulado e riscos da forja ficam visivelmente diferentes. |
| 3 | Placas de fundo nove-fatias para chips e banners (`status_chip`, `eco_banner`, `hud` controles, `stage_box`) | Média-baixa | São caixas planas hoje; uma textura sutil poderia melhorar. Risco de destoar do ouro ornamentado dos chips aceitos. |
| 4 | Molduras grandes (ficha, modal) | Nenhuma | Já existe moldura ornamentada aceita; a forja não alcança esse nível. |
| 5 | Cartões de oferta (`offer_card`) | Baixa | Desenho em código é intencional e já recebeu arte (U09/U11 integradas). |
| 6 | Placeholders e peças de QA | Nenhuma hoje | Não há asset faltando. |

## 4. Conclusão

A F1 não encontrou candidato forte. O estilo aceito do jogo é pintado e ornamentado, e a forja 2D produz arte limpa de vetor ou pixel que, nas amostras, ficou claramente mais simples. O único candidato plausível é o nº 3, de valor pequeno.

Isso mostra que a ferramenta funciona bem, mas o jogo hoje não tem uma lacuna que ela resolva.

## 5. Opções

- **A (recomendada): pausar a adoção.** Manter a forja guardada em `F:\dev\noct-asset-forge2d`, sem instalar nada, e reavaliar se surgir uma necessidade (ex.: peça técnica sem estilo pintado, ferramenta de protótipo, nova frente de UI).
- **B: F2 mínima.** Instalar dependências na pasta da forja, criar tema com a paleta acima e produzir **uma** placa nove-fatias para o candidato 3. Comparar em captura sintética lado a lado com os chips aceitos. Descartar se destoar.

Em ambas: sem alteração de runtime, commit, push ou promoção a CANON.

## 6. Decisão do dono (2026-11-05)

"Pausar adoção" (opção A). A forja permanece em `F:\dev\noct-asset-forge2d`, sem dependências instaladas. Nenhuma alteração de runtime, `plan.yaml`, commit ou push. Reavaliar somente se surgir necessidade nova.
