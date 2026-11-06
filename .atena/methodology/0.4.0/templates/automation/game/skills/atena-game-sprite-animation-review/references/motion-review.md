# Revisão temporal de sprites

## Dados antes da conclusão

Identificar clip/versão, ordem de frames, duração por frame, loop, estado de input, deslocamento do personagem e playback. Separar medição disponível de hipótese; simples imagem estática não demonstra fluidez.

## Diagnóstico por sinal

| Sinal | Examinar | Possível ação delimitada |
| --- | --- | --- |
| Pés deslizam | Fase de contato versus deslocamento do corpo/mundo; ciclos por distância | Ajustar deslocamento ou timing a partir de medição; rever contato quando o desenho falha |
| Corpo pulsa/deforma | Invariantes de identidade entre poses compatíveis | Encaminhar sprite-fit antes de suavizar playback |
| Loop salta | Último→primeiro, âncora e ritmo; não apenas posição do pé | Rever extremos/durações e baseline |
| Movimento rígido | Poses-chave, espaçamento, peso, antecipação/recuperação | Melhorar intenção de poses e timing sem impor realismo |
| Transição trava/reinicia | Entrada/saída do estado, reset contínuo, interrupções | Inspecionar controller e testar cenário reproduzível |
| Frames intermediários borram | Desenho/extração/filtering versus frame pacing | Isolar causa antes de aumentar FPS |

## Godot existente

Inspecionar versão, AnimatedSprite2D/SpriteFrames ou outra estrutura realmente usada. Verificar timing por frame, seleção de animação, reinício, física/interpolação e importação/filtering apenas onde o cenário indicar. Não trocar arquitetura sem motivo nem assumir configuração. Use engine/captura local somente quando disponível/autorizada.

## Evidência

Clip/build/cenário, hipóteses isoladas, original/candidato, contato ou transição examinados, checks reais e limitações. Prévia fora da engine ajuda revisão temporal, mas não comprova integração. Sem pessoa avaliando, sensação/fluidez subjetiva permanece pendente.
