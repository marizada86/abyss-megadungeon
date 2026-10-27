# Varredura das âncoras de chão dos efeitos (2026-10-27)

## Causa
Os efeitos ancorados no chão usavam a linha 196 da célula (borda de baixo da arte) como se fosse o centro do anel. O anel é uma
elipse achatada: ancorar a borda dele no ponto do chão o levantava 14 a 38 px acima do alvo. O Colar dos Tentáculos ainda tinha
`RING_PX`/`BASE_ANCHOR_Y` herdados de outra medida.

## Correção
- `VfxAtlas.GROUND_ROW` / `ground_offset_y(folha)`: tabela única com a linha do centro do anel de cada folha (medida na arte e
  confirmada no jogo). Folha fora da tabela usa a base (196).
- Consumidores migrados: `pickup_vfx` (poção, subida de nível, aura da Maré), `tentacle_vfx` (emersão e laço), `detonation_vfx`
  (mágica e física), `death_vfx` (chefe, alma), `boss_vfx` (estouro de fase, conjuração, escudo), `fire_burst_vfx`.
- Colar: `RING_PX` 184 -> 166 (o anel da arte era 12% mais estreito que o círculo do chão).

## Regressão
- `tests/test_vfx_ground_anchor.gd`: (1) a tabela confere com a linha do anel medida em cada folha de anel (tolerância 10 px);
  (2) os nós criados usam a tabela; (3) nenhum `core/*_vfx.gd` volta a escrever 196 ou `BASE_ANCHOR` à mão.
  Verificado: com `mare_aura` de volta em 196 o teste falha.
- `tools/vfx_ground_sweep.ps1`: quadro de contato (`sweep.png`) com cada efeito sobre o herói, elipse de referência e ponto do chão.

## Antes -> depois (px na tela, anel acima(-)/abaixo(+) do chão)
poção -14, subida de nível -38, detonação mágica -8, detonação física +20, estouro de fase -18, morte de chefe -20, morte de alma -12,
aura da Maré -14, Colar -44 (e 12% estreito). Depois: concêntricos em todos (ver `sweep.png`).

## Pendência encontrada (não corrigida aqui)
Cartão de oferta COMPACTO (6+ ofertas) com texto longo (nome em 2 linhas, categoria em 2, resumo em 3) ainda estoura pela base: a
faixa de preço e a tecla caem fora da moldura. Já ocorria antes das mudanças de hoje (captura de base idêntica). Exige limitar
linhas do texto ou redesenhar a altura do cartão compacto; o espaço vertical da loja em 720p é o limite.
