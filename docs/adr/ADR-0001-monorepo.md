<!-- SPDX-License-Identifier: Apache-2.0 -->
# ADR-0001: One monorepo for three confidential-token tools

Date: 2026-11-24. Status: accepted.

**Context.** confidential-engine (Rust, Soroban contract + client), confidential-viewer (TypeScript CLI + web) and zk-diff-harness (Rust, verifier test bench) were built as separate projects of the Stellar Institutional Kit (kit ADR-0002: independent projects, no root workspace). They tell one story: two routes to confidential stablecoin payments on Stellar (the issuer-attested engine, and OpenZeppelin's `stellar-confidential` once its verifier is zero-knowledge and audited), plus the holder tooling both routes need and independent evidence on the verifier route B depends on. Apart, they duplicate the web design system, gate wording and SHA-256 / canonical JSON handling, the viewer cannot read engine tokens (M10), and two copies of OpenZeppelin's repository are checked out.

**Decision.** Merge them into one project, `confidential-stablecoin-kit`, in one public repository (`confidential-kit/confidential-stablecoin-kit`):

- Rust in one Cargo workspace (`crates/*`): engine crates (`sik-ce-*`, edition 2021, `todo = allow` with ticket ids) and harness crates (`sik-zkd-*`, edition 2024, `todo = deny`), each keeping its own edition and lint levels.
- The three verifier adapters (`adapters/*`) stay separate Cargo workspaces, each with its own lockfile, because they link soroban-sdk 26, 27 and 28 (harness decision D2).
- TypeScript in one pnpm workspace (`packages/*`, `web`): the viewer and the engine's testnet runner.
- One release profile for host binaries (unwind, overflow checks) and a `release-wasm` profile for the Soroban contract.
- One web console (`web/`).
- One check script (`scripts/check.sh`) run locally and in CI.

Consistent with kit ADR-0002 as amended (a project may be an intra-project workspace). Each crate and package keeps a published interface (CLI, library API, JSON Schema), so any one can be lifted out.

**Order.** Scaffold first (this ADR). Move each tool in unchanged with its checks green (M2, M4, M5). Fix the harness's published claim straight after it moves (M3). Remove duplicates one at a time, each as its own change.

**Consequences.** One install, one check command, cross-tool changes in one commit, one console. Larger clone; Rust builds carry several soroban-sdk versions across the main workspace and the adapters. All gates (G-ZK, G-CRYPTO, G-VALUE, G-LEGAL, G-OUTREACH, G-SECRETS) carry over unchanged.
