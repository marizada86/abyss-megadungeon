// Agrega a varredura M5: arms old/new/newm2 por mapa e política. Uso: node aggregate-m5.js [prefixo=s5]
const fs = require("fs"), path = require("path");
const dir = path.join(__dirname, "results");
const pfx = process.argv[2] || "s5";
const rows = [];
for (const f of fs.readdirSync(dir)) {
  const m = f.match(new RegExp("^" + pfx + "-(old|new|newm2)-(smartgod|smart|smartgodchain|smartchain)-([a-z_]+)-([a-z]+)\.jsonl$"));
  if (!m) continue;
  for (const l of fs.readFileSync(path.join(dir, f), "utf8").split("\n")) {
    if (!l.trim()) continue;
    const r = JSON.parse(l);
    rows.push({ arm: m[1], pol: m[2], hero: m[4], r });
  }
}
const avg = (a, k) => a.length ? a.reduce((s, x) => s + (x[k] || 0), 0) / a.length : NaN;
const f1 = (v, d = 1) => Number.isFinite(v) ? v.toFixed(d) : "-";
const order = ["dagruve","shedaklah","molor","durao","feng_tu","shendilavri","goranthis","pilares"];
for (const pol of ["smartgod", "smart"]) {
  console.log(`\n== ${pol === "smartgod" ? "IMORTAL (smart-god): pressão" : "MORTAL (smart): sobrevivência"} ==`);
  console.log("mapa".padEnd(12), "braço".padEnd(6), "n".padStart(3), pol === "smartgod" ? "vit%  t_chefe  dano/min  golpes_letais  abates  nivel" : "vit%  morte%  t_chefe  dano/min  abates  nivel  pv_min");
  for (const st of order) for (const arm of ["old", "new", "newm2"]) {
    const g = rows.filter(x => x.pol === pol && x.arm === arm && x.r.stage === st).map(x => x.r);
    if (!g.length) continue;
    const won = g.filter(r => r.boss_kill_time >= 0 || r.outcome === "cleared" || r.outcome === "won");
    const dead = g.filter(r => r.outcome === "dead");
    const tboss = won.length ? won.reduce((s, r) => s + (r.boss_kill_time >= 0 ? r.boss_kill_time - r.boss_time : (r.clear_time - r.boss_time)), 0) / won.length : NaN;
    const dpm = g.reduce((s, r) => s + (r.damage_taken || 0) / Math.max(1, (r.run_time || 1) / 60), 0) / g.length;
    const cols = pol === "smartgod"
      ? [f1(100 * won.length / g.length, 0).padStart(4), f1(tboss, 0).padStart(7), f1(dpm, 0).padStart(9), f1(avg(g, "lethal_hits"), 1).padStart(14), f1(avg(g, "kills"), 0).padStart(7), f1(avg(g, "level"), 1).padStart(6)]
      : [f1(100 * won.length / g.length, 0).padStart(4), f1(100 * dead.length / g.length, 0).padStart(6), f1(tboss, 0).padStart(8), f1(dpm, 0).padStart(9), f1(avg(g, "kills"), 0).padStart(7), f1(avg(g, "level"), 1).padStart(6), f1(avg(g, "min_hp_frac"), 2).padStart(7)];
    console.log(st.padEnd(12), arm.padEnd(6), String(g.length).padStart(3), cols.join("  "));
  }
}
console.log("\n== CAMPANHA ENCADEADA (de docas): até onde chega, nível por mapa ==");
for (const pol of ["smartgodchain", "smartchain"]) for (const arm of ["old", "new"]) {
  const g = rows.filter(x => x.pol === pol && x.arm === arm).map(x => x.r);
  if (!g.length) continue;
  const stages = {};
  for (const r of g) for (const s of r.segments) { (stages[s.stage] ??= []).push(s); }
  console.log(`${pol} ${arm} (n=${g.length}): ` + Object.entries(stages).map(([k, v]) => `${k}[${v.filter(s => s.result === "cleared" || s.result === "won").length}/${v.length} L${f1(avg(v, "level"), 1)} ${f1(avg(v, "t"), 0)}s]`).join(" "));
}
