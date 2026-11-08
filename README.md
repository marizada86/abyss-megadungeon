# Nottgard - Abyss Megadungeon PC

Abyss Megadungeon é o mesmo jogo que nottgard-survivor, apenas com o nome novo; o repositório antigo é histórico. Projeto Godot independente para Windows x86_64, derivado da base b83f188a. Godot 4.7.2 e GL Compatibility; mobile fica para um plano futuro. O editor exibe Nottgard - Abyss Megadungeon. Diretório legado, IDs e schema de saves preservados por configuração explícita de user://.

## Desenvolvimento

Abra project.godot no editor. Todos os recursos de runtime ficam neste projeto. Não há sincronização automática com a outra versão. Para uma correção comum, registre o arquivo/base de origem, porte seletivamente e valide nos dois projetos; mudanças de plataforma ficam delimitadas. A origem histórica continua em D:/dev/nottgard/games/godot/nottgard-survivors.

## Candidatos locais

- Windows Desktop: build/NottgardSurvivors.exe
- Windows Playtest Publico: build/NottgardSurvivors-Playtest.exe
- Windows QA Interno: build/NottgardSurvivors-QA.exe

Use Testar-PC.cmd para um playtest com perfil sintético separado. Abrir o executável diretamente usa o diretório Windows compatível do jogo.

## Organização do repositório

- `core/`, `ui/`, `data/`, `assets/`: código, interface, dados e arte de runtime. `assets_incoming/` guarda fontes de arte ainda não integradas.
- `tests/` e `tools/`: suíte (`tests/run_all.gd`), auditoria (`tools/audit_projeto.gd`) e gates de release (`tools/validate_release.sh`).
- `.atena/`: Atena Driven Development 0.5.0. `methodology/0.5.0/` é a metodologia local; `specs/` guarda specs e planos; `vault/drafts/` guarda rascunhos (DRAFT, não canônicos); `evidence/` e `generated/` guardam evidências e capturas.
- Estado de plano: cada conversa grava o seu em `.atena/state/conversations/<chave>/plan.yaml`. `.atena/state/plan.yaml` é o registro legado (somente leitura, não é lido pelo validador novo).
- `build/`, `tmp/`, `evidencias/` e `Godot/` são locais e ficam fora do Git.

## Validação

```bash
bash tools/validate_release.sh            # gate completo em perfil sintético isolado (suíte + auditoria)
bash tools/validate_release.sh --quick    # só contratos de versão e plataforma
node .atena/methodology/0.5.0/tools/validate-add-state.cjs --conversation <chave> --require-executable
```

O gate nunca carrega o save real. O alpha demo usa o preset de Produção "Windows Desktop"; o checkup e as recomendações estão em `.atena/vault/drafts/ALPHA-CHECKUP-20261104-r1.md` e `ALPHA-POLISH-RECOMENDACOES-20261104-r1.md`.

## Revisão humana

No CP-SPLIT-02, verificar início de tentativa, movimento, habilidade, ofertas, pausa/retomada, ficha e retorno ao Quartel. Testar teclado, mouse e controle físico (o controle físico nunca foi testado). Observar dificuldade e diversão e relatar a plataforma/build; esses critérios não foram aceitos por testes automatizados.

Base de origem: b83f188a (histórica). Versão atual no código: 0.5.2 (o alpha demo ainda não tem número definido). Registro histórico em .atena/state/plan.yaml; planos novos em .atena/state/conversations/. Sem publicação automática.
