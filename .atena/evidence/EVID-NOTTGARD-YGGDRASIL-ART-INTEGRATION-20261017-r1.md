---
id: EVID-NOTTGARD-YGGDRASIL-ART-INTEGRATION-20261017
revision: r1
status: TECHNICAL_VALIDATION_PASS_HUMAN_PLAYTEST_PENDING
---

# S-YART-004 — integração concluída

Autorização explícita “autorizado” para integração delimitada e testes isolados. Quatro PNGs aprovados admitidos com SHA idêntico, em dez caminhos de jogo/teste. [Manifesto de admissão](../generated/yggdrasil-art-20261017/s004-admission.json), [baseline](../generated/yggdrasil-art-20261017/s004-baseline.json), [portagem/aplicabilidade](../generated/yggdrasil-art-20261017/s004-portability.json). Alteração em ground limitada a chave e desvio do ramo Yggdrasil; removendo as inserções autorizadas o arquivo equivale ao baseline. Origem consultada somente para leitura, não contém este mapa/ramo QA. Nenhuma alteração de comportamento comum portada, sincronização ou teste runtime da origem alegado.

Compositor local usa definição autoritativa r3: sete discos, oito ligações, larguras individuais. Shader recebe dados sem alterar colisão. Piso opaco, detalhe discreto, lateral escura limitada a28px para baixo, fundo cósmico separado e contraste reduzido. UV isométrica aplicada uma vez; repetição espelhada evita salto de borda. Junções de direções diferentes suavizadas após primeira inspeção. Fontes nativas preservadas; importação1024×1024 sem mipmaps,16MiB RGBA8 por cópia, não memória total GPU. Alternativa geométrica r3 preservada.

## Verificações

[Onze testes](../generated/yggdrasil-art-20261017/s004-20261018-000748/tests-result.json) passaram: arte Yggdrasil e dez regressões previstas. Após ajuste visual do shader/filtro, nova importação/compilação e [auditoria renderizada final](../generated/yggdrasil-art-20261017/s004-20261018-001045/render-result.json) sem erro. Não repetidos testes funcionais independentes, pois geometria/regras permaneceram idênticas.

Máscara raster:9666 pontos, zero divergência com apoio e zero desenho fora de apoio/extrusão permitida; excluída apenas faixa de0,18 unidade para quantização subpixel. Capturas1280×720/1920×1080: entrada, centro, dois desvios, borda, alvo, combate40/recursos, tons de cinza e visão geral/fallback. Pisos Reino Abissal/Domwieck pixel a pixel iguais ao baseline. Revisão visual direta: material amadeirado, recortes sem halo claro evidente, borda distinguível, passagem sinalizada e fundo abaixo do contraste do piso. Madeira ainda tem padrão perceptível e o rótulo QA herdado “protótipo geométrico” permanece no HUD; ambos visíveis, sem alterar dados fora do escopo. Conforto/identidade final dependem do playtest humano, não certificados por testes.

A/B na mesma sessão, seed7504,dt1/60,40 inimigos,30frames aquecimento+600 medidos: versão geométrica mediana8,978ms/p95 10,349ms; arte mediana7,745ms/p95 8,693ms. CPU de simulação3,641→3,838ms na mediana (+5,4%), p95 4,768→4,682ms. Nenhuma regressão>10% ou nova pausa na amostra final. Máximos de loop12,546→10,073ms. Medidas incluem sincronização/escalonamento/render dispatch fora da tela, não GPU nem promessa de FPS.

Todas as sessões com APPDATA/LOCALAPPDATA/perfil sintéticos e probe sem autoload validado antes do jogo. Perfil sintético original e assinatura de save inalterados. Guardas de navegação/combate/catálogos/HQs e demais planos preservados. Sem geração nova, instalação, save real, commit ou publicação.

Plano r1:4/5 concluídas; S-YART-005 e aceite humano pendentes em CP-YART-005.
