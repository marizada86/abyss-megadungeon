# SPEC-ABYSS-CODEX-LORE-20261027 · r1 (APROVADA; heróis, inimigos, armas e itens entregues, aguardando aceite visual das armas e itens e portagem)

Origem: pedido do dono em 2026-10-27: preencher o Códex do Quartel com biografias e curiosidades dos inimigos e ganhar uma aba de personagens jogáveis com curiosidades, imagens, HQs e extras, tudo com base no Vault de Nottgard.
Escopo: Windows x86_64. Fonte de lore: `F:\dev\nottgard-vault` (somente leitura; o Vault prevalece sobre o Nottcard). Sem recursos externos, sem dependências novas, sem commit, push ou publicação. Testes só com diretório sintético; nunca o save real (`user://Nottgard Survivors`).

## Situação encontrada

| Item | Hoje |
|---|---|
| Códex do Quartel (`ui/menu.gd` `_fill_codex`/`_show_codex`, `Tabs/Códex` em `ui/menu.tscn`) | 3 categorias: Inimigos, Armas e feitiços, Itens únicos. Lista + um `RichTextLabel`; sem imagem grande. |
| Fonte dos textos (`core/catalog.gd` `detail`) | Inimigos: linha de status + `note` de `enemies.json`. 17 dos 64 notes são só "Nottcard." ou vazios; sem biografia nem curiosidade. |
| Descoberta | `profile.data.codex.{enemies,items,weapons}`: booleano por id, sem contagem. Pausa (`ui/pause_menu.gd`) usa o mesmo `Catalog`. |
| Heróis | 12 em `data/heroes.json`; biografia em `data/hero_bios.json` (12 textos, tom das HQs, sem cânone do mestre), liberada pela conquista `bio_<id>` e mostrada só na aba Jogar. Retrato `assets/portraits/<id>.png`; ficha/HUD próprios só no piloto do Durvall (SPEC-ABYSS-HERO-PORTRAITS). |
| Extras que já existem | `chronicles.json` (12), `hqs.json` (21 HQs, painéis em `assets/hq/`), Ecos/Diário (`secrets.json`), ícones `assets/icons/codex/{herois,bencaos,passivas}.png` sem uso. |
| Vault | Criaturas: 13 arquivos em `07_Criaturas`. Os demais inimigos têm base em NPCs (Juiblex, Zuggtmoy), Locais (Rivenheart, Castelo Argento, Durao, Feng-tu, Molor, Goranthis…), Lore (Lu Yueh, Ghaunadaur, Gehenna), Organizações (Mente Derretida) e Itens. Heróis: 7 em `02_Personagens` e 5 em `03_NPCs` (Bromnor, Arlindo, Erik, Nyrelia, Zynara). |

## Decisões de projeto (recomendadas)

1. **Texto fora do código.** Novo `data/codex_lore.json` (`enemies`, `heroes`, opcional `items`), com `bio`, `curiosidades[]`, `fonte` (nota do Vault) e, nos heróis, `hqs[]` e `extras[]`. `Catalog.detail` passa a compor status + biografia + curiosidades. Nenhum texto novo em `.gd`.
2. **Sem mudança de save.** Descoberta continua booleana. Dossiê completo de chefe = chefe derrotado (`stats.boss_kills`, já existe); de herói = biografia já liberada (`bio_<id>`) e HQs já vistas. Contagem de abates por inimigo exigiria upgrade de save: fica como opção, não recomendada agora.
3. **Aba de heróis dentro do Códex.** Quinta opção do seletor, "Personagens", com o ícone `herois.png` que já existe. A pausa mantém as 3 categorias (a pausa é durante a run; spoiler de biografia ali não ajuda). Por isso `Catalog.CATEGORIES` não muda; entra `Catalog.QUARTEL_CATEGORIES`.
4. **Imagens: só o que já existe.** Retrato do herói (e ficha/HUD quando o piloto for aceito), sprite de caminhada, ícone da arma e da passiva, miniaturas dos painéis das HQs em que o herói aparece, arte de chefe (`assets/ui/boss-intros/`). Nenhuma geração nova, nenhuma cópia de `F:\dev\nottgard-vault\assets` sem aprovação.
5. **Regra de sigilo.** Nada do "cânone do mestre": segredo de Durvall (inclui o termo Receptáculo), identidade de Adam, morte de Bromnor, e qualquer coisa que o grupo não soubesse no momento. Em dúvida, o texto fica de fora e entra na lista de pendências para o dono.
6. **Sem invenção.** Entrada sem lastro no Vault ganha só o que está no jogo (nome, local, nota) e vai para o relatório "sem fonte"; não se preenche com texto plausível.
7. **Bloqueado não vaza.** Herói bloqueado aparece como silhueta, "???" e a dica da conquista que já aparece na aba Jogar. Inimigo não visto continua "???".

## Estrutura da tela (Códex)

Hoje: `Left` (seletor + lista) | `CodexText`. Proposta: `Left` | coluna direita com `CodexArt` (TextureRect, retrato, sprite ou arte do chefe), `CodexText` (rolável) e, só em Personagens, uma fileira `CodexGallery` de miniaturas (retrato, ficha, HQs) com setas e confirmação abrindo a HQ no visualizador do Diário. Obrigatório: navegação por controle (`menu.gd`, regra de foco linhas ~195-202), escala de texto e alto contraste da P1 de acessibilidade, resolução 1920x1080 e 1280x720.

Conteúdo por entrada:

| Categoria | Bloco |
|---|---|
| Inimigos | Arte; status (já existe); **Quem é** (2–4 frases); **Curiosidades** (1–3, 1 linha cada); **Onde aparece** (fases, a partir de `stage_story`/`stages`); **Fraqueza/dica** só quando já estiver nos dados; selo "Derrotado" em chefes. |
| Personagens | Retrato; ficha (atributos, arma, passiva, já existe); **Biografia** (reaproveita `hero_bios`); **Curiosidades** (3–5: família, idade em 1690, ligações, objeto marcante); **Nas HQs** (lista e miniaturas); **Extras** (cartas, diários e objetos do Vault ligados ao herói, só os de conhecimento do grupo). |
| Armas/Itens (fase opcional) | **História do objeto** de 1–2 frases onde existir arquivo em `06_Itens` (Machado de Xar'gath, Colar dos Tentáculos, Lâmina da Digestão, Cajado dos Desejos, Martelo da Glória, Sopro de Estrela, Chicote Avarento, Ampulheta…). |

Agrupamento de variantes (uma fonte, vários ids): `guardiao_copia`/`guardiao_verdadeiro`, `molydeus_menor`/`molydeus_chefe`, `cultista_*` por culto, `ilusao_*`, `slime_*`/`pudim_negro`/`bolha_de_slime` (séquito de Juiblex). Campo `igual_a: "<id>"` evita duplicar texto. Os 12 quebráveis recebem 1 linha de curiosidade cada, vinda do Local; não ganham biografia.

## Passos

| Passo | O quê | Saída | Gate |
|---|---|---|---|
| S-C01 | Inventário de fontes: tabela inimigo/herói → arquivos do Vault, com lacunas e trechos "cânone do mestre" marcados | `.atena/vault/drafts/CODEX-SOURCES-20261027-r1.md` | leitura do dono |
| S-C02 | Rascunho dos textos dos 12 heróis (curiosidades, extras, mapa herói→HQs) | `.atena/vault/drafts/CODEX-HEROES-DRAFT-r1.md` | **aceite de texto** |
| S-C03 | Rascunho dos textos de ~52 inimigos + 12 quebráveis, em lotes por região (Dagruve/Docas → Shedaklah → Molor → Durao → Feng-tu → Shendilavri/Goranthis → Pilares/Reino Abissal/Domwieck) | `.atena/vault/drafts/CODEX-ENEMIES-DRAFT-r*.md` | **aceite por lote** |
| S-C04 | `data/codex_lore.json` + `Catalog.detail/lore/QUARTEL_CATEGORIES` + liberação por chefe derrotado e bio | código e dados | testes verdes |
| S-C05 | UI: `CodexArt`, `CodexGallery`, opção Personagens, foco de controle, acessibilidade | `menu.tscn`/`menu.gd` | capturas |
| S-C06 | Testes: `test_codex_lore` (todo id tem entrada ou `igual_a`; limites de tamanho; termos proibidos; heróis bloqueados sem vazamento; fonte preenchida), ajuste de `test_catalog` e `test_quartel`, `run_all` e auditoria | 0 falhas | — |
| S-C07 | Capturas 1920x1080 e 1280x720 (base, 150%, alto contraste) de inimigo, chefe, herói liberado e herói bloqueado, com perfil sintético | `.atena/generated/codex-lore-20261027-r1/` | **aceite visual do dono** |
| S-C08 | Registro de portagem para a versão de origem (`D:/dev/nottgard/...`), hoje inacessível desta sessão; atualizar `plan.yaml` | — | — |
| S-C09 (opcional) | Armas e itens únicos com história do objeto | extensão do JSON | decisão do dono |

Ordem recomendada: S-C01 → S-C02 (heróis primeiro, é a parte nova e menor) → S-C04/S-C05 sobre heróis → S-C03 por lotes, cada lote com texto aceito antes de entrar no JSON.

## Riscos

- **Cobertura do Vault desigual.** Chefes e Juiblex/Zuggtmoy/Lu Yueh têm material; Esporo Voador, Escravo de Rivenheart, Guarda do Castelo Argento e as estátuas têm pouco. Mitigação: regra 6 e relatório de lacunas.
- **Spoiler.** O Vault mistura fato conhecido e cânone do mestre. Mitigação: S-C01 marca cada trecho; teste de termos proibidos; aceite de texto antes do JSON.
- **Colisão com o piloto de retratos.** Ficha/HUD só existem para o Durvall. A galeria usa `ui/hero_portraits.gd` (cai no retrato do menu quando a imagem não existe), sem depender do aceite do lote.
- **Arquivos já alterados no working tree** (`ui/run.gd`, `core/*_vfx.gd`, `plan.yaml`): fora desta frente; `ui/menu.*` e `core/catalog.gd` não estão entre eles.
- **Portagem.** A mudança é comum às duas versões; o registro S-C08 fica pendente enquanto a origem estiver inacessível.

## Decisões do dono (2026-10-27)

1. Armas e itens únicos (S-C09): depois.
2. Dossiê de chefe: por chefe derrotado, sem mexer no save. Heróis e HQs usam `hqs_seen` e `hero_bio_unlocked`, que já existem.
3. Os 12 quebráveis entram no Códex com 1 linha.
4. Aceite de texto: por lote.
5. `bencaos.png` e `passivas.png`: não abordados; seguem fora do escopo.

Aprovação registrada em `plan.yaml` (`codex_lore_20261027`). Execução começa por S-C01 e S-C02; produtos em `.atena/vault/drafts/CODEX-SOURCES-20261027-r1.md` e `CODEX-HEROES-DRAFT-20261027-r1.md`.

## Fora de escopo
Pausa durante a run, geração de arte nova, HQs novas, mudança de balanceamento, mudança de save, commit, push, publicação.
