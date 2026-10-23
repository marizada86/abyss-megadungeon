# R2 — roteiro r4: idle, ataque, habilidade e morte (2026-10-22)

Status: DRAFT. Preparado por autorização do dono em 2026-10-22 ("Sigo a recomendação: use as tiras piloto do Durvall como caminhada provisória, leve a geração nova para idle, ataque, habilidade e morte, e prepare o estudo de recortes (opção 3) com uma geração. Nada gerado sem eu autorizar"). **Nada foi gerado.** Substitui o escopo do R2 dos roteiros r1 a r3: a caminhada saiu do R2 até o estudo de recortes dar resposta.

## 1. O que mudou de escopo

- **Caminhada:** o Durvall usa as tiras piloto que já estão no jogo (8 direções, 6 quadros, oeste real; `assets/animations/heroes/durvall/move_*.png`). Nada a mudar. A geração de caminhada com o ChatGPT fica suspensa para todos os heróis. Seis tentativas (duas r1, três r2 e a E1 do r3) não produziram alternância de pernas legível; o orçamento de 4 gerações do experimento tem **3 restantes**, reservadas ao estudo de recortes (uma) e à decisão do dono sobre as outras.
- **R2 agora:** só idle, ataque, habilidade e morte, onde o modelo acerta (o idle v01 do Durvall é a prova).
- **Contratos:** vale o `animation-contract-r2.md` para essas animações (formato, referências, nomes, critérios). O r3 vale só para a caminhada e fica em espera.

## 2. As 11 imagens

| Herói | Imagens | Já feito |
|---|---|---|
| Durvall | `durvall_attack_se_v01`, `durvall_active_se_v01`, `durvall_death_se_v01` | idle v01 aprovado |
| Korrak | `korrak_idle_se_v01`, `korrak_attack_se_v01`, `korrak_active_se_v01`, `korrak_death_se_v01` | nada |
| Erik (raspado) | `erik_idle_se_v01`, `erik_attack_se_v01`, `erik_active_se_v01`, `erik_death_se_v01` | nada |

Prompts: `.atena/generated/hero-art-reset-20261021/prompts-r2/<herói>.md`, procurando o bloco pelo nome do arquivo (Durvall: blocos 10, 11, 12; Korrak: 1, 7, 8, 9; Erik: 1, 10, 11, 12). Salvar como `F:\dev\abyss-megadungeon\assets_incoming\hero-r2\<herói>\<nome>.png`, sem editar.

## 3. Ordem sugerida (uma conversa por herói)

1. **Durvall:** ataque, habilidade, morte. Anexos de cada uma: as 4 vistas CANON + o **idle aprovado** (`durvall_idle_se_v01.png`); estão listados no arquivo do herói, na seção "Todas as outras imagens".
2. **Korrak:** **idle primeiro** (anexos do idle: 4 vistas CANON + `zuggtmoy.png`). Você aprova o idle à vista; só então ataque, habilidade e morte, com o idle aprovado como quinto anexo.
3. **Erik:** igual ao Korrak. As referências mostram cabelo e barba; o prompt manda ignorar. Confira em toda imagem que ele saiu **careca e sem barba**.

Limite do contrato r2: 3 tentativas por imagem.

## 4. O que conferir à vista

Cada grade tem 4 figuras: a primeira é a de calibração (em pé, neutra) e as outras três são as poses.

| Animação | Poses | Conferir |
|---|---|---|
| Ataque | preparo, golpe, seguimento | as três poses claramente diferentes, o gesto do herói (ficha) legível, arma na mão correta, sem efeito mágico desenhado |
| Habilidade | três poses do gesto da habilidade | idem; sem brilho, onda ou partícula |
| Morte | impacto, queda, caído | recuo, joelhos no chão, corpo caído; sem sangue; o objeto cai ao lado da mão (Erik: tocha com a chama apagada) |

A figura de calibração tem a mesma escala e traje do idle aprovado. **O risco que já vimos:** o modelo repete a mesma pose em quadros diferentes (como na v03 do walk). Se duas poses parecem iguais, não aprove e me chame.

## 5. Como eu meço quando você disser "mede"

Verificador v3 (`r2_check_v3.gd`), uma linha:

```bash
"F:/dev/abyss-megadungeon/Godot_v4.7.2-stable_win64.exe" --headless --script "F:/dev/abyss-megadungeon/.atena/generated/hero-art-reset-20261021/r2_check_v3.gd" -- "F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall/durvall_attack_se_v01.png" magenta 4 grid
```

Idle: `... magenta 3 idle`. Rode sem `--path`. Saída: 0 PASSA, 3 PASSA_COM_ITENS_A_VISTA, 1 REPROVA.

Critérios objetivos: 1 (4 figuras inteiras, cada uma no seu quadrante), 2 (fundo), 4 (pés na mesma linha por fileira), 5e (poses diferentes: PASSA ≥ 20%, REPROVA < 6%, entre os dois INCERTO, limites PROVISÓRIOS não calibrados com dados de ação; a v03 do walk, de quadros quase iguais, teria dado INCERTO), 6 (pontos soltos). O 5f (o gesto lê como a ficha) é **sempre à vista**: o veredito de uma grade de ação nunca é PASSA.

## 6. Riscos registrados

1. **Mistura de estilos no Durvall (decisão do dono, depois).** A caminhada piloto usa a arte antiga (espada de cristal azul brilhante, proporções e traje do piloto); o idle novo, o ataque, a habilidade e a morte serão de aço simples e render diferente. Se forem integrados assim, o Durvall muda de aparência ao começar a andar. **Não integro nada agora.** As saídas possíveis, na hora do R4: manter o Durvall inteiro no piloto até a caminhada nova existir; aceitar a diferença; ou refazer a caminhada depois do estudo de recortes e integrar tudo de uma vez.
2. **Ritmo e amplitude:** não se aplicam às ações.
3. O contador de 3 tentativas por imagem do contrato r2 continua valendo.

## 7. Preservado

Idle v01 aprovado; as seis tentativas de caminhada e seus arquivos; contratos r1, r2, r3; verificadores v1, v2, v3; pacotes de prompts r1 e r2; demais planos. Sem integração, commit, push ou CANON.
