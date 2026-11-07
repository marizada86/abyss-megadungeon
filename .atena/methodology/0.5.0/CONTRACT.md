# ADD portable contract v0.2

## Required files and folders

```text
.atena/
  add.yaml
  vault/
    canon/
    drafts/
    research/
  specs/
  evidence/
  generated/
  state/
    plan.yaml
```

`.atena/automation/` is optional until a skill or agent is approved.

`atena/` is a legacy v0.1 path. A v0.2 validator should detect it and report a migration requirement rather than silently treating both directories as canonical.

`state/conversations/<key>/plan.yaml` is persistent local operational state per chat; `state/plan.yaml` remains a readable legacy record. It is required even when no plan is active, in which case its plan, cursor, and suspension values are `null` and its deferred-request list is empty. It is not a canonical-vault record and must not be used to rewrite intent or approval history.

## Agent activation

Distribution 0.5.0 includes eight standard portable role procedures: Atena, Indiano, Odin, Miyazaki, Prometeus, Stanley, Zeus and Tolkien. Its project instruction bridge loads the native catalog on demand. See [native library and adoption](NATIVE-AGENTS.md). This changes distribution contents, not workspace contract 0.2. Older adoptions require an explicit update; personal profiles/knowledge remain separate. Role availability is distinct from client recognition and independently executing agents. This is the implemented distribution procedure (DRAFT r1), not automatic canonical promotion in an adopting project.

The portable workspace defines ADD state and records; it does not by itself inject behavior into an AI client. A project that wants Atena behavior must load project instructions through its root `AGENTS.md`. [`templates/AGENTS.md`](templates/AGENTS.md) is the copyable default: it activates Guided ADD, plan compliance, per-plan approval selection, and Atena Voice without replacing project-specific rules.

## `add.yaml` fields

```yaml
add_version: "0.2"

project:
  id: "PRJ-example"
  name: "Example"

interaction:
  default_mode: "direct"
  atena:
    trigger: "explicit-address"
    mode: "guided"
  direct_execution:
    allow_without_spec: true
    reconciliation: "propose-after-change"

specification:
  require_zero_blocking_gaps: true
  allow_explicit_defer: true
  recommend_defaults: true

bootstrap:
  tooling_checks:
    rtk:
      enabled: true
      required: false
      ask_if_missing: true
      ask_once: true
      status: "unknown" # unknown | enabled | declined | unsupported

policies:
  remote_context: "scoped-remote-context"
  draft_writing: "allowed"
  publishing: "explicit-approval"
  dependencies: "allowlist-with-plan"

autonomy:
  profile: "guarded-autopilot"
  approval_selection: "required-per-plan"
  report_mode: "step-updates-and-final"
  max_retries: 3

git:
  local_commits: "automatic-on-run-branch"
  direct_local_commits: "project-policy"
  merge: "explicit-approval"
  publish: "explicit-approval"

skills:
  record_opportunity_after_repetitions: 2
  propose_after_repetitions: 3

graph:
  mode: "derived"
  output: "generated/graph.production.json"
```

Projects may add fields. They must not redefine the meaning of the required fields in a way that hides a mandatory gate.

## Canonical record metadata

Every canonical record starts with frontmatter containing at least:

```yaml
id: "DEC-001"
type: "decision"
title: "Local-first workspace"
status: "approved"
created: "YYYY-MM-DD"
reviewed: "YYYY-MM-DD"
relations:
  - type: "supports"
    target: "CAP-001"
sources: []
```

Allowed initial types include `vision`, `constraint`, `decision`, `capability`, `requirement`, `risk`, `entity`, `location`, `faction`, `event`, `timeline`, `rule`, and `research-claim`.

## Spec contract

Each spec folder contains:

```text
spec.md
plan.md
tasks.md
acceptance.md
```

A spec must reference at least one canonical record or explicitly state that it creates the initial record.

### Required spec metadata

```yaml
id: "SPEC-001"
title: "Example change"
status: "draft"
origin: "planned" # planned | post-hoc
implementation_preceded_spec: false
created: "YYYY-MM-DD"
```

For post-hoc reconciliation:

```yaml
origin: "post-hoc"
implementation_preceded_spec: true
```

Do not change these markers to make the history look planned.

## Gap contract

Planned specs track unresolved items under three classes:

- `BLOCKING`: must be zero before `ready-for-approval`.
- `RESOLVABLE`: Atena records a grounded default/decision and may continue.
- `DEFERRED`: explicitly outside current scope and acceptance criteria.

A validator should reject a `ready-for-approval` planned spec with unresolved `BLOCKING` gaps.

## Planned approval contract

Every planned `plan.md` must record an `approval.mode` before it becomes executable. The mode is selected by the user for that plan and is one of:

- `per-plan`: one approval checkpoint for the complete bounded plan;
- `per-batch`: one approval checkpoint before each stable `B-XXX` batch;
- `per-step`: one approval checkpoint before each stable `S-XXX` step.

`unconfigured` is valid only while the plan is being drafted. A validator must reject a planned spec as `ready-for-approval` or executable while the mode is `unconfigured`.

Each satisfied checkpoint records its scope, approver, time, and plan revision. Approval:

1. confirms the bounded outcome and scope;
2. promotes the prepared spec to `approved`;
3. authorizes ordinary in-scope local implementation only through the selected approval checkpoint(s);
4. does not authorize always-approve actions unless they are separately and explicitly approved.

## Plan coordination contract

Every planned `plan.md` activated under this contract has a stable `PLAN-XXX` identifier and stable execution-step identifiers such as `S-001`. While implementation is active, the owning conversation's persistent state is the authoritative operational return point. The legacy record remains readable. The base shape is:

```yaml
version: 2
active_plan:
  id: "PLAN-001"
  spec_id: "SPEC-001"
  current_step: "S-004"
  total_steps: 8
  status: "ACTIVE"
  approval:
    mode: "per-batch"
    checkpoint: "B-002"
    status: "APPROVED"
plan_cursor:
  current: "Validate the contract"
  next: "Record evidence"
suspension: null
deferred_requests: []
```

The normative machine-readable shape is [`schemas/plan-state.schema.json`](schemas/plan-state.schema.json). A validator must reject malformed state and must report these semantic violations:

- an active plan without a matching active cursor;
- a cursor step not present in the referenced plan;
- an active plan without a valid approval mode and checkpoint state;
- work continuing beyond a `PENDING` approval checkpoint;
- a suspension without an active plan and saved cursor;
- duplicate deferred-request IDs;
- an unknown plan, spec, request, or step reference.

Before executing a new user request while this same chat's `active_plan.status` is `ACTIVE`, Atena must classify it:

- `IN_PLAN` — execute normally. Clarifications, small corrections, decisions requested by Atena, and changes necessary to complete the current step are `IN_PLAN`.
- `PLAN_DEVIATION` — do not execute until the Plan Deviation Gate records the user's route.
- `PLAN_CHANGE_REQUEST` — analyze impact on scope, decisions, steps, acceptance criteria, evidence, and recovery before replacing the active plan. The prior approval does not authorize the replacement.

For route A of a Plan Deviation Gate, persist `suspension` and its saved cursor and set `active_plan.status` to `SUSPENDED` before the parallel execution. Restore that cursor, return the status to `ACTIVE`, and clear `suspension` after the parallel work completes. For route B, append a `DEV-XXX` record with `status: PENDING` to `deferred_requests`; do not silently execute it later. Mandatory safety and approval gates still apply to either route.

### Conversation ownership and persistent state

The sequencing gate is scoped to the **same chat**, not the project or workspace. Resolve ownership before classifying a request. A plan in another chat does not prompt "do it now or after the plan", and must not be suspended, replaced or receive this chat's deferred requests. Actual conflicts over files/resources and mandatory approval gates remain applicable across chats.

Each conversation stores the existing version-2 shape in `.atena/state/conversations/<key>/plan.yaml`, with this additional root mapping:

```yaml
conversation:
  key: "local-example-chat"
  kind: "local"
  evidence: "Explicit plan approval in this conversation; local key, not a platform ID."
```

The key must match `^[A-Za-z0-9][A-Za-z0-9_-]{0,79}$` and its directory. Use `kind: platform` only for an actual exposed identifier compatible with that format; otherwise use a stable local key and truthful evidence of the conversation/approval. Reuse the recorded key on continuation; do not generate a new key every turn. Do not ask users for technical identifiers routinely or invent platform IDs. The binding records evidence; its mere presence is not independent proof of authorization.

Legacy `.atena/state/plan.yaml` remains readable and is never automatically assigned to the current chat or migrated. Without proven ownership, it cannot trigger a deviation gate or authorize execution here. Context from the current conversation can establish a local binding; ask for clarification only if explicitly resuming a plan is genuinely ambiguous. An explicit request to resume elsewhere must identify the source plan, confirm the scope/revision/checkpoint, and coordinate the handoff before copying a cursor; do not silently claim a plan still running elsewhere. A handoff does not grant new approval or automatically authorize a broader replacement.

Write only the owning conversation's state. Suspensions/deferred requests are scoped to that file. Before writing shared artifacts, inspect real concurrent changes, preserve others' work, and resolve concrete conflicts under their applicable gates. Separate files prevent cursor replacement, not every possible resource conflict; no runtime scheduler or automatic cross-chat messaging is introduced.

The read-only validator accepts `--conversation <key>` to select exactly one scoped state, verifies its binding, and never falls back to another chat or the legacy plan if the file is absent. Without this option it validates the legacy record but reports `binding: unscoped` and `executionReady: false`; `--require-executable` therefore requires a matched conversation and approved checkpoint. Low-level `validateState` and legacy fixtures check structural/approval validity only; callers deciding execution must use `validateConversationState` after selection. Validation cannot establish that an arbitrary key supplied by a caller really belongs to their chat.

## Post-hoc plan contract

For `origin: post-hoc`, `plan.md` is a reconstructed implementation map. It must state that it was produced after implementation and must not contain a fabricated prior approval.

## Validation rules

- `.atena/` is the only canonical v0.2 workspace root.
- IDs are unique and never reused.
- Relations use known types and point to existing IDs where required.
- Canonical intent cannot be rewritten without an approved successor or revision record.
- Operational canonical fields may be updated automatically only when caused directly by an authorized change and recorded in evidence.
- Every planned spec includes objective, scope, non-goals, acceptance criteria, impact, gap state, and validation.
- Every executable planned spec has a plan-of-flight approval, evidence, and reconciliation result.
- Every executable planned spec records an explicit per-plan, per-batch, or per-step approval mode.
- Every active planned spec has valid state in its owning chat's `.atena/state/conversations/<key>/plan.yaml`.
- A `PLAN_DEVIATION` has either a recorded suspension or a pending deferred request before execution continues.
- A planned spec cannot be approved with unresolved `BLOCKING` gaps.
- Every post-hoc spec preserves `origin: post-hoc` and `implementation_preceded_spec: true`.
- Direct Execution does not waive mandatory gates in `AUTONOMY.md`.
- The spec defines its quality gates; no predefined project type is required.
- RTK status never determines whether an ADD project is valid.

## Semantic plan validation

Schema validity establishes shape; semantic validation also resolves active plan/spec IDs, approved sequence and revision, current/next cursor, step total, matching approval mode/checkpoint and actual approval evidence. Valid PENDING persistence is not executable. Idle state has null cursor/suspension; suspended state preserves its exact saved cursor. Deferred IDs are unique.

Use [the read-only validator](tools/validate-add-state.cjs): node tools/validate-add-state.cjs --project <root> --schema <plan-state.schema.json>. Add --require-executable when checking permission to continue an active step. The portable validator supports the mapping/list/scalar subset used by ADD records; unsupported YAML fails explicitly. New plans identify revision in Plan mode, steps as numbered stable S-XXX IDs, and checkpoint records in the Approval record YAML fence. Per-batch records include steps as a list. The shared [plan template](templates/spec/plan.md) illustrates the contract. Validation never grants approval or executes work.
