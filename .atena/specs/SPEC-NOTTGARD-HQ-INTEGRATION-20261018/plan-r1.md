# HQ21 e HQ04 — integração PC r1

PROPOSED_AWAITING_CP_I18_001. origin: planned; implementation_preceded_spec: false. Pedido “Atena, vamos aplicar as novas hqs no jogo”. PLAN_DEVIATION da seleção HQ05: proposta fazer agora e retornar ao CP-V05-01; nenhuma candidata HQ05 aprovada. Modo per-step herdado, não pedir novamente nível de aprovação.

## Evidência e escopo

HQ19 e HQ20 já admitidas em assets/hq/chapter2_r1 e data/hqs.json, recibo hq-integration-20261017/admission-r1.json; validação anterior válida para fatos anteriores, não comprova esta integração. HQ21 tem 7 imagens aceitas, manifesto hq21-production-20261017/approved-sequence-r1.json; HQ04 tem 6 imagens aceitas, manifesto hq04-production-20261017/approved-sequence-r1.json. HQ04 legado ainda tem quatro artes/textos antigos em hqn_04. hqn_21 ausente, catálogo ORDER ainda não a inclui. Arquivos de catálogo/testes relevantes sem diff atual; há mudanças de outros chats no projeto que devem ser preservadas.

Integrar somente 13 PNGs selecionados/aceitos, com hashes/aceites reconferidos, caminhos versionados e originais preservados. Atualizar hqn_04 mantendo ID/título/gatilho legado e acesso já adquirido; substituir seus painéis e legendas pelos seis CANON. Adicionar hqn_21 com sete legendas CANON e ordem após hqn_20, antes hqn_04. Reconciliação do acesso HQ21 segue o contrato de conteúdo admitido chapter2_content usado HQ19/20: acesso de revisão QA e marco próprio, sem inventar evento automático de campanha. Marco proposto `shedaklah_reunion`, declaradamente reserva de acesso, não gerado por esta integração. Respeitar acesso existente visto/legado se já houver dado equivalente. Não promover arte pendente HQ05.

Não objetivos: gatilhos/filas automáticas do capítulo 2, nova progressão/mapas, combate de Zuggtmoy, alteração de saves reais, versão Web, exportação/distribuição, commit/push. Tais ações requerem contrato/checkpoint próprios. Usuário deverá conhecer que catálogo/leitor admitidos não concluem agendamento de campanha.

## Etapas

1. S-I18-001 — Admissão das 13 imagens e catálogo/leitor. Entradas: manifestos e aceites, roteiros CANON, snapshot delimitado dos arquivos alterados. Saída: imagens versionadas, hqn_04 com 6 painéis, hqn_21 com 7 e ordem no Diário. Registrar portagem PC específica, sem sincronização Web. CP-I18-001 pendente antes das alterações runtime.
2. S-I18-002 — Validação técnica/visual em perfil sintético isolado. Testes pertinentes hqs/chapter2_hqs/chapter_flow/data e compilação conforme impacto; Godot D:/Godot/godot.exe. Capturar leitor em 1280×720 e 1920×1080, incluindo Q1 HQ04, legendas longas e último quadro, e conferir avanço/retomada/fechar/concluir. Nunca carregar save real. CP-I18-002 antes da etapa.
3. S-I18-003 — Conferência humana no jogo e fechamento. Preparar roteiro curto de playtest com build/escopo/procedimento/critério e perfil de teste; dono confirma apresentação. Registrar limitações e recibo final, retornar à seleção HQ05 sem promover seleção pendente. CP-I18-003 antes da etapa. Não concluir aceitação humana sem resposta.

## Aceitação, impactos, gaps e recuperação

Cada arte corresponde ao manifesto/aceite e à legenda literal; 7/6 painéis em ordem, sem Aila ou armas futuras, colar dourado/azul e portal roxo preservados. Sem alterar IDs/saves/controle do capítulo1. Catálogo deve incluir HQ21; teste de acesso deve distinguir QA/marco ausente e presente. HQ04 permanece acessível a quem já possuía direito. Preservar comportamento de HQ19/20.

HQ04 Q1 tem fonte aceita 1640×959, demais 1672×941 (HQ21Q1 1672×940). Não esticar/cortar/regenerar arte aprovada para satisfazer teste de proporção; verificar modo de ajuste do leitor e aceitar dimensões-fonte documentadas no teste específico se necessário. Conferir letterboxing/legenda em capturas, manter arte integral. Gap RESOLVABLE na implementação: layout existente de texture rect e legibilidade. BLOCKING para reprodução automática: contrato de campanha não incluído; DEFERRED explicitamente nesta proposta.

Recuperação: snapshot dos arquivos de runtime específicos antes de editar; fontes inalteradas. Reverter apenas deltas próprios se falhar validação, sem reset/checkout global nem excluir alterações concorrentes. Atualizar somente bloco próprio no plan.yaml lido imediatamente antes de cada escrita. Evidência: recibo de admissão, fontes/hashes, testes e capturas, aceite humano separado. Escolha de escopo concreto precisa de aprovação CP-I18-001 antes da admissão, conforme Guided ADD/per-step já adotado.

## Aprovação e execução

Em 2026-10-18, dono aprovou “por plano”, substituindo checkpoints de autorização por autorização única das três etapas. S-I18-001/002 concluídas e validadas; S-I18-003 aguarda somente avaliação subjetiva do dono. Metadado de legenda abaixo da arte resolveu sobreposição observada, sem alterar PNG. Evidência EVID-NOTTGARD-HQ21-HQ04-INTEGRATION-20261018-r1.
