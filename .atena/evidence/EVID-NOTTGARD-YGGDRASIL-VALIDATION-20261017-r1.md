---
id: EVID-NOTTGARD-YGGDRASIL-VALIDATION-20261017
revision: r1
status: PARTIAL_AWAITING_SCOPE_ADJUSTMENT
---

# S-YGG-004 — validação isolada e pendência delimitada

Autorização do usuário: “autorizado”, após proposta explícita dos doze conjuntos, simulação completa, capturas e comparação de desempenho. IN_PLAN, plano r1, etapa **4/5 em andamento; 3/5 concluídas e duas restantes**. Não há aceite técnico integral nem abertura do playtest humano. [Resultados, hashes e sessões](../generated/yggdrasil-map-20261017/s004-validation.json).

## Resultado dos testes

Onze dos doze conjuntos passaram. Única falha: test_level_design, mensagem “raiz_yggdrasil: level_design sem props”. Teste exige props em todos os registros; o contrato r1 aprovado exige props=[] neste protótipo. O teste não foi editado, asserções não foram removidas e o teto continua treze arquivos.

Testes novos exercitados no Godot: corpos 0,3/0,4/0,8, conectividade de toda a grade e ambos os sentidos das oito ligações, sweep/diagonais grandes, dash real, empurrão, avanço, knockback, investida, separação, aproximação por desvio, spawn omitido sem abate/recompensa, raios reais dos quatro IDs e voo apenas sintético. Loot/magnetismo confinados. Objetivo antes/exato/depois de240s, passo cruzando limiar, saída/reentrada, dano, pausa, morte/abandono e limpeza sem kills/loot; cap40 para spawn, invocação/divisão e recusa após240s com espaço disponível. Simulação seed7502/dt0,1 até presença completa aproximadamente243s com herói sintético invulnerável; isso não certifica dificuldade. Regressões válidas preservadas; apenas checks afetados pelas correções foram repetidos.

## Capturas, correções e preservação

Capturas em1280×720/1920×1080: entrada, centro, dois desvios, borda, alvo e combate com40 inimigos/ataque/recursos, overview e tons de cinza. Perfil fonte sintético e assinatura preservados. Entrada pelo catálogo normal recusada; entrada e retorno pela QA passaram. Sessão final Yggdrasil: validation-20261017-230416-464. Capturas dos dois mapas anteriores emvalidation-20261017-225731-723 continuam válidas.

A auditoria de pixels detectou465 divergências iniciais porque o desenho dos discos usava raio horizontal de tela em vez do raio do mundo. ui/ground.gd corrigido para projetar pontos do círculo como a colisão. Auditoria final: 12438 amostras e 0 divergências, excluindo apenas margem0,18 de quantização de borda; máscaras/render reais, não só conferência da tabela. Reino Abissal: 8157 amostras, zero divergências/escapes. Pisos de Reino Abissal e Domwieck pixel a pixel idênticos à versão anterior; arte/controladores protegidos e dados anteriores inalterados. Aparência é protótipo geométrico; não promove arte ou lore.

## Desempenho

Mesma máquina e render OpenGL offscreen, vsync desativado. Reino Abissal50,seed7204,dt1/60,30frames de aquecimento+600 medidos. Baseline anterior ao código: loop mediana/p95 13.328/15.767ms; simulação 9.06/11.431ms. Final: loop 13.495/15.469ms (1.3%/-1.9%); simulação 9.63/11.381ms (6.3%/-0.4%). Aumento inicial acima de10% investigado: removidas chamadas repetidas de largura e criação de array em consultas de apoio; equivalência geométrica verificada. Tentativas anteriores preservadas no diretório. Se algum indicador final permanecer acima de10%, permanece explícito aqui; não foi apagado nem normalizado.

Yggdrasil40,seed7504,mesmo dt e30+600frames: loop 9.738/10.57ms; simulação 4.978/5.456ms. Não comparar diretamente mapas/populações diferentes. Tempos são CPU e loop com despacho/render; não timestamp GPU ou certificação FPS/controle físico.

Todas as execuções usam APPDATA/LOCALAPPDATA/perfil sintéticos com probe prévio sem autoload. Sem save real, instalação, recursos externos ou campanha alterada. Teto13 respeitado; duas correções de runtime e reforço dos dois testes novos permanecem nos caminhos aprovados.

## Checkpoint de ajuste

[Proposta r2 DRAFT](../specs/SPEC-NOTTGARD-YGGDRASIL-MAP-20261017/validation-adjustment-r2-draft.md): autorizar unicamente tests/test_level_design.gd como14º caminho para testar positivamente o protótipo QA sem props e manter expectativas dos mapas anteriores. Motivo do pedido: contrato r1 limita13 caminhos e exige apresentar consumidor adicional antes de editar; a autorização atual não elimina esse teto. Após aceite, aplicar ajuste e repetir o teste afetado; reutilizar evidências válidas. S-YGG-004 continua incompleta. S-YGG-005 exige sua própria autorização depois da validação técnica.
