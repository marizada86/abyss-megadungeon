const fs=require('fs'),crypto=require('crypto'),zlib=require('zlib'),path=require('path');
const base='.atena/generated/domwieck-art-20261017/',kit=base+'kit-r1/';
const read=p=>fs.readFileSync(p,'utf8').replace(/^\uFEFF/,'');
const hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const names=['ground','architecture','vegetation','garden','ailalore','ambient'];
const ids=['54590f58-136a-488b-abc4-b66797a33de8','89e801dd-da33-4ecc-8d87-91bc5efc69be','be37db7a-f9a7-49d6-b552-e0d13a1eb8f3','77cc21f6-9c48-4d5c-9c9a-8a1e9cbe43b2','8a7c81c4-e7ac-4811-b03e-4574e4e4f304','baea0d3b-bb68-4ed5-84e4-2fa1a966431e'];
function inspect(p){
 const b=fs.readFileSync(p);if(b.subarray(0,8).toString('hex')!=='89504e470d0a1a0a')throw Error('Not PNG');
 let w,h,depth,type,interlace;const chunks=[];
 for(let at=8;at<b.length;){const n=b.readUInt32BE(at),t=b.toString('ascii',at+4,at+8),d=b.subarray(at+8,at+8+n);if(t==='IHDR'){w=d.readUInt32BE(0);h=d.readUInt32BE(4);depth=d[8];type=d[9];interlace=d[12];}if(t==='IDAT')chunks.push(d);at+=n+12;}
 if(depth!==8 || ![2,6].includes(type) || interlace!==0)throw Error('Unsupported PNG verification format '+p);
 const channels=type===6?4:3,stride=w*channels,raw=zlib.inflateSync(Buffer.concat(chunks));
 let prev=Buffer.alloc(stride),pos=0,zero=0,partial=0,opaque=0,bbox=[w,h,-1,-1],edge=0;
 for(let y=0;y<h;y++){
  const filter=raw[pos++],row=Buffer.alloc(stride);
  for(let i=0;i<stride;i++){
   const a=i>=channels?row[i-channels]:0,c=i>=channels?prev[i-channels]:0,up=prev[i];let predictor=0;
   if(filter===1)predictor=a;else if(filter===2)predictor=up;else if(filter===3)predictor=Math.floor((a+up)/2);else if(filter===4){const v=a+up-c,pa=Math.abs(v-a),pb=Math.abs(v-up),pc=Math.abs(v-c);predictor=pa<=pb&&pa<=pc?a:pb<=pc?up:c;}else if(filter!==0)throw Error('PNG filter');
   row[i]=(raw[pos++]+predictor)&255;
  }
  for(let x=0;x<w;x++){
   const alpha=channels===4?row[x*4+3]:255;
   if(alpha===0)zero++;else if(alpha===255)opaque++;else partial++;
   if(alpha>16){bbox=[Math.min(bbox[0],x),Math.min(bbox[1],y),Math.max(bbox[2],x),Math.max(bbox[3],y)];if(x===0||x===w-1||y===0||y===h-1)edge++;}
  }prev=row;
 }
 return {width:w,height:h,bit_depth:depth,color_type:type,alpha:{transparent_pixels:zero,partial_pixels:partial,opaque_pixels:opaque,transparent_fraction:zero/(w*h),visible_bbox_alpha_gt_16:bbox,visible_outer_edge_pixels:edge},native_rgba8_bytes:w*h*4};
}
const audit=JSON.parse(read(base+'reference-audit-r1.json'));
for(const r of audit.references)if(hash(r.asset)!==r.sha256)throw Error('Changed reference');
for(const r of audit.guarded_sources)if(hash(r.path)!==r.sha256)throw Error('Changed game source '+r.path);
const entries=[];
for(let i=0;i<names.length;i++){
 const name=names[i],source='C:/Users/gui-m/.codex/generated_images/01a14a9f-7cd5-7bf1-930d-4351996a8ad1/exec-'+ids[i]+'.png',target=kit+name+'-v01.png';
 if(fs.existsSync(target))throw Error('Do not overwrite '+target);
 fs.copyFileSync(source,target);const stats=inspect(target);
 if(name!=='ground' && (stats.color_type!==6||stats.alpha.transparent_fraction<0.05))throw Error('Missing real alpha '+name);
 if(name==='ground' && stats.alpha.transparent_pixels>0)throw Error('Ground opacity');
 if(hash(source)!==hash(target))throw Error('Copy mismatch');
 entries.push({id:name,version:'v01',path:target,source_path:source,sha256:hash(target),...stats,tool:'built-in image_gen.imagegen',prompt_file:kit+'prompts.json',prompt_key:name,status:'DRAFT_AWAITING_OWNER_KIT_ACCEPTANCE',import_target_max_size:1024,import_mipmaps:false});
}
const restrictions={ground:'Four overhead material variants. Ornamental quadrant for sparse accents; no seamless tiling guarantee. UV inset and seams to validate in integration.',architecture:'Four independent sprites. Native shapes need measured individual rectangles/pivots; top-right spire has a narrow top margin. Never assume exact 2x2 clipping. Reduce display size to preserve routes.',vegetation:'Four crowns; lower-left tree extends across nominal central atlas split. Use individually measured rectangles rather than blind equal quadrants. Protect objective/approach visibility.',garden:'Only top-left, top-right and bottom-left flat cover variants proposed for admission. Bottom-right contains raised rubble and is EXCLUDED from runtime use; preserved in original only.',ailalore:'One intact light-blue crystal cluster. Native margins narrower than requested; preserve tips with measured rect/pivot and UV inset. Size/brightness and edge fringe require in-engine review.',ambient:'Two fires plus blue aura/lattice. Lower blue motifs are stronger and broader than requested; low opacity and small footprint mandatory. No opaque sky or full-screen filter. Beam and Tarn arc remain engine composition.'};
for(const e of entries)e.integration_restrictions=restrictions[e.id];
const manifest={id:'DOMWIECK-ART-KIT-R1',revision:'r1',status:'DRAFT_AWAITING_OWNER_ACCEPTANCE',stage:'S-DART-003',authorized_scope:'Six PNGs only, no game integration',references:audit.references.map(r=>({asset:r.asset,sha256:r.sha256,role:r.role})),approved_sample_guidance:'.atena/vault/canon/ASSET-APPROVAL-DOMWIECK-ART-SAMPLES-20261017-r1.md',references_supplied_to_generator:'ONLY_THE_THREE_HQ_FILES_IN_EACH_CALL',entries,import_policy:{native_originals_preserved:true,max_size_per_image:1024,mipmaps:false,maximum_six_1024_square_rgba8_bytes:25165824,measurement:'24 MiB raw RGBA8 per copy at proposed imported dimensions, not total runtime/GPU memory',import_uv_pivots_pending_integration:true},owner_acceptance:'PENDING'};
fs.writeFileSync(kit+'manifest.json',JSON.stringify(manifest,null,2)+'\n');
const review=kit+'review.md';
fs.writeFileSync(review,'# Domwieck — conjunto r1 para aceite\n\nSeis PNGs DRAFT produzidos pelo imagegen integrado com somente HQ18 Q3 v01, HQ03 Q1 v03 e HQ03 Q2 v03; Q2 limitada à aparência/escala de Ailalore. As amostras aprovadas orientam a direção, mas não foram passadas como referências adicionais ao gerador. [Prompts completos](prompts.json) e [manifesto, hashes, dimensões e alfa](manifest.json).\n\n'+entries.map(e=>`## ${e.id}\n\n![${e.id}](${e.id}-v01.png)\n\nOriginal ${e.width}×${e.height}; ${e.id==='ground'?'opaco':'alfa real confirmado'}. ${restrictions[e.id]}\n`).join('\n')+'\nAs observações técnicas acima delimitam o uso proposto, sem editar os originais ou admitir imagens no jogo. Plano de importação até 1024 por imagem, recortes/pivôs individualizados e redução de opacidade/escala conforme a leitura. Se esses limites não forem suficientes, corrigir antes de declarar integração concluída.\n\nAvaliação solicitada: coerência dos materiais e da arquitetura; formas/cor da vegetação e jardim; identidade azul-clara de Ailalore; fogo e luz decorativos. O aceite do conjunto não certifica UV, emendas, halo, projeção exata, oclusão ou contraste no combate; essas verificações permanecem na S-DART-004. Produção entregue; aceite do conjunto pendente.\n');
const evidence='.atena/evidence/EVID-NOTTGARD-DOMWIECK-ART-KIT-20261017-r1.md';
fs.writeFileSync(evidence,`---\nid: EVID-NOTTGARD-DOMWIECK-ART-KIT-20261017\nrevision: r1\nstatus: DRAFT_DELIVERED_AWAITING_OWNER_ACCEPTANCE\n---\n\n# S-DART-003 — produção do conjunto\n\nAutorização do usuário: “autorizado”, após proposta concreta de seis PNGs com as mesmas referências/limites, sem aplicação no mapa. Seis chamadas ao imagegen integrado, uma por arquivo. Fontes fornecidas em todas as chamadas: apenas as três HQs autorizadas; hashes reconferidos. Nenhum especialista delegado, dependência instalada ou geração por CLI/API.\n\n[Conjunto e revisão](../generated/domwieck-art-20261017/kit-r1/review.md); [manifesto](../generated/domwieck-art-20261017/kit-r1/manifest.json). Originais copiados sem transformação para o workspace e SHA-256 igual à fonte gerada. PNGs decodificados localmente apenas para inspeção, sem edição: dimensões, alfa transparente/parcial/opaco, bbox e bordas medidos. Piso opaco e cinco PNGs com alfa real confirmados.\n\nRevisão visual realizada nos seis resultados. Restrições de atlas irregular, spire com margem curta, brilho forte e variante de entulho excluída estão documentadas por arquivo. Resultado mantém aparência de pedra clara/azulada, vegetação escura, flores vermelhas e estrela cristalina azul-clara. Não foi declarada conformidade matemática da câmera nem legibilidade em combate sem render.\n\nGuardados arquivos de jogo/teste da auditoria permanecem com hashes idênticos. Sem importação Godot, código de jogo, save real ou publicação. Tamanhos nativos preservados; importação até 1024 e orçamento de 24 MiB por cópia RGBA8 propostos, sem afirmar custo total.\n\nPlano r1, etapa 3/5, duas concluídas; entrega da terceira pronta para aceite CP-DART-003-ACCEPTANCE. Não encerrar a etapa nem autorizar integração antes do aceite/autorização respectivos.\n`);
const spec='.atena/specs/SPEC-NOTTGARD-DOMWIECK-ART-20261017/plan-r1.md';
fs.writeFileSync(spec,read(spec).replace('status: S_DART_002_COMPLETE_AWAITING_CP_DART_003','status: KIT_DELIVERED_AWAITING_OWNER_ACCEPTANCE')+'\n\n## Entrega S-DART-003 — 2026-10-17\n\nProdução explicitamente autorizada: seis PNGs gerados, copiados sem edição e conferidos por hash/alfa. [Conjunto para revisão](../../generated/domwieck-art-20261017/kit-r1/review.md) e [evidência](../../evidence/EVID-NOTTGARD-DOMWIECK-ART-KIT-20261017-r1.md). Duas de cinco etapas encerradas, terceira com entrega pronta e aceite pendente em CP-DART-003-ACCEPTANCE. Observações e exclusão da variante de entulho do jardim documentadas no manifesto; dimensões nativas preservadas e UV/pivôs/importação condicionados à validação da integração. Nenhuma admissão no jogo. Menções anteriores à produção não autorizada representam checkpoints históricos.\n');
const statePath='.atena/state/plan.yaml',state=read(statePath),end=state.indexOf('\nroot_art_plan:');let block=state.slice(0,end);
if(end<0||!block.includes('status: S_DART_003_ACTIVE'))throw Error('Checkpoint changed');
block=block.replace('status: S_DART_003_ACTIVE','status: S_DART_003_DELIVERED_AWAITING_OWNER_ACCEPTANCE').replace('checkpoint: CP-DART-003','checkpoint: CP-DART-003-ACCEPTANCE').replace("next_activity: 'Produzir e conferir seis PNGs; apresentar conjunto para aceite próprio'","next_activity: 'Avaliar conjunto visual r1 e seus limites de uso antes da integração'");
block+=`  kit_manifest: ${kit}manifest.json\n  kit_review: ${review}\n  kit_evidence: EVID-NOTTGARD-DOMWIECK-ART-KIT-20261017-r1\n  kit_delivery: COMPLETE_AWAITING_OWNER_ACCEPTANCE\n  kit_acceptance: PENDING_OWNER_R1\n`;
fs.writeFileSync(statePath,block+state.slice(end));
if(read(statePath).slice(read(statePath).indexOf('\nroot_art_plan:'))!==state.slice(end))throw Error('Shared state mismatch');
for(const p of [review,evidence,spec])for(const m of read(p).matchAll(/\]\(([^)]+)\)/g))if(!fs.existsSync(path.resolve(path.dirname(p),m[1])))throw Error('Broken link '+m[1]);
const result={status:'PASS_FILE_INSPECTION_OWNER_ACCEPTANCE_PENDING',six_pngs:entries.length,real_alpha_files:entries.filter(e=>e.id!=='ground').length,game_sources_unchanged:true,shared_state_preserved:true,document_links_valid:true,completed_steps:2,total_steps:5,stage:'S-DART-003',checkpoint:'CP-DART-003-ACCEPTANCE',entries:entries.map(e=>({id:e.id,width:e.width,height:e.height,transparent_fraction:e.alpha.transparent_fraction,outer_edge_pixels:e.alpha.visible_outer_edge_pixels}))};
fs.writeFileSync(base+'s003-validation.json',JSON.stringify(result,null,2)+'\n');console.log(JSON.stringify(result,null,2));
