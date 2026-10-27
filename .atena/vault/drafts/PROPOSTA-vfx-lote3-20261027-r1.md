# Proposta — VFX e "dopamina", Lote 3: evoluções, detonação inimiga, tentáculos e dano no herói (2026-10-27, r1)

Status: **DRAFT, escopo aprovado pelo dono em 2026-10-27** (12 folhas, piloto E03, D01 e T02, indicador da Maré e metadados `dtype`; seção `vfx_lote3_2026_10_27` no `plan.yaml`, fila `ASSET-QUEUE-VFX-LOTE3-20261027-r1.md`). Nada foi gerado, integrado, commitado ou publicado. Continua `PROPOSTA-vfx-lote1-20261023-r1.md` e `PROPOSTA-vfx-lote2-20261023-r1.md` (ambos aprovados e publicados). Geração manual no ChatGPT, mesmo fluxo e contratos de folha dos Lotes 1 e 2; séries novas **E** (evoluções), **D** (detonação), **T** (tentáculos) e **H** (herói).

## 1. O que sobrou da auditoria original

| # | Lacuna | Evidência no código | Observação |
|---|---|---|---|
| 6 | Evoluções iguais às bases | `ProjectileVfx.FAMILIES`, `MeleeVfx.WEAPON_SHAPES`, `RadiantPulseVfx.WEAPONS` e `FireBurstVfx` roteiam a evolução para a mesma arte da base, só maior | evoluir hoje só muda os números |
| 9 | Detonação de AoE inimigo comum | o evento `boom` só tem arte para o afixo explosivo (M06); as demais detonações de telégrafo (cultistas, chefes) fecham num anel de 0,3 s | falta o "pow" depois do aviso |
| 10 | Zona de Tentáculos | `_draw_tentacle_zone` é polilinha roxa sobre uma elipse | a Cera já ganhou corpo e chama; os tentáculos não |
| 11 | Dano no herói | número flutuante, tremor, vinheta de tela e o tom vermelho do sprite do herói | **já existem** flash de tela (`DangerFeedback`) e tom no sprite (`hero.hit_flash`); falta um impacto desenhado no corpo |

Correção ao que falei no Lote 2: o "contador da Maré" não existe hoje na HUD (só um aviso de toast ao marco) e o flash de dano **já existe**. A barra de XP já pisca a cada coleta (`pulse_xp`). Por isso a lista de itens só de código, na seção 5, é menor e diferente.

## 2. Escopo: 12 folhas

Mesmos contratos: células de 256 px, mistura aditiva sobre preto, 6 quadros (1536×256) ou 4 loop + 4 uma vez (2048×256), margem mínima de 21 px, uma escala por animação.

### E — variantes de evolução (7)

Cada família evoluída ganha a sua arte: mais densa, outra cor, outro formato. As bases não mudam.

| ID | Nome | Quadros | Usada por | Ideia visual |
|---|---|---|---|---|
| E01 | `melee_fisico_evo_arco` | 6 | Espada da Armadura Negra, Maça Demolidora, Esmagar Defesas | arco pesado e largo, lâmina de energia carmim e preta, fissuras no ar, onda de choque |
| E02 | `melee_rajada_evo` | 6 | Rajada de Golpes | três cortes finos em leque que se cruzam, rápidos, brancos e dourados |
| E03 | `orbe_radiante_evo` | 4 + 4 | Luz Mais Pura | feixe de luz pura com halo e raios, impacto em estrela de seis pontas |
| E04 | `orbe_arcano_evo` | 4 + 4 | Raio da Ruína, Domínio Coletivo (tingido) | orbe arcano com cauda de runas quebradas, impacto que racha o ar |
| E05 | `onda_cortante_evo` | 4 + 4 | Tempestade | lâmina de vento com redemoinho e relâmpago, impacto em corte cruzado |
| E06 | `pulso_evo` | 6 | Julgamento da Glória, Chuva de Estrelas, Constelação de Silva (tingidos) | pulso com coroa de raios, anéis duplos e estrelas caindo |
| E07 | `explosao_fogo` | 6 | Bola de Fogo (pequena) e Tormenta de Fogo (grande) | explosão de fogo com coluna e brasas, no lugar do desenho procedural |

### D — detonação inimiga por tipo de dano (2)

Ao fim de um telégrafo, a arte aparece no raio exato do aviso. O afixo explosivo continua com a M06.

| ID | Nome | Quadros | Usada por | Ideia visual |
|---|---|---|---|---|
| D01 | `detonacao_fisica` | 6 | golpes físicos (Nidhogg, Kraken, Molydeus, Blogbog e outros) | pancada no chão: anel de choque elíptico, poeira, lascas de pedra |
| D02 | `detonacao_magica` | 6 | golpes mágicos (cultistas, chefes) | erupção violeta com runas e coluna de energia |

### T — Colar dos Tentáculos (2)

| ID | Nome | Quadros | Ideia visual |
|---|---|---|---|
| T01 | `tentaculos_emergem` | 6, uma vez | tentáculos rompem o chão em arco, com respingo e pó |
| T02 | `tentaculos_laco` | 6, laço | tentáculos violeta se contorcendo sobre um círculo no chão, vistos em 3/4 |

### H — dano no herói (1)

| ID | Nome | Quadros | Ideia visual |
|---|---|---|---|
| H01 | `dano_heroi` | 6, uma vez | impacto sobre o corpo: faísca vermelho-branca com talho rápido e fagulhas, curto e discreto |

**Corte mínimo sugerido (7 folhas):** E01, E03, E06, D01, D02, T02, H01. Cobre uma evolução física, uma de projétil, uma de pulso, os dois tipos de detonação, os tentáculos e o dano.

**Piloto de três:** E03 (projétil evoluído, com voo e impacto), D01 (detonação no chão, a mais frequente) e T02 (zona em laço, a mais difícil).

## 3. Código

Só apresentação: dano, hitbox, tempo e RNG continuam no `Battle`. "Reduzir efeitos de impacto" mantém o desenho de hoje.

1. **Evoluções por sobreposição, sem mexer nas listas das bases.** `ProjectileVfx` ganha `EVOLVED := {arma: família}` consultada antes de `FAMILIES`; `MeleeVfx` e `RadiantPulseVfx` ganham listas por ID de arma, como `RADIANT_WEAPONS`. Isso preserva os testes atuais, que fixam as listas das famílias-base (`test_projectile_and_ability_vfx`, `test_vfx_sfx_coverage`).
2. **`FireBurstVfx`** passa a usar a E07 quando a folha existe e mantém o desenho procedural como fallback.
3. **`core/detonation_vfx.gd` novo:** consome `boom` com `dtype`, tamanho pelo raio (mesma conta de `axes_for_radius`), limite de ~10 vivos. Metadado novo: `dtype` no evento `boom` (a zona de telégrafo já tem o campo).
4. **`core/tentacle_vfx.gd` novo**, no padrão do `WaxVfx`: a E01 não, a **T01** toca no evento `zone` do Colar dos Tentáculos, e a **T02** vive enquanto a zona vive, com fade pela vida da zona; `_draw_tentacle_zone` fica como fallback.
5. **`core/hurt_vfx.gd` novo:** a **H01** no corpo do herói no evento `hurt` (não contínuo), tingida pelo `dtype` quando o evento o trouxer; sem o dado, vermelho neutro. Metadado `dtype` acrescentado onde já é conhecido (golpes inimigos).
6. Reaproveita `VfxAtlas` (Lote 1) e `ProjectileVfx.frames_from_texture`; preparação com `tools/asset_prep.gd` e um job novo `tools/asset_jobs/vfx_lote3_v01.json`.

## 4. Testes

Pelo runner existente, sem carregar o save real.

- **`test_evolution_vfx.gd`:** toda evolução da lista tem família evoluída; as bases continuam roteadas como antes; impacto reduzido ignora; folhas com geometria e margem corretas; o evento da arma não é alterado.
- **`test_detonation_vfx.gd`:** `boom` com `fisico`, `magico` e afixo explosivo cai na arte certa; sem raio ou com impacto reduzido não cria nada; limite de vivos.
- **`test_tentacle_vfx.gd`:** só o Colar dos Tentáculos roteia; a arte nasce, vive e some junto com a zona; o dicionário da zona não é alterado.
- **`test_hurt_vfx.gd`:** só `hurt` não contínuo; tinta por `dtype`; limite; RNG intacto.
- **Ajustes** só se o roteamento tocar listas que algum teste fixa (a verificar).
- **Playtest sintético** com evoluções, detonações, a zona e dano em sequência, com e sem arte, e captura em `.atena/generated/vfx-lote3-…/`. Suíte completa e auditoria do projeto, como nos lotes anteriores.

## 5. Itens só de código (sem arte)

1. **Brilho da barra de XP ao subir de nível.** A barra já pisca a cada coleta. Aqui entra um brilho que varre a barra quando ela enche e vira nível (`hud.shine_xp()`), com "Reduzir efeitos de impacto" respeitado.
2. **Indicador da Maré.** Como não há contador hoje, é um elemento novo e pequeno ao lado da barra de XP: "Maré +N%" que aparece e pulsa só enquanto o bônus de XP vigora. É a única parte que toca layout da HUD.

O flash de dano no herói e a vinheta de vida baixa **já existem** e ficam como estão.

## 6. Passos e checkpoints

1. **Aprovação de escopo** (esta proposta); só então registrar a seção no `plan.yaml`.
2. Gerar **prompts e fila** (`ASSET-QUEUE-VFX-LOTE3-…`, `prompts/`, prancha de referência), no formato dos lotes anteriores.
3. **Piloto de três** (E03, D01, T02) no ChatGPT; revisão de estilo, tamanho e legibilidade, incluindo fundo claro.
4. Demais 9 folhas, até três candidatas por peça; aceite visual por ID/revisão/hash.
5. Preparação dos atlas, auditoria numérica e galerias de legibilidade.
6. Código e testes, na ordem: evoluções, detonação, tentáculos, dano no herói, itens só de código.
7. Playtest sintético e **playtest humano** com evoluções e um chefe.

Sem commit, push, build ou publicação sem pedido seu. O mesmo trabalho no projeto de origem em `D:` (portagem) continua pendente e não faz parte deste lote.

## 7. Decisões que preciso de você

1. Aprovar as 12 folhas, ou o corte mínimo de 7.
2. Piloto de três (E03, D01, T02), ou trocar.
3. Aprovar o novo **indicador da Maré** na HUD (item só de código que muda um pouco o layout), ou deixar de fora.
4. Aprovar os metadados `dtype` nos eventos `boom` e `hurt` (só apresentação, nenhuma lógica os lê).
5. Rajada de Golpes ganhar a folha própria E02, ou apenas usar a E01 tingida.

## 8. Riscos

- **Poluição visual:** evoluções e detonações acontecem em volume; mitigado por limites de efeitos vivos e por reservar a densidade para a evolução, não para a base.
- **Legibilidade do telégrafo:** a detonação respeita o raio exato do aviso (a arte é recortada ao raio) e o contorno de perigo continua desenhado por baixo.
- **Tentáculos:** são o item mais difícil de a IA acertar (laço sem emenda ruim); o piloto T02 existe para isso.
- **O ChatGPT não garante pixels nem loops perfeitos:** piloto, três candidatas e normalização na preparação.
- **Escopo:** 12 folhas somadas às 39 já feitas; por isso o corte mínimo e o piloto de três.
