# Proporção, identidade e encaixe

## Separar causas

1. **Extração/canvas:** dimensões/células, transparência, cortes e padding inconsistentes. Corrigir extração/encaixe sem remodelar o personagem.
2. **Âncora/escala:** pivô/baseline muda ou escala diverge na importação/cena. Medir na escala alvo; bounding boxes variam naturalmente com pose.
3. **Pose/perspectiva:** encurtamento e silhueta variam legitimamente. Comparar poses compatíveis e referências apropriadas.
4. **Identidade/proporção:** cabeça, tronco, membros, roupa ou paleta mudam sem justificativa. Voltar à referência mestra; normalização de canvas não resolve.

## Candidato de ChatGPT

Tratar imagem gerada como candidato DRAFT, não sequência temporal já consistente. Usar identidade mestra, escala/canvas explícitos e poses-chave controladas. Conferir cada frame antes de admiti-lo. Solicitar inbetweens/correções delimitadas quando forem úteis; uma spritesheet completa em uma geração não garante coerência. Usar ferramenta de imagem disponível para gerar/editar quando autorizado, preservando fontes; não impor provedor novo.

## Registro mínimo

Versão/origem, canvas e célula, âncora/baseline, escala alvo, dimensões de referência comparáveis, tolerâncias do projeto, frames que falham e hipótese da causa. Sem artefato disponível não afirmar medidas nem correções. Inspeção de imagem não comprova importação/playback Godot.

Conferir orientação/pose somente quando o asset concreto precisar delas; isso não é gate universal de posição.
