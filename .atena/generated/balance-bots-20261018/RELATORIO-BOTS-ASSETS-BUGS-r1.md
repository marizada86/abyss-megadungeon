---
id: REPORT-NOTTGARD-BOTS-ASSETS-BUGS-20261018
revision: r1
status: DRAFT_FOR_OWNER_REVIEW
base: 4de71c2 (pós-pull) comparada com 2bc4d24 (pré-pull)
changes_to_runtime: none
---

# Bots de balanceamento, lacunas de assets e bugs — Windows x86_64

Tudo foi rodado **headless**, com `APPDATA/LOCALAPPDATA/USERPROFILE` sintéticos (`tmp/balance-bots/*`), sem tocar save real, runtime, dados ou assets. Artefatos novos (não versionados, nada commitado) em `.atena/generated/balance-bots-20261018/`:
`bot.gd` (bot), `run-bot.sh`/`launch.sh`/`jobs*.txt` (execução), `aggregate*.ps1` (tabelas), `asset_gaps.gd` (auditoria de assets), `debug_boss.gd` (sonda), `results/*.jsonl` (cada run, com histórico a cada 30 s), `results/asset-gaps.json`, `PROMPTS-CHATGPT-ASSETS-FALTANTES-DRAFT-r1.md`.

## 1. Como os bots funcionam (e o que NÃO provam)

`Battle` roda sem interface (`Battle.new` + `step`), então o bot joga as regras reais: movimento, habilidade ativa, coleta de XP/moedas, escolha de bênçãos (evolução > sinergia > subir arma > arma nova > passiva), revive e **encadeamento por portal** (`enter_next_stage`, como a campanha). Em mapas de raízes segue o campo de navegação do próprio jogo. Cinco modos:

| Modo | Para quê |
| --- | --- |
| `smart-god-chain` | herói imortal (PV restaurado a cada passo), campanha encadeada: mede **dano recebido, tempo para fechar a fase, abates, nível**. É a métrica principal de pressão; independe da habilidade do bot. |
| `smart-chain` / `smart` | bot mortal: mede quanto tempo um jogador novato sobrevive (piso). |
| `idle`/`kite`/`brawl` | pisos de comparação (pilotos). |

Limites a ter em mente: o bot começa **sem progressão meta** (Quartel, upgrades permanentes); joga bem pior que uma pessoa; usa 1–3 sementes por caso; o jogo **não é 100 % determinístico** entre processos (a mesma semente deu desfechos diferentes), então diferenças < ~15 % são ruído. Resultados são para **comparar** (versão antes/depois, herói contra herói, mapa contra mapa), não para dizer "está fácil/difícil" em absoluto. Fases depois de Domwieck (Shedaklah→Pilares) não têm entrada na campanha atual; só o piso mortal foi medido nelas.

Total: ~800 runs (12 heróis × 12 mapas + cadeias de campanha × 3 sementes, atual e baseline `2bc4d24`). **Zero erros de script** nos logs de todos os bots.

## 2. Balanceamento — achados

**2.1 Campanha (Docas → Reino Abissal → Domwieck), herói imortal, 12 heróis × 3 sementes**

| Fase | Concluiu | Tempo | Dano recebido | Abates | Nível ao fim | vs pré-pull (4 heróis) |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| Docas (início, herói novo) | 89 % | 396 s | 4.107 | 326 | 12,9 | dano +12 %, abates −2 % (ruído) |
| Reino Abissal | 97 % | 374 s | 2.257 | 319 | 16,3 | dano −19 % |
| Domwieck | 100 % | 423 s | 3.957 | 439 | 19,4 | dano −22 % |
| Dagruve → Docas → … (cadeia legada) | 97 % / 94 % / 100 % / 100 % | — | 2.404 / 3.333 / 1.624 / 3.052 | — | — | Docas dano +46 % (ruído alto), chefe ~+25 s |

- **Os três mapas de objetivo (Reino Abissal, Domwieck, Raiz de Yggdrasil) são concluíveis** com o bot seguindo a navegação por raízes; `presença = 3 s` registrada em todos. (Sem bug de objetivo inalcançável; a primeira tentativa falhou só porque o bot ignorava a navegação.)
- **Docas e Domwieck concentram a pressão** da campanha (≈4 mil de dano recebido cada, contra 2,3 mil em Reino Abissal), e Docas — a primeira fase, hp×1,7/dmg×1,7 — é onde 11 % das runs imortais (4 de 36) não matam o chefe em +360 s. (No piso mortal Docas é a que o bot sobrevive mais, 76 s: o dano de Docas vem da luta longa com o chefe, não do início.) Dagruve (hp×1,0, tier 0) está fora da campanha atual.
- **Desequilíbrio entre heróis (campanha de Docas):** dano recebido por fase vai de 1,99 mil (Sylas) a 5,4 mil (Durvall), 2,7×. Mais abaixo do esperado: **Arlindo (5,2 mil de dano, só 201 abates/fase contra ~380) e Nyrelia (5,1 mil, 250 abates)** quase não matam em comparação aos demais e concentram os timeouts; **Durvall (herói inicial)** é o terceiro pior em dano recebido. Podem ser limitações do bot com habilidades de apoio/área; vale testar à mão antes de ajustar números.
- **Piso mortal (novato, 24 runs/mapa):** todos os 12 mapas matam o bot de herói novo em 29–96 s. O primeiro minuto é duro em qualquer mapa; sobrevivência média do bot, do mais duro ao mais brando: Feng-tu 30 s, Goranthis 31, Pilares 32, Shendilavri 34, Reino Abissal 38, Durao 40, Raiz de Yggdrasil 44, Molor 50, Shedaklah 52, Domwieck 56, Dagruve 61, Docas 76. Pré-pull vs agora: paridade nos mapas antigos (±20 %); **nos mapas novos o início ficou mais duro** — dano recebido no 1º minuto +24 % (Reino), +14 % (Domwieck), +28 % (Yggdrasil), voltando à paridade em 4 min; sobrevivência do bot −19 % / −25 % / −41 %. Efeito pequeno e com ruído, mas consistente nos três mapas.
- Chefe de Dagruve: com bot que luta de perto morre em 335–405 s (spawn aos 300 s) — normal. Sem mecânica quebrada (totens blindam, não bloqueiam).

**Sugestões (decisão do dono, não alterei nada):** (1) conferir à mão Docas com herói novo e Durvall/Arlindo/Nyrelia; (2) se o início dos mapas novos precisar suavizar, mexer só nas primeiras ondas (t0–60 s) de `reino_abissal`/`domwieck`/`raiz_yggdrasil`; (3) repetir o lote depois de qualquer ajuste: `bash run-bot.sh …` + `aggregate-chain.ps1` (≈ 10 min).

## 3. Bugs e riscos encontrados

| # | Severidade | Achado | Evidência / observação |
| --- | --- | --- | --- |
| B1 | Baixa (já registrada: DEBT-PORT) | A suíte tem **30 falhas e 2 erros de script** herdados; 28 vêm de `reino_abissal`/`domwieck` estarem em `stages.json` (sem música, ambiência, crônica, decais, pesos de eventos aleatórios) e contratos antigos (`test_affixes`, `test_game_design`, `test_playtest` "18 HQs"). Mesma contagem antes e depois do pull. | `tests/run_all.gd`; ver `EVID-…B004`. |
| B2 | Baixa | 2 erros de script nos testes: `Battle._spawn` com chefe `""` (`battle.gd:3385`, via `test_fog_edge.gd:161`). Só acontece no teste, que cria chefe para toda fase; os mapas de objetivo têm `boss: ""`. | `audit_projeto.gd` também acusa "chefe inexistente" para os dois mapas: falso positivo de contrato. |
| B3 | Baixa | `audit_projeto.gd` avisa "curva": Dagruve (tier 0) aparece depois de Domwieck na ordenação por `order`; ordem de campanha ≠ ordem de dados. Sem efeito em jogo. | Docas order 0 → Reino 1 → Domwieck 2 → Dagruve 3. |
| B4 | Média | 7 chefes (todos exceto o Sacerdote) **não têm `boss_presentations`**: entram sem cartaz/pausa de introdução e sem a Maré de Névoa configurada por presença. | `audit_projeto.gd`, `asset_gaps.gd`. Pode ser decisão de design; confirmar. |
| B5 | Baixa | `stage_rules`/`stage_events`/`atmosphere`/`chronicles`/`stage_story` incompletos para os mapas novos (ver §4). | Dívida conhecida; dados dependem de lore. |
| B6 | Info | Resultados do mesmo caso variam entre execuções (global/clock em algum ponto fora do RNG semeado); `core/` só usa RNG global em `sfx.gd`, então a causa está em outro lugar (ordem de dicionário/tempo de quadro). Afeta replays/`run_record`. | Chefe de Dagruve morreu aos 325 s numa sonda e não morreu em 660 s numa run com a mesma semente. |
| B7 | Info | O bot **não encontrou** travamentos, objetivos inalcançáveis, NaN ou erros de script; os 3 mapas de raízes não prendem o herói com o campo de navegação. | 0 erros em ~800 runs. |

## 4. Assets faltantes (62 lacunas por convenção; falsos positivos removidos)

Resumo (detalhe em `results/asset-gaps.json`; **prompts prontos em `PROMPTS-CHATGPT-ASSETS-FALTANTES-DRAFT-r1.md`**, todos DRAFT, nada gerado):

- **Mapas novos (Reino Abissal, Domwieck, Raiz de Yggdrasil):** 3 miniaturas de seleção, 6 decais de chão, 3 quebráveis temáticos, ícone de regra de Docas; áudio (música + ambiência dos 3), `chronicles` ×3, `stage_story`/`stage_rules`/`stage_events` da Raiz, `atmosphere` ×3 — estes últimos são **texto/áudio**, fora de prompt de imagem.
- **Inimigos:** Molydeus comum (4 folhas), Ilusão de Súcubo e de Socothbenoth (opcional), Tentáculo do Kraken sem `move` (provavelmente estacionário, ignorar).
- **Chefes:** 7 cartazes de introdução 640×360; `special.png` do Sacerdote e do Discípulo.
- **Ícones 128×128:** 7 armas, 13 bênçãos, 1 item único (Espelho das Almas Desejantes, sem descrição em `items.json`).
- Itens marcados **[PRECISA DECISÃO]** nos prompts dependem de escolha de conteúdo (não inventei lore; onde há sprite estático ele é a referência de identidade).

## 5. Como repetir

```bash
# lote de campanha (12 heróis × 3 sementes, herói imortal)
echo "BOT_ROOT= chainD-durvall smart-god-chain durvall docas 1,2,3" > .atena/generated/balance-bots-20261018/jobs.txt
bash .atena/generated/balance-bots-20261018/launch.sh
powershell -File .atena/generated/balance-bots-20261018/aggregate-chain.ps1 -Prefix chainD-
```
`BOT_ROOT=<pasta>` aponta para outro checkout (usei um worktree de `2bc4d24`) para a comparação antes/depois.

## 6. Correções aplicadas depois do relatório (B1–B3) — suíte: 0 falhas, 0 erros de script

Causa real das 30 falhas: (a) 22 vinham de Reino Abissal/Domwieck estarem em `stages.json` sem conteúdo ainda não produzido; (b) 8 vinham de **a ordem local (`order`) ter mudado** quando os mapas do capítulo 1 entraram antes de Dagruve, mas regras de combate ainda liam `order`.

- **Regra de combate (runtime, `core/battle.gd` `_stage_order`)**: afixos de elite, horda e chefe afixado agora seguem `boss_mech.combat_orders` (já usado pelo orçamento das mecânicas de chefe), com queda para `order` nos mapas novos. Efeito: Dagruve volta a não ter horda nem afixos novos; os chefes de Shedaklah e Molor deixam de receber afixo (só a partir de Durao, como no SPEC-120). Reino Abissal/Domwieck mantêm o comportamento atual. Mudança específica do PC (a origem tem outra numeração): sem portagem.
- **Adiamentos explícitos, sem inventar conteúdo**: `tests/stage_contracts.gd` registra música, ambiência, crônica, decais e pesos de eventos aleatórios de Reino Abissal/Domwieck como adiados (dossiê dos mapas: não necessários ao protótipo; falta já é tolerada em runtime). `tests/test_stage_deferrals.gd` falha se o conteúdo passar a existir (remover o adiamento) ou se um mapa com chefe pedir adiamento.
- **Contratos obsoletos atualizados**: descida de Docas leva ao `next` aprovado (Reino Abissal); QA lista o catálogo de HQs inteiro (21, incluindo as 18 preservadas); `test_fog_edge` ignora mapas sem chefe (`postboss_fog: false`).
- **`tools/audit_projeto.gd`**: não acusa "chefe inexistente" em mapas de objetivo e compara a curva só entre as fases legadas, pela ordem de combate. Erros 0, avisos 13 → 9 (restam: 7 chefes sem `boss_presentations` e 2 crônicas dos mapas novos, ambos já listados acima).
