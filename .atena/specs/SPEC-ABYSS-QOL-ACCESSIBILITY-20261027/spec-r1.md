# SPEC-ABYSS-QOL-ACCESSIBILITY-20261027 · r1 (DRAFT, aguarda aprovação por plano)

Origem: pedido do dono em 2026-10-27: melhorar a qualidade de vida e a acessibilidade para os jogadores.
Escopo: Windows x86_64. Código de runtime só depois da aprovação. Nenhum número de balanceamento muda; nada novo no schema de save além de chaves opcionais em `profile.data.settings` (leitura com padrão, sem migração destrutiva). Sem dependências, sem recursos externos.

## O que já existe (não refazer)

| Área | Já feito | Onde |
|---|---|---|
| Áudio | Volume mestre, música, efeitos, ambiente e mudo por canal | `ui/options_panel.gd` |
| Impacto | "Impacto reduzido" (sem tremor/flash, vinheta estática, VFX de nova/swing/projétil desligados) | `core/danger_feedback.gd`, `Game.reduced_impact()` |
| Tela | Janela/sem borda/tela cheia, resolução, filtro visual, atmosfera | `Game.apply_window` |
| Mira | Automática ou no mouse, alternável (Tab / Y) | `Battle.Aim` |
| Controle | Remapeamento de botões, convenção A/B, ícones por família, zona morta, troca de dispositivo | `ui/controller_options.gd`, `core/controller_input.gd` |
| Ajuda | Dicas de primeira vez com teto, opção de rever | `core/onboarding_hints.gd` |
| Segurança | Pausa automática ao perder o foco | `ui/run.gd` `_notification` |
| Legibilidade | Números de dano com contorno e tamanhos por faixa, fonte dos títulos selecionável | `core/damage_feedback.gd`, `ui/ui_fonts.gd` |

## Lacunas encontradas

1. **Teclado não é remapeável**: Q, E, X, C, R, F/T, Tab, Shift e WASD estão fixos em `Game.ensure_input_actions` e `ui/run.gd`; só o controle tem remapeamento.
2. **Sem escala de texto/UI**: tamanhos de fonte fixos (14 a 16 px nos painéis, dicas, rótulos) com `canvas_items` a 1280x720; sem ajuste.
3. **Cor como única pista**: tipos de dano, escolas, bênção/maldição (▲/▼ já ajuda), telegrafias de chefe e alertas dependem de matiz. Não há modo para daltonismo nem contraste alto.
4. **Informação sonora sem equivalente visual**: avisos de chefe/perigo e falas (barks) dependem de áudio ou de balões curtos; não há indicador direcional de perigo fora da tela nem opção de duração/ficar-na-tela das falas.
5. **Esforço motor**: sem "segurar" vs "alternar" para habilidades que exigem manter botão, sem mira assistida graduada além do liga/desliga, sem ajuste de velocidade de jogo fora de F/T durante a run.
6. **Dificuldade sem rede de segurança**: "Maldição 0 a 3" só aumenta; não há modo de assistência (dano recebido, regeneração, ritmo de ondas) e a escolha não é explicada em consequências.
7. **Configurações dispersas**: Opções e Controles em painéis diferentes; sem busca, sem "restaurar padrões" geral, sem aviso do que vale só ao reabrir (fonte).
8. **Recuperação e continuidade**: pausa automática existe, mas não há "retomar com contagem regressiva", nem aviso claro de salvar/erro de save.

## Pacotes propostos (ordem recomendada)

### P1 · Leitura e visibilidade (maior ganho, baixo risco)
- **P1.1 Escala de interface** (Normal 100%, Grande 125%, Muito grande 150%): multiplicador central em `UiKit.label` e no tema `ui/theme.tres`, aplicado a HUD, pausa, ofertas, ficha, Quartel. Teste de layout a 1280x720 e 1920x1080 (sem corte).
- **P1.2 Contraste alto de HUD**: fundo mais opaco e contorno nos textos do mundo (falas, rótulos, dicas) via `Game.visual_settings_changed`.
- **P1.3 Modos para daltonismo** (protanopia, deuteranopia, tritanopia): paleta substituta para tipos de dano, escolas e telegrafias; **cada categoria ganha segunda pista não cromática** (ícone/forma/letra) em vez de só trocar cor. Base: tabela de cores única em `data/` lida pelos VFX e pela HUD.
- **P1.4 Falas e dicas**: duração ajustável, opção "manter até apertar", e fila visível para falas sobrepostas.

### P2 · Controles
- **P2.1 Remapeamento de teclado e mouse**: nova tabela em `profile.data.settings.keyboard`, mesma tela de captura do controle, detecção de conflito, "Restaurar teclado". Substitui as constantes de `ensure_input_actions` por padrões que o perfil sobrepõe. Movimento (WASD/setas) entra por último e com par de teclas.
- **P2.2 Alternar em vez de segurar** para ações contínuas, e "interagir ao encostar" já tratado como opção.
- **P2.3 Assistência de mira**: níveis Desligado / Suave / Forte em vez de só Auto vs Mouse (reutilizar o alvo automático, só muda tolerância).
- **P2.4 Velocidade do jogo** (0,75x, 1x, 1,25x) em Opções, além de F/T.

### P3 · Avisos sem depender do som
- **P3.1 Indicador direcional de perigo** na borda da tela (chefe, ataque telegrafado, área) respeitando "Impacto reduzido".
- **P3.2 Legendas de efeitos** opcionais ("Chefe carrega ataque", "Maré ativa"), reaproveitando `data/barks.json` e `data/boss_mechanics.json` para o texto.
- **P3.3 Alerta visual equivalente** para sons essenciais (recompensa disponível, extração, vida baixa) sem tremor.

### P4 · Assistência e ritmo
- **P4.1 Modo de assistência** separado da Maldição: sliders de dano recebido (50 a 100%), regeneração e densidade de ondas, **marcado no registro da tentativa** e sem conquistas/ranking quando ativo (decisão do dono, abaixo).
- **P4.2 Texto de consequência** nas Maldições 0 a 3 e prévia dos efeitos.
- **P4.3 Retomar com contagem** (3 s) depois da pausa e do retorno de foco; opção de desligar a pausa automática.

### P5 · Organização das Opções
- **P5.1 Uma tela de Opções** com abas (Áudio, Tela, Jogo, Acessibilidade, Controles) igual no Quartel e na pausa; "Restaurar padrões" por aba; indicação "vale ao reabrir".
- **P5.2 Predefinições de acessibilidade** (Visão, Audição, Motor, Leitura) que aplicam várias opções de uma vez e podem ser ajustadas depois.
- **P5.3 Aviso de falha de save** claro na tela (hoje só `logline`).

## Verificação

- Testes novos no padrão `tests/test_*.gd`, em diretório sintético isolado (jamais o save real): `test_ui_scale`, `test_colorblind_palette`, `test_keyboard_remap`, `test_assist_mode`, ampliar `test_options_menu` e `test_pause_menu`.
- Contrato de perfil: perfis antigos (sem as chaves novas) abrem idênticos; `tests/test_profile.gd` cobre.
- Revisão humana por pacote: captura de tela a 1280x720 e 1920x1080 nos tamanhos de escala; sequência de teclado só com remapeado; conferência de matiz por simulação de daltonismo nas telas de HUD e oferta.
- Checks em ambos os projetos quando a mudança for comum; portagem registrada se aplicável (hoje a plataforma é só PC).

## Decisões para o dono

1. **Prioridade**: seguir P1 → P2 → P3 → P4 → P5, ou puxar P2.1 (teclado remapeável) primeiro?
2. **Modo de assistência (P4.1)**: bloqueia conquistas/medalhas/ranking enquanto ativo, ou conta normalmente?
3. **Cores (P1.3)**: aceita mudar levemente cores dos tipos de dano para os três modos, mantendo o padrão como está hoje?
4. **Idioma**: continuar só em português ou reservar chaves de texto agora para localização futura? (Este plano não traduz nada.)
5. **Teste com pessoas**: há jogadores com necessidades específicas para validar P1.3 e P3, ou fica só simulação por filtro?

## Fora de escopo

Mobile, leitor de tela do sistema operacional, tradução, reescrita de HUD ou arte, novas telas de Quartel, mudança de balanceamento fora do P4.1.
