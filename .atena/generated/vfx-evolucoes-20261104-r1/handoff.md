# VFX de evoluções — fontes para o Claude, 2026-11-04

Autorização do dono: “atena, proximo plote”, em resposta à proposta das sete famílias. Atena gera imagens; preparação e implementação ficam com Claude. DRAFT, sem promoção de conteúdo a CANON. Sete fontes entregues, sem recortes ou alteração de runtime. Prompts exatos em prompts/; proveniência e hashes em manifest.json. Aceite humano deste lote PENDING.

| Fonte | Arma/efeito | Ordem dos quadros |
|---|---|---|
| VE01 | selo_da_retidao | 4 de voo na linha superior + 4 de impacto na inferior |
| VE02 | cajado_dos_desejos_realizados | 4 de voo + 4 de impacto |
| VE03 | lamina_do_eclipse | 4 de voo + 4 de impacto |
| VE04 | memoria_reescrita | 4 de voo + 4 de impacto |
| VE05 | vigilia_perpetua | 6 quadros, pulso uma vez, leitura 3×2 |
| VE06 | abraco_dos_tentaculos | 6 quadros, laço persistente, leitura 3×2 |
| VE07 | ampulheta_do_tempo_parado | 6 quadros, pulso uma vez, leitura 3×2 |

## Preparação futura

Fontes em assets_incoming/vfx-evolucoes-20261104-r1/sources/. Fundo preto para composição aditiva. A grade pedida nos projéteis é 4×2 (células 384×512 numa fonte 1536×1024), nas áreas 3×2 (512×512). Conferir dimensões reais no manifest; não assumir que os pivôs e contornos solicitados foram obedecidos. Os projéteis do consumer atual usam atlas final 8×1 de células 256×256 (4 voo e 4 impacto); pulso radiante usa 6×1, 256×256. O VFX da zona tem projeção própria; medir elipse/base antes de normalizar. Mapear arma por ID herdado, preservando fallback. Estes são contratos de referência para Claude, não jobs executados ou admissão técnica.

Para os projéteis, usar escala consistente no ciclo de voo e pivô medido; não centralizar só pelo bounding box de cada rastro. Os impactos crescem e desvanecem, portanto não normalizar cada quadro a um mesmo tamanho. Nos pulsos, usar uma escala para a sequência inteira para preservar crescimento e dissipação, e medir o raio no pico. Vigília/Ampulheta foram desenhadas como círculo visto de cima; projeção isométrica é aplicada na preparação/runtime conforme consumer. Não multiplicar visualmente o número de projéteis: os leques de cinco e três são dados da arma.

## Inspeção das fontes e limites

Sete folhas vistas ao gerar. VE01–VE04 apresentam quatro voos e quatro impactos em duas linhas; VE05/VE07 mostram crescimento e dissipação de anéis; VE06 mostra seis quadros da zona. VE06 tem cinco tentáculos claramente visíveis por quadro contra seis pedidos no prompt: diferença visual registrada para decisão do dono, sem mudança de mecânica. A margem direita de VE06 parece menor que a solicitada; medir antes de recortar. Cor, centros, margem, caixa útil e continuidade do laço ainda exigem QA. Não declarar reprodução perfeita da geometria nem continuidade verificada apenas pela folha estática. Os voos têm variação sutil: avaliar animação depois da preparação, sem presumir fluidez.

Aceite de fontes não é aceite de integração. Não alterar mecânicas, raio, dano, cadência ou acessibilidade para acomodar a arte. Nada instalado, nenhum save carregado, sem commit/push/build/publicação. Outros planos e fontes aprovadas preservados.

## Aceite visual recebido — 2026-11-04
O dono respondeu 'atena aprovado' após entrega das sete folhas e divulgação da variação de VE06 (cinco tentáculos visíveis em vez de seis). Todas as sete fontes estão aceitas visualmente por ID e SHA-256 em visual-acceptance.json; este recibo atualiza o estado PENDING descrito acima. Não repetir geração nem aceite destas fontes. DRAFT preservado. As verificações técnicas de normalização, centros, margens e continuidade permanecem para Claude na preparação e implementação; nenhuma integração foi executada pela Atena. Sem commit, push, build ou publicação autorizados.
