"""Converte o lote aprovado para o formato do jogo (mono, 22 050 Hz, PCM 16) em F:\dev\audio-lab\staging (espelho de assets/audio).
NAO toca no repositorio do jogo."""
import csv, os, numpy as np, soundfile as sf
from scipy.signal import resample_poly

CSV = r"F:\dev\abyss-megadungeon\.atena\generated\audio-brief-20261105-r1\audio-prompts.csv"
SRC = r"F:\dev\audio-lab\out"; DST = r"F:\dev\audio-lab\staging\assets\audio"
AMB_RMS, AMB_CEIL, SFX_PEAK = 0.109, 0.45, 0.71
os.makedirs(DST + r"\sfx\weapon", exist_ok=True); os.makedirs(DST + r"\ambience", exist_ok=True)

def load_mono22(path):
    a, sr = sf.read(path); m = a.mean(1) if a.ndim > 1 else a
    assert sr == 44100
    return resample_poly(m, 1, 2).astype(np.float64)

def write(path, x): sf.write(path, np.clip(x, -1, 1), 22050, subtype="PCM_16")
rep = []
rows = {r["codigo"]: r for r in csv.DictReader(open(CSV, encoding="utf-8-sig"))}

# SFX: s101 -> fire_01, s202 -> fire_02
for i in range(1, 13):
    code = f"E{i:02d}"; ev = rows[code]["evento_ou_arquivo"]; secs = float(rows[code]["duracao_s"])
    for seed, n in ((101, "01"), (202, "02")):
        x = load_mono22(f"{SRC}/batch/{code}_s{seed}.wav")
        x = x[: int((secs + 0.3) * 22050)]
        x = x - x.mean()
        f = int(0.015 * 22050); x[-f:] *= np.linspace(1, 0, f)
        x[:64] *= np.linspace(0, 1, 64)
        x = x / (abs(x).max() or 1) * SFX_PEAK
        out = f"{DST}/sfx/weapon/{ev}_{n}.wav"; write(out, x)
        rep.append((os.path.basename(out), len(x) / 22050, abs(x).max(), np.sqrt((x**2).mean())))

# Ambiencias: escolha do dono (A01 v2 s101, A02 v2 s101, A03 v2 s202), loop continuo por crossfade de 1 s
CH = {"A01": ("docas", 101), "A02": ("reino_abissal", 101), "A03": ("domwieck", 202)}
for code, (name, seed) in CH.items():
    x = load_mono22(f"{SRC}/batch2/{code}_v2_s{seed}.wav"); x = x - x.mean()
    n = int(1.0 * 22050); w = np.linspace(0, 1, n)
    body = x[:-n].copy(); body[:n] = body[:n] * w + x[-n:] * (1 - w)   # fim se funde com o inicio
    g = AMB_RMS / np.sqrt((body**2).mean())
    y = np.tanh(body * g / AMB_CEIL) * AMB_CEIL                       # limitador suave
    out = f"{DST}/ambience/{name}.wav"; write(out, y)
    rep.append((os.path.basename(out), len(y) / 22050, abs(y).max(), np.sqrt((y**2).mean())))

with open(r"F:\dev\audio-lab\staging\relatorio.txt", "w") as fh:
    for r in rep: fh.write("%-52s %5.2fs peak=%.2f rms=%.3f\n" % r)
for r in rep: print("%-52s %5.2fs peak=%.2f rms=%.3f" % r)
