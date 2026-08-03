# {{pluginName}}

You are an expert {{platform}} plugin developer working on a TypeScript/Preact
project built on the unoff stack.

## Documentation

Architecture, conventions and platform APIs live in the skill library:

**[{{skillsPath}}/SKILL.md]({{skillsPath}}/SKILL.md)** — the index. Load the file
matching the layer you are working in before writing code.

| Layer         | Load from `{{skillsPath}}/`                                                                                                      |
| ------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **Canvas**    | `canvas/{{platformSlug}}/canvas-api.md`, `canvas/{{platformSlug}}/data-storage.md`, `canvas/{{platformSlug}}/document-generation.md` |
| **Bridge**    | `bridge/{{platformSlug}}/communication-pattern.md`, `bridge/{{platformSlug}}/bridge-functions.md`                                    |
| **Config**    | `config/global-config.md`, `config/feature-flags.md`, `config/credits-system.md`, `config/vite-build.md`, `config/code-quality.md` |
| **UI**        | `ui/component-library.md`, `ui/component-patterns.md`, `ui/state-management.md`, `ui/types-system.md`, `ui/i18n.md`, `ui/css-theming.md`, `ui/error-handling.md`, `ui/accessibility.md`, `ui/performance.md`, `ui/app-bootstrap.md`, `ui/external-services.md` |
| **Externals** | `externals/implement-design.md`, `externals/payment-systems.md`                                                                   |

Product behaviour — what this plugin does, as opposed to how it is built — lives
in `{{specsDir}}/`. See `{{specsDir}}/INDEX.md`.

## Stack facts

These are the most common source of broken implementations. Never contradict them.

- **Preact**, not React — import from `preact` / `preact/compat`. The 3-level
  alias (Vite, TSConfig, npm) exists only for third-party libraries.
- **Nanostores**, not Zustand/Redux — `atom` from `nanostores` +
  `@nanostores/preact`, `$prefix` convention.
- **PureComponent classes**, not function components with hooks — composed with
  the `WithConfig` and `WithTranslation` HOCs.
- **Tolgee** for UI strings (`@tolgee/react`) and `createI18n()` for Canvas —
  two distinct systems, never mixed.
- **Dual Vite build** — `IS_PLUGIN=true` emits the IIFE `plugin.js`; the default
  build emits a single HTML file.
- **`@unoff/ui` first** — look up the existing component before building one.

Which external services are enabled is declared in `src/global.config.ts` — read
it rather than assuming.

## Architecture

Two contexts that never mix:

1. **Canvas** (`src/index.ts`, `src/canvas/`, `src/bridges/`) — {{platform}} API
   access, no DOM, no authenticated network calls.
2. **UI** (`src/app/`) — Preact application, no direct {{platform}} API access.
3. **Bridge** — message passing between the two.

```
src/
├── index.ts              # Canvas entry — action map
├── global.config.ts      # Central config
├── bridges/
│   └── loadUI.ts         # Message router
├── app/
│   ├── index.tsx         # UI entry — providers, bootstrap
│   ├── components/
│   ├── stores/           # Nanostore atoms
│   ├── services/         # External service singletons
│   └── types/
└── canvas/               # Canvas API helpers
```

### Communication

{{#figma}}

```typescript
// UI → Canvas
parent.postMessage({ pluginMessage: { type: 'CREATE_NODE', data } }, '*')

// Canvas → UI
figma.ui.postMessage({ type: 'NODE_CREATED', data })

// Receive in Canvas
figma.ui.onmessage = (msg) => { ... }
```

Storage is `figma.clientStorage` — asynchronous and typed. Await it.
{{/figma}}
{{#penpot}}

```typescript
// UI → Canvas — dispatch a pluginMessage CustomEvent (proxy)
window.dispatchEvent(
  new CustomEvent('pluginMessage', { detail: { type: 'CREATE_SHAPE', data } })
)

// Canvas → UI
penpot.ui.sendMessage({ type: 'SHAPE_CREATED', data })

// Receive in Canvas
penpot.ui.onMessage((msg) => { ...msg.pluginMessage })
```

Storage is `penpot.localStorage` — **synchronous and string-only**. Serialize
before writing, and never await it. This is the most frequent porting bug.
{{/penpot}}

Message naming: UI → Canvas is `VERB_NOUN` (`CREATE_NODE`), Canvas → UI is
`NOUN_PAST_TENSE` (`NODE_CREATED`).

**A new action means four coordinated edits**: the type union in
`src/app/types/`, the Canvas handler in the action map, the bridge function, and
the routing entry in `loadUI.ts`. A missing one is a silent no-op.

## Rules

**Do**

- Keep Canvas and UI logic completely separate
- Reuse `@unoff/ui` components; use `FeatureStatus` / `isBlocked` for gating
- Type every message; extend the union before writing the component
- Await async Canvas APIs (`loadAllPagesAsync`, `loadFontAsync`, `getNodeByIdAsync`)
- Surface bridge errors via `POST_MESSAGE` + Sentry — never swallow them
- Put every user-facing string behind a Tolgee key

**Don't**

- Call the {{platform}} API from a Preact component, or import Preact in a bridge file
- Introduce hooks or `import React from 'react'` in application code
- Use `any`, or hardcode values that belong in `global.config.ts`
- Build a component that already exists in `@unoff/ui`

## Before declaring work done

- Both build outputs still work (`IS_PLUGIN=true` IIFE, and default single HTML)
- Lint and typecheck pass (`npm run lint`, `npm run typecheck`)
- Modals and interactive components keep focus trapping and keyboard access
- The relevant spec's **Acceptance criteria** are each satisfied
