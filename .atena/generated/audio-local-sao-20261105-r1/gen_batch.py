"""Gera um lote de SFX (todas as variacoes de cada evento) e monta a ferramenta de audicao do lote.
uso: gen_batch.py <nome_do_lote> <grupo> [<grupo> ...]   (ex.: lote1 S-sfx-combat S-sfx-player)
Saida em F:\\dev\\audio-lab\\audition_<lote>\\ (sfx, items.json, ferramenta). NAO toca o jogo."""
import sys, csv, os, json, time, shutil, numpy as np, torch, soundfile as sf
from scipy.signal import resample_poly
from stable_audio_tools import get_pretrained_model
from stable_audio_tools.inference.generation import generate_diffusion_cond

lote, groups = sys.argv[1], set(sys.argv[2:])
GAME = r"F:\dev\abyss-megadungeon"; LAB = r"F:\dev\audio-lab"
CSV = GAME + r"\.atena\generated\audio-brief-20261105-r1\audio-prompts.csv"
AUD = LAB + "\\audition_" + lote
os.makedirs(AUD + r"\sfx", exist_ok=True)
man = json.load(open(GAME + r"\data\audio_manifest.json", encoding="utf-8"))["events"]
rows = [r for r in csv.DictReader(open(CSV, encoding="utf-8-sig")) if r["grupo"] in groups]
seen, jobs = set(), []
for r in rows:
    ev = r["evento_ou_arquivo"]; e = man.get(ev)
    if not e:
        print("SEM EVENTO", ev, flush=True); continue
    files = tuple(e["files"])
    if any(f in seen for f in files):
        print("PULA (arquivo compartilhado):", ev, flush=True); continue
    seen.update(files); jobs.append((r, e))
print(len(jobs), "eventos;", sum(len(e["files"]) for _, e in jobs), "clipes", flush=True)


def load_cur(path):
    p = GAME + "\\" + path.replace("res://", "").replace("/", "\\")
    a, sr0 = sf.read(p)
    a = a if a.ndim == 1 else a.mean(1)
    if sr0 != 22050:
        a = resample_poly(a, 22050, sr0)
    return a


NEG = "music, melody, voice, speech, long reverb tail, noise floor, distortion"
model, cfg = get_pretrained_model("stabilityai/stable-audio-open-1.0")
sr = cfg["sample_rate"]
model = model.to("cuda").to(torch.float16).eval()
size = lambda s: int(-(-s * sr // 2048) * 2048)
items = []
for k, (r, e) in enumerate(jobs, 1):
    ev, secs = r["evento_ou_arquivo"], float(r["duracao_s"])
    n = "%03d" % k
    cur = load_cur(e["files"][0])
    L = len(cur) / 22050
    pk = float(abs(cur).max())
    sf.write(AUD + "\\sfx\\i%s_atual.wav" % n, np.clip(cur, -1, 1), 22050, subtype="PCM_16")
    kinds = ["atual"]
    targets = [f.replace("res://", "") for f in e["files"]]
    for vi, seed in enumerate((101, 202, 303)[: len(e["files"])], 1):
        t0 = time.time()
        kind = "novo_%02d" % vi
        dst = AUD + "\\sfx\\i%s_%s.wav" % (n, kind)
        if not os.path.exists(dst):
            audio = generate_diffusion_cond(model, steps=50, cfg_scale=7,
                conditioning=[{"prompt": r["prompt"], "seconds_start": 0, "seconds_total": secs}],
                negative_conditioning=[{"prompt": NEG, "seconds_start": 0, "seconds_total": secs}],
                sample_size=size(max(2.0, secs + 0.5)), sigma_min=0.3, sigma_max=500,
                sampler_type="dpmpp-3m-sde", device="cuda", seed=seed).to(torch.float32)
            x = resample_poly(audio[0].cpu().numpy().T.mean(1), 1, 2).astype(np.float64)
            x = x[: int(L * 22050)]
            x = x - x.mean()
            fd = min(int(0.02 * 22050), len(x) // 4)
            x[-fd:] *= np.linspace(1, 0, fd)
            x[:48] *= np.linspace(0, 1, 48)
            x = x / (abs(x).max() or 1.0) * pk
            sf.write(dst, np.clip(x, -1, 1), 22050, subtype="PCM_16")
            print("%s %s: %.0fs nan=%s" % (ev, kind, time.time() - t0, bool(torch.isnan(audio).any())), flush=True)
        kinds.append(kind)
    items.append({"event": ev, "group": r["grupo"], "n": n, "kinds": kinds, "targets": targets,
                  "volume_db": e.get("volume_db", 0), "pitch": e.get("pitch", 1.0)})
    json.dump(items, open(AUD + "\\items.json", "w"), indent=1)
for f in ("main.gd", "main.tscn", "project.godot"):
    shutil.copy(LAB + "\\audition_template\\" + f, AUD + "\\" + f)
print("FIM", flush=True)
