const fs = require("fs"), path = require("path");
const dir = path.join(__dirname, "results");
const rows = [];
for (const f of fs.readdirSync(dir)) {
  const m = f.match(/^s5-(old|new|newm2)-smartgod-([a-z_]+)-([a-z]+)\.jsonl$/);
  if (!m) continue;
  for (const l of fs.readFileSync(path.join(dir, f), "utf8").split("\n")) if (l.trim()) rows.push({ arm: m[1], hero: m[3], r: JSON.parse(l) });
}
const avg = (a, k) => a.length ? a.reduce((s, x) => s + (x[k] || 0), 0) / a.length : NaN;
const f1 = (v, d = 0) => Number.isFinite(v) ? v.toFixed(d) : "-";
const order = ["dagruve","shedaklah","molor","durao","feng_tu","shendilavri","goranthis"];
console.log("-- tempo total do mapa (s), ouro, abates/min, e vitória por herói (old new newm2) --");
for (const st of order) {
  const line = [st.padEnd(12)];
  for (const arm of ["old", "new", "newm2"]) {
    const g = rows.filter(x => x.arm === arm && x.r.stage === st).map(x => x.r);
    const w = g.filter(r => r.boss_kill_time >= 0 || r.outcome === "cleared" || r.outcome === "won");
    line.push(`${arm}: dur=${f1(avg(g, "run_time"))}s(venc ${f1(avg(w, "run_time"))}s) ouro=${f1(avg(g, "gold"))} ab/min=${f1(avg(g, "kills") / (avg(g, "run_time") / 60), 1)}`);
  }
  console.log(line.join(" | "));
}
console.log("\n-- vitórias por herói (de 2 sementes) --");
for (const st of ["molor","durao","feng_tu","shendilavri","goranthis"]) {
  const parts = [];
  for (const arm of ["old", "new", "newm2"]) {
    const o = [];
    for (const h of ["durvall","brook","maelor"]) {
      const g = rows.filter(x => x.arm === arm && x.hero === h && x.r.stage === st).map(x => x.r);
      o.push(h.slice(0,3) + " " + g.filter(r => r.boss_kill_time >= 0 || r.outcome === "cleared" || r.outcome === "won").length + "/" + g.length);
    }
    parts.push(arm + ": " + o.join(", "));
  }
  console.log(st.padEnd(12), parts.join(" | "));
}
