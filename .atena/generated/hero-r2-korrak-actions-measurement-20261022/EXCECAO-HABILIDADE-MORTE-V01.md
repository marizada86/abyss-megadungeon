# Exceção documentada: Korrak, habilidade e morte SE v01 (2026-10-22)

Status: DRAFT. Registro de decisão do dono. **O verificador não foi alterado** e nenhum limite foi mudado. São exceções a **duas imagens**, escritas e com escopo, não uma regra nova.

## Decisão

Dono, 2026-10-22: "Aceito habilidade (active v01) e morte (death v01) do Korrak à vista com as exceções escritas; registre, sem mudar o verificador."

Aceite visual do dono: **APPROVED_OWNER_20261022** para as duas imagens, a partir da apresentação de `RESULTADO.md` e das duas imagens abertas na sessão.

## Imagens

| Arquivo | SHA-256 (conferido em 2026-10-22 contra `actions-generation-receipt-v01.json`) | Tentativas |
|---|---|---|
| `assets_incoming/hero-r2/korrak/korrak_active_se_v01.png` | F316D1F345535E2CFED19F69904951498E40B7E7CC4B82C79A9FE217C4314DAC | 1 de 3 (restam 2, não usadas) |
| `assets_incoming/hero-r2/korrak/korrak_death_se_v01.png` | 27F9C1B7AE091BFECE766AFAAF467C312CDD721F1FE916284E4832671C3321E4 | 1 de 3 (restam 2, não usadas) |

Arquivos idênticos aos originais gerados, sem pós-edição.

## O resultado técnico que continua valendo

O verificador v3 (`grid`, `magenta`, 4 figuras) **continua dando REPROVA** para as duas: habilidade, critério 1 FALHA; morte, critérios 1 e 4 FALHAM. O resultado oficial não foi reescrito. Passam nas duas: 2 (fundo), 5e (poses diferentes, menor 42,8% e 45,6%); 6 é INCERTO (1 ponto em cada). Habilidade: 4 (pés) passa com 2,2%.

## As exceções

| # | Imagem | Critério | Por que não se aplica | Evidência |
|---|---|---|---|---|
| 1 | Habilidade | 1, figura toca o limite do seu espaço | Pomo do machado da figura 2 a **5 px** do topo da imagem (sem corte) e pés da figura 1 na linha entre as fileiras (y=511). As 4 figuras são componentes separados (folga de 6 px do `asset_prep`); menor margem da imagem: 5 px | `RESULTADO.md` seções 1 a 3; `sep_check_korrak_acoes.json` |
| 2 | Morte | 1, figura toca o limite do seu espaço | Pés das figuras 1 e 2 passam da linha y=511, mas as figuras seguem separadas das de baixo (componentes, folga de 6 px); menor margem da imagem: 41 px | `RESULTADO.md` seção 3; `sep_check_korrak_acoes.json` |
| 3 | Morte | 4, pés (11,2%) | Não se aplica a figura deitada: a figura caída não tem linha de pés e a de joelhos tem o cabo do machado como ponto mais baixo. Mesmo caso da morte do Durvall (`EXCECAO-MORTE-V03.md`) | `RESULTADO.md` seção 3 |
| 4 | Habilidade e morte | 6, pontos soltos (1 INCERTO em cada) | Contado à vista; não é falha do contrato (INCERTO não reprova) | `v3-korrak-active-v01.json`, `v3-korrak-death-v01.json` |

## Pontos de atenção registrados (não são exceções de critério)

- **Habilidade:** o machado fica à esquerda nas figuras 2 e 3 e à direita na 4 (impacto à frente). O dono aceitou à vista; a transição 3 → 4 é do mesmo tipo que motivou a rejeição do ataque v01, mas aqui o seguimento é um impacto.
- **Margem pedida de 80 px:** não atendida (as figuras seguem separáveis).

## O que a exceção não faz

- Não declara as imagens prontas para integração, não as promove a CANON e não altera nenhum limite do verificador.
- Não vale para outras imagens, heróis ou animações; não é precedente.
- Não aprova a proposta B (`PROPOSTA-CRITERIO-1-SEPARACAO.md`), que **segue não aplicada**, sem decisão.
- Não reabre a geração.

## Obrigações transferidas para o R4 (montagem; exigem aprovação própria)

1. Separar por componentes (`asset_prep`, `split: components`) e conferir 4 figuras em cada imagem.
2. Habilidade: conferir que o pomo da figura 2 não foi cortado no recorte (5 px do topo).
3. Morte: ancorar na vertical pelo contato do corpo com o chão, não pela ponta do machado (senão o quadro de joelhos paira); remover componentes soltos e despill do magenta na escala de produção.
4. Alinhar pelo tronco e normalizar a escala entre as figuras.
5. Registrar no relatório do R4 que habilidade e morte do Korrak entraram com estas exceções.

## Preservado

Os dois PNG e seus hashes; `actions-generation-receipt-v01.json` (recibo de geração, intacto); `RESULTADO.md` e os JSON de medição; verificadores v1, v2 e v3 sem alteração; contrato r2; o ataque v01 (rejeitado) e o v02b (aceito); os demais planos. Sem geração, integração, commit ou push.
