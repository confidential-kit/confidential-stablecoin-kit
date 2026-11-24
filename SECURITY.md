# Security

**DEMO-ONLY. TESTNET-ONLY. Unaudited. Do not hold value.** Nothing in this repository is deployed to Stellar mainnet.

## Reporting a vulnerability

Please do not open a public issue. Use GitHub's private vulnerability reporting on this repository ("Security" tab, "Report a vulnerability"). We aim to acknowledge within 72 hours.

This includes any case where a verifier tested by `zk-diff-harness` accepts an invalid proof: report it privately to that verifier's maintainers first, and to us.

## Scope

- The confidential-engine contract and client (issuer-attested; amounts hidden from the public; issuer-visible; not zero-knowledge).
- The confidential-viewer CLI and web app (local-first; no keys leave the machine).
- The zk-diff-harness and its reports.

## Not in scope

Third-party verifiers, OpenZeppelin's `stellar-confidential`, and the Stellar network itself: report to their maintainers.
