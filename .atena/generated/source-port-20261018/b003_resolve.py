from pathlib import Path
import re,json,sys
sys.stdout.reconfigure(encoding='utf-8')
b=Path('.atena/generated/source-port-20261018/b003')
def resolve(rel):
 t=(b/'merged'/rel).read_text(encoding='utf-8-sig'); count=0
 def choice(m):
  nonlocal count
  count+=1
  local,base,up=m.group(1,2,3)
  if rel=='core/battle.gd':
   return {1:local,2:local+up,3:local+'\t\t\tvar rate := live_rate if past_end and not is_dagruve_encounter() else 1.0\n',4:'\t\t\tif is_dagruve_encounter():\n\t\t\t\tevery = float(w.every)\n\t\t\tevery /= _mk_density * rate\n'}[count]
  if rel=='core/game.gd':return up.replace('\tif OS.has_feature("android") or OS.has_feature("ios"):\n\t\treturn\n','')
  if rel=='core/playtest.gd':return '\tframe_stats.add(_delta)\n'
  if rel=='ui/run.gd':return {1:local,2:local+'\tPlaytest.frame_stats.reset()\n',3:local+up,4:local,5:up,6:local}[count]
  if rel=='ui/hud.gd':return '\n'.join(x[1:] if x.startswith('\t') else x for x in up.split('\n')[1:])
  if rel=='ui/options_panel.gd':return up.split('\tif Game.touch_controls_enabled():')[0]+'\n'
  if rel=='ui/title.gd':return '\t\tlab.text = "Nottgard\\nAbyss Megadungeon"\n\t\tlab.add_theme_font_override("font", UiFonts.title_font())\n\t\tlab.add_theme_font_size_override("font_size", roundi(52 * UiFonts.size_scale()))\n'
  raise AssertionError(rel)
 t=re.sub(r'(?ms)^<<<<<<<[^\n]*\n(.*?)^\|\|\|\|\|\|\|[^\n]*\n(.*?)^=======\n(.*?)^>>>>>>>[^\n]*\n',choice,t)
 assert not re.search(r'(?m)^(<<<<<<<|=======|>>>>>>>)',t)
 t=t.replace('Partículas e gradação de cor por fase. Em aparelho de toque fica desligada.','Partículas e gradação de cor por fase.')
 dest=b/'resolved'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(t,encoding='utf-8')
for r in json.loads((b/'merge-review.json').read_text()):resolve(r['path'])
print('Resolved 21 review candidates; runtime untouched')
