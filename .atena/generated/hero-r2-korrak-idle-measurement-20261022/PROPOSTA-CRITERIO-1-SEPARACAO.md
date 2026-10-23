# Proposta B: corrigir o critério 1 do verificador (2026-10-22, r1)

Status: **PROPOSTA, NÃO APLICADA.** Pedida pelo dono em 2026-10-22 ("deixe a correção do critério (B) como proposta separada"). O verificador v3, o contrato r2 e todas as imagens estão como estavam. Nada aqui muda um resultado oficial. Exige aprovação do dono antes de qualquer alteração.

## 1. O problema

O critério 1 do v3 divide a imagem em espaços fixos (terços de 512 px nas filas, quadrantes de 768×512 nas grades) e reprova a figura que toca o limite do seu espaço. Isso mede uma instrução do prompt (margem de 60 px), não o que a montagem precisa, que é **separar as figuras por componentes** (`asset_prep`, `split: components`, folga padrão de 6 px).

Consequências já vistas:
- **Falsos reprovados:** o idle do Korrak (figuras separadas por 18 e 20 px, mas com a ponta do machado passando da linha por 1 a 3 px) e a E1 do Durvall (1 px).
- **Falsos pontos soltos:** as pontas do machado cortadas pela partição viram "componentes pequenos" (3 no idle do Korrak).
- **Caixas distorcidas:** o agrupamento por vizinhança (dilatação de 20 px de cada lado) funde figuras separadas por menos de 40 px; as caixas por figura mostram valores errados (a figura 2 do Korrak aparece com x=512).
- **Exceções repetidas:** a morte do Durvall (por outros motivos) e o idle do Korrak já exigiram exceção escrita.

## 2. A definição proposta

**Critério 1:** a imagem tem **exatamente o número esperado de figuras** como componentes conectados da máscara de produção, com folga de 6 px entre componentes (a mesma do `asset_prep`) e área mínima de 4000 px; e **nenhuma figura toca a borda da imagem** (margem mínima de 4 px, PROVISÓRIO).

Efeitos acompanhantes:
- As caixas de cada figura passam a vir desses componentes (não da dilatação), o que corrige os critérios 3 e 4 quando as figuras estão próximas.
- O critério 6 (pontos soltos) conta componentes pequenos **fora** das figuras, sem a partição por terços; os artefatos nas linhas de corte somem.
- Ficam como estão: critérios 2, 3, 4, 5a, 5d, 5e, 5f, os limites, o veredito de três estados e o código de saída.

## 3. Teste da definição nas imagens que existem (sem alterar nada)

Script: `sep_check.gd`; saída: `sep_check_resultado.json`. Máscara de produção, dilatação de 3 px por lado (folga de 6 px), componentes de área original ≥ 4000.

| Imagem | Esperadas | Componentes | Critério 1 hoje (v3) | Pela definição proposta | Menor margem da imagem |
|---|---|---|---|---|---|
| Durvall idle v01 | 3 | 3 | PASSA | PASSA | 50 px |
| Durvall idle v02 | 3 | 3 | não medido no v3 | PASSA | 50 px |
| **Korrak idle v01** | 3 | 3 | **FALHA** | **PASSA** | 8 px |
| **Durvall walk E1 (r3)** | 3 | 3 | **FALHA (1 px)** | **PASSA** | 64 px |
| Durvall walk r2 v01 | 4 | 4 | PASSA | PASSA | 16 px |
| Durvall walk r2 v02 | 4 | 4 | PASSA | PASSA | 14 px |
| Durvall walk r2 v03 | 4 | 4 | PASSA | PASSA | 24 px |
| Durvall attack v02 | 4 | 4 | PASSA | PASSA | 85 px |
| Durvall active v02 | 4 | 4 | PASSA | PASSA | 93 px |
| Durvall death v03 | 4 | 4 | PASSA | PASSA | 136 px |
| Durvall walk r1 v01 | 3 | 3 | não medido no v3 | PASSA | 23 px |
| Durvall walk r1 v02 | 3 | 3 | não medido no v3 | PASSA | 51 px |

**Leitura honesta do teste:** as 12 imagens ficam separáveis, inclusive as duas que o critério atual reprova. A mudança **só remove falsos reprovados**; não afrouxa nada que estivesse pegando um defeito real nesta amostra, e **também não prova que a definição pegaria um defeito real**: nenhuma das 12 tem figuras fundidas, então o caso que o critério deve reprovar (figuras que se tocam ou fundem) **não foi exercitado** com imagem real. Esse teste teria de ser feito com uma imagem sintética de figuras coladas antes de aplicar. A margem mínima de 4 px é um chute: o menor valor medido é o do Korrak (8 px).

## 4. O que muda e o que fica

| Item | Mudança proposta |
|---|---|
| `r2_check_v3.gd` | Fica intacto. Seria criado **`r2_check_v4.gd`**, cópia do v3 com o critério 1 e o agrupamento trocados. O v3 permanece reprodutível |
| Contrato r2/r3, seção de critérios | Redação do critério 1; o pedido de margem de 60 px nos prompts continua como orientação, deixa de ser critério de aceite |
| Testes | Reexecutar as 12 imagens acima; adicionar duas sintéticas (figuras coladas deve reprovar; figura tocando a borda da imagem deve reprovar) |
| Exceções já registradas | Continuam valendo como estão (morte do Durvall v03, idle do Korrak v01). A morte continua reprovando nos critérios 4 e 6; o idle do Korrak passaria o critério 1, e a exceção dele ficaria desnecessária |

## 5. Riscos

1. O prompt pede margem de 60 px e o modelo vem ignorando (figuras de 80 a 94% do espaço). Sem o critério, ninguém mais reprova figuras grandes demais; o ganho é não perder imagens boas, o custo é perder esse sinal. Se figuras grandes passarem a causar problema na montagem, o critério volta.
2. Limites novos (6 px, 4 px) saem de poucas imagens.
3. Uma definição mais permissiva não deve virar justificativa para outras exceções: cada imagem continua medida nos demais critérios.

## 6. Decisão pedida (quando o dono quiser)

Aprovar, ajustar ou recusar a criação do `r2_check_v4.gd` com o critério 1 acima, com o reteste das 12 imagens e das duas sintéticas. **Nada será aplicado sem a sua resposta.**
