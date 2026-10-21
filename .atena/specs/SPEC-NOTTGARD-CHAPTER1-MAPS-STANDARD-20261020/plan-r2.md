---
id: PLAN-NOTTGARD-CHAPTER1-MAPS-STANDARD-20261020
revision: r2
status: DRAFT_DECISIONS_RECORDED_AWAITING_BATCH_APPROVAL
content_state: DRAFT
origin: owner request during playtest observation (2026-10-20)
approval_mode: per-batch
implementation_authorized: false
---

# Mapas do capítulo 1: vitória de Domwieck, duração de 3 minutos e paridade com o padrão do jogo

Pedido do dono (2026-10-20, observando o playtest): (1) ao vencer Domwieck não há opção de continuar; (2) reduzir para 3 minutos o tempo dos 3 primeiros mapas; (3) plano para deixar os mapas novos no padrão do jogo, "ainda falta muita coisa". Este documento é só planejamento: nenhum dado, código ou estado (`plan.yaml`) foi alterado por ele.

## 1. Achados (inspeção local, 2026-10-20)

### 1.1 Vitória de Domwieck sem "continuar"

- `Battle.complete_stage("objective")` ([core/battle.gd:817](../../../core/battle.gd)): se o mapa não tem `next`, vai direto a `state = "won"`; senão cria o portal e avisa "Retornar a Nottgard (E/oeste) ou extrair (X/norte)".
- Domwieck tem `"next": ""` em `data/chapter_flow.json` (e em `stages.json`), então a run **acaba no instante em que a presença de 3 s fecha**. Não há portal, nem escolha, nem tempo para saquear antes do resultado.
- "Continuar" no jogo é `enter_next_stage()`: desce para o mapa seguinte na mesma run, com cura parcial e multiplicador de recompensa (é o que Docas → Reino Abissal já faz). Em Domwieck não existe próximo mapa; o capítulo 2 está adiado no contrato.
- O contrato do capítulo 1 diz que o capítulo fecha com a HQ03 e destino `result_then_menu`. Isso não proíbe um portal de "continuar", mas hoje o contrato e o jogo não preveem nenhum.

### 1.2 Duração dos mapas

| Mapa | Hoje | Como a duração é usada |
| --- | --- | --- |
| Docas (existente, contrato "preserve_current") | 300 s | Chefe `guardiao_verdadeiro` entra ao fim; portal depois |
| Reino Abissal | 360 s | Objetivo "chegar e segurar 3 s" só vale depois do tempo; ondas param na duração |
| Domwieck | 420 s | Idem |

Mudar só `duration` **não basta**: `t0`/`t1` das ondas, `at` dos elites, a horda (fração da duração), `stage_events`, `stage_rules` e `level_design` usam segundos absolutos. Em Docas, por exemplo, os elites em 225 s e 165 s e a onda que começa em 170 s deixariam de existir ou ficariam espremidos. Além disso:

- Docas é "preservar balanceamento atual" no contrato r1; reduzi-la exige contrato r2 (revisão registrada).
- Regra da triagem 0.5.0: balanceamento não muda por relato isolado (3+ testers, ou 1 relato + bots). Aqui é decisão do dono, mas deve ser registrada como tal, não como achado de playtest.
- Hipótese B1 dos bots já aponta mapas novos com +14–28 % de dano no primeiro minuto; encurtar concentra a dificuldade e o XP em menos tempo.
- A build 0.5.0 está congelada; qualquer mudança vai para a 0.5.1.

### 1.3 Lacunas dos mapas novos em relação ao padrão (Reino Abissal e Domwieck vs. Docas e demais)

| Item | Mapas antigos | Reino Abissal / Domwieck |
| --- | --- | --- |
| `atmosphere`, `scenery`, `ground_decals`, `chronicles`, `difficulty`, `secrets` | presentes | **ausentes** |
| `ambient` (poças, neblina etc.) | presente | vazio |
| Interações por mapa | 17 tipos | 7 (faltam ritual, ampulheta, doação, aposta, pacto de sangue, relicário, peregrino, contador, carroça, eclipse; eventos aleatórios "desligados" são conteúdo provisório conhecido) |
| Elites | 3 | 2 |
| Chefe / conquistas ligadas ao mapa | sim | sem chefe (contrato); sem conquistas próprias |
| Música | por mapa | reaproveitada |
| Arte | kit próprio | Domwieck tem `domwieck_art`; Reino Abissal usa `root_art` provisório |
| Crônicas / diário do mapa | sim | ausentes (conhecido) |
| Chaves de `stages.json` | base | completas, mais `completion` (ok) |

Restrições do contrato que seguem valendo: sem novos inimigos, sem novas dependências, sem Adam morto, sem acesso a save real, sem abrir capítulo 2, mapas 60×60.

## 2. Decisões do dono (registradas em 2026-10-20)

- **D1 = A, com extensão:** a vitória de Domwieck não encerra a run; abre o portal e o jogador pode extrair (X) ou **continuar para Dagruve, e dali pela cadeia antiga** ("segue para Dagruve e por aí vai"). Isto vai além do portal de retorno simples da opção A do r1 e toca a estrutura de capítulos (ver 2.1).
- **D2:** os 3 primeiros mapas são **Docas, Reino Abissal e Domwieck**; depois vêm Dagruve, Shedaklah, Molor, Durão, Feng Tu, Shendilavri, Goranthis e Pilares.
- **D3:** **180 s exatos** para os três (inclui o chefe de Docas aparecendo aos 180 s e o objetivo de chegada liberando aos 180 s).
- **D4:** escopo do "padrão do jogo" = **só dados e ambiente** (lote C). Arte, música e crônicas (lote D) ficam fora deste plano.

### 2.1 Consequências técnicas de continuar para Dagruve (achados de 2026-10-20)

1. `dagruve.next` ainda é `docas` (cadeia antiga Dagruve → Docas → Shedaklah). Com `domwieck.next = dagruve` isso criaria laço Dagruve → Docas → Reino → Domwieck → Dagruve. Precisa de `dagruve.next = shedaklah` (e `shedaklah.unlock` já é `dagruve`). `docas.next` já é `reino_abissal`.
2. `ChapterFlow.stage_allowed` só conhece Docas, Reino e Domwieck (mais acesso legado por perfil antigo). Jogador novo não teria Dagruve e os demais liberados no menu depois de limpar Domwieck. Estender para seguir o campo `unlock` da cadeia, **sem** dar acesso retroativo a perfis existentes além do que já têm e sem recompensas de migração.
3. Dagruve é nível 0 (`hp_mult` 1,0, 300 s, chefe Sacerdote da Mente Derretida), logo depois de Domwieck, que é nível 3 (`hp_mult` 2,2). Em continuação, o inimigo ficaria mais fraco que no mapa anterior. **Pergunta D5** abaixo.
4. O contrato do capítulo 1 diz que o capítulo fecha em Domwieck com HQ03 e destino `result_then_menu`, sem abrir o capítulo 2. A HQ03 e o marco `chapter1_closed` continuam disparando ao limpar Domwieck, mas o título "Capítulo 1 concluído" do resultado só aparece quando a run termina em Domwieck; numa run que continua, ele não apareceria. Ajustar o aviso para o momento da limpeza.
5. A adaptação de Dagruve para o encontro com Thalion segue fora de escopo (`is_dagruve_encounter` é só do modo QA isolado).
6. Isto exige **contrato r2 de `chapter_flow`** (Docas deixa de ser "preserve_current"; Domwieck passa a ter `next`) e registro de portagem, pois a cadeia é dado compartilhado.

### D5 (nova, bloqueia só o trecho "Dagruve" do lote A)
Como tratar a dificuldade de Dagruve quando vem depois de Domwieck?
- **Manter os valores atuais de Dagruve** (recomendado por ora): não mexer em balanceamento sem dado; o dano/vida já escalam com a profundidade da descida (`descent_depth`), e os bots dirão se há queda abrupta.
- Reclassificar Dagruve como tier mais alto na cadeia: mexe em balanceamento, só com bots.

## 3. Lotes propostos (per-batch, cada um com aprovação própria)

### Lote A: vitória de Domwieck e continuação da cadeia (candidato à 0.5.1)
1. `complete_stage("objective")`: com `next` definido, criar o portal e o aviso "Continuar: Dagruve (E/oeste) ou extrair (X/norte)" em vez de `state = "won"`; limpeza idempotente e sem XP/loot, como hoje.
2. Dados: `domwieck.next = "dagruve"`; `dagruve.next = "shedaklah"` (D5 define se Dagruve muda de valores). Atualizar `chapter_flow` (contrato r2) e `stages.json` de forma consistente.
3. `ChapterFlow.stage_allowed`/`next_stage`: liberar Dagruve ao limpar Domwieck e seguir a cadeia pelo campo `unlock`; migração idempotente, sem recompensa nem acesso retroativo novo.
4. Resultado e HQ03: marco `domwieck_cleared` e HQ03 uma única vez ao limpar (já ocorre no clear); aviso "Capítulo 1 concluído" no momento da limpeza, não só no resultado de Domwieck.
5. Testes: `test_battle`, `test_stage_progress`, `test_reach_grid`, `test_profile`/migração, fluxo de `chapter_flow` (sem HQ duplicada, replay, retomada, perfil novo × legado × limpo até Domwieck), cadeia sem laço (teste novo: percorrer `next` de Docas até Pilares sem repetir), smoke. Perfil sintético, nunca o save real.

### Lote B: duração de 3 minutos, 180 s exatos (balanceamento; contrato r2, junto com o lote A)
1. Contrato r2 de `chapter_flow` (Docas deixa de ser "preserve_current").
2. Reescalar os cronogramas por fator 180/duração original (Docas 0,6; Reino Abissal 0,5; Domwieck ≈ 0,43; fatores = 180/duração atual): `t0`, `t1`, `at` dos elites, eventos de fase, regras e `level_design`. Manter o teto de inimigos e decidir se densidade (`every`, `max`) sobe para não esvaziar o mapa.
3. Conferir o que depende da duração: horda (`HORDE_AT`), fim das ondas, `skip_seconds` da névoa, objetivo de chegada, tempo útil de XP e de baús (menos level-ups por run; revisar recompensa).
4. Validar com os bots (baseline `balance-bots-20261018`) antes e depois, e com um playtest curto. Hipótese B1 passa a ser vigiada de perto.
5. Portagem registrada (dado compartilhado) ou divergência anotada.

### Lote C: paridade de dados e ambiente (sem arte nova)
1. Criar as entradas de `atmosphere`, `scenery`, `ground_decals`, `difficulty`, `secrets` e `ambient` para Reino Abissal e Domwieck, reaproveitando assets locais já aceitos.
2. Ampliar interações de 7 para o conjunto dos antigos que fizerem sentido, reativando eventos aleatórios no mapa novo (pesos em `stages.json`), e avaliar o terceiro elite.
3. Auditoria cruzada ("matriz de paridade" por arquivo de `data/`) como teste, para impedir que um mapa novo entre sem as entradas obrigatórias.

### Lote D: apresentação e conteúdo (FORA DESTE PLANO por D4)
Música própria, arte do Reino Abissal (hoje `root_art`), crônicas e diário, conquistas dos mapas, capas/quadros que ainda faltam. Cada item exige decisão do dono; arte e texto seguem DRAFT até aceite.

### Lote E: validação final
Suíte completa (G1), auditoria (G2), smoke do exe (G4), upgrade de save (G5), capturas 1280×720 e 1920×1080, teclado e controle; **uma instância do Godot por vez**.

## 4. Ordem e vínculos com a 0.5.1

1. **Lote A** primeiro: bug de fluxo, baixo risco, não mexe em balanceamento.
2. **Lote C** em paralelo ao A (arquivos distintos), por ser dado sem balanceamento.
3. **Lote B** (D2/D3 respondidas) com bots rodando antes/depois; o contrato r2 é compartilhado com o lote A.
4. **Lote D** conforme a produção de arte/canon, fora da 0.5.1.
5. Itens já prontos no working tree, sem commit, para a 0.5.1: efeito visual da Bola de Fogo e da Tocha do Incendiário ([core/fire_burst_vfx.gd](../../../core/fire_burst_vfx.gd), [core/fire_swing_vfx.gd](../../../core/fire_swing_vfx.gd)).

## 5. Riscos

- Encurtar sem reescalar o cronograma deixa elites e chefe sem espaço (item 1.2).
- Portal em Domwieck não pode duplicar HQ03, marco ou recompensa; testar saída por portal, por X e por morte logo após o objetivo.
- Mapas novos sem entradas de ambiente podem cair em padrões herdados do mapa anterior; a matriz de paridade (lote C.3) fecha isso.
- Nada é commitado, exportado nem publicado sem pedido explícito; mudar dado comum exige portagem.
