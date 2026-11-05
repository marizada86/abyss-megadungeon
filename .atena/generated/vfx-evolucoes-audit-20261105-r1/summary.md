# Auditoria técnica das 7 fontes VFX de evolução (VE01–VE07)

Data: 2026-11-05. Estado: DRAFT. Somente leitura: nenhuma fonte, runtime, `plan.yaml` ou asset foi alterado. Medições brutas em `audit.json`; script em `audit_vfx_evolucoes.gd`.

Reproduzir (projeto Godot sintético, sem autoload nem save real; `project.godot` com apenas `config_version=5` e `config/name`):

```
Godot_v4.7.2-stable_win64.exe --headless --path <projeto_sintetico> -s res://audit.gd -- <pasta_sources> <saida.json>
```

## Método

- Fundo preto sem alpha: brilho do pixel = max(R,G,B). Limiares: 16 ("brilho", inclui o halo fraco) e 48 ("núcleo").
- Grades: 4×2 com células 384×512 (VE01–VE04) e 3×2 com células 512×512 (VE05–VE07). Ordem de leitura por linha.
- Métricas por célula: caixa útil, margens, centroide ponderado, raio máximo do núcleo, energia (soma do brilho). Entre quadros: diferença média e energia. Costuras: pixels do núcleo a menos de 3 px das linhas da grade.
- Régua de margem 8,2% (21/256) copiada do lote 3 e **apenas informativa**: os quadros finais serão reescalados.

## Resultados gerais

- As 7 folhas medem 1536×1024, RGB sem alpha. Fundo de verdade preto (média 0,08–0,13; máximo 1), então a chave de preto é limpa.
- **Nenhum pixel do núcleo cruza ou toca as costuras** da grade (0 em todas as folhas): as células são separáveis pelas grades pedidas.
- Nenhuma célula toca a borda da sua célula. A menor margem de halo é 18 px (VE04, quadros 2 e 3 de voo, lado esquerdo).

## Por fonte

| Fonte | Tipo | Maior caixa útil (L×A) | Escala uniforme p/ 214 px* | Observação principal |
|---|---|---|---|---|
| VE01 selo | projétil 4+4 | 312×322 | 0,665 | Voo praticamente estático: diferença entre quadros 0,004–0,012; largura varia 2,4%. Pico de impacto no 2º quadro; último impacto a 4% do pico. Quadro de impacto 7 (idx 6) com halo a 7,3% de margem. |
| VE02 cajado | projétil 4+4 | 247×230 | 0,866 | Voo com mais variação (largura 15,5%; borda esquerda anda 78→105 px; centroide x +7 px). Impacto começa pequeno (105×98) e cresce até 247×228. Último impacto a 2,5% do pico. |
| VE03 lâmina | projétil 4+4 | 287×314 | 0,682 | Voo estável (largura 3,5%). Massa pesada à direita: centroide x ≈ 244 contra centro da caixa ≈ 174. |
| VE04 memória | projétil 4+4 | 307×273 | 0,697 | Voo estável no centroide (x ≈ 202), largura varia 9,8%. Halo do voo a 4,7–5,2% da margem esquerda (18–20 px) nos quadros 2 e 3. |
| VE05 vigília | pulso único | 432×408 | 0,495 | Energia sobe até o quadro 4 (idx 3) e cai; início a 12% e fim a 6% do pico. Salto brusco do quadro 3→4 (diferença 0,113; energia 2,6→5,95). No pico o núcleo tem 7,6% de margem (quase ocupa a célula). |
| VE06 tentáculos | laço | 431×262 | 0,497 | Energia estável entre quadros (3,73–4,00; +7%). **Fecha o laço:** diferença do último para o primeiro 0,026 contra média entre vizinhos 0,031 (razão 0,86). Margens esquerda/direita **simétricas** (~7,2–8,4%), não só a direita. Base elíptica deslocada para baixo: centroide y ≈ 305 contra centro 256. |
| VE07 ampulheta | pulso único | 379×380 | 0,563 | Pico no quadro 4; início a 17% e fim a 1% do pico (último quadro quase invisível, 0,05M). Margens do núcleo ≥ 10,4%. |

\* Escala que faz a maior caixa útil da folha caber em 214 px (quadro final de 256 com margem de 21 px). Escala a decidir na preparação: por folha (normaliza o tamanho aparente) ou única (preserva a proporção entre armas).

## Pendências do plano e o que a medição mostra

- **Margem direita da VE06 parecer menor (nota do handoff):** não confirmada. As margens são aproximadamente iguais dos dois lados (~7%). O que existe é margem apertada nos dois lados (célula 512 com 431 px de largura); resolve-se com a escala da preparação.
- **Continuidade do laço (VE06):** o fechamento é plausível pela métrica estática (razão 0,86). Não substitui teste de animação em jogo.
- **Voo "com variação sutil":** confirmado. VE01 praticamente não anima (0,004–0,012 entre quadros); VE02 é a que mais anima.
- **Escala e pivô dos projéteis:** o centroide fica deslocado do centro da caixa útil (VE01 220 vs 183; VE03 244 vs 174), ou seja, a massa está do lado direito. O pivô não pode ser o centro da caixa; precisa vir da ponta/cabeça de cada projétil. Verticalmente os voos ficam centrados (centroide y 244–255 para centro 256).
- **Pulsos:** usar uma única escala para os 6 quadros (o raio no pico é ≈ 217 px em VE05 e ≈ 206 px em VE07, medidos como o ponto mais distante do centro do núcleo).
- **Impactos:** crescem e desvanecem; não normalizar quadro a quadro.

## Limites

- Medidas estáticas por quadro: não provam fluidez, ritmo nem aparência em jogo. Falta teste de animação.
- Não medi cor, saturação, nem a composição aditiva sobre o chão real. O limiar 48 do núcleo é uma escolha de medição.
- Nenhuma preparação, recorte, normalização ou integração foi feita. A decisão de escala, pivô e recorte é da etapa seguinte.
- Pixel a pixel, a diferença entre quadros usa amostragem de 1 a cada 4 px.
