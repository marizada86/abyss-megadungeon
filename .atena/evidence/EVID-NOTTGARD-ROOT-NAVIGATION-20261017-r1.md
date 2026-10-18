---
id: EVID-NOTTGARD-ROOT-NAVIGATION-20261017-r1
status: PASS_TECHNICAL_HUMAN_PLAYTEST_PENDING
spec: SPEC-NOTTGARD-ROOT-NAVIGATION-20261017
step: S-ROOT-002
---

# Raízes com bordas travadas — execução e verificação

Execução planejada e autorizada antes do código. [Aceite CANON](../vault/canon/DEC-NOTTGARD-ROOT-NAVIGATION-R2-20261017-r1.md). Integração: Atena, sem delegação. Preflight releu o estado compartilhado e encontrou ChapterFlow e ambos os mapas já integrados por outro trabalho; preservou esse estado. Baseline dos dez caminhos em `.atena/generated/root-navigation-20261017/baseline.json`, com cópias anteriores e hashes; não houve restauração sobre o checkout compartilhado.

Referência visual: HQ17 Q3 v02 reinspecionada em imagem; SHA-256 `5440f4c64b056f3f40f23e4ffc3e971632a64311e38b144fbae022618df650c0`, novamente conferido. Raízes escuras entrelaçadas sobre vãos; desenho geométrico provisório, não arte final. Identidade de personagem N/A para o terreno. Nove junções, doze ligações com largura seis, quatro ciclos e quatro vãos; discos/cápsulas definidos em `data/root_navigation.json` alimentam render, apoio, navegação e admissão.

O corpo inteiro precisa de apoio. Erosão conservadora por primitiva pode recusar pequenas regiões de junção que caberiam na união exata, mas nunca admite invasão do vazio. Sweep por eixos de até 0,2 unidade ou metade do raio, com verificação intermediária e margem que cobre o trecho inteiro; aplicado a movimento, push, dash, knockback, investida e separação. Sem queda, dano ou correção por teleporte. Inicialização usa entrada válida de 60×60 sem consultar bloqueios herdados do mapa anterior; UI substitui esses bloqueios por sua cena atual.

Perseguição usa campo compartilhado por footprint/célula-alvo e vizinhança cardinal, com folga de meia célula circunscrita; grade/campos em cache. Spawns não validados não são adicionados à batalha. A função conserva contrato para consumidores legados retornando objeto inerte `dead=true`, nunca registrado ou recompensado; falha da amostragem devolve sentinela não finita, sem fallback arbitrário. Nenhum ID real ganhou voo. Voadores sintéticos ignoram apenas apoio das raízes, mantendo objetos/limites externos. Recursos são projetados antes de nascer e magnetismo percorre a rede; pilhas no limite preservam valor sem pagamento automático.

Quatro cargas mantidas nos bolsões externos (12,55/47,45 nos dois eixos), com footprint de raio 0,4 inteiramente apoiado, fora das reservas E/C/G/W/L e fora das cápsulas das passagens. Duas cargas omitidas. Auditoria matemática confirma largura seis sem estreitamento por props. Domwieck e todos os outros registros de level_design são idênticos ao baseline; parâmetros do catálogo de protótipos preservados, com apenas a referência de navegação acrescentada.

## Verificações executadas

Todos os processos executáveis receberam APPDATA/LOCALAPPDATA novos dentro da sessão gerada e `--controller-profile` sintético. A sonda sem autoload confirmou `OS.get_user_data_dir()` dentro dessa sessão antes da importação/jogo. Não houve leitura/cópia de save pessoal nem mudança de permissões globais. Godot 4.7.2 Windows x86_64, render gráfico OpenGL Compatibility na GTX 1650.

- Sessão `validation-20261017-174158-072`: `test_root_navigation`, `test_map_objectives`, `test_data`, `test_level_design`, `test_terrain` passaram sem erros. Inclui simulações integrais dos dois mapas, cap 50 com fixture de 49 criaturas admitidas, objetivo/limpeza/idempotência e regressões de mapas com chefe.
- Sessão `validation-20261017-174422-944`: `test_battle`, `test_chapter_flow`, `test_scripts_compile` passaram sem erros. O runner original de combate apresentou zero falhas, mas avisos de encerramento por dois `PropRef.new()` não liberados na introspecção de `tests/test_battle.gd:1285`. O harness gerado executa as mesmas asserções sem editar esse teste e libera somente os dois nós órfãos novos; log confirma `TEST_FIXTURE_ORPHANS_CLEANED=2` e encerramento limpo.
- Sessão `validation-20261017-174603-531`: `test_root_navigation` repetido após a última proteção de inicialização e adição de provas de transição com bloqueios herdados e omissão quando toda a área está bloqueada. PASS.
- Sessão gráfica `validation-20261017-174244-028`: 13 capturas, chegada/borda/alvo de ambos os mapas em 1280×720 e 1920×1080 mais visão geral da rede. `smoke-result.json`: zero falhas e perfil de origem preservado. A primeira versão do harness comparava o perfil QA mutável com o de origem; corrigido para verificar o objeto de origem e a assinatura persistente sintética, sem relaxar proteção de dados. Imagens reinspecionadas: vazio distinto das raízes, rede conectada e quatro cargas fora das passagens. Leitura subjetiva da arte e sensação ficam pendentes.
- Sessão `validation-20261017-174511-629`: 600 passos a 1/60 s, 50 inimigos, seed 7204; zero footprints inválidos, dois caches de grade/campo. Mediana de simulação 7,724 ms; p95 16,709 ms; máximo 95,972 ms. Medição headless local com asserções e outros checks em andamento; não prova 60 FPS renderizados nem melhora sobre baseline. Picos, congestionamento e conforto deverão ser observados no playtest humano; não foi iniciado trabalho de otimização separado.
- Auditoria `.atena/generated/root-navigation-20261017/audit.json`: dez arquivos de jogo/teste, quatro props válidos, contratos de outros mapas preservados e hash da HQ conferido. Metadados derivados de importação não representam novos consumidores de código.

Falhas intermediárias preservadas nas sessões anteriores: ordem de inicialização 40×40/entrada 60×60; fixtures antigas em coordenadas agora vazias; exigência existente de props não vazios. Corrigidos no escopo autorizado, sem remover asserções de gameplay nem editar testes fora dos dois caminhos previstos.

## Reconciliação, portagem e próximo checkpoint

S-ROOT-002 tecnicamente concluída: 2/3 etapas. S-ROOT-003/CP-ROOT-003 pendente de autorização por etapa. Não sobrescrever cursores de campanhas/HQs de outros chats. A aprovação r2 substitui apenas a superfície contínua anterior do Reino Abissal, inclusive na integração PC já presente; duração 360+3 segundos, raio 2, ondas, estatísticas e HQs continuam com seus contratos.

Portagem registrada: PC Windows x86_64 somente, conforme recorte r2 aprovado “Sem ... Web”. Navegação comum possui efeito condicionado ao ID Reino Abissal, e demais mapas receberam regressão PC. Web permanece DEFERRED, não portada nem testada nesta etapa; não há alegação de paridade, sincronização ou autorização para gravar naquele projeto. Sem instalação, dependências, commit, push ou publicação.

Próxima entrada: build atual e r2, pelo `Testar-Mapas.cmd` já existente. Procedimento proposto para S-ROOT-003: escolher Reino Abissal; caminhar contra bordas e diagonais, usar habilidade junto aos vãos, percorrer centro e ambos os lados sob pressão, concluir o ritual. Observar clareza de apoio/vazio, locais de travamento/congestionamento, inimigos presos, recursos inacessíveis e picos visíveis. Critério: zero saída das raízes e caminhos compreensíveis, com avaliação humana do conforto; resultado esperado é feedback do dono, não inferido de testes automatizados.
