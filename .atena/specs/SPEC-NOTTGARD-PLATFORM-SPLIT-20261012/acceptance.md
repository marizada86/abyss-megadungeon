# Aceitação da separação PC e web

DRAFT r1 autorizado. Verificação técnica local registrada na evidência de execução; aceites humanos e navegadores externos continuam pendentes.

| Critério | Evidência exigida |
| --- | --- |
| Dois projetos no local confirmado, sem dependência da origem ou do outro destino | Manifestos e auditoria de caminhos/referências; abertura/importação de cada projeto isolado |
| PC exporta somente Windows e web exporta somente Web | Presets e logs de exports locais com templates compatíveis; nenhum pacote mobile |
| Controles e layouts mobile não estão ativos em nenhum dos dois alvos | Auditoria de chamadas/flags e teste de configuração/entrada que tente ativar mobile e confirme ausência; APIs compartilhadas justificadas |
| Conteúdo, arte, mecânicas, versão e IDs preservados na base | Comparação de hashes dos arquivos comuns e lista justificada de diferenças por plataforma |
| Saves compatíveis e perfil real intacto | Fixtures sintéticas de carga/gravação/recuperação em diretório isolado; nenhuma leitura ou escrita do perfil real |
| PC mantém teclado/mouse/controle e evidências locais | Suíte pertinente e smoke; reteste físico de controle com dono marcado separadamente |
| Web mantém runtime, bridge, downloads/evidências e proteção de sessão | Smoke desktop em Chrome/Edge/Firefox disponíveis; áudio iniciado por gesto, fullscreen, foco, resize e recarga; teste sintético de sessão aceita/negada; browsers indisponíveis registrados sem alegar PASS |
| Não há regressão da separação na suíte comum | Resultados comparados à baseline; falhas preexistentes e testes específicos removidos documentados, sem esconder nova falha |
| Origem e planos concorrentes preservados | Hashes antes/depois do manifesto; única eventual alteração na origem é registro operacional delimitado; releitura do estado compartilhado e recibo de retorno |
| Contratos ADD e referências válidos nos dois projetos | add.yaml, vault/canon, vault/drafts, vault/research, specs, evidence, generated e state/plan.yaml com IDs próprios e procedência; links conferidos |
| Entrega local revisável | Dois candidatos, instruções de execução, matriz de manutenção/portagem e relatório; CP-SPLIT-02 humano pendente até resposta |

Baseline com falhas exige investigação e delimitação antes de alegar aceitação. Não fechar bugs preexistentes por este plano. Os registros consultados indicam BUG-032, BUG-033, BUG-034 e BUG-038 implementados aguardando playtest; BUG-028 adiado/aguardando coleta. Nenhum deles foi validado novamente nesta preparação.

Resultado e limites: [revisão](../../generated/platform-split-execution-20261012/REVIEW.md). CP-SPLIT-02: PENDING_HUMAN_PLAYTEST.
