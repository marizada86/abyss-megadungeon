# Lote 3 — nove fontes restantes, 2026-10-27

Pedido posterior do dono: “commit”. Autoriza versionar estas fontes e seus registros; aceite visual e admissão técnica continuam pendentes. Push não solicitado.

DRAFT. Nove IDs gerados, 14 candidatas preservadas. Aceite visual do dono pendente por ID/revisão/hash. Piloto aprovado e integração existente preservados.

Autorização: “atena, continue”, após aceite do piloto e liberação registrada no plano e em COLAR-NO-CHATGPT-9-FOLHAS.md. Execução via image_gen integrado, uma chamada por candidata, fundo preto aditivo. Todas usam ref-existing-vfx.png. T01 v02 também usa T02_tentaculos_laco_v02.png para continuidade de aparência e pose. Arquivos copiados do CODEX_HOME para esta pasta sem modificar os originais.

## Seleção recomendada para revisão

| ID | Versão | Tentativas usadas | Motivo / ponto a conferir |
|---|---|---|---|
| E01 | v02 | 2/3 | Crescente carmim mais compacto; preservar pivô do atacante |
| E02 | v02 | 2/3 | Cortes cruzados, em vez de chevrons da v01 |
| E04 | v01 | 1/3 | Orbe violeta com fragmentos e quatro impactos; revisar pivô e tintas |
| E05 | v01 | 1/3 | Crescente de vento com raios, impactos em X |
| E06 | v03 | 3/3 | Pulso menor e raios mais curtos; sem nova tentativa sem decisão do dono |
| E07 | v01 | 1/3 | Explosão vertical com progressão e dissipação; altura excede a célula nominal |
| D02 | v01 | 1/3 | Coluna violeta e anel de runas; altura excede a célula nominal, medir elipse antes da escala por raio |
| T01 | v02 | 2/3 | Ventosas e disposição mais próximas de T02; validar transição quadro 6 → T02 quadro 1 |
| H01 | v01 | 1/3 | Corte vermelho e branco; reduzir na preparação para impacto discreto |

Prompts v01: arquivos originais prompts/<ID>_<nome>_prompt.txt, enviados sem alterações. Correções completas em *_correction_v02_prompt.txt e E06_pulso_evo_spacing_v03_prompt.txt. As correções reforçam separação, cortes cruzados ou continuidade; E06 v03 reduz explicitamente o raio pedido para evitar pontes entre quadros. O estilo permanece o do lote. D02 original contém conflito entre “No magenta anywhere” e a paleta específica magenta; foi enviado como recebido, sem editar silenciosamente.

## Auditoria e limites

audit-remaining.ps1 usa System.Drawing, sem instalação, e gera remaining-source-audit-20261027.json. Todas as 14 fontes têm 1536×1024; contagem visual de seis quadros por fonte, exceto E04/E05 com quatro voos e quatro impactos. Sem texto, grade desenhada ou marca d'água observados.

A análise percorre toda a altura de cada linha e busca um corte vertical até ±48 px da fronteira nominal, com RGB máximo >24/255. Todas as candidatas têm um separador sem pixels acesos em cada fronteira nesse limiar. Isso não prova margem de 20/30 px, ausência de brilho abaixo do limiar, alinhamento, tamanho de jogo, continuidade ou aceite técnico de atlas. E06 v01/v02 pareciam conectadas visualmente por raios longos; mesmo com separadores no limiar, v03 é preferida pelo efeito mais contido.

Não usar recorte cego de y=384..639: várias fontes excedem a altura nominal. Preparar pelos limites reais, aplicar escala única por animação e revisar centro/base, dissipação final, legibilidade sobre fundo claro e escuro e a passagem T01→T02. A galeria mostra fontes integrais e prévias pela grade nominal, sem normalizar ou produzir atlas. Prévia nominal pode cortar partes altas ou mostrar vizinhos; não é evidência de defeito irrecuperável da fonte.

Manifesto com hashes e contagens: remaining-manifest-20261027.json. Galeria: remaining-review.html. Checkpoint: LOTE3_REMAINING_9_SOURCE_REVIEW_PENDING. Próxima etapa: aceite visual das recomendações, seguido de preparação e integração das nove. Não repetir aceite do piloto.

Nesta sessão não houve mudanças de código, atlas, saves, dependências, commit, push ou publicação. Estado anterior e histórico preservados; estas fontes pertencem à frente operacional atual, sem sincronização com o repositório histórico.
