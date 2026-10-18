---
id: SPEC-NOTTGARD-HQ-REVIEW-20261015
revision: r1
status: AUTHORIZED_R1_S_HQ_002_COMPLETE
origin: guided-add
implementation_preceded_spec: false
---

# Revisão individual das HQs — textos e imagens

Atualização operacional de 2026-10-15: S-HQ-002/HQ01 concluída após roteiro, oito imagens individuais e sequência integral aprovados e integração PC/Web verificada. **O suplemento [hq01-integration-r1.md](hq01-integration-r1.md) prevalece sobre as restrições iniciais de quatro quadros/56 imagens abaixo para hqn_01 somente:** HQ01 agora tem oito, as demais 13 conservam quatro (60 imagens referenciadas). R1 e modo per-step preservados; 2/16 etapas concluídas, S-HQ-003 aguarda aprovação própria. O texto inicial abaixo conserva a proposta/baseline de origem; não representa o cursor atual. Resultado: [evidência de integração](../../evidence/EVID-NOTTGARD-HQ01-INTEGRATION-20261015.md).

Pedido de 2026-10-15: planejar a correção das HQs, validando uma a uma e refazendo o necessário. Revisão r1 aprovada pelo dono, per-step, para PC e Web. CP-HQ-01 autorizou S-HQ-001, concluída; S-HQ-002 aguarda aprovação própria. Nenhum texto, imagem ou código do jogo foi alterado.

## Escopo proposto e limites

Revisar as 14 HQs existentes, hqn_01 a hqn_14, com quatro quadros cada. Para cada quadro, conferir legenda, fato narrado, identidade, cenário, ação, continuidade, relação entre imagem e texto e legibilidade. Manter o que for aprovado; corrigir somente os problemas identificados. A ordem inicial é a de core/hq_catalog.gd; o dono pode escolher outra antes da execução.

Base deste chat: projeto PC Windows x86_64. Como o conteúdo é comum, propor portagem explícita para o projeto Web, com recibo de origem, arquivos e revisões e checks nos dois projetos; essa escrita depende da confirmação concreta do escopo PC+Web e da permissão do ambiente. Se o dono escolher somente PC, registrar a divergência deliberada e a portagem Web como pendente, antes de tornar o plano executável. Não sincronizar automaticamente.

Preservar IDs, gatilhos, conquistas, quantidade de quadros, nomes técnicos, schema e saves. Caso a revisão encontre necessidade de mudar esses contratos, tratar como mudança de escopo antes de implementar. Novas HQs, mecânicas, balanceamento, mobile, instalação de dependências, commits, push e publicação ficam fora do escopo.

## Autoridade narrativa e visual

O runtime local descreve o que existe, não prova que a narrativa ou arte estão corretas. A procedência local remete às decisões e fontes preservadas na origem D:/dev/nottgard/games/godot/nottgard-survivors/.atena/. Consultar apenas material pertinente, sem copiar relatos pessoais ou acessar serviços remotos por efeito deste plano.

Referências históricas consultadas: vault/drafts/PLAN-040-hqs-novas-highlights-do-vault-2026-09-29.md (DRAFT com decisões registradas), specs/SPEC-095-revisao-de-proporcao-e-identidade-das-hqs.md e specs/SPEC-098-geracao-de-hqs-trilha-b.md. Não promovê-las a CANON local por inferência. PLAN-040 aponta o vault de Nottgard como fonte principal e o registro de sessão acima da prosa; localizar a fonte local de cada fato antes de propor correção definitiva. Se não houver fonte disponível, registrar a dúvida e obter decisão explícita do dono.

Antes de revisar visualmente cada HQ, montar sua ficha textual: fontes e revisões DRAFT/CANON, evento, lugar, tempo, personagens e referências oficiais, intenção dos quadros e limites de revelação. Consolidar a bíblia visual aplicável a partir das regras preservadas: pixel art sombria, proporção aproximada 16:9, sem texto embutido/UI/marca-d'água, área inferior calma para legenda, continuidade e identidades oficiais. Personagens sem referência não recebem aparência canônica inventada; enquadramentos sem entidade relevante registram identidade N/A com justificativa.

Restrições herdadas a conferir por HQ: não revelar cânone do mestre; preservar a perspectiva do grupo; Zuggtmoy e Malcanthet vivas quando a cena retrata a aliança; não atribuir assassino a Bromnor por inferência; não antecipar revelações posteriores de Nyrelia; manter escalas e identidades dos personagens. Conflitos com o pedido serão apresentados ao dono, sem reescrita canônica silenciosa.

## Método por HQ

1. Exibir os quatro quadros atuais com legendas literais, título, ID e contexto de desbloqueio. Recolher os erros apontados pelo dono quadro a quadro e registrar também os itens aprovados.
2. Comparar com fontes locais e referências; classificar cada quadro: manter, corrigir texto, corrigir imagem, corrigir ambos ou esclarecer. Não diagnosticar todas as HQs como erradas por generalização do pedido.
3. Apresentar roteiro revisado DRAFT: texto exato, quem fala, fato narrado e descrição visual de cada quadro. Resolver dúvidas narrativas/identidade BLOCKING e obter aprovação explícita dessa revisão antes de produzir arte.
4. Preparar candidatas versionadas somente para as imagens marcadas, usando originais e referências pertinentes. Cada candidata será apresentada e aprovada individualmente; preservar anteriores e registrar reprovações/ajustes. Acionar o skill imagegen apenas quando a produção/edição for autorizada, após ler suas instruções. Não há delegação ou serviço pago autorizado neste planejamento.
5. Apresentar a HQ completa com texto e imagens finais. O aceite identifica HQ, revisão e os quatro quadros; promoção de intenção/lore a CANON, quando necessária, é aprovação distinta da autorização de implementar.
6. Integrar apenas a revisão aceita, com backup/hash dos arquivos substituídos, verificar referências, importação, leitura e fluxo usando dados sintéticos. Encerrar a etapa com evidência e objetivo da próxima HQ; respeitar o modo e o checkpoint selecionados. Se o dono desejar revisar todas antes de integrar, revisar o plano nessa decisão.

## Plano de voo

PLAN-NOTTGARD-HQ-REVIEW-20261015 r1, 16 etapas ordenadas, 1/16 concluída. Modo per-step selecionado pelo dono em 2026-10-15 ("3, aprovado"); revisão r1 aprovada. "Para ambos" confirmou PC e Web e liberou CP-HQ-01/S-HQ-001. Restam 15 etapas; S-HQ-002 aguarda aprovação. Gates editoriais continuam obrigatórios.

| Lote | Etapa | Entrega |
| --- | --- | --- |
| B-HQ-001 | S-HQ-001 | Prontidão: fontes locais, bíblia aplicável, referências, escopo PC/Web, baseline recuperável e procedimento de teste isolado |
| B-HQ-002 | S-HQ-002 | hqn_01 — Uma Noite Sem Fim |
| B-HQ-002 | S-HQ-003 | hqn_02 — Seremos um só |
| B-HQ-002 | S-HQ-004 | hqn_03 — O Véu Vivo |
| B-HQ-002 | S-HQ-005 | hqn_04 — O Palácio de Zuggtmoy |
| B-HQ-002 | S-HQ-006 | hqn_05 — O Núcleo Verde |
| B-HQ-002 | S-HQ-007 | hqn_06 — A Jaula de Durao |
| B-HQ-002 | S-HQ-008 | hqn_07 — A Peregrinação da Estrela |
| B-HQ-002 | S-HQ-009 | hqn_08 — O Chifre de Malcanthet |
| B-HQ-002 | S-HQ-010 | hqn_09 — O Paraíso que Era Ilusão |
| B-HQ-002 | S-HQ-011 | hqn_10 — A Síntese Abissal |
| B-HQ-002 | S-HQ-012 | hqn_11 — A Concórdia Eterna |
| B-HQ-002 | S-HQ-013 | hqn_12 — O Nome Aluris |
| B-HQ-002 | S-HQ-014 | hqn_13 — O Cerco de Aluris |
| B-HQ-002 | S-HQ-015 | hqn_14 — A Máscara |
| B-HQ-003 | S-HQ-016 | Regressão conjunta, aceite final, portagem/reconciliação e retorno |

CP-HQ-01: aprovar revisão r1, modo e plataformas antes de S-HQ-001. Os gates editoriais de roteiro/candidata/HQ completa continuam explícitos em qualquer modo. Por plano: autorização operacional de todo o escopo; por lote: autorização antes de cada B-HQ; por etapa: autorização antes de cada S-HQ. CP-HQ-02: aceite final após S-HQ-016, sem substituir o playtest pendente do plano anterior.

## Gaps e decisões

| ID | Classe | Resolução |
| --- | --- | --- |
| GAP-HQ-001 | RESOLVED | Dono selecionou per-step e aprovou r1 em 2026-10-15 ("3, aprovado"); CP-HQ-01 liberado após confirmação das plataformas |
| GAP-HQ-002 | RESOLVED | "Para ambos" confirmou PC e Web em 2026-10-15; registro de coordenação Web persistido com permissão do ambiente |
| GAP-HQ-003 | RESOLVABLE em S-HQ-001 e por HQ | Localizar fontes narrativas e referências aplicáveis; ausência/conflito vira BLOCKING somente para a HQ afetada, antes da revisão visual/produção |
| GAP-HQ-004 | RESOLVABLE durante revisão humana | Identificar erros concretos e quais imagens precisam ser refeitas; não gerar lote antecipado |
| GAP-HQ-005 | DEFERRED | Publicação, novas HQs, mudanças de gatilhos e outros contratos exigem escopo próprio |

Nenhuma execução liberada enquanto houver BLOCKING aplicável. Aprovação antiga da separação de plataformas não autoriza este novo trabalho.

## Aceitação e validação

- As 14 HQs possuem decisão registrada para os 56 quadros, revisão de texto e decisão de manter/refazer imagem; itens mantidos também recebem aceite.
- Texto e imagem descrevem a mesma ação; nomes, identidades, continuidade e fatos têm fonte ou decisão explícita. Estética e fidelidade narrativa permanecem pendentes até aceite humano.
- Candidatas anteriores e baseline recuperáveis; admissão limitada aos arquivos aprovados, sem sobrescrever mudanças concorrentes.
- JSON válido, 14 IDs e quatro quadros preservados, legendas não vazias, caminhos existentes e imagens importáveis com proporção prevista pelo teste existente.
- Executar os testes existentes pertinentes test_hqs, test_profile e test_playtest após mudanças correspondentes; ampliar somente se houver mudança/falha/incerteza que justifique. Testes e smoke usam diretório sintético isolado: nunca carregar o save real. Confirmar o isolamento antes de iniciar Godot, inclusive prévias.
- Conferir leitor em 1280x720 e 1920x1080, enquadramento, legibilidade, avanço/fechamento, replay no Diário e desbloqueios preservados. Se PC+Web aprovado, registrar portagem e repetir checks pertinentes no destino, com divergências de plataforma explícitas.
- Na fase de teste humano, informar build/HQ, objetivo, passos, critérios e feedback esperado; não declarar aceite humano por resultado automatizado.
- Validar referências ADD e reconciliar estado/evidência sem promoção canônica implícita.

## Impactos, recuperação e retorno

PLAN_DEVIATION: DEV-NOTTGARD-HQ-REVIEW-20261015. Preservar PLAN-NOTTGARD-PLATFORM-SPLIT-20261012 r1, per-plan, APPROVED_LOCAL_R1, CP-SPLIT-02, B-SPLIT-003/S-SPLIT-005, 5/5 concluídas e playtest humano pendente. Estado compartilhado relido e suspensão delimitada/cursor/aprovação de retorno registrados no PC antes da execução de S-HQ-001. Coordenação registrada no estado Web preservando seu conteúdo anterior, com recibo e cópia recuperável. O plano anterior não foi substituído.

Não alterar project.godot ou os quatro arquivos .attempt1 locais encontrados durante a preparação. Recuperação compara hashes e mudanças posteriores e restaura somente arquivos do plano aprovados para reversão; nenhum reset global ou limpeza automática. A restauração não pode remover alterações de outro chat.

Evidência inicial: [EVID-NOTTGARD-HQ-REVIEW-PREPARATION-20261015](../../evidence/EVID-NOTTGARD-HQ-REVIEW-PREPARATION-20261015.md). Registro individual: [review.md](review.md). Aprovações e decisões serão acrescentadas com revisão e escopo concretos.

Resultado S-HQ-001: [prontidão](../../evidence/EVID-NOTTGARD-HQ-REVIEW-READINESS-20261015.md), [referências visuais DRAFT](../../vault/drafts/HQ-REVIEW-VISUAL-BIBLE-r1-20261015.md) e [validação/recuperação](validation.md). Zero gaps BLOCKING para iniciar a revisão da HQ01; aceite narrativo, visual e aprovações de produção permanecem futuros.
