---
id: IDEA-NOTTGARD-BONUS-MAPS-20261019
revision: r1
status: DRAFT_IDEA_RECORDED_NOT_APPROVED
content_state: DRAFT
origin: decisão B1 da 0.5.0 (2026-10-19)
implementation: NOT_AUTHORIZED
---

# Mapas bônus desbloqueados por quest — registro da ideia

## A ideia (palavras do dono)

Fazer os mapas novos como **mapa bônus, desbloqueado ao completar uma missão (quest) no mapa anterior**, servindo como uma opção para o jogador **"farmar" recurso para seguir a run**. Aceita recomendações.

## Decisão para a 0.5.0

Registrar a ideia e **manter a campanha como está** (Docas → Reino Abissal → Domwieck, contrato do capítulo 1 aceito em 2026-10-17). Nenhum código, dado ou fluxo muda por causa deste documento.

## O que a ideia toca (para planejar sem surpresa)

| Área | Hoje | Impacto se virar mapa bônus |
| --- | --- | --- |
| Campanha | `ChapterFlow`: `docas_cleared` abre Reino Abissal; `reino_abissal_cleared` abre Domwieck; `next` encadeia as fases | Reino Abissal/Domwieck saem da trilha obrigatória; a progressão para o resto precisa de outro caminho |
| HQs | HQ18 dispara em `reino_abissal`; HQ03 em `domwieck`; fila de apresentação por marcos | Gatilhos narrativos teriam de migrar para a trilha principal ou para a quest |
| Mapa de objetivo | 360/420 s, alcançar um ponto e permanecer 3 s; sem chefe; sem recompensa de abate | "Farmar recurso" pede economia própria (moedas/XP/drops), hoje desligada ao concluir por objetivo |
| Quests | Não há sistema de quest genérico; há `stage_events`, rituais, câmaras e Ecos por fase | Precisa de definição da missão (onde, condição, falha, repetição) |
| Saves | `campaign_progress` (versão 1) com marcos | Novo marco/quest exige migração e teste de save (modelo: `test_save_upgrade_050`) |

## Perguntas em aberto (para a spec real)

1. **Quais** mapas: só a Raiz de Yggdrasil (hoje QA-only) ou também Reino Abissal/Domwieck?
2. **Qual quest** desbloqueia e em qual mapa (ex.: um objetivo opcional dentro de Docas)?
3. **Recompensa de farm:** moedas, XP, itens, essência? Vale a build da run em curso ("para seguir a run") ou só meta-progressão?
4. **Repetição:** pode rejogar sempre? Há custo (tempo, risco) ou limite por run?
5. **Risco de exploração:** farm infinito sem pressão quebra o balanceamento; os bots (`balance-bots-20261018`) já medem pressão e podem validar a economia.
6. **Narrativa:** o mapa bônus é canônico no Vault ou só mecânica? (O Vault atualizado não traz notas novas de Reino Abissal.)

## Recomendação

Começar pela **Raiz de Yggdrasil** como primeiro mapa bônus (não há contrato de campanha nem HQ presa a ela, já tem arte e navegação aceitas), com uma quest simples em Docas ou Reino Abissal, e só depois decidir se Reino Abissal/Domwieck migram. Passos prováveis: spec da quest → dados (`stage_events`/marco) → economia do mapa → teste de save → bots para validar o farm → playtest.
