---
id: EVID-NOTTGARD-ROOT-ART-KIT-20261017-r1
step: S-RART-003
status: FOUR_PNGS_DELIVERED_OWNER_REVIEW_PENDING
---

# Produção do conjunto de raízes — r1

Autorização do dono: “autorizado”, em resposta à pergunta explícita sobre S-RART-003, produção de superfície, junções, laterais e profundidade seguindo a amostra v02 aceita, com integração em aprovação separada. Estado persistido antes da geração; duas de cinco etapas previamente encerradas, terceira em entrega/revisão.

Entradas: direção CANON r1, amostra v02 aceita e somente imagens HQ17 Q3 v02/Q4 v01 como referências de geração. Hashes da amostra e das duas referências conferidos no preflight `.atena/generated/root-art-20261017/s003-before.json`. Identidade de personagem N/A: trabalho de terreno sem personagens. Nenhuma outra referência ou dado do projeto foi fornecido ao gerador. Sem subagentes/especialistas delegados, instalação ou CLI/API alternativa.

Quatro chamadas independentes ao imagegen built-in, uma por arquivo, com prompts exatos em `.atena/generated/root-art-20261017/kit-prompts-r1.json`. PNGs copiados sem alteração dos resultados originais para a pasta local versionada `kit-r1`; fonte original preservada. [Conjunto para revisão](../generated/root-art-20261017/kit-r1/review.md) e [manifesto/recibos](../generated/root-art-20261017/kit-r1/manifest.json) contêm caminhos, dimensões, hashes, fontes e regiões propostas do atlas. Nenhum PNG sobrescrito ou admitido em assets.

Inspeção visual: casca/carvão e marrom frio, fibras grossas entrelaçadas, contrastes vinho discretos, ausência de personagens, UI, paisagem cinematográfica ou novos objetos. Superfície e junções em vista material plana; laterais em faixas e profundidade em fibras verticais sem piso. Relêvo pintado e densidade precisam ser observados no jogo; a produção isolada não certifica leitura de combate, geometria exata ou conforto.

Verificação sem editar imagens: leitura do cabeçalho PNG, descompressão dos pixels e aplicação dos filtros apenas em memória para medir alfa. Superfície/junções: 1254×1254, alfa mínimo/máximo 255, 100% opacas. Laterais: 1774×887, 222115 pixels totalmente transparentes e 1351368 parcialmente transparentes. Profundidade: 1254×1254, 1067189 totalmente transparentes e 504657 parcialmente transparentes. As duas peças têm alfa real; não se trata de xadrez pintado como fundo. Existem pixels parcialmente transparentes claros (38/144 respectivamente), portanto halo deve ser inspecionado no fundo final; não afirmar borda final certificada só por existir alfa.

O gerador entregou dimensões nativas diferentes das dimensões de destino propostas no plano. Originais preservados, sem resize por outra ferramenta. Custo bruto RGBA8 nativo: aproximadamente 24 MiB por cópia; destino 1024 via importação Godot é proposta para S-RART-004, com qualidade e memória a verificar antes da admissão. Não aumentar silenciosamente o orçamento do jogo. As regiões de faixas têm limites em pixels arredondados devido à altura 887; conferir o alfa/UV de cada franja antes de integrar, com recortes do manifesto tratados como propostas.

Sete caminhos do jogo/dados/render em `s003-before.json` mantêm os hashes de antes da produção. Testes de gameplay anteriores reutilizados; nenhum Godot executado, pois não houve integração. Recortes, emendas/repetição, adequação de importação, posicionamento abaixo da superfície, contraste com combate e custo de render permanecem checks da S-RART-004. Não declarar recursos tecnicamente admitidos ou aceitos pelo usuário nesta entrega.

Checkpoint CP-RART-003-ACCEPTANCE: aguarda aceite do conjunto. S-RART-004 não autorizada. Estado de mapas, navegação, campanha e HQs preservado. Sem saves pessoais, dependências, portagem Web, commit, push ou publicação.
