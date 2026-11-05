# Produção de avisos comuns — 2026-11-05

Status: DRAFT / três fontes entregues / aceite humano pendente.

Autorização: “atena, verificar fila de assets e começar a gerar imagens”. Modo per-plan herdado. Ferramenta: image_gen integrada, uma chamada por folha, sem referências externas. Prompts exatos enviados: os três blocos de `prompts-source.md`, cópia do rascunho local preservada antes da geração.

| ID | Fonte entregue | Dimensões reais | Quadros visíveis |
|---|---|---|---|
| T20 | assets_incoming/queue-20261105-r1/T20_faixa_investida_v01.png | 2172×724 | 6 |
| T21 | assets_incoming/queue-20261105-r1/T21_mira_v01.png | 2172×724 | 6 |
| T22 | assets_incoming/queue-20261105-r1/T22_area_v01.png | 1536×1024 | 4 |

Proveniência, bytes e SHA-256 em `manifest.json`. Cópias integrais das saídas, sem recorte, redimensionamento ou edição. Inspeção visual das três saídas: contagem aparente de quadros correta, luz quente sobre preto, sem texto, grade ou magenta aparente. Isso não constitui aceite humano nem auditoria geométrica.

## Retenções técnicas

- T20/T21: tamanho e proporção divergem do canvas solicitado (1536×1024). Não usar as coordenadas de corte do prompt diretamente. Medir células, centros e margens no arquivo real antes de preparar.
- T20: verificar se a textura no miolo permanece uniforme o suficiente para esticar e se a espessura atende ao contrato.
- T22: medir raios, margens e espaçamento angular dos três traços; continuidade da rotação e ciclo ainda não validados.
- Todas: preto puro, paleta tingível, margens, estabilidade de escala/centro e loop precisam de medição e avaliação na preparação. Nenhum derivado ou teste em jogo foi produzido nesta frente.

## Fila e continuidade

Fontes anteriores aceitas preservadas: lote original de 125 selecionadas, oito fontes de queue-r1, dezenove folhas de queue-r2, ícones e VFX das evoluções. Não gerar novamente. HQ05 permanece pausada pelo dono.

Outro candidato encontrado: ícone de regra “alcançar o destino”, lote B de `.atena/vault/drafts/PROMPTS-ALPHA-PENDENCIAS-20261105-r1.md`. Música e sons desse documento não são imagens. Este lote iniciou pela lacuna explícita T20–T22 já registrada no plano.

Checkpoint: S-TC02/THREE_SOURCES_DELIVERED_REVIEW_PENDING. Próximo: dono revisa cada folha; Claude prepara e integra após aceite. Sem promoção a CANON, integração, save real, portagem automática, commit, push, build ou publicação. Regras globais referenciadas em C:/Users/gui-m/.codex/AGENTS.md e RTK.md indisponíveis neste computador; ADD e instruções locais consultados.
