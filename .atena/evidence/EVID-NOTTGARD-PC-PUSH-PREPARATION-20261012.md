---
id: EVID-NOTTGARD-PC-PUSH-PREPARATION-20261012
revision: r1
date: 2026-10-12
status: AUTHORIZED_READY_TO_COMMIT_AND_PUSH
---

# Preparação do push do PC

Pedido explícito: “vamos fazer o push do pc”. Autoriza envio do projeto PC ao origin existente; não inclui Web, origem histórica, deploy ou atualização de pacotes. Commit local requer autorização explícita independente, conforme regras globais/local de Git.

Destino conferido: https://github.com/marizada86/abyss-megadungeon.git, branch main. HEAD local e referência remota consultada em 2026-10-12: b106b0c6cc8d8765123ff9a48afa3bda1587c27a. Nenhum commit pendente de push antes desta preparação; mudanças de trabalho ainda não commitadas.

Conjunto proposto para um commit: exclusão dos 30 recursos e seus 30 metadados aprovados; configurações do nome no editor e caminhos legados de saves; comentário de core/game.gd e documentação operacional; spec/adendo canônico autorizado e evidências/manifestos JSON/candidatos relativos às duas entregas locais. Não incluir builds, caches, saves, temporários, logs volumosos ou código da versão Web. .atena pode registrar os checks nos dois alvos sem incluir arquivos do projeto Web neste repositório.

Validação reutilizada: [limpeza](EVID-NOTTGARD-RESOURCE-CLEANUP-EXECUTION-20261012.md), [nome e saves](EVID-NOTTGARD-EDITOR-NAME-EXECUTION-20261012.md). Configuração atual do PC corresponde ao hash validado; fontes e arte preservadas. git diff --check passou; referência main no remoto conferida sem escrita remota.

Commit proposto: `Clean unused assets and update editor name preserving saves`. Aguardar autorização para criar esse commit; push já solicitado pelo dono. Revalidar HEAD/delta se houver mudança concorrente ou remoto avançar. Nenhum force push, merge, deploy ou publicação de build autorizado. Plano de separação e aceite humano permanecem intactos.

Autorização recebida em 2026-10-12: “autorizado”, em resposta ao conjunto preparado de 85 arquivos, ao título de commit acima e ao envio para origin/main. Gate de commit local resolvido somente para este conjunto; autorização de push permanece limitada ao PC. HEAD e referência remota main reconferidos antes de executar, ambos b106b0c6cc8d8765123ff9a48afa3bda1587c27a. git diff --cached --check passou.
