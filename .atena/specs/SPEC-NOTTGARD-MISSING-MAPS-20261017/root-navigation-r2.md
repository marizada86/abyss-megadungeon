---
id: SPEC-NOTTGARD-ROOT-NAVIGATION-20261017
revision: r2
status: COMPLETE_R2_TECHNICAL_AND_OWNER_PLAYTEST_APPROVED
origin: planned
implementation_preceded_spec: false
classification: PLAN_CHANGE_REQUEST
approval_mode: per-step
---

# Reino Abissal — malha de raízes e navegação

Revisão documental originalmente autorizada por “vamos lá”, depois da decisão de borda travada e da proposta de detalhar caminhos/conexões antes de implementar. R2 aceita e S-ROOT-002 autorizada explicitamente em 2026-10-17; implementação e verificação concluídas conforme reconciliação abaixo. Integração responsável: Atena, sem delegação. O plano de mapas r1 foi preservado e o preflight conciliou a integração ChapterFlow já presente antes de código.

## Autoridade, escopo e não objetivos

[Decisão CANON de borda](../../vault/canon/DEC-NOTTGARD-ROOT-EDGE-BLOCKED-20261017-r1.md): não se pode sair das raízes nem cair. [Material CANON](../../vault/canon/DEC-ABYSS-ROOT-GROUND-20261016-r1.md): apoio feito de raízes. [Feedback](../../evidence/EVID-NOTTGARD-MAP-PLAYTEST-FEEDBACK-20261017-r1.md) aceita protótipos e propõe distinção terrestre/voador. A aprovação do protótipo anterior não aceita automaticamente esta geometria nova.

Recorte: somente Reino Abissal. Substituir piso caminhável contínuo por união de raízes/plataformas conectadas dentro dos mesmos 60×60. Preservar objetivo 360 s + presença 3 s/raio 2, ondas, cap 50 e multiplicadores aceitos. Sem queda, dano por borda, salto, voo concedido a heróis, chefes novos, novos inimigos, alteração de ataques ou integração de HQs por efeito desta revisão. Domwieck e demais mapas permanecem com seus contratos. Arte final continua pendente; nova silhueta geométrica proposta é protótipo, sem geração de bitmap.

## Planta concreta aprovada — r2

Coordenadas de chão; raios/larguras em unidades de chão, não pixels. Toda a região resultante é uma única rede, com caminhos livres desde o início e sem gate dinâmico.

| Nó | Centro | Raio de área aberta | Função |
| --- | --- | --- | --- |
| E | (30,45) | 6 | Chegada/área de manobra sem props |
| C | (30,30) | 6 | Junção central, sem tronco bloqueando o eixo |
| G | (30,15) | 4 | Acesso ao ritual, alvo fixo de raio 2 |
| W / L | (15,30) / (45,30) | 6 cada | Acampamentos/arenas laterais |
| NO / NL | (15,15) / (45,15) | 4 cada | Conexões superiores |
| SO / SL | (15,45) / (45,45) | 4 cada | Conexões inferiores |

Raízes de ligação, todas com **largura 6**: E–C, C–G, W–C, C–L; circuito externo E–SO–W–NO–G–NL–L–SL–E. Cada ligação é uma faixa com extremidades arredondadas, unida aos discos dos nós. São quatro voltas alternativas em torno do centro; nenhum ramo de combate termina obrigatoriamente num beco sem saída. O trajeto central E→C→G tem comprimento 30 antes de desvios; alternativas oeste/leste têm comprimento 60. Esses números descrevem a planta, não duração esperada da partida.

Diagrama lógico, não desenho em escala:

```text
NO ======== G ======== NL
||          ||         ||
W ========= C ========= L
||          ||         ||
SO ======== E ======== SL
```

Fora da união de discos/faixas é vazio visual e não caminhável. Não existem vãos decorativos sobre um piso invisível. As raízes se alargam suavemente nas junções; o desenho precisa mostrar a mesma silhueta usada na colisão. Madeira/casca com relevos de baixo contraste; borda clara o suficiente para distinguir apoio de profundidade, sem luz que se confunda com aviso de ataque. Identidade de personagem N/A para esta produção de terreno; referências de contexto/raízes continuam HQ17 Q3 v02 e decisão CANON já inspecionadas. Não introduzir entidade cosmológica nova no fundo.

Props: transferir cargas periféricas da arena anterior para bolsões de raiz que de fato suportem seus footprints. Não preservar posições antigas sobre o vazio. Entrada raio 6, alvo raio 4 e arenas laterais raio 6 permanecem livres de colisões; quaisquer adornos ali são planos e não bloqueantes. Conservar pelo menos seis unidades livres após considerar colisões nas ligações. Se não houver posição que cumpra essas reservas, omitir o prop no protótipo; não estreitar a raiz para manter decoração. O piso e as junções bastam para o primeiro teste; tendas/arte final continuam fora desta revisão.

## Regra geométrica e movimentos

Uma definição de superfície deve alimentar render, consulta de apoio, geração da grade e admissão de spawns/objetos. O teste considera o **footprint inteiro** da entidade: seu raio não pode invadir vazio. Checar só o centro, como TerrainLayout.is_blocked faz hoje, é insuficiente na beirada.

Movimento terrestre normal, controle/mouse, empurrão, avanço/esquiva e investida devem percorrer o segmento com amostras/subpassos limitados (proposta: até 0,2 unidade por subpasso, ou menor conforme raio), com verificação de apoio completo em cada trecho. Um passo grande não pode saltar por cima do vazio e terminar noutra raiz. Ao bloquear, parar na última posição válida; deslizar pela borda apenas se o caminho resultante também for válido. Sem teleporte de volta, dano ou animação de queda. A borda trava a posição, não o input nem o combate.

Recuperação de QA/carregamento inválido: validar a chegada antes de iniciar simulação. Usar E como fallback apenas na inicialização sintética, registrando o erro de posição; se E não for válida, falhar o carregamento. Nunca salvar entidade no vazio ou corrigir silenciosamente a posição do herói a cada frame. Não há migração de save real/run nesta mudança.

## Terrestres, voadores e perseguição

Proposta técnica: mobilidade explícita `ground`/`air`, com padrão terrestre. Voo dispensa somente a exigência de raiz sob o corpo neste mapa; respeita limites externos da arena e conserva as demais colisões/regras existentes. Não implica atravessar prédios, invulnerabilidade, altitude dinâmica ou nova classe de ataque. Não deduzir voo de nome, sprite ou tipo `keep/chase`.

O acervo dirigido consultado não declara `flying/fly/voador` como contrato de mobilidade. Os cinco IDs das ondas atuais (`cultista_adaga`, `notivago`, `cultista_arqueiro`, `cultista_cajado`, `criatura_corrompida`) entram **como terrestres nesta revisão proposta**, sem inventar capacidade aérea. Lista inicial explícita de voadores: vazia. Suporte aéreo será verificado por entidade sintética de teste, sem adicionar inimigo à campanha. Admitir um ID real como voador requer ficha/referência e aceite próprio, inclusive para criaturas de outros mapas. O nome Esporo Voador encontrado no catálogo não autoriza transplantá-lo para esta incursão.

Inimigos terrestres precisam seguir a rede em vez de perseguir o herói em linha reta contra a beirada. Proposta: grade de navegação/fluxo compartilhada por mapa e footprint, derivada da superfície estática e props, com vizinhança sem cortar diagonais pelos vãos. Recalcular caminho/campo quando o herói mudar de célula relevante, reutilizando dados entre inimigos; não buscar uma rota completa nova por inimigo a cada frame. Meta: todos os nós e alvo alcançáveis com os raios efetivos; verificar caminho por entidade maior. Voadores conservam perseguição existente quando ela é segura nos limites externos.

## Spawns, ataques e recursos

- Spawns terrestres: somente em raiz conectada à área do herói, sem sobrepor props/bordas e preservando distância/área livre de chegada. Se a amostragem em anel falhar, buscar candidatos válidos da grade na faixa de distância; se não houver, adiar/omitir aquele spawn sem compensação explosiva de dívida. Eliminar fallback atual que pode devolver posição não validada. Nunca gerar terrestre no vazio para depois teletransportá-lo.
- Invocações/divisões/reforços: mesmo filtro de superfície e footprint; sem invasão de borda por callback secundário. Falta de lugar impede aquela criação.
- Ouro/XP/itens/interações: ponto acessível na rede e sem sobrepor borda. Loot de um futuro voador morto no vazio deve usar ponto de raiz válido mais próximo, com desempate determinístico, antes de criar o pickup; não perder a recompensa no vazio nem pagá-la automaticamente ao herói. Isso não transforma limpeza de objetivo em abate/loot.
- Projéteis e alcance de ataques conservam regras atuais: um vão não vira parede invisível para tiros. Não criar linha de visão, colisão vertical ou imunidade de borda por efeito da navegação.
- Objetivo/ritual continua em G, acessível desde o início. Limpeza, idempotência, pausa e conclusão sem chefe permanecem intactas.

## Impactos, orçamento e recuperação

Fatos inspecionados: Hero.can_stand verifica limites, centro do terreno e props; Hero.step move por eixos incluindo push. Battle._enemy_move reutiliza essa consulta e contorno local; avanço de herói tem candidato próprio; _ring_pos possui fallback. Logo bloquear somente o herói ou só trocar a imagem não cumpre a proposta.

Orçamento proposto de implementação: **10 arquivos de jogo/teste**: data/root_navigation.json (novo: rede, reservas e mobilidade por mapa), data/prototype_stages.json (referência da malha), data/level_design.json (props admitidos), core/terrain_layout.gd (superfície/grade), core/hero.gd (footprint/movimento), core/enemy.gd (mobilidade explícita), core/battle.gd (navegação, deslocamentos, spawns/loot), ui/ground.gd (silhueta derivada), tests/test_map_objectives.gd (aceitação geométrica revisada), tests/test_root_navigation.gd (novo: casos comportamentais). Comparar código atual no preflight, pois integração de campanha em outro chat já introduziu ChapterFlow. Não substituir arquivos por snapshots antigos. Necessidade de outros consumidores exige revisão delimitada antes de editá-los.

Antes de código: reler estado compartilhado, registrar cursor/autorizações reais e baseline/hashes/cópias dos próprios caminhos. Preservar campanha em integração, acervo HQ, Domwieck, saves/IDs e permissões. Recuperar somente edições desta mudança com comparação posterior. Sem project.godot, instalação/dependência, Web, commits ou publicação. Importação do Godot via launcher isolado existente continua permitida para atualizar índice derivado, sem alteração global.

## Gaps e plano por etapa

| Gap | Estado / tratamento |
| --- | --- |
| Queda vs borda bloqueada | RESOLVED por decisão explícita CANON: nunca cair |
| Rede/conexões, footprint e deslocamentos | RESOLVABLE com proposta concreta acima; provas executáveis somente na implementação |
| Quais criaturas voam | Resolvido para recorte proposto por lista aérea vazia e cinco ondas terrestres; classificação real adicional DEFERRED e sujeita a aceite |
| Compatibilidade com código concorrente | RESOLVABLE no preflight obrigatório, sem restaurar cópias antigas |
| Arte final e avaliação de sensação | DEFERRED; não bloqueiam protótipo geométrico |

Zero lacunas de design sem proposta no checkpoint original. Geometria/mobilidade técnica r2 e S-ROOT-002 foram posteriormente aprovadas explicitamente; [aceite CANON](../../vault/canon/DEC-NOTTGARD-ROOT-NAVIGATION-R2-20261017-r1.md). A autorização não abrange S-ROOT-003 antecipadamente.

1. **S-ROOT-001 — revisão documental:** esta entrega, 1/3 concluída. Entrada: feedback, decisão e consumidores; saída: r2 delimitada, sem código.
2. **S-ROOT-002 — implementar e verificar tecnicamente:** CP-ROOT-002 aprovado, execução concluída. Entrada: r2 aceita e preflight; saída: malha sem saída pelas bordas, terrestres navegando e suporte aéreo sintético verificado, dentro dos dez caminhos. Nenhuma troca de motor/dependência.
3. **S-ROOT-003 — playtest e conciliação:** autorizada, realizada e aprovada pelo dono em 2026-10-17; apresentar build/objetivos/procedimento e critérios, colher avaliação do dono, corrigir limites aprovados e retornar ao cursor compartilhado atualizado. Não declarar campanha/arte final concluídas.

Checks futuros: conectividade de todos os nós e raiz→objetivo; folgas e discos; trajetos completos de corpo pequeno/grande em todos os sentidos; amostras junto à borda, alto dt, diagonais, empurrões/avanços/investidas; nenhum cruzamento por vazio/teleporte/queda; terrestre contorna vãos e voador sintético cruza sem sair da arena; spawns/invocações/divisões/loot válidos; nenhum softlock ou dívida de ondas; objetivo/limpeza continuam corretos; regressão dirigida de Domwieck e mapas tradicionais. Executar somente com sonda e perfis sintéticos. Capturas distinguem raiz de vazio em 1280×720/1920×1080; desempenho avaliado se a nova navegação mostrar custo relevante, sem declarar melhoria sem medir. Playtest humano verifica conforto, caminhos, pressão/congestionamento e clareza das bordas; não está realizado.

Reconciliação em 2026-10-17: r1 de mapas continua histórica; r2 foi aceita e implementada somente na superfície/navegação de Reino Abissal, preservando parâmetros/saídas narrativas da integração PC atual. Quatro cargas admitidas em bolsões externos, duas omitidas. Erosão por primitiva é conservadora em junções; nenhum footprint entra no vazio. Oito conjuntos de testes passaram e 13 capturas gráficas foram produzidas em perfis isolados; [evidência técnica](../../evidence/EVID-NOTTGARD-ROOT-NAVIGATION-20261017-r1.md). S-ROOT-003/CP-ROOT-003 concluída após aceite humano explícito das bordas, dos caminhos e do espaço para combater, sem arte final ou portagem Web.

## Encerramento — aceite humano

Em 2026-10-17, o dono informou que testou e aprovou bordas, caminhos e espaço para combater e autorizou concluir a S-ROOT-003. Revisão r2 encerrada em **3/3 etapas**; [resultado do playtest](../../evidence/EVID-NOTTGARD-ROOT-PLAYTEST-ACCEPTANCE-20261017-r1.md). As referências anteriores a avaliação futura descrevem o plano original, agora cumprido nesse recorte. Arte final, IDs aéreos e Web permanecem diferidos. Evidência técnica reutilizada sem novos testes ou mudanças de código. Nenhum cursor de campanha/HQs foi avançado por este encerramento.
