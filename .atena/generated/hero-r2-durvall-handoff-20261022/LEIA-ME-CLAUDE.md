# Passagem para Claude — Durvall R2 / gate 1

Preparado em 2026-10-22, a pedido do dono: “atena, deixe pronto para o claude receber”. Este documento trata apenas de Durvall R2; não substitui a passagem da frente geral de assets.

## Ponto de retomada

Projeto operacional: `F:/dev/abyss-megadungeon`. Leia `AGENTS.md`, `.atena/add.yaml` e a seção `hero_art_reset_20261021` de `.atena/state/plan.yaml` antes de atuar. Os arquivos globais citados em `C:/Users/gui-m/.codex/AGENTS.md` e `RTK.md` não foram encontrados neste PC.

Gate 1 permanece **REPROVADO tecnicamente**, com duas tentativas efetivas por imagem. Foram gerados somente idle SE e caminhada SE, v01 e v02. Nada das demais direções, Korrak ou Erik foi gerado nesta conversa. Nenhuma integração no jogo, alteração de saves, commit, push ou publicação foi feita nesta frente. Conteúdo continua DRAFT.

O dono disse **“aprovado, continue” após as duas v01**. Preserve esse aceite visual. As v02 surgiram depois, para corrigir bordas e pontos soltos; não houve aceite visual explícito delas. O dono pediu um GIF e depois esta passagem. Não interpretar esses pedidos como aprovação técnica ou autorização de integração.

## Abrir primeiro

Todas as entregas ficam em `F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall/`:

- `durvall_gate1_preview_v02.gif`: idle e caminhada v02 lado a lado.
- `durvall_idle_se_v01.png` e `durvall_walk_se_v01.png`: originais com aceite visual.
- `durvall_idle_se_v02.png` e `durvall_walk_se_v02.png`: segunda tentativa técnica.
- `gate1-review-v02.md`: medição consolidada e complemento literal dos prompts v02.
- `gate1-idle-v01.json`, `gate1-walk-v01.json`, `gate1-idle-v02.json`, `gate1-walk-v02.json`: resultados completos.
- `gate1-generation-receipt-v01.md`: proveniência e desvio no número de referências aceitas pela ferramenta.

PNG original preservado sem edição em todas as versões. O GIF é um derivado de prévia; não é uma folha pronta para integração.

## Resultado técnico

| Fonte | Figuras | Desvio de escala | Desvio dos pés | Halo, limite 2% | Pontos soltos | A/P e B/P |
|---|---|---|---|---|---|---|
| Idle v01 | 3/3 | 0,2% | 0,0% | 49,5% | 56 | n/a |
| Walk v01 | 3/3 | 3,8% | 0,3% | 50,5% | 48 | 37,0%; 35,8% |
| Idle v02 | 3/3 | 0,2% | 0,0% | 34,8% | 0 | n/a |
| Walk v02 | 3/3 | 3,5% | 0,1% | 41,2% | 17 | 34,5%; 35,7% |

Todas as figuras estão inteiras e sem tocar na borda. O critério automático da passada compara A e B com P; ele **não prova** que A e B têm pernas opostas. Confira isso no GIF e nas fontes antes de considerar a caminhada aceita. Identidade, estilo e assimetrias também dependem de avaliação visual.

## Próxima ação recomendada

Investigar primeiro a relação entre os PNGs gerados, a remoção de magenta prevista em `tools/asset_prep.gd` e o cálculo de halo/pontos em `.atena/generated/hero-art-reset-20261021/r2_check.gd`. O verificador estima o resíduo a partir da imagem bruta; nesta conversa não foi produzida nem medida uma versão efetivamente recortada. Não declarar que o teste está errado sem demonstrar, nem flexibilizar os limites apenas para aprovar as fontes.

O reforço no prompt reduziu os defeitos, mas não aprovou o gate. O roteiro manda interromper a sequência após duas tentativas sem sustentação do formato e prevê uma pose por imagem como plano B. Como contagem/escala/pés passaram, os dados atuais não demonstram que separar poses resolveria o halo. Apresente uma recomendação baseada no diagnóstico antes de consumir nova geração ou alterar o contrato. Máximo registrado no contrato: três tentativas por imagem; já foram usadas duas.

Preserve os PNGs e o aceite v01. Qualquer experiência de recorte deve gerar derivados identificados em diretório sintético isolado. Não avançar às demais direções/heróis enquanto o gate estiver reprovado. Integração pertence ao R4 e mantém seus próprios gates. Esta passagem não adiciona autorização de execução além do histórico registrado.

## Contrato e proveniência

- Plano: `.atena/specs/SPEC-NOTTGARD-HERO-ART-RESET-20261021/plan-r1.md`.
- Contrato: mesmo diretório, `animation-contract-r1.md`.
- Roteiro: mesmo diretório, `r2-roteiro-r1.md`.
- Prompts integrais: `.atena/generated/hero-art-reset-20261021/prompts/durvall.md` (idle SE é o bloco 1; walk SE é o bloco 3).
- Ficha visual: `.atena/vault/drafts/HERO-VISUAL-SHEETS-20261021-r1.md`.
- Referências CANON: `F:/dev/nottgard-vault/output/referencias-personagens/CHAR-015/historico-S01-S09/r01/`, somente leitura; front-candidate, left, back e right v01 conforme lista no pacote de prompts.

Gerador usado: ferramenta integrada image_gen, sem API/CLI ou dependência instalada. Limite efetivo: cinco referências por chamada; tentativa inicial com seis foi rejeitada antes de gerar. Idle v01 recebeu quatro CANON + Zuggtmoy; Malcanthet foi vista, mas não enviada. Walk v01 recebeu quatro CANON + idle v01. V02 usou referências v01 conforme revisão. O limite impediu cumprir literalmente as seis referências do roteiro e deve ser considerado na retomada.

## Reproduzir e conferir

Use o Godot existente na raiz, fora do projeto real. Exemplo PowerShell para walk v02, com pasta sintética já existente:

```powershell
& 'F:/dev/abyss-megadungeon/Godot_v4.7.2-stable_win64.exe' --headless --path 'F:/dev/abyss-megadungeon/tmp/hero-r2-gate1-isolated' --script 'F:/dev/abyss-megadungeon/.atena/generated/hero-art-reset-20261021/r2_check.gd' -- 'F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall/durvall_walk_se_v02.png' magenta 3 walk
```

As execuções produziram JSONs, porém o processo retornou 0 mesmo com REPROVA. Leia `verdict` e `checagens`, não apenas o exit code. Houve também erro de leitura de certificados e tentativa negada de salvar editor_settings no AppData; nenhum save real foi carregado. Reavalie o isolamento do ambiente antes de repetir.

GIF: 620×500, 40 quadros de 40 ms, loop de 1,6 s; sequência R/I/E/I e A/P/B/P. Idle 5 fps, walk 12,5 fps por quantização temporal do GIF. Fundo magenta mantido, alinhamento pela base do bounding box e escala por calibração, sem remoção de halo. Renderização bicúbica e paleta GIF podem criar artefatos; avaliar bordas nos PNGs, não no GIF. O GIF foi reaberto com System.Drawing e seus 40 quadros foram confirmados.

Scripts de reprodução copiados para `preview-scripts/` nesta pasta. Usam PowerShell/System.Drawing e Node já disponíveis; sem dependências adicionais. Os caminhos internos continuam apontando ao diretório sintético original. Não é necessário regenerar o GIF para retomar.

`manifest.json` registra caminhos absolutos, tamanhos e SHA-256 das entregas e referências documentais locais. Conferência de integridade não equivale a aceite de arte. Preserve alterações concorrentes e os demais planos.
