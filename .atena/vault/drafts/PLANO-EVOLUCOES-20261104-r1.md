# PLANO — Evolução para todas as armas (DRAFT r1, 2026-11-04)

Estado: rascunho para aprovação do dono. Nada foi aplicado em `data/`, `core/` ou `tests/`; `plan.yaml` não foi alterado; sem commit.
Origem: auditoria de `data/weapons.json` (43 armas: 15 evoluem, 15 são formas evoluídas, 13 não evoluem).

## 1. Escopo

12 armas entram no plano. A 13ª, **Domínio da Vontade** (item Coração da Dominância, tier 5), fica fora: não tem níveis (`levels: []`), é recompensa final de uma estrela só. Ver D-1.

Heróis beneficiados (a arma inicial passa a evoluir, como já ocorre com os 5 iniciais): **Korrak Nammat** (Machado de Xar'gath), **Zynara Vellen** (Ampulheta), **Arlindo Orlando** (Memória Alterada), **Erik Blackthorn** (Tocha do Incendiário).
Correção a uma resposta anterior: o herói do Machado é Korrak; "Durao" é só o nome da conquista que o desbloqueia (`veterano_de_durao`).

## 2. Como o motor já funciona (nada a criar no código)

- Evoluir = `evolve: {passive, into, min_attr?}` na arma base + arma destino com `src: "Evolução"` e `levels: []` ([weapon.gd:75](../../../core/weapon.gd)).
- Condição: arma no Nv 5 e passiva em mãos (nível ≥ 1); a passiva exigida entra na oferta com peso 9 e **não ocupa** os 5 espaços de passiva ([battle.gd:3145](../../../core/battle.gd)).
- Armas vindas de item (`granted`) também sobem de nível e evoluem; a evolução preserva o `granted` ([battle.gd:3397](../../../core/battle.gd)).
- Armas com `src` iniciando em "Evolu" ou "Item" não entram como "NOVA" nas ofertas; as evoluções ficam protegidas.
- Auditorias já cobrem: passiva existente, destino existente, `min_attr` entre 8 e 30 ([test_data.gd](../../../tests/test_data.gd), [audit_projeto.gd](../../../tools/audit_projeto.gd)).
- Todas as evoluções abaixo usam **só chaves de efeito que o motor já lê** (`dice, dmg, cd, range, cone, count, spread, pierce, radius, duration, tick, slow, stun, weaken, mark, burn, lifesteal, heal, gold_hit, ignore_def`). Zero código de combate novo.

## 3. Passivas

Hoje: 14 passivas; 12 são usadas por evoluções; **Regeneração** e **Ganância** estão sem uso. Plano: reaproveitar as duas e criar **2 novas** (total 16, todas com função).

| Passiva | Situação | Dados | Usada por |
|---|---|---|---|
| `regeneracao` | existente, sem uso | — | Vela Sagrada |
| `ganancia` | existente, sem uso | — | Chicote Avarento |
| `precisao` "Mira Justa" | **NOVA** | src "Treino", `mods: {hit: 1}`, "+1 de precisão por nível" | Marca da Retidão, Lâmina de Sombra |
| `brasa` "Brasa Viva" | **NOVA** | src "Fogo", `mods: {dmg_pct: 0.04}`, "+4% de dano por nível" | Machado de Xar'gath, Tocha do Incendiário |

As chaves `hit` e `dmg_pct` já existem no herói ([battle.gd:1014](../../../core/battle.gd), [battle.gd:1025](../../../core/battle.gd)); as novas passivas são só dados. Falta o ícone `assets/icons/passives/<id>.png` (ver fase 5).

## 4. Tabela de evoluções (valores iniciais, a calibrar na fase 4)

Referência: nas 15 evoluções atuais o DPS médio vai de ~1,3× a ~3,5× o do Nv 5 da base (típico ~1,8×); armas de área mudam menos em DPS e mais em raio/utilidade. Meta: ~1,7–2,2× e um efeito qualitativo. Nomes são **provisórios** (ver D-3).

| Arma base (Nv 5, DPS≈) | Passiva | Gate | Evolução (provisório) | Mudança |
|---|---|---|---|---|
| Estocada Mística (11,2) | `carisma` | — | Estocada Transfixante | 3d6+5, cd 0,8, alcance 3,6, cone 30, `weaken` 1 |
| Vela Sagrada (1,5; cura) | `regeneracao` | — | Vigília Perpétua | 3d6, cd 2,5, raio 3,6, `heal` 2,2 |
| Marca da Retidão (1,9; marca) | `precisao` | — | Selo da Retidão | 2d6, cd 2,0, `count` 3, `pierce` 1, `mark` 0,8, `weaken` 3 |
| Chicote Avarento (7,9) | `ganancia` | — | Chicote da Cobiça | 3d6+3, cd 0,7, alcance 3,8, cone 30, `gold_hit` 5 |
| Machado de Xar'gath (10) | `brasa` | FOR 16 | Machado Devorador (prov.) | 4d8+5, cd 1,1, cone 140, `burn` 5, `lifesteal` 0,08 |
| Colar dos Tentáculos (1,2; zona) | `alcance` | — | Abraço dos Tentáculos | 3d6, cd 5,0, raio 4,2, duração 6, tick 0,5, `slow` 1,0 |
| Lâmina da Digestão (8,1) | `forca` | — | Lâmina Dissolvente | 3d6+4, cd 0,85, alcance 2,4, cone 80, `weaken` 5 |
| Cajado dos Desejos (15) | `sorte_de_sendrinah` | CAR 16 | Cajado dos Desejos Realizados | 2d6+3, `count` 5, cd 1,8, `spread` 40 |
| Ampulheta (2,2; stun) | `foco_arcano` | INT 16 | Ampulheta do Tempo Parado | 4d8, cd 3,5, raio 6,5, `stun` 4,0 |
| Lâmina de Sombra (6,9) | `precisao` | — | Lâmina do Eclipse | 2d8, `count` 3, `pierce` 3, cd 1,3, `ignore_def` 4 |
| Memória Alterada (6,8) | `sabedoria` | CAR 16 | Memória Reescrita | 2d8+3, `count` 2, cd 1,7, `slow` 4,0 |
| Tocha do Incendiário (6) | `brasa` | — | Pira do Incendiário | 3d8+3, cd 1,2, alcance 2,6, cone 100, `burn` 5 |

Escolha das passivas: a passiva casa com a identidade da arma (cura→Regeneração; moedas→Ganância; memória→Sabedoria/XP; tempo→Foco Arcano; zona→Alcance; fogo→Brasa) ou com o atributo dela, como nas evoluções atuais. Os gates `min_attr` seguem o padrão das armas fortes existentes (Maça Demolidora, Raio da Ruína, Constelação de Silva) e ficam nas relíquias de tier alto.

Uso final das passivas: `cota_de_malha` ×3, `sabedoria` ×3, `carisma`/`forca`/`foco_arcano`/`alcance`/`sorte_de_sendrinah`/`precisao`/`brasa` ×2, as demais ×1. Passivas repetidas só pesam se o herói tiver as duas armas.

Sinergias (`synergy` por item base, opcionais): fora do escopo mínimo; podem entrar numa r2 usando as bases ainda livres (`espada_longa`, `cajado`, `couro` etc.).

## 5. Passos (um checkpoint cada; aprovação por plano)

| Passo | Entrega | Verificação |
|---|---|---|
| S-E01 | Dono decide D-1 a D-5 | Decisões registradas neste arquivo (r2) |
| S-E02 | `data/passives.json` (+2), `data/weapons.json` (12 blocos `evolve` + 12 armas evoluídas, `src: "Evolução"`, `levels: []`, `icon_like` da base) | `tests/test_data.gd`, `tools/audit_projeto.gd` sem erro |
| S-E03 | Testes: remover a asserção "Lâmina de Sombra não evolui na 0.4.0" ([test_new_content.gd:104](../../../tests/test_new_content.gd)); novo teste de cobertura: toda arma com `levels` não vazio tem `evolve` ou consta em lista explícita de exceções; cada evolução é alcançável (passiva existe, destino com `src: "Evolução"`) e aparece na oferta com Nv 5 + passiva | Suíte do projeto, em diretório sintético, sem tocar no save real |
| S-E04 | Balanço: rodar os bots de balanço (`.atena/generated/balance-bots-20261018`) antes/depois nas 4 relíquias de herói e nas 8 armas de carta/item; ajustar números da tabela | Relatório de DPS e taxa de vitória por herói |
| S-E05 | Apresentação: ícones das 12 evoluções (provisório via `icon_like`, exigido pelo teste de ícone), ícones das 2 passivas, VFX (as evoluções herdam a família da base; arte evoluída própria só onde houver ganho: melee físico via `EVOLVED_SHAPES`), entradas de Codex | Item entra na fila de assets, que já exige aprovação própria |
| S-E06 | Reconciliação: registrar no `plan.yaml` e checar a portagem com a origem | Checks em ambos, conforme AGENTS.md |

S-E02 e S-E03 podem ser executados juntos; S-E04 só depois deles; S-E05 não bloqueia o jogo (tudo tem fallback provisório).

## 5b. Execução (2026-11-04) — S-E02 e S-E03 concluídos, sem commit

Decisões aplicadas: as recomendadas (D-1 sem evolução para Domínio da Vontade; D-2 `brasa` genérica; D-3 nomes provisórios; D-4 gates FOR/CAR/INT/CAR 16; D-5 só dados e ícones provisórios).

Arquivos alterados: `data/passives.json` (+2), `data/weapons.json` (12 `evolve` + 12 armas evoluídas), `data/audio_manifest.json` (12 eventos `weapon.<evolução>.fire`, reaproveitando os WAV da base com tom 0,92× — provisório), `core/weapon.gd` (4 evoluções de Carisma em `SCHOOL_EXCEPTIONS`), `tests/test_new_content.gd`, `tests/test_arcanist.gd`, `tests/test_playtest_fixes.gd` e o novo `tests/test_weapon_evolution_coverage.gd`.

Efeitos colaterais que o plano não previa e foram tratados: assinatura sonora obrigatória por arma; lista de armas físicas do Arcanista (4 evoluções corpo a corpo entram como "arma"); exceções de escola por atributo; contagem de evoluções (15 → 27); a asserção que garantia a regressão "evoluções antigas sem `min_attr`" ganhou lista de exceções.

Verificação: suíte completa `tests/run_all.gd` com 0 falhas e `tools/audit_projeto.gd` com 0 erros e 0 avisos, ambos com perfil sintético (`--controller-profile` em diretório temporário); o save real não foi carregado.
Pendente: S-E04 (balanço com os bots), S-E05 (ícones próprios das passivas, VFX, Codex) e S-E06 (`plan.yaml`/portagem). Os ícones das 2 passivas novas ainda não existem em `assets/icons/passives/`.

## 5c. Revisão r2 (2026-11-04) — regra "a exigência de evolução não se repete" + balanço (S-E04) concluído

Pedido do dono: nenhuma evolução nova pode repetir a passiva exigida de outra (a r1 repetia Mira Justa em Marca da Retidão e Lâmina de Sombra, além de Carisma, Força, Alcance, Sabedoria, Foco Arcano e Sorte de Sendrinah, já usadas por evoluções antigas). **As seções 3 e 4 acima ficam superadas por esta tabela**; passam a existir **10 passivas novas** (24 no total), só dados, usando chaves que o herói já lê.

| Arma base | Passiva exigida | Efeito por nível | Gate | Evolução (provisório) |
|---|---|---|---|---|
| Estocada Mística | `ponta_certeira` Ponta Certeira *(nova)* | +2% de crítico | — | Estocada Transfixante |
| Vela Sagrada | `regeneracao` Regeneração *(existente, sem uso)* | +0,12 PV/s | — | Vigília Perpétua |
| Marca da Retidão | `precisao` Mira Justa *(nova)* | +1 de precisão | — | Selo da Retidão |
| Chicote Avarento | `ganancia` Ganância *(existente, sem uso)* | +15% de moedas | — | Chicote da Cobiça |
| Machado de Xar'gath | `sede_de_sangue` Sede de Sangue *(nova)* | +1% de roubo de vida | FOR 16 | Machado Devorador |
| Colar dos Tentáculos | `olhar_abissal` Olhar Abissal *(nova)* | +6% de dano em área | — | Abraço dos Tentáculos |
| Lâmina da Digestão | `acido` Ácido Corrosivo *(nova)* | +1 de dano por acerto | — | Lâmina Dissolvente |
| Cajado dos Desejos | `ventura` Ventura *(nova)* | +1 de sorte | CAR 16 | Cajado dos Desejos Realizados |
| Ampulheta | `tempo_suspenso` Tempo Suspenso *(nova)* | −4% de recarga | INT 16 | Ampulheta do Tempo Parado |
| Lâmina de Sombra | `veu_de_sombras` Véu de Sombras *(nova)* | +2% de esquiva | — | Lâmina do Eclipse |
| Memória Alterada | `memoria_viva` Memória Viva *(nova)* | +4% de XP e +3% de XP por Eco | CAR 15 (era 16) | Memória Reescrita |
| Tocha do Incendiário | `brasa` Brasa Viva *(nova)* | +8% de dano de fogo (`fire_pct`, já existente: só fogo) | — | Pira do Incendiário |

D-2 resolvida sem código: a Brasa Viva usa `fire_pct`, que o motor já lê, em vez de dano genérico. **Herança preservada**: `cota_de_malha` (Espada Sombria, Martelo da Glória, Romper Armadura) e `sabedoria` (Dominar Pessoa, Sopro de Estrela) continuam divididas por evoluções antigas; o teste `LEGACY_SHARED` as autoriza e barra qualquer outra repetição. Remover essa herança exigiria mais 3 passivas novas e mudaria evoluções já jogadas (decisão D-6).

**Balanço** (sonda `.atena/generated/evolution-balance-20261104-r1/probe.gd`, arena controlada, 20 s, alvo único e anel de 10; resultados em `results/`): referência = as 15 evoluções antigas, que multiplicam o DPS do Nv 5 da base em 1,1×–3,3× (mediana 2,16×) com os 4 atributos em 16. Após ajuste, as 12 novas ficam em 1,8×–2,4× em alvo único (Ampulheta 3,3×: a base quase não causa dano, o valor é o atordoamento). Ajustes feitos: Estocada 3d8 / recarga 0,75; Selo da Retidão 2d4 / recarga 2,2 / 2 marcas / marca 0,6 / enfraquece 2 (estava 4,2×); Cajado com passo de leque 26° (40° deixava só 1 de 5 projéteis no alvo, 0,58×); Memória Reescrita 3d6 / recarga 1,6; Pira do Incendiário 3d6 +5 / recarga 1,3; Lâmina do Eclipse recarga 1,4; Machado Devorador +7. Com atributos 10 e 20 a razão se mantém (1,5×–3,2×); em atributo alto as multiplicações comprimem como nas evoluções antigas.
Limites da sonda: mede dano, não cura (Vigília), controle (Colar, Ampulheta) nem a utilidade das passivas; não substitui os bots de campanha (`balance-bots-20261018`), que não foram reexecutados.

Risco novo: o pool de passivas sobe de 14 para 24; cada passiva não evolutiva fica mais rara nas ofertas de nível. A passiva que libera uma evolução continua com peso 9 e sem ocupar espaço de passiva.

## 5c-bis. Revisão r3 (2026-11-04) — herança repetida removida (D-6 decidida: remover)

Decisão do dono: "Remover repetições". Agora **nenhuma passiva é exigida por mais de uma evolução** (27 evoluções, 27 passivas distintas; 13 passivas novas, 27 no total). A Espada Sombria ficou com `cota_de_malha` e o Sopro de Estrela com `sabedoria`; as outras três trocaram:

| Arma base | Antes | Agora | Efeito por nível |
|---|---|---|---|
| Romper Armadura | `cota_de_malha` | `quebra_defesas` Quebra-Defesas *(nova)* | +4% de dano |
| Martelo da Glória | `cota_de_malha` | `vigor_sagrado` Vigor Sagrado *(nova)* | +6 PV |
| Dominar Pessoa | `sabedoria` | `presenca_dominante` Presença Dominante *(nova)* | −3% de recarga e +1 de precisão |

Efeito prático: quem já conhecia essas evoluções precisa de outra passiva agora (as exigências de atributo, CON 16 e CAR 16, não mudaram). Testes ajustados em `test_new_content.gd`; `test_weapon_evolution_coverage.gd` não tem mais exceção. A sonda não mostrou regressão: Esmagar Defesas 2,2× e Domínio Coletivo 2,8× em alvo único; O Martelo da Luz media 1,1× na sonda de 20 s, mas essa janela é curta demais para armas lentas (7 golpes por simulação). Medido em 240 s, o Martelo da Glória (Nv 5) dava 7,6 de DPS e a evolução antiga ~1,6× o nominal. Reforçado a pedido do dono: recarga 1,8 → 1,6 e +4 de dano por acerto; em 240 s, 7,6 → 14,3 (1,88×, dentro da faixa das demais). Aviso: as razões de 20 s de armas lentas (Sopro, Ampulheta, Bola de Fogo, Vigília e similares) têm ruído; sonda de depuração com 240 s em `debug_hits.gd`.

## 5c-ter. Revisão r4 (2026-11-04) — Cota de Malha volta ao Romper Armadura; Martelo ganha passiva radiante

Pedido do dono: o Romper Armadura fica com `cota_de_malha`, e o Martelo da Glória ganha uma passiva nova de dano radiante. Para manter a regra de não repetir, a Espada Sombria (Durvall) passou a exigir uma passiva nova (escolha do dono entre 3 opções). **Substitui a tabela da r3**; `quebra_defesas` e `vigor_sagrado` foram removidas.

| Arma base | Passiva antes (r3) | Passiva agora | Efeito por nível |
|---|---|---|---|
| Espada Sombria | `cota_de_malha` | `furia_sombria` Fúria Sombria *(nova)* | +5% de dano abaixo de 50% de PV (`low_hp_dmg`, já existente; soma com a passiva do Durvall, +25% na mesma condição) |
| Romper Armadura | `quebra_defesas` | `cota_de_malha` | +1 CA |
| Martelo da Glória | `vigor_sagrado` | `fe_radiante` Fé Radiante *(nova)* | +8% de dano radiante (`radiant_pct`, bônus novo) |

Código: uma linha em `core/battle.gd` (bônus `radiant_pct` só para dano radiante, no mesmo ponto do `fire_pct`) e rótulos de `radiant_pct` e `low_hp_dmg` em `core/items.gd`. Testes: `test_battle.gd` (4 pontos que usavam Cota de Malha com a Espada Sombria), `test_new_content.gd`, e `test_weapon_evolution_coverage.gd` (novo teste: Fé Radiante aumenta o dano radiante e não mexe no fogo). Balanço: Martelo da Glória 7,6 → 15,4 de DPS em 240 s (2,0×) com Fé Radiante Nv 1; a Fúria Sombria só atua abaixo de 50% de PV, então a sonda (herói com PV cheios) não a mede. Total: 27 passivas, 13 delas novas. Ícones: folha E06 agora = Fúria Sombria, Fé Radiante, Presença Dominante.

## 5d. Assets preparados (sem gerar)

`PROMPTS-ASSETS-EVOLUCOES-20261104-r1.md` (22 ícones 128×128 em 5 folhas, prompts e destinos) e `.atena/generated/asset-evolucoes-20261104-r1/jobs.json` (recortes de preparação). Nada foi gerado nem integrado.

## 6. Decisões para o dono

- **D-1 Domínio da Vontade.** Recomendo deixar sem evolução (recompensa final de uma estrela). Alternativa: dar 4 níveis + evolução, o que exige novo desenho.
- **D-2 `brasa` genérica.** Recomendo `dmg_pct` de 4% (sem código). Alternativa: passiva que só reforça queima (`burn_pct`), mais temática, exige código no motor.
- **D-3 Nomes e lore.** Os nomes são provisórios. O Vault tem segredos de "cânone do mestre"; nada aqui afirma fatos novos de lore. Os nomes finais precisam ser aprovados (ou virem do Vault) antes do Codex.
- **D-4 Gates de atributo.** Recomendo os 4 listados (Machado FOR 16, Cajado CAR 16, Ampulheta INT 16, Memória CAR 16). Alternativa: sem gate nas relíquias de herói, para o jogador evoluir sem fricção.
- **D-6 Repetição herdada.** Manter `cota_de_malha` ×3 e `sabedoria` ×2 como estão (recomendado, por compatibilidade) ou trocar 3 delas por passivas novas.
- **D-5 Escopo de apresentação.** S-E05 inteiro agora, ou só dados + ícones provisórios agora e arte depois (recomendado).

## 7. Riscos

- Armas "Arma de Erik…" e "Magia de Arlindo…" não são filtradas das ofertas NOVA (só "Item"/"Evolu" são); outros heróis podem receber Tocha e Memória e passam a ter também a evolução. Comportamento já existente, mas convém decidir se é desejado.
- A passiva exigida por uma evolução só aparece como "NOVA" com peso alto enquanto a arma estiver no Nv 5; nenhuma mudança de oferta é necessária.
- Evoluções de área (Vela, Colar, Ampulheta) têm DPS baixo por natureza; a avaliação delas deve olhar utilidade (cura, controle), não só dano.
- Números da tabela são ponto de partida: nenhum foi simulado.

## 5e. Ajuste do gate do Arlindo e VFX da Memória Alterada (2026-11-04, depois do commit 1bf0d61)

- A Memória Reescrita passa a exigir **Carisma 15** (era 16): o Arlindo começa com 15, o único herói que começava abaixo do valor exigido da própria arma (os demais começam exatamente no valor). Simulação: com Nv 5 + Memória Viva e CAR 15 a evolução entra na oferta e a arma troca; a cinemática roda e termina.
- Projétil da Memória Alterada (família `orbe_memoria`) e habilidade Modify Memory (folha nova de `habilidade_arlindo.png`, `ref_px` 110) integrados a partir das fontes aceitas de `asset_queue_20261104-r1`. Capturas em `.atena/generated/evolution-assets-qa-20261104-r1/captures/arlindo-*.png`.
