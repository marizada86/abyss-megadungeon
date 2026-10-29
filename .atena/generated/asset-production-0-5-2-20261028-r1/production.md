# Produção complementar 0.5.2 — r1

Status: COMPLETE_CANDIDATES_DELIVERED, DRAFT. Autorização do dono em 2026-10-28: “atena pode gerar o que falta”, após a revisão dos assets.

Escopo: A01 ícone de corrosão das Docas; A02 carga da legião quebrável; A03 urna élfica quebrável. Objetos seguem as propostas da revisão r2, autorizadas pela continuação. A04 Discípulo opcional permanece adiado. Geração com imagegen nativo; referências exclusivamente locais. Sem instalação de dependências.

Prompts-base: `.atena/vault/drafts/PROMPTS-ASSETS-0-5-2-20261028-r2.md`, blocos A01–A03. Destino isolado: `assets_incoming/beta-0-5-2-20261028-r1/`. Fontes originais preservadas, sem sobrescrita dos assets aceitos.

Etapas: S-G01 registrar autorização e referências; S-G02 gerar as três fontes; S-G03 inspecionar e preparar dimensões/derivados isolados; S-G04 entregar candidatas e registrar pendências.

Checkpoint: S-G04/CANDIDATES_DELIVERED_AWAITING_VISUAL_ACCEPTANCE. Etapas concluídas: 4/4. Aceite humano pendente; integração de runtime, commit, push e publicação não incluídos.

## Entrega

- 3 fontes originais em `assets_incoming/beta-0-5-2-20261028-r1/sources/`, preservadas byte a byte após cópia da saída do imagegen nativo.
- 5 derivados em `assets_incoming/beta-0-5-2-20261028-r1/prepared/`: ícone 128×128; duas folhas 2560×512; dois sprites intactos 512×512 extraídos do primeiro quadro.
- Prompts finais exatos em `prompts.json`; dimensões, canal alfa, cortes de origem, escala uniforme e hashes SHA-256 em `qa.json`; visualização em `index.html`.

## QA e preparação

Fontes geradas: ícone 1254×1254 e folhas 1983×793. As folhas não vieram no contrato de cinco células quadradas: foram segmentadas nos espaços transparentes mais próximos das cinco colunas, recortadas e reduzidas com escala isotrópica única por objeto. Transparência com alfa >= 0,1 foi usada para localizar a silhueta e ignorar resíduos quase invisíveis nas margens; o alfa dentro dos recortes foi mantido. Originais completos preservados. Base dos quadros normalizados em y=432, centro em x=256. Altura intacta acompanha as referências existentes: carga 250 px, urna 285 px. Sem deformação de proporções.

QA técnico final: PASS, cinco PNGs com alfa real, dimensões conferidas, cinco quadros separados por folha, sem silhueta visível tocando os cortes de origem. Inspeção visual dos três derivados principais realizada: identidade/estilo coerentes com referências, sequência intacto → fragmentos e sem texto ou chão incorporado. O acabamento artístico e a semelhança da carga com o caixote existente ficam para aceite do dono, sem declarar aceite humano. Não houve teste em jogo nem admissão dos novos IDs.

Preparação executada com Godot local em projeto sintético sem autoloads, com APPDATA/LOCALAPPDATA/USERPROFILE isolados. Nenhum save real carregado. Log final `qa/preparation.log`; mensagem ambiental de certificate store preservada. Nenhuma mudança em runtime ou necessidade de portagem nesta entrega isolada.
