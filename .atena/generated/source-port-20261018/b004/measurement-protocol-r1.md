# Protocolo de comparação local — r1 DRAFT

S-PORT-007, 2026-10-18. Medição diagnóstica; não autoriza otimização,
mudança de dificuldade ou promoção canônica.

Comparar snapshot PC anterior à portagem (B001) e candidata entregue (B003),
na mesma máquina/Godot 4.7.2/OpenGL/1280×720, sequencialmente em ordem ABBA.
Perfis e user:// sintéticos verificados. Fonte e árvore entregue não são alteradas.

Render: Molor, Durvall, 32 inimigos nas mesmas posições, batalha congelada,
sem entrada humana; 120 quadros de aquecimento + 360 amostras. VSync e limite
de FPS desligados. Tempo de parede entre quadros, mediana/p95/p99, memória
estática Godot e quantidade de objetos; não é tempo de GPU nem VRAM total.
Atmosfera e assets usam defaults de cada revisão, representando custo da
apresentação entregue. Desenho fora da tela pode diferir de janela em foco.

CPU: batalha Molor com seed 8142, 1.800 passos de 1/60 s e entrada nula;
resolver ofertas pela primeira opção, manter HP de teste, remover eventos
consumidos. Registrar duração total/passos e inimigos. Regras novas podem
mudar a população; comparar custo do cenário, sem atribuir a diferença a
uma única função ou confundir com workload idêntico.

Sinal de investigação proposto antes da medição: p95 de render aumenta
mais de 25% E 2 ms sobre baseline; orçamento indicativo de 60 FPS = 16,67 ms.
Não existe aceite canônico de desempenho para esse cenário. Resultados são
diagnósticos; conforto, hardware real e playtest continuam pendentes.
