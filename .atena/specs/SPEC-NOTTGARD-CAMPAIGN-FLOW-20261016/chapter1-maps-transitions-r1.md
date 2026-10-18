---
id: SPEC-NOTTGARD-CHAPTER1-MAPS-TRANSITIONS-20261016
revision: r1
status: DRAFT_AWAITING_DESIGN_ACCEPTANCE
origin: planned
implementation_preceded_spec: false
platform: windows-x86_64
---

# Capítulo 1 — mapas e transições

Saída de S-C1-002, autorizada por “Atena, aprovado. Vamos detalhar os mapas e as transições do capítulo 1”, em 2026-10-16. Autoriza elaboração documental; este contrato é proposta concreta para aceite antes de implementação. Roteiros aprovados permanecem [CANON](../../vault/canon/CHAPTER1-SCREENPLAYS-APPROVED-20261016-r1.md); valores de gameplay, campos e métodos abaixo são DRAFT técnico, não nova lore. Nenhum código/arte/runtime foi alterado.

## Resultado pretendido e limites

Campanha PC: Docas → Reino Abissal → Domwieck → encerramento com Helion. Duas cenas novas de mapa em 60×60 unidades de chão, conservando escala/câmera/controles do jogo. Sem plataforma com queda, salto, escolta ou vida própria de Ailalore. Personagens narrativos não precisam virar NPCs simulados.

Docas conserva chefe Guardião verdadeiro, ondas, duração e balanceamento nesta entrega. Reordenar seu acesso é necessário, mas reformular seus acontecimentos misturados de sessões diferentes fica fora deste recorte. O mapa Reino Abissal leva ao ritual; confrontos com Kein, Beholder e Death Tyrant ficam na HQ18, integralmente aceita. Domwieck tem conclusão por objetivo e não simula Adam como chefe matável. Não gerar inimigos/chefes novos por efeito deste desenho.

Capítulo 2 continua pendente: não inserir Dagruve/Thalion, raiz de Yggdrasil ou HQ19–21 neste fechamento. A entrada futura fica reservada para depois do fim do capítulo 1; não ligar provisoriamente Domwieck a Shedaklah ou à Dagruve antiga. Perfis legados preservam acesso às fases já desbloqueadas, em acesso livre separado da progressão narrativa nova.

## Fluxo de campanha

| ID estável | Condição | Apresentação / ação | Saída |
| --- | --- | --- | --- |
| T-C1-001 | Iniciar campanha nova em Docas | HQ01, antes de qualquer passo de combate, rumor/tempo de fase | Docas |
| T-C1-002 | Guardião verdadeiro derrotado em Docas | Salvar conclusão e liberação de Reino Abissal; enfileirar HQ02 → HQ15 → HQ16 → HQ17 | Leitura pausada, depois saída interativa |
| T-C1-003 | Após a fila de Docas ser resolvida | Escolher continuar pela passagem ou extrair. HQ14 fica disponível no Diário como complementar, sem interromper a sequência | Reino Abissal, na mesma run, ou menu com acesso à próxima fase |
| T-C1-004 | Objetivo de Reino Abissal cumprido | Salvar conclusão e liberação de Domwieck; HQ18 inteira | Leitura pausada, depois portal de retorno ou extração |
| T-C1-005 | Continuar após HQ18 | Carregar Domwieck conservando build/vida/recuperação de transição já existentes | Domwieck |
| T-C1-006 | Objetivo de Domwieck cumprido | Salvar conclusão; HQ03, seis quadros | Encerramento do capítulo |
| T-C1-007 | HQ03 concluída ou fechada explicitamente | Registrar fechamento narrativo; exibir “Capítulo 1 concluído”, resultado e retorno ao menu | Sem iniciar capítulo 2 automaticamente |

HQ14 — A Máscara é memória complementar anterior ao encontro com Erik; no Diário fica em “Complementares do capítulo 1”. Liberação nova: conclusão de Docas. Não é oitava HQ obrigatória entre Docas e a primeira incursão. Preservar desbloqueio histórico por `pilares_ativos` para perfis que já o possuíam, sem mudar a conquista/recompensa em si.

Os oito IDs do capítulo são `hqn_01, hqn_02, hqn_15, hqn_16, hqn_17, hqn_18, hqn_03, hqn_14`; as sete principais têm ordem explícita. A posição dos IDs novos não depende de ordenação numérica. HQ01/HQ02 ficam intactas; HQ16 Q3 mostra a Igreja de Nott em corte distinto, como aprovado.

## Mapa 1 — Docas existente

- ID `docas`; ordem narrativa 0; `unlock: start`; `next: reino_abissal`; tier, moedas e atributos originais preservados, mesmo que o tier não seja igual à posição no menu.
- Duração atual 300 s até o Guardião verdadeiro, mantida; matar o chefe conclui como hoje. O primeiro início padrão de Game/Battle/menu/QA passa a Docas quando não houver seleção explícita válida. Testes que nomeiam outra fase não devem ser silenciosamente redirecionados.
- HQ01 precede o primeiro combate. O marco de Docas aciona quatro HQs em fila; não aciona capítulo 2. Extração continua disponível depois da conclusão e da apresentação/dispensa das HQs.
- A Maré pós-chefe já existente em Docas mantém sua regra. Seu relógio não avança durante HQs; ao fechar a fila restaura-se a pausa anterior, sem intervalo oculto de dano acumulado. Não reiniciar a Maré após replay do Diário.

## Mapa 2 — Reino Abissal novo

**Identidade e fonte:** raízes colossais, abismo cilíndrico, acampamento da legião e ruínas ligadas ao ritual, conforme S11–12. É a primeira incursão; não é Shedaklah, não tem floresta fúngica de Zuggtmoy e não contém Marciela. Relâmpagos são ambiente visual, sem dano novo. Texturas/silhuetas finais dependem da prontidão visual; esta etapa só define zonas textuais.

**Layout proposto:** terreno caminhável contínuo 60×60, coordenadas normalizadas; entrada (0,50; 0,75), raiz central (0,50; 0,50), acampamentos laterais (0,25; 0,50)/(0,75; 0,50), acesso ao ritual (0,50; 0,25). Corredores de pelo menos seis unidades, área livre de seis unidades em torno da entrada e quatro em torno do alvo. Abismo fora da área caminhável é cenário, nunca queda instantânea. Alvo acessível desde o início; nenhum portão dinâmico que possa prender o jogador.

**Objetivo:** sobreviver 360 s e, a partir daí, chegar ao acesso ao ritual e permanecer por 3 s num raio de duas unidades. O contador da presença pausa/reinicia se sair da área; dano não o reinicia. Tempo restante e marcador de destino visíveis. Não exigir matar todos os inimigos, pagar ouro, coletar item aleatório ou derrotar um personagem nomeado.

| Intervalo, segundos | Ondas iniciais propostas | Limite por tipo |
| --- | --- | --- |
| 0–180 | `cultista_adaga`, 2 a cada 4 s | 12 |
| 30–240 | `notivago`, 2 a cada 4 s | 12 |
| 90–360 | `cultista_arqueiro`, 1 a cada 6 s | 6 |
| 150–360 | `cultista_cajado`, 1 a cada 8 s | 5 |
| 210–360 | `criatura_corrompida`, 1 a cada 8 s | 6 |

Elites: criatura corrompida aos 120 s; cultista de cajado aos 240 s. Cap global 50, tier 2, HP×1,9, dano×1,8, moedas×1,45. Multiplicadores são sobre as bases dos inimigos; continuam recebendo dificuldade/Marcas já existentes. Sem nova regra de dano de chão ou Maré pós-chefe. Após 360 s, cessa o diretor de ondas/elites; sobreviventes continuam ativos até concluir a presença, sem novas ondas infinitas. Se o jogador já estiver no alvo aos 360 s, os três segundos contam a partir desse instante.

**Conclusão:** emitir `objective_completed` uma vez; limpar perigos/inimigos sem executar `_kill`, sem XP/loot/abate por essa limpeza; registrar `stage_cleared`; pausar e exibir HQ18. A HQ contém os confrontos narrativos e a abertura da invasão. Em seguida o portal de retorno oferece Domwieck, ou extração. `boss: ""`, `completion.kind: timed_reach`; não criar chefe fictício só para satisfazer código antigo.

## Mapa 3 — Domwieck novo

**Identidade e fonte:** distrito élfico em torno de Ailalore, entrada da invasão e caminho até a floresta/santuário da estrela (S12). Urbanismo élfico atingido por incêndios, transição para vegetação e rosas; paisagem sob a Tarn azul até o evento final. A névoa verde invadindo pelo colapso, o ataque de Adam e as raízes do Véu pertencem à HQ03. O mapa não deve mostrar previamente a proteção viva já pronta.

**Layout proposto:** 60×60; chegada (0,50; 0,75), praça de resistência (0,50; 0,55), ruas laterais (0,25; 0,50)/(0,75; 0,50), acesso ao santuário (0,50; 0,25). Via central com seis unidades livres, duas rotas laterais de quatro, bolsões de combate de raio seis. Fogo/escombros visuais fora dos corredores críticos; sem nova simulação de incêndio ou civis que possam morrer e bloquear o objetivo. Ailalore ao fundo, sem barra de vida.

**Objetivo:** sobreviver à pressão da invasão durante 420 s e então chegar ao santuário, mantendo presença 3 s em raio dois. Mesma regra de presença/tempo de Reino Abissal. Sobreviver longe da estrela libera a chegada, mas não teleporta nem conclui automaticamente. Texto de objetivo: “Resista à invasão e alcance Ailalore”.

| Intervalo, segundos | Ondas iniciais propostas | Limite por tipo |
| --- | --- | --- |
| 0–210 | `cultista_adaga`, 2 a cada 3,5 s | 14 |
| 30–300 | `notivago`, 3 a cada 4,5 s | 15 |
| 90–420 | `cultista_arqueiro`, 1 a cada 6 s | 6 |
| 150–420 | `criatura_corrompida`, 1 a cada 7 s | 7 |
| 210–420 | `cultista_cajado`, 1 a cada 8 s | 5 |

Elites: criatura corrompida aos 140 s e cultista de cajado aos 280 s. Cap global 54, tier 3, HP×2,2, dano×2,0, moedas×1,6. Os tipos são inimigos já disponíveis; não afirmar que esses nomes cobrem toda a composição histórica da legião. Sem usar demônio de Gehenna como se fosse prova de sua presença nesta invasão. Não incluir Adam como alvo, unidade selecionável ou inimigo que use animação de morte.

Após 420 s, cessa o diretor; sobreviventes continuam até o alvo. Ao cumprir presença, encerrar combate, limpar sem recompensas de abate e disparar HQ03. O ataque de Adam à estrela, sacrifício, fuga de Adam e Véu Vivo são vistos na HQ. Nenhuma condição de vitória depende de derrotar Adam ou impedir a queda da Tarn. `boss: ""`, `completion.kind: timed_reach`, `next: ""`; `final_victory` dos Pilares permanece intocado.

## Finalização de objetivo e recompensas

Extrair a conclusão comum de fase da rotina que hoje só existe em `_on_boss_dead`; propor uma rotina `complete_stage(reason)` idempotente. Para objetivos, `stage_cleared`, `stages_cleared`, `cleared_ids` e bônus de conclusão têm o mesmo significado de vencer uma fase. Não incrementar `bosses`, `boss_ids`, `boss_kills` nem criar baús/loot de chefe. Para fases tradicionais, abate e drops seguem iguais, chamando a conclusão comum depois.

Recompensa inicial dos mapas novos: fórmula de conclusão já existente, `60*(1+tier)` na liquidação normal de run, mais ouro realmente coletado; sem pagamento narrativo adicional. Objetivo não cria conquista de abate. Conquistas agregadas que contam fases concluídas podem avançar, como previsto por sua métrica; não tratar presença como abate de chefe. Não trocar recompensa de conquista antiga ou pagar novamente na migração/leitura/reentrada.

Continuidade na mesma run conserva vida/build/recuperação/reward_multiplier existentes. O nome visível da ação nos mapas novos é “Continuar”/“Retornar a Nottgard”, não “Descer” para voltar ao material. Não mudar a matemática de profundidade global por causa do nome. Extração voluntária após um objetivo é vitória de fase e encerra a run normalmente; antes do objetivo continua regendo o abandono existente, sem conceder conclusão.

## Fila de HQs, fechamento e interrupção

Hoje a lista é calculada antes de salvar `cleared`, mas o acesso também deriva de `cleared`. Por isso recalcular depois de um carregamento pode considerar a HQ liberada e nunca apresentá-la. Separar três conceitos: **liberada no Diário**, **pendente de apresentação** e **lida inteira** (`hqs_seen`).

1. Ao evento de conclusão, gravar em uma única mutação persistível o marco e as entradas ordenadas da fila, antes de abrir o leitor. Não depender da próxima execução de `newly_triggered_ids` para recuperar essa fila.
2. Um único controlador drena a fila; outros eventos só acrescentam IDs únicos. Pausar Battle/diretor, Maré, dano e tempo. Não abrir duas telas ou consumir input de avanço no quadro seguinte. Restaurar a pausa anterior ao fechar.
3. Salvar cursor a cada troca de quadro; ao encerrar inesperadamente o aplicativo, retomar a mesma HQ/quadro antes de iniciar outra partida narrativa. O diário pode também retomar a leitura pendente. Não prometer restaurar combate, HP, RNG ou inventário da run interrompida: o jogo não tem snapshot de run neste escopo.
4. Avançar além do último quadro marca leitura completa e retira a entrada, com `mark_hq_seen` e recompensa de leitor exatamente uma vez.
5. **Fechar explicitamente** dispensa a apresentação atual, grava `presentation_done[id] = dismissed`, retira sua entrada e segue para a próxima; não marca leitura completa, não paga recompensa e mantém a HQ liberada no Diário. Conclusão integral grava `presentation_done[id] = read`. O jogador pode fechar todas sem bloquear o mapa seguinte. Essa dispensa consciente é diferente de falha/fechamento inesperado do processo. Nunca enfileirar ID já resolvido em `presentation_done`, inclusive após replay de fase ou reinício do programa.
6. Replay não altera mapa, resultado, milestone ou fila de campanha; concluir pela primeira vez no Diário pode marcar `hqs_seen`, como hoje. Replay posterior nunca duplica moedas.
7. Persistência de conclusão de fase não é persistência de recompensa de run. Em queda do processo, conservar milestones/fila; ouro/build não liquidado segue a limitação existente. Reabrir a fila nunca executa `finish_run` nem liquida a run antiga novamente.

Ao terminar Domwieck, conclusão jogável e fechamento narrativo são distintos. `domwieck_cleared` é salvo antes da HQ03; `chapter1_closed` só após HQ03 terminar ou ser dispensada explicitamente. Se HQ03 já estava lida em perfil legado, pode ser considerada apresentada sem obrigar repetição, mas nunca conceder `chapter1_closed` antes de vencer Domwieck novo.

## Modelo aditivo de progresso e compatibilidade

Proposta de campo novo `campaign_progress`, sem alterar o nome técnico/caminho do save ou apagar campos herdados:

```json
{
  "version": 1,
  "milestones": {},
  "pending_hqs": [],
  "presentation_done": {},
  "legacy_stage_access": {},
  "legacy_hq_access": {},
  "next_stage": "docas"
}
```

Milestones permitidos neste recorte: `docas_cleared`, `reino_abissal_cleared`, `domwieck_cleared`, `chapter1_closed`. Fila usa `{id, panel_index}`; só IDs conhecidos, índice limitado ao tamanho atual. `presentation_done` registra resolução de apresentação (read/dismissed/legacy) sem substituir `hqs_seen`. Inicializar leitura histórica como read e HQ01 já conhecida de perfil antigo como legacy; nunca presumir leitura das novas HQ15–18. `next_stage` deriva dos milestones e não é autoridade suficiente para desbloquear. Um `next_stage` desconhecido recua para a primeira etapa válida, sem alterar moedas/conquistas. Campos desconhecidos no save continuam preservados.

Migração, na primeira leitura sem `campaign_progress`: analisar o dicionário de entrada original **antes** da migração que infere Docas de Dagruve; capturar o acesso que o perfil teria na versão antiga usando catálogo/baseline antigo congelado nesta evidência. Só então aplicar migração histórica e adicionar o campo novo. Recarregar versão 1 não recaptura acesso nem enfileira tudo de novo. `_migrate_stage_split` fica restrita à entrada legada, para Dagruve concluída no futuro não inventar Docas concluída na campanha nova.

| Perfil sintético de origem | Resultado planejado |
| --- | --- |
| Novo/vazio | Somente Docas disponível na campanha, HQ01 no primeiro início; sem mapas novos concluídos |
| Antigo com moedas/estatísticas, sem fases vencidas | Preservar economia e acesso antigo a Dagruve; campanha nova em Docas; HQ01 disponível no Diário sem repetição automática obrigatória |
| Antigo com Dagruve vencida | Preservar acessos antigos (incluindo Docas/Shedaklah liberadas pela regra antiga). Reconhecer apenas equivalência de Docas concluída para o início do fluxo; nenhuma conclusão de Reino Abissal/Domwieck/Thalion inventada |
| Antigo com Docas vencida, sem Dagruve | Docas concluída reconhecida; Reino Abissal disponível, novas HQ15–17 pendentes na primeira retomada narrativa; não marcar HQ02 lida sem leitura |
| Antigo com camadas avançadas/HQ03 já liberada ou lida | Preservar acesso livre e HQ03 no Diário; nova campanha pode começar por Reino Abissal se Docas equivalente; Domwieck precisa ser jogada para o novo marco final |
| Antigo com HQ11/12/13 vistas ou suas conquistas já existentes | Congelar direito histórico de replay em `legacy_hq_access`; sem perder conquistas/moedas nem apresentação automática nova |
| Versão 1 com fila interrompida | Retomar cursor da fila; migração idempotente, sem novas recompensas nem objetivos concluídos artificialmente |

Reconhecer equivalência de Docas não marca HQ02 lida. Ao optar por continuar a história nova após equivalência, apresentar HQ02 se ainda não lida e HQ15–17 se não lidas/dispensadas. Não abrir retrospectiva automaticamente só por carregar o menu de perfil antigo.

Campanha e acesso livre legado usam permissões diferentes. Para perfil novo, `stage_unlocked` deve obedecer milestones: Docas livre; Reino Abissal após Docas; Domwieck após Reino Abissal; demais fases bloqueadas na trilha narrativa até contrato posterior. Para legado, união do acesso histórico congelado com os mapas novos liberados pela campanha; não fechar conteúdo que já podia jogar. `Game.start_run` valida permissão além do botão do menu; QA explícita continua podendo selecionar alvos isolados com contexto sintético.

Não transformar `achievements.fechadura_aberta.reward.unlock_stage` em atalho novo; hoje o desbloqueio real vem de `stages.unlock`. Preservar essa conquista e os bônus já obtidos; o modo legado continua permitindo seu contexto original. Não retargetear conquistas de Dagruve para o novo Guardião, nem alterar sua definição de chefe por efeito deste recorte.

## Retirada das três HQs e Diário

Manter registros `hqn_11/12/13`, imagens, conquistas e `hqs_seen` no acervo; marcar como fora da seleção ativa de campanha. Excluir da apresentação por novas conquistas e de novos desbloqueios por fallback genérico. Replay arquivado somente para direitos congelados de perfil legado; não conceder leitura removida a perfil novo porque ganhou a conquista depois da atualização. As próprias conquistas e recompensas continuam existindo.

Diário principal mostra as oito HQs ativas do capítulo conforme liberação. Arquivo histórico separado só aparece se houver direito. HQs do capítulo 2 já existentes conservam direitos antigos de perfis legados, mas não são novas entradas do fluxo de campanha do capítulo 1. Não excluir fontes/crônicas históricas para implementar essa seleção.

## Arquivos previstos e limites de implementação

| Arquivos | Alteração delimitada futura |
| --- | --- |
| `data/stages.json` | Docas como entrada e duas definições novas; `completion` explícito; sem alterar ondas das fases posteriores |
| `data/chapter_flow.json` (novo) | Ordem, gatilhos, capítulos, complementares e seleção arquivada separados de IDs históricos |
| `data/hqs.json`, `core/hq_catalog.gd` | Quatro HQs novas, HQ03/HQ14 aceitas; fila, direitos históricos e ordem; preservar HQ01/02 |
| `data/stage_story.json`, `data/stage_events.json`, `data/stage_rules.json`, `data/stage_structures.json` | Somente entradas dos dois mapas novos e textos genéricos de objetivo; não reescrever lore posterior |
| `data/level_design.json`, `data/scenery.json`, `data/prop_visuals.json` | Zonas/props dos dois mapas; novas referências só após aceites visuais |
| `ui/stages/reino_abissal.tscn`, `ui/stages/domwieck.tscn` (novos) | Mesmo contrato Ground/Sorted/Hero/SpawnPoints, 60×60, caminhos livres e alvos |
| `core/battle.gd`, `ui/run.gd` | Conclusão de objetivo, limpeza sem abate, transições e fila serializada; não mudar balanço global |
| `core/profile.gd`, `core/game.gd` | Progresso aditivo, migração, validação de início, save/cursor; Game padrão Docas |
| `ui/hq_screen.gd`, `ui/menu.gd`, `ui/hud.gd`, `ui/stage_progress.gd` | Cursor/estado do leitor; objetivo em vez de chefe ausente; encerramento; Diário ativo/histórico |
| `core/playtest.gd`, `tools/playtest_interop.gd` | Apenas tratar QA de objetivo sem acessar boss vazio; preservar separação PC/Web |
| `assets/hq/*`, `assets/stages/*`, `assets/tiles/*`, `assets/props/*` | Somente recursos aceitos necessários aos oito roteiros/dois mapas, com manifestos de origem |
| Testes existentes pertinentes; `tests/test_chapter_flow.gd` (novo) | Contratos de fluxo/migração não cobertos; sem testes que apenas espelhem constantes |

Não alterar `project.godot`, dependências, credenciais, permissões, estrutura externa do projeto ou arquivos Web. `data/enemies.json`, armas e heróis não precisam de novas entidades neste desenho. `achievements.json` fica preservado. `core/terrain_layout.gd` só poderá ganhar entrada dos dois mapas se necessária à passagem no chão, mediante registro no inventário antes de editar; não mudar layouts antigos. Orçamento inicial: 48 arquivos de texto/cena/teste, mais assets aprovados por manifesto; excedente ou alteração de contrato exige revisão antes de implementar.

Os nomes de métodos/campos são propostas locais, não API publicada. Preferir adaptar os componentes existentes, sem framework novo ou biblioteca. Inventário/hashes da análise são baseline informativa; antes de escrever código, recapturar hashes e comparar mudanças concorrentes. Não restaurar pasta inteira em recuperação.

## Validação futura e aceitação

1. Referências válidas, dois IDs novos sem colisão, todos os inimigos das ondas existentes; `boss` obrigatório só para `completion.kind=boss`. `test_data`/menu/QA não indexam inimigo vazio. `test_catalog` é catálogo de inimigos/itens, não prova da ordem da campanha.
2. Duas fases com alvo alcançável desde spawn; contador só depois do tempo, raio e saída/reentrada corretos; morte/abandono não concedem objetivo. Dois callbacks da mesma conclusão não duplicam evento/drop/bônus. Simulação da limpeza não gera mortes/XP.
3. Perfil novo sem atalhos por menu, chamada direta, conquista, `next` ou migração; perfil legado preserva permissões congeladas. Nenhuma conclusão de mapa novo fabricada a partir de Dagruve/HQ03 antiga.
4. HQ01 antes do primeiro passo; HQ02/15/16/17 na ordem; HQ18 depois do objetivo; HQ03 após Domwieck. HQ14 complementar. Fechar não marca leitura completa; interrupção inesperada retoma; nenhum avanço duplicado por input ou recompensa em replay.
5. Salvar/carregar antes/depois de cada marco, início/meio/fim de cada HQ, dispensa explícita e capítulo fechado; duas migrações idênticas, campos desconhecidos preservados, moeda/conquista sem perda/duplicação. Usar os sete casos de perfil da tabela e incluir saves com HQ removida conquistada versus não conquistada.
6. Docas/rotas legadas continuam funcionais, chefe/baús/fog originais sem regressão. Os novos objetivos não chamam boss_dead, final_victory dos Pilares ou baú de chefe. O capítulo acaba no resultado/menu, nunca inicia capítulo 2 em fundo.
7. Testes: test_data, test_profile, test_save_resilience, test_hqs, test_stage_progress, test_stage_story, test_stage_structures, test_map_scale, test_terrain, test_reach_grid, test_battle, test_playtest, test_qa_sandbox, test_catalog; selecionar os pertinentes por arquivo realmente alterado. `test_chapter_flow` cobre fila/migração/permissões reais. Checks apenas após mudanças justificadas.
8. Leitor/HUD/menu em 1280×720 e 1920×1080, teclado/controle, pausa restaurada, objetivo/destino e feedback claros. Isolamento prévio com sonda de user_data_dir e perfil/APPDATA/LOCALAPPDATA sintéticos. Nunca carregar save real.
9. Playtest humano comunica build, rota, tempos, objetivo e critérios; feedback de duração, clareza, dificuldade e continuidade é pendente. Os 360/420 s e multiplicadores são valores iniciais ajustáveis após observação, não prova de diversão.

## Prontidão, decisões e próximo checkpoint

Desenho documental fechado sem lacunas técnicas sem proposta: objetivos, chefes ausentes, fila, fechamento, migração, HQ14, arquivo histórico e fronteira final possuem solução concreta acima. **Aceite do contrato de gameplay/compatibilidade r1 está pendente**, separado do pedido que autorizou elaborá-lo; isso bloqueia sua implementação. Não promover proposta técnica a CANON automaticamente.

Prontidão visual continua pendente antes da produção de cada HQ/mapa. Próxima etapa S-C1-003 começa pela seleção de referências e reaproveitamento da HQ15; produzir candidatas somente depois da seleção/prontidão aceitas e da autorização pertinente. Capítulo 2 e portagem Web seguem DEFERRED. Roteiros já aprovados não precisam de novo aceite.

Conclusão de S-C1-002: entregar este contrato, anexo estruturado e evidência; duas etapas de seis concluídas, quatro restantes. CP-C1-02 solicita aceite deste contrato r1 e início apenas da preparação/seleção visual HQ15, mantendo gates individuais de arte. Suspensão e cursor de retorno dos planos anteriores permanecem registrados, sem marcar o capítulo entregue antes dos testes/playtest.
