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
