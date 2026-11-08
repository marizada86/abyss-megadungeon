// uso: node apply_lote.js <lote>  -> aplica votos de audition_<lote>\resultado.json no jogo
const fs = require('fs');
const lote = process.argv[2];
const GAME = 'F:/dev/abyss-megadungeon', AUD = `F:/dev/audio-lab/audition_${lote}`;
const votes = JSON.parse(fs.readFileSync(`${AUD}/resultado.json`, 'utf8'));
const items = JSON.parse(fs.readFileSync(`${AUD}/items.json`, 'utf8'));
let manifest = fs.readFileSync(`${GAME}/data/audio_manifest.json`, 'utf8');
const count = { atual: 0, regerar: 0, aplicado: 0 }, log = [], mp3 = [];
for (const it of items) {
  const v = votes[it.event];
  if (v === undefined) { log.push('SEM VOTO ' + it.event); continue; }
  if (v === 'atual') { count.atual++; continue; }
  if (v === 'regerar') { count.regerar++; log.push('regerar ' + it.event); continue; }
  const src = `${AUD}/sfx/i${it.n}_${v}.wav`;
  if (!fs.existsSync(src)) { log.push('SEM ORIGEM ' + src); continue; }
  for (const t of it.targets) {
    const dst = t.replace(/\.mp3$/, '.wav');
    if (dst !== t) mp3.push([t, dst]);
    fs.copyFileSync(src, `${GAME}/${dst}`);
  }
  count.aplicado++;
}
for (const [a, b] of mp3) {
  const s = `"res://${a}"`;
  if (!manifest.includes(s)) { log.push('manifesto sem ' + a); continue; }
  manifest = manifest.split(s).join(`"res://${b}"`);
}
if (mp3.length) fs.writeFileSync(`${GAME}/data/audio_manifest.json`, manifest);
console.log(JSON.stringify(count), 'mp3->wav:', mp3.length);
console.log(log.join('\n'));
