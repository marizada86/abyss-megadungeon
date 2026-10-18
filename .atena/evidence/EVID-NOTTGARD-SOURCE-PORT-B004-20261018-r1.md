# Validação final e preparação humana — B-PORT-004 r1

Data: 2026-10-18. PLAN-NOTTGARD-SOURCE-PORT-20261018 r1.
Autorização do dono: “aprovado o lote 4. Pode executar a validação final e
preparar a avaliação humana, preservando DRAFT e as retenções pendentes.
Depois retornamos à HQ05.”

S-PORT-007 concluída; S-PORT-008 entregue como preparação com pendências
explícitas, conforme sua saída prevista. **8/8 entregas do plano realizadas;
aceite humano não realizado e não presumido.** Não é aprovação integral
de release, conteúdo canônico ou exportação. Runtime não foi alterado no lote 4.

## Integridade e disposição final

`b004/integrity-r1.json` e `disposition-matrix-final.json`: 4.037 caminhos,
zero disposição de arquivo indefinida. Isso não encerra gates de conteúdo.

| Disposição final | Quantidade |
|---|---:|
| Reutilizados idênticos | 2.824 |
| Copiados da origem | 505 |
| Conciliados com o PC | 45 |
| Preservados PC/HQs aprovadas | 242 |
| Conflitos preservados após revisão histórica | 21 |
| Contratos de teste mantidos | 6 |
| Exclusões mobile | 12 |
| Suporte de desenvolvimento catalogado, sem admissão/execução em massa | 382 |

Origem integral conferida contra manifesto B001 e intacta. Entrega conferida
contra manifesto B001 + receipts B002/B003, sem drift. Os 21 itens preservados
foram comparados com a base histórica: a maioria só contém avanços PC; a
decoração do leitor HQ é excluída para preservar composição aprovada. A
adição da origem ao audit_projeto é validação de min_attr, já coberta por
test_data portado; ferramenta PC não foi substituída. Scripts de produção/
diagnóstico permanecem catalogados com path/hash na matriz, fora da paridade
de runtime e sem copiar histórico pessoal.

Versão preparada: **PORT-PC-20261018-B004-r1**. Selo de 1.808 caminhos de
runtime na candidata; inclui scripts/cenas/dados/assets/configuração e exclui
metadados de importação mutáveis/cache. Cada byte selado corresponde à entrega.
Fingerprint: `bb60436a71f7e043df94ec7f178bd1c54398ef058e37afb9b8b63753536d6b17`.
O iniciador verifica esses hashes antes de abrir a sessão. A candidata está
em `tmp/port-b3/candidate`; não a remover enquanto a avaliação estiver pendente.

## Validação reutilizada com entradas ainda válidas

Não repetir suítes aprovadas sem mudança: B001 da origem e B003 final do PC
reutilizados após conferir hashes. Evidências B001/B003 continuam vinculadas.

- Importação da entrega: zero erros; smoke final de 11 mapas: zero erros.
- Controle: 94 checks funcionais, zero falhas/erros de script; hardware físico
  permanece pendente. Houve mensagem de recurso em uso no encerramento inicial.
- Probes nativos: 37 checks runtime + 13 UI, zero falhas/erros de script;
  capturas de runtime/opções em 720p/1080p disponíveis em B003.
- Suíte global: mesmas 30 falhas e 2 erros de script herdados, não limpa.
  Quatro mensagens de teardown na suíte e limpeza GL nas capturas permanecem
  registradas separadamente. Não afirmar regressão zero de toda a engine.

Dívidas continuam DEBT-PORT-001 a 009: contratos antigos de testes/ordem,
HQ count/decals/eventos, duas falhas de fixture fog_edge, associação ausente
de áudio/ambiência e crônicas dos mapas exclusivos PC, e teardown. Não foram
criadas novas regras, trilhas ou lore para acomodar testes. Retenções e gates
subjetivos são pendências independentes da integridade dos arquivos.

## Comparação de custo nova

Protocolo `b004/measurement-protocol-r1.md` escrito antes de medir. Mesma
máquina, Godot 4.7.2, OpenGL Compatibility/NVIDIA GTX 1650, 1280×720;
baseline PC B001 versus candidata B003, sequencial ABBA, dois runs de cada.
Probe confirma user:// sintético em `tmp/port-b4/user`; nenhum save real lido.

| Métrica — média das duas execuções | PC anterior | PC atualizado |
|---|---:|---:|
| Mediana entre quadros | 1,392 ms | 1,851 ms |
| p95 entre quadros | 1,725 ms | 2,283 ms |
| p99 entre quadros | 1,853 ms | 2,474 ms |
| Memória estática Godot | 78,38 MiB | 85,63 MiB |
| CPU para 1.800 passos / 30 s simulados | 568,817 ms | 626,529 ms |

Apresentação com 32 inimigos congelados nas mesmas posições, 120 quadros de
aquecimento e 360 amostras por execução, VSync/FPS cap desligados. Simulação
separada com seed 8142, Molor, entrada nula e HP de teste; ambas terminaram
running, 30 s simulados e 29 inimigos. Total: 1.440 quadros amostrados e
7.200 passos. Custo observado aumentou: p95 +0,558 ms (~32%) e CPU ~10%.
Não atingiu o sinal diagnóstico proposto de aumento simultâneo >25% e >2 ms;
p95 desse cenário ficou abaixo da referência indicativa de 16,67 ms.

Não é contrato de desempenho canônico nem prova de FPS em jogo longo, VRAM,
GPU time, hardware diferente ou janela em foco. A revisão nova usa seus
defaults/arte/atmosfera, portanto mede custo integrado, não uma otimização
isolada. Sem otimização, instalação ou mudança de dificuldade. Baseline
encerrou limpo; candidata emitiu sete mensagens GL de limpeza, como os probes.
Primeira tentativa do harness teve inferência de tipo inválida, corrigida antes
das quatro medições; nenhuma alteração no runtime por esse problema.

## Avaliação humana preparada

`human-review-r1.md` contém versão/escopo, objetivo, abertura, sequência de
25–35 min, critérios/observações e limites. `human-feedback-r1.md` começa
inteiramente não testado. Parecer de funcionamento, identidade, conforto,
dificuldade, diversão e controle físico requer pessoa jogando.

Iniciador: `b004/Avaliar-Portagem.cmd` → `review.py`. Confere selo, cria
APPDATA/LOCALAPPDATA/perfil novos e prova user:// em sessão isolada antes de
abrir a candidata. Abre Quartel/Navegador QA e não inicia playtest humano
automaticamente. Python já disponível, sem dependências novas. Uma tentativa
com PowerShell foi negada pelo AuthorizationManager local; substituída por
Python, sem alterar política de execução ou permissões.

Verificação oculta real do iniciador: PASS, zero falhas/erros de script;
captura `review-ready.png` inspecionada, seletor e botões acessíveis em 720p.
`b004/launcher-verification.json` registra sessão, isolamento e sete mensagens
GL de teardown. Não confundir essa abertura automática com avaliação humana.
Roteiro L5 usa entrada natural do chefe; prévias de 70%/35% não substituem
luta real como evidência de avaliação das mecânicas novas.

## Retorno e limites finais

DRAFT, G-D4, bugs de identidade/passada e todas as retenções do contrato
continuam pendentes; nenhum aceite visual/lore/arquitetura promovido.
Sem exportação, commit, push, rede, publicação ou edição da origem.

Retorno autorizado à **HQ05, S-V05-001/CP-V05-01**, com seleção r1 aguardando
aceite do dono e geração ainda desautorizada. Preservar proposta de Blogbog/
núcleo e os cinco quadros; autorização do lote 4 não aprova essa seleção.
O feedback humano da portagem fica pendente em paralelo, com versão selada.

Relatórios novos: `b004/integrity-r1.json`, `disposition-matrix-final.json`,
`preserved-conflicts.json`, `review-seal.json`, `measurement-results.json`,
`measurement-summary.json`, `isolation.json`, `launcher-verification.json`
e `closeout-r1.json`. Checkpoints CP-PORT-007/008 encerrados como validação
técnica e preparação com pendências explícitas; não como aceite humano final.
