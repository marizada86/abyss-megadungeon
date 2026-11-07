# Agentes nativos — Atena 0.5.0

A candidata local 0.5.0 inclui **Atena, Indiano, Odin, Miyazaki, Prometeus, Stanley, Zeus e Tolkien** por padrão. [Catálogo e procedimentos DRAFT r1](agents/README.md), implementação autorizada no PLAN-022 r1. Não é necessário adotar o perfil pessoal Marizverso ou copiar conhecimento do mantenedor.

Para preparar o pacote em um destino novo:

```powershell
node tools/build-atena-portable.cjs release-staging/add-0.5.0-r1/package
```

Os comandos abaixo mostram prévia. Usar `--apply` somente para a adoção/atualização aprovada do projeto escolhido:

```powershell
node <pacote>/bin/atena-add.cjs install <projeto>
node <pacote>/bin/atena-add.cjs update <projeto> --source <pacote>
node <pacote>/bin/atena-add.cjs agents <projeto> --json
node <pacote>/bin/atena-add.cjs status <projeto> --details
```

Instalação nova recebe os oito papéis, com catálogo e ponte no AGENTS.md; atualização preserva snapshots, configuração, canon, conhecimento, instruções locais e planos. Uma versão antiga permanece sem a biblioteca até ser atualizada. `agents` inspeciona a instalação efetiva, não presume que a candidata já foi aplicada.

Em outro PC, transferir o pacote revisado e instalar/adotar no projeto com Node >=20. Após o cliente carregar as instruções, o usuário pode pedir um especialista pelo nome ou domínio. Atena consulta o procedimento necessário e integra a entrega. São papéis sequenciais por padrão; processos independentes exigem suporte e autorização próprios. Instalação não sincroniza memória nem transfere aprovações.

Esta implementação foi preparada para testes locais isolados. A execução em outro PC/OS/conta/cliente precisa de observação própria; arquivos copiados não comprovam reconhecimento pelo cliente. Publicação e atualização de projetos reais são ações separadas. Versões anteriores permanecem preservadas e não devem ser reconstruídas in-place.
