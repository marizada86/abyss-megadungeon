# Portagem — B-PORT-001 concluído, r1

PLAN-NOTTGARD-SOURCE-PORT-20261018, S-PORT-001/002 concluídas em 2026-10-18.
Autorização por lote e rota agora/retornar à HQ05 persistidas antes de executar.
Somente B-PORT-001 aprovado. B-PORT-002 aguarda aprovação própria.

## Inventário e preservação

Matriz final com 4.037 caminhos: 851 exclusivos da origem, 127 diferentes,
232 exclusivos PC e 2.827 idênticos. Inclui metadados e contratos de testes;
não é contagem de funcionalidades. Matriz funcional de 12 famílias, índice
dos 127 conflitos e diferenças textuais registrados.

Origem HEAD a558cd8532ffa39cabfe49bb7b4d1c1cb978a783 confirmado lendo
HEAD/ref locais; core.bare=false, sem core.worktree. Git -C recebeu
Permission denied sob sandbox: não afirmar repositório bare ou limpo.
Nenhuma configuração/permissão foi alterada.

Manifestos SHA-256/tamanho por arquivo, snapshots de teste em tmp/port-b1 e
ZIPs de texto bruto de código/dados/config/testes. Assets têm manifesto;
backup por arquivo é obrigatório antes das próximas escritas autorizadas.
Não usar cópia de teste, modificada por imports/fixtures, como rollback amplo.
Dependências finais de snapshots excluem perfis, saídas opcionais de ferramentas
e evidências pessoais; somente contratos não pessoais de testes necessários.

integrity-verification.json confirma 3.805 arquivos da origem e 3.186 do PC
contra hashes de entrada: **zero alterações**. ZIPs íntegros, matriz com
disposição para todos os caminhos, cursor HQ05 preservado, YAML validado.
Mudanças deste lote: documentos, ferramentas de auditoria/teste, logs e
cópias sintéticas neste workspace. Nenhum asset integrado ao runtime.

## Baselines executados

Godot 4.7.2.stable.official.ed1daf0bf. Probes comprovaram user:// em
tmp/port-b1/user-source e user-pc antes dos jogos; APPDATA/LOCALAPPDATA e
perfis sintéticos próprios. Testes que escrevem res:// somente nas cópias.
Nenhum save real lido, copiado ou carregado.

| Check | Origem | PC |
|---|---|---|
| Importação final | exit 0, sem erros de script/motor | exit 0, sem erros de script/motor |
| Suíte completa | 0 falhas funcionais, 0 SCRIPT ERROR; dívidas de teardown | 30 falhas e 2 SCRIPT ERROR; dívidas de teardown |
| Smoke | 9 fases, ok, sem erro | 11 fases, ok, sem erro |
| Controle sintético | 94/0, sem erro | 94/0, 2 recursos em uso ao sair |
| Mobile sintético | retry 146/0, sem SCRIPT ERROR; recursos em uso ao sair | N/A, exclusão de plataforma |

Importação fria reclamou de fonte do tema antes de criar cache; importações
seguintes ficaram limpas sem trocar arquivos de fonte.

Primeiro mobile completou os casos até save_real_preservado, mas não encerrou
nem gravou relatório final: pasta mobile-controls/v02 não preparada. Timeout
do wrapper deixou filho vivo. Auto-review autorizou identificação/encerramento
somente de PID 26312, cuja linha de comando apontava para snapshot source e
tools/mobile_buttons_check.tscn. Nenhum outro processo foi encerrado.
Após preparar apenas o diretório sintético, retry 146/0. Primeiro timeout reteve
stdout parcial, não stderr completo; contagens de erro dessa tentativa não são
prova de ausência de erros. Adicionado limite de frames ao harness mobile.

As 30 falhas PC reproduziram individualmente: 6 afixos, 4 áudio, 2 crônicas,
1 game_design, 4 decals, 1 contagem de HQs, 12 eventos aleatórios.
test_fog_edge reproduziu 2 SCRIPT ERROR ao tentar spawn de chefe vazio e
acessar Nil, apesar de exit 0/“0 falhas”. Esse teste **não é PASS**.
Não corrigido runtime nem enfraquecidos testes neste lote.

## Contrato, dívidas e próximo objetivo

Contrato: .atena/specs/SPEC-NOTTGARD-SOURCE-PORT-20261018/b001-integration-contract-r1.md.
Dívidas: .atena/specs/SPEC-NOTTGARD-SOURCE-PORT-20261018/b001-baseline-debts-r1.md.
Nenhum gap BLOCKING para integrar assets existentes seguindo essas fronteiras;
permanecem DEFERRED conteúdo retido, novas crônicas/associações dos mapas,
exportação, hardware e aceites subjetivos. Não afirmar suíte PC limpa ou
aceite de release. Sem CANON novo, dependências, commit/push/publicação,
exportação ou acesso remoto.

CP-PORT-B002-APPROVAL: S-PORT-003/004, assets, leitores e dependências de
apresentação, animações admitidas com DRAFT e retenções preservados.
Entradas: manifestos, contrato, matriz funcional e baseline/dívidas.
Saída: recibo de integração de recursos/animações e checks de importação,
compilação, assets/animações/áudio/fontes e regressões PC pertinentes.
Novas mecânicas de combate/campanha aguardam lote 3. Aprovação B002 pendente.
HQ05 segue suspensa com S-V05-001/CP-V05-01 e aceite de seleção pendente.

Detalhes em .atena/generated/source-port-20261018/b001/: disposition-matrix,
functional-matrix, conflict-index, source/pc-manifest, add-dependencies,
rollback-receipt, git-source-readonly, integrity-verification (JSON), diffs/,
baseline-source/ e baseline-pc/ com logs, resultados e retries.
