# Nottgard - Abyss Megadungeon PC

Projeto Godot independente para Windows x86_64, derivado da base b83f188a. Godot 4.7.2 e GL Compatibility; mobile fica para um plano futuro. Nome técnico e schema de saves preservados.

## Desenvolvimento

Abra project.godot no editor. Todos os recursos de runtime ficam neste projeto. Não há sincronização automática com a outra versão. Para uma correção comum, registre o arquivo/base de origem, porte seletivamente e valide nos dois projetos; mudanças de plataforma ficam delimitadas. A origem histórica continua em D:/dev/nottgard/games/godot/nottgard-survivors.

## Candidatos locais

- Windows Desktop: build/NottgardSurvivors.exe
- Windows Playtest Publico: build/NottgardSurvivors-Playtest.exe
- Windows QA Interno: build/NottgardSurvivors-QA.exe

Use Testar-PC.cmd para um playtest com perfil sintético separado. Abrir o executável diretamente usa o diretório Windows compatível do jogo.

## Revisão humana

No CP-SPLIT-02, verificar início de tentativa, movimento, habilidade, ofertas, pausa/retomada, ficha e retorno ao Quartel. PC: testar teclado, mouse e controle físico. Web: testar Chrome, Edge e Firefox, foco, tamanho da janela, áudio após gesto e tela cheia. Observar dificuldade e diversão e relatar a plataforma/build; esses critérios não foram aceitos por testes automatizados.

Build IDs: b83f188a-split-pc-r1. Registro local em .atena/state/plan.yaml; matriz e evidências acompanham a entrega. Sem publicação automática.
