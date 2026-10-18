# HQ01 Q2 — fala de Helion na metade direita

Aceite humano posterior à implementação e conferência: dono respondeu “aprovado” em 2026-10-15 à apresentação do Quadro 2 corrigido, com Zynara à esquerda e Helion à direita. Correção encerrada; não equivale à autorização de iniciar S-HQ-003/HQ02.

Pedido direto do dono: “coloque o texto de helion no quadrado da direita”. IN_PLAN, correção da entrega S-HQ-002 do plano r1 per-step; estado geral permanece 2/16 concluídas e S-HQ-003 pendente. Escopo descrito antes da escrita em hq01-q2-dialogue-layout-r1.md, sem gaps BLOCKING.

Aplicado no PC e Web: Q2 possui text de Zynara e campo opcional text_right de Helion. Leitor divide horizontalmente a faixa inferior apenas quando esse campo existe; Label direito com estilo idêntico e margem central, legenda esquerda com largura reduzida. Quadros sem fala direita ocultam/limpam a coluna e retomam largura original. Não há condição por ID/nome no leitor. PNGs, texto literal das duas falas, ordem, demais HQs, gatilhos e saves preservados.

Arquivos limitados: data/hqs.json, ui/hq_screen.gd, ui/hq_screen.tscn e tests/test_hqs.gd. Snapshot e recibos PC/Web em `.atena/generated/hq-review-20261015/q2-layout/`. Verificação semântica reconstrói texto combinado anterior e exige igualdade do restante do catálogo; hashes das oito artes conferidos sem mudanças. Manifesto da sequência recebeu somente metadado captionLayout da decisão do dono.

Validação: importação e test_hqs PASS nos dois projetos, com perfis/pastas sintéticos e sonda de isolamento sem autoload. Teste verifica a fala correta em cada metade e restauração da legenda única no próximo quadro. Capturas dos oito quadros em 1280×720 e 1920×1080, sem overflow, sobreposição ou resíduo da fala direita. PC concluiu também replay sintético. A primeira execução de smoke Web produziu as capturas mas não concluiu o resultado do replay; conferência posterior foi delimitada ao layout (16 capturas, zero falhas), sem repetir o replay já validado na integração. Logs preservados; não contabilizar a execução incompleta como PASS.

Q2 capturado e inspecionado em PC/1280 e Web/1920; PNGs finais pc-q2-1280x720.png e web-q2-1920x1080.png em q2-layout/. Não houve nova exportação/teste de navegador nesta correção: checks Web são execução desktop do projeto Web; evidência de navegador anterior refere-se ao estado anterior do layout. Testes de perfil/playtest anteriores permanecem válidos para partes não alteradas e não foram repetidos.

Resultado: fala de Helion à direita junto de Helion/Durvall, Zynara à esquerda junto de Zynara/Kayron. Conteúdo e imagens não regenerados. Nenhum save real, commit, push ou publicação. HQ02 continua aguardando aprovação de início.
