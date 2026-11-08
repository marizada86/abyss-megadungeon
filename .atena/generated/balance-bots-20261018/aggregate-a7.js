// Compara Arlindo a6 (antes) x a7 (depois do ajuste da Memória Alterada), 3 sementes por mapa.
const fs = require("fs"), path = require("path");
const dir = path.join(__dirname, "results");
const stages = ["docas","reino_abissal","domwieck","dagruve","shedaklah","molor","durao","feng_tu","shendilavri","goranthis","pilares"];
const won = r => r.boss_kill_time >= 0 || r.outcome === "cleared" || r.outcome === "won";
const load = (tag, pol) => { const rows = []; for (const st of stages) { const f = path.join(dir, `${tag}-${pol}-${st}-arlindo.jsonl`); if (!fs.existsSync(f)) continue;
  for (const l of fs.readFileSync(f, "utf8").split("\n")) if (l.trim()) try { rows.push(JSON.parse(l)); } catch (e) {} } return rows; };
const avg = (a, k) => a.reduce((s, x) => s + (x[k] || 0), 0) / (a.length || 1);
const cell = (g) => { if (!g.length) return "-"; const t = avg(g, "run_time"); return `${g.filter(won).length}/${g.length} · ${Math.round(avg(g, "damage_taken") / (t / 60))} · ${(avg(g, "min_hp_frac") * 100).toFixed(0)}% · ${avg(g, "kills").toFixed(0)}`; };
const out = ["| mapa | a6 imortal (vit · dano/min · PV mín · abates) | a7 imortal |", "|---|---|---|"];
const A = load("a6", "god"), B = load("a7", "god");
let wa = 0, wb = 0;
for (const st of stages) { const a = A.filter(r => r.stage === st), b = B.filter(r => r.stage === st); wa += a.filter(won).length; wb += b.filter(won).length; out.push(`| ${st} | ${cell(a)} | ${cell(b)} |`); }
out.push(`| **total** | ${wa}/${A.length} | ${wb}/${B.length} |`);
const MA = load("a6", "mort"), MB = load("a7", "mort");
out.push("", "Mortal (capítulo 1): a6 " + MA.filter(won).length + "/" + MA.length + ", a7 " + MB.filter(won).length + "/" + MB.length);
out.push("Mortal, tempo de sobrevivência médio (s): a6 " + avg(MA, "run_time").toFixed(0) + ", a7 " + avg(MB, "run_time").toFixed(0));
fs.writeFileSync(path.join(dir, "a7-aggregate.md"), out.join("\n") + "\n");
console.log(out.join("\n"));
