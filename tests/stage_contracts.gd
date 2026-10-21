extends RefCounted
## Conteúdo ainda não produzido para os mapas de objetivo cronometrado (sem chefe) da campanha do capítulo 1.
##
## Música e ambiência NÃO estão mais aqui: a decisão B4 da 0.5.0 reutiliza Pilares (Reino Abissal, Raiz) e Goranthis (Domwieck).
##
## Reino Abissal e Domwieck entram em data/stages.json, então os contratos globais "toda fase tem X" passam a vê-los.
## O dossiê dos mapas (SPEC-NOTTGARD-MISSING-MAPS-20261017: environments-resources-r1 e s003-catalog-scope-adjustment-r1)
## diz que música/ambiência não são necessárias ao protótipo e que história, crônica e trilha final não se completam
## "por efeito de um protótipo". Em vez de inventar conteúdo (ou afrouxar os testes para todos), cada adiamento é
## explícito aqui e test_stage_deferrals.gd falha quando o conteúdo passa a existir, para o adiamento ser removido.
##
## Em runtime a falta já é tolerada: Sfx cai na música "menu" e para a ambiência sem entrada, o Quartel só lista
## crônicas que existem, GroundDecals devolve vazio sem entradas e eventos sem peso simplesmente não surgem.

const TOPICS := ["music", "ambience", "chronicle", "decals", "random_events"]

const DEFERRED := {
	"reino_abissal": ["decals"],
	"domwieck": ["decals"],
}

static func deferred(stage_id: Variant, topic: String) -> bool:
	return (DEFERRED.get(String(stage_id), []) as Array).has(topic)
