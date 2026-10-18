# Pesquisa — mapas e HQs da nova progressão

Data: 2026-10-16. ID: EVID-NOTTGARD-CAMPAIGN-FLOW-20261016. Pesquisa local autorizada pelo dono. Sem implementação, nova arte, consulta remota ou escrita no vault externo. Fontes com status canônica no vault são fontes da campanha; sua adaptação para o jogo permanece DRAFT até aceite. Não houve nova conferência auditiva.

## Fontes e resultados

Raiz das fontes: `D:/dev/nottgard/vault/`.

| Fonte | Trecho | Resultado pertinente |
| --- | --- | --- |
| 04_Locais/Docas.md | 17–37 | Porto comercial, galpões e porão ritual. Base para preservar Docas e a HQ02 já aceita |
| 04_Locais/Vila das Sombras.md; 03_NPCs/Erik Blackthorn.md | fichas | Erik é batedor Grimholder, protegido pelo Amuleto da Luz; encontro além da Tarn, não dentro das Docas |
| 10_Sessões/Arco 01 - Nottgard, A Noite Sem Fim/Sessão 11.md | 23–25, 39–45 | Travessia por Skygomork, encontro com Erik, Igreja das Sombras e passagem sob a igreja por raízes negras. Chegada ao Reino Abissal, diante do exército |
| 04_Locais/Igreja das Sombras.md | 15–25 | Igreja anterior à Tarn; passagem inferior ao Reino Abissal |
| 10_Sessões/Arco 01 - Nottgard, A Noite Sem Fim/Sessão 12.md | 23–33 | Raízes gigantescas, caminho em espiral, acampamento abissal; Kein abre portal para o exército e outro para um Beholder. Kein/Beholder e depois Death Tyrant são vencidos |
| mesma Sessão 12 | 35–45 | Grupo cria portal de retorno; chega à Floresta de Ailalore durante invasão que entrou por Domwieck. Adam ataca a estrela; Helion planta a semente e se sacrifica; Véu Vivo substitui Tarn; Adam foge vivo |
| 04_Locais/Domwieck.md | 14–22 | Distrito élfico ao norte/nordeste, em torno de Ailalore; ponto de entrada da invasão |
| 10_Sessões/Arco 01 - Nottgard, A Noite Sem Fim/Sessão 14.md | 58–60, 64, 93–102 | Aila desperta, transmite mensagem; templo de Sendrinah em Dagruve; Thalion manda capturar. Leoric/Korrak são enviados por raízes/portais, Maelor/Aila presos, Kayron foge, Brook está fora |
| 10_Sessões/Arco 01 - Nottgard, A Noite Sem Fim/Sessão 15.md | 19–27 | Raiz de Yggdrasil, Marciela guia Leoric/Korrak a Shedaklah; linha separada de Maelor e núcleo material reativando portal; depois palácio de Zuggtmoy |
| 04_Locais/Yggdrasil.md | ficha | Árvore interplanar; sua raiz não é o Véu Vivo de Helion |
| 04_Locais/Camadas do Plano Abissal (Arco 01).md | 29–37 | Continuação: Shedaklah, Molor, Durao, Feng-tu, Shendilavri e Goranthis; base para reaproveitar a rota existente |
| 04_Locais/Dagruve.md | ficha | Distrito humano negligenciado; o conflito antigo do cemitério/Astherion é outro momento. Não é prova de Thalion como chefe jogável |
| 04_Locais/QG.md | ficha | QG dos Guardiões fica na Rua Miraval; não usar essa ficha para provar localização do laboratório de Zynara |

Também consultadas as fichas Kein, Mago Helion, Thalion Aetherion e Marciela. A atribuição de ação a Kein (abertura dos portais) e a Adam (comando da invasão em Nottgard) é complementar, não contraditória.

## Autoridade local e divergências já resolvidas

- `DEC-NOTTGARD-CHAPTERS-20261015-r1`: capítulo 1 encerra no Véu Vivo; capítulo 2 cobre chegadas posteriores. Mantida expressamente pelo dono neste turno.
- `DEC-NOTTGARD-ABYSS-ARRIVALS-20261015-r1`: Thalion envia Maelor depois do interrogatório; runa nórdica, portal roxo, raízes/cipós; Aila fica com Thalion; Nidhogg erra a mordida; Durvall atravessa pelo laboratório de Zynara.
- A Sessão 15:21 ainda diz mordida grave e :23 atribui o laboratório a Marciela. Prevalece a correção direta do dono para o roteiro do projeto. Não alegar que o vault já foi reconciliado. Reutilizada `EVID-NOTTGARD-VAULT-ARRIVALS-AUDIT-20261015`.
- Respostas deste turno: capítulo 1 após Helion; combate de Dagruve termina com envio por Thalion, que não morre; escopo somente PC, aprovação por etapa. Isso decide esses pontos, não aprova automaticamente a spec completa ou sua implementação.
- O fluxo geral recebido é insumo explícito do dono. Duração, ondas, objetivos, montagem, falas e aparência ainda não foram aprovados.

## Estado técnico observado no PC

- `data/stages.json`: nove mapas; abertura atual Dagruve → Docas → Shedaklah. Docas exige Dagruve, mas Shedaklah também exige Dagruve, apesar de `next` de Docas apontar Shedaklah. Reordenar `order`/`next` sozinho não basta.
- `core/profile.gd:28–31`: migração legada marca Docas concluída se Dagruve está concluída. Não remover sem plano de compatibilidade nem tratar conclusão histórica como prova do novo encontro com Thalion.
- `core/profile.gd:171–173`: desbloqueio usa `unlock`; `ui/menu.gd` ordena por `order`. `core/game.gd` e `core/battle.gd` têm padrão Dagruve.
- `data/hqs.json`: 14 IDs; HQ01 first_run; HQ02 stage_cleared/docas; HQ03 stage_reached/shedaklah. O novo fluxo exige gatilho de HQ03 em Domwieck, preservando leitura histórica.
- `core/hq_catalog.gd`: ORDER explícito; desbloqueios também por conquistas e hqs_seen. `ui/run.gd` apresenta HQs em eventos e registra marcos. Fila, retomada e persistência exigem análise, principalmente com várias HQs após Docas.
- Busca por Thalion, Kein, Beholder, Adam e Nidhogg em `data/enemies.json` não retornou entradas com esses nomes. Novos encontros não podem ser presumidos disponíveis só pela lore.
- Testes pertinentes existentes: test_catalog, test_stage_story, test_stage_structures, test_stage_progress, test_hqs, test_profile e test_playtest. Há expectativas fixas da progressão antiga em test_profile.

## Limites e resultado

Pesquisa suficiente para proposta de sequência e identificação dos impactos; não é auditoria completa de todos os consumidores de mapas/perfis. Valores de balanceamento, contrato de encontro sem morte e compatibilidade requerem desenho técnico antes de execução. Nenhum Godot foi iniciado e nenhum save foi acessado. A pesquisa não avalia diversão ou dificuldade.

Plano vigente preservado: HQ review r1, per-step, S-HQ-004/HQ03 com roteiro r1 pendente; HQ02 integrada com navegador pendente. Plano de separação continua no CP-SPLIT-02 aguardando aceite humano.

Validação documental executada ao concluir: PASS na leitura YAML do estado, existência dos três documentos, referências Markdown locais, oito etapas ordenadas e correspondência com total_steps. Confirmados modo per-step, implementação não autorizada e cursor S-HQ-004 preservado. O schema upstream estrito não foi usado como alegação de conformidade: o estado local preexistente tem extensões próprias; sua migração não integra este pedido. Testes de jogo não se aplicam à alteração documental e não foram executados.
