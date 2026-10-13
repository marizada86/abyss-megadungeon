---
id: SPEC-NOTTGARD-RESOURCE-CLEANUP-20261012
revision: r1
status: DRAFT_AUTHORIZED_LOCAL_R1
origin: guided-add
implementation_preceded_spec: false
---

# Remoção de recursos sem uso

Escopo concreto: remover exclusivamente os 30 recursos e seus 30 metadados .import identificados em `manifest` de [audit.json](../../generated/resource-cleanup-audit-20261012/audit.json), tanto no projeto PC `D:/dev/nottgard/games/launcher-pc/nottgard-abyss-megadungeon` quanto no projeto Web `D:/dev/nottgard/games/launcher-web/nottgard-abyss-megadungeon`. Não alterar origem `D:/dev/nottgard/games/godot/nottgard-survivors`. Os campos path/metadata.path e SHA-256 fixam a lista; expansão de escopo ou hash divergente exige nova análise.

Recursos: 10 pisos antigos listados na primeira auditoria, 12 PNG em assets/animations/heroes_screen/kayron, 6 WAV antigos (progress.levelup_01/02, ui.click_01/02, ui.confirm_01/02), AlegreyaSans-Bold.ttf e nevoa_textura_01.png. Preservar todas as licenças, generation_report.json, recursos ativos, código, testes e builds existentes. Pode remover apenas diretórios vazios deixados por esses arquivos; nenhum delete recursivo de assets autorizado.

Aceitação: 60 arquivos ausentes por projeto; todos os demais recursos, fontes, configurações e executáveis existentes preservados por hash; sem referência quebrada causada pela remoção; importar e passar checks pertinentes nos dois alvos; portagem com hashes e evidência em ambos; estados concorrentes e CP-SPLIT-02 preservados. Economia nominal conjunta 55462138 bytes (52,89 MiB), antes de registros operacionais. Não prometer redução de builds já exportados ou de caches novos.

Impactos: piloto de Kayron rejeitado deixa de estar disponível localmente para overrides experimentais futuros. Fluxos atuais usam originais e não mudam. Recuperação: antes de excluir, criar backup delimitado dos 60 arquivos de cada destino em diretório temporário isolado e registrar hashes; não depender exclusivamente da origem, apesar da correspondência atual. Reter esse backup fora dos projetos até validar ambos; remoção do backup após PASS integra o checkpoint de execução aprovado. Em falha, restaurar somente arquivos removidos e comprovar hashes; nunca sobrescrever mudanças concorrentes.

Gaps: nenhum BLOCKING para apresentar a proposta. Gates de execução: aprovação explícita dos arquivos e dos dois destinos; acesso de escrita Web concedido pelo ambiente; processos fechados; preflight de hashes e baseline pertinente. RESOLVABLE: verificar engine existente, baseline/testes nos clones isolados e falhas conhecidas antes de exclusão. DEFERRED: deduplicação de recursos usados, outras fontes/imagens fora do manifesto, reexport de produtos e playtest humano. Nenhuma instalação, novo conteúdo canônico, publicação, Git ou save real.

PLAN-NOTTGARD-RESOURCE-CLEANUP-20261012 r1; modo proposto per-plan conforme limpeza anterior, checkpoint CP-RESOURCE-CLEAN-01 PENDING_APPROVAL. Não executável antes da aprovação. Não reutilizar autorização do cache/builds. Caso o dono prefira por lote ou etapa, configurar isso antes de execução.

Plano de voo:

1. B-RESOURCE-001/S-RESOURCE-001: reler estados PC/Web, registrar suspensão e retorno, conferir hashes/limites/processos, preparar backup e clones temporários isolados; baseline de testes pertinentes sem carregar save real.
2. B-RESOURCE-001/S-RESOURCE-002: ensaiar ausência do manifesto em clones, importar e validar; depois de PASS, excluir arquivos literais autorizados no PC e portar seletivamente as mesmas exclusões no Web. Registrar portagem, sem sincronização automática.
3. B-RESOURCE-002/S-RESOURCE-003: conferir hashes preservados/ausências e contrato ADD, registrar evidências e retorno em ambos; remover temporários somente após PASS. Falha não encerrar como sucesso e manter recuperação disponível.

Validação planejada nos clones sintéticos de PC/Web, com D:/Godot/godot.exe existente: import/parse headless e tests/test_terrain.gd, test_audio.gd, test_hero_strips.gd, test_animation_assets.gd, test_scripts_compile.gd. Usar perfil sintético por --controller-profile e isolar também user:// via configuração somente do clone para impedir save real. Falhas de baseline devem ser distinguidas de regressões; não alegar PASS por exit code sem conferir logs/falhas. Verificação estática de manifesto e referências após remoção; comparar fontes/recursos preservados por SHA-256. Não recriar .godot no projeto PC apenas para estes checks; testes em clones evitam repor o cache removido. Sem playtest novo ou reexport neste escopo.

Evidência: [auditoria](../../evidence/EVID-NOTTGARD-RESOURCE-CLEANUP-AUDIT-20261012.md). Identidade/bible N/A para auditoria de dependências: nenhuma produção ou julgamento visual. Responsável: Atena neste chat, sem delegação. Reconciliação permitida: portagem de fatos operacionais e registro de exclusões; sem promoção canônica. Retorno: plano de separação r1, CP-SPLIT-02, B-SPLIT-003/S-SPLIT-005, per-plan aprovado, 5/5 etapas, aceite humano pendente.

Autorização registrada em 2026-10-12: “Aprovado por plano. Pode remover os 30 recursos e seus metadados no PC e no Web, preservando os recursos ativos e validando os dois projetos.” CP-RESOURCE-CLEAN-01 APPROVED_LOCAL_R1.
