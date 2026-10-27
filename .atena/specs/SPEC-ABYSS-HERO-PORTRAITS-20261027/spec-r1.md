# SPEC-ABYSS-HERO-PORTRAITS-20261027 · r1 (DRAFT, piloto Durvall aprovado para preparação)

Origem: pedido do dono em 2026-10-27: o HUD da run e a Ficha do Herói (C) mostram o mesmo retrato do menu/Quartel; trocar por imagens próprias para variar.
Escopo: Windows x86_64. Nenhum código de runtime novo: o resolvedor da SPEC-178 (`ui/hero_portraits.gd`) já carrega `assets/portraits/hud/<id>.png` e `assets/portraits/ficha/<id>.png` e cai no retrato do menu quando elas não existem. Sem mudança de save, de dados ou de balanceamento. Sem recursos externos dentro do projeto: a arte é gerada pelo dono fora dele e entra por `assets_incoming/`.

## Situação encontrada

| Tela | Código | Imagem hoje | Efeito |
|---|---|---|---|
| Menu / Quartel | `ui/menu.gd` | `assets/portraits/<id>.png` (640×427) | Referência de apresentação. Não muda. |
| HUD da run | `ui/hero_panel.gd` (`HeroPortraits.HUD`, caixa 76×76, `COVERED`) | nenhuma própria; fallback no menu, cortado em quadrado | Rosto vira borrão a 76 px. |
| Ficha (C) | `ui/character_sheet.gd` (`HeroPortraits.FICHA`, caixa 250×90, `COVERED` se própria) | nenhuma própria; fallback no menu, centralizado inteiro | Mesma imagem do menu numa faixa pequena. |

Os 12 heróis: arlindo, bromnor, brook, durvall, erik, kayron, korrak, leoric, maelor, nyrelia, sylas, zynara. `tests/test_hero_portraits.gd` já valida 768×256 (Ficha), 256×256 (HUD), o fallback e o modo de escala.

## Contrato de arte (vale para todos os heróis)

| Tela | Arquivo final | Tamanho | Papel | Composição |
|---|---|---|---|---|
| Menu / Quartel | `assets/portraits/<id>.png` | 640×427 (existe) | Apresentação: busto em 3/4, pose heroica | Não muda. |
| HUD | `assets/portraits/hud/<id>.png` | 256×256 | Reconhecer o herói a 76 px | Close do rosto e do colarinho, olhando para a câmera, expressão de combate. Cabeça ocupa pelo menos 60% da altura. Sem arma, sem efeito. Fundo escuro liso com leve vinheta. |
| Ficha (C) | `assets/portraits/ficha/<id>.png` | 768×256 (3:1) | Cena do herói no seu mundo | Corpo inteiro ou três quartos em ação ou repouso, em perfil ou 3/4 para a direita, num cenário do herói. O assunto fica no terço central; as laterais têm cenário ou espaço vazio. |

Regras comuns:
- Identidade pela imagem CANON do Vault (as 4 vistas e as expressões); o retrato atual do menu entra só como referência de estilo, nunca de composição.
- Mesmo estilo do jogo: pintura densa de inspiração pixel-art, contorno escuro, paleta sombria e dessaturada, realces dourados quentes, luz de contorno vinda do alto à esquerda.
- Zona segura: a Ficha é exibida em 250×90 (2,78:1) com `COVERED`, o que corta cerca de 4% de cada lado. Nada importante nos 6% externos esquerdo e direito.
- Sem texto, letras, molduras, marca d'água, cabeça cortada nem segundo personagem.
- Nunca aparece o que a ficha de identidade proíbe (no Durvall: Receptáculo, Ghaunadaur como ocupante, Astherion, Síntese Abissal, qualquer símbolo do segredo do mestre).

## Passos

| Passo | O quê | Estado |
|---|---|---|
| S-P01 | Registrar spec e plano; prompts do piloto Durvall | feito nesta etapa |
| S-P02 | Dono gera as duas imagens do Durvall fora do projeto e salva em `assets_incoming/hero-portraits-r1/durvall/` | aguardando o dono |
| S-P03 | Normalizar (recorte, 768×256 e 256×256), copiar para `assets/portraits/ficha/` e `hud/`, gerar `.import` | depois do S-P02 |
| S-P04 | Capturar HUD e Ficha do Durvall em 1920×1080 (base, 150%, alto contraste) e rodar `test_hero_portraits` com diretório sintético | depois do S-P03 |
| S-P05 | Aceite visual do dono no piloto | gate |
| S-P06 | Lote dos outros 11 heróis, com o mesmo contrato de prompt | só após o S-P05 e nova aprovação |

## Decisões em aberto

1. **Relâmpago na espada.** O retrato do menu mostra a lâmina com raios azuis; a arma do jogo (Espada Sombria) é aço negro sem brilho. Os prompts do piloto usam a espada sem raio na Ficha (e nada no HUD). Se o dono quiser manter o raio por coerência, trocar a linha marcada `[ESPADA]` do prompt da Ficha pela variante B.
2. **Normalização.** Redução com filtro Lanczos e leve afiada, sem pixelizar à força; o menu já é pintura suave, não pixel puro.
3. **Gerador sem 3:1.** O ChatGPT gera 1024x1024, 1536x1024 e 1024x1536: a Ficha é pedida em 1536x1024 com o assunto na faixa central (25% a 75% da altura) e recortada em 1536x512 antes de reduzir.

## Fora de escopo
Menu/Quartel, sprites do mundo, HQs, código de runtime, os outros 11 heróis (S-P06), commit, push e publicação.

## Revisão r1.1 (2026-10-27, pedido do dono)
A faixa 3:1 (768×256) achatava o herói na caixa de 250×90 da Ficha. Contrato novo: Ficha **768×432 (16:9)**, caixa de **250×141** em `ui/character_sheet.gd` (nome e nível agora na mesma linha para liberar altura). O HUD do Durvall (256×256) está **aprovado**. Para os outros heróis, gerar a Ficha em 1536×1024 com o herói inteiro e recortar um 16:9 centrado nele (`tools/portrait_prep.gd -- <id> <cx> <y0> <w>`). Retratos de menu sem imagem própria seguem caindo no fallback (3:2 centralizado inteiro). Onde este arquivo diz 768×256 ou 3:1, vale esta revisão.

## Revisão r1.2 (2026-10-27): lote dos 11 heróis
Piloto do Durvall aceito (HUD 256×256 e Ficha 768×432, 16:9). Lote autorizado: um arquivo de colar por herói em `.atena/generated/hero-portraits-20261027-r1/colar/` (gerado por `build_batch.js` a partir das identidades da `hero-art-reset-20261021`). Mudança de contrato nos prompts da Ficha: o herói inteiro ocupa cerca de 70% da altura de uma imagem 1536×1024, centrado, câmera próxima, e o recorte passa a ser o 16:9 de largura inteira (`portrait_prep.gd -- <id> -1 -1 1536`), em vez do recorte fechado manual do Durvall. Nyrelia só tem a vista de frente no Vault; poses quase frontais. Referências em `.atena/generated/art-candidates/hero-portraits-r1-refs/` (ignorada pelo git).

## Revisão r1.3 (2026-10-27): lote concluído
Os 12 heróis têm HUD (256×256) e Ficha (768×432). Os 9 do lote usam o recorte de **altura inteira** (`portrait_batch.ps1 -Crop 1820`): o 16:9 central de largura inteira cortava cabeça ou botas porque as figuras geradas ocupam quase toda a altura; as laterais que faltam vêm do espelho da borda do cenário. **A2 revista pelo dono:** Erik fica com cabelo e barba, como nas imagens CANON do Vault (o texto do Vault e a bio dizem raspado; as imagens prevalecem para a arte). Sem mudança de save. Pendente só a conferência opcional a 125%/150% e com alto contraste.
