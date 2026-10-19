---
id: PLAN-NOTTGARD-RELEASE-0-5-0-20261018
revision: r1
status: DRAFT_AWAITING_OWNER_APPROVAL
classification: PLAN_CHANGE_REQUEST
platform: windows-x86_64
mode: per-batch
base: f88f485 (main), versão atual 0.4.0 (core/version.gd + 3 presets de exportação)
content_state: DRAFT
---

# Plano v0.5.0 — preparar playtest, fechar pendências

Pedido (2026-10-18): planejar a 0.5.0 porque muita coisa entrou e precisa ser testada de novo; levantar o que falta implementar para ser avaliado no playtest; limpar o máximo de pendências. **Este documento é só planejamento**: nada foi alterado no jogo, no estado (`plan.yaml`), no Git remoto ou em exportações. A 0.5.0 aqui é uma **versão de playtest (Windows x86_64)**, não publicação.

## 1. O que a 0.5.0 contém (entregue desde a 0.4.0, ainda sem teste humano completo)

| Bloco | Estado técnico | Aceite humano |
| --- | --- | --- |
| Capítulo 1: Docas → Reino Abissal → Domwieck, fluxo de campanha, marcos, HQ15–HQ18 e HQ03 | integrado, regressão sintética PASS | **aceito** pelo dono (2026-10-17) |
| Capítulo 2: HQ19, HQ20, HQ21, HQ04 integradas; Dagruve cap. 2 (rotas/área marcada); Raiz de Yggdrasil (mapa + arte + navegação) | integrado/validado | HQ21+HQ04 aceitas; **Dagruve cap. 2 e mapas: feedback pendente** |
| Portagem do Survivors (assets, heróis Arlindo/Erik, animações, mecânicas L5 de chefe, progressão, UI, fonte, filtro visual) | lotes B001–B004 completos, **suíte agora 0 falhas/0 erros** | **pendente** (`human-review-r1.md`, H-PORT-001…008) |
| Correções de combate/contratos (ordem de combate, adiamentos explícitos) | feito em `8fc9263` | n/a |
| Bots de balanceamento e auditoria de assets | feito em `6b82c01`/`f88f485` | n/a |

## 2. Inventário de pendências (o que falta) e classificação

**A. Técnico — posso fechar sem decisão sua (Lote 1)**

| ID | Pendência | Ação proposta | Critério de pronto |
| --- | --- | --- | --- |
| A1 | Versão ainda 0.4.0 | `core/version.gd` e `file_version`/`product_version` dos 3 presets → 0.5.0 (0.5.0.0) | Os 3 valores batem; `test_platform_contract` passa |
| A2 | `tools/validate_release.py` aponta para `D:/Godot/godot.exe` (não existe nesta máquina) e usa `rtk proxy`; sua lista de testes não cobre a suíte inteira nem a auditoria | Caminho do Godot configurável (variável de ambiente, com o `Godot_v4.7.2-stable_win64.exe` local como padrão); gate extra = `run_all` 0 falhas **e 0 SCRIPT ERROR** + `audit_projeto` 0 erros | Um comando produz relatório PASS/FAIL com sessão sintética |
| A3 | DEBT-PORT-009: ruído de encerramento (RIDs/ObjectDB, 7 mensagens GL nas capturas) | Limpar fixtures que vazam; manter qualquer ruído restante registrado, nunca como "limpo" | Contagem de mensagens de encerramento menor e documentada |
| A4 | Compatibilidade de save 0.4.0 → 0.5.0 (perfil ganhou `campaign_progress`, `settings.atmosphere`, etc.) | Teste de atualização com **fixture sintética** no esquema 0.4.0 (nunca o save real) cobrindo migração de marcos/acesso legado | Perfil 0.4.0 abre, preserva progresso/IDs e não perde conquistas |
| A5 | Estado desatualizado: `plan.yaml` cita spec/evidência HQ-CONTINUATION que **não existem no repositório**; `pc_push_request` ainda "READY_TO_COMMIT_AND_PUSH"; dívidas DEBT-PORT-001/004/005/006/007/008 já resolvidas sem registro | Reconciliar, com evidência, e propor o texto antes de gravar | `plan.yaml` coerente com os arquivos e com o Git |
| A6 | Matriz de builds: pasta `build/` não existe; templates 4.7.2 estão instalados | Exportar Desktop, Playtest Público e QA Interno em pasta de teste; smoke de cada `.exe` com perfil sintético; manifesto com hashes. **Não publicar.** | 3 executáveis abrem, mostram 0.5.0 e perfil correto (QA tools só no QA) |
| A7 | Bots depois de qualquer ajuste de balanceamento | Reexecutar `smart-god-chain` (≈10 min) e comparar com o baseline desta sessão | Sem piora > 15 % nas métricas de §4 do relatório |
| A8 | Sondas e relatório de bots fora do roteiro de release | Incluir `balance-bots-20261018` como etapa opcional do checklist | Documentado no roteiro |

**B. Decisão do dono antes de implementar (Lote 2) — são escolhas de conteúdo/design, não inventei nada**

| ID | Decisão | Opções | Minha recomendação |
| --- | --- | --- | --- |
| B1 | Início dos mapas novos (dano no 1º minuto +14…28 % vs pré-pull) | (a) deixar para o playtest medir; (b) suavizar só `reino_abissal`/`domwieck`/`raiz_yggdrasil` em dados e reconferir com bots | (a): efeito pequeno, a pessoa avalia; ajusta depois |
| B2 | Docas (1ª fase) e heróis fracos (Arlindo/Nyrelia/Durvall) | (a) só observar no playtest; (b) mexer em números (dados comuns → exige portagem registrada à origem) | (a) |
| B3 | 7 chefes sem cartaz de introdução (`boss_presentations`) | (a) aceitar sem cartaz; (b) cartaz padrão sem arte nova (sprite + nome); (c) produzir os 7 cartazes (prompts prontos) | (b) para a 0.5.0; (c) depois |
| B4 | Música/ambiência dos 3 mapas novos (DEBT-PORT-002) | (a) silêncio declarado; (b) reutilizar trilha existente por decisão concreta; (c) produzir áudio novo | (b), escolha sua |
| B5 | Crônicas dos mapas novos (DEBT-PORT-003) e `stage_story`/regra/eventos da Raiz | exigem texto canônico seu; sem isso permanecem adiados | adiar (já registrado) |
| B6 | Raiz de Yggdrasil é mapa de campanha ou protótipo QA na 0.5.0? | campanha / QA-only | QA-only (só `Testar-Mapas`) |
| B7 | HQ05–HQ10 (43 quadros novos de arte, roteiro aprovado) | (a) fora da 0.5.0, ficam as versões atuais; (b) entram em 0.5.x por HQ | (a); seleção visual HQ05 segue aguardando seu aceite |
| B8 | Fases Shedaklah→Pilares fora da trilha de campanha | manter bloqueadas (hoje) ou liberar para playtest | manter |
| B9 | Eventos aleatórios nos mapas novos (DEBT-PORT-007) | continuar sem eventos ou aprovar pesos | continuar sem |

**C. Só pessoa pode avaliar (Lote 3, é o playtest em si)**

Roteiro consolidado (25–35 min + 15 min de capítulo): H-PORT-001…008 (interface, heróis, inimigos, chefes, progressão/itens, interações, mapas e HQs, áudio/resultado), campanha do capítulo 1 em ordem com perfil novo, Dagruve cap. 2, os 3 mapas via `Testar-Mapas.cmd`, **controle físico** (nunca testado), 1920×1080 e 1280×720. Gates retidos que continuam DRAFT e não são encerrados por testes: Durvall/M1, G-D4, bugs visuais de identidade/passada, candidatos retidos (Nyrelia YN/YE). Ficha de feedback: `human-feedback-r1.md` (começa toda "não testada").

**D. Backlog de arte — não bloqueia a 0.5.0 (prompts em DRAFT, aguardam seu aceite)**

62 lacunas (relatório de assets). Candidatas a entrar se você quiser: 3 miniaturas de seleção, 6 decais, 3 quebráveis temáticos, ícone da regra de Docas (P1 do documento de prompts). Restante (cartazes de chefe, ícones de arma/bênção, Molydeus) fica para 0.5.x.

**E. Fora de escopo:** mobile; migração `D:/dev/games`/vaults (aguarda liberação de diretório); publicação/tag/release; edição do Survivors de origem.

## 3. Ordem proposta e portões

| Lote | Passos | Aprovação |
| --- | --- | --- |
| 1 — Higiene técnica | A1, A2, A3, A4, A5 (propor texto), A8 | uma aprovação para o lote; commits locais só com seu "commite" |
| 2 — Decisões | B1–B9 respondidas (podem ser "adiar") e implementação do que for escolhido; A7 reexecuta bots | por decisão |
| 3 — Candidata e builds | A6; roteiro e ficha de playtest finais; manifesto de hashes | aprovação própria; sem publicação |
| 4 — Playtest humano | Seção C; consolidar feedback em `human-feedback`; triagem (bug, ajuste, adiar) | você executa |
| 5 — Fechamento | Releituras: suíte 0/0, auditoria 0, bots sem piora, 3 builds; **tag e publicação só com pedido explícito** | sua assinatura |

Gates de saída da 0.5.0-playtest: **G1** suíte 0 falhas e 0 SCRIPT ERROR; **G2** `audit_projeto` 0 erros; **G3** bots sem piora >15 %; **G4** 3 builds com smoke sintético e versão 0.5.0; **G5** upgrade de save 0.4.0 verificado; **G6** ficha de playtest preenchida (não exige tudo "aprovado", exige tudo "avaliado"); **G7** decisões B1–B9 registradas (mesmo que "adiar"). Pendências adiadas ficam visíveis nas notas da versão; nenhuma é declarada resolvida sem evidência.

## 4. Riscos conhecidos

- O bot é um piso, não um jogador: balanceamento absoluto vem do playtest humano.
- Arte integrada segue DRAFT; "limpar pendências" não promove canon.
- Mudanças em dados comuns de heróis/armas exigem portagem registrada à origem, que não está nesta máquina (`D:/dev/nottgard/...`).
- Primeira exportação desta árvore: o tamanho/tempo de `all_resources` com 700+ arquivos de arte novos é desconhecido.

## 5. Resultado do Lote 1 (aprovado em 2026-10-18; sem commit)

| ID | Resultado |
| --- | --- |
| A1 | `core/version.gd` e os 3 presets em 0.5.0 / 0.5.0.0; `tests/test_version_contract.gd` impede divergência (mutação testada: falha quando um preset volta a 0.4.0.0). |
| A2 | `tools/validate_release.sh` (novo, **verificado aqui**, não precisa de Python): isolamento sintético, importação, contratos, suíte inteira com 0 falhas e 0 SCRIPT ERROR e `audit_projeto` com 0 erros. `tools/validate_release.py` agora acha o Godot por `NOTTGARD_GODOT`/exe local, `rtk` opcional e `--full`; **não executado** (esta máquina não tem Python). `tools/run_one_test.gd` deixou de travar quando o teste não compila. |
| A3 | `tests/run_all.gd` libera fixtures órfãs; a saída da suíte ficou sem nenhum WARNING/ERROR de encerramento (antes: 8 linhas de RIDs/ObjectDB vazados). `test_radiant_pulse_vfx` não usa mais `Image.load_from_file` em `res://` (não funciona em build exportado). Capturas/smoke seguem com mensagens GL de limpeza. |
| A4 | `tests/test_save_upgrade_050.gd`: perfil sintético no esquema 0.4.0 preserva moedas, melhorias, conquistas, estatísticas, códex, ajustes, HQs vistas e fases vencidas; ganha os campos novos; mantém o acesso legado; migração idempotente e estável após JSON. Achado documentado: a regra antiga "vencer Dagruve abre Docas" acrescenta `docas` em `cleared`. |
| A5 | `plan.yaml` atualizado: dívidas DEBT-PORT-001…009 com disposição, `pc_push_request` marcado como concluído, nota na continuação das HQs e novo bloco `release_0_5_0_plan`. **Achado:** 228 de 575 arquivos citados no `plan.yaml` (21 evidências, 186 gerados, 21 specs) não existem neste repositório nem no histórico Git (lista em `.atena/generated/release-0-5-0-20261018/missing-state-references.txt`); não foram recriados. |
| A8 | Bots e relatório entram no checklist como etapa opcional (G3 só roda se houver mudança de balanceamento). |

Gates agora: G1 PASS · G2 PASS (0 erros, 9 avisos conhecidos) · G5 PASS (fixture sintética) · G3 não executado (sem mudança de balanceamento) · G4/G6/G7 pendentes.

## 6. Decisões do Lote 2 (entrevista de 2026-10-19) e execução

| ID | Decisão do dono | Execução |
| --- | --- | --- |
| B1 | Ideia nova: mapas **bônus** desbloqueados por quest, para farmar recurso. Para a 0.5.0: **registrar a ideia e manter a campanha** | `SPEC-NOTTGARD-BONUS-MAPS-20261019/idea-r1.md` (DRAFT, sem código) |
| B2 | Só observar Docas e os heróis no playtest | Nenhuma mudança; fica no roteiro do playtest |
| B3 | Os 7 cartazes de chefe aguardam o Vault (em atualização, servirá de referência); **aceitar sem cartaz** | Nenhuma mudança; prompts seguem DRAFT |
| B4 | Reutilizar trilhas: Reino Abissal = Pilares, Domwieck = Goranthis, Raiz = Pilares | `data/audio_manifest.json` (música e ambiência, 3 entradas cada); adiamento de áudio removido de `tests/stage_contracts.gd`; teste confere arquivos |
| B5 | O assistente redige rascunho de crônicas a partir do Vault | `.atena/vault/drafts/CHRONICLES-NEW-MAPS-DRAFT-r1.md` (nada gravado em `chronicles.json` até o aceite) |
| B6 | (decorrente de B1) Raiz segue **QA-only** | — |
| B7 | HQ05–HQ10 **fora da 0.5.0** | Seleção visual HQ05 segue aguardando aceite |
| B8 | **Liberar** Shedaklah–Pilares nos builds de playtest | `Game.stage_available` (usado pelo menu e por `start_run`) abre todas as fases quando o perfil de build é Playtest Público ou QA (`Version.playtest_opens_all_stages`); `Profile.stage_unlocked`/ChapterFlow seguem puros e produção segue a trilha; política testada em `test_version_contract` |
| B9 | Sem veto: eventos aleatórios dos mapas novos seguem **adiados** (padrão do plano) | Nenhuma mudança |

Vault: a cópia local (`F:\dev\nottgard-vault`, commit `8472f7a`, 2026-10-17) traz pacotes de referência visual de personagens (CHAR-002…066, Illithar), cronologia e evidências; **não** traz referências de chefes nem novas notas de Reino Abissal, Domwieck ou Yggdrasil. Não executei `git fetch/pull` no Vault (somente leitura; peço aprovação antes de baixar). Gate G7 satisfeito (todas as decisões registradas).

## 7. Resultado do Lote 3 — candidata e builds (2026-10-19; sem publicação)

- **Builds:** `Windows Desktop`, `Playtest Público` e `QA Interno` exportados em `build/` (ignorada pelo Git), versão 0.5.0.0 confirmada nos metadados dos três. Manifesto com SHA-256 e tamanhos: `.atena/generated/release-0-5-0-20261018/build-manifest-r1.json`. Cada `.exe` tem ~640 MB (export `all_resources`, arte e áudio WAV): vale revisar antes de distribuir.
- **Smoke:** os 3 abrem em modo headless com perfil e diretórios sintéticos, saem com código 0 e sem SCRIPT ERROR/Parse Error/falha de carga (só 2 avisos de encerramento ao fechar o título). Cobre o boot do pacote exportado; **não** cobre partida, áudio audível, controle físico nem desempenho.
- **Atalhos de playtest:** `tools/playtest_maps.ps1` não achava o Godot (caminho `D:\Godot\godot.exe` fixo) e tratava ruído de encerramento do motor como falha; agora procura `NOTTGARD_GODOT`/exe local/caminho antigo e ignora só as mensagens de encerramento (GL/RIDs). Verificação de abertura **PASS** para Reino Abissal, Domwieck e Raiz de Yggdrasil. `Testar-PC.cmd` agora tem o build que ele espera.
- **Roteiro e ficha:** `playtest-r1.md` (6 sessões, atalhos, foco derivado dos bots e das decisões B2/B3/B4/B8).
- Gate **G4** (3 builds com smoke e versão 0.5.0): **PASS**. Faltam **G6** (playtest humano) e o aceite do rascunho de crônicas.
