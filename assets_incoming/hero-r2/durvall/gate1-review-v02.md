# Gate 1 — Durvall, revisão técnica em 2026-10-22

Aceite visual do dono para v01: “aprovado, continue”. Nenhum aceite visual de v02 presumido.

Ferramenta integrada image_gen, duas gerações efetivas por imagem até aqui. Todos os PNGs originais preservados sem edição. Prompts-base: blocos idle_se e walk_se do pacote `durvall.md`.

| Entrega | Figuras | Escala | Pés | Halo (limite 2%) | Pontos soltos | Diferença A/P e B/P | Veredito |
|---|---|---|---|---|---|---|---|
| idle v01 | 3/3 | 0,2% | 0,0% | 49,5% | 56 | n/a | REPROVA |
| walk v01 | 3/3 | 3,8% | 0,3% | 50,5% | 48 | 37,0%; 35,8% | REPROVA |
| idle v02 | 3/3 | 0,2% | 0,0% | 34,8% | 0 | n/a | REPROVA |
| walk v02 | 3/3 | 3,5% | 0,1% | 41,2% | 17 | 34,5%; 35,7% | REPROVA |

Relatórios completos: `gate1-idle-v01.json`, `gate1-walk-v01.json`, `gate1-idle-v02.json`, `gate1-walk-v02.json`, nesta pasta. Nenhuma figura encosta na borda.

V02: o prompt integral recebeu o complemento literal abaixo. Idle usou o idle v01 como referência; walk usou idle v01 e walk v01. A tentativa visava corrigir apenas os defeitos de recorte mantendo a direção visual aprovada.

```text
Technical correction for version 2: preserve the approved reference character and rendering inside the silhouettes. Make the OUTER silhouettes hard crisp dark pixel edges with NO antialiasing against magenta, no pink rim tint, no semitransparent edge pixels, no detached flecks, no thin detached hair strands or cloth fibers. Every character, hair, cloth and held sword must form one connected solid silhouette, with hair grouped into clean connected locks. Every background pixel including gaps must be exactly RGB(255,0,255). Separate figures with at least 140 px of empty magenta. Match the attached approved idle as identity and scale reference.
```

Verificador executado em `tmp/hero-r2-gate1-isolated`, sem abrir o projeto nem carregar save. O Godot emitiu erros de acesso ao repositório de certificados e de escrita de editor_settings fora do workspace; os quatro relatórios foram produzidos. O código do verificador não foi alterado. Seu processo retornou exit code 0 mesmo com REPROVA: o veredito do JSON é a evidência usada.

Parada após duas tentativas reprovadas, conforme roteiro; sem geração das demais direções. As filas mantêm contagem/escala/pés aceitáveis, portanto não há evidência de que separar as poses resolva o halo. Próximo passo: rever a estratégia de recorte/fundo no contrato antes de consumir outra geração. Sem integração, promoção CANON ou portagem de runtime.
