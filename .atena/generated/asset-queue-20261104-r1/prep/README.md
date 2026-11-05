# Preparação dos VFX do Arlindo (2026-11-04)

Fontes aceitas: `assets_incoming/queue-20261104-r1/sources/memoria_projetil_v01.png` (1536x1024, 4x2 de 384x512) e `memoria_habilidade_v01.png` (2172x724).

- Projétil -> `assets/vfx/orbe_memoria.png` (2048x256): âncora do voo = média dos centros de luz; impacto = núcleo mais brilhante. Família `orbe_memoria` em `ProjectileVfx.FAMILIES` (`own_color`: o deus só matiza), `memoria_alterada` e a evolução como reserva.
- Habilidade -> `assets/vfx/habilidade_arlindo.png` (1536x256): os 6 quadros NÃO têm largura uniforme (peak 391 px); as fronteiras foram medidas nos vales de luz (`hab_split.gd`: 327, 688, 1074, 1465, 1818), e cortar em 362 px fixos decepava o anel. `ref_px` = alcance da luz no quadro de pico (110; `reach.gd` mede o mesmo critério nas folhas dos outros heróis).
- Pipeline: `make_jobs_arlindo.gd` -> `jobs_arlindo.json` -> `tools/asset_prep.gd` (modo `vfx_atlas`).

## Arte estática A06, A07 e A08 (2026-11-04)

As três fontes aceitas já têm alfa real. `prep_sprites.gd` recorta a caixa útil, reduz com Lanczos a 208 px de largura (6 px de margem nos altares, 4 px na montanha) e devolve tela justa.
- A06 -> `assets/interactions/altar_do_limo.png` (208x144) e A07 -> `assets/interactions/altar_disputado_feng_tu.png` (208x137); ligados por `"asset"` em `data/stage_events.json` (eventos `altar_disputado_shedaklah` e `altar_disputado_feng_tu`).
- A08 -> `assets/props/montanha_runica_01.png` (208x236). `Ridge` (`ui/terrain_features.gd`) usa a arte: a largura do embasamento (200 px dos 208) coincide com a elipse de colisão do raio (raio x sqrt(2) x TILE_W), a base apoia-se a 80% da borda da frente, e as montanhas alternadas saem espelhadas. Sem o PNG vale o desenho antigo. A colisão (TerrainLayout.MOUNTAINS) não mudou.
