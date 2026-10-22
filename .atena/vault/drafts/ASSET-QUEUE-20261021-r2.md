# Fila de assets — estado após a geração e a integração (2026-10-21, r2)

Status: DRAFT. Substitui o acompanhamento de `ASSET-GENERATION-LIST-20261021-r1.md` (que continua sendo o contrato de prompts). Nenhum asset foi promovido a CANON.

## 1. Verificação da entrega

- Produção: worktree `codex/asset-generation-20261021-r1` (commits `d4419fe0` e `e337f3de`), 129 PNGs, 125 candidatas aceitas pelo dono por ID/revisão/SHA-256 (`visual-acceptance.json`: "aprovado o aceite, continue"). Quatro versões substituídas, preservadas e fora da seleção: `V01_death_v01`, `V02_attack_v01`, `V10_sprite_v01`, `U09_v01`.
- Conferência feita aqui: **125 de 125** aceitas existem em `assets_incoming/` com o hash do recibo; zero ausentes, zero divergentes, zero PNG inválido; as cópias em `assets_incoming/r1/` também batem.
- Preparação técnica do outro lado: `asset-preparation-20261021-r1` (158 derivados: 62 de UI/Quartel, 36 poses, 12 estáticos e 48 folhas do lote N). Auditoria deles: dimensões esperadas, sem contato de alfa nas bordas, sem resíduo magenta. Ressalva própria: buracos fechados exigem olho humano.
- Limites registrados pelo lado da produção e confirmados aqui: margens de várias poses N abaixo dos 8% pedidos; fundos cinza variam; U10 não aprovado como textura repetível; U19/U14 têm peças extras (U14 ficou como preenchimento 300×8).

## 2. Estado por lote (cada linha: integrado no jogo / reserva / pendente)

| Lote | Itens | Estado | Onde |
|---|---|---|---|
| U01–U08 | cartão, placa, gemas, fitas, cabeçalhos, glifos, setas, rerrolar | **Integrado** (dc4a917) | `ui/offer_card.gd`, `ui/hud.gd` |
| U09 | brilho aditivo do cartão | Preparado, **sem consumer** | o halo dourado de foco segue em código |
| U10 | textura de fundo | **Retido** (repetição não aprovada) | `assets/ui/oferta/oferta_fundo_textura.png` copiado, sem uso |
| U11 | placa de preço | Preparado, **não integrado** | falta decidir o chip de preço do cartão |
| U12 | painel do herói | **Retido**: é um molde fixo (janela do retrato + duas faixas), não nove fatias | exige layout próprio |
| U13/U14 | barras de PV e XP | **Integrado** | `ui/hud_art.gd`, `ui/hero_panel.gd` |
| U15 | anel da habilidade | **Integrado** | `ui/ability_slot.gd` |
| U16 | chips de moedas, abates, CA, CAM | **Integrado** (grade 2×2) | `ui/hero_panel.gd` |
| U17 | cronômetro | **Retido**: a faixa invade o rótulo da fase | exige rever o topo da HUD |
| U18 | botões de ajuda e velocidade | **Integrado**; o de pausa não existe no HUD | `ui/hud.gd` |
| U19 | lista de armas | **Retido**: a lista tem tamanho livre | `HudArt.style_weapon_list` pronto |
| U20/U21 | moldura de modal e de dica | **Integrado** (reviver e resultado; dica do cartão) | `ui/hud.gd`, `ui/offer_card.gd` |
| Q01 | ícones das 8 abas | **Integrado** (dc4a917) | `ui/menu.gd` |
| Q02/Q03 | cartões de herói e fase | **Pendente**: exige trocar `ItemList` por cartões; a placa 96×96 não cabe no cartão de 72 px | plano próprio |
| Q04, Q06 | ícones de melhorias e marcas | **Integrado** (dc4a917) | `ui/menu.gd`, `ui/abyss_panel.gd` |
| Q05 | pips e botões de compra | **Integrado** | `ui/menu.gd` |
| Q07/Q08 | medalhas e emblemas de conquista | Emblemas **integrados**; medalhas de estado **não** (o emblema apagado faz o papel) | `ui/menu.gd` |
| Q09 | ícones de categoria do códex | **Integrado** (3 categorias existentes; heróis, passivas e bênçãos não existem no códex) | `ui/menu.gd` |
| Q10 | ícones de resultado | Preparado, **sem consumer** (o resultado é texto corrido) | `assets/icons/resultado/` |
| V01–V09 | Síntese, Death Tyrant, Receptáculo, Gárgula, Crueldades, Manifestação, Nidhogg, Molydeus, Ezro, Shu | **Integrado** (dc4a917), folhas procedurais | `assets/animations/enemies/` |
| V10 | Kayron | Retrato **integrado**; sprite **retido** (incompatível com as folhas) | plano de compatibilização |
| V11 | intro do Sacerdote | **Integrado** | `assets/ui/boss-intros/` |
| C01–C10 | introduções de chefe e miniaturas | **Integrado** | `assets/ui/boss-intros/`, `assets/stages/` |
| C11–C16 | decais, ruínas, ícones, Espelho, VFX de Arlindo e Erik | **Integrado** (dc4a917) | vários |
| N01 | Reaper do Estige | **Integrado** (NPC `npc_reaper_barqueiro`: estático 173×248 e faixa de 4 quadros) | `assets/interactions`, `assets/animations/interactions` |
| N02–N10 | Beholder, Kein, Astherion, Kūkan Shito, Taverneiro, Atendente, Wonka, Willie, Marciela, Thalion, Aila | **Em reserva de arte**: sem consumer aprovado | derivados em `…/asset-preparation-20261021-r1/prepared/` |
| N11 | Mímico | Reutiliza o sprite existente | — |

## 3. Decisões do dono necessárias (nada disto foi feito sem você)

1. **Usos do lote N** (cada um muda enredo ou jogo): Beholder e Kein no ritual do Reino Abissal; Astherion como câmara opcional de Dagruve; Kūkan Shito como observador em Feng-tu; Taverneiro e Atendente na Vila das Sombras; Wonka e Willie nas Docas; Marciela como guia; Thalion no capítulo 2; Aila em Domwieck após a libertação. Recomendação: começar por Kūkan Shito (cena curta de Feng-tu), Wonka/Willie (evento de Docas) e Marciela (guia na Raiz), que não mexem em equilíbrio.
2. **Cartões de herói e fase no Quartel (Q02/Q03):** recomenda-se um plano separado (troca de `ItemList`, preservando seleção, desbloqueio e foco por controle).
3. **Topo da HUD:** o cronômetro de arte pede mover o rótulo da fase. Recomendo aprovar um ajuste pequeno (fase 8 px mais abaixo).
4. **Painel do herói:** o molde exige reorganizar retrato, nome, barras e chips dentro das áreas desenhadas. Recomendo gerar uma variante nove fatias da moldura antes.
5. **V10 sprite do Kayron:** manter a arte antiga ou regenerar as folhas do herói com a pose nova.

## 4. Pedidos de nova geração (somente se aprovar)

- Moldura de painel do herói em nove fatias (sem janela de retrato embutida) e variante de cronômetro mais baixa.
- Folhas de animação desenhadas quadro a quadro para os chefes novos (Síntese, Death Tyrant, Receptáculo, Manifestação, Nidhogg): hoje são trocas de pose com balanço.
- Ícones de categoria do códex para heróis, passivas e bênçãos (só se o códex ganhar essas abas).

## 5. Pendências técnicas

- Aceite visual humano de **todo** o conjunto integrado no jogo (o aceite recebido é das fontes, não das telas).
- Playtest de equilíbrio dos mapas (Death Tyrant no Reino Abissal).
- Portagem para o projeto de origem em `D:`.
- `controller_check`: os 2 FAIL e o timeout herdados continuam iguais.
