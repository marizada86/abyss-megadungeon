# Evidência do planejamento de portagem — 2026-10-18 r1

Solicitação: planejar a chegada de todos os assets, mecânicas e funcionalidades
da origem atualizada. Somente planejamento autorizado.

Comparação local por SHA-256 em assets/core/data/ui/tools/tests e arquivos da
raiz, com exclusões de infraestrutura e caches. Resultado: 2.824 idênticos,
853 exclusivos da origem, 127 diferentes e 229 exclusivos do destino.
Manifesto detalhado: `.atena/generated/source-port-20261018/audit-r1.json`.
Números incluem .uid/.import; não são contagem de funcionalidades.

HEAD origem a558cd8532ffa39cabfe49bb7b4d1c1cb978a783; PC
2bc4d247944be7cef1f4470340178c219908d8b0. Git status da origem indisponível
(operação requer work tree); não alterada configuração para contornar isso.
Arquivos locais, não release remoto, constituem o diagnóstico.

Origem PLAN-103/SPEC-176 em B-002/S-011 aguardando jogo do dono: Durvall,
Zynara/Leoric DRAFT; Nyrelia retida. PLAN-110/SPEC-185 registra integração
de pacotes e decisões restantes. Histórico também aponta chefes nos nove
mapas, filtros/fontes, feedback, atmosfera, evoluções, retratos e VFX.

PC tem conteúdo exclusivo de mapas/campanha/HQs e alterações não commitadas
no catálogo/dados/leitor/testes. Estado compartilhado lido; checkpoint HQ05
CP-V05-01 preservado, assim como demais planos. A evidência histórica da
integração HQ21/HQ04 diz aceite pendente, mas plan.yaml posterior registra
aceite humano concluído: prevalece o estado operacional mais recente, sem
reescrever a evidência antiga.

Saída: `.atena/specs/SPEC-NOTTGARD-SOURCE-PORT-20261018/plan-r1.md`, DRAFT,
8 etapas/4 lotes; modo não configurado; execução pendente. Nenhum arquivo de
runtime alterado, nenhum teste Godot iniciado, nenhum save real acessado,
nenhum asset copiado, nenhuma promoção canônica/commit/export/publicação.

Limite: a matriz de paridade funcional, a análise semântica dos conflitos e
os baselines executáveis pertencem às duas primeiras etapas propostas; a
comparação de arquivos não comprova funcionamento nem equivalência funcional.
