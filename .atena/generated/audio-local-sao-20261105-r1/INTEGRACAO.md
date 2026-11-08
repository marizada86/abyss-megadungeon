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

## Piloto de SFX de armas e habilidades (2026-11-08)
- 40 eventos (28 armas, 12 habilidades) gerados com 2 variações (sementes 101 e 202); 15 eventos que compartilham arquivo com outro herdam o som do primeiro.
- Dono votou na ferramenta de audição (`F:\dev\audio-lab\audition`): 40 de 40 preferiram o novo (21 novo_01, 19 novo_02), nenhum "manter atual" ou "gerar de novo".
- Aplicado: a variação escolhida substitui `_01` e `_02` do evento (80 WAV; nomes e manifesto inalterados). Pico e duração igualados aos arquivos anteriores.
- Testes headless isolados (audio, impact_fx, new_content, options_menu, quartel, save_upgrade_050, stage_deferrals, vfx_sfx_coverage, volume_and_result_panel): 0 falhas.
- Scripts: pilot_sfx.py, apply_votes.js em `F:\dev\audio-lab`. Reverter: `git checkout -- assets/audio/sfx/weapon assets/audio/sfx/hero`.

## Lote 1 de SFX (2026-11-08)

Combate, jogador, UI, progressão, mundo e resultado: 70 eventos, 153 clipes gerados com Stable Audio Open (`gen_batch.py`, sementes 101/202/303), votados pelo dono na ferramenta de audição. Votos em `resultado-lote1.json` (alvos em `items-lote1.json`).

- 17 mantiveram o som atual (incluindo os 13 eventos em mp3: nenhum foi trocado, então o manifesto não mudou).
- 46 receberam o clipe escolhido, copiado sobre todos os arquivos do evento (`apply_lote.js lote1`).
- 7 pediram nova geração (`regerar`): player.overdrive, world.ritual, world.portal, world.descent, world.elite, result.victory, result.defeat. Regerados com sementes 404/505/606 (`gen_regen.py`, lote `lote1r`).
- Testes `test_audio` e `test_vfx_sfx_coverage` com 0 falha (APPDATA isolado). Licença Stability: obrigações ainda pendentes (ver seções anteriores).
