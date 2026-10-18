from pathlib import Path
p=Path('.atena/generated/source-port-20261018/b002/runtime_probe.gd')
p.write_text(p.read_text(encoding='utf-8').replace('Game.','game.'),encoding='utf-8')
