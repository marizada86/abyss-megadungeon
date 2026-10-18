# Correção da referência de Gilly

Pedido IN_PLAN, PLAN-NOTTGARD-HQ-REVIEW-20261015 r1, S-HQ-002, etapa 2/16 (1 concluída; 15 em aberto). Dono rejeitou Q3 v01: “Gilly está errado, verifique a referência dele no vault”. Consulta de referência, sem nova produção nesta rodada.

## Evidência encontrada

- `D:/dev/nottgard/vault/03_NPCs/Gilly.md`: ficha canônica identifica Gilly Finadela, gnomo e Alto Conselheiro das Docas. Não descreve rosto/figurino nem incorpora imagem.
- `D:/dev/nottgard/vault/database/discord-messages-all.jsonl`, mensagens 1309380525768577094 (NPC, 2024-11-22) e 1335736874932768839 (lore, 2025-02-02): registros nominais de Gilly com anexo `file-6F1srH2xT7E9ODngdQw7Ea1j.png`. O link CDN não abriu pela ferramenta web; não se afirma inspeção dos pixels desse anexo nem equivalência por hash com a cópia local.
- Trilha histórica local `D:/dev/nottgard/games/IA/nottcard-ai/.atena/generated/ART-PROMPTS-003-personagens-2026-09-19.md`: banco de referências de identidade em `C:/Users/gui-m/Desktop/nottgard`, incluindo Gilly; documenta também candidata de corpo inteiro com correção de escala.
- Inspecionado `C:/Users/gui-m/Desktop/nottgard/Gilly.png`: gnomo de aparência idosa, cabelo branco/prateado volumoso penteado para trás, sobrancelhas brancas, bigode branco cheio e barba branca longa, orelhas pontudas, óculos redondos com corrente dourada, casaco azul-escuro/preto bordado em dourado, colete, lenço vinho, correntes/relógios e joias douradas.
- Inspecionada `D:/dev/nottgard/games/IA/nottcard-ai/assets/concepts/candidates/gilly_fullbody_candidate_v2_gnome.png`: candidata histórica DRAFT reproduz esses traços e proporções compactas. Não promovida a referência aprovada por esta consulta.

## Divergência e correção

A Q3 v01 foi baseada indevidamente no apresentador da HQ12-Q2. Mostra cabelo castanho/grisalho encaracolado, ausência de barba branca longa e óculos, e veste predominantemente vinho. Corrigir apenas a escala não resolveu a identidade. A declaração anterior de prontidão se mostrou insuficiente: faltou rastrear o banco nominal de referências. Esta evidência substitui aquela conclusão sobre Gilly.

Q3 v01 rejeitada e preservada no histórico. Próxima candidata deve anexar a referência nominal Gilly.png, manter sua identidade e escala de gnomo, acrescentando a embriaguez já aprovada no roteiro. Preservar os quatro protagonistas, suco de laranja de Durvall e fala atual. Não transferir ambiente ensolarado/personagens de fundo do retrato; a cena da HQ é interna em Nottgard. Não houve alteração de lore, vault externo, runtime ou nova geração nesta verificação.

Próximo objetivo: correção de Q3 usando a referência nominal, seguida de validação individual pelo dono. Checkpoint atual continua na revisão da HQ01; Q4 ainda não liberado.
