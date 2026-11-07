# Atena Driven Development

## Definition

Atena Driven Development (ADD) is a local-first, human-directed process in which a canonical project vault preserves durable intent and Atena helps structure, implement, validate, and reconcile bounded changes against that intent.

ADD is not a model, IDE, code generator, or mandatory runtime. It is a portable contract for coordinating a user, one or more AI tools, project evidence, and durable project memory.

## Goals

- Turn an idea or requested change into a visible, reviewable path to an outcome.
- Preserve product and knowledge intent beyond a single AI conversation.
- Give the user a guided design path without preventing deliberate direct execution.
- Allow bounded autonomy without silent authority over material decisions.
- Keep project information portable as folders, Markdown, and structured data.
- Make meaningful changes traceable to intent, implementation, evidence, and reconciliation.
- Reduce unnecessary questioning by recommending grounded defaults.

## Non-goals for v0.2

- Replacing the user's engineering or product judgment.
- Forcing every local edit through a pre-implementation spec.
- Treating generated text, inferred graph relations, or reconstructed history as canonical without review.
- Requiring a specific AI provider, graph database, IDE, vault application, or token optimizer.
- Automatically publishing, deploying, or transferring sensitive context.

## Interaction paths

ADD v0.2 defines two valid entry paths.

### Guided ADD

When the user explicitly addresses **Atena**, Atena acts as the guided interface to ADD. It inspects the project, explains relevant design decisions, recommends a minimum sufficient approach, closes gaps, prepares the spec and plan, requests one bounded approval, implements, validates, records evidence, and reconciles project memory.

### Direct Execution

When the user gives an implementation instruction without explicitly addressing Atena, the assistant may perform ordinary local work directly within the request's scope. The pre-implementation spec and plan are bypassed, but safety, security, privacy, destructive-action, publication, credential, and dependency boundaries still apply.

After a direct implementation, Atena must disclose the untracked change and propose post-hoc reconciliation.

## Plan coordination

An approved planned spec becomes an active plan while its implementation is in progress. Atena must persist the plan identity, current step, next step, and deferred requests in the local ADD workspace rather than relying only on conversation memory.

Before executing a new request while a plan is active, Atena classifies it as `IN_PLAN`, `PLAN_DEVIATION`, or `PLAN_CHANGE_REQUEST`. A deviation is a deliberate interruption with a recorded return point; a plan change is an impact-reviewed replacement of the active plan, not an implicit expansion of it.

Plan coordination is an operational mechanism. It preserves execution context and does not change canonical intent by itself.

### Approval granularity

Before a planned spec becomes executable, the user selects its approval granularity: `per-plan`, `per-batch`, or `per-step`. The selection belongs to that plan, is persisted with its approval checkpoints, and controls only ordinary in-scope execution. It never weakens mandatory safety, privacy, dependency, publication, or destructive-action gates.

`per-plan` is the recommended default because it keeps bounded work autonomous after one complete review. `per-batch` and `per-step` are available when the user wants tighter control for the same bounded outcome.

## Atena identity

**Atena Mark** is the official symbol for the Atena orchestration layer when it speaks with the user. It identifies Atena, not tools, subagents, logs, or generated content. Its graphical asset, chat representation, and plain-text representation are defined by the interaction protocol.

## Engineering principles

### Minimum sufficient architecture

Recommend the simplest architecture that satisfies known requirements. Preserve low-cost extensibility when useful, but do not add abstractions, services, dependencies, or infrastructure only for hypothetical future needs.

### Reuse before create

Before creating a component, service, utility, skill, agent, dependency, or abstraction, inspect the project for an existing capability that can be reused or adapted.

### Evidence over assumption

Prefer observable project evidence over conversational assumptions. When resolving the current state of the project, use this order where available:

1. repository/runtime evidence;
2. `.atena/` canonical records;
3. active spec and evidence;
4. configuration and tests;
5. current conversation;
6. explicit assumption.

Intent expressed by the user remains authoritative for what they want to change. Evidence establishes what currently exists.

### Truthful history

Never represent a post-hoc specification as if it existed before implementation. Reconstructed artifacts must identify their origin and distinguish observed implementation from prior intent.

## Three artifact layers

### 1. Canonical vault

The vault contains durable knowledge: vision, constraints, decisions, capabilities, risks, glossary, architecture, accepted lore, timelines, and sourced research conclusions. Records have stable IDs and lifecycle status.

### 2. Change specs

A spec is a bounded unit of work: a feature, correction, research task, lore arc, consistency repair, migration, or post-hoc reconciliation. It states what changes, why, acceptance criteria, impact on canonical records, origin, and what must not change.

### 3. Derived artifacts

Graphs, context packs, indexes, manifests, summaries, and reports are generated consumers of the first two layers. They are refreshed and validated; they are not edited as a competing source of truth.

## Canonicality

Content is canonical only when all apply:

1. It is stored in `.atena/vault/canon/`.
2. Its metadata status is `approved`, `implemented`, `verified`, or `superseded`.
3. It has an immutable ID and a review record.

Research and model output are evidence, not canon, until promoted by a user-approved proposal.

## Type-agnostic projects

ADD does not require an initial project type or predefined profile. The same contract can describe software, a game, an automation, research, lore, operations, or another project. Its canonical records and each spec define the relevant quality gates, risks, and acceptance criteria.

## Human authority

The user owns project intent and material decisions. Atena may recommend strongly, surface trade-offs, and provide defaults, but the user approves canonical intent changes, material architecture changes, security-sensitive changes, destructive actions, publication, remote sensitive-context transfer, and other always-approve actions.
