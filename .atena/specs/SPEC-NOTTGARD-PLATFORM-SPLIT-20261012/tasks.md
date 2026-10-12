# Tarefas de separação por plataforma

DRAFT r1 autorizado no CP-SPLIT-01. Cinco etapas locais executadas; revisão humana no CP-SPLIT-02 pendente.

- [x] S-SPLIT-001: reler instruções e ADD da origem e destinos; inventariar apenas fontes/recursos/testes pertinentes; registrar hashes, recursos transitivos e baseline; confirmar engine e templates sem instalação; persistir suspensão e retorno delimitados após aprovação.
- [x] S-SPLIT-002: criar as duas subpastas sem sobrescrita; copiar pelo manifesto; preservar UIDs; regenerar caches; criar contratos ADD e referências válidas à história da origem, sem clonar todos os registros; marcar a procedência e as etapas reais.
- [x] S-SPLIT-003: remover exports/shell Web do PC; eliminar caminhos mobile e bridge web ativos; preservar evidência nativa, save e controles; adaptar testes específicos, documentando os excluídos; gerar candidato Windows local.
- [x] S-SPLIT-004: remover exports Windows do web; preservar shell, bridge, identidade e contratos de sessão; eliminar caminhos mobile/nativos ativos; adaptar testes específicos e gerar candidato web local sem publicar.
- [x] S-SPLIT-005: verificar isolamento de recursos, paridade do conteúdo, saves sintéticos, menu/run/pausa/reinício/evidências, acesso protegido em ambiente sintético quando necessário; comparar baseline; registrar limitações e roteiro de teste físico; reconciliar estados e solicitar CP-SPLIT-02.

Artefatos de execução deverão conter plataforma, build ID, hashes da base e perfil de export. Ferramentas de QA não podem escrever em saves reais ou enviar evidências para serviços externos nesta validação.
