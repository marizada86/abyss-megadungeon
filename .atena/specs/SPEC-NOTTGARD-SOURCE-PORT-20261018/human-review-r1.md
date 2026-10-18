# Avaliação humana da portagem — r1 DRAFT, preparada

Versão: **PORT-PC-20261018-B004-r1**, Windows x86_64, Godot 4.7.2,
candidata local `tmp/port-b3/candidate`, equivalente à entrega por hash.
Identificador completo em `b004/review-seal.json` e `integrity-r1.json`.
Não é uma exportação executável nem uma versão publicada. Estado do aceite:
**PENDENTE — nenhuma sessão humana realizada nesta validação**.

## Abrir a avaliação

Na pasta do projeto, abrir
`.atena/generated/source-port-20261018/b004/Avaliar-Portagem.cmd`.
O iniciador usa o Python já instalado, confere a versão preparada e cria uma
sessão nova com dados de teste separados. Não requer instalar dependências
nem alterar permissões. A verificação automática de abertura passou.

O jogo abre no Quartel com o Navegador QA. Escolher herói, fase e destino e
clicar **Abrir destino**. **Abrir Quartel** permite conferir menus/opções.
**F4** reabre o navegador; clicar no mundo se um campo estiver com foco.
**F1** abre o guia, **F5** uma anotação e **F6** uma captura local. Nada é
enviado automaticamente. Fechar a janela termina a sessão.

Teclado/mouse: WASD/setas ou movimento configurado; Q/botão direito para a
habilidade, E para interagir, C para ficha e Esc para pausa. Conferir o guia
para o layout do controle conectado. O teste sintético de controle já passou;
o conforto e o hardware físico ainda precisam de avaliação.

## Objetivo e sequência sugerida — 25 a 35 minutos

Avaliar identidade/movimento, legibilidade, resposta dos comandos, dificuldade,
conforto visual e áudio percebido. Atena verificou funcionamento técnico;
diversão e conforto dependem de quem joga. Usar seed **8142**, inicialmente
Durvall e nível **8**, sem armas/itens/passivas extras para comparar tentativas.
Para abertura normal e dicas, usar nível 1 e destino **Inicio da run**.

| Passo | O que fazer | Observar e critério humano |
|---|---|---|
| H-PORT-001 · Interface | Abrir Quartel → Opções, testar 1280×720 e 1920×1080, trocar fonte, visual, atmosfera e impacto reduzido; sair e reabrir a tela | Textos legíveis, rolagem e foco acessíveis, preferência mantida na sessão; nenhum aviso deve desaparecer por causa do filtro |
| H-PORT-002 · Heróis | Em Docas, caminhar nas oito direções, parar, atacar e ativar habilidade com Durvall; repetir brevemente com Zynara, Leoric, Arlindo e Erik | Base dos pés, escala, recortes, viradas e ataque coerentes; oeste de Durvall sem espelho indevido; anotar estranheza de passada/identidade sem aprovar arte por inferência |
| H-PORT-003 · Inimigos | Início de Docas: aproximar-se e afastar-se de arqueiros, cultistas e grupos | Antecipação de tiro/bote, distância, grupos e dano compreensíveis; distinguir ameaça antes de sofrer dano |
| H-PORT-004 · Chefes | Docas e Molor, **Chefe: entrada**; aguardar o surgimento natural e lutar atravessando fases | Totens, conjuração/interrupção pela ativa, alvos prioritários, áreas e avisos legíveis; avaliar espaço para reagir e dificuldade. As prévias diretas 70%/35% não substituem essa luta para avaliar L5 |
| H-PORT-005 · Progressão/itens | Conferir **Oferta de level-up**, ficha e requisitos de evolução; experimentar uma troca de item e depois uma run curta | Atual/novo claros, foco útil, requisitos compreensíveis; cinco evoluções e evolução por atributo já têm checks automáticos, mas sua descoberta/clareza precisa de parecer humano |
| H-PORT-006 · Interações | Procurar loja, baú normal/de chefe, quebráveis e pista de câmara | Abertura, idle, E/contexto, questlog, efeitos e som correspondentes; apresentação sem esconder alvo/texto; registrar qualquer sobreposição |
| H-PORT-007 · Mapas e HQs | Usar o atalho existente **Testar-Mapas.cmd** para Domwieck, Reino Abissal e Raiz de Yggdrasil; no navegador desta avaliação conferir **Quadrinho (prévia)**, HQ21 e HQ04 | Caminhos/bordas/objetivos preservados; arte, enquadramento, legendas e avanço/retorno das HQs consistentes. O atalho de mapas cria sua própria sessão isolada; registrar sessão e usar os mesmos arquivos da entrega |
| H-PORT-008 · Áudio/resultado | Ouvir ataques/ativa, abrir pausa, alterar volumes, testar **Resultado: vitoria**, **Resultado: derrota** e **Oferta de revive**; experimentar controle físico se disponível | Sons distinguíveis e volume confortável; ações do resultado acessíveis e retorno previsível; registrar quedas de fluidez e desconforto |

## Limites e pendências que devem acompanhar o parecer

- Arte integrada continua DRAFT. Gates de Durvall/M1, G-D4 e bugs visuais
  registrados não são encerrados pelo transporte ou por esta preparação.
  Nyrelia YN/YE e todos os demais candidatos retidos continuam retidos.
- A suíte global mantém 30 falhas e 2 erros de script herdados. Há lacunas
  de associação de música/ambiência e crônicas para Domwieck/Reino Abissal;
  não interpretar ausência como intenção de silêncio nem criar conteúdo.
- O benchmark é curto, fora da tela e com cenário delimitado. Não prova
  estabilidade em combate longo, outras GPUs/resoluções ou conforto real.
- Limpeza de recursos ao encerrar ainda emite mensagens em algumas suites
  e capturas. O smoke de 11 mapas permanece limpo.
- O roteiro não autoriza nova arte, reequilíbrio, promoção canônica,
  exportação/publicação ou alterações no progresso real.

## Devolutiva esperada

Preencher `human-feedback-r1.md`: cenário/herói, resolução, entrada usada,
o que aconteceu, o que esperava, gravidade e anotação/captura se houver.
Marcar por passo **satisfatório**, **precisa de ajuste** ou **não testado**.
Separar parecer de funcionamento, conforto/dificuldade e arte/identidade.
Uma aprovação deve identificar versão e escopo; aceite geral de teste não
promove automaticamente conteúdo DRAFT nem libera os recursos retidos.

Após o relatório técnico e esta preparação, o retorno autorizado é à HQ05,
S-V05-001/CP-V05-01, aguardando aceite da seleção visual r1. O feedback
humano da portagem permanece registrado como pendência independente.
