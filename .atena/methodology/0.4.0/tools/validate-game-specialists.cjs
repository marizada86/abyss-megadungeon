const fs=require('fs'),path=require('path'),assert=require('assert');
const root=path.resolve(__dirname,'..');
const read=p=>fs.readFileSync(p,'utf8');
function assessReadiness(input) {
 const gaps=[];
 if(!input.taskAuthorized)gaps.push('Task checkpoint not authorized');
 if(input.visual===false)return {ready:gaps.length===0,gaps};
 function reference(name,ref) {
  if(!ref){gaps.push('Missing '+name);return;}
  if(!ref.path||!ref.revision)gaps.push('Unidentified '+name+' revision/reference');
  if(!['DRAFT','CANON'].includes(ref.state))gaps.push('Unknown '+name+' maturity');
  if(ref.state==='DRAFT'&&!ref.draftUseAuthorized)gaps.push('Unauthorized draft '+name);
  if(ref.state==='CANON'&&!ref.approvalEvidence)gaps.push('Unsubstantiated canon '+name);
 }
 reference('visualBible',input.visualBible);reference('sceneContext',input.sceneContext);
 if(input.identityApplicable===false){if(!input.identityNotApplicableReason)gaps.push('Missing identity N/A reason');}
 else reference('identity',input.identity);
 if((input.blockingGaps||[]).length)gaps.push('Relevant blocking gaps remain');
 // Position/coordinates are intentionally not prerequisites.
 return {ready:gaps.length===0,gaps};
}
function readinessChecks() {
 const canon={path:'reference.md',revision:1,state:'CANON',approvalEvidence:'user approval'},draft={path:'draft.md',revision:2,state:'DRAFT',draftUseAuthorized:true};
 const base={taskAuthorized:true,visualBible:canon,identity:canon,sceneContext:canon};
 const cases=[
 ['no position required',base,true],
 ['missing bible',{...base,visualBible:null},false],
 ['missing identity',{...base,identity:null},false],
 ['missing scene',{...base,sceneContext:null},false],
 ['abstract identity explained',{...base,identity:null,identityApplicable:false,identityNotApplicableReason:'abstract menu'},true],
 ['N/A without reason',{...base,identity:null,identityApplicable:false},false],
 ['authorized draft remains usable',{...base,visualBible:draft},true],
 ['draft without authority',{...base,visualBible:{...draft,draftUseAuthorized:false}},false],
 ['canon without evidence',{...base,identity:{...canon,approvalEvidence:null}},false],
 ['pending checkpoint',{...base,taskAuthorized:false},false],
 ['relevant blocker',{...base,blockingGaps:['unresolved identity']},false],
 ['pure logic task no visual bible',{taskAuthorized:true,visual:false},true],
 ['nonvisual still needs authority',{taskAuthorized:false,visual:false},false],
 ['missing revision',{...base,sceneContext:{...canon,revision:null}},false]
 ];
 for(const [name,input,ready]of cases)assert.equal(assessReadiness(input).ready,ready,name);
 return cases.length;
}
function packages() {
 const base=path.join(root,'templates/automation/game'),catalog=JSON.parse(read(path.join(base,'catalog.json')));
 assert.equal(catalog.positionRequired,false);assert.deepStrictEqual(catalog.visualPrerequisites,['visualBible','identityWhenApplicable','sceneContext']);
 assert.equal(catalog.specialists.length,10);const names=new Set(),agents=new Set();let links=0;
 for(const entry of catalog.specialists) {
  assert(!names.has(entry.skill),'Duplicate skill');names.add(entry.skill);assert(!agents.has(entry.agent),'Duplicate agent');agents.add(entry.agent);
  const file=path.join(base,entry.skillPath),text=read(file),m=text.match(/^---\r?\n([\s\S]*?)\r?\n---/);assert(m,'Missing skill frontmatter');
  const fields={};for(const line of m[1].split(/\r?\n/)){const f=line.match(/^([\w-]+): (.+)$/);assert(f,'Unsupported skill frontmatter');assert(['name','description','license','allowed-tools','metadata'].includes(f[1]),'Unsupported field');assert(!fields[f[1]],'Duplicate field');fields[f[1]]=f[2];}
  assert.equal(fields.name,entry.skill);assert(/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(fields.name)&&fields.name.length<=64,'Invalid name');assert(fields.description.length<=1024&&!/[<>]|TODO/i.test(fields.description),'Invalid description');assert(fields.description.trim(),'Empty description');
  assert(!/\[TODO:[\s\S]*?\]/.test(text),'Unfinished scaffold');assert.equal(path.basename(path.dirname(file)),entry.skill,'Folder mismatch');
  const brief=read(path.join(base,entry.agentPath));assert(brief.includes(entry.skill),'Brief not linked to skill');
  for(const [p,doc]of [[file,text],[path.join(base,entry.agentPath),brief]])for(const link of doc.matchAll(/\[[^\]\n]*\]\(([^)\n]+)\)/g)){assert(!/^https?:/.test(link[1]),'Unexpected skill external dependency');assert(fs.existsSync(path.resolve(path.dirname(p),link[1])),'Broken package link');links++;}
 }
 assert.deepStrictEqual(fs.readdirSync(path.join(base,'skills')).sort(),[...names].sort(),'Uncataloged packages');
 assert.equal(fs.readdirSync(path.join(base,'agents')).filter(p=>p.endsWith('.md')).length,10,'Agent count');
 return {skills:names.size,agentBriefs:agents.size,packageLinks:links};
}
module.exports={assessReadiness,readinessChecks,packages};
if(require.main===module){try{console.log(JSON.stringify({status:'pass',...packages(),readinessScenarios:readinessChecks(),limits:['Structural and synthetic decision checks, not live model behavior.','Readiness helper validates supplied authority fields, not the authenticity of human approval.','No asset, runtime or human aesthetic assessment performed.']},null,2));}catch(e){console.error(e.message);process.exitCode=1;}}
