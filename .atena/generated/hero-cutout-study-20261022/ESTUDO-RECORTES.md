# Estudo de recortes (boneco articulado) para a caminhada: preparo (2026-10-22, r1)

Status: DRAFT. **Nada foi gerado.** Preparado por autorização do dono em 2026-10-22 ("prepare o estudo de recortes (opção 3) com uma geração. Nada gerado sem eu autorizar"). Origem: o E1 do Durvall walk SE foi reprovado e mostrou que o ciclo de três desenhos não alterna as pernas (`hero-r2-durvall-walk-se-r3-E1-20261022/E1-RESULTADO.md`). Seis tentativas de caminhada pelo ChatGPT, quadro a quadro, não entregaram a troca de pernas.

## 1. A ideia

Em vez de pedir ao modelo cada quadro da caminhada, pedir **as partes do corpo** (um kit de 10 peças) e **montar o ciclo no motor com rotações**. A troca de pernas deixa de depender do modelo: o motor gira a coxa e a canela de cada perna com ângulos que eu controlo, e o ritmo e a amplitude viram parâmetros, não sorte.

O que o modelo faz bem (uma peça por célula, parada, de pé) é o que se pede; o que ele não faz (trocar qual perna está à frente) sai do cálculo.

## 2. O que já está pronto e validado (sem geração)

| Item | Arquivo | Estado |
|---|---|---|
| Montador de recortes | `rig_walk_preview.gd` | Funciona: esqueleto fixo (quadril, torso, cabeça, cabelo, faixa, dois braços, duas pernas em coxa e canela), pivôs e encaixes por parte, ciclo A, P1, B, P2 com a troca de pernas por construção, pé de apoio plantado automaticamente, amplitude como parâmetro |
| Kit sintético de formas simples | `rig_synthetic_kit.gd`, `kit-sintetico/` | Gerado por script, só para validar a mecânica (a perna do lado da câmera é clara com joelheira; a distante é escura) |
| Prévias em GIF | `DEMO_rig_sintetico_amplitude_100.gif` e `_060.gif`, `make_rig_preview.ps1` | 16 quadros, painel grande e painel como o jogo mostra (64 px ampliado 4×) |
| Guia de layout do kit | `make_kit_layout_guide.gd`, `assets_incoming/hero-r2/guides/kit_layout_guide_5x2.png` | Grade 5×2 de silhuetas cinza |
| Prompt do kit | `prompt_kit_durvall_se_E3.md` | Pronto, **não executado** |

Conferi a mecânica nos quatro quadros-chave: a perna clara vai à frente em A, é o apoio em P1, vai para trás em B e passa levantada em P2, e a escura faz o inverso. **Isso valida a mecânica, não a arte:** as formas são blocos.

## 3. A geração do estudo (1 geração, ainda não feita)

**E3:** uma imagem 1536×1024 com **10 partes** do Durvall SE, em grade 5×2 de células de 307×512:

| Linha 1 | Linha 2 |
|---|---|
| 1 cabeça · 2 cabelo de trás · 3 torso · 4 pano da faixa · 5 braço perto com a espada | 6 braço longe · 7 coxa perto · 8 canela e bota perto · 9 coxa longe · 10 canela e bota longe |

Anexos (5): vistas CANON de frente, esquerda e costas; o idle aprovado; o guia de layout. Cada parte desenhada **completa e reta**, na escala do idle, com cerca de 12 px a mais além da articulação para sobrepor ao vizinho; **as pernas sem a espada cruzando**. É o que resolve o problema que a espada causa na imagem inteira: a espada vive só na peça do braço.

## 4. Critérios de aceite do kit (medidos por mim; identidade e estilo, por você)

Limites PROVISÓRIOS, a calibrar com o primeiro kit:
1. **10 componentes**, um por célula, inteiros, sem encostar na célula.
2. **Escala:** coxa mais canela com bota entre 405 e 495 px (45 a 55% de 900); coxa e canela com comprimentos até 25% diferentes.
3. **Torso:** largura até ±15% da do idle na mesma escala.
4. **Membros retos:** altura da peça pelo menos o dobro da largura.
5. **Sem espada nas pernas** e pernas completas, sem corte.
6. **À vista:** mesma identidade e render do idle; as pontas das articulações continuam para a sobreposição; parte distante em sombra mais funda mas com o mesmo desenho.

## 5. Como eu avalio depois da geração (sem custo de geração)

1. Medir as 10 partes e derivar o `kit.json` (pivôs e encaixes por proporção da caixa de cada parte, ajustados à vista).
2. Montar a prévia animada com o kit real: amplitude cheia (1,0) e baixa (0,6, parecida com a caminhada piloto).
3. Você olha o GIF no painel do jogo (64 px). A pergunta do estudo: **a troca de pernas lê como passos alternados, e a arte sobrevive à rotação** (costuras, membros achatados, buracos)?

## 6. O que o estudo responde e o que não

Responde: se um kit de partes gerado pelo ChatGPT é utilizável; se a caminhada montada lê bem a 64 px; se a espada separada resolve a leitura das pernas.

**Não responde:** as outras quatro direções (`e`, `ne`, `s`, `n`) e o oeste real; o custo de engenharia no motor; os heróis assimétricos.

## 7. Riscos

1. **O modelo não segue o layout ou desenha as partes cortadas e costuradas.** Peças parciais, peças inteiras repetidas ou células trocadas invalidam o kit. É o risco maior, com uma só geração para testá-lo.
2. **Costuras e rotação em vista três-quartos:** girar no plano da tela uma peça desenhada em três-quartos é uma aproximação; em ângulos pequenos e a 64 px deve passar, em ângulos grandes pode parecer chapado.
3. **Partes escondidas:** a perna de trás tem de vir completa (o prompt pede); se vier com recorte do que a perna da frente cobriria, aparece buraco ao girar.
4. **Escala de trabalho:** um kit por direção. Para os 12 heróis seriam cerca de 5 kits por herói (uma imagem por direção, como a caminhada), mais engenharia.
5. **Engenharia no motor (R4, com aprovação e testes):** um nó de boneco articulado para a caminhada, que convive com o `AnimatedSprite2D` do idle, ataque e morte; os pés e a altura têm de coincidir nas transições. Hoje nada disso existe no jogo.
6. **Mistura de estilos no Durvall** (registrada no roteiro r4): a caminhada piloto atual usa a arte antiga.

## 8. Orçamento e decisões

- **Gerações do experimento de caminhada:** total 4, usadas 1 (E1), **3 restantes**. O E3 usa 1; sobrariam 2.
- **Sem autorização de geração agora.** Quando você autorizar, o passo a passo é o mesmo dos outros: conversa nova, 5 anexos, colar o prompt, salvar como `durvall_kit_se_E3_v01.png`, dizer "mede o kit".
- Decisões suas, depois do resultado: seguir com o rig para as demais direções, voltar à caminhada piloto, ou outra rota.

## 9. Comandos (para reproduzir a mecânica; sem gerar nada)

Prévia do kit sintético, uma linha:

```bash
powershell -NoProfile -File "F:/dev/abyss-megadungeon/.atena/generated/hero-cutout-study-20261022/make_rig_preview.ps1" -Kit "F:/dev/abyss-megadungeon/.atena/generated/hero-cutout-study-20261022/kit-sintetico/kit.json" -OutGif "F:/dev/abyss-megadungeon/tmp/hero-r2-gate1-isolated/rig_demo.gif" -Amplitude 1.0
```

Rode sem `--path`. As ferramentas só leem o kit e escrevem os quadros e o GIF na saída indicada.
