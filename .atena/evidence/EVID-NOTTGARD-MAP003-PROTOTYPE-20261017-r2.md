---
id: EVID-NOTTGARD-MAP003-PROTOTYPE-20261017-r2
revision: r2
status: COMPLETE_TECHNICAL_QA_PROTOTYPE
step: S-MAP-003
date: 2026-10-17
supersedes: EVID-NOTTGARD-MAP003-PROTOTYPE-20261017-r1
---

# Reino Abissal — S-MAP-003 concluída

Autorização explícita: “Atena, autorizado o ajuste. Pode separar o cadastro em data/prototype_stages.json, mantendo o teto de 13 arquivos e as exigências dos testes existentes, e concluir a validação da S-MAP-003.” CP-MAP-003A aprovado; executado o [ajuste delimitado r1](../specs/SPEC-NOTTGARD-MISSING-MAPS-20261017/s003-catalog-scope-adjustment-r1.md). Não houve implementação anterior à autorização desse ajuste.

Cadastro do protótipo movido para data/prototype_stages.json; data/stages.json voltou a ser byte a byte igual à baseline anterior a S-MAP-003, com nove mapas. core/battle.gd resolve a definição final e, apenas para ID ausente, a definição qa_only do catálogo de protótipos. ui/run.gd bloqueia protótipo fora de Game.qa_sandbox, inclusive chamada direta de início; ui/hud.gd consulta essa definição no resultado. Menu não consulta desbloqueio de ID inexistente no catálogo final durante o retorno de QA.

Preservado: protótipo 60×60, raízes geométricas provisórias, seis cargas locais conferidas, chegada (30,45), alvo (30,15), 360 s mais presença de 3 s/raio 2, ondas/elites e limpeza sem abate/drop/XP/estatística de chefe. A simulação integral e a cobertura de pausa, dano, saída/reentrada, morte, abandono, idempotência e geometria foram novamente aprovadas. Domwieck e fluxo/HQs/progresso de campanha permanecem nas etapas seguintes.

## Orçamento e integridade

[Auditoria final](../generated/missing-maps-20261017/s003-final-validation.json): PASS_S_MAP_003; lista autorizada com 13 caminhos, **11 arquivos de jogo/teste com diferença final**. data/stages.json e tests/test_data.gd restaurados às versões anteriores. tests/test_battle.gd não foi editado e cedeu seu lugar na lista para data/prototype_stages.json. As exigências de 14 arquivos de testes existentes foram comparadas às fontes rastreadas e permanecem iguais, normalizando apenas CRLF/LF na comparação com Git. Teste novo separado: tests/test_map_objectives.gd. Não houve afrouxamento ou exclusão das exigências de fases finalizadas.

Snapshot adicional anterior ao ajuste: [s003a-before/manifest.json](../generated/missing-maps-20261017/s003a-before/manifest.json), sem substituir s003-before. Demais mudanças do projeto/planos de outros chats foram preservadas. Nenhum reset/commit/push ocorreu. A auditoria confere somente o inventário delimitado; não atribui mudanças externas a esta etapa.

## Validação executada

[Nove verificações nesta rodada](../generated/missing-maps-20261017/s003-validation-20261017-163740-615/results.json), todas aprovadas: test_stage_story, test_stage_structures, test_game_design, test_audio, test_chronicles, test_ground_decals, test_fog_edge, test_data e test_map_objectives. Os três contratos que falharam na r1 passaram pela remoção do protótipo do catálogo final, sem editar suas exigências. Os quatro riscos estáticos também passaram por execução real.

Reutilizada [evidência válida anterior](../generated/missing-maps-20261017/s003-validation-20261017-162614-141/results.json) de seis grupos não exigindo repetição: test_battle, test_stage_progress, test_terrain, test_map_scale, test_level_design e test_qa_sandbox. A resolução de mapas finais devolve a mesma definição, e o catálogo final é idêntico à baseline. Total acumulado: **15 grupos distintos pertinentes**, não alegação de execução da suíte inteira nesta rodada.

[Smoke final OpenGL](../generated/missing-maps-20261017/s003-validation-20261017-163920-607/smoke-result.json): zero falhas, logs sem SCRIPT ERROR/ERROR; cinco capturas (entrada e ritual em 1280×720/1920×1080, mais resultado), perfil sintético preservado, catálogo final com nove mapas e protótipo ausente da campanha. Conferidos carregamento QA, HUD/resultado e bloqueio da entrada normal. [Prévia do ritual](../generated/missing-maps-20261017/s003-validation-20261017-163920-607/reino-abissal-1280x720-ritual.png) inspecionada. Acabamento é esquemático DRAFT, não arte final. O primeiro smoke após a separação expôs consulta de Profile.stage_unlocked ao ID removido; corrigida no menu já autorizado, e smoke repetido sem erro.

Cada sessão de projeto foi precedida por sonda mínima sem autoload, confirmando OS.get_user_data_dir dentro do diretório sintético da sessão. APPDATA/LOCALAPPDATA exclusivos do processo e --controller-profile sintético. Nunca carregado/copiado save real. Verificação de diff dos caminhos de jogo alterados passou sem erros de whitespace. Scripts de auditoria/validação são registros ADD e não dependências novas do jogo.

## Resultado, limites e próximo checkpoint

S-MAP-003 concluída tecnicamente no escopo QA autorizado. Plano r1: **3/7 concluídas, quatro restantes**. Não há BLOCKING técnico remanescente desta etapa. Playtest humano, sensação/dificuldade, acabamento final e integração de campanha não são demonstrados pelas verificações automáticas e permanecem pendentes nas suas etapas. Sem execução/escrita Web, geração remota, instalação de dependências ou publicação; portagem do novo fluxo continua DEFERRED pela exceção PC-only aprovada.

Próximo objetivo S-MAP-004: protótipo funcional de Domwieck, usando contrato CANON e dossiê r1 aceito, com ruas/rotas livres, aproximação do jardim vermelho/Ailalore azul-clara e conclusão de 420 s + presença de 3 s; sem Adam matável, escolta ou vida da estrela. Saída esperada: mapa verificável em QA isolada e evidência de objetivo/geometria/legibilidade. Revalidar recursos/consumidores e orçamento antes de editar; manter modo per-step. **CP-MAP-004 pendente**, nenhuma execução de Domwieck autorizada por este fechamento. Trabalho/retorno da HQ14 preservado no estado vigente, sem restauração de snapshot antigo.
