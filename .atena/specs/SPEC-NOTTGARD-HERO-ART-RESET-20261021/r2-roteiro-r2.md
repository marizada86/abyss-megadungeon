# R2 — roteiro de geração, revisão 2 (2026-10-22)

Status: DRAFT. Substitui `r2-roteiro-r1.md` a partir do gate 1 reprovado do Durvall. Contrato: `animation-contract-r2.md`. Prompts: `.atena/generated/hero-art-reset-20261021/prompts-r2/`. Verificador: `.atena/generated/hero-art-reset-20261021/r2_check_v2.gd`. Autorização do dono (2026-10-22): "Aprovo as correções ... Não gere nada ainda; me diga quando eu puder tentar o walk se do Durvall de novo."

## Onde estamos

- **Idle SE do Durvall:** o v01 está aprovado visualmente por você e continua como referência. Não refaz.
- **Walk SE do Durvall:** as duas tentativas do formato antigo (v01, v02) ficam preservadas e **não contam** para o formato novo. O formato novo (4 figuras em grade 2×2: A, P1, B, P2) tem **3 tentativas**, ainda **0 usadas**.
- Nada mais foi gerado. Korrak e Erik esperam o Durvall passar.

## Próxima ação sua: walk SE do Durvall, formato novo

1. **Abra uma conversa nova no ChatGPT.** Não reaproveite a conversa das duas tentativas: ela já viu a caminhada reprovada e tende a copiá-la.
2. **Anexe 5 arquivos, nesta ordem** (o limite da ferramenta é 5; o contrato r2 já respeita isso):
   1. `F:\dev\nottgard-vault\output\referencias-personagens\CHAR-015\historico-S01-S09\r01\durvall-front-candidate-v01.png`
   2. `...\CHAR-015\historico-S01-S09\r01\durvall-left-v01.png`
   3. `...\CHAR-015\historico-S01-S09\r01\durvall-back-v01.png`
   4. `...\CHAR-015\historico-S01-S09\r01\durvall-right-v01.png`
   5. `F:\dev\abyss-megadungeon\assets_incoming\hero-r2\durvall\durvall_idle_se_v01.png` (o idle aprovado)
   **Não anexe nenhuma caminhada** (nem a v01 nem a v02).
3. **Cole o prompt** do bloco `durvall_walk_se_r2_v01.png` em `.atena/generated/hero-art-reset-20261021/prompts-r2/durvall.md` (é o bloco 3), inteiro.
4. **Salve o PNG, sem editar, como** `F:\dev\abyss-megadungeon\assets_incoming\hero-r2\durvall\durvall_walk_se_r2_v01.png`. O nome tem `_r2` de propósito: assim não sobrescreve o `durvall_walk_se_v01.png` que você aprovou. Se refizer: `_r2_v02`, `_r2_v03` (no máximo 3).
5. Me diga "mede o walk r2 do Durvall".

O formato mudou: a imagem deve ter **4 figuras em grade 2×2** (A no canto superior esquerdo, P1 no superior direito, B no inferior esquerdo, P2 no inferior direito), e não mais uma fila de 3.

## O que você confere à vista no walk r2 (antes de eu medir)

O que mais importa, porque foi o que falhou:

- **Figura 1 (A) e figura 3 (B) com pernas opostas.** Na figura 1 a bota do lado da câmera está à frente; na figura 3 ela está **atrás do corpo** e a bota do outro lado está à frente. Se as duas figuras mostram a mesma bota à frente, é cópia: refazer.
- **Figura 2 (P1) e figura 4 (P2) diferentes.** Na 2 o pé levantado é o de trás, quase escondido; na 4 o pé levantado é o do lado da câmera, bem visível e à frente da perna de apoio.
- Braço da espada firme nas quatro; o outro braço balança do lado oposto à perna da frente.
- Identidade e estilo como na v01 aprovada; faixa vermelha, espada na mão direita, nenhum brilho.

## O que eu faço quando você disser "mede"

1. Rodo o verificador v2 com o ruído de "mesma pose" do idle v01 aprovado (`gate1-diagnosis-20261022/v2-idle-v01.json`) e gero o recorte das pernas.
2. Olho os recortes (A, B, P1, P2) junto com você: o item 5b (A diferente de B) **nunca é aprovado só pelo número**; ele só vira PASSA com a imagem à vista.
3. Respondo com o veredito por critério e, se reprovar, o que mudar no prompt.

Comando (eu rodo; você pode rodar também), uma linha:

```bash
"F:/dev/abyss-megadungeon/Godot_v4.7.2-stable_win64.exe" --headless --script "F:/dev/abyss-megadungeon/.atena/generated/hero-art-reset-20261021/r2_check_v2.gd" -- "F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall/durvall_walk_se_r2_v01.png" magenta 4 walk4 "F:/dev/abyss-megadungeon/tmp/hero-r2-gate1-isolated/walk_se_r2_v01.json" --noise-from "F:/dev/abyss-megadungeon/.atena/generated/hero-r2-durvall-gate1-diagnosis-20261022/v2-idle-v01.json" --crops "F:/dev/abyss-megadungeon/tmp/hero-r2-gate1-isolated/walk_se_r2_v01_pernas.png"
```

Rode sem `--path`. Códigos de saída: 0 PASSA, 3 PASSA_COM_ITENS_A_VISTA, 1 REPROVA, 2 uso errado. Leia o `verdict` do JSON.

## Se a tentativa falhar

| Sintoma | O que fazer |
|---|---|
| B ainda copia A | Segunda tentativa com o reforço: "in figure 3 the NEAR boot must be BEHIND the body and the FAR boot in front; if figures 1 and 3 look the same, redraw figure 3". Terceira: plano B. |
| Menos ou mais de 4 figuras, ou coladas | Refazer pedindo "exactly 4 figures, each in its own quadrant, at least 60 px of empty margin". |
| Fundo com gradiente, chão ou sombra | Refazer: "perfectly uniform flat pure magenta #FF00FF". |
| Traje ou rosto deriva | Reanexar as vistas CANON e o idle aprovado. |
| Rótulos, setas, efeitos | Refazer; o prompt proíbe. |

**Plano B (depois da 3ª falha):** uma pose por imagem (cerca de 4× mais imagens), com a B pedida numa imagem à parte anexando a A. Eu regenero o pacote nesse formato antes de você gastar mais.

## Depois que o walk SE passar

Segue a ordem do roteiro r1 para o resto do Durvall (`e`, `ne`, `s`, `n`, `w`, `sw`, `nw`, ataque, ativa, morte), usando sempre os blocos de `prompts-r2/durvall.md` (caminhadas com sufixo `_r2`; as outras imagens têm o nome de antes). Depois Korrak (9) e Erik (12). Cada caminhada de herói assimétrico (Durvall, Erik) tem 4 figuras também em `s` e `n`.
