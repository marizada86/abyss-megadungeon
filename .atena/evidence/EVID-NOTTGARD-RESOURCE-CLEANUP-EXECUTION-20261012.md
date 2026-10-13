---
id: EVID-NOTTGARD-RESOURCE-CLEANUP-EXECUTION-20261012
revision: r1
date: 2026-10-12
status: PASS
spec: SPEC-NOTTGARD-RESOURCE-CLEANUP-20261012
plan: PLAN-NOTTGARD-RESOURCE-CLEANUP-20261012
---

# Remoção de recursos inativos no PC e Web

Autorização explícita do dono em 2026-10-12: “Aprovado por plano. Pode remover os 30 recursos e seus metadados no PC e no Web, preservando os recursos ativos e validando os dois projetos.” DRAFT r1 autorizado para execução local, sem promoção canônica. CP-RESOURCE-CLEAN-01 aprovado; três etapas concluídas e CP-RESOURCE-CLEAN-02 validado.

Removidos 30 recursos e 30 .import em cada projeto, exclusivamente a lista de [audit.json](../generated/resource-cleanup-audit-20261012/audit.json). Grupos: 10 pisos antigos, 12 folhas do piloto reduzido de Kayron, seis WAV substituídos, AlegreyaSans-Bold.ttf e nevoa_textura_01.png. Portagem seletiva PC → Web registrada por caminhos e hashes idênticos; nenhuma sincronização automática. Diretórios vazios do piloto removidos. Origem histórica intacta.

Economia: 27731069 bytes por projeto, 55462138 bytes conjuntos, aproximadamente 52,89 MiB. Bytes lógicos de fontes/metadados; registros operacionais acrescentam espaço e cache/exports existentes não diminuíram por esta ação. Executáveis e pacotes existentes preservados; futuros exports refletem a limpeza.

Validação em clones isolados dos dois projetos com Godot 4.7.2.stable.official.ed1daf0bf: baseline e candidato import/parse PASS; test_terrain, test_audio, test_hero_strips, test_animation_assets e test_scripts_compile com zero falhas antes e depois. Logs conferidos, sem SCRIPT ERROR/ERROR nos resultados finais; não depender apenas do exit code.

Isolamento: perfil sintético explícito via --controller-profile e APPDATA/LOCALAPPDATA alterados somente no ambiente dos processos de teste. OS.get_user_data_dir() confirmado dentro dos diretórios sintéticos. Sondas iniciais sem autoload verificaram a configuração; não carregaram perfis reais. A propriedade custom_user_dir inicialmente ensaiada foi ignorada pela engine, e o isolamento foi confirmado pelo ambiente antes dos testes. Fundamentação técnica: [implementação Windows oficial](https://github.com/godotengine/godot/blob/4.7/platform/windows/os_windows.cpp), get_config_path/get_data_path/get_user_data_dir.

A primeira importação fria nos clones excedeu o limite de 240 segundos e foi interrompida; nenhum teste ou exclusão de original foi executado nessa tentativa. Logs attempt1 retidos. Para finalizar, o cache existente Web foi copiado somente aos clones após conferir hashes dos assets comuns e compatibilidade de engine. O Godot verificou os imports em ambos. A execução seguinte da baseline e os candidatos passaram. Não se alega PASS da tentativa interrompida. O cache dos originais não foi regenerado por esta validação.

Recuperação: backups delimitados de 60 arquivos por projeto, SHA-256 conferidos antes do ensaio. Precommit confirmou equivalência dos conteúdos testados e fontes originais. Exclusões em PowerShell com caminhos literais absolutos, limites dos dois projetos, hashes e reparse points verificados, sem remover recursivamente assets. Preflight inicial detectou Godot aberto e não removeu nada; limpeza somente retomada após confirmação do fechamento e preflight aprovado.

Integridade final: [after.json](../generated/resource-cleanup-execution-20261012/after.json), zero divergências dos arquivos preservados do manifesto; todos os alvos ausentes. Metadados .git automáticos do Codex foram excluídos da comparação após mudança concorrente em refs/codex/turn-diffs; não foram alterados pela limpeza. Licenças, fontes e texturas ativas, animações originais, código, testes, presets e builds existentes preservados. Nenhuma instalação, alteração de save real, nova arte, reexport, commit ou publicação.

Registros: [before.json](../generated/resource-cleanup-execution-20261012/before.json), [precommit.json](../generated/resource-cleanup-execution-20261012/precommit.json), [PC baseline](../generated/resource-cleanup-execution-20261012/pc-baseline-results.json), [PC candidato](../generated/resource-cleanup-execution-20261012/pc-candidate-results.json), [Web baseline](../generated/resource-cleanup-execution-20261012/web-baseline-results.json), [Web candidato](../generated/resource-cleanup-execution-20261012/web-candidate-results.json). Cópias equivalentes dos registros em ambos os projetos. Clones/perfis/backups temporários eliminados somente após PASS.

Retorno: PLAN-NOTTGARD-PLATFORM-SPLIT-20261012 r1, CP-SPLIT-02, B-SPLIT-003/S-SPLIT-005, 5/5 etapas, aprovação per-plan APPROVED_LOCAL_R1 e aceite humano pendente. Suspensão do desvio encerrada sem substituir o plano original ou alterar autorizações de outros trabalhos.

Nome do editor: config/name permanece Nottgard Survivors conforme contrato de compatibilidade de saves; título da janela do jogo é Nottgard - Abyss Megadungeon. Nenhuma mudança de nome técnico foi autorizada ou feita neste escopo.
