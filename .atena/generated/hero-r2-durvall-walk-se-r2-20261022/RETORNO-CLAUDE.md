# Retorno ao Claude — Durvall walk SE, contrato r2

Data: 2026-10-22. DRAFT. Preparado a pedido do dono: “atena preparar para retornar para o claude”. Pacote local; não enviado automaticamente.

## Retomada

Projeto operacional: `F:/dev/abyss-megadungeon`. Abyss Megadungeon é a continuidade de nottgard-survivor, não outro jogo. Leia `AGENTS.md`, `.atena/add.yaml` e `hero_art_reset_20261021` em `.atena/state/plan.yaml`. O repositório antigo é histórico; não sincronizar de volta automaticamente. Arquivos globais citados em `C:/Users/gui-m/.codex/AGENTS.md` e `RTK.md` não existem neste PC.

**As três tentativas do formato novo foram consumidas. A alternância das pernas continua sem solução visual. Não gerar uma quarta tentativa nem avançar a outras direções/heróis.** Próxima ação recomendada: diagnosticar e propor o plano B de uma pose por imagem previsto no roteiro r2, com pedido separado de autorização para novas gerações. Este retorno não autoriza essa execução.

## O que foi feito

As três chamadas usaram a ferramenta integrada `image_gen`, sem API/CLI, instalação ou edição posterior dos PNGs. Em todas, foram enviados somente cinco arquivos, nesta ordem:

1. `F:/dev/nottgard-vault/output/referencias-personagens/CHAR-015/historico-S01-S09/r01/durvall-front-candidate-v01.png`
2. Mesmo diretório: `durvall-left-v01.png`.
3. Mesmo diretório: `durvall-back-v01.png`.
4. Mesmo diretório: `durvall-right-v01.png`.
5. `F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall/durvall_idle_se_v01.png` — idle aprovado.

Nenhuma caminhada foi fornecida como arquivo de referência. A sessão atual era nova em relação às caminhadas anteriores. Inicialmente a Atena interpretou o pedido como abertura do site ChatGPT e encontrou uma aba sem login; nenhuma imagem foi enviada ou gerada nessa aba. O dono corrigiu: “entendeu errado, essa já uma aba nova, uma sessão nova só continue”. As três gerações ocorreram nesta mesma conversa do Codex, usando caminhos explícitos das cinco referências. Logo, v02 e v03 compartilharam o histórico textual/visual das tentativas desta conversa; não alegar isolamento total entre essas chamadas.

## Tentativas e aceite

PNGs em `F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall/`:

| Tentativa | Arquivo | Pedido usado | Resultado |
|---|---|---|---|
| 1/3 | `durvall_walk_se_r2_v01.png` | Bloco 3 integral de `prompts-r2/durvall.md` | Reprovada explicitamente pelo dono. |
| 2/3 | `durvall_walk_se_r2_v02.png` | Bloco 3 + reforço de perna próxima/oposta e inversão A/B | Reprovada explicitamente pelo dono. |
| 3/3 | `durvall_walk_se_r2_v03.png` | Identidade/layout preservados; movimento reescrito como passo direito, passagem esquerda, passo esquerdo, passagem direita | Alternância ainda parece falhar na inspeção da Atena. Não houve aceite nem reprovação explícita separada do dono após o resultado; ele pediu este retorno. |

Feedback literal do dono sobre v01: “a passada continua estranha só uma perna se movimenta e no ultimo quadro a outra perna se movimenta”. Após v02: “não aprovo, nessa ultima tentativa, tente refazer o movimento das pernas de forma simples um passo depois o outro alternando entre os frames”.

Na inspeção visual das folhas, os contatos dos quadros 1 e 3 continuam mostrando aparentemente a mesma perna à frente. A v03 também parece repetir a mesma perna levantada nos quadros 2 e 4. São observações visuais, não medições novas: **o verificador v2 não foi executado para estas três imagens, não houve recorte das pernas nem GIF novo**. Não atribuir a elas PASSA/REPROVA automática, números ou teste em jogo.

O aceite histórico do idle v01 continua válido. As caminhadas antigas `durvall_walk_se_v01.png` e `durvall_walk_se_v02.png` foram preservadas; o aceite visual histórico não prova passada correta e não se transfere às novas `_r2`. Não confundir duas tentativas antigas com estas três novas.

## Evidência reproduzível

Nesta pasta:

- `request.json`: prompt e referências da tentativa 1, hashes, origem, reprovação e feedback.
- `prompt.txt`: bloco 3 utilizado na tentativa 1.
- `attempt-v02.json`: prompt integral da tentativa 2, referências, hash e reprovação.
- `attempt-v03.json`: prompt integral simplificado da tentativa 3, referências, origem e ressalva visual.
- `manifest.json`: hashes/tamanhos dos PNGs, fontes geradas, cinco referências e documentos desta entrega.
- `MENSAGEM-PARA-CLAUDE.txt`: mensagem curta para copiar na conversa do Claude.

As cópias dos PNGs no projeto foram conferidas por SHA-256 contra as saídas originais da ferramenta. Nenhuma edição, recorte, redimensionamento ou correção foi feita nas fontes.

Documentos vigentes:

- Contrato: `.atena/specs/SPEC-NOTTGARD-HERO-ART-RESET-20261021/animation-contract-r2.md`.
- Roteiro: mesmo diretório, `r2-roteiro-r2.md`.
- Prompts: `.atena/generated/hero-art-reset-20261021/prompts-r2/durvall.md`.
- Verificador: `.atena/generated/hero-art-reset-20261021/r2_check_v2.gd`.
- Diagnóstico anterior: `.atena/generated/hero-r2-durvall-gate1-diagnosis-20261022/DIAGNOSTICO.md`.

O handoff anterior `.atena/generated/hero-r2-durvall-handoff-20261022/LEIA-ME-CLAUDE.md` é histórico, anterior às correções r2. Não usar como estado atual. Ele contém a afirmação antiga de que o verificador v1 retornava 0 apesar de REPROVA; a rechecagem registrada no plano corrigiu isso: o v1 já retornava 1. Não repetir a afirmação antiga.

## Limites preservados

Nenhuma integração, mudança de runtime, save, nome técnico, IDs, contrato, gerador de prompts ou verificador nesta rodada. Demais heróis/direções não foram gerados nesta conversa. Nenhuma promoção a CANON, commit, push, publicação ou sincronização com a origem histórica. Preservar demais planos e alterações concorrentes. Experimentos futuros usam diretório sintético isolado; nunca carregar save real.

Antes de consumir nova geração, apresentar ao dono um diagnóstico e uma proposta concreta para controlar a pose de cada perna. O plano B é uma hipótese a validar, não uma solução comprovada. Caso se proponha modificar contrato, verificador ou pipeline, explicitar escopo e pedir aprovação conforme modo per-batch vigente.
