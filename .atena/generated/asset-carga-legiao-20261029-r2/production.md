# Carga da legião — candidata r2, 2026-10-29

Status: COMPLETE_CANDIDATE_DELIVERED_AWAITING_VISUAL_ACCEPTANCE. DRAFT, aceite humano pendente.

Autorização: “aprovado, proxima geração”, após o templo e a recomendação de refazer a carga com silhueta distinta. Modo per-plan. S-CG01 autorização/revisão, S-CG02 geração, S-CG03 preparação/QA, S-CG04 entrega: 4/4. Não altera outros planos.

Revisão visual: carga baixa e alongada, dois volumes embrulhados e atados em berço de madeira escura com ferragens discretas. Contrasta com a silhueta vertical do caixote existente. Sem símbolos ou lore novos. A candidata de 28/10 permanece preservada.

Gerada com imagegen nativo. Referências locais: assets/enemies/caixote_quebravel.png para acabamento, assets/animations/enemies/caixote_quebravel/death.png para sequência, assets/tiles/reino_abissal_roots_r1/surface.png somente para paleta. Prompt final exato em [prompt.txt](prompt.txt), revisão do A02 de ../../vault/drafts/PROMPTS-ASSETS-0-5-2-20261028-r2.md.

Entrega em assets_incoming/carga-legiao-20261029-r2/:

- sources/carga_da_legiao_quebravel_death_v01.png: fonte original 1983×793, preservada byte a byte.
- prepared/carga_da_legiao_quebravel/death.png: PNG RGBA 2560×512, cinco células de 512×512.
- prepared/carga_da_legiao_quebravel/static.png: PNG RGBA 512×512, extraído do primeiro quadro.

Preparação com Godot local em projeto sintético sem autoloads, com APPDATA/LOCALAPPDATA/USERPROFILE isolados. Nenhum save real. Separação em espaços transparentes com margem de quatro pixels; recorte pelo alfa >=0,1; escala uniforme em todos os quadros e base alinhada em y=432. Transparência dentro dos recortes preservada. Hashes, limites e escala em qa.json. A primeira verificação exigiu ampliar a margem de corte na primeira célula; após correção o QA terminou PASS, código 0. Mensagem ambiental de certificado do Windows em qa/preparation.log.

Fonte, folha preparada e sprite intacto inspecionados visualmente: cinco quadros separados, intacto até destroços, sem texto ou chão incorporado; silhueta baixa distinta da fonte anterior. Aceite artístico e funcionamento em jogo não presumidos. Sem integração, instalação, portagem, commit, push ou build. Repositório histórico não modificado; entrega isolada da frente transferida.

Atualização em 2026-10-29: dono aprovou r2 com “aprovado, proximo”; recibo por hash em visual-acceptance.json. Aceite visual registrado, DRAFT mantido, integração pendente. Continuação autorizada para geração do A04 em plano separado.
