---
id: DRAFT-NOTTGARD-CHRONICLES-NEW-MAPS-20261019
revision: r1
status: DRAFT_AWAITING_OWNER_APPROVAL
content_state: DRAFT
origin: decisão B5 da 0.5.0 ("eu redijo rascunho a partir do vault")
source: F:\dev\nottgard-vault (cópia local, somente leitura; último commit 8472f7a, 2026-10-17)
---

# Crônicas dos mapas novos — rascunho para aprovação

Regras seguidas: paráfrase curta do Vault, sem lore nova, no estilo das crônicas aprovadas (SPEC-117 H4), ≤ 420 caracteres,
sem nenhum dos termos vetados pelo teste (`amuleto`, `durvall`, `se torna adam`, `vira adam`), sem citar o segredo do mestre
(colar/amuleto; fusão de Durvall com Astherion). **Nada foi gravado em `data/chronicles.json`**: só entra depois do seu aceite.

| Mapa | Título | Texto | `fonte_vault` |
| --- | --- | --- | --- |
| Reino Abissal | A legião no reino | Por uma passagem sob a Igreja das Sombras, o grupo chegou ao Reino Abissal. A sessão terminou diante de uma legião de demônios, notívagos e cultistas. Mais tarde, a rota do grupo passaria por Durao, Molor e Feng-tu. | 04_Locais/Reino Abissal (Sessões 11 e 17) |
| Domwieck | A invasão por Domwieck | Domwieck, o distrito élfico construído ao redor de Ailalore, foi por onde o exército abissal entrou em Nottgard: um portal aberto ali espalhou a destruição até a Floresta de Ailalore. | 04_Locais/Domwieck (Sessão 12) |
| Raiz de Yggdrasil (QA-only; hoje fora de `stages.json`, não aparece no Diário) | A raiz entre os planos | Puxados por um portal, Leoric e Korrak chegaram a uma raiz de Yggdrasil, a árvore interplanar. A raiz levava a um tronco aparentemente infinito e abria uma rota difícil entre os planos. | 04_Locais/Yggdrasil (Sessão 15) |

Conferido em 2026-10-19 contra o registro atualizado das Sessões 11 (descida ao Reino Abissal pela passagem sob a Igreja das Sombras) e 12 (o exército abissal entrou por Domwieck e atacou Ailalore); o registro de sessão prevalece sobre a prosa derivada e confirma os fatos usados.

## Pontos que merecem sua atenção

- A nota **Reino Abissal.md** do Vault é curta (duas sessões); o texto acima não vai além dela. Se o Vault atualizado tiver mais detalhe aprovado, prefira acrescentá-lo lá primeiro.
- **Domwieck** é, no Vault, a cidade humana de Aluris usurpada pelos elfos (revelada ao grupo na S9). Deixei essa identidade fora porque a crônica trata da invasão (S12); posso incluí-la se quiser.
- Cronologia: a crônica do Reino Abissal cita a rota futura (Sessão 17); se a ordem de leitura na campanha nova (Reino Abissal antes de Domwieck) pedir menos antecipação, removo a última frase.

## Como aplicar depois do aceite (escopo pequeno)

1. Inserir as duas primeiras entradas em `data/chronicles.json` (a terceira só quando a Raiz virar fase de `stages.json`).
2. Remover `"chronicle"` das listas de `reino_abissal` e `domwieck` em `tests/stage_contracts.gd` (o `test_stage_deferrals` falha enquanto o adiamento existir).
3. Rodar `bash tools/validate_release.sh`.
