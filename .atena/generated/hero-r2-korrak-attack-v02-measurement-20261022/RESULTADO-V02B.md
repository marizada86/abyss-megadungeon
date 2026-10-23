# Korrak, ataque SE v02b (composição): medição (2026-10-22)

Status: DRAFT. Pedido do dono: usar a posição 4 da imagem anterior (a figura 4 do v01, que mostra as duas mãos). Nenhuma geração; a tentativa restante (1) não foi usada.

## O que é o v02b

`assets_incoming/hero-r2/korrak/korrak_attack_se_v02b.png` (SHA-256 1DA5647F850A1B7B78F26507F40754B303D1241AA5A4C0A431A0ED9945F1D218). Figuras 1, 2 e 3 do v02 intactas; figura 4 do v01 colada 1:1 no quadrante inferior direito, sem escala nem retoque, deslocada 14 px para baixo para igualar a linha dos pés. v01 e v02 preservados (hashes conferidos). Recibo: `attack-composite-receipt-v02b.json`.

## Medição (verificador v3, `grid`; `v3-korrak-attack-v02b.json`)

| Critério | v02 | v02b |
|---|---|---|
| 1 Figuras | PASSA | PASSA |
| 4 Pés | PASSA (1,6%) | PASSA (1,1%) |
| 2 Fundo | PASSA (0,1) | PASSA (0,1) |
| 6 Pontos soltos | PASSA (0) | PASSA (0) |
| 5e Poses diferentes | PASSA (menor 46,9%) | PASSA (menor 42,5%, par 1-4) |
| 5f Gesto | à vista | à vista |
| Veredito | PASSA_COM_ITENS_A_VISTA | **PASSA_COM_ITENS_A_VISTA** |

Separação (`sep_check`): 4 componentes separados; menor margem 42 px. Pés: 973 e 968 na fileira de baixo.

## À vista

- Figura 4: **as duas mãos aparecem** no cabo (a de trás perto do pomo, a da frente a meio do cabo); machado baixo à direita, cabeça inteira. Resolve a pendência do v02.
- Figuras 1 a 3: como no v02 (duas mãos visíveis em todas).

## Ressalvas

- **Escala:** a figura 4 (v01) tem 408 px de altura contra 437 da figura 3 (v02), cerca de 7% menor. É diferença de desenho, não de enquadramento; a montagem do R4 deve normalizar a escala (por tronco) ou o seguimento "encolhe". Não reescalei para não alterar pixels sem pedido; posso gerar uma variante com a figura 4 ampliada em 7%, se quiser.
- **Emenda:** o fundo do quadrante colado tem o magenta do v02 (250,2,250), com a figura do v01 trazendo 251,3,251 ao redor; diferença de 1 nível, resíduo magenta pós-recorte 0,1 ponto (passa).
- Mesmas ressalvas do v02: altura (428-457 px) e margem (42 px) acima do pedido; figura 3 ainda lê um pouco como estocada.
- O ataque é um composto de duas gerações; o estilo é o mesmo, mas a figura 4 foi gerada com o prompt do v01 (preparo com machado sobre a cabeça), então o seguimento não "nasceu" do golpe da figura 3. A transição 3 → 4 é decisão à vista.
