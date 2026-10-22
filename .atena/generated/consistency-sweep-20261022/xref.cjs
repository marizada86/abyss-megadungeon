const fs=require('fs'),path=require('path');
const root='F:/dev/abyss-megadungeon';
const D={};for(const f of fs.readdirSync(root+'/data'))if(f.endsWith('.json')){try{D[f.slice(0,-5)]=JSON.parse(fs.readFileSync(root+'/data/'+f,'utf8'))}catch(e){console.log('PARSE',f,e.message)}}
const keys=o=>Object.keys(o).filter(k=>!k.startsWith('_'));
const sets={stage:new Set(keys(D.stages)),enemy:new Set(keys(D.enemies)),hero:new Set(keys(D.heroes)),weapon:new Set(keys(D.weapons.weapons||D.weapons))};
const ids=(arr)=>new Set(arr.map(x=>x.id));
sets.item=new Set([...keys(D.items.bases),...D.items.uniques.map(x=>x.id)]);sets.ach=ids(D.achievements.achievements);
console.log('counts',Object.fromEntries(Object.entries(sets).map(([k,v])=>[k,v.size])));
const out=[];const add=(m)=>out.push(m);
// 1. tabelas cujas chaves de topo são ids de um conjunto
for(const [t,o] of Object.entries(D)){ if(Array.isArray(o)||typeof o!=='object')continue; const ks=keys(o);
  for(const [n,s] of Object.entries(sets)){ const hit=ks.filter(k=>s.has(k)).length; if(ks.length>=3&&hit/ks.length>=0.5&&t!==({stage:'stages',enemy:'enemies',hero:'heroes'})[n]){ const miss=ks.filter(k=>!s.has(k)); if(miss.length)add(`[${t}] chaves que não são ${n}: ${miss.join(', ')}`);}
    const miss2=[...s].filter(k=>hit/ks.length>=0.5&&ks.length>=3&&!ks.includes(k)&&['barks','hero_bios','abilities','hero_bios','stage_story','stage_rules','secrets','stage_events','atmosphere','chronicles','fog'].includes(t)); if(miss2.length)add(`[${t}] sem entrada de ${n}: ${miss2.join(', ')}`);
  }}
// 2. fases: ondas, chefe, elites
for(const [sid,st] of Object.entries(D.stages)){ if(sid.startsWith('_'))continue;
  const scan=(o,p)=>{ if(Array.isArray(o))o.forEach((x,i)=>scan(x,p+'['+i+']')); else if(o&&typeof o==='object'){ for(const [k,v] of Object.entries(o)){ if(typeof v==='string'&&['id','boss','elite','enemy','minion','add','spawn'].includes(k)&&p.match(/waves|elites|boss|events|reinforce|adds/i)&&!sets.enemy.has(v)&&!sets.hero.has(v)) add(`[stages.${sid}${p}.${k}] "${v}" não é inimigo`); scan(v,p+'.'+k);} } };
  scan(st,'');
  for(const k of ['next','prev','unlock','requires'])if(st[k]&&typeof st[k]==='string'&&!sets.stage.has(st[k])&&!sets.ach.has(st[k]))add(`[stages.${sid}.${k}] "${st[k]}" desconhecido`);
}
// 3. campos por nome em todas as tabelas
const fieldMap={weapon:'weapon',hero:'hero',stage:'stage',enemy:'enemy',boss:'enemy',next:'stage',requires:'ach'};
for(const [t,o] of Object.entries(D)){ const walk=(x,p)=>{ if(Array.isArray(x))x.forEach((y,i)=>walk(y,p+'['+i+']')); else if(x&&typeof x==='object'){ for(const [k,v] of Object.entries(x)){ if(typeof v==='string'&&fieldMap[k]&&v&&!sets[fieldMap[k]].has(v)&&!(fieldMap[k]==='ach'&&sets.stage.has(v))&&!(k==='weapon'&&sets.item.has(v)))add(`[${t}${p}.${k}] "${v}" não existe em ${fieldMap[k]}`); walk(v,p+'.'+k);} } }; walk(o,''); }
// 4. arquivos citados
const exts=/\.(png|ogg|wav|mp3|webp|jpg|jpeg|tres|tscn|ttf|otf)$/i; const seen=new Set();
for(const [t,o] of Object.entries(D)){ const walk=(x,p)=>{ if(Array.isArray(x))x.forEach((y,i)=>walk(y,p+'['+i+']')); else if(x&&typeof x==='object')for(const [k,v] of Object.entries(x))walk(v,p+'.'+k); else if(typeof x==='string'&&exts.test(x)&&!x.includes(' ')){ let c=x.replace(/^res:\/\//,''); const cands=[c,'assets/'+c]; if(!cands.some(a=>fs.existsSync(path.join(root,a)))&&!seen.has(t+x)){seen.add(t+x);add(`[${t}${p}] arquivo ausente: ${x}`);} } }; walk(o,''); }
console.log(out.length+' achados'); const byT={}; out.forEach(m=>{const t=m.match(/^\[([^.\]\[]+)/)[1];(byT[t]=byT[t]||[]).push(m)}); for(const [t,a] of Object.entries(byT)){console.log('\n## '+t+' ('+a.length+')');a.slice(0,25).forEach(m=>console.log(' '+m));if(a.length>25)console.log(' ... +'+(a.length-25));}
