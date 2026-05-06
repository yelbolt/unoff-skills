---
name: unoff-create-plugin
description: "Master index for the unoff plugin skill library. Use when building, debugging, or extending a Figma or Penpot plugin with React UI, Canvas bridge, @unoff/ui components, Supabase, Tolgee, Sentry, Mixpanel, Vite build, TypeScript, credits, feature flags, payments, or design implementation. Covers all layers: Canvas, Bridge, UI, Config, and Externals. Platform-specific skills are in bridge/figma/, bridge/penpot/, canvas/figma/, canvas/penpot/. UI, Config, and Externals are shared across platforms."
---

# Unoff Plugin Skills

## Overview

This collection covers every layer of the **unoff plugin** architecture for both **Figma** and **Penpot**. Each sub-skill is a self-contained reference document providing patterns, templates, and decision rules for a specific concern.

**How to use these skills**: when a task falls within a domain below, load the corresponding file with `read_file` before writing or reviewing code. For platform-specific layers (Bridge, Canvas), always load the file matching the target platform.

---

## Bridge

Inter-layer communication between the React UI and the Canvas. **Platform-specific** — load the correct subdirectory.

| Skill                                                                                  | Platform | When to load                                                                                        |
| -------------------------------------------------------------------------------------- | -------- | --------------------------------------------------------------------------------------------------- |
| [bridge/figma/bridge-functions.md](./bridge/figma/bridge-functions.md)                | Figma    | Creating bridge functions, implementing canvas operations called from `loadUI.ts` on Figma          |
| [bridge/figma/communication-pattern.md](./bridge/figma/communication-pattern.md)      | Figma    | Wiring new actions, debugging UI↔Canvas communication, understanding the `onmessage` pattern        |
| [bridge/penpot/bridge-functions.md](./bridge/penpot/bridge-functions.md)              | Penpot   | Creating bridge functions, implementing canvas operations called from `loadUI.ts` on Penpot         |
| [bridge/penpot/communication-pattern.md](./bridge/penpot/communication-pattern.md)    | Penpot   | Wiring new actions, debugging UI↔Canvas communication, understanding the `onMessage` pattern        |

---

## Canvas

Canvas API usage and data persistence. **Platform-specific** — load the correct subdirectory.

| Skill                                                                                      | Platform | When to load                                                                                          |
| ------------------------------------------------------------------------------------------ | -------- | ----------------------------------------------------------------------------------------------------- |
| [canvas/figma/canvas-api.md](./canvas/figma/canvas-api.md)                                | Figma    | Writing Canvas-layer code via `figma.*`: node creation, styles, variables, selection, viewport        |
| [canvas/figma/data-storage.md](./canvas/figma/data-storage.md)                            | Figma    | Persisting node metadata (Plugin Data), cross-plugin data (Shared Plugin Data), or user prefs        |
| [canvas/figma/document-generation.md](./canvas/figma/document-generation.md)              | Figma    | Generating structured output using `Tag`, `Paragraph`, `Signature` from `src/canvas/` on Figma       |
| [canvas/penpot/canvas-api.md](./canvas/penpot/canvas-api.md)                              | Penpot   | Writing Canvas-layer code via `penpot.*`: boards, shapes, flex layout, fills, selection, viewport     |
| [canvas/penpot/data-storage.md](./canvas/penpot/data-storage.md)                          | Penpot   | Persisting all plugin state via `penpot.localStorage` (the only storage mechanism in Penpot)         |
| [canvas/penpot/document-generation.md](./canvas/penpot/document-generation.md)            | Penpot   | Generating structured output using `Tag`, `Paragraph`, `Signature` from `src/canvas/` on Penpot      |

---

## Config

Build pipeline, runtime configuration, code quality, and system-level concerns. Shared across platforms.

| Skill                                                  | When to load                                                                                                                                                  |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [config/global-config.md](./config/global-config.md)   | Adding new config values, understanding what is available via `ConfigContext`, or wiring environment variables                                                |
| [config/feature-flags.md](./config/feature-flags.md)   | Adding new features, gating by plan tier, restricting to specific editors (Figma: FigJam/Dev Mode) or services, or overriding feature state for testing       |
| [config/credits-system.md](./config/credits-system.md) | Adding feature usage limits, wiring a feature to a credit gate, or implementing the `isReached → isBlocked` pattern                                           |
| [config/vite-build.md](./config/vite-build.md)         | Modifying the build pipeline, adding Vite plugins, adding env vars, or understanding how platform-specific CSS is excluded from the bundle at build time      |
| [config/code-quality.md](./config/code-quality.md)     | Configuring linting rules, writing Vitest tests for Canvas or UI layers, or setting up CI/CD quality gates                                                    |

---

## Externals

Third-party integrations and design-to-code workflows. Shared across platforms except Option A of payment-systems.

| Skill                                                            | When to load                                                                                                                                        |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| [externals/implement-design.md](./externals/implement-design.md) | Implementing UI from a design spec — Figma (URL + `get_design_context` MCP tools) or Penpot (selection + code execution via `@penpot/mcp`) — or building components with 1:1 visual fidelity |
| [externals/payment-systems.md](./externals/payment-systems.md)   | Choosing a payment model — Option A (`figma.payments`, Figma only) or Option B (Lemon Squeezy license keys, cross-platform)                       |

---

## UI

All concerns for the React UI layer. Shared across platforms except where noted.

| Skill                                                  | When to load                                                                                                                                                        |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [ui/app-bootstrap.md](./ui/app-bootstrap.md)           | Modifying initialization order, adding a service to the startup chain, or debugging startup failures — Canvas init is platform-specific (Figma vs Penpot)           |
| [ui/component-library.md](./ui/component-library.md)   | Building UI, choosing the right `@unoff/ui` component, or understanding the `FeatureStatus` / `isBlocked` permission pattern                                        |
| [ui/component-mapping.md](./ui/component-mapping.md)   | Looking up which npm export matches a UI component spec, navigating Storybook, or translating a design spec into code imports                                       |
| [ui/component-patterns.md](./ui/component-patterns.md) | Writing new UI components, composing `WithConfig` / `WithTranslation` HOCs, or handling Canvas→UI messages in a component                                           |
| [ui/css-theming.md](./ui/css-theming.md)               | Styling components, handling light/dark mode via `data-theme` / `data-mode`, managing z-index — window resize is Figma-only (Penpot: fixed size)                    |
| [ui/state-management.md](./ui/state-management.md)     | Adding Nanostore atoms, managing user preferences across sessions, or syncing state between Canvas and UI                                                           |
| [ui/external-services.md](./ui/external-services.md)   | Integrating or configuring Supabase, Sentry, Mixpanel, Tolgee, or the Notion CMS Cloudflare Worker                                                                  |
| [ui/i18n.md](./ui/i18n.md)                             | Adding translations, supporting new languages, or persisting language preference — Canvas storage differs per platform (figma.clientStorage vs penpot.localStorage) |
| [ui/error-handling.md](./ui/error-handling.md)         | Handling errors in bridge functions, external service calls, or surfacing errors via `POST_MESSAGE` / Sentry — Canvas action examples have platform variants        |
| [ui/accessibility.md](./ui/accessibility.md)           | Building modal dialogs, toasts, interactive components, reviewing a11y, or understanding focus trapping / portal layering                                           |
| [ui/performance.md](./ui/performance.md)               | Optimizing render cycles, reducing bundle size, or improving startup time                                                                                           |
| [ui/types-system.md](./ui/types-system.md)             | Adding new types, extending `BaseProps`, defining union types for state machines, or adding new contexts, modals, events, or languages                              |

---

## Architecture Quick Reference

```
src/
├── index.ts              # Canvas entry — action map, bridge dispatch
├── global.config.ts      # Central config (see config/global-config)
├── bridges/              # Canvas operations (see bridge/<platform>/)
│   └── loadUI.ts         # Message router — Figma: figma.ui.onmessage / Penpot: penpot.ui.onMessage
├── app/
│   ├── index.tsx         # UI entry — providers, bootstrap (see ui/app-bootstrap)
│   │                     # Penpot: includes platformMessage/pluginMessage proxy
│   ├── components/       # React UI components (see ui/)
│   ├── stores/           # Nanostore atoms (see ui/state-management)
│   ├── services/         # External service singletons (see ui/external-services)
│   └── types/            # TypeScript definitions (see ui/types-system)
└── canvas/               # Canvas API helpers (see canvas/<platform>/)
```

**Canvas side** → `src/index.ts` + `src/bridges/`  
**UI side** → `src/app/index.tsx` + `src/app/`  
**Shared** → `src/global.config.ts` + `src/app/types/`

### Platform differences at a glance

| Concern           | Figma                                    | Penpot                                          |
| ----------------- | ---------------------------------------- | ----------------------------------------------- |
| Open UI           | `figma.showUI(__html__, { ... })`        | `penpot.ui.open(title, url, { ... })`           |
| Canvas → UI       | `figma.ui.postMessage({ type, data })`   | `penpot.ui.sendMessage({ type, data })`         |
| UI → Canvas       | `parent.postMessage({ pluginMessage })` | dispatch `pluginMessage` CustomEvent (proxy)    |
| Receive in Canvas | `figma.ui.onmessage = (msg) => ...`      | `penpot.ui.onMessage((msg) => ...)` + `msg.pluginMessage` |
| Receive in UI     | `event.data.pluginMessage`               | `(event as CustomEvent).detail` on `platformMessage` |
| Storage           | `figma.clientStorage` (async, typed)     | `penpot.localStorage` (sync, string-only)       |
| Resize            | `figma.ui.resize(w, h)`                  | Not supported — fixed at open time              |
| Open external URL | `figma.openExternal(url)`                | Re-send to UI, handle in browser via `OPEN_IN_BROWSER` |
| Theme             | CSS vars via `themeColors: true`         | `penpot.theme` + `SET_THEME` message            |
| Current user      | `figma.currentUser?.photoUrl`            | `penpot.currentUser.avatarUrl`                  |
