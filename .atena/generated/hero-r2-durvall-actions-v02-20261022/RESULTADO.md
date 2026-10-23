# Durvall — correção de enquadramento

2026-10-22. DRAFT. Dono: “eu gostei, mas faça o que achar que é certo”. Registrado como preferência visual pelas v01 e autorização para escolher a correção técnica, sem presumir aceite de versões ainda não vistas.

Decisão: preservar v01 e editar cópias pela ferramenta integrada image_gen, com foco em reduzir e reposicionar figuras inteiras. Foram produzidas attack v02, active v02, death v02 e death v03. A morte v02 ainda tinha margem inferior de 29 px; a v03 corrigiu esse ponto. Prompts integrais em `prompt-attack.txt`, `prompt-active.txt`, `prompt-death.txt` e `prompt-death-v03.txt`. Cada chamada usou a versão anterior da própria ação como único alvo de edição, preservando a identidade pela imagem. Não foi repetida geração do zero com as cinco referências CANON/idle; trata-se de correção localizada autorizada pelo pedido atual.

| Candidata | Margem mínima medida | Veredito oficial v3 | Seleção técnica |
|---|---|---|---|
| durvall_attack_se_v02.png | 70 px | PASSA_COM_ITENS_A_VISTA | Candidata principal, revisão visual pendente |
| durvall_active_se_v02.png | 62 px | PASSA_COM_ITENS_A_VISTA | Candidata principal, revisão visual pendente |
| durvall_death_se_v02.png | 29 px | REPROVA | Histórico, superada pela v03 para enquadramento |
| durvall_death_se_v03.png | 69 px | REPROVA | Enquadramento corrigido, retenção técnica |

Margens calculadas a partir das caixas por quadrante do v3, considerando cabelo e arma presentes na máscara; não incluem pontos isolados excluídos do agrupamento. Todas as candidatas principais têm quatro figuras sem contato com limites de quadrante. Fundo e diferença entre poses passam nas quatro imagens medidas.

Ataque v02: dois pontos soltos INCERTO; habilidade v02: três pontos INCERTO. Gestos continuam como revisão visual obrigatória pelo contrato. À vista, ações, personagem e linguagem visual seguem as versões de origem; edição generativa não garante identidade pixel a pixel e mudou detalhes finos, por isso as v01 aprovadas em preferência foram preservadas.

Morte v03: sete pontos soltos FALHA e variação da linha inferior 18,8% FALHA. O cálculo compara a base do desenho ajoelhado com a do corpo deitado, incluindo espada; não basta para concluir erro de pose. Os sete pontos precisam de inspeção específica antes de qualquer admissão. Mantido REPROVA, sem alterar o verificador ou dispensar critérios para aprovar a imagem. A v03 atende a margem; não está declarada pronta para integração. Três tentativas de morte usadas (v01/v02/v03); não continuar gerando no orçamento atual.

Testes executados pelo verificador v3 inalterado, em projeto sintético sem autoloads ou acesso a save real; logs explícitos nesta pasta. A mensagem de falha no repositório de certificados Windows persiste. O código de processo observado foi 0, mesmo com vereditos REPROVA; decisão baseada nos JSONs. Relatórios e resumo de margens estão nesta pasta. SHA-256 e igualdade entre origens geradas e cópias constam em `integrity.json`. As quatro novas cópias são idênticas às respectivas saídas do image_gen, sem pós-edição local; SHA-256 das v01 confirmado inalterado.

Checkpoint: ACTIONS_SE_FRAMING_CORRECTED_DEATH_TECHNICAL_HOLD. Tentativas totais usadas: ataque 2/3, habilidade 2/3, morte 3/3. Aceite humano das novas versões pendente. Sem integração no jogo, alteração de save, promoção CANON, portagem de runtime, commit ou push. Demais planos preservados.
