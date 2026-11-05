"""Ambiencias v2 (mais suaves, sem clima de terror). Saida: F:\dev\audio-lab\out\batch2 (fora do jogo)."""
import os, time, torch, soundfile as sf
from stable_audio_tools import get_pretrained_model
from stable_audio_tools.inference.generation import generate_diffusion_cond

OUT = r"F:\dev\audio-lab\out\batch2"; os.makedirs(OUT, exist_ok=True)
TAIL = " Natural field recording, calm and gentle, low level. No music, no melody, no voices, no sudden peaks."
P = {
 "A01": "Calm harbor at dusk: soft waves lapping against wooden piers, a gentle sea breeze, light rope and rigging clinks, a few distant seagulls." + TAIL,
 "A02": "Large underground cavern: soft steady room tone, slow water drips into still pools, gentle air moving through stone, a faint distant campfire crackle." + TAIL,
 "A03": "Quiet garden at the edge of a bonfire: soft steady fire crackling, a light breeze through leaves, a few drifting embers popping, distant birds." + TAIL,
}
NEG = "horror, scary, ominous drone, dark rumble, screams, whispers, voices, music, heartbeat, distortion"
model, cfg = get_pretrained_model("stabilityai/stable-audio-open-1.0")
sr = cfg["sample_rate"]; model = model.to("cuda").to(torch.float16).eval()
size = int(-(-10 * sr // 2048) * 2048)
for code, prompt in P.items():
    for seed in (101, 202):
        t = time.time()
        audio = generate_diffusion_cond(model, steps=50, cfg_scale=7,
            conditioning=[{"prompt": prompt, "seconds_start": 0, "seconds_total": 10}],
            negative_conditioning=[{"prompt": NEG, "seconds_start": 0, "seconds_total": 10}],
            sample_size=size, sigma_min=0.3, sigma_max=500, sampler_type="dpmpp-3m-sde",
            device="cuda", seed=seed).to(torch.float32)
        a = audio[0].cpu().numpy().T[: 10 * sr]
        a = a / (abs(a).max() or 1.0) * 0.9
        sf.write(os.path.join(OUT, f"{code}_v2_s{seed}.wav"), a, sr)
        print(f"{code} seed={seed}: {time.time()-t:.0f}s nan={bool(torch.isnan(audio).any())}", flush=True)
