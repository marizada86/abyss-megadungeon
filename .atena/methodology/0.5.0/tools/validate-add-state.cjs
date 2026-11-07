// Read-only validation. Reject unsupported YAML rather than guessing approval.
const fs=require('fs'), path=require('path'), assert=require('assert');
const read=p=>fs.readFileSync(p,'utf8').replace(/^\uFEFF/,'');
function scalar(raw) {
 if(raw==='null')return null;
 if(raw==='true'||raw==='false')return raw==='true';
 if(raw==='[]')return [];
 if(/^-?\d+$/.test(raw))return Number(raw);
 if(/^".*"$/.test(raw))return JSON.parse(raw);
 if(/^[A-Za-z][A-Za-z0-9_ -]*$/.test(raw))return raw;
 throw Error('Unsupported YAML scalar: '+raw);
}
function parseYaml(source) {
 const tokens=[];
 for(const line of source.split(/\r?\n/)) {
  if(!line.trim()||line.trimStart().startsWith('#'))continue;
  assert(!line.includes('\t'),'Tabs unsupported in YAML');
  let quote=false,escape=false,cut=line.length;
  for(let i=0;i<line.length;i++){const c=line[i];if(escape){escape=false;continue;}if(c==='\\'&&quote){escape=true;continue;}if(c==='"')quote=!quote;if(c==='#'&&!quote&&(i===0||/\s/.test(line[i-1]))){cut=i;break;}}
  const clean=line.slice(0,cut).trimEnd(), indent=clean.length-clean.trimStart().length, text=clean.trimStart();
  if(text.startsWith('- ')&&/^[\w-]+:/.test(text.slice(2))){tokens.push({indent,text:'-'});tokens.push({indent:indent+2,text:text.slice(2)});}
  else tokens.push({indent,text});
 }
 let i=0;
 function block(indent) {
  const list=tokens[i].text==='-'||tokens[i].text.startsWith('- '), out=list?[]:{};
  while(i<tokens.length&&tokens[i].indent===indent){
   const text=tokens[i++].text;
   if(list){assert(text==='-'||text.startsWith('- '),'Mixed YAML list/mapping');const raw=text.slice(1).trim();out.push(raw?scalar(raw):(i<tokens.length&&tokens[i].indent>indent?block(tokens[i].indent):null));}
   else {const m=text.match(/^([\w-]+):\s*(.*)$/);assert(m,'Unsupported YAML mapping: '+text);assert(!Object.hasOwn(out,m[1]),'Duplicate YAML key: '+m[1]);out[m[1]]=m[2]?scalar(m[2]):(i<tokens.length&&tokens[i].indent>indent?block(tokens[i].indent):{});}
   assert(i>=tokens.length||tokens[i].indent<=indent,'Unexpected YAML indentation');
  }
  return out;
 }
 if(!tokens.length)return {};
 assert(tokens[0].indent===0,'YAML root indentation');
 const result=block(0);assert(i===tokens.length,'Unconsumed YAML');return result;
}
function schemaValidate(value,schema,loc='$') {
 const known=['$schema','$id','title','type','additionalProperties','required','properties','oneOf','const','enum','pattern','minimum','minLength','items'];
 for(const k of Object.keys(schema))assert(known.includes(k),'Unsupported schema keyword: '+k);
 if(schema.oneOf)assert.equal(schema.oneOf.filter(s=>{try{schemaValidate(value,s,loc);return true;}catch{return false;}}).length,1,loc+' oneOf');
 const type=v=>v===null?'null':Array.isArray(v)?'array':typeof v;
 if(schema.type)assert([].concat(schema.type).some(t=>t==='integer'?Number.isInteger(value):type(value)===t),loc+' type');
 if(Object.hasOwn(schema,'const'))assert.deepStrictEqual(value,schema.const,loc+' const');
 if(schema.enum)assert(schema.enum.includes(value),loc+' enum');
 if(schema.pattern)assert(new RegExp(schema.pattern).test(value),loc+' pattern');
 if(schema.minimum!==undefined)assert(value>=schema.minimum,loc+' minimum');
 if(schema.minLength!==undefined)assert(value.length>=schema.minLength,loc+' minLength');
 if(schema.required)for(const k of schema.required)assert(Object.hasOwn(value,k),loc+' missing '+k);
 if(schema.additionalProperties===false)for(const k of Object.keys(value))assert(Object.hasOwn(schema.properties||{},k),loc+' extra '+k);
 if(schema.properties)for(const [k,s]of Object.entries(schema.properties))if(Object.hasOwn(value,k))schemaValidate(value[k],s,loc+'.'+k);
 if(schema.items)value.forEach((v,i)=>schemaValidate(v,schema.items,loc+'['+i+']'));
}
function validateState(state, registry, schema) {
 schemaValidate(state,schema);
 const ids=state.deferred_requests.map(r=>r.id);assert.equal(new Set(ids).size,ids.length,'Duplicate deferred request ID');
 if(!state.active_plan){assert.equal(state.plan_cursor,null,'Idle cursor');assert.equal(state.suspension,null,'Idle suspension');return {valid:true,executionReady:false,state:'idle'};}
 const a=state.active_plan,p=registry[a.id];assert(p,'Unknown plan '+a.id);
 assert.equal(p.spec_id,a.spec_id,'Plan/spec mismatch');assert(p.specExists,'Unknown spec '+a.spec_id);
 assert(['approved','active'].includes(p.status),'Active plan not approved/active');assert(['approved','active'].includes(p.specStatus),'Spec not approved/active');
 assert(p.steps.length>0,'Empty sequence');assert.equal(new Set(p.steps).size,p.steps.length,'Duplicate step');
 assert.equal(a.total_steps,p.steps.length,'Wrong total_steps');const index=p.steps.indexOf(a.current_step);assert(index>=0,'Step outside plan');
 const cursor=state.plan_cursor;assert(cursor,'Missing active cursor');assert.equal(cursor.current.split(/\s/)[0],a.current_step,'Current cursor mismatch');
 assert.equal(cursor.next===null?null:cursor.next.split(/\s/)[0],p.steps[index+1]||null,'Next cursor mismatch');
 assert.equal(a.approval.mode,p.mode,'Mode mismatch');assert.equal(p.approval.mode,p.mode,'Approval record mode mismatch');
 const checkpoints=p.approval.checkpoints;assert(Array.isArray(checkpoints),'Missing checkpoints');assert.equal(new Set(checkpoints.map(c=>c.id)).size,checkpoints.length,'Duplicate checkpoint');
 if(p.mode==='per-plan'){assert.equal(a.approval.checkpoint,'PLAN','Per-plan checkpoint mismatch');assert.equal(checkpoints.length,1,'Per-plan extra checkpoint');}
 else if(p.mode==='per-step'){assert.equal(a.approval.checkpoint,a.current_step,'Per-step checkpoint mismatch');for(const c of checkpoints)assert(p.steps.includes(c.id),'Step checkpoint outside plan');}
 else if(p.mode==='per-batch') {
  assert(/^B-\d{3,}$/.test(a.approval.checkpoint),'Per-batch checkpoint mismatch');
  const covered=[];for(const c of checkpoints){assert(/^B-\d{3,}$/.test(c.id),'Invalid batch ID');assert(Array.isArray(c.steps)&&c.steps.length,'Empty batch');for(const s of c.steps){assert(p.steps.includes(s),'Batch step outside plan');covered.push(s);}}
  assert.equal(new Set(covered).size,covered.length,'Overlapping batches');assert.deepStrictEqual([...covered].sort(),[...p.steps].sort(),'Incomplete batch coverage');
 } else throw Error('Unconfigured/unsupported mode');
 const c=checkpoints.find(c=>c.id===a.approval.checkpoint);assert(c,'Unknown checkpoint');
 if(p.mode==='per-batch')assert(c.steps.includes(a.current_step),'Current step outside checkpoint batch');
 assert(['approved','pending'].includes(c.status),'Unsupported approval status');assert.equal(a.approval.status,c.status.toUpperCase(),'Approval status mismatch');assert.equal(c.scope_revision,p.revision,'Stale approval revision');
 if(c.status==='approved'){assert(typeof c.approved_by==='string'&&c.approved_by.trim(),'Missing approver');assert(typeof c.approved_at==='string'&&/^\d{4}-\d\d-\d\dT/.test(c.approved_at)&&!Number.isNaN(Date.parse(c.approved_at)),'Missing/invalid approval time');}
 if(a.status==='SUSPENDED'){assert(state.suspension,'Missing suspension');assert.deepStrictEqual(state.suspension.saved_cursor,cursor,'Saved cursor mismatch');}
 else assert.equal(state.suspension,null,'Active state retains suspension');
 return {valid:true,executionReady:a.status==='ACTIVE'&&c.status==='approved',state:a.status.toLowerCase(),step:index+1,total:p.steps.length,completed:index,remainingAfterCurrent:p.steps.length-index-1,checkpoint:c.id};
}
function frontmatter(s){const m=s.match(/^---\r?\n([\s\S]*?)\r?\n---/);assert(m,'Missing frontmatter');return parseYaml(m[1]);}
function loadRegistry(project,active) {
 const registry={};if(!active)return registry;
 for(const e of fs.readdirSync(path.join(project,'.atena/specs'),{withFileTypes:true})){
  if(!e.isDirectory())continue;const dir=path.join(project,'.atena/specs',e.name), planFile=path.join(dir,'plan.md');if(!fs.existsSync(planFile))continue;
  const text=read(planFile).replace(/^\uFEFF/,'');if(!text.match(/^---\r?\n/)){if(text.includes(active.id))throw new Error('Active plan missing frontmatter');continue;}const meta=frontmatter(text);if(meta.id!==active.id)continue;assert(!registry[meta.id],'Duplicate plan ID');
  const specFile=path.join(dir,'spec.md'),spec=fs.existsSync(specFile)?frontmatter(read(specFile)):null;
  const revision=text.match(/\brevision:\s*(\d+)/i)?.[1];assert(revision,'Missing plan revision');
  const section=text.split(/^## Approval record\s*$/m)[1];assert(section,'Missing approval section');const fence=section.match(/```yaml\r?\n([\s\S]*?)\r?\n```/);assert(fence,'Missing approval YAML');
  registry[meta.id]={spec_id:meta.spec_id,status:meta.status,specExists:!!spec&&spec.id===active.spec_id,specStatus:spec?.status,mode:meta.approval.mode,revision:Number(revision),steps:[...text.matchAll(/^\d+\. `?(S-\d{3,})`?\s*[—-]/gm)].map(m=>m[1]),approval:parseYaml(fence[1])};
 }
 return registry;
}

// A valid legacy plan is not evidence that it belongs to the caller's chat.
const conversationKeyPattern=/^[A-Za-z0-9][A-Za-z0-9_-]{0,79}$/;
function conversationStateFile(project,key) {
 assert(typeof key==='string'&&conversationKeyPattern.test(key),'Invalid conversation key');
 const root=path.resolve(project), parts=['.atena','state','conversations',key,'plan.yaml'];
 let at=root;
 for(const part of parts){at=path.join(at,part);if(fs.existsSync(at))assert(!fs.lstatSync(at).isSymbolicLink(),'Conversation state link refused');}
 return at;
}
function selectConversationState(project,key) {
 if(key===undefined){
  const file=path.join(project,'.atena/state/plan.yaml');
  return {file,state:parseYaml(read(file)),binding:'unscoped'};
 }
 const file=conversationStateFile(project,key);
 if(!fs.existsSync(file))return {file,state:{version:2,active_plan:null,plan_cursor:null,suspension:null,deferred_requests:[]},binding:'absent'};
 const state=parseYaml(read(file));
 assert(state.conversation&&state.conversation.key===key,'Conversation binding mismatch');
 return {file,state,binding:'matched'};
}
function validateConversationState(selected,registry,schema) {
 const result=validateState(selected.state,registry,schema);
 return {...result,executionReady:result.executionReady&&selected.binding==='matched',binding:selected.binding,conversation:selected.state.conversation?.key||null};
}

function fixtureChecks(file,schema){
 const data=JSON.parse(read(file)),base=data.base;let count=0;
 for(const f of data.cases){const state=structuredClone(base.state),registry=structuredClone(base.registry);for(const change of f.changes||[]){let target=change.target==='state'?state:registry;const parts=change.path.split('.');for(const key of parts.slice(0,-1))target=target[key];target[parts.at(-1)]=change.value;}let result,error;try{result=validateState(state,registry,schema);}catch(e){error=e.message;}assert.equal(!error,f.valid,f.name+': '+(error||'unexpected pass'));if(f.valid&&f.executable!==undefined)assert.equal(result.executionReady,f.executable,f.name+' readiness');if(f.remaining!==undefined)assert.equal(result.remainingAfterCurrent,f.remaining,f.name+' count');count++;}
 // Parser must preserve persisted deferred requests and reject duplicate/unsupported forms.
 assert.deepStrictEqual(parseYaml('version: 2\nrequests:\n  - id: "DEV-001"\n    status: pending\n'),{version:2,requests:[{id:'DEV-001',status:'pending'}]});
 assert.throws(()=>parseYaml('a: 1\na: 2'));assert.throws(()=>parseYaml('a: &anchor 1'));assert.throws(()=>parseYaml('a: [1, 2]'));
 return {fixtures:count,parserChecks:4,status:'pass'};
}
module.exports={parseYaml,schemaValidate,validateState,loadRegistry,fixtureChecks,conversationStateFile,selectConversationState,validateConversationState};
if(require.main===module){try{
 const args=process.argv.slice(2),arg=(key,fallback)=>{const i=args.indexOf(key);return i<0?fallback:args[i+1];};
 const schema=JSON.parse(read(arg('--schema',path.join(__dirname,'../schemas/plan-state.schema.json'))));
 const result=args.includes('--fixtures')?fixtureChecks(arg('--fixtures'),schema):(()=>{const project=path.resolve(arg('--project',process.cwd())),selected=selectConversationState(project,arg('--conversation'));return validateConversationState(selected,loadRegistry(project,selected.state.active_plan),schema);})();
 console.log(JSON.stringify(result,null,2));if(args.includes('--require-executable')&&!result.executionReady)process.exitCode=2;
}catch(e){console.error(e.message);process.exitCode=1;}}
