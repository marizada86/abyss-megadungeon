---
id: SPEC-NOTTGARD-EDITOR-NAME-20261012
revision: r1
status: DRAFT_AUTHORIZED_LOCAL_R1
origin: guided-add
implementation_preceded_spec: false
---

# Nome no editor com diretório legado de saves

Pedido explícito em 2026-10-12: “Atena, agora ajuste o nome no editor do Godot para Nottgard - Abyss Megadungeon no PC e no Web, preservando a compatibilidade dos saves.” O conteúdo desejado e os dois destinos estão definidos; CP-EDITOR-NAME-01 apresenta a implementação concreta antes de executar, conforme Guided ADD.

PLAN_CHANGE_REQUEST delimitado perante o contrato de separação/nome técnico anterior, sem substituir o plano original ou encerrar o playtest humano. A limpeza foi concluída. Modo proposto per-plan seguindo a rota anterior; aprovação de limpeza não autoriza esta mudança. Novo checkpoint CP-EDITOR-NAME-01 PENDING_APPROVAL.

## Escopo e implementação

Nos dois projetos PC e Web, substituir exclusivamente application/config/name e acrescentar três configurações de persistência em project.godot:

```ini
config/name="Nottgard - Abyss Megadungeon"
config/use_custom_user_dir=true
config/custom_user_dir_name="Godot/app_userdata/Nottgard Survivors"
config/custom_user_dir_name.web="godot/app_userdata/Nottgard Survivors"
```

Windows usa `%APPDATA%/Godot/app_userdata/Nottgard Survivors` antes e depois. A execução Web usa `/userfs/godot/app_userdata/Nottgard Survivors` antes e depois, com override .web preservando a capitalização da implementação dessa plataforma. O editor nativo do projeto Web também conserva o diretório Windows antigo. Não resolver isso usando custom_user_dir_name só com o nome antigo, pois faltariam Godot/app_userdata e o caminho mudaria.

PC: D:/dev/nottgard/games/launcher-pc/nottgard-abyss-megadungeon. Web: D:/dev/nottgard/games/launcher-web/nottgard-abyss-megadungeon. Origem histórica intocada.

Atualizar somente o comentário obsoleto em core/game.gd sobre nome/diretório, a documentação operacional pertinente e os registros ADD. Conteúdo e comportamento de saves, nomes de arquivos, schema, IDs, gameId/statisticsId, rotas, pacotes, executáveis e builds existentes permanecem intactos. Nenhum save real será lido/copied/movido; não migrar pastas. Sem export/publicação/commit/instalação.

Adendo canônico após CP-EDITOR-NAME-01: DEC-NOTTGARD-EDITOR-NAME-20261012-r1, limitado aos dois destinos, dizendo que o nome do editor passa a ser o oficial e que a configuração explícita de user:// substitui somente a antiga restrição de conservar config/name. DEC-NOTTGARD-NAME-20261011-r1 e documentos históricos não serão reescritos. O nome oficial e aliases/IDs definidos em CANON r1 permanecem. A aprovação deste checkpoint autoriza o conteúdo concreto do adendo, execução e validação separadas.

## Aceitação e impactos

- Os dois project.godot declaram o nome solicitado e o editor lê esse nome ao reabrir o projeto.
- A engine existente resolve o mesmo user:// Windows antes/depois, com caminho exatamente igual.
- Override Web seleciona o caminho relativo legado em minúsculas; algoritmo da plataforma comprovado pela fonte oficial. Não alegar teste de navegador sem execução real.
- Fixture sintética escrita na configuração anterior continua acessível com o novo nome, sem migração. Testar os dois destinos e seleção da feature Web.
- Fonte/runtime/dados/IDs e builds preservados; portagem seletiva das mesmas configurações e do comentário, evidência nos dois projetos.
- Contratos/referências ADD válidos; retorno a PLAN-NOTTGARD-PLATFORM-SPLIT-20261012 r1 CP-SPLIT-02, 5/5 etapas, aprovação per-plan e aceite humano pendente preservados.

Impacto: o nome exibido pelo editor muda na próxima abertura; builds exportados existentes não são renomeados ou reconstruídos. Recuperação: registrar bytes/hashes dos project.godot e comentário antes; restauração delimitada dessas linhas, sem tocar saves ou mudanças concorrentes. A engine não deve ser aberta em um projeto real durante a validação de saves; usar sondas sem autoload e ambientes sintéticos, evitando caches grandes no workspace principal.

## Gaps e plano de voo

Gaps BLOCKING técnicos: zero. Checkpoint de autorização: pendente. RESOLVED: propriedades corretas da engine, override .web e diretório Windows legado, seis sondas isoladas PASS. DEFERRED: export e execução de pacote em navegador; fora do escopo de ajuste no editor. Sem mudança de lore/bible/identidade visual; inspeção artística N/A.

PLAN-NOTTGARD-EDITOR-NAME-20261012 r1, modo proposto per-plan, três etapas:

1. B-EDITOR-NAME-001/S-EDITOR-NAME-001: após aprovação, reler estados e hashes, registrar suspensão/retorno e autorização em ambos; backups delimitados das configurações/comentário e adendo canônico autorizado.
2. B-EDITOR-NAME-001/S-EDITOR-NAME-002: aplicar configurações, comentário e documentação pertinente no PC e portar as mesmas mudanças no Web; não alterar origem, saves ou builds.
3. B-EDITOR-NAME-002/S-EDITOR-NAME-003: sondas de configuração atual, fixture sintética e override Web; conferência do delta e dos IDs; registros e retorno em ambos, removendo temporários próprios após PASS.

Responsável: Atena neste chat, sem delegação. Checkpoint final CP-EDITOR-NAME-02 confirma verificação técnica local; o playtest humano da separação não é aceito por esses checks.

## Evidência

[Preparação](../../evidence/EVID-NOTTGARD-EDITOR-NAME-PREPARATION-20261012.md), [resultados](../../generated/editor-name-preparation-20261012/results.json), [candidato PC](../../generated/editor-name-preparation-20261012/pc-project.godot.candidate), [candidato Web](../../generated/editor-name-preparation-20261012/web-project.godot.candidate). Não houve implementação anterior à spec nos projetos originais.

CP-EDITOR-NAME-01 aprovado pelo dono em 2026-10-12: “aprovado, por plano”. Autorização por plano cobre o escopo concreto r1 e o adendo canônico nele descrito; nenhuma promoção de conteúdo adicional.
