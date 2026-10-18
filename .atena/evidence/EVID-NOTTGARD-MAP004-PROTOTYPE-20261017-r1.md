---
id: EVID-NOTTGARD-MAP004-PROTOTYPE-20261017-r1
revision: r1
status: COMPLETE_TECHNICAL_QA_PROTOTYPE
step: S-MAP-004
date: 2026-10-17
origin: planned
implementation_preceded_spec: false
---

# Domwieck — protótipo funcional verificado

Autorização explícita: “Atena, aprovado. Pode iniciar a S-MAP-004, criando o protótipo funcional de Domwieck conforme o dossiê r1, com testes isolados e aprovação por etapa.” Execução IN_PLAN, modo per-step, [escopo delimitado](../specs/SPEC-NOTTGARD-MISSING-MAPS-20261017/s004-prototype-scope-r1.md). Autoridade: contrato de mapas CANON r1, dossiê r1 aceito, direções de jardim vermelho/estrela azul-clara e Tarn. Sem especialista, serviço remoto ou produção de imagem. Formas geométricas continuam protótipo DRAFT, não acabamento visual final.

## Implementação e preservação

Definição somente em data/prototype_stages.json; cena ui/stages/domwieck.tscn com Ground/Sorted/Hero/SpawnPoints, 60×60, entrada (30,45), alvo (30,15), raio 2/presença 3 s após 420 s. Cap 54, tier 3, HP×2,2/dano×2,0/moedas×1,6, cinco ondas e elites nos 140/280 s conforme contrato. Sem chefe, Adam, NPC de escolta, vida da estrela, quedas, portão dinâmico, nova regra de dano ou Maré pós-chefe.

Calçamento frio contínuo, volumes élficos e fogo decorativo, floresta circular/jardim vermelho em (30,7), estrela azul-clara com feixe até arco azul da Tarn. Não antecipa Véu Vivo/ataque de Adam/queda da barreira. Arquitetura/flores/floresta/estrela inteiramente geométricas, sem transplantar casa de Dagruve, flor branca ou cristal vermelho. Identidade de personagens N/A para terreno/volumes; Ailalore segue identidade CANON pertinente. Seis cargas locais já conferidas como pequenos obstáculos fora das reservas de circulação e bolsões de combate. Piso e decoração não criam colisão oculta; risco de leitura visual foi conferido nas capturas técnicas.

HUD e aviso inicial agora usam o destino/tempo da definição, mostrando Santuário e sete minutos em Domwieck e Ritual/seis minutos em Reino Abissal. Conclusão reutiliza suporte verificado: cessar diretor ao limite, manter sobreviventes até presença, limpar sem abate/XP/drop/bosses e resultado QA sem pagar ou modificar perfil. Domwieck não abre HQ03 nem fecha capítulo nesta etapa; essa integração pertence a S-MAP-005. Sem transição QA automática entre os dois protótipos.

[Auditoria final](../generated/missing-maps-20261017/s004-final-validation.json): oito arquivos de jogo/teste alterados, exatamente os oito delimitados e abaixo do teto conservador 13. [Baseline anterior](../generated/missing-maps-20261017/s004-before/manifest.json) e cópias recuperáveis preservadas. Catálogo final dos nove mapas, definição de Reino Abissal, layouts anteriores, core/battle.gd, ui/menu.gd e cena de Reino Abissal permaneceram iguais às respectivas baselines desta etapa. Mudanças concorrentes/estado da HQ14 foram preservados; não restaurado cursor antigo.

## Checks executados e evidência

[Sessão de cinco verificações](../generated/missing-maps-20261017/s004-validation-20261017-164734-595/results.json), todas PASS: test_map_objectives, test_data, test_level_design, test_terrain e test_scripts_compile. O teste novo de objetivos agora roda a matriz completa para ambos os protótipos: tempo antes/exatamente/depois do limiar, presença/raio, saída/reentrada, pausa, dano sem reinício, morte/abandono, callback repetido, limpeza sem recompensas, QA sem chefe, cessar diretor sem ondas infinitas e cap. Inclui simulações integrais de 360+3 s e 420+3 s. Testa geometria da cena com props expandidos e grade de alcance real, eixo central, ruas laterais de quatro unidades e bolsões livres em Domwieck; materiais corretos, ausência de água/queda e spawns nas bordas. Também verifica chefe/Maré de Docas e chefes repetidos dos Pilares. Nenhum teste existente teve exigência afrouxada.

[Smoke OpenGL](../generated/missing-maps-20261017/s004-validation-20261017-164752-388/smoke-result.json): zero falhas e nenhum erro nos logs. Doze capturas no total, incluindo entrada/alvo nos dois mapas em 1280×720/1920×1080, jardim de Domwieck nas duas resoluções e resultados. Menu normal não inclui os protótipos, carregamento por QA funciona, início direto normal é bloqueado, destino/tempo/progresso estão corretos, resultado abre e perfil sintético permanece intacto. [Jardim 1280×720](../generated/missing-maps-20261017/s004-validation-20261017-164752-388/domwieck-1280x720-garden.png), [alvo 1920×1080](../generated/missing-maps-20261017/s004-validation-20261017-164752-388/domwieck-1920x1080-target.png) e entrada inspecionados diretamente: alvo/herói legíveis, jardim vermelho, floresta circular, estrela azul-clara e feixe conectando à Tarn visíveis. Escala/estética final não são aceitas por essa inspeção técnica.

Cada sessão executável foi precedida por sonda mínima sem autoload, confirmando OS.get_user_data_dir sob o diretório sintético da sessão. APPDATA/LOCALAPPDATA exclusivos do processo, perfil --controller-profile sintético, Godot D:/Godot/godot.exe. Nenhum save real carregado/copiado. Diff dos caminhos de jogo passou sem erros de whitespace. Não repetidos os demais checks já válidos da S-MAP-003 sem mudança relevante; não alegar execução da suíte inteira.

## Fechamento e próximo checkpoint

S-MAP-004 concluída tecnicamente: **4/7 etapas, três restantes**. Não há BLOCKING técnico remanescente do protótipo autorizado. Playtest humano, diversão/dificuldade, controles físicos e acabamento final permanecem pendentes. Sem assets gerados, dependências novas, escrita Web, commit/push/publicação; portagem Web continua DEFERRED no escopo PC-only aprovado.

Próximo objetivo S-MAP-005: integrar Docas → Reino Abissal → Domwieck → resultado/menu, HQs na ordem CANON, Diário e progresso aditivo/migração de perfis sintéticos novos/legados. Entradas: contrato e dossiê aceitos, dois protótipos verificados, sequências HQ aceitas e estado relido. Saída: fluxo integrado recuperável, sem atalhos nem perda/duplicação de direitos/recompensas. Antes de código, delimitar orçamento/consumidores e baseline da integração, confirmar admissão dos recursos narrativos e revalidar zero BLOCKING pertinente. Checks de fila/retomada, permissões, compatibilidade e finalização serão próprios da integração. **CP-MAP-005 pendente**, etapa não iniciada e não autorizada pelo pedido de S-MAP-004.
