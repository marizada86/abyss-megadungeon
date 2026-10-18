from pathlib import Path
import subprocess,sys
sys.stdout.reconfigure(encoding='utf-8')
code=(Path(__file__).with_suffix('.ps1')).read_text(encoding='utf-8')
p=subprocess.run(['powershell.exe','-NoProfile','-Command',code],capture_output=True,text=True,encoding='utf-8',errors='replace',timeout=30)
print(p.stdout);print(p.stderr[:1000])
