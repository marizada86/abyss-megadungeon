# VFX — Projétil da arma Memória Alterada (Arlindo), 2026-11-04, r1

Status: DRAFT, pedido do dono ("pode fazer", após a oferta de um prompt para o projétil). Nenhuma geração, integração, aceite, commit ou publicação autorizados por este rascunho. Checkpoints dos demais planos preservados. Complementa `PROMPTS-ASSETS-VFX-MEMORIA-ALTERADA-20261104-r1.md` (habilidade ativa); este é a arma.

## Lacuna

A arma `memoria_alterada` (`data/weapons.json`: `kind: "bolt"`, `dtype: "magico"`, 1d6, recarga 2,2 s, alcance 8,5, velocidade 10, lentidão de 2 s) é o ataque básico de Arlindo, mas não está em nenhuma lista de `ProjectileVfx.FAMILIES` (`core/projectile_vfx.gd`): ela voa como o círculo antigo, sem sprite. `tests/test_projectile_and_ability_vfx.gd` afirma isso hoje (a arma está na lista "fora da allowlist" e deve devolver família vazia). Outras armas mágicas bolt já têm família (`orbe_arcano` para `raio_enfraquecedor`, `dominar_pessoa` etc.).

Efeito que a arte deve sugerir sem texto: o alvo fica lento, como se uma lembrança o prendesse. Lore (vault, Sessões 8–12): Modify Memory de Arlindo, mostrar memórias. Mesma linguagem da habilidade ativa: azul frio e violeta, silhuetas anônimas translúcidas, estilhaços de cristal. Sem rosto nem identificação; sem partículas douradas (revelação de Bromnor só depois da hqn_11).

## Formato (folha de projétil, igual a `orbe_arcano.png`)

PNG RGBA 2048×256, oito células de 256×256 em fila: células 0–3 = voo em ciclo (4 quadros, 12 fps); células 4–7 = impacto, disparo único (0,30 s). Pivô no centro da célula; borda de cada célula sem luz (o teste rejeita luz nas bordas e células vazias). O projétil voa para a direita (+x); o centro de luz dos quadros de voo deve ficar perto de x=124 da célula (o `pivot_x` medido; informar o real depois da arte). Escala de jogo ~0,45 px de tela por px de arte, então o miolo precisa ser legível pequeno (cerca de 50–60 px de arte de diâmetro de núcleo, cabeça brilhante com cauda curta à esquerda). Gerar sobre preto puro; preparar com chave de preto, e o jogo compõe em modo aditivo.

Referências (acabamento/escala, não alvo de edição): `assets/vfx/orbe_arcano.png` (mesma família mágica; é a base com que a nova arte precisa conviver e se distinguir), `assets/vfx/orbe_radiante.png`, a folha atual `assets/vfx/habilidade_arlindo.png` (paleta e fantasmas).

## Prompt (colar no GPT com as referências anexadas)

> Use case: stylized-concept. Generate a horizontal sprite sheet of a magic projectile for a dark fantasy game, 8 square cells of equal size in one row, on a pure solid black background (#000000) for additive blending. The reference images are STYLE references only; match their luminous painterly fantasy VFX finish, but this projectile must be clearly different from the arcane orb: a "memory bolt" in cold blue and violet. Cells 1 to 4 are a looping flight animation of a bolt traveling to the RIGHT: a small bright cyan-white core with a short comet tail trailing to the left, wrapped in a thin violet halo, with two or three tiny translucent anonymous humanoid silhouettes (no faces, no identifiable character) and a few small crystal shards swirling and flickering around the core a little differently in each frame so the loop feels alive. The whole bolt is centered in the cell and compact, about 130 px long by 70 px tall in a 256 px cell, readable at small size. Cells 5 to 8 are a one-shot impact: frame 5 a bright flash of the core hitting, frame 6 a ripple ring and a burst of crystal shards, with ghostly silhouettes spreading outward, frame 7 the ring grows and thins and the shards fly out, frame 8 only faint pale-blue mist and a few fading shards, almost empty. Every cell must have at least 16 px of clean empty black margin on all sides and no light on the cell borders. Strong contrast against black, restrained detail. No text, letters, logos, frame, ground, scenery, faces, or visible grid lines between cells.

## Destino e integração (após aceite visual do dono)

Destino: `assets/vfx/orbe_memoria.png`. Em `core/projectile_vfx.gd`, uma nova entrada `&"orbe_memoria"` em `FAMILIES` (`path`, `dtype: "magico"`, `scale` ~0,45, `pivot_x` medido, `weapons: ["memoria_alterada"]`). Em `tests/test_projectile_and_ability_vfx.gd`: tirar `memoria_alterada` da lista de armas fora da allowlist, acrescentar a família a `FAMILIES` do teste, e rodar a importação do Godot. A família é só visual: posição, dano, lentidão e colisão ficam em `Battle`. Conferir em jogo com Arlindo que o projétil se lê ao lado de `orbe_arcano` e que a lentidão aparece no alvo.

## Fora de escopo

- Não alterar mecânica, dados da arma nem famílias existentes.
- Sem versão evoluída (a arma não tem evolução em `EVOLVED_FAMILIES`).
- Geração e integração dependem de autorização e de aceite visual do dono.
