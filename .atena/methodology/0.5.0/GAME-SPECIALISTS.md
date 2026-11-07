# Biblioteca de especialistas para jogos

Biblioteca criada e pronta para adoção: dez skills e dez definições de agentes. São fontes portáveis, sem processos de agentes iniciados nem instalação global. Atena escolhe conforme a necessidade concreta; não exige uma equipe completa em todo projeto.

| Necessidade observada | Skill | Papel do agente | Entrega típica |
| --- | --- | --- | --- |
| Experiência, core loop, regras, balanceamento | [Design](templates/automation/game/skills/atena-game-design/SKILL.md) | [Designer](templates/automation/game/agents/game-designer.md) | Design delimitado e hipótese de teste |
| Input, estados, ações e regras implementadas | [Gameplay](templates/automation/game/skills/atena-game-gameplay/SKILL.md) | [Engenharia](templates/automation/game/agents/gameplay-engineer.md) | Comportamento e reprodução verificáveis |
| Rotas, encontros, câmera e espaços jogáveis | [Level/mundo](templates/automation/game/skills/atena-game-levels/SKILL.md) | [Level designer](templates/automation/game/agents/level-world-designer.md) | Layout/graybox e travessia de teste |
| Diálogos, lore, quests e continuidade | [Narrativa](templates/automation/game/skills/atena-game-narrative/SKILL.md) | [Conteúdo](templates/automation/game/agents/content-narrative-editor.md) | Conteúdo e continuidade rastreáveis |
| Menus, HUD, entendimento e barreiras de uso | [UI/acessibilidade](templates/automation/game/skills/atena-game-ui-accessibility/SKILL.md) | [UI](templates/automation/game/agents/ui-accessibility-designer.md) | Fluxo/interface e teste de uso |
| Sons, música, retorno de ações e VFX | [Áudio/feedback](templates/automation/game/skills/atena-game-audio-feedback/SKILL.md) | [Áudio](templates/automation/game/agents/audio-feedback-designer.md) | Mapa evento→feedback e revisão |
| Bugs, regressões, critérios e playtests | [QA](templates/automation/game/skills/atena-game-qa/SKILL.md) | [QA/playtests](templates/automation/game/agents/qa-playtest-planner.md) | Reprodução, checks e teste humano |
| Gargalos medidos ou build reproduzível | [Performance/entrega](templates/automation/game/skills/atena-game-performance-delivery/SKILL.md) | [Performance](templates/automation/game/agents/performance-delivery-engineer.md) | Baseline/candidato ou build identificado |
| Proporção, identidade, escala e encaixe 2D | [Sprite-fit](templates/automation/game/skills/atena-game-sprite-fit/SKILL.md) | [Artista técnico 2D](templates/automation/game/agents/technical-artist-2d.md) | Diagnóstico e candidato consistente |
| Contato, ritmo, loop e transições 2D | [Animação](templates/automation/game/skills/atena-game-sprite-animation-review/SKILL.md) | [QA visual 2D](templates/automation/game/agents/visual-qa-2d.md) | Revisão temporal e correção delimitada |

## Como Atena recomenda

Leia intenção, evidência, plano e recursos existentes. Relacione o problema a uma entrega do catálogo; explique motivo, insumos disponíveis/faltantes, resultado, caminhos, verificações e checkpoint. Para um problema simples, uma skill pode bastar. Acrescente outro papel somente quando houver uma dependência real ou necessidade de revisão. Skill define procedimento; agente define responsabilidade e handoff. Recomendação não inicia delegação.

Exemplos: identidade/proporção variável pede sprite-fit; movimento estranho pede animação e inspeção do controller quando evidência indicar; gameplay-engineer entra se houver defeito de playback/input; ausência de dados de desempenho pede baseline antes de otimização. Narrativa só se o jogo a usar. Para um jogo novo, Atena oferece descoberta e estrutura visão/design/escopo/bíblia antes de recomendar tecnologia. Contexto atual Godot + ChatGPT não é imposto aos outros jogos.

## Pré-requisitos visuais

Antes de produção, adaptação, animação ou revisão visual, Atena estrutura [bíblia visual](templates/game/visual-bible.md), identidade de personagem/entidade aplicável e contexto da cena. Use [prontidão visual](templates/game/visual-readiness.md): referências identificadas por estado/revisão, autoridade e zero BLOCKING relevantes. **Posição não é exigência.** Uma descrição textual da cena basta quando adequada; o cenário não precisa estar construído. Identidade N/A precisa de razão.

Preparar esses documentos textuais é trabalho prévio de Atena. Um especialista visual aguarda sua conclusão. Em papéis mistos, somente a parte visual depende dessa prontidão; tarefas não visuais continuam segundo seu escopo/checkpoint. DRAFT com uso experimental explicitamente autorizado continua DRAFT. CANON depende de aprovação explícita do conteúdo/revisão.

## Adoção em um projeto

1. Confira instruções realmente aplicáveis, `.atena/add.yaml`, estado ativo e guias locais. Detecte cópias antigas; não as substitua sem reconciliar regras/canon.
2. Atena recomenda o pacote útil e prepara escopo de adoção: arquivo da skill, suas referências internas e brief correspondente. Os pacotes são autossuficientes; não dependem de links para este repositório.
3. Para descoberta normal no Codex, copie o diretório da skill completo para `.agents/skills/<nome>/` do projeto, preservando fronteiras de escrita e aprovação. Se esse diretório estiver protegido, obtenha a autorização de ferramenta necessária. Instalação global é outra ação. Guarde o brief em uma localização permitida do projeto e referencie-o nas instruções locais.
4. Integre a orientação relevante de [templates/AGENTS.md](templates/AGENTS.md), catálogo e templates utilizados; ajuste referências locais. Verifique a descoberta da skill em uma nova sessão e declare o que foi de fato carregado. Uma cópia em `templates/` ou `.atena/` não ativa descoberta automática.

Agentes aqui são briefs de papel, independentes de framework. Configuração de execução paralela, ferramentas e modelos pertence a uma adoção delimitada quando necessária/autorizada. A atualização deste repositório já ativa recomendação nas suas instruções raiz; outros jogos e sessões antigas precisam adotar a orientação.

Documentação de descoberta: [skills no Codex](https://learn.chatgpt.com/docs/build-skills) e [instruções AGENTS](https://learn.chatgpt.com/docs/agent-configuration/agents-md).

## Reutilização de ferramentas existentes

Os especialistas usam capacidades disponíveis quando a tarefa justificar: geração/edição de imagens para candidatos, editor/timeline para autoria, engine existente para integração e captura. Para sprites gerados no ChatGPT, a referência mestra e as poses-chave controlam a direção, e cada candidato passa pela revisão de identidade e movimento.

As skills de Game Development Studio podem apoiar produção, admissão de pacotes/licenças, diagnóstico de render ou performance quando seus formatos/adapters e autorizações se aplicarem. Tripo/fluxos 3D servem a entregas 3D. Não encaminhar sprites 2D automaticamente a um fluxo 3D nem instalar ferramenta indisponível. Ausência de capacidade fica registrada com a alternativa viável ou ação pendente.

## Verificação e limites

[Catálogo estruturado](templates/automation/game/catalog.json), [validação de pacotes/readiness](tools/validate-game-specialists.cjs) e [validação de estado](tools/validate-add-state.cjs) permitem conferir arquivos e cenários. Não executam agentes, não promovem conteúdo e não provam fluidez, diversão ou comportamento de modelos. Use evidência real de projeto/asset e feedback humano para esses critérios.
