---
id: SPEC-NOTTGARD-YGGDRASIL-ART-KIT-20261017
revision: r1
status: S_YART_003_COMPLETE_AWAITING_CP_YART_004
origin: planned
implementation_preceded_spec: false
approval_mode: per-step
---

# S-YART-003 — conjunto final proposto

Etapa3/5;2/5 concluídas, três restantes. [Amostras A/B aprovadas](../../vault/canon/ASSET-APPROVAL-YGGDRASIL-ART-SAMPLES-20261017-r1.md) e [HQ20 Q1 v03/Q3 v01/Q4 v01](../../generated/yggdrasil-art-20261017/approved-reference-audit-r2.json) são as únicas referências propostas, usadas conforme o componente. Hashes revalidados antes de gerar. Sem HQ17, retratos, kit de outro ambiente ou fonte nova. Identidade de personagens N/A: nenhum personagem ou criatura será desenhado. Identidade ambiental é Yggdrasil cósmica e sua madeira resistente, conforme canon e referências aceitas.

Produzir com imagegen nativo até quatro PNGs versionados em .atena/generated/yggdrasil-art-20261017/kit-r1/, sem admissão no runtime:

| Arquivo | Conteúdo e contrato visual |
| --- | --- |
| ground.png | Casca/fibras de madeira robusta em superfície opaca, vista ortográfica de material sem perspectiva cinematográfica já aplicada; textura contínua de baixo ruído, preparada para UV do topo |
| edge.png | Faixa/face lateral escura de casca maciça, alfa real, sem chão adicional; volume e profundidade derivados da mesma raiz, sem vãos de podridão |
| detail.png | Detalhes de nós/fibras/junções em atlas com alfa e margens, sem tronco-obstáculo ou ramo que finja área transitável fora da máscara |
| trunk.png | Estudo final separado de tronco/ramificações monumentais no universo, fundo opaco de contraste controlado; não um panorama que substitui toda a geometria jogável |

Passagem roxa será composta visualmente a partir de formas/cores aceitas e sinal existente na integração; não exige quinto PNG nem autoriza portal funcional. Não gravar texto, UI, personagens, objetos bloqueantes, planos nomeados/contados ou runas definitivas. Conservar madeira castanha, grão longitudinal e nós; simplificar detalhe conforme escala do jogo.

Quatro fontes geradas/normalizadas, cada importação até1024×1024; até16MiB de RGBA8 por cópia para as quatro sem mipmaps, não memória total/GPU. Nativos do gerador preservados. Transparência de edge/detail solicitada explicitamente ao imagegen; nada de checkerboard gravado. Recortes/pivôs/UV e atlas definidos após inspeção e registrados em manifesto; não prometer cobertura/empacotamento exatos antes da produção. Necessidade de quinto PNG ou maior resolução exige revisão de escopo antes de executar.

Validação de produção: formato/dimensões/hash, alfa real e margens, orientação dos veios, separação topo/lateral/fundo, continuidade com A/B e HQs, ausência de perspectiva dupla/halos/texto, leitura reduzida e repetição. Imagens não certificam colisão e legibilidade com40 inimigos; checks Godot/máscara/A-B pertencem à S-YART-004. Preservar fallback e geometria r3. Se a imagem não servir, manter versão anterior e limitar correção ao componente.

Saída: até quatro PNGs, manifesto de proveniência/refs/prompts/dimensões/hash/uso e revisão do conjunto para aceite. Zero BLOCKING para apresentar produção; adequação técnica fina RESOLVABLE na inspeção/integração. CP-YART-003 aguarda autorização. O aceite das amostras não inicia geração do kit, não edita assets/runtime e não autoriza integração, Godot, nova dependência ou publicação.


## Autorização recebida

Usuário autorizou explicitamente os quatro componentes e manifesto, ainda sem aplicação. S-YART-003 em andamento, etapa3/5;2/5 concluídas. Nativos preservados sem edição fora do imagegen; limite de importação1024 proposto por configuração futura do motor, como nos conjuntos anteriores, sem alegar que as fontes nativas já estejam reduzidas. Alfa real verificado em edge/detail; perspectiva e UV definidos para integração posterior.


## Entrega r1

[Revisão do conjunto](../../generated/yggdrasil-art-20261017/kit-r1/review.md) e [evidência](../../evidence/EVID-NOTTGARD-YGGDRASIL-ART-KIT-20261017-r1.md). Quatro componentes selecionados, detalhes v02 e demais v01. Validação de arquivo concluída; uso em mapa condicionado aos checks de integração e aceite pendente. Menções anteriores a autorizações pendentes são históricas.


## Aceite do conjunto — 3/5

Kit r1 aprovado: ground/edge/trunk v01 e detail v02. [Aceite registrado](../../evidence/EVID-NOTTGARD-YGGDRASIL-ART-KIT-ACCEPTANCE-20261017-r1.md). S-YART-003 concluída; duas etapas restantes. [Integração delimitada](integration-r1.md) aguarda CP-YART-004. Restrições históricas sobre ausência de referências/amostras não representam o estado atual.
