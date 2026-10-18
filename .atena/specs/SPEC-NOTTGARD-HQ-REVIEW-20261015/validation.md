# Procedimento de validação — S-HQ-001, r1

## Baseline e recuperação

Manifesto: ../../generated/hq-review-20261015/baseline.json. Registra caminhos de origem, hashes SHA-256, tamanho e blob recuperável de 134 arquivos por versão: catálogo, 56 PNGs, metadados de importação, 10 retratos e scripts/testes pertinentes. Blobs idênticos são armazenados uma vez; o manifesto preserva o mapeamento separado de PC e Web. Todos foram conferidos contra origem e cópia ao produzir a evidência. Não copiar a pasta inteira de volta: recuperar somente caminhos aprovados e comparar modificações posteriores antes de substituir. O manifesto registra também hashes/configurações de project.godot, sem alterar esse arquivo.

Estática inicial: ambos têm 14 HQs, quatro quadros por HQ, legendas não vazias, 56 PNGs existentes com assinatura PNG e proporção dentro da tolerância 0,0021 do teste existente. Catálogo, imagens, retratos, leitor e teste de HQ são idênticos entre PC/Web. As diferenças registradas em core/game.gd, core/playtest.gd e tests/test_playtest.gd serão preservadas e consideradas nos checks; não portar scripts de plataforma inteiros para corrigir conteúdo.

## Isolamento antes de iniciar Godot

Não iniciar o jogo normal nem usar somente begin_qa_sandbox: Game._ready chama load_profile antes de entrar no sandbox e o encerramento consulta o perfil padrão. Evidência reutilizada: EVID-NOTTGARD-RESOURCE-CLEANUP-EXECUTION-20261012, seção de isolamento. Ela confirmou com Godot 4.7.2 que APPDATA/LOCALAPPDATA exclusivos do processo, mais --controller-profile explícito, direcionam dados a uma pasta sintética. As linhas custom_user_dir atuais foram registradas no baseline. Não inspecionar ou copiar o save real para verificar isolamento.

Na primeira validação executável, para cada plataforma:

1. Criar sessão inédita em .atena/generated/hq-review-20261015/validation/<plataforma>/<sessao>/ sob o PC, contendo appdata, localappdata, perfil sintético e logs. Não reutilizar sessões que possam conter dados de uma run anterior.
2. Definir APPDATA e LOCALAPPDATA somente no ambiente dos processos filhos. Antes de qualquer autoload, executar sonda mínima sem autoload, com as mesmas configurações custom_user_dir, para registrar OS.get_user_data_dir. Exigir caminho resolvido sob o diretório sintético; se falhar, parar. A sonda não chama Game e não abre perfis.
3. Passar --controller-profile com caminho absoluto ao perfil sintético antes do nome do teste: tools/run_one_test.gd usa o último argumento como test_nome. Reservar --path ao projeto correto e --log-file a um log da sessão. O isolamento do ambiente também cobre leituras de user://profile.json no QA e arquivos de Playtest/Sfx.
4. Rodar test_hqs nas duas versões após alterações de HQ; test_profile/test_playtest quando correspondentes à integração/fluxo, conforme a spec. Conferir código de saída e logs, não só contagem impressa. Não repetir checks sem mudança/falha/incerteza nova.
5. Fazer smoke visual do leitor nas resoluções planejadas, avanço/fechamento e replay, sempre com ambiente/perfil sintéticos. Apresentar objetivo, build, procedimento e critérios ao dono antes de playtest humano. Não declarar experiência de navegador por execução desktop do projeto Web; a conferência real do browser permanece obrigatória no aceite da versão Web.

Nenhum Godot ou perfil foi iniciado em S-HQ-001. Sondas, testes e smoke serão evidências da etapa que alterar conteúdo; esta etapa preparou o procedimento e concluiu a baseline estática.

## Portagem explícita

Para cada HQ aceita: reler o estado PC/Web, conferir hashes dos arquivos a substituir, registrar revisão aprovada e arquivos exatos; aplicar somente legendas/título aprovados e imagens aceitas, preservando demais HQs. Validar PC e Web e registrar diferenças/resultados. Escrever no projeto Web requer a permissão específica do ambiente, já autorizado pelo dono para este plano; nenhuma recópia automática global.
