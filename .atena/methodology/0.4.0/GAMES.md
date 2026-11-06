# ADD game creation guidance

## Purpose and activation

When a user clearly wants to create a game, Atena offers a structured game creation path and asks whether they want to use it. Detect the intent from the conversation, rather than matching the word `game` alone. A bug fix, a discussion of an existing game, or a quoted phrase does not restart discovery.

Suggested invitation:

```text
Posso te guiar pela definição do jogo, bíblia visual, escopo e primeiro protótipo. Quer seguir essa trilha?
```

Confirmation activates the game discovery path. It does not approve implementation, canonical promotion, engine installation, or publication. If declined, stop the invitation and follow the applicable [interaction mode](INTERACTION.md). The game path supplements Guided ADD without silently replacing an intentional Direct Execution request. When a direct request would benefit from discovery, offer it without requiring it for ordinary work the user already authorized.

This path is optional. ADD remains project-type agnostic, with the same [workspace contract](CONTRACT.md), [approval gates](AUTONOMY.md), and persistent plan cursor.

## Adaptive interview

Start from what the user has already said and what exists in the project. Adapt explanations to their demonstrated experience; users do not need to select a beginner or expert mode. Recommend short rounds of up to three related questions, adjusting when necessary.

After each round, present the current understanding, decisions, recommendations with reasons, and important open questions. Ask about choices that affect the intended experience or feasibility. Use grounded defaults for resolvable gaps and preserve decisions already supplied. A developed concept needs a gap review, not a new interview from scratch.

Genre, dimensionality, style, platform, and size emerge from the conversation. Do not prescribe a default game type. Revisit earlier choices when constraints or playtests provide a concrete reason.

## Initial definition sequence

| Stage | Establish | Working artifact |
| --- | --- | --- |
| 1. Experience and vision | Player fantasy, audience, desired feelings, references, purpose, and experience pillars | [Vision](templates/game/vision.md) |
| 2. Game design | Core loop, player actions, goals, challenges, feedback, controls, progression, and relevant world/lore | [Design](templates/game/design.md) |
| 3. Scope and production | Desired platforms, team, skills, available time, budget, content volume, and constraints | Scope in vision/design |
| 4. Visual bible | Visual direction, references, readability, and production requirements | [Visual bible](templates/game/visual-bible.md) |
| 5. First playable and readiness | Prototype hypothesis, playable boundary, acceptance, main pending items, and first playtest | [Prototype readiness](templates/game/prototype-readiness.md) and [playtest](templates/game/playtest.md) |
| 6. Technical recommendation, last | Engine, tools, dependencies, and minimum sufficient architecture justified by the preceding decisions | Technical recommendation in readiness and the bounded ADD spec |

The sequence puts engine and technology recommendations last in the initial definition, after an initial visual bible exists. Earlier stages may be refined together. This means defining enough to plan the first prototype, not completing every level, asset, or lore detail before building.

Desired platforms, input needs, performance expectations, visual requirements, and production constraints can be discussed before the technical stage as requirements. Avoid recommending an engine, framework, asset tool, or architecture prematurely.

## Visual bible before engine selection

Build a reviewable initial visual bible before choosing the engine. Tie its decisions to the intended player experience and feasible production scope. It must provide enough direction to inform technical recommendations and the first prototype; expand it by milestone.

Cover applicable topics:

- Artistic intent and relation to experience pillars.
- Annotated visual references, source, known usage conditions, and whether they are inspiration or usable assets.
- Visual language: dimensionality when defined, stylization, shapes, silhouettes, proportions, scale, palette, and materials.
- Characters, props, and environments present in the game.
- Camera, composition, lighting, and readability.
- Interface, typography, icons, and visual hierarchy.
- Animation, effects, and feedback for player actions.
- Relevant accessibility, such as communicating important states through cues beyond color alone.
- Production limits: asset volume, complexity, available skills, resources, and reusable work.
- Review criteria, proposed/approved references, hypotheses, and pending items.

Mark irrelevant topics as not applicable with a reason. Text and annotated references may be sufficient initially. Generating images, acquiring assets, or using paid services belongs to a separately bounded scope when requested and authorized. Do not choose tools before identifying the visual requirements.

Keep experimental visual choices in drafts. Present the revision and intended canonical changes for approval before promoting stable visual direction. Test placeholders should preserve the cues necessary for the prototype hypothesis; explain visual limitations that affect a playtest.

## Technical recommendation at the end of definition

Base the engine and technology recommendation on the established experience, design, scope, visual bible, prototype hypothesis, and team constraints. Compare materially viable options, explain trade-offs, cite the evidence used, and recommend the simplest sufficient choice. Research current capabilities, licensing, cost, and platform support when making an actual recommendation; document uncertainty rather than assuming support.

If the engine or another technology is already decided, record it as an existing constraint. Reconsider it only for a demonstrated conflict and through the applicable approval gate. Local installation of an engine or availability of a plugin does not determine the recommendation.

Technical decisions feed the approved spec and plan before implementation. A recommendation is not installation authority; existing dependency and architecture policies still apply.

## Always explain prototype readiness

Before starting a prototype, Atena must always state its main pending items. If there are none, say so explicitly. Present the report when defining the first playable and refresh it after the technical recommendation, before implementation.

The report includes:

- What the prototype should demonstrate, its playable scope, and acceptance criteria.
- Main pending items, why they matter, how they affect starting, and the required decision or action.
- `BLOCKING`: gaps that prevent correct or safe execution; resolve all before approval/execution.
- `RESOLVABLE`: gaps with a stated, grounded default and its rationale.
- `DEFERRED`: intentionally excluded decisions/content, their reason, and when to revisit them.
- Initial visual bible status and decisions required to support technical recommendations.
- After technical review: chosen technologies, tool availability, authorization, and implementation plan status.
- The concrete next step and whether the applicable checkpoints allow implementation.

Do not hide a pending item because it has a default. Deferred details that do not affect the prototype hypothesis need not block it. A zero-blocking report does not itself authorize execution past a pending ADD checkpoint.

## Prototype and production milestones

Recommend a small prototype of the core loop, using the lowest-cost assets sufficient for the test. Then assess whether a vertical slice would help demonstrate a representative integrated sample of gameplay, visuals, audio, and production. A very small game may not need a separate vertical slice.

Plan content, polish, and release through bounded specs and milestones appropriate to the game. Each milestone identifies scope, non-goals, dependencies, acceptance, validation, playtests, evidence, and canonical impact. Asset production, audio, and publication can have additional tracks when needed; do not assume tools or providers before the technical recommendation.

Prototypes test hypotheses. If observations suggest changing approved rules, pillars, or lore, propose and approve the material revision rather than silently rewriting the canon. Apply the active-plan request classification and recovery rules from [WORKFLOW.md](WORKFLOW.md).

## Always explain what each playtest tests

Before every playtest, tell the user what it should test. A playtest plan states:

- Build/version and game scope under test.
- Question or hypothesis being investigated.
- Who plays, conditions, estimated duration, and procedure.
- Actions to perform, situations to observe, and relevant limitations.
- Observable criteria, subjective questions, and expected evidence.
- Afterward: observations, result, unresolved items, and the decision to continue, adjust, retest, or revise intent.

Atena validates what technical checks and observations can demonstrate: functioning, consistency, failures, and behavior. The user plays and evaluates feel, difficulty, and enjoyment. Technical metrics and model judgments do not prove enjoyment. If nobody played, record the playtest as pending.

Illustrative instruction, without prescribing a game type:

```text
Neste teste, verificar se o jogador entende o objetivo sem explicação adicional,
consegue executar a ação central e percebe o resultado dela. Registrar onde
houve dúvida e avaliar a sensação de controle.
```

Milestone acceptance determines when human feedback is required. Subjective criteria remain unverified until the relevant human feedback is available. A pending test prevents advancement when it is required for acceptance or a decision of the next milestone; otherwise keep it explicitly pending. Any accepted exception must be documented under normal ADD completion rules.

## Records and templates

Copy only useful templates into the game's `.atena/vault/drafts/` and adapt them. Store source research in `.atena/vault/research/`. Keep vision, mechanics, lore, and visual direction as drafts during exploration. Promote stable decisions only when explicit approval identifies the content/revision being approved.

Working documents can summarize proposed decisions. Extract or promote approved content into canonical records with stable IDs and the metadata from [CONTRACT.md](CONTRACT.md); avoid treating an entire mixed draft as approved because one section was accepted. An approved plan may include a specifically identified promotion, avoiding redundant confirmations.

Use existing specs for milestones, `.atena/evidence/` for playtest results and validation, and `.atena/state/plan.yaml` for the execution cursor. Runtime assets and builds remain in project-appropriate locations, referenced by the records. No extra canonical workspace, required project type, or custom schema is introduced.

When adopting this guidance in another project, the game section of [templates/AGENTS.md](templates/AGENTS.md) supplies the essential instructions. Copy this guide and relevant templates too if a detailed local reference is useful; adjust any links for the destination.

## Visual readiness before specialist work

Before visual production, adaptation, animation or visual review, Atena structures the applicable visual bible, character/entity identity and scene context, using [visual readiness](templates/game/visual-readiness.md). References identify content, revision, DRAFT/CANON state and authority. Relevant BLOCKING gaps must be resolved. Position is not a prerequisite. Scene context may be textual; no built engine scene is required.

When identity is inapplicable (abstract work, a menu, an environment without a character), record why. A scoped experimental draft authorization supports work without canonical promotion. Missing references return to Atena's textual preparation before any visual specialist acts. Pose/camera/coordinates may be requested for a specific deliverable when genuinely needed, without reintroducing a universal position gate.

## Adoption preflight

Read the project's actual root-to-working-directory instructions, any nearer overrides, configuration, state and referenced guides. Check whether the local instructions contain game discovery, initial bible, visual readiness, progress and specialist routing. Confirm references resolve locally. Do not infer which instructions a past chat loaded from a file inspection alone. Existing project copies require a separately scoped migration; upstream updates do not rewrite them. A new ADD game initialization uses the current [instruction template](templates/AGENTS.md) and offers discovery explicitly, mentioning the visual bible.

[Specialist catalog](GAME-SPECIALISTS.md) provides recommendations by task. Adopt only relevant skill packages/agent briefs, preserving local rules and installed capabilities.
