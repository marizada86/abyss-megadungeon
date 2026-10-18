---
id: SPEC-NOTTGARD-YGGDRASIL-VALIDATION-ADJUSTMENT-20261017
revision: r2
status: APPROVED_OWNER_R2_IMPLEMENTED_VALIDATED
origin: planned
implementation_preceded_spec: false
classification: PLAN_CHANGE_REQUEST
step: S-YGG-004
approval_mode: per-step
---

# Ajuste delimitado da validação de Yggdrasil — proposta r2

O contrato r1 aprovado exige `data/level_design.json` com `raiz_yggdrasil.props=[]`, nenhum prop inicial e passagem em `test_level_design`. A execução integral revelou incompatibilidade: esse teste considera erro toda entrada sem props. A ausência foi deliberada e aprovada; inserir objetos apenas para passar o teste mudaria o mapa aprovado.

Proposta: ampliar o teto de **13 para 14 caminhos de jogo/testes**, acrescentando unicamente `tests/test_level_design.gd`. Os treze caminhos originais, regras, geometria, apresentação e isolamento permanecem com o mesmo escopo. Nenhuma dependência, arte, permissão, campanha ou portagem adicional.

Alteração concreta proposta, ainda NÃO aplicada:

```gdscript
if String(stage_id) == "raiz_yggdrasil":
    var prototype: Dictionary = Data.table("prototype_stages").get(stage_id, {})
    if not bool(prototype.get("qa_only", false)) or not design[stage_id].get("props", []).is_empty() or not props.is_empty():
        out.append("raiz_yggdrasil: protótipo QA deve permanecer sem props")
elif props.is_empty():
    out.append("%s: level_design sem props" % stage_id)
```

Substitui exclusivamente o atual `if props.is_empty()`/mensagem correspondente. As expectativas de todos os mapas anteriores permanecem, assim como determinismo, tipos, material, campos de chão e ausência de sobreposição. Para Yggdrasil a expectativa passa a testar positivamente o contrato QA sem props; não é uma dispensa geral para protótipos ou mapas vazios.

Aceitação: `test_level_design` sem falhas; nenhum caminho adicional ao novo teto; hash dos outros mapas e protegidos preservado. Repetir apenas esse conjunto e a compilação se o ajuste revelar erro novo. Reutilizar as verificações válidas da S-YGG-004, pois a proposta só modifica um teste sem alterar runtime. Responsável: Atena, sem delegação.

Recuperação: guardar o hash e cópia do teste antes de editar; se necessário, desfazer apenas a alteração desse teste após conferir concorrência. Se a proposta não for aprovada, manter a S-YGG-004 incompleta no checkpoint de ajuste, com sua falha e demais resultados registrados. Não concluir a etapa nem abrir S-YGG-005 antes da validação completa e autorização própria do playtest.

Esta revisão é DRAFT: não substitui o contrato r1 nem autoriza o 14º caminho até aceite explícito do usuário. A autorização já recebida para S-YGG-004 continua válida dentro dos treze caminhos originais.


## Aceite e resultado posterior

O usuário aprovou expressamente esta proposta (“aprovado”). O registro original DRAFT acima é histórico; seu ajuste foi incorporado ao contrato r1 pela [decisão CANON r2](../../vault/canon/DEC-YGGDRASIL-VALIDATION-ADJUSTMENT-20261017-r2.md). Alteração aplicada e test_level_design aprovado; [evidência final](../../evidence/EVID-NOTTGARD-YGGDRASIL-VALIDATION-20261017-r2.md). A etapa S-YGG-004 está concluída.
