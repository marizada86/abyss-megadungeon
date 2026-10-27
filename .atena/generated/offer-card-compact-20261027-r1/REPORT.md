# Cartão de oferta compacto (6+ ofertas) com texto longo (2026-10-27)

## Problema
No pior caso de texto (nome em 2 linhas, categoria em 2, resumo em 3, selo ▲▼, preço longo, etiqueta de escola) o conteúdo pedia
~66 px a mais que os 232 px do cartão: a faixa de preço e a tecla caíam fora da moldura e invadiam a fileira de baixo.
O selo e a faixa de preço dividiam a base e quebravam em duas linhas (a coluna útil tem ~152 px); o preço longo ("vende X: 20",
176 px) ainda passava da largura e cobria a tecla.

## Correção (ui/offer_card.gd, só no modo compacto)
- O selo (▲▼ ou "Nv N") sobe para a coluna do ícone, sob a fita; a base fica só com a faixa de preço + tecla (1 linha).
- Placa do ícone 76 -> 70 px (ícone 56).
- Categoria em 1 linha com reticências; resumo com 3 linhas (2 quando há etiqueta de escola).
- Faixa "vende X: N" com 140 px no compacto (176 no completo).

## Medição (tools/offer_cards_sweep.ps1, 1280x720 e 1920x1080, perfil sintético)
Cartões com a faixa de preço fora da moldura ou sobre a tecla: 6 de 6 antes -> 0 de 6 depois. Capturas: antes-6-*.png, depois-6-*.png.
Teste: tests/test_offer_card_compact.gd (falha no desenho antigo, passa no novo).

## Cartão completo estreito (5 ofertas, 217 px) — corrigido
Selo e preço quebravam em duas linhas (+29 px) e a faixa encostava na tecla (5 de 5 cartões); a faixa "vende X: N" (176 px) passava da
coluna útil (157 px). Correção: `OfferCard.height_for` dá +20 px de altura ao cartão completo com largura < 250 px (460 em vez de 440),
e a faixa longa é limitada à coluna útil. Medição: 5 de 5 -> 0 de 5 (1280x720 e 1920x1080). Capturas: antes-5-*.png, depois-5-*.png.
Teste: `run_narrow` em tests/test_offer_card_compact.gd.
