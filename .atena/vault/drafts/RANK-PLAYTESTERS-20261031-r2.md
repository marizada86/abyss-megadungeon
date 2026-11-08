# Rank de contribuições dos playtesters (r2)

Atualizado em **2026-10-31**. Substitui o rank de 2026-10-10 (PLAN-096), que está em `F:\dev\nottgard-survivor\.atena\backlog\CONTRIBUICOES-PLAYTESTERS.md` (histórico, só leitura). `content_state: DRAFT`: rascunho de pontuação proposto por Atena; os pesos continuam ajustáveis pela tabela da seção 3.

Fontes: INBOX do repositório de origem (IN-073 a IN-096, que chegaram depois do rank anterior), cartões em BUGS e MECANICAS de lá, EVID-239, EVID-250 a EVID-257, e o estado deste repositório. O dono (T01, Higor) fica fora do rank, só como referência. Itens e cartões aparecem por ID; o texto dos relatos fica na origem (regra do projeto: sem copiar relatos pessoais).

## 1. Rank

| # | Tester | Pontos | Antes | Variação | Itens triados | Aplicados | Destaque |
|--:|---|--:|--:|--:|--:|--:|---|
| 1 | **Mariz (T05)** | **78** | (novo) | +78 | 20 | 14 | Primeiro relato de jogador forte: dificuldade (borda, poças, 1º chefe), chefes e elites sem identidade, números de dano e impacto; bugs de volume (BUG-044) e tela de resultado (BUG-045) |
| 2 | **Daniel ("DNA", T03)** | **76** | 76 | 0 | 15 | 15 | Sem relato novo; mantém bloco de notas (BUG-035), C da ficha (BUG-034), textos sobrepostos (BUG-036) |
| 3 | **Hiago ("Hiagola", T02)** | **74** | 68 | +6 | 14 | 14 | Novo: foco do controle sumia ao comprar melhoria (BUG-043, P1) |
| 4 | **Manzi ("manzera", T04)** | **58** | 58 | 0 | 13 | 13 | Sem relato novo |
| 5 | **Vitão** | **8** | 8 | 0 | 1 | 1 | Sem relato novo; playtest M5 dele ainda não aconteceu (plano `pacing_audit_20261029`) |

Referência (fora do rank): Higor/T01, dono e dev.

Mudança de posição: Mariz entra direto em 1º; Daniel cai de 1º para 2º e Hiago sobe de 2º para 3º, a dois pontos de Daniel.

## 2. Como cada um pontuou

| Tester | Triados | Aplicados (×3) | Em andamento (×1) | Bug P1 | Confirmado por outro (×2) | Questionário | Pacotes | **Total** |
|---|--:|--:|--:|--:|--:|--:|--:|--:|
| Mariz | 20 | 42 | 2 | 4 (BUG-044, BUG-045) | 10 (IN-079, 081, 087, 090, 091) | 0 | 0 | **78** |
| Daniel | 15 | 45 | 0 | 6 | 6 | 2 | 2 | **76** |
| Hiago | 14 | 42 | 0 | 6 (BUG-012, 015, 043) | 6 | 2 | 4 | **74** |
| Manzi | 13 | 39 | 0 | 2 | 4 | 0 | 0 | **58** |
| Vitão | 1 | 3 | 0 | 4 (P0) | 0 | 0 | 0 | **8** |

Contas conferidas: Mariz 20+42+2+4+10 = 78; Hiago 14+42+6+6+2+4 = 74. Daniel, Manzi e Vitão não mudaram.

## 3. Tabela de pontos (v1, mantida)

| Evento | Pontos |
|---|--:|
| Nota ou relato triado (um por item do INBOX, sem repetição) | 1 |
| Virou cartão **implementado** | +3 |
| Cartão aberto, mas em andamento | +1 |
| Bug **P1** achado | +2 |
| Bug **P0** achado | +4 |
| Achado confirmado por outro tester ou relato repetido (por item) | +2 |
| Questionário rápido respondido | +2 |
| Pacote de evidências com relato, log e prints | +2 |

Regra aplicada na r2: bug que repete um cartão já existente (IN-079 em BUG-012) leva só o +2 de confirmação, sem novo bônus de P1.

## 4. Detalhe dos itens novos

**Hiago (T02)** — relato repassado pelo dono em 2026-10-10

| Item | Cartão | Situação | Pontos |
|---|---|---|--:|
| IN-073 | BUG-043 (P1), EVID-239 | implementado | 1+3+2 = 6 |

**Mariz (T05)** — EVID-250, relatório escrito sobre a v0.4.0, repassado pelo dono em 2026-10-14

| Item | Cartão / lote | Situação | Pontos |
|---|---|---|--:|
| IN-077 | BUG-044 (P1) | implementado | 6 |
| IN-078 | BUG-046 (P2) | aberto: Print 1 não chegou, não reproduzido | 1 |
| IN-079 | BUG-012, L4 | implementado; confirmado por Daniel, Hiago e Higor | 6 |
| IN-080 | BUG-045 (P1) | implementado | 6 |
| IN-081 | BUG-028, M1 / SPEC-176 | em andamento; confirmado | 4 |
| IN-082 | M3, sem cartão | triado | 1 |
| IN-083 | M3 | triado (confirmar qual objeto) | 1 |
| IN-084 | MEC-070, L1 | implementado | 4 |
| IN-085 | MEC-064, M3 | triado (já tratado em parte antes do relato) | 1 |
| IN-086 | névoa do mundo, M5/ART | em andamento | 2 |
| IN-087 | BAL-004, BAL-028, L2 | implementado; confirmado | 6 |
| IN-088 | SPEC-177, MEC-031, L3 | implementado | 4 |
| IN-089 | L4 | implementado | 4 |
| IN-090 | BAL-016, MEC-040, L2 | implementado; confirmado | 6 |
| IN-091 | BAL-012, L2 e L5 | implementado; confirmado | 6 |
| IN-092 | ART (escala do chefe), L1 | implementado | 4 |
| IN-093 | M4a, L5 e PLAN-105 | implementado | 4 |
| IN-094 | M4a, L4 | implementado | 4 |
| IN-095 | MEC-070, L1 | implementado | 4 |
| IN-096 | SPEC-177, L3 | implementado em parte (F-4/F-5 recusadas pelo dono) | 4 |

Daniel, Manzi e Vitão: tabelas por item inalteradas no arquivo de origem.

## 5. Limites e perguntas abertas

- **"Aplicado" é implementado, não verificado em playtest.** Conferi neste repositório só que as chaves `l2`, `l4` e `boss_mech` estão ligadas em `data/difficulty.json` e que há teste para BUG-044/045. L1 e L3 constam como implementados no INBOX de origem e não reverifiquei aqui.
- **Mariz é relato único e de segunda mão** (sem pacote, log, hash de build nem Print 1), de quem se descreve como jogador forte. O volume de itens (20 de uma vez) pesa no rank: a liderança é de 2 pontos sobre Daniel, então qualquer ajuste de peso ou item descontado pode devolver o 1º lugar a ele. Vale decidir antes de divulgar.
- **Playtests das builds 0.5.0, 0.5.1 e 0.5.2 não têm autoria registrada.** O commit `cad99c2` (ajustes do playtest 0.5.2) e o envio da onda 1 (2026-10-20, testers não registrados) não dizem quem relatou o quê, então nada disso pontuou. Se o dono disser quem achou cada item, o rank sobe.
- Vitão só aparece em BUG-032. O playtest M5 com ele está agendado depois da reescala M4.
- Se algum cartão "aplicado" voltar reaberto, os pontos de "aplicado" caem para "em andamento".
- Dúvidas pendentes: IN-078 (Print 1), IN-083 (qual objeto), IN-060 e IN-064 (Manzi), IN-025 e IN-032 (Hiago).
- Nenhuma operação de Git, publicação ou envio foi feita; este arquivo e o cartão HTML são locais.
