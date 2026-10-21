---
id: PLAN-NOTTGARD-PLAYTEST-DISTRIBUTION-20261020
revision: r1
status: DRAFT_AWAITING_OWNER_APPROVAL
classification: PLAN_CHANGE_REQUEST
platform: windows-x86_64
mode: per-batch
parent: PLAN-NOTTGARD-RELEASE-0-5-0-20261018
content_state: DRAFT
---

# Plano: distribuir a 0.5.0 para os playtesters

Pedido (2026-10-20): o dono jogou a candidata e informa que funciona bem; elaborar plano e recomendações para lançar aos playtesters. **Este documento é só planejamento.** Nada foi alterado no jogo, no `plan.yaml`, no Git ou em exportações, e nada foi enviado ou publicado. Distribuir a build é publicação e exige pedido explícito (AGENTS.md).

## 1. Ponto de partida (verificado nesta leitura)

- Gates: G1 suíte 0/0, G2 auditoria 0 erros, G4 3 builds com smoke, G5 upgrade de save, G7 decisões: PASS. G3 não rodou (sem mudança de balanceamento). **G6 (playtest humano) era o único aberto**: o dono informou que jogou e funciona bem. Falta registrar isso na ficha (ver §3, passo 0).
- `main` está sincronizada com `origin/main` (0 commits locais à frente). A árvore só tem lixo não rastreado de bots (`old-*`).
- Build candidata: Godot 4.7.2, renderer `gl_compatibility`, 3 `.exe` de ~640 MB com PCK embutido, **sem assinatura**, gerados do commit `e3d0d44` + árvore de trabalho. `HEAD` já está em `b89c866` (correção do atalho de playtest).
- O build **Playtest Público** (`NottgardSurvivors-Playtest.exe`): abre todas as fases (B8), mostra build/versão no menu, grava relato (F5), captura (F6) e log em `evidencias/` **ao lado do executável**, e não envia nada automaticamente.

## 2. Riscos que eu corrigiria ou decidiria antes de enviar (em ordem de importância)

| # | Achado | Recomendação |
| --- | --- | --- |
| R1 | **Build ID = `dev`.** `tools/stamp_build.ps1` não existe neste repositório e `data/build_info.json` não foi gerado. Todo relato dos testers diria "build dev" e você não saberia a que commit se refere. | Gerar `data/build_info.json` (gitignored) com o hash do commit antes do export. Escrever o script no repositório, sem instalar nada. |
| R2 | **Builds não correspondem ao `HEAD`.** Foram exportados do `e3d0d44` com árvore suja. | Reexportar a partir de commit limpo e **marcado** (tag só com seu pedido explícito), rodar `tools/validate_release.sh` (G1+G2) e o smoke, regerar manifesto com SHA-256. |
| R3 | **Pasta `build/evidencias/` já tem seus relatos e logs.** Se alguém zipar `build/` inteira, eles vão junto. Hoje os 3 `.exe` estão lado a lado com ela. | Empacotar só o `.exe` do Playtest em pasta nova, vazia. Conferi que o log atual não contém nome de usuário nem caminho de usuário, mas não confie nisso: monte o pacote por cópia explícita. |
| R4 | **Canal de retorno confuso.** A fila `/api/playtest/*` do código só *enfileira*; não há envio nesta versão do PC. O menu mostra a aba "Ranking de playtest", que consulta `https://marizverso.com/api/playtest/leaderboard` ("somente testers aprovados"). Não testei o servidor (sem rede sem sua aprovação). | Decidir: (a) o servidor responde e há testers aprovados → manter; (b) não → esconder a aba no build público ou avisar nas notas que é inerte. De qualquer forma o retorno real é **manual**: tester zipa `evidencias\` e manda a você. |
| R5 | **Exe de ~640 MB.** Pesado para baixar e para o host. Arte (351 MB de HQ, 162 MB de animações) e áudio WAV (29 MB) vão sem otimização. | Mede o `.zip` real antes de decidir. Compactar para distribuição é seguro; converter áudio/arte muda o conteúdo e só com sua decisão. Para 5–10 testers, 1 zip serve. |
| R6 | **Sem assinatura:** SmartScreen e antivírus podem bloquear (Godot é alvo frequente de falso positivo). | Publicar o SHA-256 junto, avisar nas instruções ("Mais informações → Executar assim mesmo"), pedir que o testador reporte se o antivírus apagar. Assinatura de código fica para depois. |
| R7 | **Controle físico nunca foi testado em hardware.** | Declarar nas notas; pedir explicitamente a 1–2 testers que tenham controle. Não prometer. |
| R8 | **Hardware desconhecido** (só a sua máquina rodou). | Onda 1 pequena com máquinas diferentes antes da onda 2. Pedir GPU/CPU/RAM/resolução no relato. |
| R9 | **Conteúdo DRAFT/provisório visível:** 7 chefes sem cartaz, música reaproveitada nos 3 mapas novos, HQ05–HQ10 nas versões antigas, crônicas dos mapas novos não gravadas, eventos aleatórios dos mapas novos desligados, Raiz de Yggdrasil fora do build. | Notas de versão listam o que é provisório para o tester não reportar como bug. Nenhum gate DRAFT é promovido por esta distribuição. |
| R10 | **Fases profundas abertas por B8** mudam a experiência de campanha. | Dizer aos testers que o build público abre tudo de propósito e que a ordem da campanha está em P1 do roteiro. |
| R11 | **Save compartilhado:** abrir o `.exe` direto usa o diretório Windows real do jogo (o seu save). Os testers não têm esse problema; **você** teria. | Você só abre pelo `Testar-PC.cmd` (perfil sintético). Instruir os testers a extrair em pasta própria (não em "Arquivos de Programas", onde `evidencias\` não pode ser gravada). |

## 3. Passos propostos

**Passo 0 · Fechar G6 (você, ~5 min).** Responder quais sessões do roteiro (P1–P6) você realmente jogou e se o controle foi usado; eu registro a ficha, com "não avaliado" onde for o caso, e decido com você o que vira nota de versão. Também aceitar ou ajustar o rascunho de crônicas (`CHRONICLES-NEW-MAPS-DRAFT-r1.md`); sem aceite ele continua fora do jogo e do pacote.

**Lote A · Preparação técnica (eu, após sua aprovação do lote).**
1. R1: script de carimbo + `build_info.json`.
2. R2/R3: reexportar só o preset Playtest Público do commit limpo; smoke sintético; pasta de saída nova (`dist/` ignorada pelo Git).
3. R4: decisão sua sobre o Ranking; se esconder, é uma mudança mínima com teste.
4. R5: medir tamanho do zip; gerar zip + `SHA-256`.
5. Instruções curtas (PT-BR, 1 página): extrair, abrir, onde ficam relatos, teclas F1/F5/F6, como zipar `evidencias\`, o que fazer se o antivírus bloquear.
6. Notas de versão: o que mudou, o que é provisório (R9), o que pedimos para olhar (P1–P5 do roteiro, resumido em 6–8 perguntas).
7. Reler gates: G1, G2, G4 e G5 sobre a build nova. G3 só se houver mudança de balanceamento.

**Lote B · Onda 1 (2–3 testers de confiança, 2–3 dias).** Máquinas e perfis diferentes (um com controle, um com monitor 1280×720 ou notebook fraco). Objetivo: o pacote abre e o relato volta. Não é balanceamento.

**Lote C · Triagem e correção (eu).** Classificar cada relato em bug, ajuste de balanceamento ou adiar (formato de `human-feedback-r1.md`). Correções vão para um `0.5.1` com nova build, novo manifesto e releitura dos gates; qualquer dado comum de herói/arma exige portagem registrada à origem.

**Lote D · Onda 2 (5–10 testers).** Só depois de a onda 1 abrir limpo. Perguntas focadas: primeiro minuto dos mapas novos, Docas e heróis fracos (Arlindo/Nyrelia/Durvall, B2), desempenho, controle, mapas profundos.

## 4. Decisões que preciso de você

1. **Aprova o Lote A?** (preparar e reexportar localmente; nada sai da máquina.)
2. **Ranking:** manter a aba (se o servidor `marizverso.com` está no ar e há testers aprovados) ou esconder no build público?
3. **Como entregar o pacote** e a quem: link privado no seu servidor/drive ou GitHub Release privada/de rascunho? Eu só preparo o arquivo; **o envio e a tag são seus** (ou saem com pedido explícito).
4. **Quem são os testers da onda 1**, e quantos têm controle?
5. **Canal de retorno:** e-mail/Discord com o `.zip` de `evidencias\`. Você aceita receber arquivos manuais nesta fase?
6. **Aceite o rascunho de crônicas** ou adia para a 0.5.1 (R9)?

## 5. Fora do escopo desta distribuição

Mobile; produzir HQ05–HQ10 ou cartazes; assinatura de código; compressão de áudio/arte; servidor de upload automático; mapas bônus (ideia registrada); promoção de qualquer gate DRAFT a canon.

## 6. Critério de pronto para enviar

Build carimbada com o hash do commit, gerada de commit limpo, G1/G2/G4/G5 verdes sobre ela, pacote sem `evidencias\` seu, SHA-256 publicado, instruções e notas de versão aprovadas por você, e **seu pedido explícito de envio**.

## 7. Resultado do Lote A (2026-10-20; aprovado pelo dono, Ranking mantido; sem publicação, sem commit)

| Item | Resultado |
| --- | --- |
| R1 build ID | `tools/stamp_build.ps1` (novo; `-Clear` remove). Build carimbada `b89c8667`; confirmado dentro do exe. O carimbo da árvore de trabalho foi removido depois. Requer `powershell -ExecutionPolicy Bypass -File` (política do sistema bloqueia scripts) |
| R2 build limpa | Exportada de `git archive HEAD` em `tmp/dist-src`. **Achado:** durante a 1ª exportação alguém gravou edições não commitadas em `data/domwieck_art.json` e `ui/domwieck_art.gd` (escala do cenário de Domwieck, pasta `.atena/generated/domwieck-scale-20261020/`). O exe continha essas edições; **descartado e refeito** sem elas. As edições continuam intactas na árvore de trabalho e **não estão** no pacote |
| R3 pacote | `build/dist-0.5.0/Nottgard-Playtest-0.5.0.zip` (exe + `LEIA-ME.txt` + `NOTAS-DA-VERSAO.txt`), sem a pasta `evidencias`; extração verificada |
| R4 Ranking | **Mantido** (decisão do dono). Só faz `GET` em `marizverso.com`; **não testei se o servidor responde**. Correção ao §2: o jogo **tem** F7 (ZIP das evidências ao lado do exe); o guia embutido manda enviar na task do Discord |
| R5 peso | Zip ≈ exe (668 MB; o PCK não comprime). Reduzir exige mudar arte (351 MB de HQ) ou áudio WAV: decisão sua, não feita |
| R6 hash | SHA-256 do zip e do exe em `.atena/generated/release-0-5-0-20261018/dist-manifest-r1.json`; `LEIA-ME` explica SmartScreen e `certutil` |
| Gates | G1 PASS, G2 PASS (0 erros, 9 avisos), G4 PASS (smoke do exe do pacote), G5 PASS. G3 não rodou (sem mudança de balanceamento) |

O código do jogo no pacote é idêntico ao que o dono jogou (entre `e3d0d44` e `b89c866` só mudaram docs e o atalho `tools/playtest_maps.ps1`); a diferença é o carimbo de build.

**Pendência de decisão (descoberta ao fechar o lote):** as edições de Domwieck foram commitadas depois do export, em `8d71af2` ("Domwieck: scale up scenery and enlarge the Ailalore garden"). O pacote é do `b89c8667` e **não inclui** esse commit. Se o dono quiser a escala nova de Domwieck na 0.5.0, é preciso reexportar do `8d71af2`, repetir G1/G2/G4/G5 e regerar hashes (≈10 min); a mudança é visual e foi feita em outra frente, ainda sem validação por mim.
