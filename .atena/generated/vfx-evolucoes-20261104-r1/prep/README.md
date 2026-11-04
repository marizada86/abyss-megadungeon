# Preparação dos VFX de evolução (2026-11-04)

Fontes aceitas: `assets_incoming/vfx-evolucoes-20261104-r1/sources/VE01..VE07`. Saída final: `assets/vfx/`.

1. `make_jobs.gd` mede os centros de luz e gera `jobs.json` (modo `vfx_atlas` de `tools/asset_prep.gd`, chave de preto).
   Voo: âncora comum = média dos centros de luz dos 4 quadros (sem tremer). Impacto: núcleo mais brilhante de cada quadro.
   Pulsos e zona: âncora no centro do anel; escala única para a sequência inteira.
2. `godot --headless --path . -s tools/asset_prep.gd -- <jobs.json>`.
3. `measure_atlas.gd`, `ring.gd` e `radial.gd` conferem margens, linha de chão do anel (140 para `abraco_laco`) e o raio do anel dominante no pico (82 para os dois pulsos). `render_check.gd` desenha tudo num quadro (`quadro_a.png`).

Mapa: VE01 `selo_retidao_evo`, VE02 `cajado_realizado_evo`, VE03 `eclipse_evo`, VE04 `memoria_reescrita_evo`, VE05 `pulso_vigilia`, VE06 `abraco_laco`, VE07 `pulso_ampulheta_tempo`.
