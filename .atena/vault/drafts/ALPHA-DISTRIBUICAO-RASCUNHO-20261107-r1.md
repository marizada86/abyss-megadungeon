# Alpha demo: textos de distribuição e versão (DRAFT r1, 2026-11-07)

Estado: **DRAFT**, não canônico, nada aplicado ao jogo. Origem: `SPEC-ABYSS-ORGANIZATION-20261107` / `PLAN-ABYSS-ORGANIZATION-20261107`, etapa S-003. Base: `build/dist-0.5.2/LEIA-ME.txt`, `NOTAS-DA-VERSAO.txt` e `ALPHA-CHECKUP-20261104-r1.md` (seções 4A e 6).

## 1. Decisões que só o dono toma

| # | Decisão | Recomendação | Efeito |
|---|---|---|---|
| D1 | Número da versão do alpha | `0.6.0-alpha.1` (aplicado como `0.6.0`: o contrato de versão não aceita sufixo; alpha é o canal) | **Aplicado em 2026-11-07** (decisão do dono: recomendação aceita). Mudou `core/version.gd` e as 6 linhas `file_version`/`product_version` de `export_presets.cfg` (formato `0.6.0.1`). `test_version_contract` precisa ser conferido com o novo número antes do build. |
| D2 | Canal de retorno dos testadores | Mensagem direta ou formulário simples | Entra na seção 5 do LEIA-ME. Sem F5/F6/F7 na Produção, o relato é por texto e print do próprio testador. |
| D3 | Aviso sobre nomes provisórios (renomeação por direitos autorais) | Incluir uma linha | Os nomes atuais valem só para o grupo combinado; a renomeação é feita antes de qualquer divulgação pública. |
| D4 | Teto de interativos vivos (4 em mapas de 300 s ou mais, 3 nos curtos) | Manter | Implementado na sessão do checkup a partir da recomendação; reversível em `data/difficulty.json`. |

## 2. Rascunho do LEIA-ME (Produção)

Pontos que mudam em relação à 0.5.2: a Produção segue a trilha da campanha (não abre todas as fases), não tem F1/F5/F6/F7, e o retorno é pelo canal combinado.

```text
NOTTGARD - ABYSS MEGADUNGEON  |  ALPHA DEMO <VERSAO>  (Windows 64 bits)

Obrigado por testar. Esta e uma demo em construcao, para um grupo combinado.
Os nomes de varios personagens e criaturas sao provisorios e vao mudar antes de qualquer divulgacao publica.

1. REQUISITOS: Windows 10 ou 11, 64 bits; placa de video com OpenGL 3.3 ou superior; cerca de 700 MB livres.
2. INSTALAR: extraia o ZIP inteiro para uma pasta sua. Opcional: confira o SHA-256 enviado pelo organizador.
3. AVISO DO WINDOWS: o executavel nao e assinado; use "Mais informacoes" > "Executar assim mesmo".
4. JOGAR: abra NottgardSurvivors.exe. A campanha segue a ordem do mapa; cada fase libera a proxima.
   Teclas: WASD/setas ou mouse = mover | Q ou botao direito = habilidade | E = interagir
           C = ficha | Esc = pausa | F11 = tela cheia (teclas remapeaveis em Configuracoes)
   Controle fisico: nunca foi testado. Se tiver um, tente e conte como foi.
5. ENVIAR O RELATO: <CANAL COMBINADO>. Conte: qual fase e heroi, o que estranhou ou gostou,
   placa de video, processador, memoria, resolucao e se usou controle. Prints ajudam.
6. PRIVACIDADE: o jogo nao envia nada automaticamente.
7. PROGRESSO: fica no perfil local do Windows. Versoes futuras podem exigir recomecar; avisaremos antes.
```

## 3. Rascunho das notas da versão

Preencher só depois de D1. O que o alpha traz em relação à 0.5.2, conforme o plano e os commits (conferir um a um antes de publicar):

- Ritmo e duração dos mapas da rampa B reduzidos e aprovados; teto de interativos vivos.
- Favor divino no HUD, quebráveis do Reino Abissal, templo de Tou Um, carga da legião, discípulo.
- Evoluções de arma e seus efeitos visuais; avisos telegrafados dos golpes comuns; correções de vazamento em `UiKit.apply_window` e, se confirmada, em `core/sfx.gd`.
- Já sabemos: música de Reino Abissal, Domwieck e Pilares reaproveitada; Pilares só é vencido por robôs com o Quartel cheio; equilíbrio dos mapas finais sem playtest humano; controle físico não testado.

## 4. Ordem recomendada até o envio (do checkup, seção 6, revisada)

1. Dono decide D1 a D3.
2. Atena aplica o bump de versão e os textos, roda `bash tools/validate_release.sh` (aprovação separada para commit).
3. Build de Produção com autorização explícita: `tools/stamp_build.ps1`, só o preset "Windows Desktop", smoke do `.exe` em perfil sintético, zip e SHA-256.
4. Playtest humano de 30 a 45 min (Docas, Reino Abissal, Domwieck, Dagruve, Shedaklah; depois salto a Goranthis/Pilares; um passe com controle).
5. Envio ao grupo só com o sim explícito do dono; sem push, tag ou publicação automáticos.

## 5. Não feito

Bump de versão, commit, build, zip, push, tag, publicação, `git gc`, qualquer alteração em `core/`, `data/` ou `export_presets.cfg`.
