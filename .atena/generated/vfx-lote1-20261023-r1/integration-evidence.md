# Integração VFX Lote 1 — entrega técnica, 2026-10-23

DRAFT. Continuação autorizada pelo dono: "atena aprovado, vamos continuar". Aceite das 17 fontes por ID/revisão/hash em batch-acceptance.json. Não houve nova geração nem alteração das fontes aprovadas.

## Resultado
17 atlas e 112 quadros preparados e integrados. Fontes 1536×1024 foram recompostas em tiras 1536×256 (seis quadros) ou 2048×256 (oito), com alfa, escala única por animação, âncoras fixas e margem mínima de 21 px (8%). F02 usa chave magenta; os demais usam chave preta. Job reproduzível em tools/asset_jobs/vfx_lote1_v01.json; modo vfx_atlas acrescentado a tools/asset_prep.gd. A F04 usa regiões horizontais explícitas devido à irregularidade da fonte, preservada sem sobrescrita. Conferência geométrica e não-vazio dos 112 quadros em preparation-audit.json. A geometria não prova loop desenhado perfeito.

Runtime: core/vfx_atlas.gd compartilha o carregamento de seis quadros; core/hit_spark_vfx.gd faz tipo/crítico, rotação determinística e limite de oito; core/projectile_vfx.gd preserva family_for do herói e acrescenta o roteamento inimigo e tinta de chefe derivada de enemies.json com brilho mínimo; core/melee_vfx.gd só acrescenta as três armas radiantes por ID; core/fire_swing_vfx.gd recebe F12 sem alterar tests/test_fire_swing_vfx.gd; core/wax_vfx.gd compõe corpo normal achatado em Under e chamas/cast aditivos em Fx.

ui/run.gd sincroniza o voo e a vida das poças por identidade, limpa sprites e dispara faíscas/lançamentos. ui/overlay.gd mantém círculos/desenhos antigos quando não há sprite admitido (folha ausente, redução ou limite). Os projéteis com sprite recebem disco escuro de contraste. O corpo F02 foi conferido em âmbar e carmim: não foi necessária F02b. Não mudaram dados de armas, balanceamento, saves, nomes técnicos ou IDs; o metadado src/ring anterior em Battle foi preservado.

## Verificação
- Testes novos de faíscas, projéteis inimigos, cera e admissão dos 17 atlas: zero falhas.
- Regressões de FireSwingVfx, projéteis/habilidades do herói, MeleeVfx e cobertura VFX/SFX: zero falhas. O teste de fogo existente permanece idêntico.
- Suíte completa tests/run_all.gd: zero falhas; final-suite.log.
- Compilação de scripts: zero falhas; compile-final.log (a verificação interativa posterior compilou o launcher revisado e passou).
- Auditoria do projeto: zero erros e zero avisos de conteúdo; project-audit.log.
- Cenário renderizado na GTX 1660 SUPER: 11 verificações passaram, incluindo 60 voos e três poças, redução, limite real de 80 voos, impacto e sua limpeza, dicionários e RNG do Battle intactos. playtest-verification.json.
- Comparação do fixture com fallback reduzido versus sprites: ambos 120 fps limitados, 180 quadros por modo; média 8,3 ms; p95 8,8 ms e 8,6 ms respectivamente. Esse cenário desliga a simulação e não mede a capacidade máxima nem o desempenho de uma partida completa.
- Capturas reais do renderer: stress-sprites.png, stress-procedural.png, consumer-samples.png e contrast-light.png. Verificadas visualmente, incluindo piso claro e tintas da cera.
- Launcher interativo verificado: VFX_INTERACTIVE_LAUNCH_PASS em interactive-check.log. Perfil isolado, quatro armas nível 3, quatro atiradores e 1000 PV apenas no fixture.
- controller_check reproduziu preferencias_persistem_reload e zona_morta_navegacao, mais o timeout já previsto no plano. O encerramento também reproduz o arquivo de saída nulo em _finish; não foi modificado o script do controller para mascarar a dívida.
- Persistem mensagens do Godot sobre certificados, recursos/ObjectDB e limpeza de GL no encerramento. Não há SCRIPT ERROR na suíte final ou no cenário VFX; a exceção do controller é discriminada acima.

A primeira execução longa de testes coincidiu com a importação/edição e acusou recursos/classes ainda não importados; não é usada como baseline de regressão. O resultado válido é a suíte final após importação. Logs vazios iniciais não constituem evidência.

## Isolamento e portagem
Todas as execuções usam APPDATA e LOCALAPPDATA sob synthetic/ deste diretório. O cenário verifica OS.get_user_data_dir antes de criar a run. Nenhum save real foi carregado. Nenhuma dependência instalada ou referência remota buscada.

Portagem registrada: frente PC do mesmo jogo, somente Windows x86_64. A fonte operacional é este checkout de Abyss Megadungeon, conforme a transferência de 2026-10-22; F:/dev/nottgard-survivor e a worktree anterior permanecem históricos, sem sincronização de volta. Não foi criada uma alteração compartilhada com uma segunda versão ativa ou mobile. Os checks cobrem preparação sintética e runtime PC neste destino. Nenhuma escrita/teste com save ou implementação no histórico.

## Próximo checkpoint
S5/TECHNICAL_DELIVERY_HUMAN_PLAYTEST_PENDING. Galeria integration-review.html e atalho Avaliar-VFX.cmd. Aceite das fontes preservado; revisão visual em jogo e diversão dependem do dono e não foram afirmadas como concluídas.

Sem commit, push, merge, build, exportação, publicação ou promoção CANON. Lote 2 e demais planos preservados.

Referência objetiva da dívida do controle: ../ui-quartel-integration-20261022-r2/synthetic-20261022-042133/controller.log (mesmas duas falhas, store_string em arquivo nulo e timeout), também descrita no evidence.md daquela entrega.
