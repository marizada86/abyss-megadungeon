---
id: SPEC-NOTTGARD-YGGDRASIL-ART-INTEGRATION-20261017
revision: r1
status: S_YART_004_COMPLETE_AWAITING_CP_YART_005
origin: planned
implementation_preceded_spec: false
approval_mode: per-step
---

# S-YART-004 — integração proposta

Plano r1, etapa 4/5; 3 concluídas, 2 restantes. Entrada: protótipo funcional r3 aceito e [kit r1 aprovado](../../vault/canon/ASSET-APPROVAL-YGGDRASIL-ART-KIT-20261017-r1.md). Responsável: Atena, sem delegação. Identidade ambiental: madeira resistente e árvore cósmica ligando todos os planos; personagens N/A, nenhum personagem produzido. Bíblia operacional e testes seguem o [plano r1](plan-r1.md), reconciliado pelos aceites posteriores.

## Escopo concreto e impactos

Aplicar quatro PNGs selecionados, conservando fontes originais: assets/tiles/yggdrasil_r1/ground.png, edge.png, detail.png (v02) e trunk.png; data/yggdrasil_art.json; ui/ground.gd somente ramo Yggdrasil; ui/yggdrasil_art.gd; ui/stages/raiz_yggdrasil.tscn; ui/shaders/yggdrasil_root_art.gdshader; tests/test_yggdrasil_art.gd. Teto de 10 caminhos de jogo/teste, metadados derivados .import/.uid à parte. Não deslocar código para contornar teto.

Importar com max_size1024, sem mipmaps, até16MiB RGBA8 por cópia das quatro. UV projetada uma vez em isométrica2:1; veios longitudinais, recortes laterais individuais, detalhe em quadrantes com margem verificada. Controlar contraste do topo e fundo, aplicar detalhes esparsos. Fundo distante sem piso falso; bordas respeitam máscara de apoio; passagem roxa apenas visual usando sinal existente, sem novo portal funcional.

Preservar geometria r3, larguras, colisão/bordas travadas, caminhos, controle, combate, objetivos, campanha, demais mapas e fallback geométrico. Sem alterações em Hero/Battle/navegação/catálogos/HQs; sem dependências, publicação ou nova geração visual. Recuperação limitada aos próprios arquivos com baseline atualizado e conferência de concorrência. Alterações comuns exigem registro de portagem e verificações em ambos conforme política local; não escrever na origem externa sem autorização específica se isso se tornar necessário.

## Validação e saída

Antes de qualquer Godot: perfil sintético novo APPDATA/LOCALAPPDATA e probe sem autoload, jamais save real. Executar test_yggdrasil_art e dez regressões previstas: yggdrasil_navigation, yggdrasil_map, root_navigation, root_art, domwieck_art, map_objectives, level_design, terrain, chapter_flow e scripts_compile. Conferir importação, atlas, alfa, fallback, máscara versus apoio e invariantes funcionais.

Capturas1280×720/1920×1080 de entrada, centro, desvios, bordas, alvo, fundo e combate40; overview/tons de cinza; regressão visual Reino Abissal/Domwieck. A/B geométrico/final seed7504,dt1/60,40 inimigos,30frames aquecimento+600 medidos: investigar aumento sustentado>10% mediana/p95/pausas, sem alegar FPS GPU. Evidência e manifesto de admissão local delimitam resultado; playtest humano pertence à S-YART-005.

Zero BLOCKING documental para autorização. Recortes, emendas, halos, contraste e custo são RESOLVABLE com inspeção/testes, não certificados pelo aceite visual. Se teto, arquitetura ou correção dos PNGs exigirem expansão, apresentar revisão antes. Campanha capítulo2, demais mapas, áudio e publicação DEFERRED. CP-YART-004 aguarda autorização expressa de integração e testes isolados; não abrir playtest nesta etapa.


Autorização recebida: “autorizado”. Etapa4/5 em execução; baseline local por caminho registrado antes das mudanças.


## Integração validada — 4/5

S-YART-004 concluída nos10 caminhos previstos. [Evidência](../../evidence/EVID-NOTTGARD-YGGDRASIL-ART-INTEGRATION-20261017-r1.md),11 testes aprovados e auditoria final sem divergência de máscara. [Playtest visual S-YART-005](playtest-r1.md) aguarda autorização própria e avaliação humana. Uma etapa restante.
