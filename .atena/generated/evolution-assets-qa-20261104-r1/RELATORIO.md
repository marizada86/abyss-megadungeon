# QA dos assets das evoluções — 2026-11-04

Escopo: 25 ícones (13 passivas, 12 evoluções) e 7 VFX integrados em `42fce70`. Somente leitura + capturas em perfil sintético (`render.ps1`, APPDATA isolado); nenhum save real, nenhum arquivo do jogo alterado.

## Auditoria de padrões (`audit.gd`, resultado em `audit-result.txt`)

152 verificações OK, 2 achados.

- Cobertura: todas as armas e passivas do jogo têm PNG próprio; as 12 evoluções resolvem o ícone próprio (sem `icon_like`).
- Ícones: 128×128 RGBA, cantos e borda transparentes, margem ≥ 3 px, sem cinza de fundo residual (< 2%), ocupação média 5941 px (existentes 4616 px).
- VFX: tamanhos 2048×256 (projéteis) e 1536×256 (áreas), margem ≥ 20 px por célula, borda com alfa 0, impactos desvanecem, pulsos com pico e dissipação.
- `.import` dos 26 arquivos novos idênticos aos dos assets equivalentes já aceitos; todos têm `.import` e estão versionados.
- Roteamento: família evoluída + fallback para a base nos 4 projéteis; Vigília, Ampulheta evoluída e Abraço roteados; `abraco_laco` na tabela de âncoras.
- Testes: `tests/run_all.gd` com 0 falhas e `tools/audit_projeto.gd` com 0 erros e 0 avisos.

### Achados
1. Voo de `eclipse_evo` (mín/máx de brilho 0,57) e `cajado_realizado_evo` (0,63) varia mais que as famílias-base (0,65 a 0,81) e que as evoluções do Lote 3 (0,92 a 0,95). Vem da fonte aceita ("voos com variação sutil"); nas capturas não incomoda, mas pode piscar em ritmo de 12 fps. Correção opcional: equalizar o brilho dos 4 quadros de voo na preparação.
2. Estilo: os ícones novos são pintados e detalhados; ícones antigos como `forca`, `carisma` e `cota_de_malha` são mais simples (pixel art). Já havia mistura no jogo (por exemplo `memoria_alterada`, `tocha_do_incendiario`). Decisão estética do dono.

## Capturas (`captures/`)
01 ícones de armas antes/depois · 02 passivas novas e referência · 03 oferta de evoluções · 04 e 05 ofertas de passivas novas · 06 HUD com as armas · 07 ficha, aba Armas · 08 ficha, aba Passivas · `vfx-*.png` sequências em combate real (linha de cima = arma base, linha de baixo = evolução).

Observação do método: o cenário de teste que deixou Vela e Ampulheta sem efeito na primeira rodada foi corrigido (alvos fora do raio da arma base). Os pulsos de área foram capturados em câmera lenta (`Engine.time_scale` 0,25); a cor dos VFX segue o tema do deus do herói (Sylas), como nos demais.
