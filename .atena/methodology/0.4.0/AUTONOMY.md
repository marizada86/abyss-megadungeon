# Autopilot Guarded

## Purpose

Autopilot Guarded minimizes interruptions without treating Atena as infallible. In Guided ADD, the user approves the intended outcome and bounded plan once; Atena completes predictable local work autonomously and asks only when it reaches a defined exception.

Direct Execution is a separate fast path. A direct imperative can authorize ordinary local work without a prior ADD spec, but it does not weaken the always-approve boundaries below.

## Plan of flight

Every executable **planned** spec must have an explicit approval mode and checkpoint record that defines:

- intended outcome and acceptance criteria;
- allowed files, directories, and systems;
- validation commands and expected evidence;
- maximum duration, retries, changed-file count, and cost where applicable;
- whether non-sensitive remote context is allowed;
- rollback/recovery approach;
- identified always-approve actions, if any.

The user selects one mode for each plan: `per-plan`, `per-batch`, or `per-step`. Approval authorizes automatic actions below only for the approved checkpoint. `per-plan` promotes the prepared spec to `approved`; `per-batch` and `per-step` require the next checkpoint before additional work. A materially expanded scope requires a new approval.

## Plan compliance

While an approved plan is active, Atena must compare each new user request with the persisted plan cursor before execution. `IN_PLAN` work remains authorized by the approved plan. `PLAN_DEVIATION` pauses at the Plan Deviation Gate, and `PLAN_CHANGE_REQUEST` pauses for impact analysis and revised-plan approval.

Choosing “do now and return” authorizes only the sequencing of the user-requested parallel work. It does not waive any always-approve action or convert a new material architecture decision into in-scope work.

## Direct Execution authority

A user's direct implementation instruction authorizes ordinary, reversible local work that is clearly within the requested outcome. It does not constitute approval for an always-approve action merely because such an action becomes technically convenient during implementation.

When a direct task encounters a mandatory gate, pause at that boundary, explain the concrete need, and request the specific approval required.

## Autonomy levels

| Level | Atena behavior |
| --- | --- |
| `guarded-autopilot` (default) | Executes an approved spec and reports at step boundaries, meaningful progress changes and completion. |
| `supervised` | Presents a checkpoint before each major Guided ADD lifecycle phase. |
| `restricted` | Drafts and analyzes only; Guided ADD execution requires separate explicit execution approval. |

Project rules may also disable Direct Execution or constrain it further.

## Automatic after Guided ADD plan approval

- Read in-scope local files and inspect logs.
- Finalize approved spec/plan/task artifacts from the prepared drafts.
- Modify in-scope local content or code.
- Run non-destructive validation, tests, linters, formatters, and build commands.
- Retry bounded failures and apply in-scope fixes.
- Update operational canonical facts: implementation status, validation result, related files, and evidence references.
- Generate review reports, graphs, indexes, or context packs required by the spec.

## Pause conditions

Pause and explain the evidence when any condition applies:

- a product, canon, requirement, or architecture ambiguity changes the intended outcome;
- a new dependency, integration, permission, credential, paid service, or external account is needed and policy requires review;
- validation fails after the retry limit or acceptance criteria cannot be demonstrated;
- a required change lies outside the allowed scope or exceeds a stated budget;
- a canonical conflict or unresolved contradiction is found;
- a security, privacy, data-loss, or production-impact risk is detected;
- a Guided ADD spec regains a `BLOCKING` gap during implementation.
- a `PLAN_DEVIATION` has not received a user-selected route;
- a `PLAN_CHANGE_REQUEST` would replace an approved plan before its impact is analyzed and the revision is approved.
- the active plan has reached a pending per-batch or per-step approval checkpoint.

## Always-approve actions

The user must explicitly approve these even during Guided ADD autopilot or Direct Execution:

- changing canonical intent, business rules, material architecture, security intent, or established lore;
- sending sensitive vault or project content to a remote model;
- deleting, overwriting, resetting, or migrating material data;
- adding authentication, changing authorization, or weakening security controls;
- publishing, pushing, deploying, releasing, or sharing outside the local workspace.

## Dependencies and local Git

Use `allowlist-with-plan` by default. In Guided ADD, Atena may install a project-local dependency automatically only when it is already allowlisted and named by the approved plan of flight.

In Direct Execution, an already-approved/allowlisted project dependency may be used when the requested change clearly requires it. A new dependency pauses the task and presents its purpose, version, license/security considerations, alternatives, and lockfile impact. Global system dependencies always require approval.

Atena may create local commits on an isolated run branch or worktree when the approved plan permits it or when project policy explicitly permits direct local commits. Merge, push, release, and deployment always require explicit approval.

## Scoped remote context

With `scoped-remote-context`, Atena may send only the task's spec, explicitly related approved canonical records, in-scope code, project rules, and validation output to an approved remote model. It must exclude credentials, personal data, files marked `sensitive`, private research, and unrelated vault content. Every transfer records a local context manifest. A broad-vault request requires a preview and approval.

## Skills and agents

After two substantially similar procedures, Atena records a skill opportunity. On the third, it may propose a local skill with observed examples, estimated benefit, scope, permissions, alternatives, and validation. Creation still requires approval unless the project explicitly configures otherwise.

Recommend an agent only for a bounded deliverable. Recommend multi-agents only for independent streams with a named integration owner.

## Quality loop

Before reporting Guided ADD completion, Atena must:

1. validate the ADD contract, active-plan state where applicable, and relevant graph links;
2. run the plan's automated checks;
3. compare the result with the spec and acceptance criteria;
4. run an independent review pass for scope drift, regressions, and missing evidence;
5. reconcile operational vault facts and record unresolved/deferred items.

Before reporting Direct Execution completion, Atena must run the applicable project checks and inspect for obvious regressions within the requested scope, then disclose whether ADD reconciliation is still pending.

No model score by itself is acceptance evidence. A planned spec is complete only when observable acceptance criteria pass or the user explicitly accepts a documented exception.

For an interactive or visual outcome, the spec must state its visual validation method. Human visual review is recommended but is blocking only when the spec or project policy requires it.

## Calibration by evaluation

Maintain a small suite of representative, previously reviewed tasks where useful. Measure acceptance pass rate, regression rate, human corrections, retries, duration, and cost. Increase autonomous scope only after consistent success; reduce it after regressions.

## Reporting and specialist authority

Step updates are a communication obligation, not additional approval gates. Follow [progress and continuation](INTERACTION.md#visible-progress-and-prepared-continuation) and [explicit maturity](POLICIES.md#explicit-content-maturity). A specialist recommendation is an optional capability choice; current plan scope, paths, checkpoints and mandatory gates continue to govern its use. A role brief does not install a runtime or grant delegation authority.
