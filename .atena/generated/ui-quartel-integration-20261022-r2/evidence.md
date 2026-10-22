# Integração de UI/HUD e Quartel — evidência r2

Data: 2026-10-22. Autorização do dono: «atena. aprovado seguindo recomendações». Modo per-plan, escopo U09/U11/U17/Q02/Q03/Q10. Entrega técnica concluída; avaliação visual humana pendente. Conteúdo DRAFT; aceite das fontes preservado, sem nova geração.

## Entrega

- U09: brilho aditivo abaixo do texto; estado de foco/hover e raridade; opção de impacto reduzido desliga a respiração.
- U11: placa de preço com recuo para o ícone de moeda e cor de saldo insuficiente. A fita compacta teve as margens reduzidas para caber ao lado do nome longo.
- U17: cronômetro aplicado; barra de progresso, fase, ícone da regra, chefe e questlog reposicionados. A suíte detectou contato entre fase e questlog na primeira revisão; corrigido antes da entrega.
- Q02/Q03: novo `ui/quartel_card_list.gd`, uma apresentação sobre ItemList que mantém os nomes/IDs de nós, input nativo, ordem, seleção e desbloqueios existentes. Retratos e miniaturas ajustados às janelas, com estado bloqueado, foco/seleção e rolagem. Atualizar/reabrir o menu torna a seleção visível.
- Q10: seis ícones inline no resultado, com os mesmos rótulos, valores, recompensa parcial, multiplicador e conquistas. Texto de conteúdo é escapado para BBCode, preservando nomes literais. O ScrollContainer existente continua responsável pela rolagem.

Sete arquivos de runtime alterados/adicionados, mais UID do novo script, listados em `admission.json`. Nenhum PNG foi modificado ou copiado. UI Windows deste projeto; nenhum dado/mecânica compartilhado alterado e nenhuma sincronização com a origem histórica.

## Recuperação e rastreabilidade

HEAD inicial: `02f898552fc8bea7bff90b801274bef5283a9820`. Os seis arquivos de runtime preexistentes foram copiados antes da edição, com hashes em `before-manifest.json`; novo script e UID estão identificados como arquivos novos. Para desfazer seletivamente, comparar os hashes finais do manifesto, restaurar somente os seis snapshots correspondentes e retirar somente os dois arquivos novos, preservando trabalho posterior. Nenhum reset amplo.

O perfil sintético fixo que um teste de controle altera em `.atena/generated/controller-experience/v01` foi restaurado ao conteúdo preexistente guardado no snapshot. O `.bak`, que estava limpo antes, foi restaurado byte a byte do HEAD. A tentativa de `git restore --worktree` encontrou `.git` somente leitura; a restauração usou apenas leitura de Git e escrita do arquivo de fixture. Não houve mudança de índice, commit ou push.

Os arquivos globais indicados em AGENTS.md não existem neste ambiente, e o backlog histórico em D: permanece indisponível. Aplicadas as instruções locais/ADD e a continuidade transferida. Nenhuma dependência instalada, recurso externo consultado ou save real carregado.

## Verificação final

Todas as invocações do runner primeiro comprovam o diretório de usuário em um projeto sem autoload, com APPDATA/LOCALAPPDATA redirecionados; só depois carregam o jogo e o perfil sintético. Logs completos preservados nas pastas abaixo.

| Check | Resultado | Sessão |
|---|---|---|
| Importação Godot | Sem SCRIPT ERROR/Parse Error | synthetic-20261022-042245 |
| Suíte completa final | `testes: 0 falha(s)`, sem SCRIPT ERROR/Parse Error | synthetic-20261022-042606/suite.log |
| Auditoria final | `RESUMO;erros=0;avisos=0` | synthetic-20261022-042606/audit.log |
| Interações específicas | 10/10: teclado, mouse após rolagem, bloqueio, atualização da seleção, controle entre listas, filtro QA, valores/ícones de resultado e separação relógio/fase | synthetic-20261022-042709/interaction.log |
| Capturas finais | 14 PNGs: sete cenários nas duas resoluções | synthetic-20261022-042826/after.log |
| Controle completo | Mesmas duas falhas e timeout já registrados no baseline histórico; fluxos do Quartel e ofertas passaram | synthetic-20261022-042133/controller.log |

O controle completo volta a reprovar `preferencias_persistem_reload` e `zona_morta_navegacao`; o encerramento não consegue gravar no diretório fixo v02 e termina no timeout de segurança. Isso reproduz a dívida histórica registrada na fila de assets, sem correção fora de escopo. O teste percorreu os fluxos de Quartel, ofertas, resultado e reinício. A prova específica de interação desta entrega passa separadamente; não substituir o FAIL geral por PASS.

O Godot continua emitindo `Failed to read the root certificate store`. Capturas também reproduzem as mensagens de limpeza de recursos/RIDs já presentes no baseline anterior à edição. Os checks de conteúdo e asserções passaram, mas os logs não são inteiramente limpos. Nenhuma alteração de certificados ou renderizador foi feita para ocultá-los.

## Capturas e aceite

Galeria `index.html`: 14 pares antes/depois, 28 links de imagem. Baseline anterior à edição: `synthetic-20261022-041412`. Para as ofertas, a primeira captura usou a modalidade de lista, então foi complementada por `synthetic-20261022-042820`: o script de cartão original preservado (apenas sem class_name para poder coexistir) executa o cenário de três/seis cartões com o item correto. O HUD de fundo dessa comparação complementar é o atual. Esse detalhe está explícito na galeria; não apresentar essas imagens como capturas antigas do executável inteiro.

Foram inspecionados visualmente cartões, rolagem/bloqueios, HUD, ofertas normal/compacta e resultado nas duas resoluções. O nome longo e o preço deixaram de colidir nos cartões compactos; cronômetro, fase e regra têm espaço próprio. A captura de HUD é um cenário isolado; não equivale a playtest de combate. Conforto, contraste e gosto visual aguardam o dono, pelo roteiro `playtest.md`.

U10/U12/U19/Q07, V10 sprite e N02–N10 seguem retidos. N01 e demais integrações anteriores preservados. Sem exportação, publicação ou promoção a CANON.

## Autorização de commit local

O dono autorizou «atena commite e  tem algo para ser gerado?» em 2026-10-22. O commit abrange os oito arquivos de runtime/UID, o registro próprio deste plano e as evidências/galeria desta integração. Não inclui transferências de assets nem modificações preexistentes em outros planos, AGENTS.md, ADD ou fixtures. O recibo local posterior fica em `commit-result.json`. Push e exportação continuam sem autorização; o pedido de commit não equivale a aceite visual das telas.

Os snapshots completos de recuperação em `before-files/` são locais. Os seis arquivos originais de runtime também podem ser recuperados do pai do commit desta integração. Logs e imagens referenciados pela entrega acompanham o commit; perfis e diretórios de usuário sintéticos não acompanham.
