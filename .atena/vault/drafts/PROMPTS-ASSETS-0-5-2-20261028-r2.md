# Assets 0.5.2 — revisão de geração (2026-10-28, r2)

Status: DRAFT, revisão local solicitada pelo dono. Substitui as recomendações de geração do índice r1; o r1 e o pacote de 18/10 permanecem como histórico. Nenhuma geração, integração, aceite, commit ou publicação autorizados por esta revisão. Checkpoints dos demais planos preservados.

Base: HEAD `921b42e033af8da4e6a4aabb4fd53cdd9f5fd797`, árvore local, `ui/enemy_view.gd`, `ui/run.gd`, `core/battle.gd`, dados atuais e auditoria repetida em perfil sintético. Evidências em `.atena/generated/asset-review-0-5-2-20261028-r1/`.

## Resultado

Recomendação: **3 fontes PNG para acabamento**, mais **1 folha opcional**. Os objetos dos quebráveis ainda são propostas para decisão do dono. As três fontes resultam em cinco arquivos de runtime, pois o quadro intacto de cada quebrável deve ser extraído como sprite estático. Não gerar novamente assets já aceitos.

| Ordem | Fonte candidata | Formato normalizado | Condição e admissão futura |
|---|---|---|---|
| 1 | Ícone Corrosão das Docas | 128×128, RGBA | Lacuna confirmada; mapear `docas` → `docas_puddles` no HUD |
| 2 | Carga da legião quebrável — Reino Abissal | 2560×512, 5 células 512×512, RGBA | Aprovar objeto; extrair sprite intacto e registrar dados/consumer |
| 3 | Urna élfica quebrável — Domwieck | 2560×512, 5 células 512×512, RGBA | Aprovar objeto; extrair sprite intacto e registrar dados/consumer |
| Opcional | Discípulo Pestilento, conjuração | 1536×384, 6 células 256×384, RGBA | Aprovar gesto; registrar estado e disparar durante `cast_start` |

## Correções importantes do r1

- **Molydeus menor já é animado**: `source_id: molydeus_chefe`; usa `idle/move/attack/death/special`. Não produzir quatro folhas novas para corrigir uma ausência que o runtime já resolve.
- **As duas ilusões já são animadas**: `ilusao_de_sucubo` usa as folhas de `sucubo`; `ilusao_de_socothbenoth` usa `cultista_de_socothbenoth`. Ambas têm `idle/move/attack/death`, com alfa 0,45 aplicado pelo código às flags `ghost/illusory`. Dissolução própria seria melhoria opcional, sujeita a outro escopo, não lacuna de animação. Criar pastas próprias sem mudar `source_id` não altera o jogo.
- **Sacerdote já tem especiais**: `special_a` e `special_b`, oito células de 320×480 cada, mais `phase`. O prompt antigo de `special.png` 1536×384 não corresponde ao contrato dele. Para melhorar a leitura do Sussurro, primeiro avaliar reutilizar suas fontes existentes e ligar a animação ao cast.
- **Discípulo** realmente não tem `special`, mas hoje o estado também não consta de `EnemyView.ANIMATED`. `cast_start` em `ui/run.gd` só toca `world.warning`; copiar um PNG não produz aviso corporal de conjuração.
- **PV das ilusões**: no `immune_adds` atual de Malcanthet/Socothbenoth há override para 30/40 PV e limite de 12 s. A afirmação histórica de 1 PV não descreve essas invocações de chefe.
- **Ícones de Reino Abissal e Domwieck**: ambos têm objetivo de alcance com regra `kind: none`; não gerar ícones de perigo sem nova mecânica aprovada. A auditoria procura `*_rule.png`, enquanto o HUD usa nomes próprios como `docas_puddles`; conferir o mapeamento real.
- **Áudio**: Reino Abissal reutiliza música/ambiência de Pilares; Domwieck reutiliza Goranthis. Pilares possui caminhos próprios e arquivos presentes. Não classificá-lo como áudio ausente; eventual revisão artística exige escuta. Áudio fica fora deste pacote de imagens.
- **Quebráveis**: não basta `BREAKABLE_TYPES_BY_STAGE`. Novos IDs também precisam de entradas em `data/enemies.json`, sprites estáticos, registro em `EnemyView.DEATH_ONLY`, importação e cobertura do Códex/testes. A identidade existente do jogo e os saves devem ser preservados.

## Prompts revisados, para uso após aprovação

Regras comuns: pixel art sóbria no acabamento das referências locais; PNG com alfa real, sem xadrez gravado, texto, logotipo, moldura ou grade. Luz superior esquerda. Folhas horizontais com células iguais, câmera três-quartos isométrica 2:1, sem cortes nem invasão entre células. Manter identidade e proporções das referências. A candidata deve ficar isolada em `assets_incoming/`, sem sobrescrever runtime. Dimensões abaixo são de entrega normalizada; qualquer preparação deve preservar a composição e passar QA antes da admissão.

### A01 — Corrosão das Docas

Referências: `assets/icons/stages/shedaklah_puddles.png` e `assets/icons/stages/molor_bubbles.png`.

Prompt: Ícone de interface em pixel art, 128×128, fundo realmente transparente: uma poça corrosiva verde-acinzentada borbulhando sobre um pequeno fragmento de metal corroído, vista isométrica, silhueta clara em tamanho pequeno, contorno escuro nítido, composição centralizada e margens livres. Mesmo acabamento das referências anexadas. Sem texto, moldura ou cenário.

Destino futuro: `assets/icons/stages/docas_puddles.png`. A inclusão no HUD é uma alteração posterior de código.

### A02 — Carga da legião (objeto proposto, não aprovado)

Referências: `assets/enemies/caixote_quebravel.png`, `assets/animations/enemies/caixote_quebravel/death.png` e `assets/tiles/reino_abissal_roots_r1/surface.png` (apenas paleta/contexto, sem chão incorporado).

Prompt: Folha de animação em pixel art, 2560×512, cinco quadros de 512×512 lado a lado, fundo realmente transparente. Um caixote de suprimentos de madeira escura com ferragens sóbrias, sem símbolos ou inscrições, coerente com a referência e o ambiente de raízes do Reino Abissal. Quadro 1 completamente intacto e utilizável como sprite estático; quadros 2–4 quebrando em lascas e ferragens; quadro 5 pequeno monte de destroços. Mesmo enquadramento e escala visual da referência, apoio na linha y=432 em cada célula, sem deslocamento lateral do objeto, fragmentos dentro da célula, sem fogo, sangue, sombra projetada, texto ou chão desenhado.

Destinos futuros: `assets/animations/enemies/carga_da_legiao_quebravel/death.png` e `assets/enemies/carga_da_legiao_quebravel.png` (extração do primeiro quadro, sem segunda geração).

### A03 — Urna élfica (objeto proposto, não aprovado)

Referências: `assets/enemies/urna_funeraria_quebravel.png`, `assets/animations/enemies/urna_funeraria_quebravel/death.png` e `assets/tiles/domwieck_r1/architecture.png` (linguagem visual).

Prompt: Folha de animação em pixel art, 2560×512, cinco quadros de 512×512 lado a lado, fundo realmente transparente. Uma urna de pedra élfica fria com linhas elegantes discretas, coerente com a arquitetura de referência de Domwieck, sem inscrições ou símbolos novos. Quadro 1 totalmente intacto e utilizável como sprite estático; quadros 2–4 rachando e se fragmentando; quadro 5 pequeno monte de cacos. Mesmo enquadramento e escala visual da referência, apoio na linha y=432 em cada célula, sem deslocamento lateral do objeto, cacos dentro da célula, sem magia, fogo, sangue, sombra projetada, texto ou chão desenhado.

Destinos futuros: `assets/animations/enemies/urna_elfica_quebravel/death.png` e `assets/enemies/urna_elfica_quebravel.png` (extração do primeiro quadro).

### A04 — Discípulo: Grito na mente (opcional, gesto proposto)

Referências: `assets/animations/enemies/discipulo_pestilento/idle.png`, `assets/animations/enemies/discipulo_pestilento/attack.png` e `assets/animations/enemies/blogbog/special.png` (apenas estrutura da folha).

Prompt: Folha de animação em pixel art, 1536×384, seis quadros de 256×384 lado a lado, fundo realmente transparente. O Discípulo Pestilento exatamente como nas referências, mesma anatomia, rosto, vestes, acessórios e paleta. Preparação visível do Grito na mente: postura se contrai, cabeça se ergue e os braços existentes se abrem em gesto de concentração, culminando em tensão corporal legível; efeito psíquico muito contido, sem projétil, personagens, símbolos ou acessórios novos. Apoio dos pés na linha y=356 em todas as células, sem deslizar, sem sombra projetada, sem texto. Nenhum efeito atravessa os limites da célula.

Destino futuro: `assets/animations/enemies/discipulo_pestilento/special.png`. A admissão deve definir duração/sustentação para os 2,5 s de windup e cancelamento ao interromper ou matar o chefe; seis quadros a 12 fps duram só 0,5 s. A folha sozinha não resolve esse comportamento.

## Reconciliação das 19 entradas da auditoria

| Destino | Entradas | Motivo |
|---|---:|---|
| Falsos positivos ou ausência esperada | 5 | Três aliases animados, tentáculo estacionário, Sacerdote com especiais nomeadas |
| Raiz de Yggdrasil, fora do beta atual | 8 | Decais, crônica, história, regra, atmosfera, miniatura, ícone, quebrável |
| Sem regra de perigo que justifique ícone | 2 | Reino Abissal e Domwieck |
| Recomendações de produção | 3 | Docas e dois quebráveis |
| Melhoria opcional com integração adicional | 1 | Discípulo |

O resultado bruto não equivale a 19 imagens faltantes. O script antigo é uma auditoria por convenção de caminhos e ignora aliases e nomes alternativos. Ele foi preservado como histórico, sem alteração nesta revisão.

Validação: `test_animation_assets` terminou com **0 falhas**, usando APPDATA/LOCALAPPDATA/USERPROFILE sintéticos, sem carregar o save real. Quinze folhas dos aliases e especiais do Sacerdote tiveram dimensões e presença de `.import` conferidas; os seis caminhos de áudio citados existem. Evidências: `raw-gaps.json`, `verification.json`, `animation-assets.log`. O Godot emitiu a mensagem ambiental `Failed to read the root certificate store`; não houve falha no teste. Esta revisão não inclui novo playtest nem aceite visual.

## Retenções e próximo checkpoint

Não gerar ícones de bênção/arma/item, cartazes de chefe, miniaturas/decais já existentes, fontes aceitas da produção anterior ou assets de Yggdrasil. As ideias de selo “Interrompido!”, estados do chefe, cartão da morte e abertura do capítulo 2 continuam opcionais e sem aprovação de escopo.

Próximo checkpoint desta revisão: decisão do dono sobre a produção A01–A03, os dois objetos propostos e a inclusão ou adiamento de A04. Aceite das fontes anteriores preservado; nenhuma nova integração iniciada. Sem portagem automática para o repositório histórico.

Limitação de configuração: `C:/Users/gui-m/.codex/AGENTS.md` e `RTK.md`, citados pelo AGENTS local, não existem neste ambiente. Foram aplicados o AGENTS local, ADD e estado disponíveis.
