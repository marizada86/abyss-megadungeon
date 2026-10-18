from pathlib import Path
import json,re,yaml,hashlib
r=Path.cwd(); base=r/'.atena/generated/hq-integration-20261017'
first=json.loads((r/'tmp/release-validation-20261018-010943/results.json').read_text())
fixed=json.loads((r/'tmp/release-validation-20261018-011300/results.json').read_text())
results={row['test']:row for row in first['results']}
results.update({row['test']:row for row in fixed['results']})
assert all(row['passed'] for row in results.values())
captures=json.loads((r/'tmp/release-validation-20261018-011940/capture-results.json').read_text()); assert captures['passed'] and len(captures['captures'])==12
for num in [19,20]:
    p=r/f'.atena/generated/hq{num}-production-20261017/approved-sequence-r1.json'; m=json.loads(p.read_text(encoding='utf-8'))
    admission=json.loads((base/'admission-r1.json').read_text(encoding='utf-8'))
    for row in m['panels']:
        asset=next(a for a in admission['entries'] if a['hq']==f'hqn_{num}' and a['panel']==row['panel'])
        assert hashlib.sha256((r/asset['target']).read_bytes()).hexdigest()==asset['sha256']
        row['runtime_admitted']=True; row['admitted_asset']=asset['target']
    m['runtime_admitted']=True; m['campaign_automatic_triggers']=False
    p.write_text(json.dumps(m,ensure_ascii=False,indent=2),encoding='utf-8')
report=dict(status='PASS',tests=list(results.values()),test_count=len(results),captures=captures['captures'],capture_session='tmp/release-validation-20261018-011940',isolation_probed=True,real_save_accessed=False,portage='PC-specific content/catalog/testing; no Web edits or automatic synchronization',limitations=['Chapter 2 campaign triggers remain deferred; QA reader available','Dagruve remains QA prototype awaiting owner playtest','No new human playtest claimed'])
(base/'validation-r1.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ19-HQ20-INTEGRATION-20261017-r1.md'
(r/evidence).write_text(f'''# Integração HQ19/HQ20 e consolidação PC — r1

Autorização explícita do dono em 2026-10-17: “vamos integrar tudo que temos par afazer um commit e push”. S-I20-001/S-I20-002 concluídas. Spec planejada antes da admissão. Dezenove PNGs aprovados admitidos por hash em assets/hq/chapter2_r1, HQ19 com 12 e HQ20 com sete quadros, legendas dos roteiros CANON. HQ19 conserva uma entrada e metadados de segmentos antes/depois de Dagruve.

Catálogo/leitor integrados: QA permite prévia completa, acesso normal depende de marcos próprios do capítulo 2, que não são fabricados nos eventos do capítulo 1. Sem alterar progressão ou saves de capítulo 1, sem ativar protótipo Dagruve na campanha. Roteiros posteriores não recebem arte inventada. Implementações locais de capítulo 1 e mapas aceitos são consolidadas, protótipo Dagruve permanece QA aguardando avaliação humana no outro plano.

Validação: {len(results)} testes distintos PASS, incluindo 19 quadros no leitor, legendas/contadores/retomada/fechamento, gating normal e QA, campanha, perfil/save, dados/scripts/plataforma, objetivos/terreno, mapas/artes/navegação e encontro Dagruve QA. Recuperação de saves apresentou recursos retidos por fixtures Nodes órfãos no executor antigo; corrigida limpeza limitada aos novos órfãos do teste e repetidos save, HQ2 e batalha: PASS, sem erros de encerramento. Não alterada lógica do save para silenciar erro.

Doze capturas automatizadas em 1280×720 e 1920×1080; amostras finais inspecionadas com legenda e composição legíveis. Primeira captura foi invalidada por guia inicial sobreposto; capturador sintético corrigido e repetido. Sonda de isolamento comprovou APPDATA/LOCALAPPDATA e perfil sintéticos antes de Godot. Nenhum save real carregado ou playtest humano alegado.

Manifestos: .atena/generated/hq-integration-20261017/admission-r1.json e validation-r1.json. Portagem PC específica, sem Web/origem modificada. Publicação autorizada em origin/main; revisão de payload exclui sessões/caches, material rejeitado e documentos de organização externa ao projeto. Recibo operacional de commit/push será salvo localmente em .atena/generated/hq-integration-20261017/publication.json, depois da operação, sem fabricar hash ou sucesso antecipados.
''',encoding='utf-8')
p=r/'.atena/state/plan.yaml'; text=p.read_text(encoding='utf-8'); pattern=r'(?ms)^hq19_hq20_integration_plan:\n.*?(?=^[A-Za-z_][A-Za-z_0-9]*:|\Z)'; match=re.search(pattern,text); assert match
block=match.group().replace('status: LOCAL_ADMISSION_VALIDATION_PENDING','status: INTEGRATED_VALIDATED_PUBLICATION_AUTHORIZED',1).replace('current_step: S-I20-002','current_step: S-I20-003',1).replace('completed_steps: 1','completed_steps: 2',1).replace('next_activity: Validar HQs e consolidar alterações locais','next_activity: Commit e push autorizados; resultado operacional no recibo de publicação',1)
block+=f'  validation: .atena/generated/hq-integration-20261017/validation-r1.json\n  evidence: {evidence}\n  publication_receipt: .atena/generated/hq-integration-20261017/publication.json\n'
text=text[:match.start()]+block+text[match.end():]; yaml.safe_load(text)
p.write_bytes(text.replace('\r\n','\n').encode('utf-8'))
print(f'PASS: {len(results)} testes distintos, 12 capturas finais; evidência e manifestos reconciliados, publicação autorizada.')
