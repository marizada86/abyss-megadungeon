# Korrak, idle SE v01: medição (2026-10-22, r1)

Status: DRAFT. Somente leitura: nenhuma geração, nenhuma alteração no verificador, na imagem ou no jogo. Imagem: `assets_incoming/hero-r2/korrak/korrak_idle_se_v01.png`, SHA-256 `1EBB6780349A26A13B47284536D07928BF0DD79487CD1A9AF2260914813426C2` (conferido contra o recibo `idle-generation-receipt-v01.json`; arquivo idêntico, sem pós-edição). Aceite visual do dono já registrado no recibo ("aprovado, proximo passo?"). Tentativas usadas: 1 de 3.

## 1. Resultado do verificador v3 (`idle`, `magenta`, 3 figuras)

| Critério | Resultado |
|---|---|
| 1 Figuras | **FALHA formal** (ver seção 2) |
| 3 Escala | PASSA: pior diferença de altura 0,6% |
| 4 Pés | PASSA: variação 0,0% |
| 2 Fundo | PASSA: excesso de resíduo magenta 0,2 ponto |
| 6 Pontos soltos | INCERTO: 3, todos **artefatos do corte do verificador** (seção 3) |
| Veredito | REPROVA (só pelo critério 1) |

## 2. O "figura no limite do espaço" (critério 1)

O verificador divide a imagem em terços de 512 px e reprova a figura que toca o limite do seu terço. Medindo as colunas ocupadas direto na imagem:

| Medida | Valor |
|---|---|
| Intervalo vazio entre figura 1 e figura 2 | colunas 514 a 531: **18 px** |
| Intervalo vazio entre figura 2 e figura 3 | colunas 1025 a 1044: **20 px** |
| Margem à esquerda e à direita da imagem | 19 px e 8 px |
| Cada figura | cerca de 495 px de largura (o prompt pedia margem de 60 px e 140 px de intervalo) |

As pontas do machado de cada figura passam da linha dos terços (512 e 1024) por 1 a 3 px. **As figuras não se tocam nem se sobrepõem**: há fundo vazio de 18 e 20 px entre elas. O `asset_prep` separa componentes com folga padrão de 6 px (`gap`), então separaria as três figuras sem problema.

Também **uma limitação do verificador**: a fusão por vizinhança (dilatação de 20 px de cada lado) uniu a ponta do machado da figura 1 à figura 2, e por isso o relatório mostra a figura 2 com x=512 em vez de 532. Os números por caixa do v3 não valem para figuras separadas por menos de 40 px.

## 3. Os 3 pontos soltos

Posições (512, 575), (512, 513) e (1024, 575): todos **exatamente nas linhas de corte dos terços**. São as pontas do machado cortadas pela partição do verificador e contadas como componentes pequenos. Não são pontos soltos da imagem.

## 4. O que a imagem mostra (à vista)

- Identidade e assimetrias de acordo com o CANON: pauldron de aço com espinhos no ombro esquerdo do personagem (lado direito da tela, de frente) e manto de pele no direito; cabeça raspada com crista escura, barba preta cheia, pele cinza de pedra, colete de couro com tira diagonal e cinto com disco, saiote de tiras, botas com punhos de pele.
- Machado de Xar'gath nas duas mãos, atravessado, lâmina com rachaduras de lava pintadas no metal, sem chamas ou faíscas.
- As três figuras quase idênticas, com respiração sutil, como o contrato pede para o idle.
- Estilo: pintura de jogo com contornos escuros, mais próxima do estilo do jogo que o idle do Durvall; o anexo `zuggtmoy.png` entrou como referência de estilo.

## 5. O que isso significa e opções (nada aplicado; decisão do dono)

O idle está aprovado à vista e o único critério que reprova mede margem em terços, não a separação que a montagem precisa. Mesmo caso da morte do Durvall, com uma diferença: **aqui o defeito está na definição do critério** (terços de 512 px não comportam um machado largo), não só numa imagem.

| Opção | O que é | Muda o verificador? |
|---|---|---|
| **A. Exceção documentada** | Registrar o idle como aceito à vista com a exceção do critério 1 e dos 3 artefatos, como foi feito na morte do Durvall | Não |
| **B. Corrigir o critério 1** | Trocar "figura dentro do terço" por "figuras separadas por fundo vazio de pelo menos 6 px, sem encostar na borda da imagem" e agrupar por colunas vazias em vez de dilatação; o Durvall idle passaria igual | Sim, com aprovação |
| **C. Refazer** | Gerar de novo pedindo figuras menores | Não; gasta tentativa (2 restantes) e muda uma imagem já aprovada |

**Recomendo A agora e B como proposta separada**, para parar de acumular exceções ao mesmo critério (a E1 do Durvall também falhou por 1 px). Não alterei nada.

## 6. Preservado

A imagem e seu hash; o recibo; verificadores v1, v2, v3 sem alteração; contrato r2; o aceite visual do dono; as exceções e relatórios do Durvall. Sem integração, promoção CANON, commit ou push.
