# Piloto VFX Lote 2 — v01

DRAFT. Três candidatas geradas com image_gen integrado, uma chamada por peça, em resposta ao pedido atual: “atena vamos seguir o plano para gerar imagens vindo do claude” (2026-10-23). O pedido atual substitui a restrição anterior de geração manual para o piloto. As outras 19 continuam retidas pelo gate do plano.

Prompts finais usados integralmente, sem alterações: prompts/M01_morte_poeira_prompt.txt, prompts/P02_xp_coleta_prompt.txt e prompts/G03_boss_quadrante_runas_prompt.txt. Referência anexada a cada chamada: ref-existing-vfx.png. Fundo preto aditivo. Fontes salvas nesta pasta; dimensões e SHA256 em pilot-sources-v01.json.

## Inspeção visual das fontes

- M01: seis etapas, flash, nuvem e dissipação em branco quente. Partículas e nuvem excedem a faixa central de 256 px; exige reenquadramento e normalização, evitando recorte direto.
- P02: seis etapas, espiral ciano, explosão e anel com fagulhas douradas. Altura também excede a faixa prevista; último quadro mantém brilho significativo. Conferir desaparecimento em animação.
- G03: oito etapas, quatro avisos circulares e quatro detonações, vistos de cima. Centros verticais divergem da grade nominal; detonações chegam perto dos limites horizontais das células. Exige validar separação e margens; loop e equivalência entre quadrantes ainda não verificados.

As três fontes têm 1536×1024, conforme canvas de geração. Dimensão do canvas não comprova conformidade das células. Legibilidade a 24–48/96–160 px e sobre fundo claro ainda não validada. Nenhuma candidata recebe aceite técnico de atlas ou aceite humano automaticamente.

Checkpoint: PILOT_GENERATED_AWAITING_REVIEW. Próximo passo: revisar as candidatas e preparar demonstração isolada de legibilidade nos fundos e tamanhos do plano antes de liberar as demais 19. Sem integração de runtime nesta sessão. Aceite visual por ID/revisão/hash pendente.

Os caminhos globais C:/Users/gui-m/.codex/AGENTS.md e C:/Users/gui-m/.codex/RTK.md não existem nesta máquina. Aplicados AGENTS.md, ADD e plano locais; não se presume leitura das regras ausentes.
