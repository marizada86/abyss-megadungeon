# Próxima integração visual — proposta DRAFT r1

Esta proposta continua a produção visualmente aceita; ainda não foi executada no runtime. Preservar a integração PC dc4a917 e os demais planos. Modo recomendado: manter per-plan já escolhido. Não repetir entrevista nem aprovação do aceite das fontes.

## Escopo delimitado

1. S-I01 — capturar baseline visual e técnico do PC em perfil sintético e conferir estado atual antes de editar; registrar somente os arquivos desta integração, sem incluir trabalho de outras sessões.
2. S-I02 — integrar U09–U11 nos cartões existentes (brilho aditivo, textura se repetição validada e placa de preço); preservar foco, teclado/controle, largura e versão compacta.
3. S-I03 — integrar U12–U21 aos consumers de HUD, painel do herói, habilidade, barras e modais, sem mudar combate. Ajustar conteúdo/margens às áreas existentes e testar leitura com texto real. U14 tem fill independente; botões de ajuda/velocidade continuam com texto gerado pelo Godot.
4. S-I04 — integrar Q02/Q03/Q05/Q07–Q10 no Quartel: cartões de herói/fase, pips, medalhas, categorias e resultado. A adaptação de ItemList para cartões é a maior mudança de apresentação: preservar seleção, desbloqueios, foco por controle, detalhes e nomes. Definir janela de retrato compatível com a altura; não forçar placa 96×96 num cartão de 72px.
5. S-I05 — adaptar somente N01 ao consumer existente npc_reaper_barqueiro, verificando escala e estado idle. Manter N02–N10 em reserva de arte: nenhum novo chefe, evento, mecânica ou consumer nesta proposta. N11 reutiliza mímico. V10 sprite permanece retido até plano específico de compatibilização com as folhas do herói.
6. S-I06 — importação Godot, checks relevantes de assets/animação, run_all, auditoria do projeto, capturas antes/depois e preparação de playtest visual. Registrar falhas herdadas separadamente. Dono julga leitura, navegação e aparência no jogo; não presumir esse aceite do aceite das fontes.

## Entradas e saídas

Entradas: recibo visual-acceptance.json (125 fontes aceitas), prepared/ (158 derivados), audit.json e jobs nesta pasta; consumers PC ui/offer_card.gd, ui/hud.gd, ui/hero_panel.gd, ui/ability_slot.gd, ui/menu.gd e componentes de resultado/tooltip existentes; data/stage_events.json e data/interaction_anims.json para N01. Conferir paths reais na execução, sem criar consumer apenas porque um nome foi sugerido.

Saídas esperadas: mudanças de apresentação e referências a PNGs preparadas no projeto PC, manifesto de admissão e evidência de testes/capturas. Não portar para a worktree histórica automaticamente. Não alterar IDs, saves, lore, balanceamento ou mecânicas. Não instalar dependências, promover CANON, publicar build ou commitar/push sem solicitação própria.

## Aceite e recuperação

Critérios: PNGs importados, recursos resolvidos, contratos de dimensão/margem, nenhuma regressão nova nos checks, seleção/controle e conteúdo legíveis nas capturas. Teste humano no jogo fica pendente até realizado. Preservar snapshots/hash dos arquivos substituídos e baseline dos consumers para desfazer seletivamente este conjunto, sem reset amplo.

Impacto em checkpoints: preparação isolada termina; abre-se uma frente de integração PC, mantendo PLAN-103 e os demais planos. A aprovação visual recebida abrange as fontes, não resolve automaticamente os ajustes de layout ou os usos de novos personagens. A execução desta ampliação de escopo requer aprovação do plano de integração; nenhuma autorização de novos eventos está incluída.
