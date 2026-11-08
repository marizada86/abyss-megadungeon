# EVID-ABYSS-BUILD-0-6-0-20261107-r1

Estado: DRAFT. Build de Produção 0.6.0 para a playtest do próprio dono, gerada com autorização explícita no chat ("Sim, gerar build", 2026-11-07).

## Artefato
- `build/dist-0.6.0/NottgardSurvivors.exe` (preset "Windows Desktop", 705 130 752 bytes; `build/` fica fora do Git).
- SHA-256: `aad19eae35f6a85d9ca5cb8913f6ba3713e5ccbfd10f85cebc4581acafd55b1` (também em `build/dist-0.6.0/SHA256.txt`).
- Carimbo: commit `841dab25` sem `-dirty` (árvore limpa), versão `0.6.0`. O `data/build_info.json` foi removido depois da exportação (`stamp_build.ps1 -Clear`), então execuções locais voltam a mostrar "dev".
- Exportação: saída 0. Avisos do log: só "another project.godot at res://tmp/base-alpha-20261104, folder ignored" e nomes de arquivos com "warning"; `tmp/*` está no filtro de exclusão do preset.
- As builds anteriores (`build/NottgardSurvivors*.exe`, `dist-0.5.x`) não foram tocadas.

## Verificações (perfil sintético isolado em `tmp/smoke-060`; perfil real não carregado)
- Gate de release com 0.6.0 antes da build: `RELEASE-GATES: PASS` (suíte 0 falhas, auditoria 0 erros).
- Smoke headless do `.exe` (`--quit-after 600`): saída 0, log só no diretório sintético.
- Smoke com janela (`--resolution 1366x768 --quit-after 400`): saída 0, OpenGL 3.3 em NVIDIA GTX 1660 SUPER, caches de shader criados. No encerramento o motor registra "3 RID allocations of type GLES3 Texture leaked": ruído de saída do motor, não falha.

## Limites (não verificado)
- Não confirmei por log que o menu principal ou uma partida carregou: a Produção não grava o log de evidência. O smoke prova que o pacote abre, renderiza e fecha limpo.
- Trilha da campanha na Produção, ordem de liberação das fases, fim da campanha, controle físico, desempenho em Goranthis e Pilares: só a playtest humana confirma.
- Zip e LEIA-ME para testadores não foram gerados (adiados por decisão do dono).
- Merge em `main` e push seguem pendentes de sim explícito.

## Como testar (para a playtest do dono)
Abrir `build/dist-0.6.0/NottgardSurvivors.exe`. Abrir o executável diretamente usa o diretório de saves real do jogo; para um perfil separado, usar `Testar-PC.cmd` (que roda a build de Playtest). Roteiro: Docas, Reino Abissal, Domwieck, Dagruve, Shedaklah; depois salto a Goranthis e Pilares; um passe com controle.
