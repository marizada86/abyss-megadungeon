---
id: PLAN-NOTTGARD-RELEASE-0-5-1-20261022
revision: r1
status: PREPARED_AWAITING_COMMIT_APPROVAL
platform: windows-x86_64
parent: PLAN-NOTTGARD-RELEASE-0-5-0-20261018
content_state: DRAFT
---

# Playtest 0.5.1

A 0.5.0 nunca chegou a testers; a 0.5.1 a substitui e inclui os 14 commits desde `e49756c`
(cadeia Docas > Reino Abissal > Domwieck > Dagruve, 180 s, rebalanceamento, cartas de oferta, HUD/Quartel, cartazes de chefe, Ecos, crônicas).
Sem mudança de esquema de save.

## Feito (2026-10-22, nada commitado nem publicado)
- `core/version.gd` e os 3 presets de `export_presets.cfg` → 0.5.1 / 0.5.1.0.
- `distribution/LEIA-ME.txt` e `distribution/NOTAS-DA-VERSAO.txt` da 0.5.1.
- Gates sobre a árvore de trabalho: contratos de versão/plataforma, deferrals, upgrade de save, suíte completa e auditoria (0 erros, 0 avisos) = PASS. G3 (bots) não rodou: os rebalanceamentos já foram medidos nos commits `da0c4e6`, `a792cca`, `dce57dd`, `32e4536`.

## Falta (cada um exige aprovação do dono)
1. Commit do bump + docs (para exportar de `git archive HEAD`, árvore limpa).
2. `tools/stamp_build.ps1`, exportar só o preset "Windows Playtest Publico" (uma instância do Godot por vez), smoke do exe (G4), montar zip (exe + LEIA-ME + NOTAS, sem `evidencias\`), SHA-256.
3. Envio/tag: só por pedido explícito.
