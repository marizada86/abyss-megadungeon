---
id: SPEC-NOTTGARD-DAGRUVE-CHAPTER2-DOSSIER-20261017
revision: r1
status: S_DAG_003_COMPLETE_AWAITING_CP_DAG_004
origin: planned
implementation_preceded_spec: false
classification: IN_PLAN
approval_mode: per-step
---

# Dagruve e Thalion — dossiê r1

S-DAG-002 autorizada por “aprovado autorizado”, após a [proposta r1](proposal-r1.md). Entrega documental: etapa2/5, duas entregas preparadas, três etapas de execução/validação/playtest restantes. O contrato jogável abaixo é DRAFT e exige aceite próprio antes da S-DAG-003. Não houve implementação, Godot ou geração de imagens.

## Autoridade e continuidade

CANON: [HQ19 r2](../../vault/canon/HQ19-SCREENPLAY-APPROVED-20261017-r2.md), [roteiros capítulo2 r2](../../vault/canon/CHAPTER2-SCREENPLAYS-APPROVED-20261017-r2.md), [aceite HQ19 Q5](../../vault/canon/ASSET-APPROVAL-HQ19-Q5-20261017-r1.md). HQ19 Q1–4 antecede Dagruve; Q5–12 sucede o confronto. Thalion sobrevive. Leoric/Korrak são enviados antes; Maelor é capturado, interrogado e enviado depois; Aila fica com Thalion. Não converter a conclusão jogável em morte, fuga conjunta, interrogatório interativo ou travessia simultânea.

Fonte operacional: [auditoria local e hashes](../../generated/dagruve-chapter2-20261017/audit-r1.json). Capítulo1 e três mapas aceitos permanecem preservados. data/chapter_flow.json ainda é o contrato do capítulo1; este dossiê não cria progressão do capítulo2.

## Estado real de Dagruve

Mapa60×60, projeção isométrica existente. Cena ui/stages/dagruve.tscn: chegada projetada(0,960), equivalente a(30,30); textura assada3840×1920, atlas128×64, variante visual17. A cena contém props estáticos, mas SceneryLayout.apply substitui os Prop pela distribuição efetiva de data/scenery.json. Não usar somente as posições da cena para certificar uma rota.

Catálogo legado: duração300s, cap base45 (o diretor legado também incorpora bônus temporais/de abertura), tier0, multiplicadores de PV/dano/moeda1. Chefe sacerdote_mente_derretida, próximo mapa docas, desbloqueio start. Sete ondas: zumbi, slime_corrosivo, cultista_adaga, cultista_arqueiro, notivago, cultista_cajado e criatura_corrompida; elites aos94/188s. Esse conteúdo retrata o culto/fratura e não equivale ao confronto com Thalion.

Regra: Rituais da Névoa, intervalo55s, atraso7s e interrupção1,5s. Eventos: ritual_da_nevoa115s e pulso_da_fratura290s. Há selo sacrificial(42,38), poço(36,41), segredos, relíquia e ecos referentes à campanha anterior. A crônica também relata a fratura. O protótipo deve desativar esses acontecimentos e textos somente na sua variante, conservando-os no mapa legado. Não basta trocar o nome do chefe.

Terreno/rotas efetivas: rua leste-oeste y26,x4–56; rua do selo x42,y26–56; praça do selo centrada(42,38); beco oeste(9,37); sudoeste(18,47); ruínas ao norte(30,8); leste(51,19); sudeste(50,50). Dagruve não tem entrada em level_design.json: SceneryLayout usa scenery.json. Estrutura decorativa dagruve_estrutura_01 tem alvo(14,20), reposicionado por busca segura e block_radius0; não é um templo aprovado por equivalência de nome ou posição.

## Recursos e prontidão visual

| Recurso | Situação e uso proposto |
| --- | --- |
| Piso assado/atlas Dagruve, fundo e thumb | Locais existentes, dimensões/hash no inventário; reutilização técnica no QA sem repintura; não constituem nova aprovação de arte final do templo |
| Props de pedra, pilares, velas, braseiros, caixas, livros/ossos | Distribuição legada; conservar colisão/escala, conferir no protótipo e não inventar significado religioso |
| Estrutura256×256, poço e selo256×256 | Existentes; estrutura decorativa pode permanecer; poço/selo não recebem funções do confronto e seus efeitos antigos ficam desligados na variante |
| HQ19 Q5 v01,1672×941 | Inspecionada: Thalion loiro com vestes azul/vermelho e ornamentos dourados; soldados armados no templo de pedra com velas/arcos. CANON visual aprovado para esse quadro; referência de identidade, não sprite recortável ou asset automaticamente admitido |
| Unidade Thalion | Nenhuma chave Thalion no catálogo enemies.json; nenhuma unidade de combate pronta identificada nos consumidores consultados |
| cultista_adaga/arquéiro | IDs existentes para pressão corpo a corpo/distante; usar apenas como substitutos QA declarados, sem renomear facção/aparência para guardas oficiais |
| Áudio Dagruve | Arquivos locais de música/ambiência; conservar o comportamento existente, sem novas falas ou anúncio de morte de Thalion |

Identidade ambiental relevante: templo de Dagruve segundo HQ19. A planta interior exata não está aprovada. Identidade de Thalion relevante e ilustrada na Q5; faltam sprite/ações finalizados. Para o primeiro protótipo proposto não desenhar Thalion nem gerar soldados: representação por contexto textual e marcador de área, sem retrato improvisado, boneco atribuído a ele ou HP de chefe. Identidade de personagem gerado N/A porque nenhum personagem será produzido. A avaliação de arte final/interior é DEFERRED, explicitamente fora deste protótipo.

## Contrato DRAFT recomendado para o primeiro ensaio QA

**Objetivo:** testar circulação e pressão do confronto, preservando o desfecho em que Thalion vive. Não é uma implementação completa das habilidades de Thalion. Encenação técnica na área existente de Dagruve, não reconstrução canônica do interior da HQ.

**Variante:** id de cenário QA dagruve_thalion_r1, acionado somente por request encounter_id em Game.start_qa_run com stage_id dagruve e sandbox ativo. Manter battle.stage_id=dagruve para reaproveitar terreno, props, sons e catálogos visuais. Aplicar cópia local das definições, sem sobrescrever Dagruve nem Data._cache. Definição da variante em data/prototype_stages.json com qa_only:true/base_stage:dagruve e scene própria. O catálogo released continua vencendo no caminho normal; não cadastrar a variante em stages.json.

**Geometria:** manter60×60 e chegada(30,30), clareira inicial mínima5. Alvo provisório(30,18), raio2. Rotas de conferência: eixo(30,30)→(30,18), alternativa oeste via(18,30)/(18,18) e leste via(42,30)/(42,18). Esses pontos são intenções de teste, não rotas já certificadas. Testar acesso com corpo do herói e colisões reais; área do alvo precisa de folga3. Se algum bloqueio legado impedir acesso, corrigir a posição do marcador dentro da região norte livre antes de declarar prontidão; não remover ou deslocar objetos do mapa normal. Mudança relevante do alvo/rotas exige registro e nova conferência.

**Duração e saída:** proposta180s; após esse tempo, alcançar o alvo e manter presença3s, raio2. Sair do raio zera presença; pausa/menu não avançam; morte, abandono ou extração precoce não concluem. Dano não zera presença sozinho. Contar apenas fração de dt posterior ao limite, como no contrato timed_reach existente. Texto: “Resista ao confronto; alcance a área marcada após o tempo”. Resultado QA: “Encenação concluída — desfecho narrativo pendente”. Conclusão não se chama “Thalion derrotado/morto”, não é captura/teleporte automático de um herói específico e não executa a HQ19.

**Pressão inicial:** cap estrito32 corpos combatentes, sem aumento por minuto/marcas; PV/dano/moeda1, tier0 como base. Apenas inimigos existentes/provisórios: cultista_adaga desde0s, a cada4s,2 por emissão,max12; cultista_arqueiro desde30s, a cada7s,1,max6; desde90s a onda de adagas passa a cada3s,max18 e a de arqueiros a cada5s,max8 (substituir fases, não acumular duas ondas do mesmo ID). Sem elite, chefe, invocação, runa funcional ou raiz prendendo personagem. Seed de referência7603, Durvall inicial; não atribuir estes valores ao CANON narrativo. São valores para validar no playtest.

**Preservação de conteúdo:** variante desliga regra/eventos antigos, armadilhas, poço, segredos/ecos/relíquia, interações aleatórias, quebráveis iniciais/aleatórios e spawnpoints da cena. Não mostrar a epígrafe/rumor do sacerdote como contexto de Thalion. Conservar props visuais e suas colisões. Máscaras/regras de névoa danosa e recompensas pós-chefe desligadas somente na variante. Bônus/metaprogressão/marcas neutralizados para comparação de referência, sem alteração de perfil. Desligar caminhos herdados explicitamente; mero boss vazio não os remove.

**Conclusão segura:** usar limpeza por objetivo existente, sem _kill. Thalion não é Enemy, não pode sofrer dano, morrer, dar XP/ouro, contar como chefe, entrar no códice ou criar baú. Inimigos substitutos combatidos durante o ensaio mantêm recompensas sintéticas normais; limpeza ao concluir não remunera. Parar novas admissões aos180s e após conclusão, inclusive chamadas indiretas; conclusão idempotente e retorno ao menu QA. Nenhum next para Docas/Yggdrasil, flag capítulo2 ou progresso permanente.

## Arquitetura delimitada e orçamento

Proposta S-DAG-003: máximo **8 caminhos de jogo/teste**. Sem mover lógica de runtime para helpers ADD para driblar teto.

1. data/prototype_stages.json — adicionar definição da variante, sem modificar Yggdrasil.
2. core/game.gd — transportar somente encounter_id permitido no contexto QA; rejeitar combinação inválida/fora do sandbox antes da abertura; não aceitar JSON arbitrário ou caminho de cena vindo do request.
3. core/battle.gd — resolver overlay autorizado na inicialização, antes de regras/eventos; cópia local, flags de desativação delimitadas e cap32; preservar comportamento padrão dos demais cenários. Não reatribuir stage_id para um ID sem suporte de terreno.
4. ui/run.gd — escolher cena da variante permitida, impedir spawns herdados e contexto/toasts antigos, título de conclusão QA; preservar fallback da cena e fluxo normal/QA anteriores.
5. ui/stages/dagruve_thalion_qa.tscn — cena herdada de Dagruve, sem copiar PNGs; acrescentar marcador de área local, sem novos bloqueadores.
6. ui/dagruve_encounter.gd — somente apresentação local do alvo/ensaio, sem simulação duplicada nem identidade inventada.
7. tests/test_dagruve_encounter.gd — comportamento novo e isolamento, incluindo comparação com Dagruve padrão.
8. tests/test_qa_sandbox.gd — proteção de variante/contexto/perfil e pedidos inválidos.

Não editar stages/enemies/chapter_flow/HQs/profile/Hero/terrain/scenery globais, assets ou testes de contratos para reduzir exigências. Metadados .uid derivados não contam. Se um consumidor adicional se mostrar necessário, apresentar revisão delimitada antes de exceder oito. Responsável: Atena, sem delegação/dependências. Registrar portagem e checks de comportamento compartilhado; nenhuma sincronização/alteração na origem está autorizada. Se mudança comum não puder ser validada sem ampliar acesso, explicitar a pendência antes de declarar etapa técnica final concluída.

## Validação planejada

S-DAG-003 inclui verificação mínima de importação/compilação e novo teste focal, pois protótipo funcional não pode ser entregue sem conferir inicialização e regras básicas. S-DAG-004 concentra regressões ampliadas, capturas e medição; não repetir checks já válidos sem mudança/falha.

Antes de qualquer Godot: APPDATA/LOCALAPPDATA/perfil sintéticos novos e probe sem autoload, user_dir confirmado dentro da sessão. Nunca save real. Validar pedido variante sem QA, ID inválido, mapa incompatível e caminho injetado rejeitados; cenário padrão idêntico ao baseline; overlays não alteram Data._cache e reentrada não acumula ondas/marcadores. Validar isolamento de perfil/moedas/progresso/HQs e retorno após morte/abandono/conclusão.

Checks semânticos: sem crédito antes de180s; fração limiar,3s de presença, saída/reentrada, pausa/levelup/dano, terminal morto/abandono, idempotência e cap estrito32 antes/depois do tempo. Nenhum sacerdote/Thalion spawnado; nenhuma função de morte/baú/crônica/portal acionada pela conclusão. Nada de eventos/selo/névoa/segredos herdados. Caminhos entre chegada/alvo e alternativas testados com colisões realmente carregadas; ausência de spawn sobre blockers/alvo/chegada. Não basta checar apenas os valores JSON.

Regressões propostas: test_map_objectives, test_qa_sandbox, test_battle, test_data, test_stage_progress, test_chapter_flow, test_stage_structures, test_prop_grounding, test_blocker_index, test_reach_grid, test_terrain, test_level_design, test_yggdrasil_map e test_scripts_compile (nomes existentes conferidos; reconferir conforme mudanças antes da execução). Selecionar checks adicionais somente por mudança concreta; nenhum contrato existente será enfraquecido. Capturas1280×720/1920×1080: chegada, duas alternativas, alvo, pressão32, objetivo liberado, resultado, falha/abandono e Dagruve padrão para comparação visual. Cabeçalho informa QA e substitutos provisórios.

Comparação controlada do custo do ramo comum desligado: mesma Dagruve padrão/seed7603/dt1/60/32 corpos,30frames aquecimento+600 medidos antes/depois; investigar acréscimo sustentado>10% mediana/p95 e novas pausas, registrar CPU/loop sem prometer FPS GPU. Variante medida separadamente, pois ondas/efeitos diferem. Playtest S-DAG-005 avaliará percurso, pressão, duração e clareza de encerramento, sem atribuir diversão a métricas técnicas.

## Gaps, aceite e recuperação

RESOLVED por inspeção: mapa e assets locais existentes; recursos de entrada QA e conclusão por presença; inexistência de unidade Thalion; referência visual HQ19 Q5 aprovada. RESOLVABLE na implementação/validação: alcance efetivo do alvo, desativação completa das regras herdadas, prova do cap/contexto, comparação de custo e registro de portagem. Caminhos/arte existentes ainda não foram executados nesta etapa documental.

BLOCKING para um confronto final com Thalion animado: unidade, habilidades/sprites e contrato específicos ausentes. Rota proposta dispensa essa produção **somente para o ensaio de pressão** e depende do aceite explícito dessa limitação. Não apresentar o ensaio como chefe finalizado. Sem gaps técnicos sem encaminhamento para autorizar esse protótipo delimitado; aceite do contrato DRAFT e dos substitutos permanece gate CP-DAG-003.

DEFERRED: interior final do templo, Thalion/guardas finais, novos ataques/runa/portais, sequências HQ19/20/21, campanha/saves e áudio final. Não promover esses itens por efeito da aprovação do protótipo. Recuperação por baseline de oito caminhos conferido novamente antes de editar, com cópias próprias e reversão seletiva. Preservar trabalhos concorrentes, inclusive campos HQ que apareçam no estado compartilhado; não realocar ou apagar informação de outro chat silenciosamente.

Próxima decisão: aprovar dossiê/contrato r1 com ensaio180s+3s, cap32 e substitutos QA, e autorizar S-DAG-003 nesses oito caminhos. Até essa resposta, código/arte permanecem intocados.


## Contrato aprovado e protótipo entregue — 3/5

Usuário aprovou o contrato r1 e autorizouS-DAG-003 nos oito caminhos. [Evidência](../../evidence/EVID-NOTTGARD-DAGRUVE-PROTOTYPE-20261017-r1.md). Quatro testes básicos e inicialização/conclusão/abandono isolados passaram. Rotas oeste contornam props preservados; encerramento rápido teve retenção intermitente e diagnóstico final limpo, observação específica da [S-DAG-004](validation-r1.md), ainda não autorizada. Duas etapas restantes. Texto DRAFT/autorizações pendentes acima é histórico; não promove arte/Thalion final.
