---
id: SPEC-NOTTGARD-DAGRUVE-VALIDATION-20261017
revision: r1
status: S_DAG_004_COMPLETE_AWAITING_CP_DAG_005
approval_mode: per-step
---

# S-DAG-004 — validação ampliada proposta

Etapa4/5, três concluídas e duas restantes. Entrada: [protótipo e verificações básicas](../../evidence/EVID-NOTTGARD-DAGRUVE-PROTOTYPE-20261017-r1.md). Executar regressões/capturas/custo do [contrato aprovado](dossier-r1.md), reutilizando os quatro testes básicos enquanto seus arquivos/aceitação permanecerem válidos. Conferir perfis e probe sintéticos antes de Godot.

Prioridades: Dagruve padrão versus baseline; capítulos/mapas aceitos; alvo/corredores e alternativas com blockers reais; fim aos180s/presença3s/cap32; morte/abandono/retorno/reentrada; HUD e resultado sem vitória sobre Thalion; capturas1280×720/1920×1080 com32 inimigos; simulação/loop A-B controlados e registro de portagem sem escrever na origem.

Investigar especificamente recursos retidos no encerramento headless rápido: aguardar carregamentos/limpezas pendentes e comparar baseline/variante antes de atribuir causa ao novo código; não suprimir erros do motor. Se falha exigir alteração além dos oito caminhos ou escrita na origem, preparar revisão antes de executar. Nenhum playtest humano, arte nova, geração ou integração de campanha nesta etapa.

Saída: relatório técnico, capturas, métricas e riscos resolvidos ou delimitados, para então propor S-DAG-005. CP-DAG-004 aguarda autorização própria.


Autorização explícita: “autorizado”. S-DAG-004 em andamento;3/5 concluídas. Hashes do protótipo reconferidos, testes básicos válidos reutilizados.


## Validação concluída — 4/5

[Resultado técnico](../../evidence/EVID-NOTTGARD-DAGRUVE-VALIDATION-20261017-r1.md):19 checks distintos válidos, Dagruve padrão equivalente ao baseline320s, capturas e A-B dentro do limite. Encerramento do harness limpo ao finalizar áudio antes de sair; sem alteração global de Sfx. [Playtest S-DAG-005](playtest-r1.md) aguarda autorização. Uma etapa restante.
