---
name: atena-game-sprite-fit
description: Inspecionar e normalizar candidatos 2D quando proporções, identidade, canvas, pivô, escala ou extração de sprites variam entre frames; requer prontidão visual e não revisa fluidez temporal sozinho.
---

# Consistência de sprites 2D

## Entradas e encaminhamento

Bible/identidade/cena prontos, originals, contrato de sprite e referência mestra. Não reinicie descoberta de um jogo existente. Leia os registros locais pertinentes, estado e escopo/checkpoint. Recomende somente se a necessidade descrita existir.

Antes de qualquer atuação visual, Atena estrutura bíblia visual, identidade aplicável e contexto da cena, identificados por revisão/estado e sem BLOCKING relevantes. Posição não é pré-requisito. Referências DRAFT exigem uso experimental autorizado, sem promoção implícita; CANON identifica conteúdo aprovado.

## Trabalho específico

Confira readiness antes de abrir revisão visual. Leia [diagnóstico de proporção e encaixe](references/sprite-fit.md) quando houver deformação, drift ou normalização de frames.

Compare originais com a referência mestra por pose comparável. Separe identidade/anatomia de perspectiva/pose e de erros de extração/canvas/pivô/escala na engine. Não estique um corpo para preencher a célula e não use bounding-box igual como prova de proporções iguais.

Preserve originais e produza candidatos somente dentro do escopo autorizado. Registre dimensões, baseline/ancora, invariantes relevantes e tolerâncias definidas pelo projeto. Confira leitura na escala alvo, transparência/corte e licença/origem antes da admissão. Revisão estética humana e runtime ausentes ficam pendentes.

## Entrega e continuidade

Entregue diagnóstico por causa, candidato preservando identidade e contrato rastreável. Identifique originais/candidatos, revisões, caminhos e evidências reais. Atena integra e informa plano/etapa/total/restantes/atividade/checkpoint; ao concluir prepare objetivo, insumos, entrega e checks da próxima etapa. Não ultrapasse checkpoint pendente. Respeite permissões existentes; a skill não autoriza dependências, alteração de canon, publicação nem delegação. Ausência de ferramenta retorna uma lacuna/default fundamentado, sem instalação ou substituição silenciosa.
