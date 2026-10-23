# Durvall — medição das ações SE v01

2026-10-22. Autorização: “atena continue”, após entrega dos três PNGs e indicação da medição como próxima etapa. DRAFT; sem aceite humano presumido.

Verificador oficial `r2_check_v3.gd`, argumentos `magenta 4 grid`, sem alterações. Execução headless em projeto sintético mínimo, sem autoloads, sem carregar o jogo ou seu save. Relatórios: `attack-v01.json`, `active-v01.json`, `death-v01.json`; consolidação e hashes em `summary.json`.

| Critério | Ataque | Habilidade | Morte |
|---|---|---|---|
| Veredito oficial | REPROVA | REPROVA | REPROVA |
| Figuras/quadrantes | FALHA | FALHA | FALHA |
| Fundo | PASSA | PASSA | PASSA |
| Linha inferior por fileira | PASSA (0,2%) | PASSA (1,2%) | FALHA (14,0%) |
| Poses diferentes, menor diferença | PASSA (49,1%) | PASSA (38,9%) | PASSA (37,8%) |
| Pontos soltos | INCERTO (4) | INCERTO (1) | FALHA (15) |
| Gesto | INCERTO, à vista | INCERTO, à vista | INCERTO, à vista |

Todas têm quatro espaços ocupados, mas há figuras atingindo os limites desses espaços. O agrupamento por quadrante pode cortar uma figura e atribuir sua parte ao quadrante vizinho; contagem 4/4 não comprova quatro figuras inteiras separadas. A inspeção das imagens completas na entrega já identificou a espada do ataque atravessando o quadrante e as figuras superiores de habilidade/morte cruzando a linha horizontal.

Limitações preservadas: o v3 acusa contato com limites, mas não mede integralmente a margem mínima de 60 px. O critério de linha inferior da morte compara a base do desenho ajoelhado com a do corpo deitado (incluindo espada); não prova sozinho erro anatômico ou posicionamento inadequado. Os 15 pontos soltos incluem regiões de cabelo e precisam de revisão visual. Essas ressalvas não eliminam a falha independente de enquadramento. Escala absoluta e identidade/estilo não foram aprovadas por esses testes.

Ambiente: Godot informou falha ao criar `user://logs` e ao ler o repositório de certificados do Windows. Os três JSONs foram gravados e contêm REPROVA. O processo observado pelo PowerShell terminou em 0 nas três chamadas, apesar de o script solicitar `quit(1)`; o código externo não foi usado como indicação de sucesso técnico.

SHA-256 dos três PNGs permanece igual ao recibo de geração; nenhum PNG editado. Contadores seguem em uma tentativa de três por ação. Verificador oficial e demais planos preservados.

Recomendação: preparar uma segunda tentativa de cada ação com personagens menores, mesma escala entre as quatro figuras, altura em pé de no máximo 360 px (a partir da calibração), e todas as extremidades de cabelo/arma/corpo contidas na área interna de cada quadrante com 60 px de margem. Preservar o gesto e o estilo; explicitar que o golpe não pode cruzar x=768 e que a primeira fileira inteira deve terminar antes de y=452. Na morte, limitar também a largura do corpo deitado a 648 px. Isso é uma proposta de correção do enquadramento, sem garantia de obediência do gerador; a v02 precisará de nova medição e revisão. Nenhuma nova geração executada nesta rodada.

Checkpoint: ACTIONS_SE_V01_MEASURED_REJECTED_FRAMING_RETRY_PROPOSED. Sem integração, portagem, commit ou push.
