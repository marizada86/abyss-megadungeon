---
id: EVID-NOTTGARD-MAP-PLAYTEST-ENTRY-20261017-r2
revision: r2
status: CORRECTED_VERIFIED_HUMAN_PLAYTEST_PENDING
date: 2026-10-17
supersedes: EVID-NOTTGARD-MAP-PLAYTEST-ENTRY-20261017-r1
---

# Correção da janela vazia no atalho

Pedido “não abriu” com captura de janela cinza: correção IN_PLAN da entrada de playtest autorizada, sem novo escopo de campanha. O log da tentativa .atena/generated/map-playtest-sessions/20261017-165913-432-631fbf49/engine.log identificou a causa inicial: core/game.gd passou a referenciar ChapterFlow, mas o índice local .godot/global_script_class_cache.cfg não continha a classe. Falha de parse impediu o autoload Game; erros de controls/profile em Playtest/Sfx eram consequências. Não houve necessidade de alterar o trabalho de integração em core/game.gd ou core/chapter_flow.gd.

Corrigidos somente tools/playtest_maps.ps1 e tools/playtest_maps.gd, dentro da entrada autorizada. Após a sonda de isolamento e antes de abrir a janela interativa, o launcher executa a preparação/importação do Godot em modo editor sem janela, usando APPDATA/LOCALAPPDATA e perfil sintéticos da mesma sessão. Isso atualiza o índice derivado de classes e recursos. Saída não zero ou erro de parse interrompe a abertura com caminho de registro. O bootstrap também encerra com falha explícita se o autoload Game não estiver disponível, evitando prosseguir com referências nulas. Testar-Mapas.cmd continua sendo o mesmo atalho.

## Validação

- [Reino Abissal](../generated/map-playtest-sessions/20261017-170047-785-15db8e48/launch-verification.json): PASS, abertura QA, perfil no sandbox e retorno ao seletor, zero falhas.
- [Domwieck](../generated/map-playtest-sessions/20261017-170123-223-cb40e919/launch-verification.json): PASS nas mesmas condições, incluindo o bootstrap com guarda de autoload.
- Logs finais de preparação/motor conferidos sem SCRIPT ERROR/Parse Error/ERROR. Índice derivado passou a registrar ChapterFlow. Cada sessão teve sonda mínima sem autoload confirmando user_data_dir dentro da pasta sintética antes de preparar/abrir o projeto.
- A guarda final da preparação foi conferida contra os logs finais sem erros; nenhum novo teste de combate necessário para essa guarda de leitura. Script PowerShell validado sintaticamente. Nenhuma instalação/permissão/configuração global ou mudança de regras da campanha.

A preparação é executada a cada abertura para acompanhar scripts novos da fonte local. Não carregar o .gd diretamente como alternativa ao atalho: a preparação e o isolamento são feitos pelo wrapper. Pedir ao dono fechar a janela cinza anterior e abrir novamente Testar-Mapas.cmd, aguardando a preparação. Objetivos/controles e feedback do playtest são os mesmos da r1; avaliação humana permanece pendente.

Estado de mapas preservado no checkpoint compartilhado mais recente. Esta correção não autoriza S-MAP-005, não substitui o trabalho de outro chat, não repete suite inalterada, não acessa save real nem escreve Web/publica.
