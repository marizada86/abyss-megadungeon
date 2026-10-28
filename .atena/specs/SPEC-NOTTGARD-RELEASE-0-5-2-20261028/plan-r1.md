---
id: PLAN-NOTTGARD-RELEASE-0-5-2-20261028
revision: r1
status: PREPARED_AWAITING_BUILD_APPROVAL
platform: windows-x86_64
parent: PLAN-NOTTGARD-RELEASE-0-5-1-20261022
content_state: DRAFT
---

# Playtest 0.5.2

Substitui a 0.5.1 (34 commits de arte, VFX, códex e acessibilidade, mais o ajuste de equilíbrio dos chefes e o pacote de conforto).
Sem mudança de esquema de save: as chaves novas de `settings` (`keybinds`, `vsync`, `fps_cap`) são opcionais e têm padrão.

## Feito (2026-10-28)
- `core/version.gd` e os 3 presets de `export_presets.cfg` → 0.5.2 / 0.5.2.0.
- Equilíbrio: teto do cast em 55% e dos golpes desviáveis em 45% do PV máximo (`boss_mech.cast.max_hp_pct`, `boss_mech.hit_cap_pct`).
- Conforto: tremor segue "Impacto reduzido", VSync e limite de quadros, teclas remapeáveis, anel e som do cast, último golpe e golpes sofridos.
- `distribution/LEIA-ME.txt` e `NOTAS-DA-VERSAO.txt` da 0.5.2 (nesta pasta).
- Relatório: `.atena/vault/drafts/POLISH-0-5-2-20261028-r1.md`; assets: `PROMPTS-ASSETS-0-5-2-20261028-r1.md`.

## Falta (cada um exige aprovação do dono)
1. `tools/stamp_build.ps1`, exportar só o preset "Windows Playtest Publico" (uma instância do Godot por vez), smoke do exe (G4), zip (exe + LEIA-ME + NOTAS, sem `evidencias\`), SHA-256.
2. Envio/tag: só por pedido explícito.
3. Playtest humano (G6): quadros reais em Goranthis/Pilares e a sensação do teto nos chefes.
