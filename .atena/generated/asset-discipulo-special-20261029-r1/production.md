# Discípulo Pestilento — conjuração r1, 2026-10-29

Status: COMPLETE_CANDIDATE_DELIVERED_AWAITING_VISUAL_ACCEPTANCE, DRAFT. Aceite humano pendente.

Autorização: “aprovado, proximo”, após a carga r2, continuando a lista para A04. O adiamento anterior do A04 é superado somente para esta geração. Modo per-plan, 4/4 etapas: S-DG01 autorização/referências, S-DG02 geração, S-DG03 preparação/QA e S-DG04 entrega. Outros checkpoints preservados. Aceite da carga r2 registrado separadamente por hash.

Geração com imagegen nativo. Referências locais: idle.png e attack.png do Discípulo para identidade, anatomia, vestes e acessórios; special.png do Blogbog somente para estrutura de seis quadros. Prompt exato em [prompt.txt](prompt.txt); base A04 em ../../vault/drafts/PROMPTS-ASSETS-0-5-2-20261028-r2.md.

Fonte original preservada byte a byte em assets_incoming/discipulo-special-20261029-r1/sources/discipulo_pestilento_special_v01.png (2172×724). Derivado preparado em assets_incoming/discipulo-special-20261029-r1/prepared/discipulo_pestilento/special.png: PNG RGBA 1536×384, seis células de 256×384.

Preparação: localizar intervalos transparentes com margem de quatro pixels entre colunas, recortar limites com alfa >=0,1, aplicar a mesma escala isotrópica a todos os quadros, alinhar os pés em y=356 e centro x=128. Altura do primeiro quadro acompanha idle (172 px); a elevação dos braços/cabeça fica preservada nos posteriores (até 196 px). Não normalizar cada pose a uma mesma altura. Transparência interna dos recortes mantida. Fonte e derivado não sobrescrevem o runtime.

QA PASS: seis quadros separados sem silhueta visível nos cortes, dimensões e alfa conferidos; hashes, limites e escala em qa.json. Fonte e folha preparada inspecionadas visualmente: contração inicial, cabeça levantada e braço aberto em concentração, acessórios e vestes herdados, sem projétil, texto ou cenário. Acabamento artístico e identidade final ficam para aceite do dono. Sem teste em jogo.

Godot local executado em projeto sintético sem autoloads, com APPDATA/LOCALAPPDATA/USERPROFILE isolados; nenhum save real carregado. Código de saída 0, mensagem ambiental do certificado do Windows registrada em qa/preparation-v01.log. Sem instalação de dependências, mudanças no runtime, portagem, commit, push ou build. Entrega isolada da frente transferida; histórico não modificado.

Próximo checkpoint: aceite visual A04. A lista atual de novas gerações foi atendida: templo, carga revisada e conjuração. A integração futura do A04 exige registrar o estado special no consumer, ligá-lo ao cast_start, sustentar a preparação por 2,5 s e cancelar por interrupção/morte. Seis quadros a 12 fps duram apenas 0,5 s; não presumir esse comportamento entregue pela folha.
