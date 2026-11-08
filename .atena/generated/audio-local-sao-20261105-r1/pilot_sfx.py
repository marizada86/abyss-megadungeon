"""Piloto: SFX de armas (43) e habilidades de herois (12) com Stable Audio Open, 2 variacoes cada.
Saida em F:\dev\audio-lab\pilot (staging espelhando assets/audio + compare/ atual x novo). NAO toca no jogo."""
import csv, os, time, shutil, numpy as np, torch, soundfile as sf
from scipy.signal import resample_poly
from stable_audio_tools import get_pretrained_model
from stable_audio_tools.inference.generation import generate_diffusion_cond

CSV = r"F:\dev\abyss-megadungeon\.atena\generated\audio-brief-20261105-r1\audio-prompts.csv"
GAME = r"F:\dev\abyss-megadungeon"; ST = r"F:\dev\audio-lab\pilot\staging"; CMP = r"F:\dev\audio-lab\pilot\compare"
os.makedirs(CMP, exist_ok=True)
rows = [r for r in csv.DictReader(open(CSV, encoding="utf-8-sig")) if r["grupo"] in ("S-sfx-arma", "S-sfx-habilidade")]
seen, jobs = {}, []
for r in rows:                      # varios eventos compartilham o mesmo arquivo: o primeiro vence
    t = r["arquivo_atual"]
    if t in seen: print("PULA (arquivo compartilhado com %s): %s" % (seen[t], r["evento_ou_arquivo"]), flush=True); continue
    seen[t] = r["evento_ou_arquivo"]; jobs.append(r)
print(len(jobs), "eventos a gerar", flush=True)

NEG = "music, melody, voice, speech, long reverb tail, noise floor, distortion"
model, cfg = get_pretrained_model("stabilityai/stable-audio-open-1.0")
sr = cfg["sample_rate"]; model = model.to("cuda").to(torch.float16).eval()
size = lambda s: int(-(-s * sr // 2048) * 2048)
for r in jobs:
    t1 = r["arquivo_atual"]; cur = os.path.join(GAME, t1.replace("/", os.sep))
    ev = r["evento_ou_arquivo"]; secs = float(r["duracao_s"])
    try: a0, sr0 = sf.read(cur); a0 = a0 if a0.ndim == 1 else a0.mean(1); L = len(a0) / sr0; pk = float(abs(a0).max())
    except Exception: a0, sr0, L, pk = None, 22050, secs + 0.2, 0.71
    gen = max(2.0, secs + 0.5)
    for seed, tag in ((101, "01"), (202, "02")):
        t = time.time()
        audio = generate_diffusion_cond(model, steps=50, cfg_scale=7,
            conditioning=[{"prompt": r["prompt"], "seconds_start": 0, "seconds_total": secs}],
            negative_conditioning=[{"prompt": NEG, "seconds_start": 0, "seconds_total": secs}],
            sample_size=size(gen), sigma_min=0.3, sigma_max=500, sampler_type="dpmpp-3m-sde",
            device="cuda", seed=seed).to(torch.float32)
        x = resample_poly(audio[0].cpu().numpy().T.mean(1), 1, 2).astype(np.float64)
        x = x[: int(L * 22050)]; x = x - x.mean()
        f = min(int(0.02 * 22050), len(x) // 4); x[-f:] *= np.linspace(1, 0, f); x[:48] *= np.linspace(0, 1, 48)
        x = x / (abs(x).max() or 1.0) * pk                       # mesmo pico do arquivo atual
        rel = t1.replace("_01.wav", "_%s.wav" % tag)
        dst = os.path.join(ST, rel.replace("/", os.sep)); os.makedirs(os.path.dirname(dst), exist_ok=True)
        sf.write(dst, np.clip(x, -1, 1), 22050, subtype="PCM_16")
        shutil.copy(dst, os.path.join(CMP, "%s_NOVO_%s.wav" % (ev, tag)))
        print("%s %s: %.0fs nan=%s" % (ev, tag, time.time() - t, bool(torch.isnan(audio).any())), flush=True)
    if os.path.exists(cur): shutil.copy(cur, os.path.join(CMP, "%s_ATUAL_01.wav" % ev))
print("FIM", flush=True)
