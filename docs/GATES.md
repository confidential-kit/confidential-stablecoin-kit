<!-- Copied from the Stellar Institutional Kit programme docs (docs/GATES.md) on 2026-11-24 so this repo stands alone. ENGINEERING.md adds stricter rules; where they differ, the stricter rule wins. -->
# Gates

A gate blocks a claim or an action until its condition is met. Agents must not work around a gate. If a task needs a closed gate, stop and record it in the project's `TASKS.md` as BLOCKED with the gate id.

| Gate | Blocks | Opens when |
|---|---|---|
| **G-ZK** | Any claim, in code, docs, UI or marketing, that balances or amounts are "hidden", "private" or "zero-knowledge" | A ZK-flavour verifier is merged upstream, released, adopted by the token in use, and independently audited. Until then say "amounts are encrypted from the public; not zero-knowledge" and cite CR-03 for the OZ verifier |
| **G-ZK (sigma proofs)** | The same applies to non-ZK-SNARK designs: a sigma-protocol proof can be honest-verifier zero-knowledge, but the confidential-engine stage 1 hides amounts only from the public, not from the issuer, and its validity rests on the issuer's co-signature. Describe it as "amounts hidden from the public; issuer-visible", never as "zero-knowledge" or "private" without that qualifier | Same condition as above, plus an external review of the proof system and its transcript |
| **G-VALUE** | Any mainnet deployment holding user value, any mainnet write | The code is audited (scope document exists), value is capped, and the user has approved in writing. Agents never sign or send mainnet transactions |
| **G-CRYPTO** | Shipping hand-written cryptography as a dependency of anything that holds value | Uses audited libraries for primitives, has a test-vector suite from an independent implementation, a written threat model, and an external review. Prototype code is labelled DEMO-ONLY in its README and Cargo/package metadata |
| **G-DTCC** | Treating any DTCC requirement as fact | The profile row has `status: published` with a primary URL. Rows marked `inferred` or `unknown` are labelled in every output that uses them |
| **G-LEGAL** | Anything touching auditor keys, hosted decrypted data, relayers that obscure the payer, mixers or anonymity pools, sanctions screening, custody | Counsel review. Not legal advice from this repo. Default: do not build the hosted variant |
| **G-LICENCE** | Copying third-party code | Licence is permissive (MIT, Apache-2.0, BSD) and attribution is added to `NOTICE` and `docs/THIRD_PARTY.md`. Unlicensed, GPL or BUSL code: ideas only, or ask the author |
| **G-NOVELTY** | Calling something "first", "novel" or "nobody has built" | A prior-art search of SDF repos, OZ, vendors and repos created since 2026-01-01 is recorded in the project's `PRIOR-ART.md` with a date |
| **G-OUTREACH** | Contacting anyone (issues, comments, emails, Discord, PRs to others' repos) | The user does outreach. Agents may draft text but never post it |
| **G-SECRETS** | Handling keys | No private keys in the repo, in fixtures, or in logs. Testnet throwaway keys are generated at runtime and never committed |

## Current gate status (2026-10-31)

- G-ZK: **closed** (OZ verifier non-ZK; Perch's ZK delta unaudited; no upstream merge).
- G-VALUE: **closed**.
- G-DTCC: Stellar rows are `unknown`/`inferred`; generic DTC rows are `published` (SEC no-action letter, DTCC FAQ, dtcclearning.com pages read in discovery).
- G-LEGAL: closed for hosted disclosure, relayers, pools. Open for libraries and local-first tooling.
