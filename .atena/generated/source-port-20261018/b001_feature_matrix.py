from pathlib import Path
import json,sys,hashlib,zipfile,collections
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd();out=root/'.atena/generated/source-port-20261018/b001';src=Path('D:/dev/nottgard/games/godot/nottgard-survivors')
features=[
('F-PORT-001','Chefes nos nove mapas','Encontrar chefe; executar fases, totens, quadrantes, varreduras, interrupcoes, adds, marcas e enrage sem invalidar objetivos PC',['core/boss_mechanics.gd','data/boss_mechanics.json','data/difficulty.json','core/battle.gd'],['test_l5_boss_mechanics','test_l5_b001_verbs','test_l5_b002_bosses','test_l5_b003_bosses','test_l5_b004_bosses','test_dagruve_encounter']),
('F-PORT-002','Evolucoes e requisitos','Adquirir armas/passivas/atributos; mostrar requisitos e evoluir as cinco armas novas sem perder evolucoes existentes',['core/weapon.gd','data/weapons.json','core/battle.gd'],['test_l1_evolution_and_item_order','test_new_content','test_battle','test_abyss_marks']),
('F-PORT-003','Comportamento e dano','Combater inimigos L2/L4, campos/corrosao/dano continuo e feedback mantendo colisoes e movimento em raizes',['core/enemy.gd','core/hero.gd','core/damage_feedback.gd','core/battle.gd'],['test_l2_boss_field_and_corrosion','test_l3_damage_feedback','test_l4_readable_enemies','test_continuous_hurt','test_root_navigation']),
('F-PORT-004','Segredos e acontecimentos','Receber pista de camara selada; coletar/falar/negociar e encontrar objetivo com arte sem perder marcos de campanha',['core/happenings.gd','data/secrets.json','data/stage_events.json','ui/happening_art.gd'],['test_secrets','test_happening_art','test_stage_story','test_map_objectives']),
('F-PORT-005','Animacoes e identidade de herois','Escolher cada heroi; idle/8 direcoes/ataque/habilidade/morte nas celulas corretas; laboratorio separado; manter DRAFT e gates de M1',['ui/hero_view.gd','assets/animations/heroes','assets/heroes'],['test_animation_assets','test_hero_own_art','test_walk_lab','test_hero_scale']),
('F-PORT-006','Interacoes NPCs e quebraveis','Ver idles, interagir, abrir baus e quebrar props; fallback estatico para tira ausente/retida',['ui/interaction_anim.gd','ui/overlay.gd','ui/prop.gd','data/interaction_anims.json','assets/animations/interactions'],['test_interaction_anim','test_breakable_death_art','test_actor_strips_b003']),
('F-PORT-007','Projeteis habilidades e SFX','Atacar e ativar habilidades com efeito e som correspondentes sem mudar alcance/dano pela apresentacao',['core/projectile_vfx.gd','core/hero_ability_vfx.gd','core/radiant_pulse_vfx.gd','core/hourglass_vfx.gd','core/sfx.gd','data/audio_manifest.json'],['test_projectile_and_ability_vfx','test_radiant_pulse_vfx','test_hourglass_vfx','test_vfx_sfx_coverage','test_audio']),
('F-PORT-008','Atmosfera filtros e acessibilidade','Alterar atmosfera/filtro/impacto reduzido durante run; persistir opcoes e manter perigo legivel',['ui/visual_filter.gd','ui/atmosphere.gd','ui/danger_vignette.gd','core/danger_feedback.gd','data/atmosphere.json'],['test_visual_filter','test_atmosphere','test_danger_feedback','test_toast_legibility']),
('F-PORT-009','UI fontes logo e retratos','Abrir titulo/Quartel/ficha/HUD/ofertas/pausa; lettering e fontes OFL, retratos com fallback, cursor e questlog legiveis',['ui/ui_fonts.gd','ui/hero_portraits.gd','ui/lettering.gd','ui/hud.gd','ui/quest_panel.gd','ui/options_panel.gd','data/cursor.json'],['test_ui_fonts','test_body_font','test_hero_portraits','test_lettering_assets','test_cursor','test_character_sheet','test_volume_and_result_panel']),
('F-PORT-010','Dicas e controles PC','Primeiro uso mostra dicas; desligar/rever dicas; teclado/mouse/controle navegam sem touch; volume nao reaplica janela',['core/onboarding_hints.gd','data/onboarding_hints.json','core/controller_input.gd','core/game.gd'],['test_onboarding_hints','test_controller_experience','test_platform_contract','controller_check']),
('F-PORT-011','Perfil telemetria local e QA','Carregar fixture antigo/novo, persistir configuracoes; medir quadros/maquina localmente; QA nao altera progresso real',['core/profile.gd','core/playtest.gd','core/frame_stats.gd','core/machine_info.gd'],['test_profile','test_save_resilience','test_playtest','test_frame_stats','test_qa_sandbox']),
('F-PORT-012','Campanha mapas HQs e preservacao PC','Percorrer capitulos/mapas e caminhos aprovados; concluir objetivos, retomar HQ e preservar texto/arte/legenda/enquadramento e gatilhos',['core/chapter_flow.gd','core/root_path_generator.gd','core/hq_catalog.gd','data/chapter_flow.json','data/stages.json','data/hqs.json','ui/hq_screen.gd','ui/run.gd'],['test_chapter_flow','test_chapter2_hqs','test_hqs','test_map_objectives','test_yggdrasil_map','test_yggdrasil_navigation','test_yggdrasil_art','test_root_art','test_domwieck_art','test_dagruve_encounter']),
]
matrix=[]
for id,title,workflow,paths,tests in features:
 matrix.append({'id':id,'feature':title,'workflow_and_expected_result':workflow,'paths':paths,'checks':tests,'integration_status':'NOT_STARTED_B001_ONLY','source_baseline':'see baseline-source/results.json','pc_baseline':'see baseline-pc/results.json','content_state':'PRESERVE_SOURCE_DRAFT_AND_PC_CANON_GATES','acceptance':'TECHNICAL_CHECKS_PLUS_OWNER_WHEN_SUBJECTIVE'})
(out/'functional-matrix.json').write_text(json.dumps(matrix,indent=2,ensure_ascii=False),encoding='utf-8')
# Preserve code/data and test contracts without importing them. Asset rollback is captured per affected path before later authorized writes.
receipts=[]
for label,origin in [('source',src),('pc',root)]:
 inv=json.loads((out/(label+'-manifest.json')).read_text(encoding='utf-8'))
 archive=out/(label+'-text-baseline.zip')
 with zipfile.ZipFile(archive,'w',compression=zipfile.ZIP_DEFLATED) as z:
  for rel in inv:
   if rel.startswith(('core/','data/','ui/','tests/')) or rel in ['project.godot','export_presets.cfg']:
    if Path(rel).suffix not in {'.png','.wav','.mp3','.ogg','.ttf'}:z.write(origin/rel,arcname=rel)
 receipts.append({'label':label,'archive':str(archive.relative_to(root)),'sha256':hashlib.sha256(archive.read_bytes()).hexdigest(),'scope':'raw core/data/ui/tests text and project/export config before integration; no caches/profiles; asset backup required per changed path in next batch'})
(out/'rollback-receipt.json').write_text(json.dumps(receipts,indent=2),encoding='utf-8')
print('PASS',len(matrix),'feature families; raw text baselines preserved')
