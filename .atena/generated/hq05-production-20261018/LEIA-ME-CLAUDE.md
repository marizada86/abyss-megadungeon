# HQ05 — handoff para Claude

Instrução do dono em 2026-10-22: «aprovado, continue a geração deixe as implementações para o claude». Este arquivo é entrega local para o dono/Claude; não foi enviado a outro serviço nem executado por outro agente.

Fonte operacional: `F:/dev/abyss-megadungeon`. Ler AGENTS.md, ADD e o cursor atual de `.atena/state/plan.yaml` antes de qualquer implementação. Preservar os demais planos, alterações locais e checkpoints; não sincronizar com a origem histórica.

## Estado da produção

Plano PLAN-NOTTGARD-HQ05-VISUAL-20261018, modo per-step, 2/6 etapas concluídas: seleção e Q1. Uma de cinco imagens aceita.

**Atualização do dono em 2026-10-22:** «não aprovo, o brook ficou ruim, vamos deixar isso para depois estou gerando mais prompts». Produção pausada por pedido explícito. Aguardar novos prompts e retomada; não gerar automaticamente outra candidata ou avançar para Q3.

| Quadro | Arquivo nesta pasta | Estado |
|---|---|---|
| Q1 | `candidates/hq_n05_q1_cavern_bubbles_v01.png` | Aceita explicitamente pelo dono em 2026-10-22 |
| Q2 | `candidates/hq_n05_q2_blogbog_pressure_v01.png` | REJEITADA pelo dono: resultado visual do Brook; preservar apenas como histórico, não integrar |
| Q3–Q5 | — | Ainda não geradas; dependem dos aceites individuais anteriores |

Hashes por candidata: `visual-status-r1.json`, `q1-receipt-v01.json` e `q2-receipt-v01.json`. Prompts efetivos: `q1-prompt-v01.txt`, `q2-prompt-v01.txt`. Referências usadas e hashes: recibos e requests correspondentes. Originais preservados na pasta de imagens geradas; cópias versionadas neste projeto.

Q1: caverna fechada, bolhas verdes aderentes e chão de raízes sob slime; sem personagens, portal, colar ou Estige. Q2: Blogbog CANON e slimes pressionam Brook, Erik e Korrak; martelo solar retangular de Brook; Korrak sem machado futuro; nenhum ferimento, derrota do chefe ou novo poder.

## Limites de implementação

O agente de geração não modificou `assets/hq/`, `data/hqs.json`, runtime ou saves. A solicitação reserva implementações ao Claude; não equivale a afirmar que este handoff já foi implementado. Q2 v01 foi rejeitada e não deve ser admitida. Conferir o estado mais recente e aguardar a retomada explícita da produção.

Preservar IDs técnicos, legendas CANON e a cronologia do roteiro HQ05-SCREENPLAY-APPROVED-20261017-r1. Antes de integrar, delimitar/seguir o checkpoint de integração aplicável e validar o leitor com diretório/perfil sintético isolado, sem carregar o save real. Sem dependências, sincronização da origem, commit, push ou publicação por efeito deste handoff.

Para Q2/Q3, prevalecem as quatro vistas CANON de Blogbog descritas em `.atena/specs/SPEC-NOTTGARD-HQ05-VISUAL-20261018/selection-r1-vault-update-20261020.md`: a proposta fúngica anterior foi substituída. Para Q3 usar também a Q2 após aceita, mantendo a identidade dos restos e do núcleo. O colar ficou no arco de Shedaklah; o Estige só reaparece em Q5.
