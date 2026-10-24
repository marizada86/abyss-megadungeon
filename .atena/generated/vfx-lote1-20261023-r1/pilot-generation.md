# Piloto VFX Lote 1 — geração 2026-10-23

DRAFT. Pedido atual do dono: "atena, execute o plano feito no Claude para gerar imagens", indicando a fila ASSET-QUEUE-VFX-LOTE1-20261023-r1.md. Autoriza geração pela Atena em substituição à etapa manual. Modo per-plan; gate do piloto preservado.

Ferramenta: image_gen.imagegen (built-in), fundo preto, referência local ref-existing-vfx.png em todas as quatro chamadas. Prompts v01 completos nos arquivos prompts/F03_cera_poca_chama_prompt.txt, prompts/F06_inimigo_flecha_prompt.txt e prompts/F13_hit_fisico_prompt.txt. Correção integral da F03 registrada em prompts/F03_cera_poca_chama_v02_prompt.txt.

## Entrega
- F03 v01: retida por erro objetivo; incluiu velas/corpo de cera numa camada que deve conter apenas chamas.
- F03 v02: candidata de chamas sem corpo sólido, aguardando dono.
- F06 v01: candidata com 4 voos para direita e 4 impactos, aguardando dono.
- F13 v01: candidata com 6 estágios de faísca física, aguardando dono.

Quatro PNGs preservados no diretório desta evidência, sem sobrescrever versões. Dimensões verificadas: todos 1536x1024. SHA-256 e estado por arquivo em pilot-source-audit.json; candidatas correntes e tentativas em queue.json.

## Revisão técnica preliminar
Conferência visual: contagens 6/8/6 presentes, sem texto ou grades desenhadas; F03 v02 removeu velas e poça. F06 tem paleta hostil e voo para direita. F13 tem progressão de flash a dissipação.

As fontes não são atlas prontos: o desenho excede em alguns quadros a faixa central/área pretendida, especialmente o pico da F13. Recortar cegamente y=384..640 pode perder partículas. Preparação deve medir ocupação, recentrar e normalizar quadro a quadro com margem de 8%, preservando escala temporal e sem cortar; F06 requer conferência de centros por linha. A galeria mostra as fontes e simula leitura reduzida via CSS, sem alterar os PNGs. Não se afirma loop perfeito, margem validada, animação pronta ou desempenho em jogo.

## Checkpoint
S1/PILOT_GENERATED_REVIEW_PENDING. Aceite visual do dono PENDING por ID/revisão/hash. As outras 14 permanecem QUEUED/PENDING_PILOT_GATE, conforme fila e proposta. Nenhuma preparação final, alteração adicional de runtime, integração, commit, push, exportação ou promoção CANON nesta execução. Os metadados já presentes em core/battle.gd foram preservados.

Regras globais C:/Users/gui-m/.codex/AGENTS.md e RTK.md indisponíveis (caminhos inexistentes); também não encontrados no diretório raiz do perfil Higor Rossini. Aplicadas as instruções locais e ADD disponíveis. Outros planos e alterações prévias preservados.
