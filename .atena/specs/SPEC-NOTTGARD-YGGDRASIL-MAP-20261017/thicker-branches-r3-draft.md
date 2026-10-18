---
id: SPEC-NOTTGARD-YGGDRASIL-THICKER-BRANCHES-20261017
revision: r3
status: APPROVED_OWNER_R3_IMPLEMENTED_TECHNICAL_PASS
origin: planned
implementation_preceded_spec: false
classification: PLAN_CHANGE_REQUEST
step: S-YGG-005
approval_mode: per-step
---

# Galhos mais grossos — ajuste proposto r3

Feedback do usuário durante S-YGG-005: “Atena, os galhos da Yggdrasil devem ser mais grossos”. Pedido de ajuste, sem aceite da build anterior. Plano r1 com ajuste r2, etapa5/5 em andamento,4/5 concluídas. A direção desejada está explícita; medidas concretas abaixo são proposta para checkpoint antes de implementar, pois alteram a geometria aprovada do contrato r1.

## Recorte concreto

Aumentar em50% a largura de todos os galhos: eixo principal8→12 unidades e desvios6→9. Ampliar discos para concordância nas junções: E6→8, C7→9, G4→6 e W1/W2/L1/L2 de5→7; centros e oito ligações preservados. Aumentar espessura lateral visual16→28px para maior volume. A lateral permanece representação sem piso adicional; o topo e a área transitável usam a mesma malha. Bordas continuam travadas.

Escopo limitado a três caminhos já admitidos no teto14: data/root_navigation.json (somente Yggdrasil), ui/ground.gd (somente representação Yggdrasil) e tests/test_yggdrasil_navigation.gd (expectativas dimensionais e testes da nova borda). Caso novo caminho seja necessário, apresentar antes de editar. Sem arte final/imagegen, nova referência ou dependência. Sem mudanças de duração240s, presença3s, alvo/chegada, cap40 ou ondas. Reino Abissal e Domwieck preservados. A identidade visual final continua pendente em plano próprio.

## Evidência e gaps

[Dados antes/depois e análise independente](../../generated/yggdrasil-map-20261017/thicker-branches-r3-proposal.json). Grade documental com margem0,71, raios0,3/0,4/0,8: 1026 células conectadas para raio0.3; 1014 células conectadas para raio0.4; 892 células conectadas para raio0.8. Alvo alcançável em todos. Pontos(23,24)/(37,24) continuam vazios nos dois desvios. Esta análise não é teste Godot nem afirma dificuldade/espaço subjetivamente aprovados. Zero gaps BLOCKING para apresentar a implementação; escolha quantitativa aguarda aceite. Arte final DEFERRED.

## Execução, validação e retorno

Após aprovação: registrar baseline dos três caminhos; aplicar medidas; adaptar teste da borda para a nova entrada; executar isoladamente test_yggdrasil_navigation, test_yggdrasil_map (inclui simulação integral), test_root_navigation, test_terrain e test_scripts_compile. Conferir que dados e renderizadores dos mapas anteriores mantêm hashes/conteúdo. Repetir capturas de Yggdrasil nas duas resoluções, combate/tons de cinza/overview, auditoria raster versus colisão e medição Yggdrasil40 com seed7504, dt1/60,30+600frames. Usar exclusivamente perfil/APPDATA/LOCALAPPDATA sintéticos e probe sem autoload. Reutilizar checks inalterados dos mapas antigos; não promover seus resultados como validação da nova geometria.

Aceitação técnica: malha conectada, topo sem apoio falso, corpos confinados, objetivo acessível, cap respeitado, mapas anteriores preservados e teto14. Recuperação: comparar concorrência e reverter apenas trechos próprios dos três caminhos para baseline desta revisão. Aprovação da revisão autoriza aplicar, verificar e reabrir o playtest isolado dentro da S-YGG-005, após informar novamente o percurso e critérios. Não encerrar a etapa até relato do usuário sobre a nova build.

Checkpoint CP-YGG-005-R3: aprovar este aumento de largura/volume e a repetição delimitada da validação/playtest. Aprovações e evidências r1/r2 continuam históricas para suas builds; não valem como aceite da revisão r3.


## Aprovação e execução

Usuário aprovou r3 explicitamente e autorizou aplicar, testar e reabrir. Conteúdo DRAFT anterior mantido como registro da proposta; [decisão CANON](../../vault/canon/DEC-YGGDRASIL-THICKER-BRANCHES-20261017-r3.md) incorpora o ajuste. Três caminhos alterados, cinco testes afetados/capturas/auditoria aprovados; [evidência](../../evidence/EVID-NOTTGARD-YGGDRASIL-THICKER-BRANCHES-20261017-r3.md). Aceite humano da nova build pendente.
