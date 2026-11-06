# ADD policies

## Local-first

The authoritative ADD workspace resides at `.atena/` inside the local project folder. Git or GitHub is optional replication, not the source of truth.

`atena/` is a v0.1 legacy workspace. If it is found without `.atena/`, Atena should propose migration and update references only after approval. Do not silently maintain both as canonical workspaces.

## Remote-model privacy

Local storage does not imply local inference. Before a remote LLM receives sensitive or restricted project material, show the exact files or excerpts, provider, purpose, and sensitivity level. Record approval in the run evidence.

Suggested modes:

- `local-only`: no project content sent to remote providers.
- `review-before-remote`: show each context package for approval.
- `scoped-remote-context`: send only approved, task-relevant non-sensitive context and record a transfer manifest.

## Guided ADD and Direct Execution

Guided ADD is the default structured process when the user explicitly addresses Atena. Direct Execution is an intentional fast path for direct implementation requests that do not address Atena.

Direct Execution may bypass the pre-implementation spec and plan, but it does not bypass destructive, security, privacy, credential, publication, remote-context, dependency, or project-specific mandatory gates.

A direct change should be followed by an offer to reconcile it into ADD. If reconciliation occurs after implementation, its spec must be marked `post-hoc`.

## Draft-first and operational writing

Atena may create drafts automatically when they directly result from a Guided ADD request. Before approval, draft specs and plans are working artifacts, not authorization.

After a planned change is approved, Atena may update canonical operational facts that directly result from that spec: status, validation results, changed-file references, and evidence links.

It must not silently change canonical intent: vision, product rules, requirements, material architecture, security decisions, or established lore. Those changes require a visible proposal and explicit approval.

## Plan state

`.atena/state/plan.yaml` is local operational state for an active plan, cursor, suspension, and deferred requests. It is persistent enough to recover from a conversation interruption, but it is not a canonical record, approval record, or substitute for evidence. State transitions must preserve the prior plan until a user-approved revision replaces it.

Every plan independently selects its approval mode. A project may require that selection through `autonomy.approval_selection: required-per-plan`, but it must not silently inherit a prior plan's mode. The persisted active-plan checkpoint is operational state; the user approval that satisfies it remains recorded in the plan and evidence.

## Truthful post-hoc records

Post-hoc reconciliation must derive from observable implementation and evidence. It must not imply that a plan, decision, review, or approval happened before implementation when it did not.

Required post-hoc markers:

```yaml
origin: post-hoc
implementation_preceded_spec: true
```

A reconstructed `plan.md` describes the implementation map and current rationale; it is not a retroactive plan-of-flight approval.

## Evidence and research

Research lives outside canon until reviewed. Important claims record a source, date, confidence, and status. Use `hypothesis`, `candidate`, `canonical`, and `deprecated` for knowledge maturity where applicable.

Prefer repository/runtime evidence for current implementation state. Use conversation as intent/context, not as a substitute for available project evidence.

## Architecture policy

Prefer minimum sufficient architecture and reuse before creation. A new service, datastore, framework, abstraction, agent, or dependency should have a concrete requirement or project-level benefit, not only hypothetical future value.

## Git and publishing

Before a commit or push, check staged scope, secrets, personal data, draft-only content, and generated files. A plan of flight may allow automatic local commits on an isolated run branch. Project policy may separately allow ordinary direct local commits.

Always ask for the destination and explicit approval before merging, pushing, deploying, releasing, or publishing.

## Dependencies

The default policy is `allowlist-with-plan`. Atena may install a project-local dependency during Guided ADD only if it is already allowlisted and named by the approved plan of flight.

A new dependency requires review. Direct Execution does not turn a new dependency into an implicitly approved dependency. Global installation always requires approval.

## RTK

RTK is an optional optimization, not an ADD dependency. On the first Atena interaction in a project, check it unless `.atena/add.yaml` already records a user decision.

Use:

```bash
rtk --version
rtk gain
```

Only treat RTK as correctly detected when `rtk gain` succeeds. If absent, explain its token-output compression briefly and offer configuration. Do not install or globally configure it without authorization.

## Skills and agents

Record a skill opportunity after two similar procedures. Propose a skill after three with concrete examples, expected benefit, scope, permissions, alternatives, and validation. Do not create it without approval unless project policy explicitly allows it.

Agents and multi-agents follow the same principle: recommend only when bounded delivery or independent parallelism is demonstrable.

## Graph policy

Generate graph nodes and typed links from approved IDs and relations. Validation must flag broken links, duplicate IDs, unknown relation types, and planned specs lacking acceptance criteria. Do not let an inferred graph relation become canonical automatically.

## Explicit content maturity

DRAFT means proposed or experimental content without canonical authority. Experimental-use approval identifies revision, bounded purpose and limits and does not promote it. CANON means explicitly approved durable intent in vault/canon, with approval evidence. A plan approval can cover a named promotion; no second approval is needed for content it already authorizes. Partial approval promotes only the identified portion.

Show transitions explicitly: “DRAFT revisão N; autorizado apenas para teste X” or “CANON revisão N; conteúdo Y aprovado; implementação pendente/realizada; verificação Z”. Record who approved, content/revision, source and actual operational result. Canon placement alone, a successful test, a specialist's recommendation or conversation repetition never proves promotion. Historical drafts/research remain historical and cannot silently supersede canon.
