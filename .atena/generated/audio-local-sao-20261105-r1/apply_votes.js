const fs = require('fs');
const GAME = 'F:/dev/abyss-megadungeon', ST = 'F:/dev/audio-lab/pilot/staging';
const votes = JSON.parse(fs.readFileSync('F:/dev/audio-lab/audition/resultado.json', 'utf8'));
const L = fs.readFileSync(GAME + '/.atena/generated/audio-brief-20261105-r1/audio-prompts.csv', 'utf8').replace(/^\uFEFF/, '').split(/\r?\n/).filter(Boolean);
const parse = l => { const o = []; let c = '', q = false; for (const ch of l) { if (ch == '"') q = !q; else if (ch == ',' && !q) { o.push(c); c = '' } else c += ch } o.push(c); return o };
const target = {}; for (const r of L.slice(1).map(parse)) if (r[0] == 'S-sfx-arma' || r[0] == 'S-sfx-habilidade') target[r[2]] = r[7];
let n = 0; const log = [];
for (const [ev, v] of Object.entries(votes)) {
  if (v !== 'novo_01' && v !== 'novo_02') { log.push('ignorado ' + ev + ' ' + v); continue; }
  const rel = target[ev]; const tag = v === 'novo_01' ? '01' : '02';
  const src = `${ST}/${rel.replace('_01.wav', '_' + tag + '.wav')}`;
  if (!fs.existsSync(src)) { log.push('SEM ORIGEM ' + src); continue; }
  for (const t of ['01', '02']) { fs.copyFileSync(src, `${GAME}/${rel.replace('_01.wav', '_' + t + '.wav')}`); n++; }
}
console.log('arquivos copiados', n, 'de', Object.keys(votes).length * 2); console.log(log.join('\n'));
