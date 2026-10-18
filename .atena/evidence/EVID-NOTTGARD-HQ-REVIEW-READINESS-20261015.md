# S-HQ-001 — prontidão, 2026-10-15

PLAN-NOTTGARD-HQ-REVIEW-20261015 r1, aprovação per-step. Decisões do dono: "3, aprovado" e "Para ambos". CP-HQ-01 liberado para S-HQ-001; nenhuma autorização para executar a etapa seguinte por efeito desta confirmação.

## Resultado

Etapa 1/16 concluída: fontes locais encontradas, bíblia de referências DRAFT preparada, baseline recuperável e procedimento de validação isolada documentados. Nenhum arquivo de runtime ou save foi alterado; nenhuma imagem foi gerada, editada ou auditada visualmente.

PC e Web possuem 14 HQs, 56 quadros e 10 retratos de referência. Foram preservados e verificados 134 arquivos por plataforma, com blobs deduplicados por SHA-256 e manifesto separado por origem. Check estático inicial: catálogo válido, quatro quadros por HQ, texto não vazio, PNGs existentes/assinatura válida e proporção dentro da tolerância do teste existente. Zero erros encontrados nesses checks. Não equivale à importação na engine ou aceite narrativo/visual.

Diferenças de baseline entre as versões limitadas aos arquivos selecionados: core/game.gd, core/playtest.gd e tests/test_playtest.gd. Catálogo, 56 imagens, referências, leitor e teste de HQ iguais. Configurações project.godot somente lidas/hash-registradas; alterações locais anteriores preservadas.

Fonte narrativa atual encontrada em D:/dev/nottgard/vault; 47 caminhos pertinentes ou candidatos indexados com hashes, sem copiar seu conteúdo. Sessões 01–24 do arco presentes. As duas notas Mystralia listadas incidentalmente no índice não são fontes deste plano. Lida a Sessão 01 e o início da narrativa Aluris, suficientes para preparar a entrada da HQ01; demais sessões exigem leitura por HQ. A Sessão 01 declara-se canônica e confirma o grupo de quatro, missão anterior de Zynara, ritual e pista junto à Tarn. Não foi feita auditoria editorial da HQ nessa etapa.

Leituras históricas: ART-PROMPTS-027 completo; ART-PROMPTS-028/029 consultados parcialmente para estrutura, fontes e restrições, sem alegar revisão integral de todos os prompts. As fontes/referências e hashes ficam no manifesto. Bíblia visual DRAFT consolida regras herdadas sem promoção canônica.

Procedimento de isolamento preparado a partir de código atual e evidência local ainda pertinente da limpeza anterior. Nenhum processo Godot foi iniciado; não se acessou save real. Estado Web lido antes de preparar coordenação, preservando seu plano original e checkpoints. Permissão do ambiente para escrita Web tratada separadamente.

Coordenação Web registrada com sucesso em .atena/state/plan.yaml, exclusivamente por adição de bloco; conteúdo original preservado e verificado. Recibo: ../generated/hq-review-20261015/web-coordination-receipt.json; estado anterior: ../generated/hq-review-20261015/web-plan-before.yaml. Não altera conteúdo do jogo nem autoriza S-HQ-002. A suspensão é delimitada ao novo plano, com retorno CP-SPLIT-02 e aceite humano anterior preservados.

## Artefatos

- [Manifesto e recuperação](../generated/hq-review-20261015/baseline.json).
- [Bíblia de referências DRAFT r1](../vault/drafts/HQ-REVIEW-VISUAL-BIBLE-r1-20261015.md).
- [Validação e portagem](../specs/SPEC-NOTTGARD-HQ-REVIEW-20261015/validation.md).

## Próximo checkpoint

S-HQ-002 (2/16), HQ01 Uma Noite Sem Fim: exibir quatro quadros e legendas atuais, recolher os apontamentos do dono e classificar manter/corrigir/esclarecer. Entradas: baseline, Sessão 01, prólogo/capítulo 1, guia e quatro retratos oficiais. Saída: ficha por quadro e proposta DRAFT para revisão. Checks: identidade, fonte, coerência imagem/texto e continuidade; sem produção antes de aprovar roteiro e contexto. Requer aprovação da etapa pelo modo per-step selecionado. Nenhuma ausência de fonte bloqueia o início da revisão da HQ01; interpretações específicas serão resolvidas com o dono antes de produzir ou integrar.
