---
id: EVID-NOTTGARD-DAGRUVE-PROTOTYPE-20261017
revision: r1
status: IMPLEMENTED_BASIC_ISOLATED_VALIDATION_PASS
---

# S-DAG-003 — protótipo entregue

Contrato r1 e implementação autorizados por “aprovado autorizado”. [Contrato CANON](../vault/canon/DEC-DAGRUVE-QA-ENCOUNTER-CONTRACT-20261017-r1.md), [baseline/escopo](../generated/dagruve-chapter2-20261017/s003-baseline.json). Oito caminhos previstos editados, sem ampliar orçamento, alterar PNGs ou mover runtime para ADD.

Variante encounter_id dagruve_thalion_r1 apenas com mapa dagruve e sandbox ativo; não é um ID de fase. Entrada rejeita cenário incompatível, atalho de vitória e pedido de cena/overlay injetado antes de abrir sandbox. Contexto da variante neutraliza bônus/dificuldade/marcas, construtor rejeita uso sem QA. Definições copiadas localmente antes de regras/eventos. Cena herdada mantém terreno/props/colisões, com marcador e rótulo de substitutos, sem Thalion atacável. Regra/eventos/segredos/interações/quebráveis/selo/névoa danosa/spawnpoints legados desativados somente na variante.

180s+3s/r2/cap32, fases exclusivas de ondas em90s, intervalos reais da variante independentes do fator global SPAWN_SLOW. Conclusão limpa sem _kill, sem chefe/loot/portal/campanha. Dagruve padrão e dados globais permanecem intactos; Yggdrasil e demais protótipos preservados.

[Quatro testes básicos aprovados](../generated/dagruve-chapter2-20261017/validation-20261018-003716-319/results.json): test_dagruve_encounter, test_qa_sandbox, test_map_objectives e test_scripts_compile. Novo teste cobre cap/admissão direta, bloqueio de sacerdote/chefe, proximidade de chegada/alvo, cadência/fases, presença limiar/saída/pausa/terminais, limpeza sem recompensa e idempotência, recarga sem mutar cache e cena herdada. Teste sandbox cobre pedidos inválidos e contexto neutro; controles/Nodes auxiliares do próprio teste agora são liberados explicitamente.

[Verificação final de cena completa](../generated/dagruve-chapter2-20261017/validation-20261018-004043-013/smoke-result.json), executada headless com modo verbose: duas entradas, conclusão e abandono, título do resultado correto, alvo com folga3, rotas com colisão real,64 amostras de nascimento seguro e perfil original sintético inalterado. Alternativas central/leste livres nos segmentos propostos. Oeste precisa contornar props: busca em grade0,5 com amostragem de segmentos confirmou o percurso, sem mover cenário. Coordenadas e caminhos estão no relatório. Este check não certifica conforto ou aparência.

Falhas intermediárias: simulador da variante usava40×40 antes do carregamento da cena; corrigido para60×60 apenas na variante. Harness inicial não avançava relógio entre amostras de presença; corrigido, regra existente preservada. Duas execuções rápidas posteriores passaram as asserções mas mostraram retenção de4 objetos/2 recursos no encerramento; execução diagnóstica final verbose encerrou limpa. Não se afirma correção de vazamento do jogo por esse resultado: estabilidade do encerramento/recursos permanece observação específica para S-DAG-004, com espera de assentamento e comparação com baseline. Uma chamada de múltiplos testes passou nomes como string única; launcher corrigido, sem enfraquecer critérios de erro.

Perfis APPDATA/LOCALAPPDATA sintéticos com probe sem autoload confirmado antes de qualquer Godot; nenhum save real. Assets, catálogos released, navegação, capítulo1 e HQs guardados por hashes; sem geração, instalação, portagem automática, commit ou publicação. [Registro de portagem](../generated/dagruve-chapter2-20261017/s003-portability.json): origem somente leitura; regressão de comportamento comum, capturas, desempenho e aplicabilidade em ambos projetos permanecem na etapa de validação ampliada.

Plano:3/5 etapas concluídas; CP-DAG-004 aguarda autorização. Nenhum playtest humano aberto e nenhum aceite visual inferido.
