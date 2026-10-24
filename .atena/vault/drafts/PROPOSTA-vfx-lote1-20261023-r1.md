# Proposta — VFX e "dopamina", Lote 1 (2026-10-23, r1)

Status atual: DRAFT, **escopo e 17 fontes aprovados; integração técnica concluída em 2026-10-23, aguardando playtest humano**. Evidências em .atena/generated/vfx-lote1-20261023-r1/integration-evidence.md. Sem commit ou publicação. O restante deste documento preserva a proposta e suas decisões históricas. Origem pedido do dono em chat (Cera Fervente básica, projéteis dos inimigos e dos chefes, tudo que for visual básico). Fila de arte correspondente: `ASSET-QUEUE-VFX-LOTE1-20261023-r1.md`. Prompts, manifesto e prancha de referência: `.atena/generated/vfx-lote1-20261023-r1/`. A geração é manual, no ChatGPT.

## 1. Problema (evidência no código)

| Ponto | Hoje | Onde |
|---|---|---|
| Cera Fervente e Inferno de Cera | elipse chapada e três tracinhos; o evento de lançamento só faz um anel de 0,25 s; a evolução usa o mesmo desenho, só com raio maior | `ui/overlay.gd` `_draw_wax_fire`; `ui/run.gd` evento `zone` |
| Projéteis dos inimigos | um círculo vermelho com miolo claro, igual para 9 atiradores e para todos os anéis de chefe | `ui/overlay.gd` (`pr.owner != "hero"`) |
| Golpes radiante e de fogo | radiante cai num polígono de 0,16 s; fogo usa um arco procedural | `core/melee_vfx.gd` (só dtype físico), `ui/run.gd` `_swing` |
| Acerto comum | só número flutuante e som; faísca só com tema divino | `ui/run.gd` evento `hit` |

## 2. Escopo do Lote 1: 17 folhas

| Grupo | Folhas | Resultado |
|---|---|---|
| Cera | F01 lançamento, F02 corpo da poça, F03 chamas da poça, F04 lançamento do Inferno, F05 chamas do Inferno | Cera ganha queda, respingo, poça com corpo e chamas; Inferno de Cera tem lançamento e chamas próprios (corpo reaproveitado e tingido) |
| Projéteis inimigos | F06 flecha, F07 esporo, F08 orbe abissal, F09 orbe infernal, F10 bala de chefe | cada atirador tem família com voo e impacto; todo anel de chefe usa F10 tingida por chefe |
| Golpes | F11 arco radiante, F12 arco de fogo | Golpe do Juízo, Martelo da Luz e da Glória; Tocha e Machado de Xar'gath |
| Faíscas de acerto | F13 físico, F14 mágico, F15 fogo, F16 radiante, F17 crítico | todo acerto em inimigo ganha impacto; crítico ganha estouro próprio |

Mapa de atiradores (de `data/enemies.json`):

| Família | Inimigos |
|---|---|
| `inimigo_flecha` | `cultista_arqueiro` |
| `inimigo_esporo` | `esporo_voador`, `discipulo_pestilento` |
| `inimigo_orbe_abissal` | `cultista_thullgrime`, `arch_hag`, `cultista_de_socothbenoth`, `sucubo` |
| `inimigo_orbe_infernal` | `master_of_cruelties`, `malcanthet` |
| `bala_de_chefe` | todo `ring`: `sacerdote_mente_derretida`, `zuggtmoy`, `molydeus_chefe`, `manifestacao_de_juiblex`, `lu_yueh`, `malcanthet`, `socothbenoth`, `death_tyrant`, `sintese_abissal`, e os anéis de fase de `boss_phases.json` |

## 3. Formato das folhas

Segue exatamente os contratos já aceitos, para reaproveitar carregadores e testes.

- **6 quadros, 1536×256** (células de 256, pivô no centro): F01–F05, F11–F17. Mesmo layout de `MeleeVfx`, `HeroAbilityVfx`, `RadiantPulseVfx`.
- **8 quadros, 2048×256** (voo 0–3 em loop, impacto 4–7 uma vez): F06–F10. Mesmo layout de `ProjectileVfx`.
- **Aditivas:** branco/colorido sobre preto, convertidas em alfa; F02 é a única opaca (chave magenta).
- **Margem mínima de 8%** por célula, sem quadro vazio e sem corte nas bordas (checagem automática).
- Geração em tela 1536×1024; recorte e recomposição na preparação (seção 6).

## 4. Prompts

Um arquivo por folha em `.atena/generated/vfx-lote1-20261023-r1/prompts/`. Cada um compõe quatro blocos: estilo comum, regra de fundo (preto aditivo ou magenta chave), grade (6×1 ou 4×2) e descrição do efeito, quadro a quadro. Todos pedem a prancha `ref-existing-vfx.png` como anexo. Os blocos comuns são os mesmos nos 17, de propósito: se o piloto (F03, F06, F13) pedir ajuste de estilo, muda-se uma vez.

## 5. Código

Tudo é só apresentação: posição, dano, colisão e RNG do `Battle` não mudam. "Reduzir efeitos de impacto" continua desligando os sprites e mantendo o desenho antigo.

1. **`core/projectile_vfx.gd`:** nova tabela `ENEMY_FAMILIES` e `enemy_family_for(projectile)`. `family_for` continua só para o herói (o teste atual exige isso). O mesmo carregador de atlas serve. Pivô e escala por família em constante, como nas famílias do herói.
2. **`core/battle.gd`, três pontos de criação de projétil inimigo** (tiro, anel de habilidade, anel de fase de chefe): acrescentar metadado visual `"src": e.id` e, nos anéis, `"ring": true`. Nenhuma lógica lê esses campos. **Decisão sua:** é a única mudança fora de camada de apresentação.
3. **`ui/run.gd`:** `_sync_projectile_vfx` passa a tratar também os projéteis inimigos; o impacto toca ao acertar o herói ou no fim do alcance. Limite de segurança de sprites simultâneos (~80); acima disso o círculo antigo volta. Tinta por chefe para F10 em tabela.
4. **`ui/overlay.gd`:** o círculo vermelho vira fallback (reduzir impacto, folha ausente, limite). Para projétil com sprite, um disco escuro de baixa opacidade sob o sprite garante contraste em chão claro, já que as folhas são aditivas.
5. **Cera, `core/wax_vfx.gd` novo:** `supports`, `create_cast` (F01/F04 no evento `zone`) e o nó persistente da poça (corpo F02 achatado em isométrica, tingido por `modulate`, mais chamas F03/F05 em pé), sincronizado com `battle.zones` como já se faz com projéteis. Entrada e saída com fade pela vida da zona. `_draw_wax_fire` fica como fallback. Corpo no nó `Under`; chamas e lançamento em `Fx`. Cada tick de dano já gera evento `hit`, então a faísca F15 dá o feedback de tick sem código extra.
6. **`core/melee_vfx.gd`:** duas formas novas por ID de arma, não por dtype amplo (`arco_radiante`: `golpe_do_juizo`, `martelo_da_gloria`, `martelo_da_luz`; `arco_fogo`: `tocha_do_incendiario`, `machado_de_xargath`). `romper_armadura` e demais físicos ficam como estão. `FireSwingVfx` continua como fallback quando a folha falta.
7. **`core/hit_spark_vfx.gd` novo:** `kind_for(dtype, crit)`, `create_effect`; chamado no evento `hit` de `run.gd`. Rotação derivada do `tid` (sem RNG do jogo), limite de ~8 vivos, escala maior para elite e chefe, nada com impacto reduzido.

Sem mudança em dados de armas, balanceamento, saves ou IDs.

## 6. Preparação técnica das imagens

Job novo `tools/asset_jobs/vfx_lote1_v01.json` com `tools/asset_prep.gd` (já tem chave preta, magenta e recorte por grade). Passos: recortar a faixa central, fatiar a grade, normalizar para células de 256 px com pivô no centro, recompor as folhas de 8 quadros em 2048×256 e gerar prancha de revisão sobre fundo escuro. Pode exigir um passo novo de "grade 4×2 para tira" no `asset_prep.gd`; será registrado se for o caso. Sem pacote novo.

## 7. Testes

Pelo runner existente (`godot --headless --path . -s tools/run_one_test.gd -- <nome>`), sem carregar o save real.

- **`test_wax_vfx.gd` (novo):** só `cera_fervente` e `inferno_de_cera` roteiam; `colar_dos_tentaculos` não; impacto reduzido ignora; folhas 1536×256 com seis células não vazias e margem de 8%; escala monotônica com o raio; o evento não é alterado; fallback procedural quando a folha falta.
- **`test_enemy_projectile_vfx.gd` (novo):** dirigido por dados: todo `shoot` de `enemies.json` mapeia para uma família, todo `ring` (inclusive os de `boss_phases.json`) para `bala_de_chefe`; a tabela de tintas cobre os chefes com anel; projéteis do herói não mudam de família; folhas 2048×256 com oito células não vazias; limite de sprites e impacto reduzido.
- **`test_hit_spark_vfx.gd` (novo):** tipo certo para os quatro dtypes e crítico; dtype desconhecido não gera efeito; limite de vivos; RNG do `Battle` intocado; folhas 1536×256.
- **Ajustes em existentes:** `test_melee_vfx.gd` (novas formas), `test_fire_swing_vfx.gd` (hoje exige que o kit de golpes **não** capture o fogo; passa a exigir o contrário quando a folha existe e o `FireSwingVfx` como fallback) e `test_projectile_and_ability_vfx.gd` (mantém o roteamento do herói). `test_vfx_sfx_coverage.gd` já protege `romper_armadura` de ser coberto por dano radiante e deve continuar passando.
- **Desempenho:** cenário de estresse no `tools/smoke.gd` com ~60 projéteis inimigos e três poças de cera, medindo o tempo de quadro (`core/frame_stats.gd`), antes e depois.
- **Suíte completa** (`tests/run_all.gd`) e `controller_check` com as duas falhas e o timeout herdados confirmados como inalterados.

## 8. Passos e checkpoints

1. **Aprovação de escopo** (esta proposta). Só então registrar a seção no `.atena/state/plan.yaml`.
2. **Piloto:** gerar F03, F06 e F13 no ChatGPT; revisão de estilo, tamanho e legibilidade (a 36–56 px).
3. **Demais folhas** (14), com até três candidatas por peça; aceite visual do dono por ID/revisão/hash.
4. **Preparação** das imagens e galeria de revisão.
5. **Código e testes**, na ordem: acerto (F13–F17), projéteis inimigos (F06–F10), golpes (F11–F12), cera (F01–F05). A ordem leva a melhoria mais barata e mais frequente primeiro.
6. **Validação no jogo:** captura de tela por cena, medição de desempenho e **playtest**; o aceite das fontes não prova diversão em jogo.

Sem commit, push, build ou publicação nesta proposta; cada um exige pedido seu.

## 9.1 Decisões tomadas (2026-10-23, r1.1) — substituem o que segue onde divergir

- **Escopo das 17 folhas e metadado `src`/`ring`:** aprovados; o metadado já está aplicado em `core/battle.gd`.
- **Golpe de fogo:** o `test_fire_swing_vfx.gd` **não muda**. O sprite F12 entra dentro do `FireSwingVfx` (fallback procedural sem folha ou com impacto reduzido). O `MeleeVfx` fica com o kit físico e as três armas radiantes por ID (seção 5, item 6, e os ajustes de teste da seção 7 ficam assim: só acrescentar testes).
- **Bala de chefe (F10):** tinta pela cor do inimigo em `enemies.json`, clareada até um brilho mínimo; sem tabela nova; o teste confere cor e brilho de todo chefe com anel.
- **Corpo da poça (F02):** neutro claro, tingido por código; avaliado quando a folha chegar, com F02b (corpo carmim do Inferno) como plano B.

## 9. Decisões que preciso de você (histórico, já respondidas em 9.1)

1. Aprovar o escopo das 17 folhas, com o piloto de três.
2. Aprovar o metadado visual `src`/`ring` nos três projéteis de `battle.gd` (alternativa: família só pelo dtype, que perde o anel dos chefes e o mapa por inimigo).
3. Aprovar a mudança do `test_fire_swing_vfx.gd`, que hoje fixa o comportamento antigo.
4. Confirmar a tinta neutra do corpo da poça (F02) e da bala de chefe (F10), tingidas pelo código.

## 10. Riscos

- O ChatGPT não garante pixels exatos nem loop perfeito: mitigado pelo piloto, pelas três candidatas e pela normalização na preparação.
- Leitura do lote de projéteis inimigos sobre chão claro: mitigada pelo disco escuro de contraste; confirmar em captura.
- Excesso de efeitos em tela: mitigado pelos limites de sprites e de faíscas e pela opção "Reduzir efeitos de impacto".
- Sem a ordem de camadas verificada em execução (`Under` / `Sorted` / `Fx`), a poça de cera pode cobrir ou ficar sob inimigos: o desenho exato é confirmado na leitura de `run.gd` na etapa 5.
