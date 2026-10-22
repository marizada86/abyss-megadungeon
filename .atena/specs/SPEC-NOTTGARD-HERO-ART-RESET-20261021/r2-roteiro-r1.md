# R2 — roteiro de geração (Durvall, Korrak, Erik) · r1 · 2026-10-22

Status: DRAFT. R2 autorizado pelo dono em 2026-10-21 ("Autorizo o R2"). Escopo: **33 imagens** (Durvall 12, Korrak 9, Erik 12), geradas por você no ChatGPT. A Atena só mede e monta; nada entra no jogo e nada vira CANON sem seu aceite.
Prompts completos: `.atena/generated/hero-art-reset-20261021/prompts/` (`durvall.md`, `korrak.md`, `erik.md`). Contrato: `animation-contract-r1.md`.

## Como trabalhar cada herói

1. **Uma conversa nova por herói.** Não misture heróis na mesma conversa.
2. **Anexe as 6 imagens da lista "Anexar" do arquivo do herói**, nessa ordem (4 vistas CANON do Vault + 2 imagens de estilo do jogo). Em cada imagem nova da mesma conversa, anexe de novo só se o ChatGPT perder o rosto ou o traje.
3. **Ache a imagem pelo nome do arquivo** (a numeração dentro de `durvall.md` segue a ordem e, se, ne, s, n, e não a ordem de geração desta tabela) e **cole o prompt** do bloco de texto dela (o conteúdo do bloco ```text```, inteiro). Não resuma e não traduza.
4. **Salve o PNG como veio**, sem editar, em `F:\dev\abyss-megadungeon\assets_incoming\hero-r2\<herói>\` com o nome da tabela. Se refizer, `_v02`, `_v03` (no máximo 3 tentativas por imagem; guarde todas).
5. **Depois da primeira imagem aprovada por você (o idle), anexe-a também** nas imagens seguintes da mesma conversa como referência de escala e traje.
6. **Não peça** "sprite sheet", "animação", "grade" nem "6 quadros": o contrato proíbe, é o que deu errado nas tiras antigas.

## Ordem

### Durvall (12 imagens; fundo magenta; oeste real)

| # | Arquivo | Observação |
|---|---|---|
| 1 | `durvall_idle_se_v01.png` | **GATE 1, parte A** |
| 2 | `durvall_walk_se_v01.png` | **GATE 1, parte B** |
| | **PARE aqui e me avise.** Eu meço as duas e digo se segue. | |
| 3 | `durvall_walk_e_v01.png` | |
| 4 | `durvall_walk_ne_v01.png` | |
| 5 | `durvall_walk_s_v01.png` | A, P, B (não espelha) |
| 6 | `durvall_walk_n_v01.png` | A, P, B (não espelha) |
| 7 | `durvall_walk_w_v01.png` | oeste real |
| 8 | `durvall_walk_sw_v01.png` | oeste real |
| 9 | `durvall_walk_nw_v01.png` | oeste real |
| 10 | `durvall_attack_se_v01.png` | grade 2×2 |
| 11 | `durvall_active_se_v01.png` | grade 2×2 |
| 12 | `durvall_death_se_v01.png` | grade 2×2 |

### Korrak (9 imagens; fundo magenta; oeste espelhado)

Só comece depois do Durvall passar no gate 1 (a ordem é segura: o Korrak não depende do resto do Durvall).

| # | Arquivo |
|---|---|
| 1 | `korrak_idle_se_v01.png` |
| 2 | `korrak_walk_se_v01.png` |
| 3 | `korrak_walk_e_v01.png` |
| 4 | `korrak_walk_ne_v01.png` |
| 5 | `korrak_walk_s_v01.png` (A, P) |
| 6 | `korrak_walk_n_v01.png` (A, P) |
| 7 | `korrak_attack_se_v01.png` |
| 8 | `korrak_active_se_v01.png` |
| 9 | `korrak_death_se_v01.png` |

### Erik (12 imagens; fundo magenta; oeste real; **raspado**)

Mesma sequência do Durvall (idle, `walk_se`, `walk_e`, `walk_ne`, `walk_s`, `walk_n`, `walk_w`, `walk_sw`, `walk_nw`, attack, active, death), com `erik_` no nome. As referências do Erik mostram cabelo e barba: o prompt manda ignorar; confira em toda imagem que ele saiu **careca e sem barba**.

## Gate 1 (Durvall, imagens 1 e 2)

Quando salvar as duas, me diga só "mede o Durvall". Eu rodo o verificador e respondo com: veredito por critério (1 a 6), figuras encontradas, desvios de escala e de linha dos pés, diferença entre A, B e P, e pontos soltos.

- **Passa nos critérios 1 a 6:** você confere identidade e estilo (critérios 7 a 9, abaixo) e seguimos.
- **Reprova:** eu digo o que ajustar no prompt (nunca refaço em loop; máximo 3 tentativas por imagem). Se a fila de 3 figuras não se sustentar em 2 tentativas, adotamos o plano B (uma pose por imagem): eu regenero o pacote nesse formato antes de você gastar o resto.

### O que você confere à vista (critérios 7 a 9) no Durvall

- Pele cinza-azulada, cabelo branco longo e liso, orelhas pontudas, rosto severo.
- Armadura negra de placas em forma de folha, ombreiras com espinhos, grevas pontudas.
- Faixa vermelha rasgada na cintura com o pano pendurado do mesmo lado em todas as figuras.
- **Espada na mão direita, sem brilho.** Nenhum capacete, capa ou olhos brilhando.
- As três figuras da imagem são claramente a mesma pessoa, no mesmo tamanho e com as mesmas peças.
- Idle: as três figuras quase idênticas (só a respiração mexe).
- Caminhada `se`: A e B com pernas visivelmente opostas; P com a perna passando.

## Se o ChatGPT errar

| Sintoma | O que fazer |
|---|---|
| Figuras coladas ou mais/menos que o pedido | Refazer pedindo "exactly N figures with at least 140 px of empty background between them". |
| Fundo com gradiente, chão ou sombra | Refazer: "perfectly uniform flat pure magenta #FF00FF background". |
| Pose parecida demais entre as figuras (deslizando) | Refazer destacando o par de pernas: "legs clearly crossed apart" no contato. |
| Traje ou rosto deriva | Reanexar as 4 vistas CANON e o idle aprovado. |
| Rótulos, números, setas no desenho | Refazer; o prompt já proíbe. |
| Efeito mágico, brilho ou partículas | Refazer; o jogo desenha os efeitos. |

## Medir você mesmo (opcional)

O verificador roda fora do projeto, só lê a imagem. Para uma fila de 3 figuras com fundo magenta:

```bash
"F:/dev/abyss-megadungeon/Godot_v4.7.2-stable_win64.exe" --headless --script "F:/dev/abyss-megadungeon/.atena/generated/hero-art-reset-20261021/r2_check.gd" -- "F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall/durvall_walk_se_v01.png" magenta 3 walk
```

Tipos: `walk` (fila de 3, ou 2 em `s`/`n` de herói de espelho), `idle` (fila de 3), `grid` (2×2, 4 figuras). Saída: PASSA ou REPROVA e o motivo de cada critério. Ele não avalia identidade nem estilo.
