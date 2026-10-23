# Transferência do processo de assets — r1

Autorização explícita do dono em 2026-10-22: “todo o processo será transferido para o projeto de abyss-megadungeon que é o nome do jogo agora”. Classificação PLAN_CHANGE_REQUEST aprovada para transferência do processo existente; modo per-plan preservado. Esta autorização não resolve a aprovação pendente do escopo de integração.

1. S-T01 — inventariar processo e estado atual do destino; preservar planos/trabalhos recentes do PC.
2. S-T02 — copiar fontes, prompts, metadados, aceite, derivados, scripts, galerias e proposta; conferir cada SHA-256 sem sobrescrever divergências.
3. S-T03 — tornar registros operacionais portáveis, incorporar somente as três seções desta frente ao estado do destino e registrar decisão do dono sobre projeto/nome. Validar auditoria e links no destino.
4. S-T04 — vincular este chat ao projeto abyss-megadungeon; deixar ponte histórica no repositório anterior e preparar retomada pelo estado do destino.

Destino autoritativo: F:/dev/abyss-megadungeon. Nome de continuidade: Abyss Megadungeon. Preservar IDs técnicos, saves, lore e decisões canônicas anteriores. Conteúdo produzido continua DRAFT; 125 fontes selecionadas aceitas, quatro versões substituídas excluídas; 158 derivados preparados. Não portar o PLAN-103 inteiro nem copiar outros processos do repositório antigo. Não executar runtime, commit, push, merge, build ou publicação como parte desta transferência.

Recuperação: a origem permanece preservada. Copiar somente novos arquivos ou idênticos; conflito interrompe antes de sobrescrever. Antes de editar estado/add.yaml/AGENTS no destino, guardar snapshot e conferir novamente o conteúdo atual. Acrescentar somente as seções da frente de assets, sem substituir o restante de plan.yaml. Hash de cada fonte PNG deve permanecer igual ao recibo de aceite.

Contrato de retomada: produção concluída (8/8), preparação concluída (5/5), integração S-I01/INTEGRATION_SCOPE_APPROVAL_PENDING (0/6). A transferência não aprova novos usos de N nem promove imagens a CANON. O catálogo do Codex já contém o projeto abyss-megadungeon em F:/dev/abyss-megadungeon.

Resultado: S-T01–S-T04 concluídas para a transferência dos arquivos e da continuidade operacional. 587 arquivos copiados com SHA-256; duas referências internas resolvidas para as fontes transferidas; auditoria no destino confirmou 158 saídas, zero retenções e zero fontes alteradas; links das duas galerias válidos. O restante de plan.yaml do destino foi preservado exatamente. Só a decisão explícita de continuidade/nome foi registrada como CANON; imagens continuam DRAFT.

Limite da interface do Codex: a tentativa de mover este chat ao projeto retornou confirmation_required, exigindo adicionar F:/dev/nottgard-survivor às origens do projeto destino. Essa alteração adicional não foi confirmada; o vínculo deste chat continua na worktree histórica. Os arquivos, os registros e a retomada estão integralmente no destino, e futuras operações desta frente usam esse diretório explicitamente. Não afirmar que o vínculo do chat ou seu cwd foi alterado.
