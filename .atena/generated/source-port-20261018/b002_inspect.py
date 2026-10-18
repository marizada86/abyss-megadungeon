from pathlib import Path
import sys
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd();src=Path('D:/dev/nottgard/games/godot/nottgard-survivors')
groups={
 'readers':['ui/happening_art.gd','ui/interaction_anim.gd','ui/hero_portraits.gd','ui/ui_fonts.gd','core/projectile_vfx.gd','core/radiant_pulse_vfx.gd','core/hourglass_vfx.gd'],
 'diffs':['ui__overlay.gd.diff','ui__enemy_view.gd.diff','ui__lettering.gd.diff','ui__prop.gd.diff','ui__hero_panel.gd.diff','ui__sheet_art.gd.diff','core__melee_vfx.gd.diff'],
 'tests':['test_actor_strips_b003','test_animation_assets','test_hero_own_art','test_interaction_anim','test_breakable_death_art','test_happening_art','test_hero_portraits','test_projectile_and_ability_vfx','test_radiant_pulse_vfx','test_hourglass_vfx','test_vfx_sfx_coverage','test_ui_fonts','test_body_font','test_lettering_assets','test_walk_lab']}
for f in (sys.argv[2:] if sys.argv[1]=='paths' else groups[sys.argv[1]]):
 if sys.argv[1]=='paths':
  parts=f.split('::');p=root/parts[0][3:] if parts[0].startswith('pc/') else src/parts[0];t=p.read_text(encoding='utf-8-sig')
  if len(parts)>1:t='\n'.join(t.splitlines()[int(parts[1])-1:int(parts[1])+int(parts[2])-1])
  print('\nFILE',p.name,'\n'+t);continue
 p=src/f if sys.argv[1]=='readers' else root/'.atena/generated/source-port-20261018/b001/diffs'/f if sys.argv[1]=='diffs' else src/'tests'/(f+'.gd')
 print('\nFILE',p.name,'\n'+p.read_text(encoding='utf-8-sig'))
