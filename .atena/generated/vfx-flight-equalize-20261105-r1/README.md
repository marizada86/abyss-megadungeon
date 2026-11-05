# Equalização do brilho dos voos de `eclipse_evo` e `cajado_realizado_evo`

Data: 2026-11-05. Estado: DRAFT. Autorização do dono: "Equalizar voos" (correção opcional do achado 1 de `evolution-assets-qa-20261104-r1/RELATORIO.md`).

## O que mudou

- Só `assets/vfx/eclipse_evo.png` e `assets/vfx/cajado_realizado_evo.png` (2048×256, quadros de 256 px).
- Apenas o **alfa** dos 4 primeiros quadros (voo). RGB de todos os quadros e os 4 quadros de impacto estão idênticos aos originais (0 pixels de diferença). Nenhum pixel transparente passou a ser visível.
- Alvo por arquivo: média das energias originais dos 4 quadros de voo (energia = soma de alfa × max(R,G,B)). Mistura é aditiva, então o ganho de alfa escala a luz de forma linear.

| Arquivo | Energia do voo antes | Ganhos por quadro | Energia depois | min/max antes → depois |
|---|---|---|---|---|
| eclipse_evo | 1131 / 1627 / 1977 / 1227 | 1,453 / 0,916 / 0,754 / 1,290 | 1490 (os 4) | 0,57 → 1,00 |
| cajado_realizado_evo | 2338 / 2962 / 3652 / 2290 | 1,425 / 0,949 / 0,770 / 1,492 | 2810 (os 4) | 0,63 → 1,00 |

A forma dos quadros (crescer e encolher o rastro) foi preservada; só a intensidade ficou constante. Prévia aditiva sobre preto em `preview-antes-depois.png` (linhas: eclipse antes, eclipse depois, cajado antes, cajado depois).

## Verificação

- `tests/run_all.gd` em perfil sintético (APPDATA/LOCALAPPDATA isolados, `--controller-profile`): 0 falhas, sem erros. O working tree tem outras alterações não commitadas de outras frentes (por exemplo em `core/projectile_vfx.gd`), incluídas nessa rodada.
- Hashes dos arquivos aplicados conferem com os gerados (`novo.sha256`).
- Não foi feita captura em jogo nem teste visual com animação em combate real.

## Reverter

Os originais estão em `original/` com `original.sha256`. Basta copiar de volta para `assets/vfx/`. Os arquivos `.import` não mudaram.

## Não feito

Commit, push, atualização do `plan.yaml`, mudança de runtime ou de outras VFX.

## Reproduzir

`measure.gd`, `equalize.gd` e `compare.gd` rodam num projeto Godot sintético (`config_version=5`), com `--headless -s res://<script>.gd -- <args>` (veja o cabeçalho de cada script).
