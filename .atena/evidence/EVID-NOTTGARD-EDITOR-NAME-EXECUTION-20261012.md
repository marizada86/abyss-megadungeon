---
id: EVID-NOTTGARD-EDITOR-NAME-EXECUTION-20261012
revision: r1
date: 2026-10-12
status: PASS
spec: SPEC-NOTTGARD-EDITOR-NAME-20261012
plan: PLAN-NOTTGARD-EDITOR-NAME-20261012
---

# Nome do editor no PC e Web

CP-EDITOR-NAME-01 aprovado em 2026-10-12: “aprovado, por plano”, respondendo à proposta concreta r1. DRAFT autorizado para implementação e adendo canônico explicitamente incluído no escopo. Três etapas concluídas; CP-EDITOR-NAME-02 com validação técnica PASS. Nenhuma alteração na origem histórica ou nos planos concorrentes.

Os dois project.godot passaram a declarar Nottgard - Abyss Megadungeon. user:// foi fixado via config/use_custom_user_dir e config/custom_user_dir_name para preservar o caminho Windows Godot/app_userdata/Nottgard Survivors. O override config/custom_user_dir_name.web preserva o caminho lowercase godot/app_userdata/Nottgard Survivors da implementação Web. Nenhuma migração ou alteração de nomes de arquivo/schema/IDs. Ajustado exclusivamente o comentário explicativo de core/game.gd e a frase operacional do README sobre nome/diretório.

Promoção canônica separada: [DEC-NOTTGARD-EDITOR-NAME-20261012-r1](../vault/canon/DEC-NOTTGARD-EDITOR-NAME-20261012-r1.md), escopo PC/Web. Mantido o [CANON histórico r1](../vault/canon/DEC-NOTTGARD-NAME-20261011-r1.md) e demais documentos históricos; o adendo substitui somente a restrição antiga de conservar config/name, mantendo o objetivo de persistência compatível.

Validação com Godot 4.7.2.stable.official.ed1daf0bf, seis sondas das configurações efetivamente aplicadas: PC/Web, antes/depois e seleção da feature Web. O nome retornado pela engine é o solicitado. Windows user:// antes/depois exatamente igual; fixture sintética de valor 42 escrita na configuração anterior carregada sem cópia ou migração na configuração atual. feature Web seleciona o caminho lowercase correto. Execução de navegador não realizada; equivalência do caminho virtual /userfs é fundamentada na implementação oficial já registrada na [preparação](EVID-NOTTGARD-EDITOR-NAME-PREPARATION-20261012.md). Não alegar teste de browser ou playtest por estas sondas.

Todos os processos usaram APPDATA/LOCALAPPDATA sintéticos e project.godot de sondagem sem autoload/scene/theme. Nenhum save real foi acessado, nenhum jogo real aberto e nenhum cache grande de projeto original foi regenerado. Diretórios temporários da preparação e validação removidos após PASS.

Integridade: 2955 arquivos preservados por SHA-256 no PC e 2968 no Web, zero divergências. Configurações finais PC/Web idênticas por hash 6719fb77e574e034db22714c66f6f5a91e1331816ff9041e4647fe14c5a7747b. Em core/game.gd apenas o comentário aprovado mudou; comportamento de save/runtime intacto. Metadados automáticos .git/.godot e registros ADD estão fora dessa comparação de conteúdo. Builds e pacotes existentes preservados; não foram reexportados ou renomeados. Reabrir os projetos no editor carrega o nome atualizado; não foi feita inspeção visual de uma janela reaberta.

Portagem: alterações delimitadas de project.godot e comentário de core/game.gd aplicadas seletivamente PC → Web, README ajustado respeitando cada plataforma. Evidências e backups equivalentes em ambos. Sem sincronização automática, instalação, publicação, commit ou mudança de permissões globais.

[Backups e hashes anteriores](../generated/editor-name-execution-20261012/before.json); [resultados das configurações finais](../generated/editor-name-execution-20261012/results.json). Logs individuais por projeto/fase no mesmo diretório. [Spec r1](../specs/SPEC-NOTTGARD-EDITOR-NAME-20261012/spec.md).

Retorno: PLAN-NOTTGARD-PLATFORM-SPLIT-20261012 r1, CP-SPLIT-02, B-SPLIT-003/S-SPLIT-005, 5/5 etapas, per-plan APPROVED_LOCAL_R1, playtest humano pendente. Estados relidos no momento da reconciliação e somente o registro deste desvio foi atualizado. Suspensão encerrada sem substituir o plano original.
