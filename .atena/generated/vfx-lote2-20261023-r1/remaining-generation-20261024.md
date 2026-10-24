# Geração das 19 folhas restantes — 2026-10-24

DRAFT. Geração concluída para 19 IDs (22 candidatas). Aceite visual das novas fontes pendente por ID/revisão/hash; aceite do piloto preservado.

## Autorização e execução

Pedido atual: “atena vamos seguir com os planos do claude: F:\dev\abyss-megadungeon\.atena\generated\vfx-lote2-20261023-r1\COLAR-NO-CHATGPT-19-FOLHAS.md”. A liberação das 19 consta em pilot-acceptance-v01.json, com aceite anterior do piloto por hash.

Ferramenta: image_gen integrado, uma chamada por candidata. Referência anexada a todas: ref-existing-vfx.png. Os 19 prompts completos foram extraídos dos blocos de COLAR-NO-CHATGPT-19-FOLHAS.md e enviados sem alterações nas v01. Ordem P, M, G. As fontes foram copiadas para esta pasta, preservando os originais gerados.

Correções M04, G06 e G09: segunda candidata para reduzir excesso lateral e contato entre quadros, preservando efeito, paleta e progressão. Prompts finais completos em prompts/M04_spacing_v02_prompt.txt, prompts/G06_spacing_v02_prompt.txt e prompts/G09_spacing_v02_prompt.txt. V01 mantidas para comparação; v02 recomendadas para revisão. Cada um desses IDs consumiu 2 de 3 tentativas; os outros 16 consumiram 1 de 3.

## Conferência e limites

- 19 IDs cobertos; 22 candidatas novas, todas 1536×1024. Contagem visual: seis quadros por fonte, exceto G04 e G08 com oito.
- Inspeção visual: fundo preto, efeitos luminosos, sem legendas, marca d'água ou grade desenhada observados. Paletas e assuntos distinguíveis nas fontes. Isto não constitui aceite visual do dono.
- Scan por grade nominal com limiar 24/255: todas as células previstas têm conteúdo. A ocupação nominal não prova separabilidade; medidas, hashes e contagem de pixels nos 3 px de cada limite vertical estão em remaining-source-audit-20261024.json.
- P05, M06 e outras fontes têm pixels nas bordas das células; preparar recortes por efeito e verificar contaminação por vizinhos. A normalização não recupera informação misturada: se um recorte seguro falhar, usar tentativa remanescente antes de aceitar o atlas.
- M04/G06/G09 v02 reduziram o excesso em relação às v01, mas não cumpriram todos os limites numéricos solicitados. Margens e escalas ainda pendentes, sem aprovação técnica automática.
- G04: conferir separação da detonação; G01/G02: conferir esticamento; P07: conferir sutileza da aura contínua; M02: o espírito encapuzado segue o efeito descrito no prompt. Loops, desaparecimento final e pivôs precisam de revisão animada.
- Leitura nos tamanhos de jogo e sobre fundo claro não foi validada para estas 19 nesta sessão. O comportamento aditivo sobre fundo claro continua como ressalva do piloto.

Galeria: remaining-gallery-20261024.html. Abre cada fonte em resolução integral e mantém as versões anteriores disponíveis para comparação. Não aplica normalização nem simula gameplay.

Próximo checkpoint: revisão visual das fontes recomendadas por ID/revisão/hash, seguida de preparação isolada e validação técnica do atlas. Runtime, saves, IDs e outros planos preservados nesta sessão; sem integração, commit, push ou publicação.
