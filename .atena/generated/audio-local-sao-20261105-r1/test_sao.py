"""Teste local do Stable Audio Open 1.0 na GTX 1660 Super. Saida em F:\dev\audio-lab\out (fora do jogo)."""
import sys, time, os
import torch, soundfile as sf
from stable_audio_tools import get_pretrained_model
from stable_audio_tools.inference.generation import generate_diffusion_cond

DTYPE = torch.float16 if (len(sys.argv) < 2 or sys.argv[1] == "fp16") else torch.float32
OUT = r"F:\dev\audio-lab\out"
os.makedirs(OUT, exist_ok=True)

TESTS = [
    ("E01_estocada", 3.0,
     "Thin arcane rapier thrust, fast metallic shing with a violet glass chime on the tip, dry, no reverb tail."),
    ("A01_docas", 10.0,
     "Cold harbor at night: gentle water lapping on wood and stone, distant creaking hulls and rigging, soft sea wind, an occasional faraway bell or gull kept very quiet. No melody, no rhythm, no music, no sudden peaks."),
]

dev = "cuda"
t0 = time.time()
model, cfg = get_pretrained_model("stabilityai/stable-audio-open-1.0")
sr, size = cfg["sample_rate"], cfg["sample_size"]
model = model.to(dev).to(DTYPE).eval()
print(f"modelo carregado em {time.time()-t0:.1f}s, dtype={DTYPE}, VRAM={torch.cuda.memory_allocated()/2**30:.2f} GiB")

for name, secs, prompt in TESTS:
    torch.cuda.reset_peak_memory_stats()
    t1 = time.time()
    cond = [{"prompt": prompt, "seconds_start": 0, "seconds_total": secs}]
    audio = generate_diffusion_cond(
        model, steps=100, cfg_scale=7, conditioning=cond, sample_size=size,
        sigma_min=0.3, sigma_max=500, sampler_type="dpmpp-3m-sde", device=dev, seed=12345,
    )
    audio = audio.to(torch.float32)
    if torch.isnan(audio).any():
        print(name, "ATENCAO: NaN na saida (problema de fp16)")
    a = audio[0].cpu().numpy().T[: int(secs * sr)]
    peak = abs(a).max() or 1.0
    a = a / peak * 0.9
    sf.write(os.path.join(OUT, f"{name}_{str(DTYPE).split('.')[-1]}.wav"), a, sr)
    print(f"{name}: {time.time()-t1:.1f}s, pico VRAM={torch.cuda.max_memory_allocated()/2**30:.2f} GiB")
