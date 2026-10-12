---
id: SPEC-NOTTGARD-PLATFORM-SPLIT-20261012
revision: r1
status: DRAFT_AUTHORIZED_LOCAL_R1
origin: guided-add
implementation_preceded_spec: false
---

# Separação de Nottgard para PC e web

Nottgard - Abyss Megadungeon terá dois projetos Godot independentes, especializados por plataforma. O dono confirmou em 2026-10-12 a estrutura abaixo e os alvos Windows e navegador de computador. O planejamento usa aprovação por plano; a execução depende do CP-SPLIT-01.

## Escopo

| Versão | Projeto de destino | Alvo inicial |
| --- | --- | --- |
| PC | `D:/dev/nottgard/games/launcher-pc/nottgard-abyss-megadungeon` | Windows x86_64, teclado, mouse e controles existentes |
| Web | `D:/dev/nottgard/games/launcher-web/nottgard-abyss-megadungeon` | Navegadores de computador; controles compatíveis existentes |

Origem preservada: `D:/dev/nottgard/games/godot/nottgard-survivors`. Não será apagada, movida, convertida em mobile ou declarada obsoleta durante este plano. Seu conteúdo continua sendo evidência histórica e ponto de recuperação; mobile aguarda uma spec futura.

Cada destino terá `project.godot`, recursos locais, testes pertinentes, instruções, contrato ADD e estado próprio. Sem links simbólicos, dependência de arquivos da origem ou sincronização automática entre versões. Mecânicas, dados e arte começam da mesma base registrada por hashes. Evolução comum exige portagem explícita, identificação da versão de origem e checks no destino; mudanças específicas podem divergir deliberadamente.

## Especialização

PC mantém exports Windows normal, playtest e QA, evidências em arquivos locais e comportamento de teclado, mouse e controle. Remover o preset Web e a shell HTML do projeto PC; substituir os caminhos ativos de JavaScriptBridge e recursos exclusivamente web pelos equivalentes locais existentes. Nenhum fluxo poderá exigir navegador para iniciar uma partida local já suportada.

Web mantém o export e a shell HTML Web, integração existente de sessão/evidências e comportamento de navegador. Remover exports Windows e funcionalidades exclusivamente nativas, mantendo as alternativas de download/recebimento já existentes. A autenticação e a proteção de acesso do launcher continuam sendo requisitos; falhas de sessão nunca liberam acesso anônimo.

Ambos deixam de oferecer controles, flags de preview e tratamento de layout exclusivos de mobile. A remoção será por chamada/recurso identificado: APIs usadas pela interface de computador podem ser mantidas ou adaptadas. Não apagar uma classe compartilhada somente pelo nome `touch`. Testes mobile ficam preservados na origem e não integram a suíte de aceitação dos novos alvos.

## Compatibilidade

Preservar nome oficial CANON r1, conteúdo, IDs `nottgard-survivor` e `nottgard-survivors`, schema de save e identidade técnica `config/name="Nottgard Survivors"`. A separação de pastas não autoriza trocar o diretório `user://`, migrar saves reais nem criar sincronização PC/web. Testes usarão perfis sintéticos isolados; nunca abrir o perfil real para smoke ou QA. A execução simultânea de cópias PC com o mesmo diretório de save deve ser evitada na validação.

Manter engine e renderer existentes até preflight confirmar a versão efetivamente disponível e os templates compatíveis. O projeto declara features 4.7 e o README cita templates 4.7.2; nenhuma atualização ou instalação faz parte do plano. Preservar perfis de produção/playtest/QA sem dar acesso administrativo a jogadores.

## Fora do escopo

Mobile, Linux/macOS, novas mecânicas, nova arte, balanceamento, correções gerais de backlog, integração de save remoto, reestruturação do launcher, migração de contas, repositórios remotos, dependências novas, commits, push, merge, deploy e publicação. Nenhum artefato publicado será substituído. Preparar builds locais não equivale a admitir ou distribuir o jogo no launcher.

## Impactos e recuperação

A duplicação aumenta armazenamento e exige portagem consciente de correções comuns. Registrar uma matriz de arquivos comuns e específicos, a origem de cada mudança e como testar paridade. Não copiar `.git`, `.godot`, builds antigos, executáveis da engine, segredos, saves, arquivos temporários ou todo o acervo `.atena/generated` e evidências pessoais. Recursos importados `.uid` e configurações de importação pertinentes são preservados; caches são regenerados nos destinos após aprovação.

Antes de copiar, reler os estados compartilhados e registrar manifesto dos arquivos selecionados, hashes e modificações locais. Qualquer destino ocupado inesperadamente interrompe a cópia para análise; não sobrescrever. Recuperação mantém a origem intacta e identifica somente arquivos produzidos pelo plano, sem apagar mudanças posteriores. Não copiar pipelines capazes de publicar automaticamente.

O pedido é PLAN_CHANGE_REQUEST perante PLAN-071/SPEC-138, B-006/S-011, aguardando aceite de dispositivos. Não substitui esse plano. Após aprovação da execução, persistir suspensão delimitada e cursor/aprovação de retorno na origem, relendo o estado mais recente. Preservar planos de arte, nome, launcher e publicações concorrentes. A proposta fica no ADD de Marizverso, workspace deste chat; esta preparação não escreve na origem ou nos destinos externos.

## Gaps

| ID | Classe | Tratamento |
| --- | --- | --- |
| GAP-SPLIT-01 | RESOLVED | Duas subpastas independentes, origem preservada; confirmação do dono em 2026-10-12 |
| GAP-SPLIT-02 | RESOLVED | Windows e navegador de computador; aprovação por plano selecionada |
| GAP-SPLIT-03 | RESOLVABLE | Inventário completo, baseline de testes, engine/templates e recursos transitivos serão verificados em S-SPLIT-001; não modificar fontes antes desses checks |
| GAP-SPLIT-04 | RESOLVED | Atualização Git autorizada e conciliada em DEV-SPLIT-GIT-SYNC-20261012: HEAD b83f188a, main alinhada a origin/main; alterações locais mantidas ou conciliadas com backups; manifestos do filesystem continuam autoritativos |
| GAP-SPLIT-05 | DEFERRED | Estrutura mobile e demais sistemas PC requerem novo plano |
| GAP-SPLIT-06 | DEFERRED | Admissão/distribuição nos launchers e publicação exigem pacote e aprovação próprios |

Zero gaps BLOCKING de produto/estrutura. CP-SPLIT-01 aprovado pelo dono em 2026-10-12 (“aprovado”), por plano. Escritas externas delimitadas revisadas pelo ambiente. Uso do DRAFT r1 autorizado para implementação; nenhuma nova promoção canônica.

## Plano de voo e validação

Cinco etapas em três lotes, detalhadas em [plan.md](plan.md) e [tasks.md](tasks.md). Aprovação por plano abrange somente a execução local concreta descrita nesta revisão. Checks: hashes e referências, importação/parse em cada destino, suíte comum e específica, save sintético, smoke de run, exports Windows/Web e testes de navegador. Registra-se o que foi executado, falhas de baseline e pendências humanas conforme [acceptance.md](acceptance.md).

## Evidência e reconciliação

[Evidência de preparação](../../evidence/EVID-NOTTGARD-PLATFORM-SPLIT-PREPARATION-20261012.md). [Inventário inicial](../../generated/platform-split-inventory-20261012.json). Após execução, acrescentar manifestos finais, logs, diferenças por plataforma e estado de aceite; confirmar integridade da origem e fechar a suspensão preservando aprovações anteriores. Nenhuma promoção canônica é realizada por este DRAFT.

Base atualizada antes da separação em 2026-10-12: [recibo da atualização Git](../../evidence/EVID-NOTTGARD-GIT-SYNC-20261012.md) e [manifesto de conciliação](../../generated/platform-split-git-reconciliation-20261012/manifest.json). Foram integrados 43 commits, mantendo registros recentes e addenda locais. O Godot 4.7.2 disponível concluiu a importação sem erros de parse após reparar um apóstrofo inválido preexistente em ui/run.gd. Templates e testes de gameplay continuam sendo preflight da execução; o inventário inicial é evidência histórica e não deve ser usado como snapshot da base atual. Escopo r1, alvos, cinco etapas e CP-SPLIT-01, aprovado em 2026-10-12, permanecem no mesmo escopo.

Execução local concluída nas cinco etapas: [evidência](../../evidence/EVID-NOTTGARD-PLATFORM-SPLIT-EXECUTION-20261012.md). CP-SPLIT-02 pendente de playtest e aceite humano.
