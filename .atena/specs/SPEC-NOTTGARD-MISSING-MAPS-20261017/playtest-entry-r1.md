---
id: DEV-NOTTGARD-MAP-PLAYTEST-ENTRY-20261017
revision: r1
status: COMPLETE_RETURNED_HUMAN_PLAYTEST_PENDING
classification: PLAN_DEVIATION
origin: planned
implementation_preceded_spec: false
---

# Entrada local de playtest dos mapas

Concluída em 2026-10-17. [Evidência da entrada e validação](../../evidence/EVID-NOTTGARD-MAP-PLAYTEST-ENTRY-20261017-r1.md). Etapa única 1/1 concluída, retorno ao CP-MAP-005 preservado; playtest humano não realizado pelo agente.

Correção IN_PLAN após relato de janela vazia: [evidência r2](../../evidence/EVID-NOTTGARD-MAP-PLAYTEST-ENTRY-20261017-r2.md). Entrada agora prepara o índice de classes/recursos após confirmar isolamento e antes da abertura, para reconhecer scripts novos da fonte local; falha de preparação/autoload encerra com registro. Mesmos arquivos/escopo, sem alterar a integração concorrente da campanha. Ambos os mapas novamente verificados.

Autorização do dono: “sim”, em resposta à oferta concreta de criar um atalho com escolha entre Reino Abissal e Domwieck, usando perfil separado do save. Trabalho local autorizado; modo per-step reutilizado, uma etapa S-MAP-ACCESS-001 de criação e validação da entrada. Não autoriza S-MAP-005 nem playtest humano em nome do dono.

Suspender somente o avanço do plano de mapas no CP-MAP-005, cursor S-MAP-004 concluída, 4/7; retornar ao checkpoint pendente após entrega. Preservar outros chats e reler estado antes da reconciliação.

Escopo delimitado: três arquivos novos, Testar-Mapas.cmd, tools/playtest_maps.ps1 e tools/playtest_maps.gd. Atalho abre seletor simples no Godot com dois mapas. Herói inicial Durvall, build sintética sem progresso real, controles existentes. Ao voltar ao Quartel no resultado, retornar à escolha dos mapas. Sem alteração de código de combate, catálogo de campanha, arte ou outros atalhos.

Antes de qualquer autoload do jogo: criar sessão exclusiva sob .atena/generated/map-playtest-sessions, APPDATA/LOCALAPPDATA do processo e --controller-profile sintético; executar sonda mínima sem autoload com configuração custom_user_dir idêntica e exigir caminho resolvido dentro da sessão. Falha interrompe abertura. Godot D:/Godot/godot.exe já instalado, sem dependência/instalação/configuração global. Apenas dados sintéticos, sem leitura/cópia do save real ou consulta remota.

Validação da própria entrada nos dois mapas: sonda de isolamento, abertura real em QA, mapa correto, posição inicial, perfil separado, retorno ao seletor e captura/relatório. Executar opção técnica de verificação com janela oculta, sem simular experiência humana. Sem repetir suite de combate inalterada. Registrar evidência e devolver CP-MAP-005 preservado.

Orientação antes do playtest humano: protótipos geométricos, objetivo avaliar movimento/rotas, clareza do destino e pressão das ondas; Reino Abissal 6 min e Domwieck 7 min, depois permanecer 3 s no círculo. WASD/setas ou mouse para andar, Q/botão direito para habilidade, Esc para pausa; controles de gamepad herdados. Feedback esperado: orientação, bloqueios, duração, dificuldade, conforto dos controles e conclusão. Arte final e integração da campanha permanecem pendentes.
