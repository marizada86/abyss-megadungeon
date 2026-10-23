# Durvall walk SE, contrato r2: diagnóstico das 3 tentativas e proposta (2026-10-22, r1)

Status: DRAFT. **Nada foi gerado, integrado ou alterado**: contrato r2, verificador v2 oficial, pacote `prompts-r2/`, PNGs, idle v01 aprovado e tentativas ficam como estão. Os derivados desta análise estão nesta pasta, identificados. Pedido do dono: "analise as evidências e proponha a próxima abordagem, considerando o plano B ... quero avaliar uma proposta concreta antes de autorizar novas gerações".

## 1. Resumo

1. **As três imagens estão bem formadas** (4 figuras, escala, fundo, halo). O "achei 2 figuras" do meu verificador v2 foi **defeito dele**: ele funde as figuras da fileira de cima com as de baixo (intervalo vertical de ~25 px). Não é defeito das imagens.
2. **O problema de movimento não é "a mesma perna nos contatos".** Nos contatos, silhueta igual é fisicamente normal. O problema é de **continuidade**: o pé levantado nunca *passa* ao lado da perna de apoio; sobe atrás (P1) ou à frente (P2) e volta ao mesmo lugar. O olho lê marcha no lugar, uma perna de cada vez, que é o que você descreveu.
3. **A v03 é pior que a v01 e a v02:** os quatro quadros quase não se distinguem; a simplificação do prompt apagou o movimento que a v01 e a v02 tinham.
4. **O plano B literal (uma pose por imagem, mesma linguagem de perna) provavelmente repete a falha**, porque o defeito é de linguagem (perna "próxima/distante/esquerda/direita" é ambígua em três-quartos), não de layout. É hipótese, não testada.
5. **Proposta:** descrever a pose em coordenadas de **tela** e entregar um **guia de pose** (boneco colorido) como referência; pedir **3 desenhos (A, P1, P2)** e tocar A, P1, A, P2; teto de **4 gerações** antes de voltar a você.

## 2. Evidências

### 2.1 Pés apoiados no chão, por quadro (faixa dos 6% mais baixos da figura; a espada não chega ali)

`planted_feet.json`. Cada entrada: nº de pés no chão e posição horizontal de cada pé em relação ao centro da figura, dividida pela altura (negativo = lado esquerdo da tela; a figura anda para a direita).

| Tentativa | A (fig. 1) | P1 (fig. 2) | B (fig. 3) | P2 (fig. 4) |
|---|---|---|---|---|
| r2 v01 | 2 pés (-0,22; +0,23) | **1 pé (+0,07)** | 2 pés (-0,22; +0,21) | **1 pé (-0,08)** |
| r2 v02 | 2 pés (-0,14; +0,19) | **1 pé (+0,10)** | 2 pés (-0,20; +0,20) | **1 pé (-0,10)** |
| r2 v03 | 2 pés (-0,10; +0,17) | **2 pés** (-0,12; +0,13), nenhum levantado | 1 pé (+0,18) | 1 pé (+0,13) |
| r1 v01, v02 (formato antigo) | 2 pés | 1 pé (+0,10 / +0,05) | 2 pés | (P repete) |

Leitura:
- **v01 e v02:** o apoio alterna: direita em P1, esquerda em P2. O modelo *sabe* levantar uma perna por quadro e alternar qual. Os contatos A e B têm os mesmos pés (±0,22): não distinguíveis pela silhueta.
- **v03:** o apoio fica sempre à direita (P1 com dois pés no chão, B e P2 só o direito): **sem alternância**. Confirma a tira `TIRA_ciclo_A_P1_B_P2_r2_v01_v02_v03.png` (linha de baixo: quatro quadros quase iguais).
- **Formato antigo:** sempre o direito apoiado.

### 2.2 O que cada quadro mostra (olhando as imagens e a tira)

- **v01 e v02:** A em passada larga (perna esquerda atrás, direita à frente). P1: pernas juntas, bota **esquerda levantada atrás** do corpo (chute para trás pequeno). B: igual a A. P2: bota **direita levantada à frente**, longe do apoio (passo alto). Os dois levantamentos não são simétricos nem passam pelo meio.
- **v03:** contatos e passagens quase idênticos; botas deslocadas poucos pixels.

### 2.3 Por que isso lê como "uma perna de cada vez"

Num ciclo real, o pé de trás se levanta, **passa ao lado do pé de apoio** e pousa à frente. Aqui o pé levantado em P1 fica atrás e em B volta a pousar atrás (B é igual a A); o pé da frente sobe em P2 e volta a pousar à frente. Nenhum pé troca de lugar de forma legível. Em silhueta os contatos A e B *devem* ser parecidos; é a passagem (pé levantado ao lado da perna de apoio, joelho à frente) que faz o olho ligar o pé de trás ao pé da frente. É isso que falta e que nenhuma das cinco tentativas entregou.

### 2.4 A espada atrapalha

A lâmina cruza as pernas em todas as figuras e esconde a perna do lado da câmera (recorte `r2b_pernas_v03.png`). Isso piora a leitura a 64 px e contamina qualquer medida de perna. É uma decisão de arte do Durvall (espada para baixo, ao longo da perna), não um erro de geração.

### 2.5 Verificador v2: bug de agrupamento (meu)

`1_figuras: esperava 4, achei 2` nas três. Com a dilatação menor (cópia de análise, dilatação 1) a v01 e a v03 dão 4 figuras; a v02 ainda dá 3 (outra fusão). Os arquivos `v2-oficial-*` e `v2b-*` desta pasta registram as duas rodadas. Causa: o agrupamento por vizinhança junta a bota/espada da figura de cima com o cabelo da de baixo. Correção proposta (não aplicada): **agrupar por quadrante** (cada figura dentro do seu quadrante de 768×512, que é o que o prompt exige).

### 2.6 Estado de cada checagem do v2 nas três (cópia de análise)

| | 1 figuras | 3 escala | 4 pés | 2 fundo | 6 pontos | 5a | 5b A≠B | 5c P1≠P2 |
|---|---|---|---|---|---|---|---|---|
| v01 | PASSA | PASSA | PASSA | PASSA | FALHA (4) | PASSA | INCERTO (1,02) | PASSA (8,9) |
| v02 | 3 figuras (fusão) | n/a | n/a | PASSA | FALHA (1) | n/a | n/a | n/a |
| v03 | PASSA | PASSA | PASSA | PASSA | FALHA (4) | PASSA | INCERTO (1,14) | PASSA (2,11) |

O 5c "PASSA" na v03 (razão 2,11) é **falso positivo**: a diferença de silhueta (11%) vem de pequenos deslocamentos, e a tira mostra P1 e P2 quase iguais. Os pontos soltos (4) merecem revisão junto com o critério.

## 3. Proposta

### 3.1 Ideias

1. **Pose em coordenadas de tela, sem "perna próxima/distante".** Ex.: "o pé da esquerda da tela está levantado, ao lado do tornozelo de apoio". Resolve a ambiguidade que o modelo nunca resolveu.
2. **Guia de pose como referência visual.** Boneco com a perna do lado esquerdo da tela em azul e a do lado direito em vermelho, nas posições exatas dos pés e joelhos. Exemplo gerado por script: `GUIA_DE_POSE_exemplo_A_P1_P2.png` (A, P1, P2, andando para a direita da tela). O prompt diz que o guia dá só a pose, que as cores não aparecem no resultado e que o personagem é o do idle aprovado.
3. **Três desenhos em vez de quatro: A, P1, P2; toca A, P1, A, P2.** Em silhueta B é igual a A (provado pelos pés: ±0,22 nos dois), então gerar B é pedir ao modelo algo que não se vê. Cada passagem mostra o pé levantado **junto à perna de apoio, na altura da canela, joelho à frente**, e P1 e P2 levantam pés de lados opostos da tela.
4. **Opcional (decisão sua): espada fora das pernas durante a caminhada** (lâmina apoiada no ombro direito, só na caminhada). O idle aprovado continua com a espada para baixo. Sem isso a perna do lado da câmera segue escondida.

### 3.2 Experimentos, com teto

| Exp. | O que se gera | Referências (5, limite da ferramenta) | Sucesso |
|---|---|---|---|
| **E1** | 1 imagem: fila de 3 figuras A, P1, P2 (1536×1024) | vistas CANON frente, esquerda e costas; idle aprovado; guia de pose (a vista direita sai) | ver 3.3 |
| **E2** (só se o E1 não seguir o guia) | até 3 imagens, uma pose cada, pedindo para **editar o idle aprovado mudando só as pernas** conforme o guia | idle aprovado + guia da pose + 3 vistas CANON | idem, por imagem |

**Teto: 4 gerações no total** (E1 uma; E2 até três). Passou o teto sem sucesso, volto a você com o resultado e a alternativa abaixo; não insisto.

**Alternativa se os dois falharem (F):** para o Durvall, reaproveitar as tiras piloto que já existem em `assets/animations/heroes/durvall/` (6 quadros, oeste real) como caminhada provisória enquanto a arte nova do resto avança; para os demais heróis, o mesmo método (guia + 3 desenhos) com a lição aprendida. É um retrocesso para o Durvall, mas é um fallback honesto.

### 3.3 Critérios de aceite do E1 (objetivos + à vista)

Objetivos (verificador, depois das mudanças abaixo):
- 3 figuras inteiras, escala dentro de 6% da P1, pés na mesma linha.
- **A:** dois pés no chão, afastados (≥ 0,30 da altura).
- **P1:** **um** pé no chão, do lado **direito** da tela; **P2:** **um** pé no chão, do lado **esquerdo**. (Já passam na v01 e v02; é condição necessária, não suficiente.)
- P1 e P2 não são cópia uma da outra.

À vista (você e eu, com recorte das pernas): o pé levantado em P1 e P2 está **ao lado da perna de apoio** (não atrás nem à frente do corpo), joelho à frente; A tem passada larga.

### 3.4 O que mudaria no contrato e nas ferramentas (**nada aplicado; pede sua aprovação**)

| Item | Mudança |
|---|---|
| Contrato r3 | Caminhada com 3 desenhos (A, P1, P2) tocando A, P1, A, P2; descrição de perna em coordenadas de tela; guia de pose por direção; critério 5b (A≠B) removido; critério 5d de pés apoiados |
| Verificador v3 | Agrupar figuras por quadrante; tipo `walk3p` (fila de 3: A, P1, P2); critério 5d (pés apoiados na faixa baixa); revisar pontos soltos e 5c (falso positivo) |
| Guias | Eu gero por script, por direção (`se` primeiro; `e`, `ne`, `s`, `n` se o E1 funcionar) |
| Pacote de prompts r3 | Só o Durvall `walk_se` primeiro; os demais heróis só depois do E1 passar |
| Roteiro | Novo, com os passos do E1 |

Não mexo em `animation-contract-r2.md`, `r2_check_v2.gd`, `prompts-r2/` nem nos roteiros existentes: viram histórico quando você aprovar o r3.

## 4. Decisões que preciso de você

1. Aprova o **E1 com guia de pose** e o **teto de 4 gerações**?
2. **Três desenhos (A, P1, P2) tocando A, P1, A, P2** é aceitável (contatos iguais em silhueta)?
3. **Espada na caminhada:** manter para baixo ao longo da perna ou apoiar no ombro só na caminhada?
4. Aprova eu preparar o contrato r3, o verificador v3, o guia `se` e o prompt do E1 (sem gerar nada)?

## 5. O que preservei

Idle v01 aprovado; todas as tentativas, PNGs, JSONs e hashes; `animation-contract-r2.md`, `r2_check_v2.gd`, `prompts-r2/`, `r2-roteiro-r2.md`; os demais planos e alterações concorrentes. Nenhuma geração, integração, commit, push ou promoção CANON.

## 6. Limites desta análise

- Medi imagens estáticas; não animei nenhuma tentativa. A leitura de "marcha no lugar" é minha inferência a partir dos pés apoiados e da tira, coerente com o seu relato.
- O guia funcionar com o ChatGPT é **hipótese**; o E1 existe para testá-la barato.
- O critério de pés apoiados é condição necessária: a v01 e a v02 o satisfazem e você as reprovou.
