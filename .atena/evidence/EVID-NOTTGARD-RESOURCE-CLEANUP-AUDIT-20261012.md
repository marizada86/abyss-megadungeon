---
id: EVID-NOTTGARD-RESOURCE-CLEANUP-AUDIT-20261012
revision: r1
status: AUDIT_COMPLETE_NO_DELETION
date: 2026-10-12
---

# Revisão dos candidatos de conteúdo

Pedido de verificação para limpeza adicional classificado como PLAN_DEVIATION perante o plano de separação r1, CP-SPLIT-02 pendente, e novo escopo perante a limpeza conservadora já concluída. Auditoria de leitura concluída; exclusão de conteúdo ainda não aprovada. Estado operacional do plano original preservado.

Manifesto e resultados: [audit.json](../generated/resource-cleanup-audit-20261012/audit.json). Escopo técnico: core/ui/data/tests/tools/assets, project.godot, presets e instruções locais nos projetos PC e Web. Checados caminhos completos, nomes de arquivo (exceto nomes genéricos de animação), identificadores UID dos metadados, caminhos montados relevantes, tabelas de seleção e overrides. Histórico ADD registra procedência e não é tratado como consumidor de runtime. Não houve revisão artística: identidade visual N/A para esta análise de dependências; nenhum conteúdo ou aparência ativo foi reinterpretado.

## Recursos confirmados sem uso nos fluxos atuais

| Grupo | Recursos | Bytes incluindo .import | Evidência |
| --- | ---: | ---: | --- |
| Pisos antigos | 10 | 24625765 | Cenas usam atlas v3 de Dagruve/Docas e baked v2 de Durao/Feng-tu/Goranthis/Molor/Shedaklah/Shendilavri. Os candidatos não são selecionados pelo fallback `%s_ground.png`. Sem referência por caminho, nome ou UID nos arquivos consumidores. |
| Piloto reduzido de Kayron | 12 | 1421355 | HERO_STRIP_SET vazio por decisão existente de 2026-10-09. Sem ocorrência de heroes_screen nos consumidores. Únicas atribuições ao override são o teste de conjunto vazio e restauração do estado. Testes com tabela vazia verificam originais, não exigem o piloto. |
| WAV substituídos | 6 | 78369 | Manifesto seleciona ui.click_01.mp3, ui.confirm_01.mp3 e progress.levelup_01.mp3. Sfx carrega somente paths definidos no manifesto; não enumera a pasta ou constrói nomes WAV. Sem referências aos seis WAV. |
| Fonte Bold e névoa antiga | 2 | 1605580 | Theme usa AlegreyaSans-Regular.ttf; sem seleção de Bold. Run usa nevoa_borda_01.png; sem seleção de nevoa_textura_01.png. Sem referências por caminho, nome ou UID. |
| Total por projeto | 30 | 27731069 | 30 arquivos de recurso e 30 .import. Cerca de 26,45 MiB. |

Os 60 arquivos propostos de cada projeto são idênticos por SHA-256 entre PC e Web e também às cópias preservadas na origem histórica. Não há arquivo de áudio ausente no manifesto em nenhum dos dois projetos; nenhum caminho de áudio ativo pertence à lista de remoção. A cópia da origem não foi alterada.

O falso positivo anterior de oito move_*.png do piloto era causado por busca do basename em testes dos originais. A revisão de diretório, tabela e overrides distingue os dois conjuntos. Foram incluídas as quatro folhas active/attack/death/idle do mesmo piloto rejeitado.

## Itens preservados

- OFL-AlegreyaSans.txt e OFL-CinzelDecorative.txt: licenças de fontes que permanecem no projeto. Ausência de referência de runtime não as torna descartáveis.
- assets/audio/generation_report.json: pequeno recibo de geração/procedência, 169 bytes; preservado por utilidade operacional, embora não seja lido pelo runtime.
- Grupos de conteúdo binariamente idêntico não são aprovados para deduplicação: nomes distintos servem a IDs/eventos distintos. Essa ação exigiria alterar referências/manifestos, fora do escopo de remover conteúdo sem uso.
- Originais de Kayron, fontes Regular/Cinzel usadas, névoa de borda, MP3 selecionados, baked v1 de Dagruve/Docas/Pilares e atlas ativos permanecem intactos.

## Limites e próxima validação

Conclusão estática sobre o código e configurações presentes, não prova sobre scripts externos futuros ou overrides feitos manualmente fora do projeto. Não houve exclusão, importação, testes Godot, exports nem acesso a saves. O próximo checkpoint deve autorizar o escopo concreto antes de remover conteúdo.

Proposta: remover exatamente o manifesto em PC e Web, com portagem registrada, preflight de hashes, recuperação delimitada e checks pertinentes em ambos. Economia conjunta de 55462138 bytes, cerca de 52,89 MiB, sem contar caches ou tamanho futuro dos pacotes. Builds existentes continuam contendo o conteúdo anterior até novos exports; não serão sobrescritos por este escopo.

Spec DRAFT r1: [SPEC-NOTTGARD-RESOURCE-CLEANUP-20261012](../specs/SPEC-NOTTGARD-RESOURCE-CLEANUP-20261012/spec.md). Modo proposto per-plan como na limpeza anterior; CP-RESOURCE-CLEAN-01 ainda PENDING_APPROVAL. A aprovação anterior cobria somente cache e dois executáveis, não esta lista.
