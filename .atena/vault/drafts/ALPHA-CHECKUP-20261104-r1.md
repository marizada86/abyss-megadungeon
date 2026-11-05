# Checkup geral para o Alpha Demo (DRAFT r1, 2026-11-04)

Estado: rascunho do checkup pedido pelo dono antes de reduzir o ritmo do projeto. Nada foi commitado, buildado, enviado nem publicado.
Decisões do dono nesta sessão: escopo = campanha completa jogável (12 heróis); build = **Produção** (trilha da campanha, preset "Windows Desktop"); público = amigos/testadores; commit/build = **não** (só preparar e validar); arquivos das sessões "Evolução de armas" e "Prompts golpe telegrafado" não são tocados; ritmo/tempo dos mapas da rampa B **aprovados**; vem uma atualização de renomeação de nomes por direitos autorais (tratada em separado).

## 1. Veredito

O código está saudável e o alpha é viável. O que falta não é motor: é **fechar a árvore (commits), decidir o número de versão, gerar a build de Produção, e um playtest humano** que nenhum teste automático cobre.

## 2. O que foi verificado (perfil sintético isolado, save real nunca carregado)

| Verificação | Resultado |
|---|---|
| Importação Godot, contrato de versão, contrato de plataforma, adiamentos de fase, upgrade de save 0.5.0 | PASS |
| Suíte inteira (`tests/run_all.gd`) | 1ª rodada: 4 falhas, todas de `test_weapon_school` (evoluções em andamento na outra sessão); 2ª rodada, depois que ela terminou e depois das minhas mudanças: **0 falhas** |
| `tools/audit_projeto.gd` | 0 erros, 0 avisos |
| Texto corrompido (`Ã£`) em `passives.json` e `weapons.json` | visto na 1ª leitura (2 e 29 linhas), **corrigido pela outra sessão**; hoje 0 |
| Erros de motor no log da suíte | 24× "Lambda capture was freed" (defeito real, abaixo) → hoje 0; resta só o aviso de saída "1 resources still in use" (inofensivo, de fixture de teste) |

Limite: nada disto substitui jogar em janela. Sem teste em janela, sem controle físico, sem medição de quadros real nos mapas pesados.

## 3. Correções feitas (arquivos que as outras sessões não tocam)

1. **Vazamento de conexão em `UiKit.apply_window`** ([ui/ui_kit.gd](../../../ui/ui_kit.gd)). Cada janela (pausa, ficha, opções) conectava um lambda ao sinal global `Game.visual_settings_changed` e nunca desconectava. Depois que o painel era liberado, mudar escala/contraste/modo de cor fazia o motor lançar o erro e acumulava conexões numa sessão longa. Agora a conexão vive só com o painel na árvore (`tree_entered`/`tree_exited`). `test_ui_kit`, `test_accessibility` e a suíte: 0 falhas, 0 ocorrências do erro.
2. **Teto de interativos vivos** (decisão aberta da auditoria de ritmo; o dono aprovou o pacote de ritmo e pediu para implementar). Escolhi a opção recomendada: **4 vivos em mapas ≥ 300 s, 3 nos curtos**, por dado (`difficulty.json` → `interactions.max_alive_long` e `max_alive_long_min_duration`) e uma condição em [core/battle.gd](../../../core/battle.gd) (`_spawn_random_interaction`). `tests/test_pacing.gd` cobre mapa longo com 3 (há vaga), com 4 (sem vaga, tenta de novo em 8 s) e mapa curto com 3 (sem vaga). **Reversível**: apagar as duas chaves devolve o comportamento anterior. Nota: o dono não escolheu uma das opções na pergunta; tratei "ritmo aprovado, pode implementar" como delegação à recomendação. Se preferir outra, é trocar uma chave.

## 4. Riscos e pendências para fechar o alpha (por prioridade)

**A. Bloqueantes (só você decide/autoriza)**
1. **Versão e build.** `core/version.gd` e os 3 presets estão em 0.5.2, mas a árvore já tem muito mais (ritmo M2–M4, Favor no HUD, quebráveis do Reino Abissal, templo, carga, discípulo, etc.). Os `.exe` de `build/` são de 19/10; o zip `dist-0.5.2` é do playtest público e **abre todas as fases**. Para a demo de Produção é preciso: novo número (sugestão: `0.6.0-alpha.1`, a confirmar), `tools/stamp_build.ps1`, exportar só o preset "Windows Desktop", smoke do `.exe`, zip e SHA-256. O preset de Produção **nunca foi exercitado nas versões recentes**: a trilha da campanha só tem cobertura de teste, não de janela.
2. **Commits e branch.** 13 arquivos rastreados modificados + 272 itens não rastreados, três sessões escrevendo. `feat/codex-lore` está 18 commits à frente de `main` (5 ainda não enviados). Falta decidir: commits temáticos, merge em `main`, tag. Nada disso foi feito.
3. **Textos de distribuição.** `LEIA-ME.txt` e `NOTAS-DA-VERSAO.txt` da 0.5.2 dizem "abre TODAS as fases" e descrevem F5/F6/F7; estão errados para a build de Produção. Precisam de versão nova.

**B. Qualidade que só playtest humano resolve**
4. **Equilíbrio dos mapas finais.** Bots mortais morrem 100%; o imortal vence Shendilavri 2/6 e Goranthis 1–3/6; Pilares não mudou. Não sabemos se um humano consegue chegar ao fim. Playtest humano (o "Vitão") em Shedaklah, Molor, Durao e Dagruve já era a pendência M5; acrescento Shendilavri→Pilares. O ouro/XP sem compensação (decisão de 02/11) só se valida assim. Medalhas de abates precisam de revisão.
5. **Desempenho.** Só há medição real em Docas (57 fps médios, p99 29 ms). Falta um passe em janela real em Goranthis/Pilares (≈100 inimigos com VFX do lote 3). A simulação custa ≤ 1,5 ms/passo; o risco está em render/VFX.
6. **Controle físico** nunca foi testado (consta no LEIA-ME). Para amigos testadores: avisar, ou testar uma vez antes.
7. **Aceite humano pendente** do CP-SPLIT-02 (início de tentativa, ofertas, pausa, ficha, Quartel).

**C. Conteúdo/arte (aceitável como pendência declarada do alpha)**
8. Fila de assets: 8 fontes aceitas (r1) e 19 candidatas (r2) **ainda sem integração** e sem aceite visual das 19. Lacunas conhecidas: animações de `molydeus_menor` e das ilusões, ícones de regra de fase (Docas, Reino Abissal, Domwieck), quebráveis temáticos, música/ambiência próprias do Reino Abissal, Domwieck e Pilares. Nenhuma impede jogar.
9. Evoluções de armas (plano `PLANO-EVOLUCOES-20261104-r1.md`) estão em andamento em outra sessão, com D-1..D-5 a decidir; os nomes são **provisórios** e entram na renomeação abaixo.

**D. Higiene do repositório**
10. `git count-objects -v` acusa lixo: `tmp_pack_*`, 8 `.idx` sem `.pack` e 6 `tmp_obj_*` (resto de operação interrompida). Pack de 1,54 GiB. Proposta: `git fsck` e `git gc` **depois** que as sessões terminarem, com sua aprovação. Não apaguei nada.
11. `.atena/generated/controller-experience/v01/unit-profile.json.bak` sempre aparece modificado (ruído de teste de controle): restaurar antes do commit.
12. `.atena/state/plan.yaml` tem CRLF e 3 400 linhas; as outras sessões o editam, então **não registrei nada nele** (ver 6).

## 5. Preparação para a renomeação por direitos autorais

Princípio já alinhado com o AGENTS.md: **IDs, nome técnico e saves não mudam; só mudam textos exibidos.** Levantamento de ocorrências por termo (inclui IDs, que ficam):

| Termo | Dados (arquivos) | Código core/ui | Testes | Arquivos de arte/áudio com o id |
|---|---:|---:|---:|---:|
| Zuggtmoy | 16 | 7 | 45 | 23 |
| Juiblex | 16 | 8 | 32 | 13 |
| Ghaunadaur | 13 | 3 | 15 | 8 |
| Malcanthet | 13 | 7 | 15 | 15 |
| Socothbenoth | 12 | 10 | 22 | 21 |
| Molydeus | 13 | 8 | 27 | 18 |
| Blogbog | 10 | 4 | 12 | 12 |
| Graz'zt | 5 | 1 | 16 | 2 |
| Death Tyrant | 7 | 2 | 6 | 4 |
| Arch-hag | 8 | 3 | 3 | 4 |
| Gehenna | 7 | 3 | 6 | 4 |
| Lu Yueh | 9 | 0 | 3 | 0 |
| Nidhogg | 5 | 2 | 18 | 2 |

(A lista de termos é só minha varredura de nomes que parecem vir de material de terceiros; **quem decide o que muda é você/o trabalho em separado**.)

O que ajuda a renomeação:
- **Camada de nomes exibidos.** Hoje o nome aparece em `enemies.json`, `codex_lore.json`, `chronicles.json`, `hqs.json`, `stage_events.json`, `stage_story.json`, `boss_presentations.json`, `chapter_flow.json`, `stages.json`, `favor.json`, `boons.json`, `items.json`, `achievements.json`, `secrets.json`, `hero_bios.json`, mais ocorrências em código (poucas por termo, de 1 a 10; ex.: [core/battle.gd](../../../core/battle.gd), [core/boss_mechanics.gd](../../../core/boss_mechanics.gd)). Sugestão pós-alpha: tabela `id → nome exibido` única, e um teste que acusa nome antigo em texto exibido. Não implementei: é refatoração com risco e a lista final de nomes ainda não existe.
- **Testes com nome embutido** (≈ 250 ocorrências): vão precisar de atualização em bloco quando a lista final sair. Os que comparam por id não quebram.
- **Arte com texto embutido** (HQs, cartazes, `lettering.json`): não verifiquei imagem por imagem. Se alguma tiver o nome desenhado, precisa de nova geração.
- **Momento certo.** Para amigos testadores sob combinação, o alpha pode sair com os nomes atuais. **Antes de qualquer divulgação pública, a renomeação tem de estar feita.** Recomendo registrar isso no LEIA-ME do alpha.
- **Segredos do Vault**: renomear não pode vazar "cânone do mestre". A lista final de nomes deve vir do Vault, não de dedução.

## 6. Roteiro para amanhã (ordem recomendada, ~2–3 h seus)

1. **Fechar as duas sessões** e pedir revalidação (`bash tools/validate_release.sh`; leva ~5 min).
2. **Decidir** (5 min): número de versão; commits temáticos (autorizo-os a você) e o destino de `feat/codex-lore` → `main`; aprovar ou trocar o teto de interativos 3/4.
3. **Eu preparo**: bump de versão nos 4 lugares, textos da distribuição, registro no `plan.yaml` (após as outras sessões acabarem), `git fsck`/`gc` se você autorizar.
4. **Build de Produção** com sua autorização (`stamp_build.ps1`, só o preset "Windows Desktop", smoke, zip, SHA-256).
5. **Seu playtest de 30–45 min** na build de Produção: Docas → Reino Abissal → Domwieck → Dagruve → Shedaklah, depois um salto de teste até Goranthis/Pilares com o Vitão; um passe em controle se possível; ver se a trilha libera as fases na ordem certa e se o fim da campanha fecha.
6. **Enviar** ao grupo só com seu "sim" explícito; sem push/tag automáticos.

## 7. Não feito de propósito
Commits, build, push, tag, publicação, apagar lixo do `.git`, tocar nos arquivos das duas sessões ativas, registrar no `plan.yaml` (concorrência), implementar a camada de nomes, rodar o save real.
