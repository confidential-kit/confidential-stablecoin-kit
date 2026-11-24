#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Runs every check in the repo. Each part is skipped while it has nothing in it.
set -euo pipefail
cd "$(dirname "$0")/.."

if ls packages/*/package.json >/dev/null 2>&1 || [ -f web/package.json ]; then
  echo "== TypeScript"
  pnpm check
else
  echo "== TypeScript: no packages yet, skipped"
fi

if grep -qE '^members = \[\s*\]' Cargo.toml; then
  echo "== Rust: no crates yet, skipped"
else
  echo "== Rust"
  cargo fmt --all -- --check
  cargo clippy --workspace --all-targets -- -D warnings
  cargo test --workspace
fi

for ws in adapters/*/; do
  if [ -f "$ws/Cargo.toml" ]; then
    echo "== Rust adapter ($ws): cargo check only; full builds run in the weekly job"
    (cd "$ws" && cargo check --locked)
  fi
done

echo "== all checks passed"
