# HQ02 — suplemento de integração r1

Status: APPROVED_R1, “aprovado” (2026-10-16), após apresentação dos cinco quadros/textos e proposta concreta de integração/teste PC/Web. Especificação anterior à implementação, IN_PLAN S-HQ-003; não substitui plano r1 de 16 etapas. Sequência em `.atena/generated/hq02-review-20261016/hq02-sequence-r1.json`. Sem gaps BLOCKING técnicos conhecidos.

## Escopo e aceitação

Integrar somente HQ02 CANON r2 em PC/Web: substituir assets/hq/hq_n02_q1.png a q4.png e adicionar q5.png com cópias das cinco versões individuais aceitas; atualizar apenas panels de hqn_02 em data/hqs.json com os cinco textos exatos do manifesto. Preservar ID, título e gatilho stage_cleared/docas, outras HQs, leitor, perfis e regras de desbloqueio. HQ01 continua com oito quadros, HQ02 passa a cinco, demais doze continuam com quatro: 61 imagens referenciadas. Não alterar capítulos nem iniciar HQ03.

Atualizar expectativa do catálogo em tests/test_hqs.gd para HQ01=8, HQ02=5, demais=4 e verificar navegação dos cinco quadros HQ02, imagens, legendas, contador e fechamento. Reutilizar leitor dinâmico existente sem mudança desnecessária. Validar test_hqs, test_profile e test_playtest em ambos conforme validation.md, com dados sintéticos isolados e sonda do diretório antes de autoload. Conferir leitor/legendas em 1280×720 e 1920×1080, Diário e replay. Avaliar sobreposição da legenda aos componentes do ritual/sangue, sem modificar textos/artes aceitos silenciosamente.

## Portagem, recuperação e limites

Antes de cada escrita registrar e preservar originais/hash no coordenador PC, incluindo catálogos e teste atuais de ambos. Comparar antes de gravar; portar só cinco imagens, entrada HQ02 e teste pertinente; preservar diferenças entre plataformas e trabalhos de outros chats. Registrar recibo de portagem e evidência. Importações Godot dos recursos são permitidas no escopo. Se falhar, recuperar somente alterações desta integração a partir do backup correspondente.

Sem save real, instalação, commit, push ou publicação. Não inferir teste em navegador a partir do projeto Web executado no Godot; registrar exatamente o que foi verificado e qualquer pendência. Concluir S-HQ-003 após checks/aceitação planejados; S-HQ-004 exige checkpoint próprio.
