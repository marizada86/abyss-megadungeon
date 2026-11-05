const fs = require('fs');
const p = 'F:/dev/abyss-megadungeon/data/audio_manifest.json';
let t = fs.readFileSync(p, 'utf8'); let n = 0;
const ev = ['estocada_transfixante','vigilia_perpetua','selo_da_retidao','chicote_da_cobica','machado_devorador','abraco_dos_tentaculos','lamina_dissolvente','cajado_dos_desejos_realizados','ampulheta_do_tempo_parado','lamina_do_eclipse','memoria_reescrita','pira_do_incendiario'];
for (const k of ev) {
  const key = '"weapon.' + k + '.fire": {';
  const i = t.indexOf(key); if (i < 0) { console.log('sem evento', k); continue; }
  const a = t.indexOf('"files": [', i), b = t.indexOf(']', a);
  const block = t.slice(a, b + 1);
  const m = block.match(/\n([ \t]*)"res:/); const ind = m[1];
  const nl = block.includes('\r\n') ? '\r\n' : '\n';
  const closeInd = block.match(/\n([ \t]*)\]$/)[1];
  const repl = '"files": [' + nl + ind + '"res://assets/audio/sfx/weapon/weapon.' + k + '.fire_01.wav",' + nl + ind + '"res://assets/audio/sfx/weapon/weapon.' + k + '.fire_02.wav"' + nl + closeInd + ']';
  t = t.slice(0, a) + repl + t.slice(b + 1); n++;
}
for (const k of ['docas', 'reino_abissal', 'domwieck']) {
  const s = t.indexOf('"ambience": {'); const re = new RegExp('("' + k + '": ")[^"]+(")');
  const head = t.slice(0, s), tail = t.slice(s).replace(re, '$1res://assets/audio/ambience/' + k + '.wav$2'); t = head + tail; n++;
}
console.log('substituicoes', n); fs.writeFileSync(p, t);
