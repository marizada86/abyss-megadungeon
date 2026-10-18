---
id: EVID-NOTTGARD-YGGDRASIL-VALIDATION-20261017
revision: r2
status: PASS_FULL_ISOLATED_VALIDATION
---

# S-YGG-004 concluída — ajuste r2 aprovado

Usuário respondeu “aprovado” à revisão r2 que inclui somente tests/test_level_design.gd como14º caminho. [Decisão CANON](../vault/canon/DEC-YGGDRASIL-VALIDATION-ADJUSTMENT-20261017-r2.md). Plano r1 com ajuste r2, **4/5 concluídas, uma restante**. [Relatório final e hashes](../generated/yggdrasil-map-20261017/s004-final-validation-r2.json).

O teste agora exige positivamente que Yggdrasil seja QA-only e permaneça sem props no cadastro e no cenário expandido. Os mapas anteriores continuam exigindo props e conservam todos os outros checks. Conferência textual confirma que somente o trecho aprovado mudou; cópia anterior e hash guardados no recibo. Nenhum runtime ou mapa foi alterado nesta continuação. Os treze caminhos já validados e todos os protegidos mantêm seus hashes. Teto aprovado14 respeitado.

Test_level_design PASS, zero falhas, sessão D:\dev\nottgard\games\launcher-pc\nottgard-abyss-megadungeon\.atena\generated\yggdrasil-map-20261017\validation-20261017-230806-641. Importação e execução sem erro novo de compilação; nenhuma repetição extra de compilação foi necessária. APPDATA, LOCALAPPDATA, perfil e user_dir sintéticos, com probe prévio sem autoload.

**12/12 conjuntos aprovados**, combinando o teste afetado com as onze evidências válidas anteriores. [Validação anterior detalhada](EVID-NOTTGARD-YGGDRASIL-VALIDATION-20261017-r1.md) e [dados das sessões](../generated/yggdrasil-map-20261017/s004-validation.json) preservam a falha original e sua resolução. Reutilizados: navegação/corpos/bordas, dash/investida/empurrão/separação, spawns/loot/cap40, simulação integral240s+3s, objetivo/limpeza/isolamento, regressões e capturas nas duas resoluções.

Auditoria final de Yggdrasil: zero divergências em12.438 amostras entre piso desenhado e apoio. Pisos anteriores idênticos ao baseline. Desempenho de Reino Abissal50, mesma máquina/cenário: mediana do loop +1,3%, simulação +6,3%; ambos os p95 ligeiramente abaixo do baseline. Valores absolutos/método e investigação preservados no relatório anterior. Não são certificação de FPS, dificuldade ou diversão.

## Próxima etapa e checkpoint

S-YGG-005, etapa5/5, exige autorização própria para abrir o playtest humano de **Raiz de Yggdrasil**, ainda com arte geométrica provisória. Entradas: build validada, sandbox isolado e percurso entrada→centro→desvios→passagem. Saída: relato do usuário sobre bordas, caminhos, espaço e pressão de combate. Objetivo: resistir240s e permanecer3s no alvo. Checks: lançamento/chegada corretos, perfil sintético preservado e retorno ao seletor; registrar aceite ou ajustes sem inferir avaliação da abertura da janela. CP-YGG-005 pendente; nenhuma sessão humana aberta nesta etapa. Arte final e integração do capítulo2 seguem fora deste recorte.
