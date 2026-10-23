# R2 — roteiro r3: Durvall walk SE, experimento E1 (2026-10-22)

Status: DRAFT. Preparado por autorização do dono em 2026-10-22. **Nada foi gerado.** Substitui o `r2-roteiro-r2.md` para o Durvall walk SE; o resto do R2 (Korrak, Erik, demais imagens do Durvall) continua parado até o E1 ser aceito.

Documentos: contrato `animation-contract-r3.md` · prompt `.atena/generated/hero-art-reset-20261021/prompts-r3/durvall_walk_se_E1.md` · guia `assets_incoming/hero-r2/guides/pose_guide_walk_se_A_P1_P2_r3.png` · verificador `r2_check_v3.gd` · prévia `make_walk_preview.ps1`.

## Onde estamos

- Idle SE do Durvall: v01 aprovado, é a referência (anexo 4).
- Walk SE: cinco tentativas anteriores reprovadas (2 no formato r1, 3 no r2), preservadas. O formato r3 está **intocado**.
- Orçamento do experimento: **4 gerações** (E1 uma; E2 até três). Usadas: **0**.

## O que fazer: E1 (uma geração)

1. **Conversa nova** no ChatGPT.
2. **Anexe 5 arquivos, nesta ordem:** vista CANON de frente, de perfil esquerdo e de costas do Durvall (`...\CHAR-015\historico-S01-S09\r01`), o **idle aprovado** (`durvall_idle_se_v01.png`) e o **guia de pose** (`pose_guide_walk_se_A_P1_P2_r3.png`). Os caminhos exatos estão no arquivo do prompt. Nenhuma caminhada anterior.
3. **Cole o prompt** do bloco de texto de `durvall_walk_se_E1.md`, inteiro.
4. **Salve** como `F:\dev\abyss-megadungeon\assets_incoming\hero-r2\durvall\durvall_walk_se_r3_E1_v01.png`, sem editar.
5. Diga **"mede o E1 do Durvall"**. Não refaça sozinho.

A imagem deve ter **3 figuras em fila** (A, P1, P2), **sem o boneco do guia** e sem as cores vermelha e azul.

## O que conferir à vista antes de me chamar (opcional)

- **A:** passada larga; pés bem afastados.
- **P1 e P2:** os dois pés quase juntos; o pé levantado **ao lado do tornozelo de apoio**, na altura da canela, **joelho à frente**; nada de chute para trás nem de passo alto à frente.
- P1 e P2 diferentes entre si: em P1 o pé levantado é o de trás (quase escondido); em P2, o da frente (visível).
- O guia não "vazou" para a imagem.

## O que eu faço quando você disser "mede"

1. Verificador v3 (tipo `walk3p`) com recorte das pernas e a prévia GIF (A, P1, A, P2) alinhada pelo tronco, com a versão alinhada pela caixa ao lado para comparar.
2. Resposta com: critérios 1 a 4 e 5a, 5d (objetivos); recorte das pernas e prévia para o 5c (à vista); o que mudaria no prompt se falhar.
3. **Nunca** aprovo a passagem só pelo número.

Comando do verificador (eu rodo; você pode rodar), uma linha:

```bash
"F:/dev/abyss-megadungeon/Godot_v4.7.2-stable_win64.exe" --headless --script "F:/dev/abyss-megadungeon/.atena/generated/hero-art-reset-20261021/r2_check_v3.gd" -- "F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall/durvall_walk_se_r3_E1_v01.png" magenta 3 walk3p "F:/dev/abyss-megadungeon/tmp/hero-r2-gate1-isolated/E1_v01.json" --crops "F:/dev/abyss-megadungeon/tmp/hero-r2-gate1-isolated/E1_v01_pernas.png"
```

Rode sem `--path`. Saída: 0 PASSA, 3 PASSA_COM_ITENS_A_VISTA (o esperado numa caminhada boa), 1 REPROVA. Leia o `verdict` do JSON.

## Depois do E1

| Resultado | O que acontece |
|---|---|
| Você aceita (objetivos passam e a prévia lê como passos alternados) | O contrato r3 vira regra para a caminhada; preparo os guias de `e`, `ne`, `s`, `n` (e oeste real) e o pacote r3 do Durvall; peço sua autorização para seguir |
| O resultado ignora o guia ou a passagem sai errada | Você decide: **E1 de novo** com ajuste de prompt (conta no teto) ou **E2** (preparo o prompt; até 3 imagens, uma pose cada, editando o idle). Teto: 4 gerações no total |
| Teto esgotado sem aceite | Volto a você com a medição e a alternativa F: tiras piloto do Durvall como caminhada provisória |

## Preservado

Idle v01 aprovado; as cinco caminhadas anteriores, PNGs, JSONs e hashes; `animation-contract-r1.md`, `-r2.md`, `r2_check.gd`, `r2_check_v2.gd`, `prompts/`, `prompts-r2/`; os demais planos. Sem integração, commit, push ou CANON.
