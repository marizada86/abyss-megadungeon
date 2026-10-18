# Dívidas observadas antes da portagem — r1

Todas as observações abaixo ocorreram nas cópias do estado anterior à
integração. Não são regressões da portagem. Logs e reprodução independente
em `.atena/generated/source-port-20261018/b001/baseline-pc/`.

| ID | Evidência PC | Disposição e fronteira |
|---|---|---|
| DEBT-PORT-001 | test_affixes: 6 falhas; regras por ordem/chefes/horda | O teste fixa a ordem da campanha survivor anterior. Revisar contra a progressão PC, preservando regras canônicas; não renumerar fases nem mudar balanceamento para acomodar a asserção. RESOLVABLE na conciliação de testes/campanha, lote 3 |
| DEBT-PORT-002 | test_audio: 4 falhas; música/ambiência sem mapeamento para Domwieck/Reino Abissal | Lacuna real de cobertura declarada nos dados, sem prova de intenção de silêncio. Não inventar trilha ou instalar recursos; usar somente material já autorizado e decisão concreta de associação quando necessária. DEFERRED para decisão no lote 3/aceite, não bloqueia cópia de assets existentes |
| DEBT-PORT-003 | test_chronicles: 2 falhas, novos mapas sem crônica | Nova prosa/lore exigiria aceite canônico; não criar nem copiar narrativa de outra fase por conveniência. DEFERRED; escopo da portagem conserva crônicas existentes e expõe a lacuna |
| DEBT-PORT-004 | test_game_design: 1 falha na segunda descida | Teste espera Dagruve→Docas→Shedaklah; PC tem ChapterFlow e marcos próprios. Adaptar contrato de teste aos caminhos aceitos, sem restaurar next antigo. RESOLVABLE no lote 3 |
| DEBT-PORT-005 | test_ground_decals: 4 falhas nos mapas novos | Asserções genéricas exigem remendo/trilha em mapas com arte própria; revisar aplicabilidade contra contratos de mapas e art JSON. Não criar/cobrir arte PC ou remover ResourceLoader. RESOLVABLE no lote 3 |
| DEBT-PORT-006 | test_playtest: 1 falha, contagem exata de 18 HQs | PC tem 21 HQs; expectativa antiga. Validar conjunto/ordem aceitos e acesso QA em vez de reduzir o catálogo. RESOLVABLE nos lotes 3/4 |
| DEBT-PORT-007 | test_random_events: 12 falhas; seis pesos ausentes em dois mapas novos | O teste presume eventos survivor em toda fase. Revisar aplicabilidade dos mapas/campanha, conservar comportamento atual; não ativar acontecimentos novos sem aprovação de conteúdo. RESOLVABLE para adaptação técnica; novos eventos ficam DEFERRED |
| DEBT-PORT-008 | test_fog_edge: 2 SCRIPT ERROR, embora imprima “0 falhas” e exit 0 | Teste tenta spawn de `stage.boss` vazio; _spawn falha e retorna Nil. Reproduzido isoladamente. É defeito efetivo de fixture/robustez, nunca PASS. Corrigir fixture com inimigo válido e/ou guarda de API conforme contrato PC no lote 3; manter teste de entrada inválida se permitido. RESOLVABLE |
| DEBT-PORT-009 | teardown das suítes e controle PC: RIDs/ObjectDB/recursos em uso ao sair | Registrar separadamente de falhas funcionais; runner PC individual já libera novos órfãos. Não declarar execução sem erros do motor. Melhorar somente a limpeza de fixtures afetadas dentro da validação; sem reescrever engine/runtime. RESOLVABLE se necessário; ruído herdado permanece visível |

As 30 falhas declaradas são 6+4+2+1+4+1+12. Os 2 erros de script são
adicionais e não aparecem nessa contagem. Reproduções por teste confirmam
que não dependem da ordem da suíte. Suíte origem: 0 falhas funcionais e 0
SCRIPT ERROR, com avisos/erros de limpeza de recursos ao encerrar.

Importação fria: tema tentou carregar fonte antes de existir cache de importação
na cópia nova. Não é recurso de fonte ausente na origem. Exigir importação
quente sem erros e conservar logs das duas tentativas; nada alterado nas fontes.

Critério dos lotes seguintes: nenhuma falha ou erro de script novo em relação
a este baseline; cada dívida afetada recebe verificação individual e disposição
explícita. Esta lista não é aprovação para apagar testes, enfraquecer garantias,
declarar release limpo ou aceitar novo conteúdo. Lacunas DEFERRED continuam
visíveis no aceite final. Se uma nova discrepância exigir mudança canônica,
interromper esse item no gate específico e apresentar a decisão concreta.

Não há gap BLOCKING para portar o conjunto existente de recursos de origem,
desde que esses limites e as fronteiras do contrato sejam mantidos. O lote 2
permanece sujeito à aprovação própria. O baseline PC não está integralmente
aprovado e a portagem não pode alegar regressão zero ou completude de release
com base apenas no smoke.
