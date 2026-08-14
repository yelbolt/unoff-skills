[![skills.sh](https://skills.sh/b/yelbolt/unoff-skills)](https://skills.sh/yelbolt/unoff-skills)

# Unoff Skills

Documentation and agent definitions for the **unoff** plugin architecture,
organised by responsibility layer. Currently targeting **Figma** and **Penpot** —
**Framer** and **Sketch** support is coming.

This library is written to be read by coding agents, so it is built around a
token budget: an agent should load the one file that answers its question, not a
layer. Three rules keep that true, and `scripts/check-skills.sh` enforces them.

## The three rules

1. **`core.md` is the single source of truth.** Stack facts, the architecture,
   the 4-point message contract, and the Figma/Penpot differences table live
   there and nowhere else. Every other file links to it.
2. **Large references are entry files that route on.** `ui/component-library.md`
   and `externals/implement-design.md` are small indexes pointing at detail
   files, so a Figma task never loads the Penpot workflow and a form question
   never loads the whole component reference.
3. **`SKILL.md` is a pure routing index.** It maps a task to one file. It does
   not know detail filenames, so splitting a file never touches it.

The exception is `agents/` and `rules/`: those are the always-on layer, loaded
once and cached, where short inline guardrails are cheaper than a file read.

## Structure

```
unoff-create-plugin/
├── core.md              # ← load first. Single source of truth.
├── SKILL.md             # ← routing index. Load one row, not a layer.
├── canvas/              # Canvas API (platform-specific)
│   ├── figma/           #   canvas-api, data-storage, document-generation
│   └── penpot/          #   canvas-api, data-storage, document-generation
├── bridge/              # UI ↔ Canvas messaging (platform-specific)
│   ├── figma/           #   communication-pattern, bridge-functions
│   └── penpot/          #   communication-pattern, bridge-functions
├── config/              # Configuration & build (shared)
│   └── global-config, feature-flags, credits-system, vite-build, code-quality
├── ui/                  # Preact application layer (shared)
│   ├── component-library.md   # entry → routes to components/
│   ├── components/            #   actions, forms, layout, feedback, css-classes
│   └── component-mapping, component-patterns, state-management, types-system,
│       i18n, css-theming, error-handling, accessibility, performance,
│       app-bootstrap, external-services
└── externals/           # External integrations (shared)
    ├── implement-design.md    # entry → routes to design/
    ├── design/                #   figma-workflow, penpot-workflow
    └── payment-systems.md

agents/                  # Agent definitions (neutral format — see agents/README.md)
rules/                   # Per-project rules template emitted by @unoff/cli
scripts/check-skills.sh  # Enforces the three rules above
```

## Layers

| Layer         | Scope                                                | Platform-specific |
| ------------- | ---------------------------------------------------- | ----------------- |
| **Canvas**    | `figma.*` / `penpot.*`, nodes and shapes, storage, document generation | Yes  |
| **Bridge**    | Message passing, `loadUI.ts` action map, bridge functions | Yes           |
| **Config**    | `global.config.ts`, feature flags, credits, Vite build, quality gates | No |
| **UI**        | Preact components, `@unoff/ui`, Nanostores, theming, Tolgee, a11y | No   |
| **Externals** | Supabase, Sentry, Mixpanel, Tolgee, payments, design implementation | Mostly |

For which file answers which question, see
[`unoff-create-plugin/SKILL.md`](./unoff-create-plugin/SKILL.md). It is the only
place that mapping is maintained — this README deliberately does not duplicate it.

## Platform differences

Figma and Penpot diverge in the Canvas and Bridge layers; UI, Config and
Externals are shared. The authoritative comparison table is in
[`unoff-create-plugin/core.md`](./unoff-create-plugin/core.md).

The one worth memorising: **Penpot storage is synchronous and string-only**
(`penpot.localStorage`), where Figma's is asynchronous and typed
(`figma.clientStorage`). It is the most frequent porting bug.

## Agents

Five agents cover the layers above, defined in a neutral format under
[`agents/`](./agents/) and emitted per-assistant by
[`@unoff/cli`](https://github.com/yelbolt/unoff-cli) and the
[Claude Code plugin](https://github.com/yelbolt/unoff-claude-plugin).

`unoff-plugin-architect` fixes the message contract up front, then delegates to
`unoff-canvas-bridge`, `unoff-ui` and `unoff-platform-services` — which run
concurrently on disjoint paths — before `unoff-conformance-reviewer` gates the
diff. See [`agents/README.md`](./agents/README.md).

## Contributing

Run the checker before opening a PR:

```bash
scripts/check-skills.sh
```

It fails on content that restates `core.md` and on broken relative links, and
warns when a file has grown past the point where it should route to detail files.

When adding documentation:

- Put the rule in `core.md` **or** in a layer file — never both.
- Add a row to `SKILL.md` only for a new top-level entry file; detail files are
  routed from their entry, not from the index.
- Keep code examples and API signatures. They are the payload. Cut prose that
  restates an adjacent example.

## AI agent compatibility

Consumed by Claude (VS Code, Cursor, Windsurf, Warp), GitHub Copilot, and any
agent that can read Markdown. `agents/` degrades gracefully: assistants without
a file-based agent primitive get a routing section folded into their rules file
instead.
