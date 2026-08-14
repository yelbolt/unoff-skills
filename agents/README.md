# Unoff Agents

Agent definitions for the unoff plugin architecture, in a **neutral format**.
This directory is the single source of truth: both the
[Claude Code plugin](https://github.com/yelbolt/unoff-claude-plugin) and
[`@unoff/cli`](https://github.com/yelbolt/unoff-cli) (`unoff add agents`) read
from here and emit the format each assistant expects.

## The agents

| Agent                        | Layers                                  | Owns                                                                        |
| ---------------------------- | --------------------------------------- | --------------------------------------------------------------------------- |
| `unoff-plugin-architect`     | all                                     | Resolves the target platform, decomposes and sequences work by layer         |
| `unoff-canvas-bridge`        | `canvas`, `bridge`                      | Canvas APIs, storage, document generation, UI↔Canvas messaging               |
| `unoff-ui`                   | `ui`                                    | Preact components, `@unoff/ui`, Nanostores, theming, Tolgee, a11y            |
| `unoff-platform-services`    | `config`, `externals`                   | Config, Vite, feature flags, credits, external services, payments            |
| `unoff-conformance-reviewer` | all                                     | Quality gate — conventions, message contracts, platform parity, build        |

## How they run

The architect **fixes the message contract before delegating** — every `type`,
its payload shape, its direction, and the union members to add in
`src/app/types/`. That is what removes the need for specialists to negotiate
with each other, so `unoff-canvas-bridge`, `unoff-ui` and
`unoff-platform-services` run **concurrently** on disjoint paths. Serialize only
on a real data dependency.

`unoff-conformance-reviewer` runs last, scoped to the layers the diff actually
touches, and runs its mechanical greps before reading any code.

## Context loading

Every agent loads **`unoff-create-plugin/core.md` first** — the single source of
truth for stack facts, the architecture, the 4-point message contract, and the
Figma/Penpot differences table. No skill file, agent, or rules file restates
those; they link to it.

Beyond that, agents load only the rows they need from
[`unoff-create-plugin/SKILL.md`](../unoff-create-plugin/SKILL.md), which is a
pure routing index. Large references (`ui/component-library.md`,
`externals/implement-design.md`) are **entry files that route on to detail
files** — so the index never has to know the detail filenames, and an agent
targeting one platform never loads the other's workflow.

Short guardrails are deliberately repeated inline in the agent prompts: a system
prompt is loaded once and cached, whereas reading `core.md` costs a tool call.
The rule is inline guardrails, on-demand tables.

## Frontmatter

```yaml
---
name: unoff-ui # invocation name, kebab-case
description: ... # when to invoke — the routing signal
layers: [ui] # architecture layers this agent owns
model: sonnet # preferred capability tier
effort: high # Claude Code only
maxTurns: 30 # Claude Code only
---
```

`layers` uses the **same vocabulary as functional specs** (`canvas`, `bridge`,
`ui`, `config`, `externals`). That is what ties the three pieces together: a
spec declares the layers it touches, the skill library is organised by layer,
and each agent owns a set of layers. Given a spec, an assistant can resolve both
which docs to read and which agent should do the work.

## Emitted formats

| Target             | Path                             | Notes                                            |
| ------------------ | -------------------------------- | ------------------------------------------------ |
| Claude Code        | `.claude/agents/<name>.md`       | Full frontmatter, including `effort` / `maxTurns` |
| GitHub Copilot     | `.github/agents/<name>.agent.md` | `name` + `description` only                      |
| Cursor / Windsurf  | rules files                      | No agent concept — folded into the rules          |
| ChatGPT / Codex    | `AGENTS.md`                      | No agent concept — listed as a routing section    |

Cursor, Windsurf and Codex have no file-based agent primitive. Rather than
pretend otherwise, the CLI degrades them into a routing section inside the
rules file each one already reads.

## Editing

Edit the files here, then propagate:

```bash
# Claude Code plugin
npx skills add yelbolt/unoff-skills

# A plugin project
unoff add agents
```
