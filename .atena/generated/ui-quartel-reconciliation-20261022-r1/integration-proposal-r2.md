# Integração restante de UI/HUD e Quartel — DRAFT r2

Revisão da proposta transferida r1 após inspeção do HEAD `02f8985` e reconciliação de 2026-10-22. Modo per-plan. Esta proposta é a decisão de escopo revisada; não presume que a autorização da conferência também aprovou layouts ainda não delimitados. Estado: AWAITING_REVISED_SCOPE_APPROVAL. Nenhuma execução de runtime nesta revisão.

## Objetivo e escopo

Concluir somente U09 (brilho de oferta), U11 (placa de preço), U17 (cronômetro), Q02/Q03 (cartões de seleção de herói/fase) e Q10 (ícones do resultado), usando as peças já aceitas e presentes. Preservar os demais usos existentes. Selecionar um herói no menu não implica modificar a arte/animação desse personagem.

Não reaplicar U13–U16, U18, U20/U21, Q05, Q08/Q09 nem N01: uso confirmado no checkout. U10/U12/U19 e Q07 continuam retidos. Sem novas imagens, abas, medalhas de progressão, eventos, mecânicas, NPCs, balanceamento, mudanças de IDs/saves/lore ou promoção a CANON. V10 e todos os planos dos heróis permanecem fora do escopo.

## Execução proposta, seis etapas

1. **S-UI01 — baseline e recuperação.** Conferir novamente HEAD, diff e hashes; capturar as telas anteriores em perfil sintético a 1280×720 e 1920×1080. Guardar cópias dos arquivos que serão alterados e manifesto de alterações antes da primeira edição. A conferência técnica já feita é evidência inicial; não substitui esse baseline visual.
2. **S-UI02 — ofertas U09/U11.** Aplicar brilho de fundo preto em composição aditiva sem cobrir texto ou capturar mouse. Preservar foco, hover, bloqueio, raridade e impacto reduzido. Usar a placa de preço com texto real, cor de saldo insuficiente e variantes normal/compacta, incluindo seis ou mais ofertas. Não aplicar a textura U10.
3. **S-UI03 — topo do HUD U17.** Integrar cronômetro e ajustar a posição da fase conforme dimensões reais. Os 8 px sugeridos na fila são hipótese inicial: medir cronômetro, nome longo de fase/modificador, ícone da regra e chefe juntos. Preservar o significado do relógio e o espaço de combate; sem reorganizar o painel do herói ou a lista de armas.
4. **S-UI04 — Quartel Q02/Q03.** Usar cartões em listas roláveis com nome legível, estado bloqueado/desbloqueado e foco/seleção distintos. Preservar ordem, seleção ao atualizar o menu, desbloqueios, detalhes, filtro de fases QA-only e bloqueio de JOGAR. Dimensionar retrato para o cartão de 72 px; não impor a placa de 96 px sem caber. Verificar mouse, teclado e controle: cima/baixo, esquerda/direita entre heróis/fases/JOGAR, confirmação e rolagem até itens fora da tela. Manter códex e HQs com seu comportamento existente.
5. **S-UI05 — resultado Q10.** Exibir os seis ícones (tempo, nível, abates, chefes, moedas e profundidade) ao lado de rótulos e números existentes. Manter multiplicador, recompensa parcial, Marcas do Abismo, conquistas e rolagem. A arte é apresentação, não alteração do cálculo da recompensa.
6. **S-UI06 — validação e entrega.** Importação, testes relevantes e suíte completa, auditoria do projeto, verificação de controle e capturas antes/depois nas duas resoluções. Comparar qualquer falha com o baseline, inclusive erro ambiental de certificados já observado. Preparar avaliação visual humana com roteiro e manifesto de admissão; só registrar aceite de tela quando o dono o realizar.

## Critérios e recuperação

Nenhuma regressão nova de compilação, conteúdo, seleção, bloqueios ou foco. Nenhum número/rótulo removido ou sobreposto nas capturas. Usar perfil/diretórios sintéticos com isolamento comprovado antes do primeiro carregamento. Reverter apenas o conjunto registrado por arquivo e hash se uma etapa falhar; nunca reset amplo. Preservar outros trabalhos.

Arquivos candidatos: `ui/offer_card.gd`, `ui/hud.gd`, `ui/hud_art.gd`, `ui/hud.tscn`, `ui/menu.gd`, `ui/menu.tscn`, eventual componente local de seleção de cartões e verificações funcionais afetadas. Nenhuma necessidade de recopiar as 62 peças U/Q já conferidas no runtime.

A origem anterior permanece histórica, sem sincronização de volta. Se surgir mudança comum que exija outra versão ativa, interromper esse item para definir destino e registrar a portagem antes de alterar tal versão. Não instalar dependências, exportar build, commitar ou publicar nesta autorização.

## Relação com checkpoints

A revisão r1 fica preservada em `../asset-preparation-20261021-r1/integration-proposal.md`, com o checkpoint original `S-I01/INTEGRATION_SCOPE_APPROVAL_PENDING`. Este r2 define IDs S-UI próprios para não reaproveitar S-I05 (antiga integração de N01, já realizada). Após aprovação desta revisão, abrir S-UI01 e registrar a substituição do roteiro r1, sem marcar artificialmente suas seis etapas como executadas.
