---
id: EVID-NOTTGARD-CLEANUP-AUDIT-20261012
revision: r1
date: 2026-10-12
status: AUDIT_COMPLETE_NO_DELETION
---

# Auditoria local de espaço

Pedido: verificar arquivos ocupando espaço sem uso e recomendar limpeza. Classificação: diagnóstico de PLAN_DEVIATION perante PLAN-NOTTGARD-PLATFORM-SPLIT-20261012 r1, 5/5 etapas entregues, CP-SPLIT-02 aguardando playtest humano. A consulta não autoriza exclusão nem substituição do plano. Estado e checkpoint preservados; nenhuma suspensão de execução foi necessária para esta leitura. Não há plano de limpeza executável ou aprovação de exclusão.

Inventário: [inventory.json](../generated/cleanup-audit-20261012/inventory.json). Medidas representam bytes lógicos dos arquivos, não espaço alocado no disco. Aproximadamente 2,09 GiB no projeto; o registro de auditoria acrescenta poucos KiB.

| Grupo | Espaço | Avaliação |
| --- | ---: | --- |
| build/ | 1320,97 MiB | Três produtos distintos de 440,32 MiB cada; hashes conferem com a entrega da separação. Não são duplicatas binárias. |
| .godot/ | 337,68 MiB | Cache local regenerável; 334,64 MiB são imports. Apagar exige editor e jogo fechados e implica reimportação no próximo uso. |
| assets/ | 475,95 MiB | Conteúdo e metadados de importação. Não remover em bloco. |
| .atena/ e fontes/testes/ferramentas | Menos de 4 MiB antes deste registro | Preservar contratos, evidências, código e testes. Economia irrelevante perante builds/cache. |

## Proposta conservadora, ainda sem autorização

Após aprovação concreta, remover somente `.godot/`, `build/NottgardSurvivors.exe` e `build/NottgardSurvivors-QA.exe`. Economia imediata estimada: 1,19 GiB (1277510882 bytes). Manter `build/NottgardSurvivors-Playtest.exe`, `Testar-PC.cmd`, presets, fontes e todo o conteúdo. O atalho usa o executável de playtest, e o aceite humano permanece pendente. As outras variantes precisariam ser exportadas novamente para serem usadas. Os presets continuam válidos, mas seus dois produtos estariam ausentes até regeneração. A economia de cache é temporária: o editor voltará a gerá-lo. Alterações apenas em produtos locais não exigem portagem de conteúdo para web.

Uma limpeza máxima de todos os produtos e cache liberaria cerca de 1,62 GiB, mas deixaria o atalho de playtest sem executável; não é a recomendação enquanto CP-SPLIT-02 estiver pendente.

## Candidatos de conteúdo para uma segunda revisão

Dez versões antigas de pisos somam 24615907 bytes (23,48 MiB), sem referências literais em core/ui/data/tools/tests:

- assets/tiles/dagruve_ground_atlas_v1.png
- assets/tiles/dagruve_ground_atlas_v2.png
- assets/tiles/docas_ground_atlas_v1.png
- assets/tiles/docas_ground_atlas_v2.png
- assets/tiles/durao_ground_baked_v1.png
- assets/tiles/feng_tu_ground_baked_v1.png
- assets/tiles/goranthis_ground_baked_v1.png
- assets/tiles/molor_ground_baked_v1.png
- assets/tiles/shedaklah_ground_baked_v1.png
- assets/tiles/shendilavri_ground_baked_v1.png

Dagruve e Docas apontam para atlas v3. As seis cenas restantes acima apontam para baked v2. Dagruve, Docas e Pilares ainda usam baked v1: essas versões devem permanecer. O fallback de chão monta `%s_ground.png`; não seleciona as versões antigas acima. A remoção futura deve incluir metadados `.import` correspondentes, após aprovação, identificação por hashes e validação de referências/importação/export e testes pertinentes. Conteúdo comum exige portagem registrada e checks em PC e web, conforme AGENTS.md; a segunda versão não foi auditada neste pedido.

O conjunto `assets/animations/heroes_screen/kayron/` é um piloto de redução desativado: HERO_STRIP_SET está vazio e registra a decisão do dono de voltar aos originais. Overrides de captura/teste continuam possíveis; não apagar automaticamente. Outros candidatos incluem textura de névoa, fonte Bold e alguns WAV substituídos por MP3. A lista do inventário é uma triagem, não prova de inutilidade.

Há 70 grupos de arquivos binariamente idênticos em assets, com 2735737 bytes (2,61 MiB) de cópias excedentes. Alguns nomes distintos são usados como recursos de eventos/IDs distintos. Unificação exige corrigir referências e validar comportamento; hash idêntico não autoriza exclusão.

## Preservação e limites

- Licenças `OFL-AlegreyaSans.txt` e `OFL-CinzelDecorative.txt` devem permanecer, mesmo sem referência no runtime.
- `title_background.png` e a arte da ficha são usados por concatenação de constantes e nomes. A análise adicional eliminou esses falsos positivos da triagem.
- Heróis, inimigos, ícones, estágios e animações têm caminhos dinâmicos. A auditoria protegeu padrões reconhecidos e menções de nomes; não construiu uma prova completa de alcançabilidade em execução.
- `.import` e `.uid` fora do cache preservam configurações/identidades; não confundir com lixo regenerável.
- `tmp/` e `export_templates/` estão vazios. Não há Git local neste diretório; não há histórico Git ocupando espaço aqui.
- Não houve jogo aberto, engine executada, leitura de save real, exclusão, portagem, instalação, commit ou acesso remoto. Únicas escritas: inventário e esta evidência operacional.

Diagnóstico concluído. Próxima ação possível: preparar spec DRAFT delimitada para a proposta conservadora, escolher aprovação por plano/lote/etapa e obter aprovação do checkpoint antes de excluir. Não reutilizar a aprovação da separação como aprovação da limpeza.
