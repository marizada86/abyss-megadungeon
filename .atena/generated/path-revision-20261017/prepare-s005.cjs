const fs=require('fs'),crypto=require('crypto');const base='.atena/generated/path-revision-20261017';const hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');const build=JSON.parse(fs.readFileSync(base+'/s004-build-r2.json'));
for(const f of build.files)if(hash(f.path)!==f.sha256)throw Error('Build drift '+f.path);
let source=fs.readFileSync('tools/playtest_maps.gd','utf8');
source=source.replace('var selector: Control','var selector: Control\nvar ygg_attempt := 0');
source=source.replace('7502 if stage_id == "raiz_yggdrasil" else 4401','_next_seed(stage_id)');
source=source.replace('Yggdrasil: protótipo geométrico; avalie caminhos, bordas e pressão.','S-PATH-005 r2: caminhos, bordas e combate.\\nYggdrasil alterna sementes 7502/7503/7504 ao reabrir.');
source=source.replace('if not verify:\n\t\treturn',`if not verify:
\t\tfor i in 12:
\t\t\tawait process_frame
\t\tvar run = current_scene
\t\tif run == null or run.get("battle") == null:
\t\t\tprinterr("S-PATH-005: run unavailable")
\t\t\tquit(1)
\t\t\treturn
\t\tvar b: Battle = run.battle
\t\tDisplayServer.window_set_title("S-PATH-005 r2 | " + stage_id + " | seed " + str(b.seed_value) if false else "S-PATH-005 r2 | " + stage_id)
\t\tawait RenderingServer.frame_post_draw
\t\troot.get_texture().get_image().save_png(session_dir.path_join("mapa-aberto.png"))
\t\trun.call("_toggle_pause")
\t\tvar file := FileAccess.open(session_dir.path_join("ready.json"),FileAccess.WRITE)
\t\tfile.store_string(JSON.stringify({"map":b.stage_id,"sandbox":game.qa_sandbox,"save_path":game._save_path,"user_data_dir":OS.get_user_data_dir(),"hero_position":[b.hero.pos.x,b.hero.pos.y],"paused":paused,"human_acceptance":"PENDING","seed":7502 + ((ygg_attempt-1)%3) if stage_id == "raiz_yggdrasil" else 4401},"\\t"))
\t\tfile.close()
\t\treturn`);
source+='\nfunc _next_seed(stage_id: String) -> int:\n\tif stage_id != "raiz_yggdrasil":\n\t\treturn 4401\n\tvar result: int = [7502,7503,7504][ygg_attempt % 3]\n\tygg_attempt += 1\n\treturn result\n';
// Window title needs no new Battle interface.
source=source.replace('DisplayServer.window_set_title("S-PATH-005 r2 | " + stage_id + " | seed " + str(b.seed_value) if false else "S-PATH-005 r2 | " + stage_id)','DisplayServer.window_set_title("S-PATH-005 r2 | " + stage_id)');
fs.writeFileSync(base+'/playtest-s005.gd',source);
fs.writeFileSync(base+'/s005-authorization.json',JSON.stringify({step:'S-PATH-005',revision:'r2',authorized:true,scope:'Abrir playtests isolados de Yggdrasil e primeira incursao abissal; avaliar caminhos, bordas, combate e leitura da espiral',build:base+'/s004-build-r2.json',all_18_hashes_verified:true,authorization_recorded_utc:new Date().toISOString(),human_acceptance:{raiz_yggdrasil:'PENDING',reino_abissal:'PENDING'},harness:'Copy of existing map entry with rotating Ygg seeds, readiness receipt, capture and initial pause only; no gameplay mutations'},null,2)+'\n');
let state=fs.readFileSync('.atena/state/plan.yaml','utf8');const a=state.indexOf('map_path_revision_proposal:'),m=/\n[a-zA-Z_][a-zA-Z0-9_]*:/.exec(state.slice(a)),b=m?a+m.index:state.length;let block=state.slice(a,b);const fields={status:'S_PATH_005_AUTHORIZED_OPENING_ISOLATED_PLAYTESTS',current_step:'S-PATH-005',checkpoint:'CP-PATH-005-HUMAN-FEEDBACK',next_step_approval:'APPROVED_OWNER_S_PATH_005_OPENING_ONLY',next_activity:'Abrir dois mapas isolados e aguardar relatos humanos separados'};for(const[k,v]of Object.entries(fields))block=block.replace(new RegExp('^  '+k+':.*$','m'),'  '+k+': '+v);block+='  s005_authorization: '+base+'/s005-authorization.json\n';state=state.slice(0,a)+block+state.slice(b);state=state.replace('path_revision_suspension: CLOSED_AT_S_PATH_004_CHECKPOINT_RETURN_CURSOR_PRESERVED','path_revision_suspension: ACTIVE_S_PATH_005_RETURN_CURSOR_PRESERVED');fs.writeFileSync('.atena/state/plan.yaml',state);
console.log('S-PATH-005 authorized, build verified, harness prepared.');
