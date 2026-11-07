# ADD workflow

## Entry classification

Every request begins by determining the interaction path defined in [INTERACTION.md](INTERACTION.md):

```text
request
  -> explicit Atena address -> Guided ADD
  -> otherwise              -> Direct Execution
```

A mention of the word `Atena` as content does not by itself activate Guided ADD.

## Guided ADD lifecycle

1. **Bootstrap**: locate `.atena/`, detect legacy `atena/`, load minimum relevant context, and perform the one-time RTK check when applicable.
2. **Understand**: restate the intended outcome and preserve decisions already made by the user.
3. **Inspect**: gather repository, runtime, canonical, configuration, and test evidence relevant to the change.
4. **Recommend**: propose the minimum sufficient architecture/process, prefer reuse, explain material trade-offs, and provide defaults.
5. **Specify**: prepare or update the bounded spec, non-goals, decisions, impact, and acceptance criteria.
6. **Resolve gaps**: classify gaps as `BLOCKING`, `RESOLVABLE`, or `DEFERRED`; eliminate all blocking gaps.
7. **Plan**: produce tasks, expected file/system changes, validation, evidence, limits, recovery approach, and stable batches where relevant.
8. **Select approval mode**: ask the user to choose `per-plan`, `per-batch`, or `per-step`; a plan remains non-executable while the selection is `unconfigured`.
9. **Approve the checkpoint**: present the complete plan of flight or the next defined batch/step according to the selected mode. Record the approved checkpoint and plan revision.
10. **Activate the plan cursor**: create or update this chat's `.atena/state/conversations/<key>/plan.yaml` with the conversation binding and active plan, approval checkpoint, current step, next step, and an empty suspension before implementation begins.
11. **Execute autonomously**: perform only work inside the approved checkpoint under the selected autonomy profile; pause for the next checkpoint, a stop condition, or an always-approve action.
12. **Verify**: collect test results, observations, changed files, visual evidence where applicable, and unresolved items.
13. **Record evidence**: preserve enough evidence to demonstrate acceptance without relying on model confidence alone.
14. **Reconcile**: update permitted operational facts, propose material canonical changes, regenerate derived artifacts, and clear the active plan only after its terminal result is recorded.

## Optional game creation path

For a confirmed game creation path, follow [GAMES.md](GAMES.md) within the existing Guided ADD lifecycle. Interview adaptively, establish vision/design and feasible scope, build the initial visual bible, and define the first prototype and playtest objectives. Recommend engine, tools, dependencies, and architecture last in the initial definition, using all relevant decisions as evidence.

Always present prototype readiness and its main pending items before implementation, refreshing the report after technical recommendations. Resolve all BLOCKING gaps and honor the selected approval checkpoint; state explicitly when no main pending items remain. Keep intentionally deferred details visible without treating them as blockers for unrelated hypotheses.

For each milestone, define what every playtest should test before it starts and record actual results afterward. Separate technical verification from player feedback. Human feedback is required to demonstrate subjective acceptance criteria; a pending playtest blocks advancement when required for milestone acceptance or the next decision. Preserve other pending feedback and document any explicitly accepted exception.

Vision, mechanics, lore, and visual direction stay in drafts until explicit approval identifies the content/revision promoted to canon. Use ordinary ADD specs and evidence for prototype, vertical slice when useful, content, polish, and release milestones.

## Active-plan request handling

Before executing a new request, resolve the plan belonging to this same chat under the [conversation ownership contract](CONTRACT.md#conversation-ownership-and-persistent-state). Classify only against that plan. Plans from other chats and unbound legacy state do not trigger sequencing questions, suspension, deferral or cursor replacement here. Persist each conversation independently; preserve legacy state and coordinate actual shared-file/resource conflicts. Resume across chats only on explicit request with identified plan/checkpoint and coordinated handoff.

```text
new request
  -> IN_PLAN              -> execute current-plan work
  -> PLAN_DEVIATION       -> Plan Deviation Gate
  -> PLAN_CHANGE_REQUEST  -> impact analysis and revised-plan approval
```

For route A of a deviation, save the cursor in `suspension`, mark the active plan `SUSPENDED`, perform the parallel work, restore the cursor, return the plan to `ACTIVE`, announce the return to the plan, and continue. For route B, record a `DEV-XXX` pending request and continue the current step. A deferred request is visible work, not an automatically scheduled execution.

For a plan change request, preserve the prior plan and its cursor until the revised plan has been approved. Update plan state only after that approval; do not represent an unapproved replacement as active.

## Direct Execution lifecycle

1. **Understand the direct instruction** and bound it to the work explicitly requested.
2. **Inspect enough context** to avoid breaking existing conventions or reimplementing an existing capability.
3. **Execute ordinary local work** without requiring a pre-implementation ADD spec or plan approval.
4. **Respect mandatory gates** for destructive, security-sensitive, credential, privacy, publication, remote-context, dependency, and project-specific restricted actions.
5. **Validate** the resulting implementation using appropriate project checks.
6. **Disclose untracked ADD state**: state that implementation preceded the ADD spec.
7. **Offer post-hoc reconciliation**.
8. **If authorized, reconstruct truthfully** from implementation and evidence using `origin: post-hoc`.

## Spec readiness

A planned spec may reach `ready-for-approval` only when:

```text
BLOCKING == 0
```

`RESOLVABLE` items must have a recorded default/decision. `DEFERRED` items must be visible, intentional, and outside the current acceptance criteria.

A planned spec is also not ready until its approval mode is explicit. `per-batch` plans define every `B-XXX` batch before execution; `per-step` plans use the stable `S-XXX` identifiers already present in the plan. A pending checkpoint blocks ordinary implementation even when the broader plan is approved.

## Required gates

| Gate | Required before | The user sees |
| --- | --- | --- |
| Initial canon / material intent change | Establishing or changing vision, business rules, architecture, security intent, or established lore | diff, evidence, relations, contradictions, impact |
| Plan approval checkpoint | Guided ADD bounded local execution | selected mode; relevant plan, batch, or step scope; acceptance, affected systems, tests, limits, recovery |
| Sensitive context | Sending sensitive or restricted project material to a remote model | exact context, recipient/provider, purpose, sensitivity |
| Destructive action | Delete, overwrite, reset, material migration, irreversible operation | targets, consequence, backup/recovery |
| Security-sensitive action | Authentication/authorization changes or weakening controls | behavior change, threat/impact summary, recovery |
| Publication | Git push, deploy, release, or other external sharing | destination, scope, secrets/privacy scan |

Direct Execution bypasses only the pre-implementation spec/plan gate. It does not bypass the other gates.

After a Guided ADD plan of flight is approved, normal in-scope code/content changes, validation, generated artifacts, evidence, and permitted operational vault updates do not create additional gates. See [AUTONOMY.md](AUTONOMY.md).

## Process recommendations

For a material process or architecture recommendation, use a compact form:

```text
Recommendation: <action>
Reason: <observable trigger/evidence>
Benefit: <expected outcome>
Scope: <what it may read/write/change>
Alternative: <viable alternative when material>
Default: <what Atena recommends using>
Approval needed: <yes/no and why>
```

### When to recommend a skill

Recommend a skill when a procedure is repeatable, stable, and useful across multiple specs. A skill is a documented workflow, not an extra model persona.

### When to recommend an agent

Recommend an agent for a bounded, specialist-like assignment with one owner, one deliverable, and an explicit read/write scope.

### When to recommend multi-agents

Recommend multiple agents only when work can be split into independent streams, outputs can be reconciled, and agents do not compete for the same artifacts. Name an integration owner. Otherwise use one agent.

## Completion rules

### Planned change

A planned change is complete only when:

- acceptance criteria are verified;
- evidence is recorded;
- changed canonical facts have an allowed operational update, an approved intent update, or an explicit no-update result;
- deferred items remain visible;
- derived artifacts required by the spec are refreshed.

### Direct change

A direct implementation may be operationally complete after validation, but it remains **ADD-unreconciled** until either:

- a post-hoc spec and reconciliation are completed; or
- the user explicitly declines reconciliation and that decision is recorded where project tooling supports it.

## Step handoff and maturity

Use the [visible progress contract](INTERACTION.md#visible-progress-and-prepared-continuation) throughout execution. Prepare each next step's objective, inputs, deliverable, checks and approval status before advancing. On the last step state that no planned steps remain and list truly deferred work separately. Persist state before advancing and reconcile evidence before clearing it.

Always label the referenced content as DRAFT or CANON with its revision. A draft accepted for a bounded prototype is still DRAFT. A canon promotion requires explicit approval of content/revision; identify the promoted portion and leave the rest draft. Report approved intent, implemented behavior and verified evidence as separate facts. See [maturity rules](POLICIES.md#explicit-content-maturity).


## Optional Marizverso coordination profile

Use the [coordination guide](AGENT-COORDINATION.md) for needs-based routing, specialist briefs, knowledge curation and proportional documentation. Portable sources do not install a runtime. Generic ADD does not require this profile. Copying this template alone does not adopt referenced files: resolve paths during adoption. Existing gates remain effective.

## Methodology update request

Use [update procedure](UPDATING.md) for "Atena, atualize-se para a versão mais recente" and "Atena, se atualize" (with or without a final period). Both express the same update-methodology flow. Quotation, code and discussion are not activation. Inspect the actual adopted version and configured authoritative source; compare local adaptations and scope; apply only valid approvals with backup/validation. Preserve canon, knowledge, state and local rules. Missing source/version blocks an actual update, not an invitation to invent a release. An active plan still requires request classification and sequencing.
