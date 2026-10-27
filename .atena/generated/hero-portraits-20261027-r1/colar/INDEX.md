# Lote de retratos dos 11 heróis (S-P06)

Um arquivo por herói, no mesmo formato do Durvall (já aprovado). Cada arquivo tem 2 conversas: HUD (1024×1024) e Ficha (1536×1024, recortada depois em 16:9).

Referências copiadas em `.atena/generated/art-candidates/hero-portraits-r1-refs/<id>/hud` e `.../ficha` (pasta ignorada pelo git).

| Herói | Arquivo para colar | Anexos (HUD + Ficha) | Salvar em |
|---|---|---|---|
| Arlindo Orlando | [arlindo.md](arlindo.md) | 4 + 4 | `assets_incoming/hero-portraits-r1/arlindo/` |
| Bromnor Martelo da Luz | [bromnor.md](bromnor.md) | 4 + 4 | `assets_incoming/hero-portraits-r1/bromnor/` |
| Brook França | [brook.md](brook.md) | 4 + 4 | `assets_incoming/hero-portraits-r1/brook/` |
| Erik Blackthorn | [erik.md](erik.md) | 4 + 6 | `assets_incoming/hero-portraits-r1/erik/` |
| Kayron Lioran | [kayron.md](kayron.md) | 4 + 6 | `assets_incoming/hero-portraits-r1/kayron/` |
| Korrak Nammat | [korrak.md](korrak.md) | 4 + 4 | `assets_incoming/hero-portraits-r1/korrak/` |
| Leoric | [leoric.md](leoric.md) | 4 + 4 | `assets_incoming/hero-portraits-r1/leoric/` |
| Maelor Menezes | [maelor.md](maelor.md) | 4 + 4 | `assets_incoming/hero-portraits-r1/maelor/` |
| Nyrelia | [nyrelia.md](nyrelia.md) | 3 + 3 | `assets_incoming/hero-portraits-r1/nyrelia/` |
| Sylas Malafaia | [sylas.md](sylas.md) | 4 + 4 | `assets_incoming/hero-portraits-r1/sylas/` |
| Zynara Vellen | [zynara.md](zynara.md) | 4 + 4 | `assets_incoming/hero-portraits-r1/zynara/` |

Ordem sugerida: começar por Korrak e Sylas (silhuetas mais difíceis), depois os demais. Gerar um herói por vez e me avisar; recorto, integro e mostro.

Decisões do dono já aplicadas nos prompts: Kayron pelo CANON pós-S24 (A1), Erik raspado (A2), Maelor sem luz desenhada (A3), Leoric com a concha (A4), Brook sem arma (A5).

## Em lote (a partir do Korrak, 2026-10-27)
Sylas e Korrak aprovados. Pode gerar vários heróis antes de me avisar (as conversas são independentes; abra uma por imagem e faça vários em paralelo). Quando as imagens estiverem salvas, me diga a lista; eu integro tudo com um comando:

```text
powershell -ExecutionPolicy Bypass -File tools/portrait_batch.ps1 -Heroes "brook,bromnor,leoric" -Tag lote1
```

Ele recorta (16:9 de largura inteira), importa uma vez, captura o jogo de cada herói, roda `test_hero_portraits` e `test_hero_panel` e gera uma folha de contato (`captures/contato-<tag>.png`) para revisão de uma vez. Heróis com algum arquivo faltando são pulados e avisados.

Lotes sugeridos para os 9 restantes: **A** brook, bromnor, leoric · **B** erik, kayron, maelor · **C** zynara, arlindo, nyrelia. Ou os 9 de uma vez.
