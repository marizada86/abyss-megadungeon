# HQ01 — integração PC/Web, 2026-10-15

Resultado: S-HQ-002 concluída. PLAN-NOTTGARD-HQ-REVIEW-20261015 r1 per-step, etapa 2/16; duas concluídas e 14 restantes. HQ01: oito imagens aprovadas individualmente, sequência integral e textos aprovados pelo dono. Suplemento hq01-integration-r1.md delimitou a mudança de quatro para oito antes de escrever runtime; não altera outros contratos ou libera a HQ02.

## Conteúdo e portagem

PC e Web receberam somente assets/hq/hq_n01_q1.png a q8.png, entrada hqn_01 de data/hqs.json, teste tests/test_hqs.gd e uma linha de ui/menu.gd para o contador do Diário refletir a quantidade real. Q2 apresenta Zynara e Helion em linhas separadas; demais textos conforme sequência aprovada. Leitor já suportava quantidade variável e não mudou. Total: 14 HQs, 60 imagens referenciadas, 13 HQs restantes sem alteração. IDs, título/gatilho de HQ01, outros gatilhos, conquistas e schema de saves preservados.

Snapshots antes da escrita em `.atena/generated/hq-review-20261015/integration/before-pc` e `before-web`; manifesto prepared.json e recibos pc-port-receipt.json/web-port-receipt.json registram hashes. Final-verification.json confirma oito PNGs iguais às versões aprovadas em ambos, metadados de importação presentes, textos corretos, outras 13 entradas idênticas e project.godot/leitor/catálogo lógico inalterados perante snapshot atual. A alteração já existente em project.godot foi preservada. Não se restaura baseline global. Estado de coordenação Web e recibo local atualizados sem substituir seu plano ativo.

## Validação executada

- Em ambos: sonda sem autoload com configurações de user_dir correspondentes confirmou caminho sob sessões sintéticas antes de importar/iniciar; APPDATA/LOCALAPPDATA por processo e --controller-profile sintético. Nenhum save real foi inspecionado, copiado ou carregado.
- Godot 4.7.2: importação PASS e test_hqs, test_profile, test_playtest PASS (zero falhas) nas duas versões. Teste de HQ exige oito na HQ01/quatro nas demais e percorre cada imagem, texto e contador sem conclusão prematura. Gatilhos, legado, conquistas, fechamento/Esc e bloco de notas continuam cobertos. Resultados em integration/pc-validation.json e web-validation.json, com logs nas sessões referidas.
- Smoke renderizado em 1280×720 e 1920×1080: 16 capturas por projeto, zero falhas de textura/contador/conclusão ou overflow de legenda; abertura/releitura pelo manipulador real do Diário, conclusão registrada só no perfil sintético e sem recompensa duplicada. Capturas de Q2/1280 e Q8/1920 inspecionadas visualmente, incluindo as falas em duas linhas. Resultados pc-smoke.json/web-smoke.json.
- O harness inicial precisou corrigir acesso ao autoload pelo SceneTree; primeira tentativa Web sem elevação não acessou o projeto. Primeira série de capturas foi encoberta pela ajuda inicial de perfil novo; harness passou a fechar apenas esse modal e verificar que não está aberto. Tentativas/logs preservados; resultados finais referenciam as séries desobstruídas, sem alteração de produção por esses ajustes.
- Exportação Web release com preset existente, templates já instalados copiados apenas para a pasta sintética de teste, sem instalar dependências ou sobrescrever build publicado. Browser local em origem localhost/porta inédita, identidade sintética “HQ01 QA sintético”. Primeira run abriu HQ01, avanço chegou a Quadro 8 de 8, conclusão voltou ao jogo, Diário exibiu 8 quadros, releitura abriu Quadro 1 de 8 e Esc voltou ao Diário. Nenhum erro observado no console. Evidência browser-validation.json e capturas browser-q2.jpg/browser-q8.jpg/browser-diary.jpg/browser-replay.jpg em integration/. Servidor ligado somente a 127.0.0.1 e encerrado após conferência; nenhum serviço remoto, credencial ou conta real usado.
- git diff --check PC PASS. Web não possui Git neste diretório, portanto este check é N/A; validação de arquivos/hash e testes executada normalmente. Backups, versões rejeitadas e arquivos de outros chats preservados. Sem commit, push, deploy ou publicação.

## Limites e próximo checkpoint

Aceite humano da ordem/textos/imagens foi dado na sequência integral. A conferência executável acima verifica funcionamento e apresentação; não declara avaliação humana de ritmo/conforto no leitor ou substitui o playtest pendente do plano de plataformas CP-SPLIT-02, que foi preservado.

Próxima etapa S-HQ-003, HQ02 “Seremos um só”. Entrada: roteiro CANON r2 de cinco quadros já aprovado, Willie acompanha a descida e fica no escuro do porão. Próxima saída: seleção/revisão das referências e imagens dessa HQ, com gates individuais antes da integração. Aprovação de início S-HQ-003 permanece pendente conforme modo per-step; nenhuma arte da HQ02 foi gerada nesta integração.
