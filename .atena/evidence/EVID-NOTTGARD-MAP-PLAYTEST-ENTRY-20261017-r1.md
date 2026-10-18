---
id: EVID-NOTTGARD-MAP-PLAYTEST-ENTRY-20261017-r1
revision: r1
status: COMPLETE_ENTRY_VERIFIED_HUMAN_PLAYTEST_PENDING
date: 2026-10-17
---

# Entrada de playtest entregue

Desvio DEV-NOTTGARD-MAP-PLAYTEST-ENTRY-20261017, S-MAP-ACCESS-001, autorizado pelo “sim” do dono à oferta concreta de atalho com seleção Reino Abissal/Domwieck e perfil separado. [Escopo anterior à implementação](../specs/SPEC-NOTTGARD-MISSING-MAPS-20261017/playtest-entry-r1.md). Criados somente três arquivos de entrada: Testar-Mapas.cmd, tools/playtest_maps.ps1 e tools/playtest_maps.gd. Sem mudança no combate, catálogo final ou integração de campanha; Testar-PC.cmd preservado.

Testar-Mapas.cmd invoca PowerShell com configuração apenas do processo. A preparação cria uma sessão inédita sob .atena/generated/map-playtest-sessions, com APPDATA/LOCALAPPDATA e --controller-profile sintéticos. Antes de qualquer autoload do jogo, executa sonda Godot mínima sem autoload com custom_user_dir igual ao projeto; exige resultado sob a sessão. Falha bloqueia a abertura. Não instala/configura globalmente nada. O jogo abre pela fonte local com D:/Godot/godot.exe; não depende de exportar uma build antiga.

O seletor oferece dois botões de mapa, objetivo/tempos, controles e indicação de arte provisória. Abre QA com Durvall, seed fixa e perfil sintético, sem copiar progresso real. A ação de voltar ao Quartel após resultado é redirecionada ao seletor desta entrada. Cada nova abertura do atalho cria outra sessão; perfis anteriores de teste ficam preservados. Scripts GD técnicos não são entrada recomendada isoladamente: o uso humano é pelo atalho que prepara o isolamento antes dos autoloads.

## Validação da entrada

- [Reino Abissal](../generated/map-playtest-sessions/20261017-165620-965-4a77c1a0/launch-verification.json): zero falhas; abertura real QA correta, save no sandbox sintético, captura do mapa e retorno ao seletor.
- [Domwieck](../generated/map-playtest-sessions/20261017-165636-800-e24d69d5/launch-verification.json): zero falhas; mesmas verificações, sessão distinta.
- Ambas as sondas confirmaram OS.get_user_data_dir sob os respectivos APPDATA exclusivos. Os logs finais de motor foram conferidos sem erros; capturas mostram a seleção e o destino abertos. [Tela de escolha](../generated/map-playtest-sessions/20261017-165620-965-4a77c1a0/selecao-mapas.png) inspecionada, botões e instruções legíveis em 1280×720.
- A primeira verificação expôs foco diferido em botão cuja tela já havia sido trocada durante automação; corrigido para foco imediato com nó na árvore. As duas execuções finais passaram. Uma falha transitória de criação do ambiente de processo da ferramenta exigiu aguardar e repetir a leitura; não alterou permissões nem o jogo.

As verificações chamaram a preparação real do launcher com seleção automática e janela oculta para validar, sem conduzir playtest humano. Não repetida a suíte de combate, pois não houve mudança de combate. Nenhum save real foi carregado/copiado, nenhuma escrita Web, dependência, geração remota, commit ou publicação.

## Uso e retorno

Dono deve abrir Testar-Mapas.cmd, escolher mapa, avaliar movimento/rotas, clareza do objetivo e pressão/duração. Reino Abissal: sobreviver 6 min; Domwieck: 7 min; depois permanecer 3 s no círculo seguindo a seta. WASD/setas ou mouse para andar, Q/botão direito para habilidade, Esc para pausa; controles de gamepad herdados. Feedback útil: onde se perdeu/prendeu, se o alvo ficou claro, se a pressão/duração parecem adequadas e se concluiu. Arte geométrica, sem integração de HQs/campanha ainda. Critérios subjetivos e avaliação de controles físicos permanecem pendentes do dono.

S-MAP-ACCESS-001 concluída, 1/1. Retorno ao plano de mapas r1, cursor S-MAP-004 concluída, **4/7 etapas**, CP-MAP-005 e aprovação da integração ainda pendentes. Não executada S-MAP-005 e não marcado playtest humano como realizado.
