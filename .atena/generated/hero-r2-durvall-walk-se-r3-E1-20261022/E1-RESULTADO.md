# E1 — Durvall walk SE, contrato r3: resultado (2026-10-22)

Status: DRAFT. **Reprovado pelo dono** ("a E1 ficou horrível"). Geração 1 de 4 usada; restam 3. Nada foi integrado nem alterado. Arquivo: `assets_incoming/hero-r2/durvall/durvall_walk_se_r3_E1_v01.png`. Derivados nesta pasta: `v3-E1_v01.json`, `pernas_A_P1_P2.png`, `PREVIA_E1_A_P1_A_P2.gif` (painéis: caixa, tronco, tamanho de jogo).

## 1. Medido (verificador v3, `walk3p`)

| Critério | Resultado |
|---|---|
| 1 Figuras | **FALHA formal:** A vai de x=68 a x=511, tocando o limite do seu terço (512). Sem sobreposição: há 85 px até a figura 2. A passada larga ocupa o terço inteiro |
| 3 Escala | PASSA (1,1%) |
| 4 Pés | PASSA (1,1%) |
| 2 Fundo | PASSA (excesso 2,9 pontos) |
| 5a A com passada larga | PASSA: 2 pés em -0,17 e +0,19, ou seja 0,36 da altura (o guia pedia 0,45) |
| 5d Um pé no chão nas passagens | PASSA (P1 e P2 com 1 pé cada) |
| 5c Passagem à vista | INCERTO, como sempre |
| 6 Pontos soltos | INCERTO (1) |
| Tremor horizontal | 0,8 px a 64 px de altura: alinhando pelo tronco some |

## 2. O que a imagem e o recorte das pernas mostram

- **A** segue o guia: passada larga, perna do lado da câmera à frente.
- **P2** segue o guia: perna do lado da câmera levantada, por cima da perna de apoio, joelho à frente, pé ao lado do tornozelo de apoio.
- **P1 não segue o guia:** o pé da perna do lado oposto sobe **atrás** da perna de apoio, na altura da canela, e não ao lado do tornozelo. Provável causa: ao lado do tornozelo ele ficaria escondido atrás da perna do lado da câmera, e o modelo o desloca para mostrá-lo.

## 3. Erro do meu raciocínio na proposta r3

Eu argumentei que os contatos A e B são iguais em silhueta e, por isso, bastava reaproveitar A (ciclo A, P1, A, P2). **Isso só vale para um desenho simétrico. Neste estilo as duas pernas são distinguíveis** (a do lado da câmera tem a joelheira grande e fica por cima). Com B = A:
- a perna do lado da câmera fica sempre à frente e só sobe e desce em P2;
- a perna de trás fica sempre atrás e só sobe e desce em P1;
- nenhuma perna vai de trás para a frente.

É exatamente o "só uma perna se movimenta e no último quadro a outra" que você descreveu desde a primeira tentativa, e é **marcha no lugar com cada perna oscilando no mesmo ponto**. O contrato r3 de três desenhos **não resolve isso por construção**, mesmo com a geração perfeita. O contato B com as pernas trocadas (a do lado oposto à frente, a do lado da câmera atrás) é necessário; é justamente o que falhou nas cinco primeiras tentativas.

Também: o ciclo alterna passada larga (0,36 da altura) e pernas quase juntas a cada 90 ms, o que dá efeito de tesoura. As tiras piloto do Durvall que você aceitou têm movimento de **baixa amplitude** (postura agachada, variações pequenas), muito diferente do que pedimos.

## 4. O que eu não sei

- O que exatamente, na animação, você vê de errado. Não consigo ver o GIF, só imagens estáticas; sei o que o recorte, os pés e a lógica do ciclo mostram.
- Se o ChatGPT consegue produzir um B com as pernas trocadas, mesmo editando A com um guia de cores trocadas. Cinco tentativas só com texto falharam; com guia nunca foi testado.

## 5. Opções (nada executado; a decisão é sua)

| Opção | O que é | Gerações | Risco |
|---|---|---|---|
| **1. Parar de gerar caminhada quadro a quadro agora** | Usar as tiras piloto do Durvall como caminhada provisória (alternativa F) e levar a geração nova para idle, ataque, habilidade e morte (poses onde o modelo acerta, como o idle v01) | 0 da caminhada; idle/ataque/ativa/morte seguem o contrato r2 | Caminhada dos 12 continua em aberto |
| **2. Uma tentativa de B por edição** | Editar A trocando as pernas com um guia de cores trocadas (vermelha atrás, azul à frente); P1 refeito do mesmo jeito | 2 das 3 restantes | Cinco falhas anteriores em B; sem base para estimar a chance |
| **3. Estudo de recortes (paper-doll)** | Gerar um kit de partes do Durvall SE a partir do idle aprovado (tronco, cabeça e cabelo, braços, cada perna em duas partes) e montar o ciclo no motor com rotações, trocando as pernas por construção | 1 das 3 restantes, mais engenharia minha (prévia e depois R4) | Consistência das partes; a espada cruza as pernas; muda a arquitetura de animação (código no R4) |

**Recomendação:** a opção **1 agora**, para não parar o trabalho nem insistir no que falhou sete vezes, e a **3 como estudo de uma geração** em paralelo. A opção 2 só se você preferir tentar mais uma vez o caminho atual.

## 6. Preservado

Idle v01 aprovado; as seis caminhadas anteriores (duas r1, três r2, esta E1) e todos os arquivos; contratos r1, r2, r3; verificadores v1, v2, v3; pacotes de prompts; demais planos.
