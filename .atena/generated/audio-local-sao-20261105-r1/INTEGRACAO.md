# Áudio gerado localmente (Stable Audio Open 1.0), 2026-11-05

Decisão do dono: sem LUDO.AI (custo); teste local aprovado e ouvido por ele.

## Integrado
- 12 SFX de evolução (E01-E12), `weapon.<id>.fire_01.wav` (semente 101) e `_02.wav` (semente 202), em `assets/audio/sfx/weapon/`.
- 3 ambiências: `docas.wav`, `reino_abissal.wav`, `domwieck.wav` (9 s, loop por crossfade de 1 s) em `assets/audio/ambience/`.
  Escolhas: A01 v2 s101, A02 v2 s101, A03 v2 s202 (A03 v2 s101 rejeitada pelo dono; a 1ª rodada foi rejeitada por tom de terror).
- `data/audio_manifest.json`: 12 eventos `weapon.*.fire` apontam para os arquivos novos (o campo `pitch` foi mantido: `test_vfx_sfx_coverage` exige tom próprio entre 0,7 e 1,3); ambiências `docas`, `reino_abissal`, `domwieck` deixam de reaproveitar outros mapas.
- Formato do jogo: mono, 22 050 Hz, PCM 16. Ambiências niveladas por RMS (alvo 0,109) com limitador suave; `reino_abissal` ficou em 0,047 por causa dos picos de gotas.
- Testes (headless, perfil isolado): test_audio, test_vfx_sfx_coverage, test_new_content, test_stage_deferrals: 0 falhas.

## Pendente
- Músicas M01-M03 (Docas, Reino Abissal, Domwieck): não geradas; o modelo é fraco em música. Seguem reaproveitando faixas de outros mapas.
- Licença Stability AI Community: registro em stability.ai/community-license, aviso "Powered by Stability AI" visível no jogo ou na documentação, arquivo Notice com a linha de licença, e limite de US$ 1 mi de receita anual. Decisão e execução do dono antes de distribuir.
- Renomeação por direitos autorais do jogo continua pendente.
- Reproduzir: ambiente em `F:\dev\audio-lab` (venv, modelo em cache do Hugging Face); scripts nesta pasta.
