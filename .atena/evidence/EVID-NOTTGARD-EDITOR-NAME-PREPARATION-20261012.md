---
id: EVID-NOTTGARD-EDITOR-NAME-PREPARATION-20261012
revision: r1
date: 2026-10-12
status: PREPARATION_PASS_IMPLEMENTATION_PENDING
---

# Preparação do nome no editor

Leitura de add.yaml, plano ativo, project.godot dos dois destinos, core/game.gd e CANON DEC-NOTTGARD-NAME-20261011-r1. Ambos declaram Nottgard Survivors e não configuram diretório customizado. Game usa user://profile.json, sem mudança de schema. O pedido exige rever a antiga decisão de manter config/name, preservando o objetivo de compatibilidade.

Propriedades corretas: application/config/use_custom_user_dir e application/config/custom_user_dir_name, com override custom_user_dir_name.web. Fonte primária: [ProjectSettings 4.7](https://github.com/godotengine/godot/blob/4.7/core/config/project_settings.cpp). Algoritmo de user://: [core/os/os.cpp](https://github.com/godotengine/godot/blob/4.7/core/os/os.cpp), Windows [os_windows.cpp](https://github.com/godotengine/godot/blob/4.7/platform/windows/os_windows.cpp) e Web [os_web.cpp](https://github.com/godotengine/godot/blob/4.7/platform/web/os_web.cpp).

Antes, o ramo padrão monta get_godot_dir_name()/app_userdata/Nottgard Survivors. O ramo customizado pode manter exatamente esse mesmo caminho relativo, enquanto config/name recebe Nottgard - Abyss Megadungeon. Windows usa Godot com inicial maiúscula; Web herda godot em minúsculas. Por isso o override .web é parte da proposta, evitando mudança de pasta em ambiente de navegador.

Engine local Godot 4.7.2.stable.official.ed1daf0bf. Seis sondas: PC/Web, cada um antes/depois e com feature Web habilitada no editor runtime. PASS em todas, fixture sintética com valor 42 escrita antes e carregada depois; nenhum autoload/jogo aberto e nenhum save real acessado. APPDATA/LOCALAPPDATA restritos ao ambiente dos processos e caminhos sintéticos verificados. Windows antes/depois exatamente iguais. A sonda da feature Web confirma a seleção da propriedade lowercase; a equivalência /userfs foi verificada no código oficial, não em browser real.

[Resultados e hashes](../generated/editor-name-preparation-20261012/results.json) e logs por plataforma/fase na mesma pasta. Candidatos project.godot salvos para revisão; originais, comentário, README e canon não foram modificados nesta preparação. Pequenas sondas temporárias estão na pasta de visualizações deste chat e serão removidas na execução após evidência PASS.

Próximo checkpoint: [SPEC-NOTTGARD-EDITOR-NAME-20261012 r1](../specs/SPEC-NOTTGARD-EDITOR-NAME-20261012/spec.md), CP-EDITOR-NAME-01 pendente, por plano proposto. Atualização pontual e portagem em ambos; fonte histórica não será alterada. Plano de separação e aceite humano preservados.
