<!-- SPDX-License-Identifier: Apache-2.0 -->
# Migration map

Where each source project lands. Source paths are relative to `stellar-institutional-kit/projects/`. Status: `planned` until the move is done and the tool's checks pass here, then `done (M#)`.

**Never copied:** `target/` (engine 5.2 GB, harness 2.1 GB), `node_modules/`, `.cache/` and `.tools/` (they hold third-party git clones of OpenZeppelin `stellar-contracts` and the brozorec SDK), `.toolchain/` (147 MB of nargo/bb), `work/` (harness scratch, 32 MB), built `dist/`, per-tool `docs/screenshots/` (old per-tool UIs; the console gets new captures in M14).

## Layout rule

Code goes in `crates/` (Rust), `adapters/` (Rust, separate workspaces) or `packages/` (TypeScript). Everything else a tool owns goes under a folder named after the tool, so two tools never share a path:

| What | Where |
|---|---|
| fixtures and recorded runs | `fixtures/<tool>/` |
| published JSON Schemas | `schemas/<tool>/` |
| tool-level scripts | `scripts/<tool>/` |
| recorded reports | `reports/<tool>/` |
| SPEC, ARCHITECTURE, TASKS and the other project docs | `docs/<tool>/` |
| tool ADRs | `docs/<tool>/adr/` |
| outreach drafts (DRAFT, NOT SENT) | `drafts/<tool>/` |

Shared by the kit: `vectors/` (cross-language crypto test vectors, rule C8), `reference/` (the independent second implementation, rule C8), `work/<ticket>/` (ticket contracts, reviews, evidence).

Each move keeps the tool's recorded evidence byte-identical. Provenance files keep the script path that was true at capture time.

## zk-diff-harness (M2)

| Source | Target | Status |
|---|---|---|
| `zk-diff-harness/crates/zkd-{core,driver,verifiers,harness,report,cli}` | `crates/zkd-*` (crate names `sik-zkd-*` unchanged) | planned |
| `zk-diff-harness/adapters/{nethermind-main,nethermind-pr38,perch-zk,shared}` | `adapters/` (separate workspaces) | planned |
| `zk-diff-harness/pins/` | `pins/zk-diff-harness/` | planned |
| `zk-diff-harness/schemas/result-matrix.schema.json` | `schemas/zk-diff-harness/`; `crates/zkd-report` `include_str!` path rewritten | planned |
| `zk-diff-harness/fixtures/` | `fixtures/zk-diff-harness/`; `crates/zkd-driver/src/commands.rs` `CARGO_MANIFEST_DIR` path rewritten | planned |
| `zk-diff-harness/reports/` | `reports/zk-diff-harness/` (byte-identical) | planned |
| `zk-diff-harness/scripts/` | `scripts/zk-diff-harness/` | planned |
| `zk-diff-harness/drafts/` | `drafts/zk-diff-harness/` | planned |
| `zk-diff-harness/*.md`, `docs/` | `docs/zk-diff-harness/` | planned |
| `zk-diff-harness/web/` | merged into `web/` in M14; until then `web/` sections stay per tool | planned |

## confidential-engine (M4)

| Source | Target | Status |
|---|---|---|
| `confidential-engine/crates/sik-ce-{crypto,contract,client,testvectors,bench}` | `crates/ce-*` (crate names `sik-ce-*` unchanged) | planned |
| `confidential-engine/testnet/` | `packages/engine-testnet` (`@sik/engine-testnet`) | planned |
| `confidential-engine/data/` | `fixtures/confidential-engine/` (testnet run byte-identical) | planned |
| `confidential-engine/vectors/`, `schemas/`, `tools/` | `vectors/confidential-engine/`, `schemas/confidential-engine/`, `reference/confidential-engine/` | planned |
| `confidential-engine/scripts/` | `scripts/confidential-engine/` | planned |
| `confidential-engine/adr/` | `docs/confidential-engine/adr/` | planned |
| `confidential-engine/*.md` | `docs/confidential-engine/` | planned |
| `confidential-engine/web/` | merged into `web/` in M14 | planned |

## confidential-viewer (M5)

| Source | Target | Status |
|---|---|---|
| `confidential-viewer/{src,test}` | `packages/viewer` (`@sik/confidential-viewer`, bin `cvw`) | planned |
| `confidential-viewer/schemas/` | `schemas/confidential-viewer/` | planned |
| `confidential-viewer/fixtures/` | `fixtures/confidential-viewer/` (testnet captures byte-identical) | planned |
| `confidential-viewer/scripts/` | `packages/viewer/scripts/` | planned |
| `confidential-viewer/*.md`, `docs/` | `docs/confidential-viewer/` | planned |
| `confidential-viewer/web/` | merged into `web/` in M14; its `../../src` imports become package imports in M5 | planned |
| `.tools/oz-stellar-contracts` and `zk-diff-harness/.cache/oz-stellar-contracts` | one read-only checkout at `.cache/oz-stellar-contracts` (git-ignored), fetched by script | planned |
