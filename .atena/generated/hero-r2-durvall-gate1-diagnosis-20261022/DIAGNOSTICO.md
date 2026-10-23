# Durvall R2 — diagnóstico do gate 1 (2026-10-22, r1)

Status: DRAFT. Nada foi gerado, integrado ou alterado no jogo. Os PNGs v01 e v02 e os JSONs da passagem estão intactos; o aceite visual das v01 ("aprovado, continue") foi preservado. Os derivados desta análise (chave de fundo, sobreposição, painel de escala) ficaram no scratchpad e só os leves foram copiados para esta pasta, identificados. Scripts: `diag.gd`, `diag2.gd`, `diag3.gd` (Godot headless fora do projeto, sem save e sem `res://`).

Pergunta do dono: "achei a movimentação horrível". A reprovação técnica do gate foi por halo e pontos soltos. **Esses dois não explicam a movimentação ruim.** O diagnóstico separa o que é defeito da imagem, o que é defeito do contrato (meu) e o que é defeito do verificador (meu).

## 1. Por que a movimentação é ruim: dois defeitos que se somam

### 1a. O contato B saiu igual ao contato A (defeito da geração)

O prompt pede em B "o exato oposto" de A (perna esquerda à frente, braço direito à frente). Nas duas tentativas as figuras 1 e 3 são a mesma pose: o mesmo pé à frente, o mesmo braço da espada, o mesmo pano.

| Medida (walk) | v01 | v02 | referência de ruído |
|---|---|---|---|
| Diferença de cor nas pernas, A × B | 39,5 | 42,4 | 36,7 / 31,6 (idle 1 × 3, mesma pose) |
| Diferença de cor nas pernas, A × P | 53,3 | 59,5 | |
| Diferença de silhueta, A × B | 16,9% | 13,8% | 5,3% / 4,6% |
| Diferença de silhueta, A × P | 38,4% | 34,3% | |

A e B ficam colados ao nível do ruído de "mesma pose" e longe de P. A sobreposição pelo pé (`OVERLAY_A_vermelho_B_ciano_walk_v02.png`) mostra as duas silhuetas praticamente coincidentes, deslocadas por poucos pixels. Ressalva honesta: em perfil, as silhuetas de dois contatos corretos também seriam parecidas, então a silhueta sozinha não prova nada; o que prova é o conjunto (silhueta + cor das pernas no nível do ruído + olhar as imagens).

A tentativa v02 usou a walk v01 como referência, o que provavelmente repetiu a cópia. É inferência; não testei.

### 1b. O ciclo A, P, B, P repete a mesma passagem (defeito do contrato, meu)

O contrato toca A, P, B, P com **um único desenho de passagem P**. Isso está errado para perfil e três-quartos:

- 1ª passagem: a perna que estava atrás passa à frente, com o pé levantado.
- 2ª passagem: a *outra* perna passa. Em perfil ela é a perna do lado da câmera (visível); na primeira passagem era a de trás (quase escondida).

Reusar P faz a perna que acabou de pousar à frente (em B) levantar logo em seguida, e o pé de trás ir até o meio e voltar para trás em vez de passar à frente. É o vai-e-volta que dá a aparência de mancar ou pular. **Mesmo com B perfeito, o ciclo seria ruim.** A economia de 3 desenhos só vale quando P é simétrico (de frente ou de costas); nas outras direções é preciso de 4 desenhos: contato A, passagem 1, contato B, passagem 2.

## 2. O que o verificador diz do halo e dos pontos soltos (defeito do verificador, meu)

### Halo (critério 2): a métrica era inatingível

Meu critério 2 contava, na imagem bruta, os pixels de borda a menos de 2,2 × a tolerância da chave. Essa faixa é exatamente a que o `asset_prep` já corrige no recorte (alfa proporcional e remoção do rosa). Qualquer imagem com antialiasing reprova. O teste sintético tinha bordas duras, por isso nunca acusou o problema.

Medido depois de aplicar a mesma lógica de recorte do `asset_prep` (cópia em `diag.gd`), pixels com resíduo magenta por profundidade a partir da borda:

| Profundidade (px) | idle v01 | idle v02 | walk v01 | walk v02 |
|---|---|---|---|---|
| 1 (anel externo) | 72,0% | 54,0% | 68,4% | 56,9% |
| 2 | 15,6% | 7,0% | 9,3% | 7,7% |
| 3 | 7,4% | 5,2% | 3,7% | 5,0% |
| 4 a 6 | 4,9 → 2,0% | 5,9 → 2,7% | 2,3 → 0,7% | 3,7 → 1,7% |

O resíduo está quase todo no anel externo de 1 px; de 3 a 6 px fica em poucos por cento, no nível de cores legítimas (orelha, tecido, a própria faixa). A v02 está mais limpa que a v01 no idle e equivalente no walk; no painel a 400 px a v01 mostra uma franja rosada no cabelo que a v02 não mostra. **No tamanho em que o jogo mostra o sprite, não há halo visível** (`HALO_escala_jogo_v01_v02.png`: 400 px e 64 px ampliados 6×, sobre piso escuro e claro).

Conclusão: o critério 2 em 35 a 50% era artefato da métrica, não defeito das imagens. Todas ainda têm resíduo no anel externo; é o que o recorte e a redução já tratam. Não flexibilizei limite para aprovar nada: proponho trocar a **definição** do critério (seção 4), mantendo o rigor.

### Pontos soltos (critério 6)

Contei componentes de até 120 px no tamanho de geração (v01: 48 a 56; v02: 17 no walk, 0 no idle). São fios de cabelo e franjas de pano soltos, inevitáveis em cabelo branco longo. Na escala do jogo (figura de ~400 px a ~60 px em tela) esses componentes ficam abaixo de 1 pixel. Proponho medir na escala de produção, não na de geração.

## 3. Outras observações (sem decisão agora)

- **Leitura a 64 px.** O render gerado é muito detalhado e realista, diferente do "pintura inspirada em pixel art" das referências do jogo. A 64 px o rosto, a armadura e as costuras somem; ficam a silhueta, o cabelo branco, a faixa vermelha e a espada (painel `HALO_escala_jogo_v01_v02.png`). Você aceitou a v01 à vista e isso se mantém; o painel é só para você ver como ela lê no tamanho real. Quando estilo é critério (8), as duas imagens de estilo do jogo ajudariam, mas a ferramenta aceitou cinco referências e o roteiro previa seis: o idle v01 recebeu quatro vistas CANON e Zuggtmoy (sem Malcanthet).
- **Escala dentro da fila.** O desvio de 3,5% a 3,8% no walk é o vaivém do corpo entre contato (mais baixo) e passagem (mais alto): é esperado. Não é defeito.
- **Código de saída (correção, 2026-10-22).** Eu tinha repetido da passagem que o verificador retorna 0 mesmo reprovando. **Testei e não se confirma:** o `r2_check.gd` v1 retorna 1 ao reprovar e 0 ao passar, com e sem `--path`. A passagem registrou 0, provavelmente por leitura do código de saída pelo PowerShell ou pelo pipe; não reproduzi. Continua valendo ler `verdict` no JSON.
- **Ambiente.** O `--path` do Godot apontou para `tmp/hero-r2-gate1-isolated`; os erros de certificados e `editor_settings` vêm de rodar com `--path`. Meus scripts rodam sem `--path`, fora de qualquer projeto, sem esses erros.

## 4. Mudanças propostas (nada aplicado)

### Contrato (`animation-contract-r1.md` → r2)

1. **Caminhada com 4 desenhos** nas direções `e`, `se`, `ne` (e `w`, `sw`, `nw` onde há oeste real): **A** contato (perna do lado da câmera à frente), **P1** passagem (a perna de trás passa, pé levantado), **B** contato oposto (perna do lado oposto à câmera à frente), **P2** passagem (a perna do lado da câmera passa). Toca A, P1, B, P2. Layout em grade 2×2 como ataque, com P1 de calibração.
2. Nas direções `s` e `n` de herói de espelho, continuam 2 desenhos (A e P1); B e P2 saem de `flip_x` de A e P1, o que é válido porque a vista é frontal ou traseira e o herói é simétrico.
3. **Linguagem do prompt: perna do lado da câmera e perna do lado oposto, braço do lado da câmera e braço do lado oposto.** "Direita" e "esquerda" são ambíguas em três-quartos; foi onde a geração falhou.
4. **Referências:** nas caminhadas, anexar as vistas CANON e o idle aprovado, **sem** a caminhada reprovada.
5. Contagem de imagens por herói não muda (cada direção continua sendo uma imagem). Os desenhos únicos da caminhada sobem de 13 para 16 por herói de espelho (A, P1, B, P2 em `e`, `se`, `ne`; A e P1 em `s` e `n`).

### Verificador (`r2_check.gd` → v2)

| Critério | Hoje | Proposta |
|---|---|---|
| 2 fundo | resíduo na imagem bruta, anel de antialiasing incluído | resíduo magenta a partir de 2 px de profundidade depois do recorte do `asset_prep`; limite a calibrar com as imagens aceitas |
| 6 pontos soltos | componentes ≤120 px na escala de geração | componentes na escala de produção (≈400 px de altura); só os que sobrevivem à redução |
| 5 caminhada | A e B contra P | **A × B nas pernas e P1 × P2 nas pernas, comparados com o ruído de "mesma pose" da mesma série** (hoje 31 a 37); exigir pelo menos 1,3× o ruído, valor provisório até haver um par correto aceito |
| exit code | já retorna 1 ao reprovar (verificado) | mantém; acrescenta 3 para "passa com itens à vista" |

O limite de 1,3× é um chute razoável até haver um par A/B correto; a calibração real sai da primeira imagem que você aceitar.

### Geração

O contador de tentativas: `walk_se` gastou 2 de 3 sob o contrato antigo. O formato muda (4 figuras, linguagem near/far, sem referência reprovada), então proponho tratar como novo formato com 3 tentativas, e **não gastar nenhuma antes de você aprovar** as mudanças acima. O idle v01 está aprovado e não precisa refazer (o desenho e a escala valem).

## 5. O que preservei

PNGs v01 e v02, JSONs, GIF e a pasta da passagem sem edição; aceite visual das v01; checkpoints de `plan.yaml` (acrescentei só o registro deste diagnóstico); `AGENTS.md` (portagem, sem commit nem push).
