# HQ01 — suplemento de integração r1

Status: autorizado no escopo da sequência integral de oito quadros apresentada ao dono e aprovada em 2026-10-15 para preparar integração PC/Web. Complementa a spec r1 preservada; não substitui o plano de 16 etapas nem autoriza HQ02. Especificação anterior à implementação de runtime. Roteiro, candidatas individuais e sequência possuem aceites explícitos; não há gap BLOCKING neste escopo.

## Escopo e aceitação

Integrar exclusivamente HQ01 r2: oito imagens aprovadas e textos exatos da sequência. Substituir assets/hq/hq_n01_q1.png a q4.png e adicionar q5.png a q8.png em PC/Web; preservar arquivos anteriores em backup com hashes. Atualizar somente a entrada hqn_01 em data/hqs.json. Preservar ID, título, gatilho first_run, schema de panel {image,text}, leitor, conquistas e perfil. Diálogo Q2 reúne as duas falas em linhas separadas; prefixos dos interlocutores ficam visíveis. Outras 13 HQs seguem intactas com quatro quadros, total de 60 imagens referenciadas. A regra anterior de quatro quadros/56 imagens passa a ter esta exceção concreta para hqn_01. HQ02 de cinco quadros aprovada textualmente não será integrada nesta rodada; decisões sobre capítulos/gatilhos permanecem fora desta integração.

O leitor usa panels.size() e já aceita oito; não exige mudança no leitor. O Diário possui indicação fixa “4 quadros” em ui/menu.gd: corrigir somente essa linha para exibir panels.size(), preservando todo restante. Ajuste necessário à quantidade de oito já aprovada, incluído antes desta escrita de produção. Adaptar teste de catálogo para exigir oito na HQ01 e quatro nas demais, e exercício do leitor para percorrer os oito, conferir contador/legenda/imagem e concluir somente depois do oitavo. Manter regressões de gatilhos, legado, conquistas, Esc e bloco de notas. Executar test_hqs, test_profile e test_playtest em ambos e verificar a indicação dinâmica/replay no smoke do Diário.

## Recuperação e portagem

Registrar snapshot atual e comparar hashes antes de cada escrita; não restaurar globalmente. Portar somente oito PNGs, entrada HQ01 e teste correspondente, com recibo PC/Web; preservar diferenças de plataforma, project.godot e arquivos de outros chats. Importações geradas pelo Godot são permitidas para os oito recursos. Backups/estado/evidência no coordenador PC; escrita Web depende da permissão do ambiente já dentro do escopo autorizado. Sem commit, push, publicação, dependências ou save real.

## Validação e limites

Seguir validation.md: APPDATA/LOCALAPPDATA exclusivos dos processos, sonda sem autoload exigindo user_data_dir sob a sessão sintética antes de iniciar projetos, --controller-profile explícito. Importar os recursos e executar checks sem carregar dados reais. Conferir leitor em 1280×720 e 1920×1080: oito quadros, textos completos, proporção, avanço/fechamento e repetição/replay. Não alegar execução em navegador por validação desktop de projeto Web; navegador e avaliação humana permanecem explícitos se não realizados. Teste automático não substitui legibilidade/ritmo humanos. Encerrar S-HQ-002 apenas ao satisfazer a aceitação planejada; manter pendências de plataforma/aceite visíveis.
