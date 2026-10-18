---
id: EVID-NOTTGARD-ROOT-ART-INTEGRATION-20261017-r1
step: S-RART-004
status: COMPLETE_TECHNICAL_PASS_OWNER_VISUAL_PLAYTEST_PENDING
---

# Arte das raízes — integração PC r1

Autorização explícita “autorizado” após pergunta sobre aplicar o conjunto aprovado e executar testes isolados, preservando bordas, caminhos e espaço de combate. Preflight persistiu autorização e baseline recente dos oito caminhos delimitados; nove fontes de navegação/campanha/cenas/dados guardadas por hash. Estado de outros planos preservado, sem delegação.

Quatro PNGs copiados exatamente dos originais aceitos para `assets/tiles/reino_abissal_roots_r1/`; hashes idênticos ao aceite do conjunto. Metadados de importação limitam dimensão máxima a 1024, sem mipmaps, com correção de borda alfa. Texturas carregadas: 1024×1024 superfície/junções/profundidade, 1024×512 laterais; 14 MiB brutos RGBA8 por cópia, não medição do custo total da GPU. Originais aprovados e fontes HQ17 Q3/Q4 preservados, sem nova geração/edição de imagem ou referência externa.

Implementação em exatamente oito caminhos de jogo/teste: quatro PNGs, `data/root_art.json`, `ui/ground.gd`, `ui/shaders/abyss_roots.gdshader`, `tests/test_root_art.gd`. Metadados `.import`/UID são derivados. Shader recebe os nove discos, doze ligações e largura seis da definição autoritativa existente; converte coordenadas pela projeção 64×32, recorta topo por suporte e limita laterais/profundidade à projeção vertical abaixo dele. Topos sempre prevalecem sobre essas camadas. Junções misturam material com passagens; regiões fora das cápsulas usam textura de junção, evitando esticar pixels da borda do atlas. Sem alfa das imagens como colisão. Só ramo Reino Abissal recebe a arte; `use_root_art=false` mantém desenho provisório para fallback/QA. Falta de manifesto/recurso conhecido volta ao fallback.

Geometria, movimentação, props, ondas, objetivos, HQs e transições não foram editados. Identidade de personagem N/A para essa integração de terreno. Atores e recursos presentes nas capturas são fixtures de QA, não novos recursos admitidos.

## Validação isolada

APPDATA/LOCALAPPDATA e perfis sintéticos em cada sessão nova, com sonda sem autoload confirmando diretório de usuário antes de importar/executar. Nenhum save pessoal foi aberto ou copiado. Godot 4.7.2, Windows x86_64, OpenGL Compatibility na GTX 1650.

- `validation-20261017-193337-027`: sete conjuntos PASS, sem erro de script/shader — `test_root_art`, `test_root_navigation`, `test_map_objectives`, `test_level_design`, `test_terrain`, `test_chapter_flow`, `test_scripts_compile`.
- `validation-20261017-193939-719`: `test_root_art` PASS após proteção adicional de fallback para manifesto/shader ausente. Asserções verificam geometria dos uniforms contra a definição, dimensões importadas, teto bruto de 14 MiB, metadados, ordenação dos recortes e hashes dos PNGs admitidos.
- `validation-20261017-193929-368`: 29 capturas de Reino Abissal/Domwieck em 1280×720 e 1920×1080 — chegada, borda, ritual, junções oeste/leste e combate com 50 criaturas; quatro vistas adicionais em cinza e uma visão geral. Zero falhas, perfil sintético de origem preservado. Inspeção visual local conferiu bordas, densidade de fibras, halo aparente, topo preenchido, áreas de vazio e contraste com herói/inimigos/ouro/XP. Capturas em cinza feitas por shader diagnóstico, sem alterar PNGs fonte. Quatro warnings de tamanho/anchors do overlay diagnóstico foram registrados nessa execução; o helper foi corrigido, sem alteração no jogo e sem repetir capturas já inspecionadas.
- `validation-20261017-193740-356`: auditoria gráfica — 8157 probes do topo, zero divergências com o suporte; pontos a menos de 0,15 unidade da fronteira excluídos para quantização subpixel. Zero probes de arte fora do suporte ou da extrusão vertical limitada. Toggle de arte produziu pixels idênticos no chão de Domwieck. Máscara/arte isoladas salvas na sessão.
- Mesma auditoria: comparação A/B com seed 7204, 50 inimigos, dt 1/60, 30 quadros de aquecimento e 600 medidos por modo. Desenho provisório: mediana/p95 do loop 20,808/23,064 ms; arte integrada: 12,873/15,130 ms. Simulação: medianas 8,935/8,960 ms; p95 10,866/10,800 ms. Não houve aumento sustentado acima do limiar de investigação de 10% nesse cenário. Loop gráfico fora da tela, vsync desligado, inclui simulação, sincronização da UI, agendamento e envio de render; não é timestamp de GPU, benchmark geral ou garantia de FPS de gameplay.

Uma correção visual intermediária foi necessária: a primeira aplicação esticava pixels nos ombros das junções. O shader foi corrigido e as capturas repetidas. A auditoria gráfica e as capturas finais já usam a versão corrigida. Nenhuma correção exigiu alterar superfície, colisão ou ampliar os oito caminhos.

## Encerramento e próximo checkpoint

S-RART-004 concluída: **4/5 etapas**. Evidências anteriores de gameplay reutilizadas quando não afetadas; nenhuma repetição adicional sem mudança/falha relevante. Auditoria de hashes e referências em `.atena/generated/root-art-20261017/s004-final-validation.json`.

Próxima etapa S-RART-005/CP-RART-005: autorização própria para abrir o mapa pelo launcher isolado e avaliar continuidade com as HQs, clareza de bordas, aparência dos relevos, visibilidade de ameaças/recursos e conforto durante combate. Entrada: build integrada atual, arte r1 e navegação r2 aceita. Saída: feedback humano e aceite final ou correção delimitada; ainda não recebido. Não promover avaliação técnica a aprovação estética/conforto do dono.

Portagem registrada: somente PC conforme plano aprovado; Web não portada nem testada, sem alegação de paridade. Sem dependência, instalação, permissão global, commit, push, publicação ou alteração de plano compartilhado de campanha/HQs.
