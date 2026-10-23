# Korrak, ataque v01: reprovação visual do dono (2026-10-22, r1)

Status: DRAFT. Registro de decisão do dono. Nenhuma geração, alteração de verificador ou integração.

## O que o dono disse

"nessa imagem a mão desaparece e o machado se perde no movimento não posso aprovar isso", com um recorte pequeno que mostra o machado erguido, uma mão no cabo e o braço com a pele embaixo à direita.

## Qual imagem

O recorte **não traz o nome do arquivo.** Comparei com as três poses de machado erguido do Korrak. A melhor correspondência é a **figura 2 (preparo) de `korrak_attack_se_v01.png`**: cabeça do machado no alto à esquerda, uma mão agarrando o cabo, pele do manto embaixo. A figura 3 da habilidade (`korrak_active_se_v01.png`) é parecida, mas mostra as duas mãos no cabo. **Pendente de confirmação do dono.** O registro vale, até a confirmação, para o ataque v01; a habilidade e a morte seguem sem aceite.

## Diagnóstico (olhando a imagem, a sequência e os números)

1. **A segunda mão some.** Na figura 2 só uma mão aparece no cabo; a outra fica escondida atrás da cabeça e do ombro, e o braço que a sustenta desaparece atrás da cabeça. É o "a mão desaparece".
2. **O machado muda de plano e de lado entre os quadros.** O preparo é vertical (machado sobre a cabeça, lâmina apontando para trás e para a esquerda); o golpe é horizontal (machado estendido para a direita, lâmina de frente); o seguimento é baixo, à direita. Entre o preparo e o golpe o machado dá um salto de cerca de meia volta, sem quadro intermediário. A 12 fps, com só 3 poses mais o repouso, o machado "se perde" no movimento. O prompt do preparo ("atrás do ombro direito") já era ambíguo, e o modelo escolheu o vertical.
3. **O golpe lê como estocada:** braços estendidos, machado de frente, sem o arco do corte.

O verificador **não pega nenhum dos três**: o critério 5e só mede se as poses diferem; 5f (gesto) é à vista. É uma falha de gesto, não de formato.

## O que fica

- Aceite visual do ataque v01: **REJEITADO pelo dono.** Resultado do verificador inalterado (PASSA_COM_ITENS_A_VISTA).
- Tentativas do ataque do Korrak: 1 de 3 usada, **2 restantes**.
- Habilidade e morte: sem aceite nem reprovação do dono ainda.

## Correção proposta (não executada)

Segunda tentativa do ataque, do zero com as cinco referências (o idle aprovado como quinto anexo), mudando só o gesto:
- **Um único plano de balanço, horizontal:** preparo com o machado puxado para trás, à esquerda, na altura do quadril, torso girado; golpe varrendo à frente num arco horizontal para a direita; seguimento baixo, à direita. O machado passa a seguir um caminho contínuo da esquerda para a direita.
- **As duas mãos visíveis no cabo em todas as poses**, nunca atrás do corpo, da cabeça ou do pauldron.
- **A cabeça do machado inteira e visível** em todas as poses.
- Tamanho e margens como já pedidos (figuras pequenas, 65% do quadrante).

Alternativa (muda o contrato, só com aprovação): ataque com **4 desenhos** em vez de 3 (preparo, meio do arco, golpe, seguimento), a 5 figuras na grade, para o arco ter um quadro intermediário.

## Preservado

O PNG v01 e seu hash; o recibo; o relatório de medição; os verificadores; o contrato r2; o idle do Korrak e sua exceção; os relatórios do Durvall. Sem integração, promoção CANON, commit ou push.
