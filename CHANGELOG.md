# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [0.0.2] - 2026-04-04

### Added

- **Go CI workflow** (`go-ci.yml`): vet, staticcheck, test, coverage, cross-platform
- **Go security audit** in `security.yml` using govulncheck
- **Go release** in `release.yml` with cross-compilation support
- **SLSA Build Level 3** attestations on all release artifacts via `actions/attest-build-provenance`
- **Sigstore container signing** in `docker.yml` via cosign (keyless OIDC)
- **Trusted Publishing** for PyPI (`pypa/gh-action-pypi-publish` with OIDC)
- **npm provenance** via `--provenance` flag on publish
- **SBOM generation** (SPDX) for all release languages, not just Docker
- **OpenSSF Scorecard** workflow (`scorecard.yml`) for self-assessment
- **ARM64 runner support** via `runner` input on all CI and security workflows
- `SECURITY.md` — vulnerability reporting and security policy
- `CHANGELOG.md` — this file
- `CONTRIBUTING.md` — contribution guide
- `examples/` — complete caller workflow examples for all languages

### Changed

- **All actions pinned by commit SHA** — no more mutable `@v4`/`@v5` tags (supply chain hardening post-CVE-2025-30066)
- **Top-level `permissions: {}`** on every workflow with granular job-level overrides (principle of least privilege)
- Python CI default package manager changed to `uv`
- Node.js default version updated to 22
- Python default version updated to 3.12
- `taiki-e/install-action` uses `@v2` with explicit `tool:` input instead of tool-specific tags

### Security

- All 34 GitHub Actions pinned by full SHA — prevents tag-mutation supply chain attacks
- Added `persist-credentials: false` to all checkouts — tokens not stored in git config
- Added `id-token: write` permissions for OIDC/Sigstore flows
- Removed `safety` from Python audit (deprecated, replaced by `pip-audit`)

## [0.0.1] - 2026-03-29

### Added

- Initial release with Rust, Python, and Node.js CI workflows
- Docker build and push pipeline
- Documentation build and deploy pipeline
- Security scanning (CodeQL, language-specific audits)
- Release automation for crates.io, PyPI, and npm
- PR labeling and stale issue management
- Dependabot and labeler configuration templates
