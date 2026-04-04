# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 0.0.x   | Yes       |

## Reporting a Vulnerability

If you discover a security vulnerability in this repository, please report it responsibly:

1. **Do NOT** open a public issue.
2. Use [GitHub Security Advisories](https://github.com/sebastienrousseau/pipelines/security/advisories/new) to report the vulnerability privately.
3. Alternatively, email **security@sebastienrousseau.com** with:
   - A description of the vulnerability
   - Steps to reproduce
   - Potential impact

## Response Timeline

- **Acknowledgement**: Within 48 hours
- **Initial assessment**: Within 1 week
- **Fix or mitigation**: Within 30 days for critical issues

## Security Measures

This repository implements the following security controls:

- **SHA-pinned actions**: All GitHub Actions are pinned by commit SHA to prevent supply chain attacks (see [CVE-2025-30066](https://github.com/advisories/ghsa-mrrh-fwg8-r2c3))
- **Least-privilege permissions**: Every workflow declares `permissions: {}` at the top level with granular job-level overrides
- **SLSA Build Level 3**: Release artifacts include provenance attestations via `actions/attest-build-provenance`
- **Sigstore signing**: Docker images are signed with cosign (keyless via OIDC)
- **Trusted Publishing**: Supports OIDC-based publishing to PyPI, npm, and crates.io
- **SBOM generation**: Software Bill of Materials (SPDX) for all release artifacts
- **OpenSSF Scorecard**: Automated weekly security assessment
- **Dependency scanning**: CodeQL, cargo-audit, pip-audit, npm audit, govulncheck

## Updating Action SHAs

When updating pinned action SHAs, always verify the commit belongs to the expected tag:

```bash
gh api repos/OWNER/REPO/commits/TAG --jq '.sha'
```
