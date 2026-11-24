<!-- Copied from the Stellar Institutional Kit programme docs (docs/CONVENTIONS.md) on 2026-11-24 so this repo stands alone. -->
# Conventions

## Toolchain pins (checked on this machine 2026-10-31)

| Tool | Version | Notes |
|---|---|---|
| Node | 24.x (`engines: >=22.18`) | TypeScript runs by type stripping; no build step for tests |
| pnpm | 10.22.0 | Each TS project has its own `pnpm-lock.yaml` |
| TypeScript | ^7.0 | `strict`, `noUncheckedIndexedAccess`, `erasableSyntaxOnly`, `verbatimModuleSyntax` (same tsconfig as `activity-ledger`) |
| `@stellar/stellar-sdk` | ^17.3 | |
| Rust | 1.97.1 stable | `rust-toolchain.toml` in each Rust project |
| `soroban-sdk` | per project; record it in the project README. Findings 2026-10-31 [P: confidential-engine scaffold]: 25.x (25.3.2) lacks `g1_msm` and BN254 `Fr` wrappers, which arrive in 26.0.0; SDK 25 and 29 cannot share a Cargo lockfile (`soroban-wasmi` conflict). Contract projects needing BN254 MSM use SDK 29 (separate workspace) until CE-003 decides | Protocol 29 on mainnet; Protocol 30 votes 2026-11-03 (testnet) and 2026-11-23 (mainnet) [U: dates come from earlier discovery notes, not an SDF primary source] |
| `@types/node` | ^24 for Node 24 (dtc-kit uses ^24; `activity-ledger` uses ^26) | |
| Stellar CLI | 25.2.0 | |
| Noir (`nargo`) | 1.0.0-beta.9 (Perch, Nethermind docs) and 1.0.0-beta.11 (OZ CI) [S: zk-diff-harness scaffold] | Both produce byte-identical verification keys for OZ's six circuits (checked by hand with `bb write_vk -s ultra_honk --oracle_hash keccak`). `projects/zk-diff-harness/scripts/zk-toolchain.sh` installs both profiles with SHA-256 pinning |
| Third-party verifier SDKs | verifiers under test link `soroban-sdk` 26, 27 and 28 | Older than the CLI 25.2.0 template (sdk 25); keep each verifier in its own adapter workspace |
| Barretenberg (`bb`) | 0.87.0 (not installed here) | pinned to what the Nethermind verifier targets; Aztec is at v6.0.0, differences unchecked |

## Project directory template

Every project directory contains:

```
README.md       what it is, status, how to run, commands for lint/test
SPEC.md         interfaces, data formats, behaviour; normative
ARCHITECTURE.md modules, data flow, decisions
BUILD-PLAN.md   milestones with acceptance criteria and estimates [E]
TASKS.md        small tickets: id, title, deps, acceptance, status
TESTING.md      test strategy, fixtures, how to capture new fixtures
RISKS.md        risks, gates touched, open questions
PRIOR-ART.md    searched repos/vendors with dates and verdicts
SOURCES.md      pointers into discovery notes + external URLs with trust tags
```
plus the code skeleton (compiles, one smoke test passes, every unimplemented function throws/`todo!()` with a ticket id).

## Naming

- Package scope for TS: `@sik/<project>` (private, unpublished until a task says otherwise).
- Rust crates: `sik-<project>-<part>`.
- Ticket ids: `<PROJECT>-<NNN>` (e.g. `DTC-012`).
- Scenario tags: `@published`, `@inferred`, `@unknown`, `@stellar-sac`, `@stellar-sep57`, `@testnet`, `@slow`. `@published`/`@inferred`/`@unknown` are DTCC requirement statuses (gate G-DTCC) and belong to dtc-kit scenarios only; `token-invariants` uses its own tags (for example `oz-observed` for behaviour seen in OZ code that the SEP text does not state). `holders-at-ledger` and `token-invariants` pin `soroban-sdk` "25" (what `stellar contract init` writes with CLI 25.2.0, resolves to 25.3.2); OZ stellar-contracts v0.8.0 uses sdk 28.

## Fixtures

- Captured by script, not by hand. The script, the source URL/RPC, ledger numbers and capture date are stored beside the fixture (`*.provenance.json`).
- Mainnet fixtures are read-only captures. No private data. No keys.

## Commits

Plain commit messages.

## Decision records

`docs/decisions/ADR-NNNN-title.md`: context, decision, consequences, date, status. Cross-project interface changes need an ADR.

## Licence headers

Apache-2.0 SPDX header (`// SPDX-License-Identifier: Apache-2.0`) in every source file. Third-party code keeps its own header and is listed in `docs/THIRD_PARTY.md`.
