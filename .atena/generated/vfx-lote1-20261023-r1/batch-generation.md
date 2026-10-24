# VFX Lote 1 — entrega completa das fontes, 2026-10-23

DRAFT. Ferramenta: image_gen.imagegen (built-in), referência local ref-existing-vfx.png em todas as chamadas. Quatorze novas folhas nesta execução, completando os 17 IDs F01–F17. Dezoito PNGs ao todo, incluindo F03 v01 retida. Candidatas correntes: F03 v02; demais IDs v01.

## Autorização e checkpoints
Pedido explícito: "aprovado, faça o lote completo para aprovar tudo de uma vez". Aprovação do piloto F03 v02, F06 v01 e F13 v01 registrada por ID/revisão/hash em pilot-acceptance.json. Essa aprovação libera a geração das outras 14. Aceite visual do lote completo permanece pendente, sem antecipá-lo.

Checkpoint S2/FULL_BATCH_GENERATED_REVIEW_PENDING. Galeria batch-review.html reúne as 17 fontes e a versão retida em histórico, com visão comparativa, ampliação, prompts executados e hashes.

## Proveniência dos prompts
Prompts originais por ID em prompts/Fxx_nome_prompt.txt. F03 v02 usa a correção integral já registrada. F04 e F05 tiveram esclarecimentos mínimos: violet em lugar da menção contraditória a magenta no efeito aditivo; F05 explicitamente só chamas sem cera/velas. Os textos integrais executados estão em prompts/F04_executed_v01_prompt.txt e prompts/F05_executed_v01_prompt.txt. Todos os outros novos prompts foram usados integralmente sem alterações.

F02: corpo bege neutro sobre magenta, sem chamas. F10: projétil e impacto neutros para tinta pelo código, como aprovado no plano. Candidatas preservadas no diretório de trabalho do projeto; originais de imagegen mantidos no perfil.

## Conferência e limites
Verificação automatizada: 17 IDs, 17 candidatas presentes, dimensões 1536x1024, hashes SHA-256 e tamanhos registrados em batch-source-audit.json; 17 prompts base e os prompts executados adicionais presentes; links da galeria conferidos.

Inspeção visual das 14 novas saídas: fontes com 6 quadros ou 4 voo + 4 impacto, fundos e famílias de cor correspondentes, sem textos/grades desenhadas. F05 contém só chamas. A aprovação é da arte das fontes, não da grade final. As saídas não obedecem com precisão às células e margens: em especial F04 tem centros horizontais desiguais e efeitos amplos; F05 e picos de arcos/faíscas ultrapassam a faixa central nominal de 256 px; F02 ocupa quase toda a largura da célula. A preparação deve usar limites por quadro, preservar partículas/âncoras, normalizar escala e margem, e conferir loop/legibilidade. Não recortar cegamente uma faixa central ou a grade nominal. Se não for possível separar os quadros sem perdas, usar a reserva de até três candidatas por peça para correção objetiva, sem reabrir aceite do estilo já aprovado.

Nenhum atlas final, alfa final, margem validada ou funcionamento/desempenho em jogo é afirmado. Não foram executados testes de jogo pois esta entrega só gera fontes de arte e evidências. Sem carregar save, instalar dependências, acessar recursos externos de referência, alterar runtime, integrar, exportar, promover CANON, fazer commit ou push nesta execução. Lote 2 e demais planos preservados.
