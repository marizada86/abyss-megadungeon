# Revisão da separação PC e web

Entrega local r1, autorizada no CP-SPLIT-01 em 2026-10-12. Cinco etapas executadas; CP-SPLIT-02 aguarda playtest e aceite humano.

| Versão | Projeto | Revisão local |
| --- | --- | --- |
| PC Windows | D:/dev/nottgard/games/launcher-pc/nottgard-abyss-megadungeon | Testar-PC.cmd, com perfil sintético separado |
| Web desktop | D:/dev/nottgard/games/launcher-web/nottgard-abyss-megadungeon | Testar-Web.cmd, servidor Node em loopback com conta sintética |

## Resultado

Dois projetos independentes com recursos locais, UIDs preservados, ADD próprio e procedência. PC conserva três presets Windows e evidências nativas, sem shell ou bridge web. Web conserva um preset Web, bridge e fila/downloads de evidências, com opções de tela do navegador e sincronização de tamanho do canvas. Controles, preview e recursos mobile removidos dos dois projetos; confirmações de desktop preservadas com nomes genéricos.

Nome técnico, IDs, schema de save e versão 0.4.0 preservados. Build IDs: b83f188a-split-pc-r1 e b83f188a-split-web-r1. Mecânicas, dados e arte herdados idênticos; data/build_info.json é metadado operacional novo. Sem sincronização automática entre plataformas ou save remoto.

## Verificação

| Check | Resultado |
| --- | --- |
| Suítes isoladas da base, PC e web | 0 falhas em cada suíte |
| Contratos de plataforma e flag mobile | 0 falhas; diretório sintético confirmado |
| Importação/compilação | PASS após regeneração inicial de caches/fontes |
| Smoke de menu e nove fases | PASS em PC e web |
| Exports Windows normal, playtest e QA | PASS; três executáveis locais |
| Export HTML/WASM/PCK | PASS; pacote web local |
| Inicialização do executável Windows final | exit 0, sem erros, perfil sintético explícito |
| Gate existente de acesso web | três testes PASS com autenticação/SQLite em memória, sem papéis administrativos |
| Prévia independente | oito checks HTTP PASS; sem sessão ou em falha de autenticação não serve HTML, WASM ou PCK |
| Paridade e isolamento | conteúdo comum idêntico; sem caminhos de runtime externos; contrato ADD presente |
| Integridade da origem | hashes do manifesto preservados; somente registro operacional delimitado no estado |
| Codex IAB | título, Quartel, run, HQ, revive, pausa, opções web e recarga observados; console sem erros |

Avisos de recursos/RIDs na saída do runner existem na base e permaneceram semelhantes, com 0 falhas de testes. Um parâmetro do executor de isolamento foi corrigido para config/custom_user_dir_name; os checks foram repetidos e substituídos pelos resultados finais com isolamento confirmado.

A sessão inicial do navegador apresentou descompasso de escala/entrada sob DPR 1,5. Na sessão renovada, base e candidato renderizaram corretamente em 1280×720. A entrada em fullscreen foi confirmada pelo canvas fullscreen, mas a apresentação sob viewport emulada não sustenta aceite de DPI/tela cheia em navegadores reais. O sincronizador trata resize e fullscreenchange após estabilização do canvas. Sonda temporária removida. Nenhum override de devicePixelRatio foi aplicado ao produto; simulações ficaram somente na fixture e não foram aceitas como PASS de DPI 150%.

## Playtest do dono

Verificar início de tentativa, movimento, habilidade, ofertas, ficha, pausa/retomada e retorno ao Quartel. PC: teclado/mouse e controle físico. Web: Chrome, Edge e Firefox, áudio após gesto, foco, tamanho da janela e tela cheia, inclusive DPI habitual. Relatar plataforma e build ID. Dificuldade e diversão não receberam aceite automatizado.

Backlog e aceites do PLAN-071 preservados. Mobile, admissão/distribuição nos launchers, publicação, commits e integração de saves estão fora da entrega.

## Manutenção e recuperação

Portar correções comuns seletivamente, registrando origem e validando nos dois projetos. Consultar base-manifest.json, final-audit.json, pc-products.json, web-products.json e os estados ADD. Preservar mudanças posteriores e a origem. Fontes anteriores à especialização ficam em baseline. Nome CANON r1 e arte foram herdados; sem nova promoção canônica, push, deploy ou publicação.

Verificação final do pacote: a fase exportada detectou o carregador de decals buscando PNGs originais ausentes. A tentativa de include_filter não resolveu e foi retirada. Nas duas cópias, ui/ground_decals.gd usa ResourceLoader para as texturas importadas; arte preservada. Suítes repetidas com zero falhas, pacotes reconstruídos e fase web reaberta sem novos erros de imagem. A origem conserva o carregador anterior.
