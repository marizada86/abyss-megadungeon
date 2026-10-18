# Registro de revisão — r1, histórico e resultados

Atualização de 2026-10-15: **HQ01 r2 de oito quadros aprovada e integrada no PC/Web; S-HQ-002 concluída.** Os registros iniciais abaixo são históricos. Seleção final e hashes em hq01-approved-sequence-r1.json; aceites individuais ASSET-APPROVAL-HQ01-Q1 a Q8, aceite integral HQ01-SEQUENCE-APPROVAL-20261015-r1. Q3 usa v02 (Gilly nominal), Q5 usa v02 (domo sem roxo/buracos), demais v01. Evidência atual: ../../evidence/EVID-NOTTGARD-HQ01-INTEGRATION-20261015.md. Estado: 2/16 concluídas; próxima etapa S-HQ-003/HQ02, roteiro r2 aprovado mas produção aguarda autorização da etapa.

Nenhuma HQ ou imagem recebeu novo aceite humano. Cada linha será detalhada em Q1–Q4 durante sua etapa, com original, fonte, problema, texto proposto, decisão visual, candidata, aprovação e integração. Não usar este registro como aceite antecipado.

| HQ | Título atual | Quadros | Situação |
| --- | --- | --- | --- |
| hqn_01 | Uma Noite Sem Fim | Q1–Q4 | Q1 candidata v01 e legenda aprovadas; revisão de Q2–Q4 pendente |
| hqn_02 | Seremos um só | Q1–Q4 | Aguardando revisão |
| hqn_03 | O Véu Vivo | Q1–Q4 | Aguardando revisão |
| hqn_04 | O Palácio de Zuggtmoy | Q1–Q4 | Aguardando revisão |
| hqn_05 | O Núcleo Verde | Q1–Q4 | Aguardando revisão |
| hqn_06 | A Jaula de Durao | Q1–Q4 | Aguardando revisão |
| hqn_07 | A Peregrinação da Estrela | Q1–Q4 | Aguardando revisão |
| hqn_08 | O Chifre de Malcanthet | Q1–Q4 | Aguardando revisão |
| hqn_09 | O Paraíso que Era Ilusão | Q1–Q4 | Aguardando revisão |
| hqn_10 | A Síntese Abissal | Q1–Q4 | Aguardando revisão |
| hqn_11 | A Concórdia Eterna | Q1–Q4 | Aguardando revisão |
| hqn_12 | O Nome Aluris | Q1–Q4 | Aguardando revisão |
| hqn_13 | O Cerco de Aluris | Q1–Q4 | Aguardando revisão |
| hqn_14 | A Máscara | Q1–Q4 | Aguardando revisão |

## HQ01 — entrada da revisão, 2026-10-15

S-HQ-002 autorizada pelo dono ("vamos lá"). Etapa em andamento; não concluída. Verificação de hashes: catálogo, quatro PNGs e quatro retratos permanecem iguais à baseline em PC e Web. Inspecionados visualmente os quatro quadros e retratos de Kayron, Durvall, Sylas e Maelor. Fontes narrativas pertinentes lidas em S-HQ-001 e reutilizadas; bíblia de referência DRAFT r1 aplicada. Q1 sem personagem relevante: identidade N/A; Q2–Q4 devem representar o grupo da Sessão 01.

| Quadro | Legenda literal atual | Observação inicial de Atena, sem aceite do dono |
| --- | --- | --- |
| Q1 | Não é noite. É a ausência do dia, desde que a Finbulnott engoliu o sol. | Panorama estabelece cidade, névoa e barreira azul. Texto acompanha a metáfora do prólogo. Conferir com o dono a representação da cidade e da Tarn; nenhuma correção presumida. |
| Q2 | Zynara: Há algo errado nas Docas. | As quatro silhuetas usam elementos genéricos (arqueiro de capuz, mago de chapéu, guerreiro de machado/escudo) que não correspondem claramente aos quatro retratos atuais. A fonte registra missão anterior de Zynara; a legenda em fala direta pode sugerir presença na cena. Proposta futura: explicitar a missão anterior, se o dono confirmar. |
| Q3 | Runas entalhadas na Tarn. Um ritual para enfraquecê-la. | A barreira tem linhas de fratura que podem ser lidas como vidro, contrariando o guia de energia. Há mão em primeiro plano e quatro figuras ao fundo, sugerindo um quinto integrante; identidades e continuidade precisam de correção/clarificação. O evento ritual/névoa consta na Sessão 01. |
| Q4 | Alguma coisa nos viu primeiro. | Porta/escada mantém o gancho, mas o grupo repete figuras genéricas de capuz/arco e chapéu. A figura de cabelo branco muito longo exige identificar corretamente Kayron versus Durvall com referências. Legenda é síntese de suspense, não tratada aqui como citação literal da sessão. |

Decisões por quadro: todas PENDING_OWNER_FEEDBACK. Nenhum roteiro corrigido aprovado, candidata produzida, promoção canônica ou admissão realizada. Próxima interação: apresentar quatro originais/legendas e recolher apontamentos, começando por Q1 se o dono desejar. Não avançar à HQ02 nem gerar imagens por efeito da autorização de iniciar a revisão.

### Q1 — correção aprovada e candidata, 2026-10-15

Atualização posterior: o dono corrigiu a Tarn para domo mágico cobrindo toda a cidade e protegendo da névoa, aprovou a vista aérea oblíqua externa recomendada, pediu corrigir o guia/refazer Q1, manter a legenda e validar a nova imagem antes de seguir. Reforçou que a névoa é verde. Esta autorização concreta supersede o estado pendente acima somente para o briefing de Q1 e a referência da Tarn.

- Referência aprovada: CANON DEC-NOTTGARD-TARN-20261015 r1, portada ao ADD Web. Guia visual local atualizado para revisão r2 no caminho estável e portado por hash, conforme q1-guide-port-receipt.json. O guia histórico externo é preservado e explicitamente superado no ponto da cortina vertical.
- Ferramenta: image_gen integrada, uma geração com PNG original como referência/edit target. Prompt exato: ../../generated/hq-review-20261015/q1-dome-prompt.txt.
- Candidata DRAFT: ../../generated/hq-review-20261015/candidates/hq_n01_q1_dome_v01.png, 1672x941, SHA-256 32f6c43131112166d2cf74828288ca45152d58c1bf9d6939a426d1a1b239dd6b. Original e candidata preservados; recibo q1-candidate-receipt.json.
- Inspeção da saída: cúpula azul com teto/curvatura inteira visível, cidade e porto sob o domo, névoa verde exterior, luzes âmbar, sem legenda ou UI embutida. Não equivale a aceite humano da imagem. Identidade N/A: sem personagens nesta cena urbana.
- Legenda mantida literalmente: “Não é noite. É a ausência do dia, desde que a Finbulnott engoliu o sol.”
- Check de integridade: data/hqs.json e assets/hq/hq_n01_q1.png continuam com os hashes da baseline em PC e Web. Não houve admissão no runtime, teste Godot ou acesso a save.

Checkpoint atual: aguardar validação do dono para a candidata v01. Q2–Q4 continuam pendentes e não foram produzidos/alterados. S-HQ-002 permanece em andamento, 1/16 etapas concluída.

### Aceite Q1 e entrada Q2

O dono respondeu "aprovado" à candidata v01 do domo em 2026-10-15. Aceite da imagem e manutenção da legenda registrados em ASSET-APPROVAL-HQ01-Q1-20261015 r1. Candidata aprovada permanece preservada fora de assets; a integração em ambas as versões será após a apresentação/aceite da HQ01 completa, conforme método aprovado. S-HQ-002 continua em andamento, sem autorização de avanço à HQ02.

Próximo quadro em revisão: Q2 original, legenda literal “Zynara: Há algo errado nas Docas.”. Apontamentos técnicos iniciais permanecem: elenco visual genérico e contexto de fala que pode sugerir presença física de Zynara, embora a Sessão 01 registre missão anterior. Proposta textual DRAFT para discussão: “A pedido de Zynara, Kayron, Durvall, Sylas e Maelor investigam as Docas.” Não aprovada nem aplicada. Recolher decisão do dono sobre texto e composição/elenco antes de qualquer produção do quadro.
