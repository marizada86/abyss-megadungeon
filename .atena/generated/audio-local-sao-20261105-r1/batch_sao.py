"""Lote: 12 SFX de evolucao (C) + 3 ambiencias (A). Saida em F:\dev\audio-lab\out\batch (fora do jogo)."""
import csv, os, time, torch, soundfile as sf
from stable_audio_tools import get_pretrained_model
from stable_audio_tools.inference.generation import generate_diffusion_cond

CSV = r"F:\dev\abyss-megadungeon\.atena\generated\audio-brief-20261105-r1\audio-prompts.csv"
OUT = r"F:\dev\audio-lab\out\batch"
os.makedirs(OUT, exist_ok=True)
rows = [r for r in csv.DictReader(open(CSV, encoding="utf-8-sig")) if r["grupo"] in ("C-sfx-evolucao", "A-ambiencia-nova")]
rows.sort(key=lambda r: r["grupo"] != "C-sfx-evolucao")  # SFX primeiro
model, cfg = get_pretrained_model("stabilityai/stable-audio-open-1.0")
sr = cfg["sample_rate"]
model = model.to("cuda").to(torch.float16).eval()
SIZE = lambda s: int(-(-s * sr // 2048) * 2048)
for r in rows:
    secs = float(r["duracao_s"]); is_sfx = r["grupo"].startswith("C")
    gen = 2.0 if is_sfx else secs
    seeds = (101, 202) if is_sfx else (101,)
    for seed in seeds:
        t = time.time()
        audio = generate_diffusion_cond(model, steps=50, cfg_scale=7,
            conditioning=[{"prompt": r["prompt"], "seconds_start": 0, "seconds_total": secs}],
            sample_size=SIZE(gen), sigma_min=0.3, sigma_max=500, sampler_type="dpmpp-3m-sde",
            device="cuda", seed=seed).to(torch.float32)
        a = audio[0].cpu().numpy().T
        a = a[: int((secs + (0.4 if is_sfx else 0)) * sr)]
        a = a / (abs(a).max() or 1.0) * 0.9
        sf.write(os.path.join(OUT, f"{r['codigo']}_s{seed}.wav"), a, sr)
        print(f"{r['codigo']} seed={seed}: {time.time()-t:.0f}s nan={bool(torch.isnan(audio).any())}", flush=True)
