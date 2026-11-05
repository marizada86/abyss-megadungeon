// Gera o dossiê de áudio (HTML para impressão em PDF) e o CSV de apoio (mapa id -> prompt, uso interno).
// Uso: node build.js   (depois: msedge --headless --print-to-pdf ... dossie-audio.html)
const fs = require("fs");
const path = require("path");
const D = require("./data.js");
const ROOT = path.resolve(__dirname, "..", "..", "..");
const manifest = JSON.parse(fs.readFileSync(path.join(ROOT, "data", "audio_manifest.json"), "utf8"));
const enemies = JSON.parse(fs.readFileSync(path.join(ROOT, "data", "enemies.json"), "utf8"));
const esc = s => String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
const cur = ev => (manifest.events[ev] && manifest.events[ev].files && manifest.events[ev].files[0] || "").replace("res://", "");

// ---------- CSV (uso interno: ids reais; não vai ao LUDO.AI) ----------
const rows = [["grupo", "codigo", "evento_ou_arquivo", "modo_ludo", "duracao_s", "loop", "prompt", "arquivo_atual"]];
const csvEsc = v => '"' + String(v).replace(/"/g, '""') + '"';
const addRow = (g, c, ev, mode, dur, loop, prompt, file) => rows.push([g, c, ev, mode, dur, loop, prompt, file || ""]);
D.musicNew.forEach(m => addRow("A-musica-nova", m.code, m.file, "Music", m.loopSec, "sim", m.prompt, ""));
D.ambienceNew.forEach(m => addRow("A-ambiencia-nova", m.code, m.file, "Ambiance Loops", 10, "sim", m.prompt, ""));
D.evoSfx.forEach(e => addRow("C-sfx-evolucao", e.code, "weapon." + e.id + ".fire", "Sound Effects", e.sec, "nao", e.prompt, cur("weapon." + e.id + ".fire")));
D.musicRefresh.forEach(m => addRow("R-musica-existente", m.code, m.file, "Music", 60, "sim", m.prompt, m.file));
D.ambienceRefresh.forEach(m => addRow("R-ambiencia-existente", m.code, m.file, "Ambiance Loops", 10, "sim", m.prompt, m.file));
D.weapons.forEach((w, i) => addRow("S-sfx-arma", "W" + String(i + 1).padStart(2, "0"), "weapon." + w[0] + ".fire", "Sound Effects", w[3], "nao", w[2] + ", dry, no reverb tail.", cur("weapon." + w[0] + ".fire")));
D.heroes.forEach((h, i) => addRow("S-sfx-habilidade", "H" + String(i + 1).padStart(2, "0"), "hero." + h[0] + ".active", "Sound Effects", h[3], "nao", h[2] + ".", cur("hero." + h[0] + ".active")));
const bossTpl = {
  arrival: f => `Boss arrival sting: ${f}, ominous rising entrance with a heavy impact at the end, cinematic, no music.`,
  phase: f => `Boss phase change: ${f}, sudden transformation burst with a rising growl, short, powerful.`,
  defeat: f => `Boss defeat: ${f}, collapse and a final dying wail fading into silence, with a heavy last impact.`
};
const bossSec = { arrival: 2.5, phase: 1.5, defeat: 3.0 };
D.bossFlavor.forEach((b, i) => ["arrival", "phase", "defeat"].forEach(k => addRow("S-sfx-chefe", "B" + String(i + 1).padStart(2, "0") + k[0].toUpperCase(), "boss." + b[0] + "." + k, "Sound Effects", bossSec[k], "nao", bossTpl[k](b[2]), cur("boss." + b[0] + "." + k))));
addRow("S-sfx-chefe", "B00", "boss.arrival", "Sound Effects", 2.0, "nao", "Generic boss arrival sting: deep rising brass-like rumble and a heavy slam, cinematic, no music.", cur("boss.arrival"));
const groups = [["ui", "U", D.ui], ["progress", "P", D.progress], ["combat", "C", D.combat], ["player", "J", D.player], ["world", "M", D.world], ["result", "V", D.result]];
const catalogCodes = {};
for (const [name, pre, list] of groups) list.forEach((r, i) => { const code = pre + String(i + 1).padStart(2, "0"); catalogCodes[r[0]] = code; addRow("S-sfx-" + name, code, r[0], "Sound Effects", r[3], "nao", r[2] + ", dry, no reverb tail.", cur(r[0])); });
// inimigos
const archOf = id => {
  if (/_quebravel$/.test(id)) return "break";
  if (/^ilusao_/.test(id)) return "illusion";
  if (["zumbi", "alma_penada"].includes(id)) return "undead";
  if (["slime_corrosivo", "bolha_de_slime", "pudim_negro", "slime_de_juiblex", "cogumelo_fungico", "servo_de_zuggtmoy", "esporo_voador", "receptaculo_de_juiblex", "manifestacao_de_juiblex", "blogbog", "larva_de_lu_yueh"].includes(id)) return "ooze";
  if (["gargula", "carcereiro_de_pedra", "estatua_do_templo", "guardiao_copia", "guardiao_verdadeiro", "totem_de_chefe", "guardiao_de_goranthis"].includes(id)) return "stone";
  if (/^cultista|^escravo|^guarda_do|^master_of|^notivago|^acolito/.test(id) || ["cultista_adaga", "cultista_arqueiro", "cultista_cajado"].includes(id)) return "human";
  return "demon";
};
const breakPhrase = {
  caixote_quebravel: 0, candelabro_quebravel: 1, carroca_quebravel: 2, pilha_carga_quebravel: 3, arbusto_quebravel: 4, saco_de_esporos_quebravel: 5, casulo_viscoso_quebravel: 6,
  urna_funeraria_quebravel: 7, lanterna_de_papel_quebravel: 8, espelho_ilusorio_quebravel: 9, estatua_rachada_quebravel: 10, relicario_instavel_quebravel: 11, urna_elfica_quebravel: 12, carga_da_legiao_quebravel: 13
};
const arch = Object.fromEntries(D.enemyArch.map(a => [a.key, a]));
const enemyIds = [...new Set(Object.keys(manifest.events).filter(k => k.startsWith("enemy.") && k.split(".").length === 3).map(k => k.split(".")[1]))];
const enemyCount = {};
enemyIds.forEach(id => {
  const a = archOf(id);
  enemyCount[a] = (enemyCount[a] || 0) + 1;
  for (const k of ["action", "death"]) {
    let prompt;
    if (a === "break") { const ph = D.breakables[breakPhrase[id]]; prompt = ph ? ph[1].replace(/, ([\d.]+) s$/, "") + (k === "death" ? ", final break" : ", light hit before breaking") : "object breaking"; }
    else prompt = arch[a][k];
    const dur = (prompt.match(/([\d.]+) s\b/) || [0, k === "death" ? 0.8 : 0.45])[1];
    addRow("S-sfx-inimigo", "N-" + a, "enemy." + id + "." + k, "Sound Effects", dur, "nao", prompt.replace(/, [\d.]+ s$/, "") + ", dry.", cur("enemy." + id + "." + k));
  }
});
[["telegraph", "Rising warning hum before an enemy attack, ominous but clear", 0.6], ["charge", "Heavy buildup whoosh as an enemy charges", 0.8], ["summon", "Dark portal pop with a low swell as an enemy summons", 0.8]].forEach(r => addRow("S-sfx-inimigo", "N-generic", "enemy." + r[0], "Sound Effects", r[2], "nao", r[1] + ", dry.", cur("enemy." + r[0])));
fs.writeFileSync(path.join(__dirname, "audio-prompts.csv"), "﻿" + rows.map(r => r.map(csvEsc).join(",")).join("\r\n"));

// ---------- HTML ----------
const block = (code, title, meta, prompt) => `<div class="item"><div class="ih"><span class="code">${esc(code)}</span> <b>${esc(title)}</b></div><div class="meta">${meta}</div><div class="prompt">${esc(prompt)}</div></div>`;
const mm = (mode, dur, loop, extra) => `Modo: <b>${mode}</b> · Duração: <b>${dur}</b> · Loop: <b>${loop}</b>${extra ? " · " + extra : ""}`;
let h = "";
const sec = (n, t) => `<h1 class="${n >= 6 || n === 1 ? "pb" : ""}">${n}. ${t}</h1>`;
const countArch = Object.fromEntries(D.enemyArch.map(a => [a.key, enemyCount[a.key] || 0]));

h += `<div class="cover"><div class="tag">DOSSIÊ DE ÁUDIO · r1 · 5 de novembro de 2026</div><h1 class="ct">Abyss Megadungeon</h1><div class="cs">Brief de áudio e prompts de música, ambiência e efeitos sonoros<br/>para importação no LUDO.AI (Project + Audio Generator)</div>
<p class="note">Conteúdo deste documento: visão do jogo, direção de áudio, especificação técnica, recomendações de uso no LUDO.AI e todos os prompts de áudio do projeto em três prioridades: <b>Prioridade 1</b> (pendências do alpha: 6 faixas + 12 efeitos), <b>Prioridade 2</b> (renovar a música e a ambiência existentes: 20 faixas) e <b>Prioridade 3</b> (catálogo dos efeitos existentes: ${rows.filter(r => r[0].startsWith("S-")).length} eventos). Os prompts estão em inglês, por serem a forma mais segura de escrever para o gerador. Os textos de apoio estão em português.</p>
<p class="note small">Os blocos usam descrições genéricas de propósito: nomes de personagens, divindades e criaturas serão renomeados por direitos autorais antes da divulgação, e este PDF sobe para um serviço externo. O mapa entre os códigos deste PDF e os eventos reais do jogo fica no arquivo <b>audio-prompts.csv</b> (uso interno, não importar no LUDO.AI).</p></div>`;

h += sec(1, "Visão do jogo (para o projeto no LUDO.AI)");
h += `<p><b>Abyss Megadungeon</b> é um jogo de ação de sobrevivência em arena, no estilo "survivors-like" (roguelite), em 2D com projeção isométrica 2:1, para PC (Windows). Feito em Godot 4.7. Estado: <b>alpha demo</b> para amigos e testadores.</p>
<ul><li><b>Núcleo de jogo:</b> o jogador escolhe 1 entre 12 heróis e sobrevive a ondas de inimigos em mapas de 3 a 7 minutos (180 a 420 s). As armas disparam sozinhas; o jogador move o herói, escolhe melhorias ao subir de nível e evolui armas (nível 5 mais uma passiva). Há 55 armas, chefes em vários mapas e objetivos opcionais no mapa.</li>
<li><b>Campanha:</b> 11 mapas em sequência crescente de pressão. Os três primeiros duram 180 s (dois deles têm objetivo de chegada em vez de chefe); os demais têm chefe.</li>
<li><b>Direção de arte:</b> fantasia sombria, pintura com acabamento próximo do pixel art, contornos escuros, luz superior esquerda, paleta contida com um acento brilhante.</li>
<li><b>Tom:</b> sombrio, melancólico, ameaça constante, com beleza decadente. Ambientação de uma campanha de RPG de mesa em um continente fictício invadido por forças abissais.</li>
<li><b>Plataforma e escopo de áudio:</b> trilha por mapa (loop), ambiência por mapa (loop) e efeitos curtos que se repetem muito (uma arma pode disparar a cada 0,35 s com dezenas de inimigos na tela).</li></ul>`;

h += sec(2, "Direção de áudio");
h += `<ul><li><b>Pilares:</b> (1) legibilidade em combate acima de tudo; (2) identidade por mapa; (3) ameaça crescente ao longo da campanha; (4) sem fanfarra heroica nos mapas, só nos resultados.</li>
<li><b>Música:</b> instrumental, sem letra. Orquestral sombria com texturas do local (sinos, correntes, harpa, flauta, tambores). Cada mapa tem andamento e modo próprios; a tensão sobe do primeiro ao último mapa. Loop sem estalo na emenda.</li>
<li><b>Ambiência:</b> camada sem melodia e sem ritmo, nível baixo, sem picos. Fica sob a música.</li>
<li><b>Efeitos:</b> secos, curtos, sem cauda de reverb longa (as caudas se acumulam quando há muitos disparos). Ataque nítido, com corpo no grave. Sem vozes com palavras: grunhidos e sopros curtos são aceitáveis.</li>
<li><b>Mixagem do jogo (referência):</b> barramentos UI, Impacts, Player e Enemies; cada evento tem volume, variação de tom e intervalo mínimo próprios (por exemplo, disparos de arma a −12 dB com variação de tom de 3,5%).</li></ul>`;

h += sec(3, "Especificação técnica");
h += `<table><tr><th>Item</th><th>Situação atual</th><th>Entrega final exigida pela preparação</th></tr>
<tr><td>Formato</td><td>WAV PCM 16 bits, mono, 22 050 Hz</td><td>O mesmo (a preparação converte e recorta)</td></tr>
<tr><td>Música</td><td>12 faixas de 24 s em loop (uma por mapa de 8 mapas, mais menu, chefe, vitória e derrota)</td><td>1 loop por mapa; recomendado 60 s (ver recomendação 3)</td></tr>
<tr><td>Ambiência</td><td>8 faixas de 12 s em loop</td><td>1 loop por mapa; 10 s (máximo do modo Ambiance Loops)</td></tr>
<tr><td>Efeitos</td><td>${Object.keys(manifest.events).length} eventos e 533 arquivos referenciados (2 variações em geral)</td><td>2 variações por evento, 0,2 a 1,5 s (chefes até 3 s)</td></tr>
<tr><td>Origem atual</td><td>Sintetizado por script próprio (relatório de 22/09/2026); eventos mais novos reaproveitam arquivos com mudança de tom</td><td>Áudio gerado por IA, escolhido e aprovado pelo dono</td></tr></table>`;

h += sec(4, "Como usar o LUDO.AI neste projeto");
h += `<p class="small">Resumo da documentação oficial do LUDO.AI (páginas de Audio Generator e Project, consultadas em 05/11/2026). Itens marcados "não informado" não constam nas páginas consultadas.</p>
<table><tr><th>Necessidade</th><th>Modo do Audio Generator</th><th>Limites e controles</th></tr>
<tr><td>Efeitos sonoros</td><td>Sound Effects</td><td>Duração 0 a 10 s (passo de 0,5 s) ou Auto; chave Loop; a duração é um controle, não vai no texto do prompt</td></tr>
<tr><td>Ambiência</td><td>Ambiance Loops</td><td>Duração 0 a 10 s ou Auto; Loop ligado por padrão</td></tr>
<tr><td>Música</td><td>Music</td><td>Até cerca de 3 minutos ou Auto; chave Loop desligada por padrão; campo de letra opcional (não usar)</td></tr>
<tr><td>Ajustar um som que já existe</td><td>Audio Remix</td><td>Força de modificação de 0 a 1 (padrão 0,6); aceita áudio enviado ou gerado antes</td></tr>
<tr><td>Vozes</td><td>Human Voice, Non-Human Voice, Speech</td><td>Não usados neste projeto</td></tr></table>
<p><b>Importação do projeto:</b> na página inicial, o bloco "Import Project" tem três abas: PDF, Texto e Busca de jogo. Este documento é feito para a aba <b>PDF</b>: o LUDO.AI extrai o conteúdo para um projeto novo e o transforma em um documento de design editável. Limites de tamanho, páginas e idioma do PDF: <b>não informado</b>. A documentação também não diz se o Audio Generator lê o contexto do projeto (estilo de arte, gênero); por isso <b>cada prompt deste dossiê é autossuficiente</b> e não depende do projeto importado.</p>
<p><b>Acesso por API ou MCP</b> a todos os modos de áudio exige plano Pro ou Studio (segundo a página de recursos). Custo em créditos por geração: <b>não informado</b>. Número de variações por pedido: <b>não informado</b> ("Try Again" repete com as mesmas configurações).</p>`;

h += sec(5, "Recomendações");
const recs = [
  ["Comece pequeno e compare com o jogo", "Gere primeiro 1 música, 1 ambiência e 3 efeitos (um de arma, um de interface, um de chefe) e ouça dentro do jogo ao lado das faixas atuais. Só depois gere o lote inteiro. O custo em créditos não está documentado: este teste mede o consumo real."],
  ["Ambiência em 10 s, não em 12 s", "O modo Ambiance Loops chega a 10 s. As ambiências atuais têm 12 s, mas a duração do laço não é exigida pelo jogo. Gere em 10 s e a preparação ajusta o recorte (todo o dossiê já usa 10 s)."],
  ["Música em 60 s em vez de 24 s", "Os loops atuais de 24 s são um limite do sintetizador. Com música real, 60 s reduz a repetição perceptível em partidas de 180 a 420 s e custa cerca de 2,6 MB por faixa em mono 22 050 Hz. O modo Music chega a 3 minutos. Ligue a chave Loop; a preparação ainda faz a costura (fade cruzado curto) porque o laço do gerador pode não ser perfeito."],
  ["Duração é controle, não texto", "Nos efeitos, ajuste o controle de duração e não escreva a duração no prompt (a documentação recomenda assim). Os prompts deste dossiê já seguem isso; as durações estão na linha \"Duração\" de cada bloco."],
  ["Descreva a fonte e a ação, em linguagem literal", "Para efeitos, a documentação recomenda nomear o objeto, o material, a ação e o espaço, sem metáforas emocionais. Todos os prompts foram escritos assim. Ao ajustar um prompt, mantenha esse padrão."],
  ["Gere vários, escolha dois", "Cada evento do jogo usa 2 variações. Gere 3 a 5 takes por evento e escolha os 2 mais consistentes entre si em volume e timbre. Evite pares com cauda diferente."],
  ["Seco e curto", "Sons que se repetem (disparos, passos, acertos) devem ser secos: a frase \"dry, no reverb tail\" já está nos prompts. Caudas longas se acumulam com dezenas de inimigos e encobrem o combate."],
  ["Palavra \"instrumental\" e nenhuma letra", "Em música, deixe o campo de letra vazio e mantenha \"instrumental\" e \"no vocals\" no prompt. A documentação avisa que vocais podem aparecer sem esse reforço."],
  ["Prefira WAV; evite recompressão", "Baixe em WAV quando houver a opção. Se só houver MP3, converta uma única vez para o formato final. A saída do gerador chega a 44,1 kHz, e a preparação reduz para 22 050 Hz mono, por consistência com o resto do jogo."],
  ["Aprovação e rastreio", "Registre para cada arquivo aceito: código do bloco, data, modo, duração e plano usado. Guarde os originais (sem processamento). O dono aprova antes de qualquer integração; o jogo continua com os sons atuais até lá."],
  ["Licença e propriedade", "As páginas consultadas não informam os termos de uso comercial dos áudios gerados. Antes de publicar, leia os Termos do LUDO.AI e anexe a prova do plano ativo. Não use referências a artistas reais nos prompts (a documentação permite, mas aumenta o risco de semelhança)."],
  ["Plano e automação", "Para gerar em lote, a API ou o MCP exige Pro ou Studio. Se o plano atual for outro, gere manualmente: a Prioridade 1 tem só 18 blocos (3 músicas, 3 ambiências e 12 efeitos, ou 30 arquivos finais com 2 variações por efeito)."],
  ["Nomes protegidos", "Este PDF e o CSV não são trocados: o PDF vai ao LUDO.AI e usa texto genérico; o CSV fica no repositório e liga cada código ao evento do jogo. Não envie o CSV a serviços externos antes da renomeação."],
  ["Fidelidade: decisão para depois do alpha", "O jogo usa WAV mono 22 050 Hz. Se quiser mais fidelidade na música, a alternativa é OGG estéreo 44,1 kHz (cerca de 1 MB por minuto), o que exige ajustar caminhos no manifesto e os testes de áudio. Não é necessário para o alpha."]
];
recs.forEach((r, i) => { h += `<div class="rec"><b>${i + 1}. ${esc(r[0])}.</b> ${esc(r[1])}</div>`; });

h += sec(6, "Prioridade 1 · Pendências do alpha");
h += `<h2>6.1 Música de abertura (3 faixas)</h2><p class="small">Os três mapas de abertura têm 180 s de partida e hoje reutilizam faixas de outros mapas. Modo Music, Loop ligado, duração 60 s (mínimo aceitável 24 s). Campo de letra vazio.</p>`;
D.musicNew.forEach(m => { h += block(m.code, m.title, mm("Music", "60 s", "ligado", "Arquivo final: <code>" + esc(m.file.split("/").pop()) + "</code>") + "<br/>Clima: " + esc(m.mood), m.prompt); });
h += `<h2>6.2 Ambiência de abertura (3 faixas)</h2><p class="small">Modo Ambiance Loops, Loop ligado, duração 10 s. Camada sob a música: sem melodia, sem ritmo.</p>`;
D.ambienceNew.forEach(m => { h += block(m.code, m.title, mm("Ambiance Loops", "10 s", "ligado", "Arquivo final: <code>" + esc(m.file.split("/").pop()) + "</code>"), m.prompt); });
h += `<h2>6.3 Sons próprios das 12 evoluções de armas</h2><p class="small">Modo Sound Effects, Loop desligado. 2 variações por evento. A duração está em cada bloco e é ajustada no controle, não no texto. Hoje estas evoluções reutilizam o som da arma base com tom mais grave.</p>`;
D.evoSfx.forEach(e => { h += block(e.code, e.title, mm("Sound Effects", e.sec + " s", "desligado", "2 variações"), e.prompt); });

h += sec(7, "Prioridade 2 · Renovar a música e a ambiência existentes (opcional)");
h += `<p class="small">As 12 músicas e 8 ambiências atuais foram sintetizadas por script. Estes prompts permitem trocá-las por áudio de maior fidelidade mantendo a identidade de cada mapa. Modo Music (loop ligado, 60 s) e Ambiance Loops (loop ligado, 10 s). Gerar só depois de a Prioridade 1 ser aprovada.</p><h2>7.1 Músicas (12)</h2>`;
D.musicRefresh.forEach(m => { h += block(m.code, m.title, mm("Music", m.code >= "R10" ? "20 a 40 s (sem loop nas vinhetas R11 e R12)" : "60 s", m.code >= "R11" ? "desligado" : "ligado"), m.prompt); });
h += `<h2>7.2 Ambiências (8)</h2>`;
D.ambienceRefresh.forEach(m => { h += block(m.code, m.title, mm("Ambiance Loops", "10 s", "ligado"), m.prompt); });

h += sec(8, "Prioridade 3 · Catálogo dos efeitos sonoros existentes");
h += `<p class="small">O jogo tem ${Object.keys(manifest.events).length} eventos sonoros. Cada bloco abaixo corresponde a um evento; todos usam o modo Sound Effects com Loop desligado e 2 variações por evento, duração informada na linha de cada item. O código (por exemplo W07) liga o item ao evento real no arquivo <b>audio-prompts.csv</b>. Substituir estes sons é opcional: os atuais funcionam.</p>`;
const small = (code, label, meta, prompt) => `<div class="li"><span class="code">${esc(code)}</span> <b>${esc(label)}</b> <span class="meta2">${esc(meta)}</span><br/><span class="prompt2">${esc(prompt)}</span></div>`;
h += `<h2>8.1 Disparos das armas (${D.weapons.length})</h2>`;
D.weapons.forEach((w, i) => { h += small("W" + String(i + 1).padStart(2, "0"), "Arma · " + w[1], w[3] + " s", w[2] + ", dry, no reverb tail."); });
h += `<h2>8.2 Habilidades ativas dos heróis (${D.heroes.length})</h2>`;
D.heroes.forEach((x, i) => { h += small("H" + String(i + 1).padStart(2, "0"), "Habilidade · " + x[1], x[3] + " s", x[2] + "."); });
h += `<h2>8.3 Chefes (9 chefes, 3 eventos cada, mais 1 chegada genérica)</h2><p class="small">Cada chefe tem chegada, mudança de fase e derrota. Use os três modelos abaixo trocando o trecho do chefe. Códigos B01 a B09 (A = chegada, P = fase, D = derrota); B00 é a chegada genérica.</p>`;
h += `<div class="li"><span class="code">Modelo A</span> <span class="meta2">2,5 s</span><br/><span class="prompt2">Boss arrival sting: [chefe], ominous rising entrance with a heavy impact at the end, cinematic, no music.</span></div>
<div class="li"><span class="code">Modelo P</span> <span class="meta2">1,5 s</span><br/><span class="prompt2">Boss phase change: [chefe], sudden transformation burst with a rising growl, short, powerful.</span></div>
<div class="li"><span class="code">Modelo D</span> <span class="meta2">3 s</span><br/><span class="prompt2">Boss defeat: [chefe], collapse and a final dying wail fading into silence, with a heavy last impact.</span></div>`;
D.bossFlavor.forEach((b, i) => { h += small("B" + String(i + 1).padStart(2, "0"), "Chefe · " + b[1], "", "[chefe] = " + b[2]); });
h += small("B00", "Chegada genérica de chefe", "2 s", "Generic boss arrival sting: deep rising brass-like rumble and a heavy slam, cinematic, no music.");
const catOf = [["8.4 Interface", "ui", "U", D.ui], ["8.5 Progresso e recompensas", "progress", "P", D.progress], ["8.6 Combate", "combat", "C", D.combat], ["8.7 Herói", "player", "J", D.player], ["8.8 Mundo e eventos", "world", "M", D.world], ["8.9 Resultado da partida", "result", "V", D.result]];
for (const [title, , pre, list] of catOf) { h += `<h2>${title} (${list.length})</h2>`; list.forEach((r, i) => { h += small(pre + String(i + 1).padStart(2, "0"), r[1], r[3] + " s", r[2] + ", dry, no reverb tail."); }); }
h += `<h2>8.10 Inimigos e objetos quebráveis (${enemyIds.length} fontes, ${enemyIds.length * 2 + 3} eventos)</h2><p class="small">Cada inimigo tem um som de ação (ataque ou movimento marcante) e um de morte. Por serem muitos, os prompts são por arquétipo; cada fonte herda o do seu arquétipo (a lista exata está no CSV, linhas com código N-...). Gere 2 variações de ação e 2 de morte por arquétipo e reaproveite com variação de tom; nos chefes e nos inimigos mais marcantes vale gerar sons exclusivos depois.</p>`;
D.enemyArch.forEach(a => { h += `<div class="li"><span class="code">N-${esc(a.key)}</span> <b>${esc(a.title)}</b> <span class="meta2">${a.key === "generic" ? "3 eventos" : (countArch[a.key] || 0) + " fontes"}</span><br/><span class="prompt2">Ação: ${esc(a.action)}</span>${a.death !== "-" ? `<br/><span class="prompt2">Morte: ${esc(a.death)}</span>` : ""}</div>`; });
h += `<h3>Objetos quebráveis (14 tipos, ação = golpe antes de quebrar, morte = quebra final)</h3>`;
D.breakables.forEach((b, i) => { h += small("Q" + String(i + 1).padStart(2, "0"), b[0], "", b[1] + " (gerar 2 sons: um golpe leve e a quebra final)"); });

h += sec(9, "Depois da geração: o que fica por conta da preparação");
h += `<ul><li>Converter para WAV PCM 16 bits, mono, 22 050 Hz; recortar; costurar os laços (fade cruzado curto); nivelar pelo RMS dos sons atuais.</li>
<li>Registrar os arquivos novos em <code>data/audio_manifest.json</code> (música, ambiência e eventos), rodar a importação do Godot e os testes de áudio.</li>
<li>Conferir em jogo uma partida de cada mapa (emenda do laço, transição para a música de chefe) e os efeitos mais frequentes em uma cena cheia.</li>
<li>O jogo continua funcionando com os sons atuais até cada lote ser aprovado pelo dono.</li></ul>
<p class="small">Fontes consultadas: documentação oficial do LUDO.AI, páginas Audio Generator (ludo.ai/docs/audio-generator, ludo.ai/features/audio-generator) e Project (ludo.ai/docs/project, ludo.ai/features/project), em 05/11/2026.</p>`;

const css = `
@page { size: A4; margin: 18mm 16mm 18mm 16mm; @bottom-right { content: counter(page) " / " counter(pages); font: 9pt "Segoe UI", sans-serif; color: #777; } @bottom-left { content: "Abyss Megadungeon · Dossiê de áudio r1"; font: 9pt "Segoe UI", sans-serif; color: #777; } }
* { box-sizing: border-box; }
body { font: 10.5pt/1.45 "Segoe UI", Arial, sans-serif; color: #1c1c22; }
h1 { font: 700 17pt "Segoe UI", sans-serif; color: #2a1d4e; border-bottom: 2px solid #5b3fa0; padding-bottom: 3px; margin: 22px 0 10px; break-after: avoid; }
h1.pb { page-break-before: always; }
h1.ct { font-size: 34pt; border: none; page-break-before: avoid; margin: 8px 0; }
h2 { font: 700 13pt "Segoe UI", sans-serif; color: #5b3fa0; margin: 16px 0 6px; break-after: avoid; }
h3 { font: 700 11pt "Segoe UI", sans-serif; color: #444; margin: 12px 0 4px; break-after: avoid; }
.cover { padding-top: 40mm; }
.cover .tag { font: 600 10pt "Segoe UI"; letter-spacing: .12em; color: #5b3fa0; }
.cover .cs { font-size: 14pt; color: #333; margin: 8px 0 22px; }
.note { background: #f3effb; border-left: 4px solid #5b3fa0; padding: 8px 12px; margin: 10px 0; }
.small { font-size: 9.5pt; color: #444; }
.item { border: 1px solid #d9d4ea; border-radius: 4px; padding: 7px 10px; margin: 7px 0; break-inside: avoid; }
.ih { font-size: 11pt; }
.code { font: 700 9pt Consolas, monospace; background: #2a1d4e; color: #fff; padding: 1px 6px; border-radius: 3px; }
.meta { font-size: 9pt; color: #444; margin: 3px 0; }
.prompt { font: 9.5pt/1.4 Consolas, "Courier New", monospace; background: #f6f6fa; padding: 6px 8px; border-radius: 3px; white-space: pre-wrap; }
.li { margin: 5px 0; break-inside: avoid; padding-bottom: 4px; border-bottom: 1px dotted #ddd; }
.meta2 { font-size: 9pt; color: #666; }
.prompt2 { font: 9.3pt/1.35 Consolas, "Courier New", monospace; color: #222; }
.rec { margin: 6px 0; break-inside: avoid; }
table { border-collapse: collapse; width: 100%; margin: 8px 0; font-size: 9.5pt; }
th, td { border: 1px solid #cfc9e2; padding: 4px 7px; text-align: left; vertical-align: top; }
th { background: #ece7f7; }
code { font-family: Consolas, monospace; font-size: 9pt; background: #efeff4; padding: 0 3px; border-radius: 2px; }
ul { margin: 6px 0 6px 18px; padding: 0; }
`;
const html = `<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><title>Abyss Megadungeon · Dossiê de áudio para o LUDO.AI</title><style>${css}</style></head><body>${h}</body></html>`;
fs.writeFileSync(path.join(__dirname, "dossie-audio.html"), html);
console.log("HTML ok; linhas do CSV:", rows.length - 1, "; fontes de inimigo:", enemyIds.length, JSON.stringify(enemyCount));
