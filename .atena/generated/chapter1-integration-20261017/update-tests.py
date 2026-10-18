from pathlib import Path
p=Path('tests/test_hqs.gd'); t=p.read_text(encoding='utf-8')
t=t.replace('"hqn_03": {"type": "stage_reached", "stage": "shedaklah"}','"hqn_03": {"type": "stage_cleared", "stage": "domwieck"}')
t=t.replace('"hqn_14": {"achievement": "pilares_ativos"}','"hqn_14": {"achievement": "pilares_ativos"},\n\t"hqn_15": {"type": "stage_cleared", "stage": "docas"},\n\t"hqn_16": {"type": "stage_cleared", "stage": "docas"},\n\t"hqn_17": {"type": "stage_cleared", "stage": "docas"},\n\t"hqn_18": {"type": "stage_cleared", "stage": "reino_abissal"}')
t=t.replace('var expected_panel_count := 8 if hq_id == "hqn_01" else (5 if hq_id == "hqn_02" else 4)','var expected_panel_count := int({"hqn_01":8,"hqn_02":5,"hqn_03":6,"hqn_14":5,"hqn_15":5,"hqn_16":5,"hqn_17":4,"hqn_18":8}.get(hq_id,4))')
a=t.index('\tvar milestone_cases :='); z=t.index('\tvar old_achievement_unlocks',a)
t=t[:a]+'''\tif HQCatalog.newly_triggered_ids(fresh.data, "stage_cleared", "docas") != ["hqn_02", "hqn_15", "hqn_16", "hqn_17"]:
\t\tout.append("Docas deve acionar fila ordenada")
\tif not HQCatalog.newly_earned_ids(["aluris", "pilares_ativos"]).is_empty():
\t\tout.append("conquistas novas não reativam seleção histórica")
'''.replace('\n+','\n')+t[z:]
p.write_text(t,encoding='utf-8')
print('Updated chapter assertions; reader checks preserved.')
