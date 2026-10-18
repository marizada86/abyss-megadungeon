from pathlib import Path
import hashlib,json,os,re,shutil,sys,difflib
sys.stdout.reconfigure(encoding='utf-8')
dst=Path.cwd(); src=Path('D:/dev/nottgard/games/godot/nottgard-survivors')
out=dst/'.atena/generated/source-port-20261018/b001'; out.mkdir(exist_ok=True)
snap=dst/'tmp/port-b1'; snap.mkdir(exist_ok=True)
dirs={'assets','core','data','ui','tests','tools'}
rootfiles={'project.godot','export_presets.cfg','icon.svg','icon.svg.import','README.md','AGENTS.md','.gitignore','.gitattributes','Testar-PC.cmd','Testar-Mapas.cmd'}
def dump(name,obj): (out/name).write_text(json.dumps(obj,ensure_ascii=False,indent=2),encoding='utf-8')
def inventory(root):
 result={}
 for base,children,names in os.walk(root):
  children[:]=[d for d in children if (Path(base)!=root or d in dirs) and d not in {'.godot','node_modules','__pycache__'}]
  for n in names:
   p=Path(base)/n; rel=p.relative_to(root).as_posix()
   if Path(base)==root and n not in rootfiles: continue
   data=p.read_bytes(); result[rel]={'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data)}
 return result
manifests={}; dependencies={}; missing={}
for label,root in [('source',src),('pc',dst)]:
 inv=inventory(root); manifests[label]=inv; target=snap/label; target.mkdir(exist_ok=True)
 refs=[]; absent=[]
 for rel,entry in inv.items():
  if Path(rel).suffix in {'.gd','.tscn','.tres','.json','.godot','.cfg','.gdshader'}:
   text=(root/rel).read_text(encoding='utf-8-sig',errors='replace')
   for ref in sorted(set(re.findall(r'res://[^\s"\'\)\],;]+',text))):
    tail=ref[6:]; path=root/tail
    if tail.startswith('.atena/'):
     refs.append({'consumer':rel,'reference':ref,'exists':path.exists(),'directory':path.is_dir()})
    elif not any(c in tail for c in ['%','{','+','*']) and not path.exists():
     absent.append({'consumer':rel,'reference':ref})
 for rel in inv:
  p=target/rel;p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(root/rel,p)
 deps=set()
 for ref in refs:
  p=root/ref['reference'][6:]
  if not p.exists() or not ref['consumer'].startswith(('core/','ui/','tests/')):continue
  if p.is_file(): deps.add(p)
  # Directory references in tools are inputs/outputs to catalog, never bulk-copy.
 for p in sorted(deps):
  rel=p.relative_to(root).as_posix()
  if any(x in rel.lower() for x in ['profile','app_userdata','shader_cache','relato']):continue
  q=target/rel;q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q)
  inv[rel]={'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size,'referenced_add_dependency':True}
 dump(label+'-manifest.json',inv);dependencies[label]=refs;missing[label]=absent
 print(label,len(inv),'files',sum(x['bytes'] for x in inv.values()),'bytes','ADD refs',len(refs),'static missing',len(absent),flush=True)
dump('add-dependencies.json',dependencies);dump('static-reference-candidates.json',missing)
a=manifests['source']; b=manifests['pc'];rows=[];counts={}
mobile=('ui/mobile_controls','ui/touch_ui','tests/test_mobile','tools/mobile_')
for rel in sorted(a.keys()|b.keys()):
 category='pc_only' if rel not in a else 'source_only' if rel not in b else 'identical' if a[rel]['sha256']==b[rel]['sha256'] else 'different'
 if category=='identical':action='REUSE_IDENTICAL'
 elif category=='pc_only':action='PRESERVE_PC'
 elif rel.startswith(mobile):action='EXCLUDE_MOBILE_TARGET'
 elif rel in rootfiles:action='PRESERVE_PC_CONTRACT_REVIEW'
 elif category=='source_only' and rel.startswith('tools/'):action='REVIEW_DEV_TOOL_NO_AUTORUN'
 elif category=='source_only':action='PORT_WITH_DEPENDENCIES_KEEP_CONTENT_STATE'
 elif rel.endswith('.import'):action='REIMPORT_PRESERVE_UID_REVIEW'
 else:action='SEMANTIC_INTEGRATION_REQUIRED'
 rows.append({'path':rel,'comparison':category,'disposition':action,'source':a.get(rel),'pc':b.get(rel)})
 counts[category]=counts.get(category,0)+1
dump('disposition-matrix.json',rows)
diffdir=out/'diffs';diffdir.mkdir(exist_ok=True)
for row in rows:
 rel=row['path']
 if row['comparison']=='different' and Path(rel).suffix in {'.gd','.json','.tscn','.tres','.cfg','.godot'}:
  diff=''.join(difflib.unified_diff((src/rel).read_text(encoding='utf-8-sig',errors='replace').splitlines(True),(dst/rel).read_text(encoding='utf-8-sig',errors='replace').splitlines(True),fromfile='source/'+rel,tofile='pc/'+rel))
  (diffdir/(rel.replace('/','__')+'.diff')).write_text(diff,encoding='utf-8')
dump('snapshot-receipt.json',{'source':str(src),'pc':str(dst),'snapshots':str(snap),'counts':counts,'source_original_writes':False,'runtime_writes':False,'manifest_scope':'runtime directories and bounded referenced ADD dependencies; original profiles excluded','source_git_status':'not verified; git -C source denied by sandbox; filesystem is authoritative'})
print('COUNTS',counts,flush=True)
print('ADD DEPENDENCIES',json.dumps(dependencies,ensure_ascii=False)[:10000])
