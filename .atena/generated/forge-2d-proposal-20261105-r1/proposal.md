# Proposta: forja 2D (NoctAssetForge v2.5) como ferramenta complementar de assets

Data: 2026-11-05. Estado: DRAFT, aguardando decisão do dono. Nenhuma alteração de runtime, de `plan.yaml`, commit ou push.

## 1. Recomendação

Adotar a forja 2D só como **piloto limitado e reversível**, para peças que o estilo vetorial/pixel cobre bem (molduras e painéis de UI, ícones pequenos em pixel art, texturas repetíveis). Ela **não substitui** a geração de imagens atual, que continua sendo a fonte da arte pintada (heróis, retratos, VFX, ícones de evolução).

A forja 3D (`noct-asset-forge-3d-bb-v2`) fica fora: o jogo é 2D em Godot.

## 2. Evidência

Tudo em pasta isolada, fora deste repositório:

| Verificação | Resultado |
|---|---|
| Integridade do zip | 121 de 121 hashes de `checksums.sha256` conferem |
| `npm ci` | ok; `npm audit` aponta 2 vulnerabilidades altas (não corrigidas) |
| `npm run doctor` | ambiente pronto (Node 24.15, Chromium já presente) |
| `npm test` | núcleo, fronteira pública, comandos de agente e viewer passaram |
| 3 assets de amostra | exportados e medidos com `inspect` |

Amostras: painel de UI 384×256, placa de rocha 256×256 e gema pixel art 32×32 (5 cores exatas, alpha só 0/255, sem tocar as bordas).

Leitura honesta da qualidade: o resultado é limpo e controlado, mas simples. Com o tema padrão fica longe da riqueza da arte pintada do jogo. A placa de rocha da amostra não é tileável (tem contorno); um tile contínuo exige outro desenho.

## 3. Correção ao que eu disse antes

Eu havia sugerido que a forja ajudaria nas pendências técnicas das VFX de evolução (margens, âncoras, loops). **Isso não se sustenta:**

- O `inspect` mede um PNG inteiro (bounds, alpha, nº de cores). As fontes de VFX são folhas 1536×1024 em **fundo preto** para composição aditiva, sem alpha, e a medição por célula exige recorte que a forja não faz.
- O projeto já tem seu próprio ferramental para isso (`audit.ps1`, `asset_prep.gd`, Godot).

Portanto a forja **não entra** nas pendências de VFX nem no restante do backlog de UI/Quartel (U09, U11, U17, Q02, Q03, Q10), já aprovado com arte aceita.

## 4. Onde ela pode agregar

| Uso | Valor | Observação |
|---|---|---|
| Molduras, painéis e placas de UI sem texto | Regeneração determinística por tema (trocar a paleta regera tudo) | Precisa casar com o estilo pintado já aceito |
| Ícones pequenos em pixel art | Paleta fixa, bordas duras, medição automática | Só se houver slot que aceite esse estilo |
| Texturas repetíveis e decals | Granulado, riscos e carimbos reproduzíveis | Exige desenhar para repetição |
| Placeholders e peças de QA | Entrega rápida sem fila de geração por imagem | Marcar como provisório |

Os slots concretos **não foram levantados**; isso é o passo F1.

## 5. Plano do piloto (cada fase com decisão sua)

- **F0, local.** Colocar a forja em pasta própria fora do repositório (sugestão: `F:\dev\noct-asset-forge2d`), a partir do zip conferido. O código da forja não entra neste repositório (a licença proíbe redistribuir; os PNGs gerados são seus).
- **F1, levantamento (somente leitura).** Listar slots candidatos e o estilo real (`STYLE`, `ui/ui_kit.gd`, paleta, escalas). Entrega: lista de 3 a 5 candidatos, com justificativa.
- **F2, piloto.** Criar `_theme.ts` a partir da paleta do jogo e produzir até 3 assets. Comparar lado a lado com a arte aceita, em captura com diretório sintético (nunca o save real).
- **F3, decisão.** Você adota, ajusta ou descarta. Se adotar, os PNGs seguem o fluxo existente: `assets_incoming` → preparação → runtime, sempre `DRAFT` e com aceite visual humano.

## 6. Riscos

- **Estilo:** vetor/pixel limpo pode destoar da arte pintada. Mitigação: F2 compara antes de qualquer uso.
- **Dependências:** `npm audit` com 2 altas. Mitigação: uso só local, na pasta isolada, sem expor servidor.
- **Licença:** uso interno e comercial das saídas permitido; redistribuir ou vender a ferramenta, não.
- **Papéis:** o plano registra que Atena gera imagens e Claude prepara e implementa. Falta definir quem opera a forja (código de asset).

## 7. Aprovações necessárias

1. F0: criar a pasta da forja fora do repositório.
2. Quem opera a forja.
3. F1 e F2 sob demanda, uma fase por vez.
4. Registrar o piloto no `plan.yaml` (hoje já modificado; não alterei).

## 8. Fora de escopo

Mudança de runtime, mecânicas, IDs, saves, lore, promoção a CANON, substituição de fontes aceitas, integração das VFX, commit, push, build e publicação.
