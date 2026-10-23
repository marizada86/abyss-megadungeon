const fs = require('fs');
const path = require('path');
const dir = path.join(__dirname, 'gif-frames');
const files = fs.readdirSync(dir).filter(f => /^frame-\d+.gif$/.test(f)).sort();
const first = fs.readFileSync(path.join(dir, files[0]));
const header = Buffer.from(first.subarray(0, 13));
header.write('GIF89a', 0, 'ascii');
header[10] &= 0x7f;
const chunks = [header, Buffer.from([0x21,0xff,0x0b]), Buffer.from('NETSCAPE2.0'), Buffer.from([3,1,0,0,0])];
for (const file of files) {
  const b = fs.readFileSync(path.join(dir, file));
  const packed = b[10];
  const paletteSize = 3 * (1 << ((packed & 7) + 1));
  const palette = packed & 128 ? b.subarray(13, 13 + paletteSize) : null;
  let p = 13 + (palette ? paletteSize : 0);
  while (b[p] === 0x21) {
    p += 2;
    while (b[p]) p += 1 + b[p];
    p++;
  }
  if (b[p] !== 0x2c) throw new Error('Missing image descriptor');
  const descriptor = Buffer.from(b.subarray(p, p + 10));
  p += 10;
  let localPalette;
  if (descriptor[9] & 128) {
    const size = 3 * (1 << ((descriptor[9] & 7) + 1));
    localPalette = b.subarray(p, p + size); p += size;
  } else {
    if (!palette) throw new Error('Missing palette');
    localPalette = palette;
    descriptor[9] = (descriptor[9] & 0x78) | 0x80 | (packed & 7);
  }
  const start = p++;
  while (b[p]) p += 1 + b[p];
  p++;
  chunks.push(Buffer.from([0x21,0xf9,4,4,4,0,0,0]), descriptor, localPalette, b.subarray(start,p));
}
chunks.push(Buffer.from([0x3b]));
const output = 'F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall/durvall_gate1_preview_v02.gif';
fs.writeFileSync(output, Buffer.concat(chunks));
console.log(JSON.stringify({output, frames: files.length, width:first.readUInt16LE(6),height:first.readUInt16LE(8),durationSeconds:files.length*0.04,bytes:fs.statSync(output).size}));
