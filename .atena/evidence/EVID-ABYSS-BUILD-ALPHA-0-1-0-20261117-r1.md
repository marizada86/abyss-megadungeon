# EVID-ABYSS-BUILD-ALPHA-0-1-0-20261117-r1

Estado: DRAFT. Build de Produção Alpha 0.1.0 (Windows x86_64), gerada em 2026-11-17 dentro de `PLAN-ABYSS-ALPHA-BUILD-20261116` (aprovação por plano, sem push). Áudio fora do escopo.

## Artefatos (`build/dist-0.1.0/`, fora do Git)
- `NottgardSurvivors.exe`: preset "Windows Desktop", 705 149 376 bytes, SHA-256 `b46e2d2592ba8600e9be3117db69bbb0f3387343931f36cd62024e5d42176e19`.
- `Nottgard-Alpha-0.1.0.zip`: 630 796 821 bytes, SHA-256 `29d587397f50acaa00432c8de697a6ff220e91e0a1e3118caf4568dce8c8aedf`; contém o `.exe`, `LEIA-ME.txt` e `NOTAS-DA-VERSAO.txt` (listagem conferida com `tar -tvf`).
- `SHA256.txt` com os dois valores.
- Carimbo: commit `e3894a91`, árvore rastreada limpa (sem `-dirty`), versão `0.1.0`. `data/build_info.json` removido depois da exportação. O `stamp_build.ps1` não pôde rodar (política de execução do PowerShell); o carimbo foi gravado pelo bash no mesmo formato.

## Conteúdo desta versão
- Versão `0.1.0`, canal "Alpha" no menu e nos 3 presets (contagem reiniciada; builds anteriores 0.5.x e 0.6.0).
- Nomes oficiais (DEC-NOMES-OFICIAIS-20261108-r2) em todo o texto exibido: commit `961a24c`. Verificação no pacote: "Amanessa" presente (46 trechos), "Zuggtmoy", "Juiblex" e "Beholder" ausentes.
- Ícone de regra "destino" em Reino Abissal e Domwieck: commit `43b9eee` (aceite visual do dono pendente).
- Inclui os SFX provisórios e o ajuste de Arlindo posteriores à build 0.6.0.

## Verificações (perfil sintético em `tmp/smoke-alpha010`; save real não carregado)
- `bash tools/validate_release.sh`: `RELEASE-GATES: PASS` (suíte 0 falhas, auditoria 0 erros, `test_save_upgrade_050` PASS), repetido após o ícone.
- Exportação: saída 0; único aviso relevante "another project.godot at res://tmp/base-a6-20261107, folder ignored" (`tmp/*` está no filtro de exclusão).
- Smoke headless do `.exe` (`--quit-after 600`): saída 0. Smoke com janela (`--resolution 1366x768 --quit-after 400`): saída 0, OpenGL 3.3 em NVIDIA GTX 1660 SUPER. No encerramento o motor registra vazamento de texturas/RIDs: ruído de saída já visto na 0.6.0, não falha.

## Limites (não verificado)
- Menu principal e partida não foram confirmados por log (a Produção não grava evidência): o smoke prova que o pacote abre, renderiza e fecha limpo.
- Glifos acentuados dos nomes novos (ă em Zburător, ê em Lavriê) não foram conferidos em tela com as fontes do jogo.
- Arte com nome desenhado: amostra de 7 imagens sem texto; não exaustivo. Aparência do Vigia (beholder) e do Zburător segue como decisão de redesenho do dono/Vault.
- Controle físico, desempenho em Goranthis e Pilares, ordem de liberação da campanha: só a playtest humana confirma. `controller_check.gd` não foi rodado (falhas herdadas registradas no plano).
- Merge em `main`, push, tag e envio aos testadores: pendentes de sim explícito.

## Como testar
`build/dist-0.1.0/NottgardSurvivors.exe` abre o diretório de saves real do jogo; para um perfil separado, rodar com `APPDATA` e `LOCALAPPDATA` apontando para uma pasta de teste.

## Revisão de nomes de terceiros (2026-11-17, r2 da build)
- Varredura de `data/`, `ui/` e `core/`: nenhuma forma capitalizada dos 37 nomes de DEC-NOMES-OFICIAIS-20261108-r2 restou; só IDs minúsculos intencionais.
- Termos de D&D trocados no texto exibido: "Underdark" → "subterrâneo profundo", "Cloudkill" → "Nuvem Mortal" (4 trechos), "Aboleth" → "outro nome"; teste do codex ajustado. Gate `RELEASE-GATES: PASS` depois da troca.
- DECISÃO DO DONO (2026-11-17): manter Dante, Vergil, Trish (Devil May Cry), Wonka, Willie (Willy Wonka) e Arondir (Tolkien) nesta Alpha; a troca fica para um patch futuro, com decisão correspondente no Vault (DEC-NOMES-OFICIAIS r3). Risco aceito pelo dono com a distribuição aberta.
- Não trocados por serem mitologia ou termo genérico: Gehenna, Estige, Kraken, Amatsu-Mikaboshi, Lu Yueh, Tou Um, Molor; raças Drow, Tiefling, Aasimar, Goliath; herói Leoric (também personagem de Diablo).
- Limite: arte com nome desenhado e áudio não foram varridos; termos de D&D fora da lista usada podem ter escapado.
