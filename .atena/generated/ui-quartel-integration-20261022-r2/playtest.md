# Avaliação visual — integração de UI/HUD e Quartel r2

Estado: PENDENTE_DO_DONO. Avaliar as telas, sem repetir o aceite das 125 fontes. Galeria: `index.html`, com pares antes/depois em 1280×720 e 1920×1080. O conteúdo permanece DRAFT.

## Roteiro

1. **Quartel:** ler nomes e reconhecer retratos/miniaturas; conferir contraste dos cartões liberados/bloqueados, distinção de seleção e foco, e leitura do último cartão após rolar. A seleção de herói bloqueado deve manter JOGAR desabilitado. Retrato e informações centrais devem corresponder à seleção. As capturas conservam a seleção entre resoluções; na segunda resolução o herói selecionado é Erik.
2. **HUD:** observar cronômetro, progresso, nome longo da fase/modificador, ícone da regra, chefe e painel de objetivos. Conferir se o deslocamento do topo é confortável em combate. O teste automatizado de geometria cobre a separação do questlog, e a captura isolada demonstra a leitura sem simular uma run inteira.
3. **Ofertas:** comparar três cartões com seis compactos; ler nome longo, categoria, descrição, fita e preço. O segundo cartão tem saldo insuficiente e fica desabilitado/vermelho. Observar brilho sem lavar o texto. O perfil das capturas usa impacto reduzido; a respiração do brilho respeita essa opção.
4. **Resultado:** comparar vitória e recompensa parcial. Conferir os seis ícones, rótulos e números, multiplicador, total de moedas e botões. Verificar uma sessão com muitas conquistas para julgar também a rolagem; a suíte existente cobre o limite vertical desse caso.

Mouse, teclado e controle foram exercitados por eventos sintéticos; conforto e preferência estética continuam sendo avaliação humana. Não usar o save real para validar esta frente.

## Como repetir as verificações isoladas

Na raiz `F:/dev/abyss-megadungeon`, com PowerShell:

```powershell
pwsh -NoProfile -File .atena/generated/ui-quartel-integration-20261022-r2/run.ps1 after
pwsh -NoProfile -File .atena/generated/ui-quartel-integration-20261022-r2/run.ps1 interaction
```

O runner comprova o diretório de usuário isolado antes de carregar autoloads e escreve as capturas/logs em uma nova pasta sintética. `after` abre o renderizador fora da tela e encerra automaticamente; `interaction` é headless. Os modos `full` e `controller` executam os checks completos e podem demorar vários minutos.

## Registro de retorno

- Parecer por tela: aprovado / ajustar.
- Se ajustar: tela, resolução, item/trecho afetado e resultado esperado.
- Navegação humana no jogo: ainda não realizada neste escopo.
- Nenhum commit, push, build ou promoção a CANON está autorizado por este aceite visual.
