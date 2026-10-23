# SPEC-ABYSS-WEAPON-SCHOOL-20261023 · r1

Origem: pedido do dono em 2026-10-23: o jogador não entende qual arma escala com qual atributo.
Escopo: apresentação e regra de leitura. **Nenhum número de dano, atributo ou tipo de arma foi alterado** (`data/weapons.json` intacto).

## Regra

| Escola | Dano | Escala com | Evitado por |
|---|---|---|---|
| Física | físico (`dtype: fisico`) | Força | CA |
| Mágica | mágico (`dtype: magico`) | Inteligência | CAM |
| Fogo | de fogo (`dtype: fogo`) | o atributo declarado (Inteligência nas magias, Força nos golpes flamejantes) | CAM |
| Radiante | radiante (`dtype: radiante`) | o atributo declarado (Constituição ou Carisma; Força nos martelos) | CAM |

Fogo e Radiante são tipos elementais próprios: a etiqueta mostra o tipo e o atributo real ("Fogo · Inteligência", "Radiante · Carisma").
A etiqueta é derivada de `dtype` + `attr` por `Weapon.school()`; não há campo novo nos dados nem no save.

## Exceções declaradas (Física/Mágica com outro atributo)

Mantidas de propósito: são as armas de Paladino, Devoto, Bardo e Dominação, e trocar o atributo mudaria o dano desses heróis.
Ficam em `Weapon.SCHOOL_EXCEPTIONS`; `tests/test_weapon_school.gd` falha se uma arma Física/Mágica fugir da regra sem estar na lista (ou estiver na lista sem fugir).

| Arma | Etiqueta |
|---|---|
| golpe_atordoante | Física · Constituição |
| chicote_avarento | Física · Carisma |
| estocada_mistica, dominar_pessoa, dominio_coletivo, cajado_dos_desejos, dominio_da_vontade, memoria_alterada | Mágica · Carisma |

Decisão em aberto para o dono: converter as seis magias Mágica · Carisma para Inteligência uniformizaria a regra, mas reduziria o dano de Nyrelia e Arlindo (CAR 16 e 15, INT 14 e 13) em 1 ponto fixo por golpe.

## Onde o jogador vê

- Cartão de oferta (arma nova, melhoria, evolução, forja e equipamento que concede arma): etiqueta colorida sob a categoria ("Física · Força"; no cartão compacto, "Física · FOR"). A cor é a do atributo na ficha e no painel do herói (Força vermelha, Inteligência amarela, Constituição azul, Carisma violeta). Na evolução vale a escola da arma resultante.
- Tooltip do cartão: frase "Mágica: dano mágico (evitado pela CAM), escala com Inteligência."
- Ficha (aba Armas): etiqueta e a mesma frase sob o nome; a faixa de dano já inclui o atributo atual do herói.
- Catálogo (armas descobertas): etiqueta, frase e tipo; o texto cru "fisico / forca" saiu.

## Fora de escopo

- Lista de armas do HUD (linha "⚔ Nome Nv N"): sem etiqueta, para não alargar o painel.
- Habilidades ativas dos heróis e armas de inimigos.
- Portagem para o repositório histórico `nottgard-survivor`: não feita.
