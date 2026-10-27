# PLAN-ABYSS-QOL-A11Y-P1 · evidência (2026-10-27)

Plano: `qol_accessibility_p1_20261027` em `.atena/state/plan.yaml`. Spec: `.atena/specs/SPEC-ABYSS-QOL-ACCESSIBILITY-20261027/spec-r1.md`. Sem commit, push, build ou exportação.

## O que entrou

| Passo | Entrega | Onde |
|---|---|---|
| S-A01 | Tamanho do texto 100/125/150%, ao vivo. Move o tamanho padrão do tema e cada `font_size` explícito; o tamanho original fica no nó, então 100% devolve o que o código pediu. Números de dano do mundo ficam de fora (`META_SKIP`). | `ui/ui_adapter.gd`, `Game.set_ui_scale` |
| S-A02 | Contraste alto: janelas opacas (alfa 1,0), escurecimento 0,78, texto apagado clareado, contorno escuro em rótulos sem contorno. | `UiAdapter`, `UiKit.window_alpha/dim_alpha` |
| S-A03 | Daltonismo (protanopia, deuteranopia, tritanopia): paleta substituta de tipo de dano (números, anéis de zona, telégrafos por tipo) e de raridade, mais marca no número de dano (▲ fogo, ● radiante, ◆ mágico). Desligado, as cores originais ficam intactas. | `core/accessibility.gd`, `run.gd` `_dcol`, `overlay.gd` `_dcol`, `Items.rarity_color` |
| S-A04 | Duração das falas e avisos do topo: Normal, Longa (2,5x) e Até a próxima (máx. 30 s). | `Accessibility.speech_hold`, `run.gd` fala, `hud.gd` aviso |
| Opções | Seção ACESSIBILIDADE no topo do painel (Quartel e pausa). | `ui/options_panel.gd` |

Chaves novas em `profile.data.settings`: `ui_scale`, `high_contrast`, `color_mode`, `speech_time`. Todas opcionais; perfil antigo não ganha chave e abre igual. Valores inválidos presentes no perfil voltam ao padrão (`Profile._migrate_settings`).

## Verificação

- `tests/test_accessibility.gd` (novo): regras puras, escala sem acúmulo e reversível, contraste e contorno reversíveis, `META_SKIP`, perfil antigo/inválido/válido, setters do Game, painel de opções, paletas por **simulação de daltonismo** (Machado 2009, severidade 1,0, distância mínima ΔE ≥ 24 entre categorias; valores medidos: dano 32,5 a 39,6; raridade 26,8 a 30,8).
- Suíte completa (`tests/run_all.gd`), perfil sintético: **0 falhas**. `tools/audit_projeto.gd`: **erros=0, avisos=0**.
- Capturas em `captures/` (1280x720 versionadas; as de 1920x1080 ficam só locais, não commitadas): Quartel Opções (100% e 150% com contraste), HUD (100%, 150%, 125% com contraste, 150% com contraste e deuteranopia, falas longas), pausa Jogo e Configurações (100%, 150%, 150% com contraste). Gerador: `tools/a11y_capture.gd` (APPDATA e perfil sintéticos; nunca o save real).
- Todos os testes e capturas rodaram com `--controller-profile` apontando para um perfil sintético fora do projeto, ou com `APPDATA` isolado.

## Limites conhecidos (não escondidos)

1. **Fila visível de falas sobrepostas (P1.4)**: adiada. Uma fala nova ainda substitui a anterior.
2. **Cor ainda não coberta**: tintas dos sprites de VFX (atlas), faíscas de acerto crítico por tipo, vermelho do dano recebido, gemas de raridade (arte). O número de dano, o anel/telégrafo por tipo e a cor de raridade em texto estão cobertos.
3. **Escala**: `[font_size=N]` embutido em BBCode (ex.: detalhe da ficha) não escala. Código que reescreve o tamanho depois de criar o nó só é reavaliado na próxima mudança de escala. Caixas de tamanho fixo podem cortar texto a 150% (janelas com rolagem absorvem).
4. **Telas não capturadas**: ficha do herói, cartões de oferta, leitor de HQ, resultado da corrida, Catálogo. Revisão humana pendente nelas a 125% e 150%.
5. **Aceite humano**: PENDENTE. Nenhum critério visual foi aceito por teste automático além da distinção de paletas.
6. **Portagem** para o repositório histórico `nottgard-survivor`: não feita (AGENTS.md pede portagem registrada para mudança comum; esta frente é PC e o histórico não recebe sincronização automática).
7. Outra sessão alterou os VFX do Lote 3 no mesmo checkout durante este trabalho (`ui/run.gd` compartilhado); as edições deste plano em `run.gd` e `overlay.gd` são pontuais e estão listadas acima.

## Revisão humana sugerida

Abrir Opções → ACESSIBILIDADE; testar 125% e 150% em: HUD de corrida, ficha (C), ofertas, pausa, Quartel e leitor de HQ. Em Daltonismo, olhar números de dano e raridades nos avisos. Reportar qualquer texto cortado.
