# CODEX-ITEMS-DRAFT-20261027-r3 · S-C09 · lote C: os 10 itens restantes (aguardando aceite)

Mesma voz e regras dos lotes A e B. Fontes lidas: `06_Itens/` (Luneta de Korrak, Lasca de Ailalore, Colar Rúnico de Thalion, Cajado da Família Infernum, Wave of Terror, Detector Arcano, Dispositivo Antimagia de Gilly, Dispositivo das Docas, Espelho das Almas Desejantes) e as Sessões 13, 18, 19 e 20 (parte 1), 21 e 22.
`req`: `base` (visto) ou `hq:<id>`. Os fatos das Sessões 21 e 22 ficam atrás da última HQ (`hqn_21`), pela regra de fim de arco que você já aprovou. `[jogo]` = sem lastro no Vault.
Os arquivos de item são curtos; quando só há uma linha, o item entra só com o "Quem é".

## Itens únicos

### Luneta de Korrak — `luneta_de_korrak`
**Quem é.** Luneta oficial que Gilly entregou a Korrak. — *06_Itens/Luneta de Korrak, Sessão 13*

### Lasca de Ailalore — `lasca_de_ailalore`
**Quem é.** Fragmento furtado da estrela Ailalore para reconstruir o Amuleto da Luz.
1. `base` A mesma lasca de estrela é a base do Martelo da Luz e do Anel da Passagem Sombria, forjados por Bromnor. — *06_Itens/Lasca de Ailalore; Martelo da Glória; Anel da Passagem Sombria*

### Colar Rúnico de Thalion — `colar_runico_de_thalion`
**Quem é.** Colar de Thalion Aetherion que emana magia do tipo Primordial.
1. `hq:hqn_21` Brilhou em vermelho enquanto Thalion sustentava o portal rúnico que arrastou o Kraken. As runas terminaram trincadas, e o esforço drenou a vitalidade dele. — *06_Itens/Colar Rúnico de Thalion, Sessão 21*

### Cajado da Família Infernum — `cajado_familia_infernum`
**Quem é.** Relíquia da família Infernum, feita de Yggdrasil e cravejada com pedras da estrela de Eléstria.
1. `hq:hqn_21` Trish decidiu que o cajado fica com um tio: não com Dante, por ele não ter magia, nem com Vergil, por achar a magia dele caótica. — *06_Itens/Cajado da Família Infernum, Sessão 21*

### Wave of Terror — `wave_of_terror`
**Quem é.** Espada longa mágica, recompensa de Graz'zt. Causa dano de ácido (Toque do Abismo).
1. `base` Dança das Sombras: o portador se esconde mesmo observado. — *Sessão 19 e 20 (parte 1)*
2. `base` Traz a Maldição da Ambição Sombria: em tensão social, o portador é compelido a semear discórdia. — *Sessão 19 e 20 (parte 1)*
3. `base` Graz'zt a deu ao grupo, com 4000 de ouro, como recompensa. — *Sessão 19 e 20 (parte 1)*

### Detector Arcano — `detector_arcano`
**Quem é.** Aparelho que detecta assinaturas mágicas. John Tobias o usou numa caravana de reconhecimento fora do Véu Vivo. — *06_Itens/Detector Arcano*
1. `hq:hqn_21` Detectou uma assinatura mágica fraca e extremamente pura, que levou John e Joseph Tobias até quem a emanava. — *06_Itens/Detector Arcano, Sessão 21* `[decisão C-2]`

### Dispositivo Antimagia de Gilly — `dispositivo_antimagia_gilly`
**Quem é.** Escudo antimagia para cerca de cinco pessoas, com cerca de trinta usos. O custo é sentido por quem o usa. — *06_Itens/Dispositivo Antimagia de Gilly*
1. `hq:hqn_21` Gilly o entregou aos Companions para a escolta de Bella. — *Sessão 22 (Companions)*

### Dispositivo das Docas — `dispositivo_das_docas`
**Quem é.** Mecanismo do porto das Docas que afasta criaturas do mar. É associado a Wonka. — *06_Itens/Dispositivo das Docas*
1. `hq:hqn_21` Wonka tentava consertá-lo depois do incêndio que Erik provocou. Um tentáculo do Kraken o capturou durante o combate. — *06_Itens/Dispositivo das Docas, Sessão 21*

### Espelho das Almas Desejantes — `espelho_das_almas_desejantes`
**Quem é.** Espelho que mostra o maior desejo de quem o encara. Graz'zt o roubou de Malcanthet.
1. `base` Malcanthet contratou o grupo, em segredo, para recuperá-lo ou trazer Graz'zt. — *06_Itens/Espelho das Almas Desejantes; Sessão 18*
2. `base` Ficava na parede secreta da sala de música do Castelo Argento, atrás de sete runas. — *04_Locais/Sala de Música do Castelo Argento; Sessão 19*
3. `base` Graz'zt entregou o espelho ao grupo ao oferecer a aliança. — *Sessão 19*

### Coração da Dominância — `coracao_da_dominancia` `[jogo]`
**Quem é.** Troféu da vontade: nasceu quando o portador resistiu à Rainha das Súcubos e conquistou seu respeito. — *jogo; sem arquivo no Vault* `[decisão C-3]`

## Arma que aponta para este item (`igual_a`)

| Arma | Nome no jogo | Aponta para |
|---|---|---|
| dominio_da_vontade | Domínio da Vontade | item `coracao_da_dominancia` |

## Resumo para aceite

10 itens e 1 arma por `igual_a`; 12 curiosidades (Lasca 1, Colar Rúnico 1, Cajado Infernum 1, Wave of Terror 3, Detector 1, Antimagia 1, Dispositivo das Docas 1, Espelho 3). Sem lastro (`jogo`): Coração da Dominância. Só a Luneta fica sem curiosidade.

Decisões:
- **C-1:** os fatos das Sessões 21 e 22 (Colar Rúnico, Cajado Infernum, Detector, Antimagia, Dispositivo das Docas) ficam atrás da `hqn_21`, como os demais fatos de fim de arco. Recomendo manter.
- **C-2:** o Detector Arcano entra sem o nome de quem ele encontrou (o arquivo cita "Temenos"). Recomendo manter assim; o Vault trata Temenos como personagem à parte, e a escolha de revelá-lo é sua.
- **C-3:** o Coração da Dominância entra só com a nota do jogo, sem ligá-lo a Sylas, já que o Vault não registra o item. Recomendo manter.
