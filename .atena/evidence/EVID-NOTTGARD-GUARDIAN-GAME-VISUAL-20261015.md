# Guardião Alado — aparência efetivamente usada no jogo

Consulta IN_PLAN em S-HQ-003, etapa 3/16: dono solicitou verificar visual do Guardião no jogo. Somente inspeção, sem produção/alteração de runtime. Complementa e corrige a prontidão da seleção HQ02, que havia consultado vault/arquivo nominal externo sem rastrear o renderizador do inimigo.

## Fonte e ligação ao runtime

data/enemies.json identifica guardiao_verdadeiro como Guardião Alado verdadeiro e data/stages.json o usa como chefe das Docas. ui/enemy_view.gd registra animações para guardiao_verdadeiro e guardiao_copia, células 320×480, estados idle/move/attack/special/death. _build_animations carrega assets/animations/enemies/<id>/<state>.png, com fallback estático assets/enemies/<id>.png. As duas tiras idle foram abertas e inspecionadas, assim como ambas as artes estáticas. A tela de introdução em boss_presentations.json não tem ilustração independente para esse chefe.

Guardião verdadeiro: humanoide alado de aparência angelical/estátua, rosto humano sem elmo/chifres, cabelo cinzento ondulado, corpo/armadura em cinza-pedra/marfim/prata, drapeado claro, grandes asas de penas cinzentas com acentos violetas, luz violeta no peito e marcas/veios violetas nos membros. Arma longa de haste com lâmina/ponta e gema violeta. A animação mantém esses traços. Descrição visual não promove raça/origem angelical a lore canônica.

Cópia: forma humanoide semelhante, predominantemente cinza/escura com detalhes dourados/âmbar, sem o destaque violeta intenso do verdadeiro. Tirar do jogo o papel distinto dos dois, sem presumir que a antiga HQ da criatura demoníaca seja referência válida.

## Divergência e recomendação

Antigo HQ02-Q2 mostra criatura escura esquelética, cabeça com chifres e asas membranosas. Diverge substancialmente do chefe efetivo. A recomendação anterior de aproveitar sua aparência é retirada como proposta de identidade; o salão ainda pode servir de cenário. Proposta DRAFT atual para Q3: usar o Guardião verdadeiro do jogo como referência de forma/figurino/arma e reencenar a derrota com sangue negro conforme roteiro CANON r2. Roxo do Guardião não altera a restrição de domo somente azul.

Não houve geração, aprovação automática da referência para HQ ou mudança dos sprites. Aceite da seleção HQ02 continua pendente. Próximo objetivo: validar a seleção revisada com Guardião do jogo em vez da criatura antiga; depois produzir candidatas uma por vez.
