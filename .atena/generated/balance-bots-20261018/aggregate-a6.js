// Agrega a varredura a4 (12 heróis x 11 mapas, 3 sementes): vitórias, tempo, pressão e piso de PV por mapa e por herói.
const fs = require("fs"), path = require("path");
const dir = path.join(__dirname, "results");
const rows = [];
for (const f of fs.readdirSync(dir)) {
  const m = f.match(/^a6-(god|mort)-([a-z_]+)-([a-z]+)\.jsonl$/);
  if (!m) continue;
  for (const l of fs.readFileSync(path.join(dir, f), "utf8").split("\n")) if (l.trim()) { try { rows.push({ pol: m[1], hero: m[3], r: JSON.parse(l) }); } catch (e) {} }
}
const won = r => r.boss_kill_time >= 0 || r.outcome === "cleared" || r.outcome === "won";
const avg = (a, k) => a.length ? a.reduce((s, x) => s + (x[k] || 0), 0) / a.length : NaN;
const f1 = (v, d = 0) => Number.isFinite(v) ? v.toFixed(d) : "-";
const stages = ["docas","reino_abissal","domwieck","dagruve","shedaklah","molor","durao","feng_tu","shendilavri","goranthis","pilares"];
const heroes = ["durvall","brook","maelor","sylas","kayron","korrak","leoric","nyrelia","zynara","bromnor","arlindo","erik"];
const out = [];
for (const pol of ["god", "mort"]) {
  const sub = rows.filter(x => x.pol === pol);
  if (!sub.length) continue;
  out.push(`\n## Política ${pol === "god" ? "imortal (mede pressão)" : "mortal (mede se morre)"} — ${sub.length} partidas`);
  out.push("\n### Por mapa\n| mapa | partidas | vitórias | tempo médio (s) | dano/min | PV mínimo médio | nível final | abates/min |\n|---|---:|---:|---:|---:|---:|---:|---:|");
  for (const st of stages) {
    const g = sub.filter(x => x.r.stage === st).map(x => x.r);
    if (!g.length) continue;
    const t = avg(g, "run_time");
    out.push(`| ${st} | ${g.length} | ${g.filter(won).length} | ${f1(t)} | ${f1(avg(g, "damage_taken") / (t / 60))} | ${f1(avg(g, "min_hp_frac") * 100)}% | ${f1(avg(g, "level"), 1)} | ${f1(avg(g, "kills") / (t / 60), 1)} |`);
  }
  out.push("\n### Vitórias por herói e mapa (de 3 sementes)\n| herói | " + stages.join(" | ") + " | total |\n|---|" + stages.map(() => "---:").join("|") + "|---:|");
  for (const h of heroes) {
    let tot = 0, n = 0;
    const cells = stages.map(st => {
      const g = sub.filter(x => x.hero === h && x.r.stage === st).map(x => x.r);
      if (!g.length) return "-";
      const w = g.filter(won).length; tot += w; n += g.length; return `${w}/${g.length}`;
    });
    out.push(`| ${h} | ${cells.join(" | ")} | ${tot}/${n} |`);
  }
  out.push("\n### Dano recebido por minuto, por herói (menor = mais robusto), mapas de meio a fim\n| herói | " + ["shedaklah","molor","durao","feng_tu","shendilavri","goranthis","pilares"].join(" | ") + " |\n|---|---:|---:|---:|---:|---:|---:|---:|");
  for (const h of heroes) {
    const cells = ["shedaklah","molor","durao","feng_tu","shendilavri","goranthis","pilares"].map(st => {
      const g = sub.filter(x => x.hero === h && x.r.stage === st).map(x => x.r);
      return g.length ? f1(avg(g, "damage_taken") / (avg(g, "run_time") / 60)) : "-";
    });
    out.push(`| ${h} | ${cells.join(" | ")} |`);
  }
  const reasons = {};
  for (const x of sub) { const k = x.r.outcome + (x.r.death_reason ? "/" + x.r.death_reason : ""); reasons[k] = (reasons[k] || 0) + 1; }
  out.push("\n### Desfechos\n" + Object.entries(reasons).sort((a, b) => b[1] - a[1]).map(([k, v]) => `- ${k}: ${v}`).join("\n"));
}
console.log(out.join("\n"));
