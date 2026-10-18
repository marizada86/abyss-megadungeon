# Reino Abissal — conjunto de raízes r1 para revisão

Quatro PNGs produzidos via **imagegen built-in**, com somente HQ17 Q3 v02 e Q4 v01 como referências fornecidas ao gerador. Direção da amostra v02 aprovada preservada. Este conjunto está **APROVADO visualmente pelo dono em 2026-10-17**; não foi aplicado no jogo.

| Peça | Arquivo | Dimensão nativa | Finalidade |
| --- | --- | --- | --- |
| Superfície | [surface-v01.png](surface-v01.png) | 1254×1254 | Quatro variações opacas de casca/fibras para as passagens |
| Junções | [junctions-v01.png](junctions-v01.png) | 1254×1254 | Quatro encontros de fibras para revestir os alargamentos aprovados |
| Laterais | [sides-v01.png](sides-v01.png) | 1774×887 | Quatro faixas com transparência sob a franja de raízes |
| Profundidade | [depth-v01.png](depth-v01.png) | 1254×1254 | Quatro grupos escuros de fibras pendentes para o vazio abaixo das bordas |

Avaliar continuidade com a amostra aceita, cor da madeira, entrelaçamento nas junções e aparência das fibras suspensas. As divisões dos atlas separam variantes; não são novos cortes ou obstáculos no mapa.

Inspeção confirmou PNGs legíveis, superfície/junções totalmente opacas e alfa real nas duas peças de borda/profundidade. A translucidez parcial e eventuais franjas deverão ser conferidas com o fundo real na integração. O relevo pintado não acrescenta colisão.

Os originais foram preservados no tamanho nativo entregue pela ferramenta. O plano prevê texturas de destino 1024×1024 e 1024×512; ajustar importação/UV e examinar a redução em escala normal pertence ao preflight e à integração S-RART-004, antes da admissão. Proposta: limitar tamanho pela importação do Godot, preservando os PNGs originais e verificando filtro nearest. Os quatro originais RGBA8 equivalem a aproximadamente 24 MiB por cópia; as texturas importadas nas dimensões previstas equivaleriam a aproximadamente 14 MiB por cópia. Nenhum desses números é medição do custo total da GPU ou do jogo.

Não foram provados encaixe visual com colisão, emendas entre regiões, repetição de textura, leitura sob combate ou desempenho. Esses checks precisam da integração autorizada, como previsto no plano. Os recortes propostos no manifesto são ponto de partida, não admissão automática: principalmente as quatro faixas laterais requerem verificar o limite real da franja em cada região. Não usar o alfa das imagens como colisão nem desenhar profundidade sobre área caminhável.

[Manifesto e recibos dos quatro arquivos](manifest.json) · [Prompts efetivamente utilizados](../kit-prompts-r1.json) · [Amostra v02 aprovada](../candidates/reino-abissal-roots-sample-v02.png).

S-RART-003 concluída, 3/5 etapas. Próximo checkpoint CP-RART-004: autorização para integrar e verificar, mantendo os caminhos e o espaço de combate aprovados.
