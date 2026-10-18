---
id: HQ-OPENING-SCRIPT-20261015
revision: r1
status: DRAFT_OWNER_OUTLINE_WITH_RESEARCH_GAPS
---

# Roteiro de abertura — HQ01 e HQ02

Esboço fornecido pelo dono em 2026-10-15; roteiro primeiro, produção depois. Artes existentes são referências; HQ01 Q1 do domo já aprovada e preservada. Não houve mudança no catálogo ou nos gatilhos. Esta versão excede o contrato atual de quatro quadros da HQ01; analisar r2 da spec antes de implementar, preservando aprovação per-step e PC/Web.

## Regra visual informada pelo dono

Em imagens de dentro de Nottgard, antes da queda da Tarn, o céu visível deve ser o interior do domo mágico que cobre toda a cidade. A névoa é verde. Trincas são rupturas na energia do domo por onde entra a névoa; não converter o domo inteiro em vidro/material sólido. Registrar que a representação temporal do céu muda somente após a queda/substituição da Tarn. Não aplicar essa regra retroativamente a épocas anteriores à criação da Tarn.

## HQ01 — ordem solicitada, ainda em discussão

| Quadro | Ação / conteúdo |
| --- | --- |
| 1 | Vista externa de Nottgard sob o domo, candidata já aprovada; legenda atual mantida |
| 2 | Duas cenas de incumbência: Zynara para Kayron, “Investigue as docas.”; Helion para Durvall, “Procure Gilly.”. Composição em duas cenas ainda a decidir; não implica presença dos quatro juntos neste momento |
| 3 | Gilly passa a missão de ir às Docas para Kayron, Durvall, Sylas e Maelor. Durvall bebe suco de laranja |
| 4 | Ritual com símbolos abissais enfraquecendo a Tarn; trincas no domo deixam a névoa verde entrar |
| 5 | Kayron em contato com a névoa: efeito específico pendente de fonte/decisão |
| 6 | Durvall no mesmo contato: permanece sem o efeito sofrido pelos companheiros, sem declarar imunidade geral |
| 7 | Sylas em contato com a névoa: efeito específico pendente de fonte/decisão |
| 8 | Maelor em contato com a névoa: efeito específico pendente de fonte/decisão |
| 9 | Kayron, Durvall, Sylas e Maelor chegam às Docas e encontram Willie |

Contagem provisória: nove quadros se as duas incumbências compartilharem um quadro; dez se separadas. Não comprimir automaticamente em quatro. Ordem do dono foi preservada acima. Continuidade a discutir: as fontes da Sessão 01 colocam a chegada às Docas e Willie antes da descoberta da rachadura/contato com a névoa; a lista atual coloca o encontro depois. Recomendar mover a chegada/Willie antes do ritual ou explicitar um retorno, sem alterar silenciosamente a intenção.

## HQ02 — três momentos pedidos

1. Quatro personagens entram no porão: inscrições em abissal cujo significado é “Seremos um só”, sangue nas paredes/chão e arranhões de garras. Inscrição diegética não é legenda de UI; não produzir pseudoalfabeto como se fosse idioma validado sem decisão de representação.
2. Pequena biblioteca: descobrem ritual com “Sangue celestial, sangue corrompido e osso de galinha”.
3. Após derrotar o Guardião Alado, usam sangue dele, sangue celestial de Kayron e osso de galinha; as trincas da Tarn desaparecem.

O fechamento das trincas é informação explícita do dono para este roteiro. As notas canônicas locais consultadas registram ritual e posterior dissipação aparente da névoa, sem afirmar causalidade/fechamento; conservar essa diferença de procedência, sem dizer que a consulta comprovou o efeito completo. Não escrever no vault por efeito deste trabalho. Proposta de encenação, ainda não aprovada: separar derrota do Guardião e execução/resultado do ritual para dar espaço à resolução. Isso resultaria em quatro quadros, mantendo os três acontecimentos pedidos.

## Pesquisa dos efeitos da névoa — Sessão 01

Consultados: Sessão 01; dossiê da Sessão 01 (validado e convertido, incluindo S1-12/A01/A02); fichas de Kayron, Durvall, Maelor; capítulo 1 da narrativa Histórias de Nottgard — Aluris. Dossiê 02 consultado para ritual/resultado. Índices 15_Fontes localizam transcrição original fora do vault; ela não foi aberta nem copiada. As notas-resumo História Nottgard Completa e Prólogo - Nottgard não trouxeram descrição individual adicional nesta busca.

Confirmado: Kayron, Sylas e Maelor sofrem o contato; Durvall não sofre o efeito inicial. A narrativa em prosa descreve os três cambaleando/pálidos, presença mental de Ghaunadaur e lampejo/visão de ritual. Os registros canônicos consultados não individualizam três reações diferentes para esta cena. Não importar reações da Sessão 07 ou 13, nem extrapolar ausência de efeito de Durvall para imunidade permanente.

BLOCKING para roteiro final dos quadros individuais: localizar descrição primária adicional ou obter definição do dono sobre a reação de cada um. Fonte comprovada permite descrever o efeito compartilhado, mas não inventar quatro visões individuais.

## Véu Vivo — jogo versus história

Jogo: hqn_03, gatilho stage_reached/shedaklah em data/hqs.json. ui/run.gd apresenta a HQ ao registrar a chegada à fase (linhas 563–568); não exige vencer Shedaklah. core/hq_catalog.gd também permite replay no Diário a perfis que já alcançaram ou concluíram a fase. Tests/test_hqs.gd declara o mesmo gatilho; nesta consulta não foram rodados testes nem carregados saves.

Campanha: no fim da Sessão 12, depois do confronto com Kein no Abismo e do retorno a Nottgard sob invasão. Adam atinge Ailalore, a fonte de energia da Tarn; o domo cai e a névoa invade. Helion planta a semente recebida de Leoric e se sacrifica; a árvore/raízes erguem a proteção viva que substitui a Tarn. A Sessão 13 retoma as consequências e a fusão de Helion com a árvore. Não é acontecimento imediatamente posterior à primeira investigação das Docas da Sessão 02. O gatilho atual é uma adaptação de apresentação para a progressão do jogo; qualquer mudança será decisão separada.
