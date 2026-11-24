# Confidential Stablecoin Kit

**Confidential stablecoin payments on Stellar, with the evidence to trust them.**

> [!IMPORTANT]
> **DEMO-ONLY. TESTNET-ONLY. Unaudited. Do not hold value.** Nothing here is deployed to Stellar mainnet.
> The engine hides amounts from the public; the issuer sees every amount; it is not zero-knowledge.
> OpenZeppelin's `stellar-confidential` token encrypts amounts from the public and is not zero-knowledge until a ZK verifier is merged, released and audited (audit finding CR-03).

The kit is being assembled from three tools that were built separately:

| Tool | What it gives you | Language | Status (2026-11-24) |
|---|---|---|---|
| **confidential-engine** | An issuer-attested confidential stablecoin wrapper for Soroban: the public cannot read transfer amounts, the issuer checks and co-signs every transfer, and the chain refuses bad transfers | Rust | Moving in (M4). Recorded testnet run 2026-11-08 |
| **confidential-viewer** | For holders and their accountants: read a confidential token's history, keep unknown amounts unknown, export books, and build disclosure packages an auditor can check | TypeScript | Moving in (M5). Decryption with a viewing key not built yet |
| **zk-diff-harness** | Independent test evidence on the zero-knowledge verifiers that OpenZeppelin's token needs: what each accepts, rejects or crashes on, and what it costs | Rust | Moving in (M2). Its earlier result is being re-run after a forgery was published against one pinned verifier (M3) |

Plan: [MILESTONES.md](MILESTONES.md). Crypto rules: [docs/CRYPTO-RULES.md](docs/CRYPTO-RULES.md). Layout: [MIGRATION.md](MIGRATION.md) and [ADR-0001](docs/adr/ADR-0001-monorepo.md). Security reports: [SECURITY.md](SECURITY.md).

## Requirements

- Node.js 22.18 or later (24 recommended, `.nvmrc`), pnpm 10.22.0
- Rust 1.97.1 with `wasm32v1-none` (`rust-toolchain.toml`)
- Stellar CLI (version set when the engine moves in, M4)

## Check

```sh
pnpm install
bash scripts/check.sh   # every check in the repository; parts with nothing in them are skipped
```

## Layout

```
crates/      Rust crates, one Cargo workspace (engine sik-ce-*, harness sik-zkd-*)
adapters/    verifier adapters, one Cargo workspace each (soroban-sdk 26/27/28)
packages/    TypeScript packages, one pnpm workspace (viewer, engine testnet runner)
web/         one web console
vectors/     cross-language crypto test vectors
reference/   independent second implementation for the vectors
fixtures/ schemas/ reports/ scripts/ drafts/   per tool: <dir>/<tool>/
docs/        per-tool docs, ADRs, gates, design system
work/        one folder per ticket: contract, reviews, evidence
```

## Licence

Apache-2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).
