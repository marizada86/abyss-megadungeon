---
id: EVID-NOTTGARD-DOMWIECK-ART-INTEGRATION-20261017
revision: r1
status: COMPLETE_TECHNICAL_PASS_OWNER_PLAYTEST_PENDING
---

# S-DART-004 — integração visual de Domwieck

Autorização explícita: “autorizado”, em resposta à integração do conjunto r1, ajuste de recortes/escala/brilho e testes isolados preservando rotas e combate. Etapa concluída tecnicamente: **4/5 etapas do plano r1**, uma restante. Sem aceite visual humano inferido.

## Aplicação e invariantes

Seis PNGs admitidos em assets/tiles/domwieck_r1 com bytes SHA-256 idênticos aos [arquivos aprovados](../vault/canon/ASSET-APPROVAL-DOMWIECK-ART-KIT-R1-20261017-r1.md). Importação 1024×1024, sem mipmaps, até 24 MiB RGBA8 por cópia. Fontes nativas 1254×1254 preservadas; importação é derivada.

Onze caminhos de jogo/teste alterados dentro do teto 12: seis imagens, data/domwieck_art.json, ui/ground.gd (flag e ramo Domwieck), ui/domwieck_art.gd, ui/stages/domwieck.tscn e tests/test_domwieck_art.gd. Nenhum shader novo necessário. Lista e hashes no [registro final](../generated/domwieck-art-20261017/s004-final-validation.json).

Piso e flores usam materiais overhead projetados uma única vez por Iso; pequenos agrupamentos de flores substituem a primeira aplicação excessivamente ampliada. Calçamento com variação reduzida e filtro linear em runtime. Seis edifícios e 28 árvores mantêm âncoras/distribuição, sem corpos físicos. Sprites com recortes/pivôs próprios no Sorted existente; transparência a 32% quando prédio/copa/estrela encobre a vizinhança projetada do herói. Três incêndios estáticos localizados, aura de baixa opacidade, feixe reto e arco da Tarn ativos. Variante de jardim com entulho excluída dos UVs usados. Demais ornamentos e motivos azuis mais fortes não precisam ser usados por existirem no atlas.

Visual provisório recuperável por Ground.use_domwieck_art=false ou ausência de recursos; outros mapas não instanciam a composição. Fonte de ui/ground.gd, removida apenas a adição Domwieck, é idêntica ao baseline. Dados de mapas/props, terreno/navegação, Battle, Hero, Enemy, ChapterFlow e arte das raízes guardados por hash e inalterados. Nenhuma nova colisão, rota, objetivo, save ou direito de acesso.

## Verificações

Oito testes aprovados: test_domwieck_art, test_root_art, test_root_navigation, test_map_objectives, test_level_design, test_terrain, test_chapter_flow e test_scripts_compile. Resultado inicial em .atena/generated/domwieck-art-20261017/validation-20261017-214203-354/results.json; teste de arte rerodado após ajuste de flores/transparência em .atena/generated/domwieck-art-20261017/validation-20261017-214549-181/results.json. O teste verifica identidade de PNGs/importação, orçamento/UV, exclusão do entulho, fallback, isolamento por mapa, ordenação e transparência/reversão perto do herói.

45 capturas de Domwieck/Reino Abissal em 1280×720 e 1920×1080, mais 5 da conferência dirigida de ameaças. Chegada, praça, ruas laterais, alvo/jardim, atrás de prédio, árvores próximas, combate de 54 inimigos e recursos, tons de cinza e overview. Amostras representativas inspecionadas visualmente. As capturas de ameaças usam projéteis e aviso de área sintéticos dos renderizadores existentes, congelados para avaliar contraste; não representam uma partida humana. Sem erros de script/render nos registros finais. [Santuário](../generated/domwieck-art-20261017/validation-20261017-214735-278/domwieck-1280x720-target.png), [combate e ameaças](../generated/domwieck-art-20261017/validation-20261017-215109-488/domwieck-1280x720-combat_garden.png).

Regressão de Reino Abissal: pixels do chão com arte aprovados comparados em SubViewport com o script anterior e atual, idênticos. Capturas do mapa completo também disponíveis.

A/B isolado: seed 7204, dt=1/60, 54 inimigos, 30 frames de aquecimento e 600 medidos por configuração, 1280×720, OpenGL offscreen sem vsync. Loop: provisório mediana 26.216 ms/p95 29.318 ms; integrado 9.031 ms/p95 9.731 ms. Simulação: medianas 1.567/1.57 ms. Sem aumento acima do limiar de 10%. Medida inclui simulação, UI, agendamento e despacho de render; não é timestamp de GPU nem certificação de FPS. [Auditoria](../generated/domwieck-art-20261017/validation-20261017-214806-462/smoke-result.json).

Toda execução Godot precedida de sonda sem autoload, confirmando user_dir dentro de APPDATA/LOCALAPPDATA sintéticos, além de perfil separado. Comparação do perfil fonte e assinatura sintética preservadas nos runs de captura; save real não carregado. Portagem registrada: PC implementado/testado; Web permanece fora do escopo aprovado.

Diagnósticos preservados: primeira rodada revelou índices JSON float tratados como inteiros na seleção de incêndios e teste de exclusão; corrigidos com conversão explícita. Helper de regressão teve erro de indentação corrigido antes do run final. Capturas intermediárias com animações de morte residuais foram substituídas por limpeza direta dos nós diagnósticos. Nenhum desses registros foi tratado como PASS final.

## Próximo checkpoint

CP-DART-005: autorizar abertura do playtest isolado de Domwieck. Entradas: build técnica validada e arte r1; saída: avaliação humana de continuidade com HQs, escala de Ailalore, clareza de ruas/alvo/jardim, transparência e conforto de combate. Não realizado nesta etapa. Estado dos demais planos preservado.
