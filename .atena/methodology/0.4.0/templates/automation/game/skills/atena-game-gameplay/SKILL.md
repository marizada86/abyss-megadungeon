---
name: atena-game-gameplay
description: Implementar ou diagnosticar input, controles, estados e regras de gameplay em um escopo ADD autorizado; usar quando há comportamento jogável a construir, separando defeitos de controle de defeitos de arte.
---

# Engenharia de gameplay

## Entradas e encaminhamento

Regra aprovada, cenário reproduzível, engine/versão existente, caminhos e critérios. Não reinicie descoberta de um jogo existente. Leia os registros locais pertinentes, estado e escopo/checkpoint. Recomende somente se a necessidade descrita existir.

Quando a entrega envolver produção/adaptação/animação/revisão visual, Atena prepara bíblia, identidade aplicável e cena antes dessa parte. Preparação textual e trabalho não visual podem prosseguir no escopo autorizado. Posição não é pré-requisito. Referências DRAFT exigem uso experimental autorizado, sem promoção implícita; CANON identifica conteúdo aprovado.

## Trabalho específico

Identifique a regra observável, o estado inicial e a sequência de input que reproduz o problema. Inspecione projeto/engine reais antes de propor arquitetura; preserve escolhas existentes.

Separe simulação física, apresentação e entrada quando essa separação resolver o defeito. Verifique ordem de eventos, duração do input, estados concorrentes e repetição de animação. Não reestruture todo o jogo para corrigir uma ação.

Valide o cenário e regressões relevantes. Em Godot, use a instalação/versão indicada pelo projeto; não suponha APIs nem presença de editor. Se runtime estiver indisponível, reporte inspeção estática e teste pendente. Mudança de regra material exige aprovação; integração visual exige readiness.

## Entrega e continuidade

Entregue mudança mínima de comportamento e evidência reproduzível. Identifique originais/candidatos, revisões, caminhos e evidências reais. Atena integra e informa plano/etapa/total/restantes/atividade/checkpoint; ao concluir prepare objetivo, insumos, entrega e checks da próxima etapa. Não ultrapasse checkpoint pendente. Respeite permissões existentes; a skill não autoriza dependências, alteração de canon, publicação nem delegação. Ausência de ferramenta retorna uma lacuna/default fundamentado, sem instalação ou substituição silenciosa.
