// Agrega a rodada a5: sensibilidade a nível (L-8, L-4, L) e ao Quartel (full x none) em Shendilavri, Goranthis e Pilares, 6 sementes por herói.
const fs = require("fs"), path = require("path");
const dir = path.join(__dirname, "results");
const rows = [];
for (const f of fs.readdirSync(dir)) {
  const m = f.match(/^a5-([a-z_]+)-L(\d+)-(full|none)-([a-z]+)\.jsonl$/);
  if (!m) continue;
  for (const l of fs.readFileSync(path.join(dir, f), "utf8").split("\n")) if (l.trim()) { try { rows.push({ stage: m[1], lv: +m[2], meta: m[3], hero: m[4], r: JSON.parse(l) }); } catch (e) {} }
}
const won = r => r.boss_kill_time >= 0 || r.outcome === "cleared" || r.outcome === "won";
const avg = (a, k) => a.length ? a.reduce((s, x) => s + (x[k] || 0), 0) / a.length : NaN;
const f1 = (v, d = 0) => Number.isFinite(v) ? v.toFixed(d) : "-";
const heroes = ["durvall","brook","maelor","sylas","kayron","korrak","leoric","nyrelia","zynara","bromnor","arlindo","erik"];
const out = [`# Rodada a5 — ${rows.length} partidas (imortal, 6 sementes por célula)`];
const keys = [...new Set(rows.map(x => `${x.stage}|${x.lv}|${x.meta}`))].sort();
out.push("\n## Por configuração\n| mapa | nível | Quartel | partidas | vitórias | % | dano/min | PV mínimo médio | tempo até o chefe morrer (s, só vitórias) |\n|---|---:|---|---:|---:|---:|---:|---:|---:|");
for (const k of keys) {
  const [st, lv, meta] = k.split("|");
  const g = rows.filter(x => x.stage === st && x.lv === +lv && x.meta === meta).map(x => x.r);
  const w = g.filter(won);
  out.push(`| ${st} | ${lv} | ${meta} | ${g.length} | ${w.length} | ${f1(100 * w.length / g.length)}% | ${f1(avg(g, "damage_taken") / (avg(g, "run_time") / 60))} | ${f1(avg(g, "min_hp_frac") * 100)}% | ${f1(avg(w.map(r => ({ t: r.boss_kill_time >= 0 ? r.boss_kill_time : r.clear_time })), "t"))} |`);
}
for (const st of ["shendilavri", "goranthis", "pilares"]) {
  const cfgs = [...new Set(rows.filter(x => x.stage === st).map(x => `${x.lv}|${x.meta}`))].sort((a, b) => +a.split("|")[0] - +b.split("|")[0]);
  out.push(`\n## ${st} — vitórias por herói (de 6)\n| herói | ` + cfgs.map(c => c.replace("|", " ")).join(" | ") + " |\n|---|" + cfgs.map(() => "---:").join("|") + "|");
  for (const h of heroes) {
    out.push(`| ${h} | ` + cfgs.map(c => { const [lv, meta] = c.split("|"); const g = rows.filter(x => x.stage === st && x.hero === h && x.lv === +lv && x.meta === meta).map(x => x.r); return g.length ? `${g.filter(won).length}/${g.length}` : "-"; }).join(" | ") + " |");
  }
}
console.log(out.join("\n"));
