# Cryptography and verifier rules

Rules every change to the cryptographic and verifier code in this repo must follow. Each one comes from a real failure in a comparable system: confidential transfers on Solana and XRPL, Zcash, Penumbra, Aztec, and the Soroban UltraHonk verifier.

Parts: **E** = confidential engine (Soroban contract and Rust client), **V** = viewer, **H** = verifier test bench. "From" is the milestone in [MILESTONES.md](../MILESTONES.md) where the rule starts to apply; it applies to every later change.

| # | Rule | Failure it prevents | Parts | From |
|---|---|---|---|---|
| C1 | **The proof module owns its transcript.** Each statement is one typed struct with one `absorb_into(&mut Transcript)` called inside both prover and verifier; callers never append public inputs | Solana Apr and Jun 2025 forgeries (values missing from Fiat-Shamir); Frozen Heart | E, V | M12 |
| C2 | **Transcript-trace golden file.** Test builds log (label, length, hash) for every absorb and squeeze; a test compares it with the table in CRYPTO-SPEC and asserts every proof field is absorbed before the challenge that depends on it | Same; Trail of Bits' Solana review | E, H | M12 |
| C3 | **Batching weights only after everything is absorbed, plus a compensation test.** The engine already derives `omega` after absorbing the proof (CRYPTO-SPEC). Add a test that breaks one equation and compensates in another; it must be rejected. If the test cannot be written soundly, verify equations separately | zkSecurity: batching weights "already the source of two bugs" (Solana) | E | M12 |
| C4 | **Domain-tag and generator registry.** One table of tags (`protocol|version|network|contract|statement`); generators by hash-to-curve with distinct tags; parameter digest absorbed first; tests for pairwise distinctness and fixed vectors | XRPL Sherlock Critical (two generators from one label) | E, V | M12 |
| C5 | **Statement checklist per operation.** CRYPTO-SPEC lists every relation each operation must prove (ownership, ciphertext equality, balance ≥ amount, range, version). Each line has a "cheating prover" test that must be rejected | Trail of Bits XRPL High: no proof of balance ≥ amount (tokens from nothing) | E | M11, M12 |
| C6 | **A negative test for every final equation and every proof field, and mutation testing on verifiers.** Surviving `cargo-mutants` mutants that delete a check mean a missing test | Trail of Bits: tests could not detect a verifier that skips checks | E, H | M12 (E), M3 (H) |
| C7 | **Algebraic forgeries, not only byte mutations.** H keeps published forgeries (PR #38) as regressions and runs stock and patched prover profiles. E has "trapdoor" tests: with known logs between generators forging must succeed (so the test is real); with real generators it must fail | Our earlier byte-mutation matrix (0 of 2,220 invalid proofs accepted) missed the PR #38 forgery | H, E | M3, M12 |
| C8 | **Independent reference implementation and committed vectors.** A second implementation in another language emits JSON vectors; CI regenerates and diffs | Zcash test-vector practice; XRPL findings that broke external implementations | E, V | M12 |
| C9 | **Spec tables are tested.** Transcript order, context-id layout, storage layout, error codes and event wire formats are machine-readable tables that tests compare with the code | OZ #949; XRPL spec/code findings | all | M6 onward |
| C10 | **Strict parsing at every boundary.** Exact lengths, canonical encodings, on-curve checks, identity rejected where forbidden, in Rust and TS with the same vectors | Aztec "0 bug"; Trail of Bits length-check findings | E, V, H | M4, M5 onward |
| C11 | **Full-range property tests with committed regressions.** Strategies always include 0, 1, max, max−1 and limb boundaries; commit `proptest-regressions/` | Penumbra fixed-point; XRPL `UINT64_MAX` loop | E, V | M12 |
| C12 | **Fuzz targets with "never panic".** Every decoder, every `verify`, the viewer's event parser and replay | Noir CVE-2026-41197; verifier panics in Solana audits | E, V, H | M12 (E), M5/M7 (V) |
| C13 | **Recompute, don't trust.** The contract derives every public value it can and applies exactly what the statement binds | Aztec Connect proof/apply mismatch | E | M11 |
| C14 | **Kill switch and safe exit designed up front.** Separate pause flags per operation, who may flip them, and an exit path while paused | Solana switched off in a day, needed a year to come back | E | M11 |
| C15 | **Versioned proof and transcript formats.** Version byte in proofs and labels; accept-set per contract version; the viewer decodes every version it has seen | PR #38 proof-format change; Solana legacy paths | E, V, H | M3, M10 |
| C16 | **Secret hygiene.** `zeroize`; no `Debug`, `Serialize` or `Clone` on secret types (lint rule); constant-time checks on prover and decrypt paths where feasible; document JS limits | Least Authority findings on secret types; XRPL timing findings | E, V | M7, M12 |
| C17 | **Equation-by-equation review before any soundness statement.** A written walk-through in the repo comparing every verifier equation with the spec; a maintainer signs it off | PR #38 forgery was found exactly this way | E, H | M12, M3 |
| C18 | **No exploit authoring.** Negative tests are rejection tests. Published third-party forgeries may be replayed as regression artefacts only with maintainer approval. If anything we test accepts an invalid input, stop and report it privately (see `SECURITY.md`); publish nothing | Responsible disclosure (`docs/GATES.md` G-OUTREACH) | H, E | always |

## Wording

- Engine: "amounts hidden from the public; issuer-visible; not zero-knowledge".
- OpenZeppelin confidential token: "amounts are encrypted from the public; not zero-knowledge".
- Never "private", "zero-knowledge", "audited" or "secure" without that qualifier. See [GATES.md](GATES.md) (G-ZK).

## Not covered here

An applied-cryptography review of the spec, a code audit and a bug bounty are external steps (MILESTONES Part 2). Until they happen, nothing in this repo is audited.
