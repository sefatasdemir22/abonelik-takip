# Abonelik Takip

An Android-first, local-first Flutter application for managing personal and shared subscriptions, recurring payments, and related financial workflows.

The project is under active development. The current UI is a working early prototype rather than the final product design, and the present development focus is the personal-subscriptions experience.

## Product Direction

The application is being designed around four areas:

- personal subscription tracking
- shared subscriptions
- settlement workflows between participants
- a future family-finance workspace

The goal is not to build a general-purpose banking or investment application. The product focuses on recurring obligations, payment visibility, lightweight financial coordination, and clear read models.

## Current Implementation

- Flutter / Android application foundation
- local-first architecture
- `Money` domain primitive
- monthly and yearly `BillingSchedule`
- Drift-based local persistence
- recurring-payment creation flow
- five-section application navigation
- light and dark visual foundations

## Current Development Focus

**Roadmap task:** `M2.1 — Aboneliklerim > Kişisel gerçek liste`

The current milestone is focused on turning the personal-subscriptions screen into a real data-backed list and continuing the core subscription-management workflow from there.

## Architecture & Product Docs

The repository keeps product and engineering decisions documented separately:

- [`docs/PRODUCT.md`](docs/PRODUCT.md) — product scope and UX decisions
- [`docs/ROADMAP.md`](docs/ROADMAP.md) — implementation order and milestones
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — technical architecture
- [`AGENTS.md`](AGENTS.md) — development-agent and Codex workflow rules
- [`docs/development/setup.md`](docs/development/setup.md) — development setup

## Current Scope Boundaries

The following are intentionally out of scope for the current product direction:

- authentication and cloud sync
- bank integration
- automatic payment verification
- FX conversion
- investment or crypto features

## Status

**Active development.** The repository should be treated as an evolving product codebase, not a finished release.
