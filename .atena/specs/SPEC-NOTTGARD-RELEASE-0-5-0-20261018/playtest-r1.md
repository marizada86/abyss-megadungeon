---
id: PLAYTEST-NOTTGARD-0-5-0-20261019
revision: r1
status: PREPARED_AWAITING_HUMAN_SESSION
content_state: DRAFT
builds: .atena/generated/release-0-5-0-20261018/build-manifest-r1.json
---

# Roteiro de playtest — v0.5.0 (Windows x86_64)

Não é publicação: três executáveis locais em `build/` (ignorada pelo Git). **Abrir pelos atalhos, não pelo `.exe`**: abrir o `.exe` direto usa o diretório Windows real do jogo (seu save); os atalhos usam perfil sintético separado.

| Como abrir | O que é |
| --- | --- |
| `Testar-PC.cmd` | Build **Playtest Público** com perfil sintético (`.atena/generated/review-profile`). Todas as fases abertas (decisão B8). Use este para o roteiro abaixo |
| `Testar-Mapas.cmd` | Seletor dos 3 mapas novos (Reino Abissal, Domwieck, Raiz de Yggdrasil — a Raiz é QA-only) com Durvall e dados de teste |
| `build\NottgardSurvivors-QA.exe` | QA interno (F4 navegador de destinos); só com perfil sintético |
| `build\NottgardSurvivors.exe` | Produção: segue a trilha narrativa (Shedaklah–Pilares bloqueadas). Só para conferir o gating |

Teclas úteis: WASD/setas ou mouse, **Q**/botão direito habilidade, **E** interagir, **C** ficha, **Esc** pausa, **F1** guia, **F5** anotação, **F6** captura local. Nada é enviado automaticamente.

## Sessões (tempo estimado 90–120 min no total, pode dividir em dias)

| Sessão | O que jogar | Foco da avaliação |
| --- | --- | --- |
| P1 · Capítulo 1 em ordem (30–40 min) | Perfil novo: Docas → Reino Abissal → Domwieck, lendo as HQs que abrirem (HQ15–HQ18, HQ03) | Início de Docas com herói novo; fluxo de marcos e HQs; objetivo de 3 s (seta, relógio, progresso); **primeiro minuto** dos mapas novos; troca de fase |
| P2 · Mapas novos isolados (15 min) | `Testar-Mapas.cmd`: os 3 mapas | Caminhos/bordas, legibilidade com 40 inimigos, arte, **música/ambiência reaproveitadas** (Pilares no Reino e na Raiz, Goranthis em Domwieck): combina ou incomoda? |
| P3 · Fases profundas (20–30 min) | Shedaklah → Pilares (agora abertas); pelo menos Shedaklah, Durao e Goranthis | Dificuldade e clareza das mecânicas de chefe (totens, giro, marca), chefes **sem cartaz de introdução** (B3): o ritmo de entrada faz falta? |
| P4 · Heróis (20 min) | Durvall, Arlindo, Nyrelia, Erik, Zynara, Leoric em Docas | Impressão de poder; os bots mostraram Arlindo/Nyrelia com pouco dano direto e Durvall recebendo muito dano em Docas: é real para você? |
| P5 · Interface, áudio e controle (20 min) | Quartel → Opções (1280×720 e 1920×1080, fonte, filtro visual, atmosfera, dicas), pausa, volumes, resultado (vitória/derrota/revive); **controle físico** | Foco e leitura; conforto; controle nunca testado em hardware |
| P6 · Portagem (H-PORT) | `.atena/specs/SPEC-NOTTGARD-SOURCE-PORT-20261018/human-review-r1.md` (H-PORT-001…008) | Itens ainda não avaliados da portagem |

## O que já foi verificado por máquina (não precisa repetir)

Suíte 0 falhas e 0 erros de script; auditoria 0 erros; upgrade de save 0.4.0→0.5.0 com perfil sintético; os 3 executáveis abrem e carregam recursos; os 3 mapas novos são concluíveis por bot; versão 0.5.0.0 nos três.

## Gates que continuam DRAFT (nada aqui os encerra)

Durvall/M1, G-D4, bugs visuais de identidade/passada, candidatos retidos (Nyrelia YN/YE); HQ05 aguarda seu aceite; crônicas dos mapas novos aguardam seu aceite do rascunho.

## Ficha de feedback (preencher por sessão)

Use `human-feedback-r1.md` (portagem) como modelo; para a 0.5.0, por item: **Avaliado? (sim/não) · Funcionou? · Dificuldade (fácil/ok/difícil) · Diversão (1–5) · Bug (descrição, mapa, herói, o que fazia) · Captura (F6)**. Triagem posterior: bug / ajuste de balanceamento / adiar. Para G6 basta que cada sessão esteja **avaliada**, não aprovada.
