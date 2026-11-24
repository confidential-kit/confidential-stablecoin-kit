<!-- SPDX-License-Identifier: Apache-2.0 -->
# Milestones

Date: 2026-11-24. Working name: **confidential-stablecoin-kit** (name and repository not decided yet).

Three parts. **Part 0** is what the market research says and the go-to-market strategy that follows from it. **Part 1** takes the kit to a working MVP in 15 milestones. **Part 2** is how the project is built after the MVP.

Tier A milestones (M3, M7-M12) need the user's approval of each ticket contract before code.

Status words: `done` (merged, checks green, evidence linked), `in progress`, `planned`. Sizes are effort, not dates: S about 1 day, M 2-3 days, L about a week. Every milestone ends with the full check (`bash scripts/check.sh`) green, its evidence committed, and a short public update with a real capture (draft only; the user posts).

Gates carry over from all three projects and never relax: **G-ZK** (never "private" or "zero-knowledge"; the engine's fixed wording is *amounts hidden from the public; issuer-visible; not zero-knowledge*), **G-CRYPTO** (no hand-written cryptography; unaudited), **G-VALUE** (testnet only, no mainnet writes), **G-LEGAL** (no custody, no hosted service, no auditor keys), **G-OUTREACH** (drafts only, the user sends), **G-SECRETS**.

## Part 0: Market and go-to-market

Full notes, every fact with a URL and date: [`research_notes/Confidential stablecoin kit market analysis/`](research_notes/Confidential%20stablecoin%20kit%20market%20analysis/) — `platform_competitors.md`, `module_competitors.md`, `market_sentiment.md`, `gtm_evidence.md` (all 2026-11-24).

### What the research found

| Finding | Source note | What it changes |
|---|---|---|
| **zk-diff-harness reported clean results on a verifier commit now known to accept a forged proof.** The harness pins Nethermind PR #38 at `de1dfa75`. On 2026-11-17 the PR author published a forgery against exactly that commit (it verified natively and on Stellar testnet), fixed it in `d9de33cf`, and moved the head to `5c0329ce`. The fix changes the proof format, so stock `bb 0.87.0 --zk` proofs no longer verify. Our byte-mutation suite cannot build a forgery of that kind. Checked against GitHub on 2026-11-24. | module, gtm | The harness's "0 of 2,220 invalid inputs accepted" must be re-worded and re-run before any outreach. This is milestone M3, first after the scaffold. |
| **OpenZeppelin may absorb the engine's idea.** OZ PR #976 (opened 2026-11-13, not merged) adds a designated auditor and an optional issuer approval gate on deposit, withdraw and transfer to `stellar-confidential`. | platform, module | If #976 merges and OZ adopts an audited ZK verifier, the engine becomes a reference design and cost benchmark. Checkpoint in Part 2. |
| **Closest rival design to the engine: Fairblock** (SCF #40, $150K): homomorphic ElGamal with range proofs and threshold disclosure, aimed at stablecoins. Active and shipping on EVM (CUSD on Arbitrum, 2026-09-30), but its Stellar port looks paused: closed-source testnet SDK last updated 2026-05-05, no public contract source, 0 events on its testnet contract in the last 7 days (checked 2026-11-24). Threat medium. | module | Engine milestones must show what Fairblock does not on Stellar: open source, proofs checked on chain, measured cost, four-of-four refusal tests. Re-check Fairblock at each phase gate. |
| **No confidential token is on Stellar mainnet.** OZ `stellar-confidential` is still v0.8.0 with a non-ZK verifier (CR-03). Most other Stellar privacy work (Arcane, ZKELLA, 0xbow, Cavern, Nethermind SPP) is shielded pools, a different product. | platform | The window is open, but small. |
| **The viewer's books export has no competitor on any chain.** Koinly, CoinTracker, Cryptio, Bitwave and TRES show no confidential-token support; Zcash users describe the same gap. Decoding and replay alone are crowded (brozorec SDK, Lucent). | module | Lead the holder side with books and disclosure, not decoding. Bitwave (Stellar integration, SCF ties) is the likely absorber; possible partner. |
| **Privacy is not a ranked barrier in independent data.** EY-Parthenon (Oct 2026, 521 respondents): regulatory uncertainty 76%, ecosystem 65%, ERP/TMS integration 54%; privacy not listed; 40% name transparency and auditability. Most "privacy is the blocker" claims come from privacy vendors, SDF and OZ. | sentiment | Never sell "privacy". Sell **issuer control and evidence**: who can see what, proven by tests. |
| **On Stellar, privacy is a foundation priority, not a customer one.** SDF's Q3 report (2026-11-16) and the Nov dev meetings do not mention it. Stellar stablecoin float is about $413M (DefiLlama, 2026-11-24) against about $280B of USD stablecoins. No named Stellar issuer has asked publicly for confidential payments. | sentiment, gtm | The engine is a pilot tool without a named customer. The MVP ends with a design-partner draft, not a launch. |
| **Regulation favours issuer visibility.** OCC GENIUS Act rule effective 2027-01-18 mandates no privacy technology; FATF wants issuers able to freeze and withdraw; the EU anonymous-account ban starts 2027. | sentiment, gtm | "The issuer sees everything" is the easier story for an issuer's lawyers. It is the engine's design. |
| **Developer base is tiny.** OZ's `stellar-confidential` crate: 41 crates.io downloads. Fireblocks does not support Soroban tokens. | gtm | Outreach to named teams, not broad marketing. |

### Positioning

**One line:** confidential stablecoin payments on Stellar, with the evidence to trust them.

The kit offers two routes and the tools both need:

| Route | For | Trust model | Status today |
|---|---|---|---|
| A. **Issuer-attested** (confidential-engine) | A regulated issuer that already holds freeze and clawback and wants to pilot payments competitors cannot read, now | Amounts hidden from the public; the issuer sees every amount and co-signs every transfer; not zero-knowledge | Works on testnet (recorded run 2026-11-08) |
| B. **OpenZeppelin `stellar-confidential`** | Issuers who will wait for an audited ZK verifier | Circuits (Noir, UltraHonk); not zero-knowledge on chain until a ZK verifier is merged and audited | Testnet; verifier fix under review |
| Both | Holders, treasurers, accountants, auditors | **confidential-viewer**: books export and verifiable disclosure packages | Works without a key; decryption not built |
| Route B's gate | OZ, Nethermind, SDF, auditors | **zk-diff-harness**: independent evidence on the ZK verifiers | Works; needs re-run on the fixed pin |

Wording rule for every surface: lead with what a person gets (books an accountant accepts, payments competitors cannot read, a test result anyone can re-run), never with the cryptography.

### Who it is for (in order of evidence)

1. **Verifier maintainers and reviewers** (Nethermind, indextree, Perch, OZ, auditors). Strongest live need: a forgery was found in the pending verifier on 2026-11-17 and a privacy pool (Cavern) calls that verifier "the last thing between us and mainnet". Users of zk-diff-harness.
2. **Holders and their accountants** of confidential tokens. No books tool exists anywhere. Users of confidential-viewer.
3. **Issuers and issuance platforms** with inter-entity or B2B flows (named targets on Stellar: PYUSD, MGUSD, EURCV, the U.S. Bank USBDC pilot pattern, white-label issuance platforms). None has asked publicly. Users of confidential-engine, via a capped testnet pilot.

### Channels and order (all drafts; the user sends)

1. **Evidence on public GitHub threads**, issue-first: re-run matrix offered on Nethermind PR #38; spec-versus-code differences on OZ #949; measured costs and refusal tests as a comparison point on OZ #976 (not a competing PR).
2. **Stellar Community Fund**: one kit-level Build application in the next round after #46 (expected late Dec 2026 to Jan 2027; confirm on the awards page). Budget below the $135-150K privacy precedents. Then an Audit Bank request. Public Goods route for the harness alone as fallback.
3. **One design-partner note** to an issuer or issuance platform for a capped testnet pilot (Q1 2027).
4. **Static pages and plain X posts** with real captures ("see which proof checkers reject a known fake proof", "export your books from a confidential token").
5. Not used: Drips Stellar Wave (user rule: never apply the Stellar Wave label).

### Business model (sequence)

Grants (SCF Build, Public Goods) → paid integration and audit-prep support for issuers piloting route A or B → paid verifier re-runs for maintainers and auditors when pins move. A hosted service only if G-LEGAL opens after counsel; never key custody.

### Twelve-month success metrics

- Harness cited or linked by at least 1 verifier repo or audit report; at least 2 pins re-run after upstream changes.
- At least 2 upstream threads where a maintainer engages with the kit's evidence; at least 1 merged doc or test contribution.
- 1 SCF award, then 1 Audit Bank request for the engine.
- 1 named issuer or platform on a capped testnet pilot under written terms.
- Viewer published to npm after decryption works; at least 3 external teams using it on testnet.
- 30-100 GitHub stars (Stellar privacy repos sit at 0-60).

## What the MVP is

One repository where an investor or a reviewer sees, in five minutes:

1. **Route A on testnet:** a confidential transfer whose amount the public cannot read, the issuer co-signing it, the chain refusing four kinds of bad transaction, and its cost.
2. **Route B, honestly:** OZ's token deployed by us on testnet with known ground truth; the viewer decrypting a holder's own history with the holder's key.
3. **One viewer, both tokens:** books export and a verifiable disclosure package for a holder of either token.
4. **Evidence on route B's gate:** the harness matrix re-run on the fixed verifier pins, including the published forgery as a regression case, with each verifier's verdict and Soroban cost.
5. **Both routes side by side:** cost per transfer, what each party can see, what is proven and what is assumed.

MVP is done when all five run from this repo on testnet, one console shows them with provenance on every figure, and the release notes say plainly what works and what does not. Not in the MVP: mainnet writes (never, G-VALUE), range proofs (stage 2), threshold auditor custody, a hosted service, any claim of privacy or zero-knowledge.

## Part 1: MVP (15 milestones)

### Phase A: Move in and fix the evidence (M1-M6)

Each tool arrives unchanged, with its own checks green, before anything is merged or rewritten. The one exception is M3: the harness's published claim is wrong in a way that matters, so it is fixed straight after the harness moves in.

| # | Milestone | Size | Done when | Status |
|---|---|---|---|---|
| M1 | Backup and monorepo scaffold | S | tarball of the three source projects (no `target/`, `node_modules`, `.cache`, `.tools`, `.toolchain`, `work/`); Cargo workspace + pnpm workspace; `scripts/check.sh`; `docs/adr/ADR-0001-monorepo.md` (amends kit ADR-0002 as the issuer kit did); `MIGRATION.md`; root `docs/GATES.md` with one G-ZK wording | planned |
| M2 | zk-diff-harness moves in | M | 6 crates under `crates/zkd-*` (edition 2024, `todo = deny` kept per crate); 3 adapters stay separate workspaces under `adapters/` (soroban-sdk 26/27/28); `include_str!` schema path and `fixtures/toolchain-help` path rewritten; 80 tests pass; `reports/latest/` byte-identical | planned |
| M3 | Harness repair: the PR #38 forgery | L | PR #38 re-pinned to the fixed head (`5c0329ce` or later) in `pins/verifiers.json` and the adapter together; a patched-prover profile for the new ZK proof format; the published forgery artifact (from the PR's own tests, not code we write) replayed as a named regression case against the vulnerable pin (must accept), the fixed pin (must reject) and Perch (result kept private and drafted to its maintainers first if accepted); full matrix re-run; PITCH, README and report say the earlier result was measured on a commit later shown forgeable and what byte mutations cannot catch | planned |
| M4 | confidential-engine moves in | M | 5 crates under `crates/ce-*` (edition 2021, `todo = allow` kept per crate); one host `release` profile and a `release-wasm` profile; contract builds to 45,992 B Wasm; 45 tests pass; `testnet/` runner under `packages/engine-testnet`; recorded run byte-identical | planned |
| M5 | confidential-viewer moves in | M | `packages/viewer` (`cvw` CLI); web `../../src` imports rewritten to the package; `pnpm check` passes; `fixtures:check` decodes 866/866 events; one OZ v0.8.0 read-only checkout shared by viewer and harness (no second clone) | planned |
| M6 | CI and one set of docs | M | GitHub Actions runs `scripts/check.sh` (Node + Rust caches; adapter builds on a weekly job); each tool's SPEC, ARCHITECTURE, RISKS, TESTING, PRIOR-ART, SOURCES under `docs/<tool>/`; the three banners (engine G-ZK sentence, viewer `banner.ts`, harness `EVIDENCE_NOTICE`) traced to `docs/GATES.md`; every link resolves | planned |

### Phase B: Route B made real (M7-M9)

| # | Milestone | Size | Done when | Status |
|---|---|---|---|---|
| M7 | Viewer decrypts with the holder's key (CV-005) | L | Pinned crypto SDK installed behind `CryptoBackend` (needs the user's approval: this install was refused by the permission system on 2026-11-08); passes all 18 OZ primitive vectors or is refused; `cvw timeline --key` decrypts; web "load your viewing key" works in the browser with nothing uploaded | planned |
| M8 | Our own OZ token on testnet with ground truth (CV-015) | L | Script deploys OZ v0.8.0 verifier, token and extensions with throwaway keys; runs register, deposit, merge, transfer, withdraw; captures events, on-chain commitments and the true amounts; viewer's decrypted timeline matches ground truth 100%; the harness gets real proofs from a real deployment as extra positive cases | planned |
| M9 | Disclosure with real proofs (CV-030..034) | L | A disclosure package carries a D-recipient proof for one transfer, bound to an accountant's request key; the recipient verifies it against chain data; tamper and re-seal are detected; golden fixtures committed | planned |

### Phase C: Route A ready for a pilot (M10-M12)

| # | Milestone | Size | Done when | Status |
|---|---|---|---|---|
| M10 | One viewer, both tokens | L | The viewer decodes the engine's events and decrypts a holder's own engine amounts through the engine's own client (Wasm build of `sik-ce-client` or the `ce` JSON CLI; no second implementation of the crypto); books export and disclosure package work for an engine holder on the recorded run; same package format for both tokens | planned |
| M11 | Engine pilot kit (CE-032, CE-038) | M | Issuer reference tooling (local shadow ledger, attestation signer) as a library and CLI; one-command testnet deploy with mandatory caps; pilot runbook; a re-recorded run from this repo; a written comparison with OZ PR #976's approval gate and with Fairblock (what each party sees, setup, measured cost) | planned |
| M12 | Engine credibility (CE-027, CE-028 partial, CE-034) | L | Crypto test vectors generated and checked by an independent implementation (transcript, encodings, ElGamal, proof verification) in a second language (C8); transcript owned by the proof module with a golden trace and absorb-before-challenge check (C1, C2); a test that breaks one batched equation and compensates in another is rejected (C3); generator/tag registry tests (C4); a rejection test per statement-checklist line and per proof field, `cargo-mutants` on the verifier with no surviving check-deleting mutant (C5, C6); trapdoor forgery tests (C7); full-range property and fuzz suites over the verifier and contract entry points (C11, C12); secret-type lint (C16); written equation-by-equation review (C17); claims linter covers every new surface | planned |

### Phase D: Product surface (M13-M15)

| # | Milestone | Size | Done when | Status |
|---|---|---|---|---|
| M13 | Route comparison report | M | One generated page and JSON: cost per transfer (engine sigma proof about 36.7M CPU on testnet vs OZ ZK verification about 112-121M in the test host, re-measured on the fixed pins), who sees what, what is proven vs assumed, setup needs; every figure from a recorded run with its date; harness report diff between the old and the fixed pins (ZKD-032) | planned |
| M14 | One web console | L | `web/` with four sections (Route A engine, Route B viewer, Verifier evidence, Compare) and a live read-only testnet check; works at 375 px, light and dark; built with the taste skills on the kit design tokens; provenance chip on every figure | planned |
| M15 | MVP release | M | README, DEMO and PITCH rewritten for the kit (lead with issuer control and evidence, never "privacy"); demo video; console deployed as a static page after the user approves; tag `v0.1.0`; release notes list what works and what does not; drafts ready for the user: the three GitHub comments, the SCF interest form, one design-partner note, X posts with captures | planned |

### Order and dependencies

```
M1 ─► M2 ─► M3 ───────────────────────────┐
M1 ─► M4 ─► M5 ─► M6                       │
M5 ─► M7 ─► M8 ─► M9 ─► M10 ─► M13 ─► M14 ─► M15
M4 ─► M11 ─► M12 ─────────────► M13
M3, M8 ─► M13
```

M3 goes first after the scaffold because the harness is the part with live demand and a wrong published claim. M11 and M12 only need the engine (M4), so route A work runs alongside Phase B. M8 depends on M7 only for decryption; the deploy script can start as soon as M5 lands.

## Part 2: After the MVP

Dates are targets, not commitments. All outreach is drafted for the user and sent by the user (G-OUTREACH).

| Phase | Target | Contents | Done when |
|---|---|---|---|
| P1 Evidence outreach | Dec 2026-Jan 2027 (starts once M3 lands, before the rest of the MVP) | The user sends the three GitHub drafts (Nethermind #38, OZ #949, OZ #976); the harness re-runs whenever the PR #38 or Perch pin moves; Perch result handled privately first if it accepts the forgery | at least 2 threads where a maintainer engages with the kit's evidence |
| P2 Funding | next SCF round after #46 (expected late Dec 2026-Jan 2027) | One kit-level SCF Build application, milestones tied to audit-ready deliverables; Audit Bank request after an award; Public Goods fallback for the harness alone | application submitted; award or written decline |
| P3 Design partner | Q1 2027 | One issuer or issuance platform on a capped testnet pilot of route A under written terms; Bitwave or a crypto-accounting vendor approached about the viewer's books format | 1 partner running the pilot; 1 written reference |
| P4 Harden | Q1-Q2 2027 | External review of the engine (audit package CE-039) and the viewer's key path (CV-041); threat model and no-egress tests (CV-040); `cargo deny`, `pnpm audit`, supply-chain review; operators and key rotation (CE-020, CE-024) | review report published; findings fixed or tracked |
| P5 Disclosure and custody library | Q2-Q3 2027 | Engine disclosure verifier (CE-029), threshold partial decryption (CE-030), custody runbook (CE-031); archive source for history older than 7 days (CV-007/008); npm package for the viewer | one partner verifies a disclosure package without our help |
| P6 Stage 2 | gated by AUDIT-PLAN.md rubric | Transparent range proofs replace the issuer's attestation for range and balance (CE-036), separate audit scope | rubric says GO and an auditor signs off, or a written NO-GO |
| P7 Sustainability decision | Q3-Q4 2027 | Paid integration and audit-prep offer; paid verifier re-runs; go/no-go on anything hosted (only if G-LEGAL opens) | 1-2 paid engagements and a written decision |

### Checkpoints (decide, do not drift)

- **OZ PR #976 merges and OZ adopts an audited ZK verifier:** the engine becomes a reference design and cost benchmark; the kit narrows to the viewer (books and disclosure for OZ's token) and the harness. Re-plan within 2 weeks.
- **Fairblock ships a confidential stablecoin on Stellar mainnet:** publish the M13 comparison against it; keep the engine only if its trust model or cost wins on measured numbers.
- **No maintainer responds to evidence drafts within about 8 weeks of sending:** stop outreach on that thread; keep the harness running for audits.
- **June 2027 with no design partner for route A:** freeze the engine at its pilot kit; spend the time on the viewer, which has no competitor in our searches.
- **A soundness bug in the engine's own proofs:** stop all engine claims and demos until fixed and re-reviewed.
