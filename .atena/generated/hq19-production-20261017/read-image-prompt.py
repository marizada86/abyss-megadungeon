from pathlib import Path
import json,sys
print(json.dumps({'prompt':Path(sys.argv[1]).read_text(encoding='utf-8')},ensure_ascii=True))
