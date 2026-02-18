# Pipelines

Reusable CI/CD templates and GitHub Actions workflows for the Sebastien Rousseau ecosystem.

## Overview

Pipelines provides standardized continuous integration and deployment configurations that ensure consistent quality across all projects. Use these reusable workflows to maintain best practices without duplicating CI/CD code.

## Available Workflows

| Workflow | Purpose | Languages |
|----------|---------|-----------|
| `rust-ci.yml` | Build, test, lint, audit | Rust |
| `python-ci.yml` | Test, lint, type check, coverage | Python |
| `release.yml` | Automated releases | Rust, Python, Node |
| `security.yml` | Security scanning | All |

## Quick Start

### Rust Projects

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  ci:
    uses: sebastienrousseau/pipelines/.github/workflows/rust-ci.yml@main
    with:
      rust-version: "stable"
      run-coverage: true
```

### Python Projects

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  ci:
    uses: sebastienrousseau/pipelines/.github/workflows/python-ci.yml@main
    with:
      python-version: "3.11"
      coverage-threshold: 80
```

### Security Scanning

```yaml
# .github/workflows/security.yml
name: Security

on:
  push:
    branches: [main]
  schedule:
    - cron: '0 0 * * 0'  # Weekly

jobs:
  security:
    uses: sebastienrousseau/pipelines/.github/workflows/security.yml@main
    with:
      fail-on-vulnerability: true
```

### Releases

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    uses: sebastienrousseau/pipelines/.github/workflows/release.yml@main
    with:
      language: rust
    secrets:
      CRATES_TOKEN: ${{ secrets.CRATES_TOKEN }}
```

## Workflow Inputs

### rust-ci.yml

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `rust-version` | string | `stable` | Rust toolchain version |
| `run-clippy` | boolean | `true` | Run clippy linting |
| `run-fmt` | boolean | `true` | Check formatting |
| `run-audit` | boolean | `true` | Run security audit |
| `run-coverage` | boolean | `false` | Generate coverage report |
| `coverage-threshold` | number | `80` | Minimum coverage % |
| `cargo-features` | string | `''` | Features to enable |

### python-ci.yml

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `python-version` | string | `3.11` | Python version |
| `run-mypy` | boolean | `true` | Run type checking |
| `run-ruff` | boolean | `true` | Run ruff linting |
| `coverage-threshold` | number | `80` | Minimum coverage % |
| `package-manager` | string | `poetry` | poetry, pip, or uv |

### release.yml

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `dry-run` | boolean | `false` | Skip actual publish |
| `language` | string | required | rust, python, or node |

### security.yml

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `language` | string | `auto` | rust, python, node, auto |
| `fail-on-vulnerability` | boolean | `true` | Fail on findings |
| `severity-threshold` | string | `medium` | low, medium, high, critical |

## Required Secrets

| Secret | Used By | Purpose |
|--------|---------|---------|
| `CRATES_TOKEN` | release.yml | Publish to crates.io |
| `PYPI_TOKEN` | release.yml | Publish to PyPI |
| `NPM_TOKEN` | release.yml | Publish to npm |
| `CODECOV_TOKEN` | *-ci.yml | Upload coverage (optional) |

## Best Practices

1. **Pin to tags** for stability:
   ```yaml
   uses: sebastienrousseau/pipelines/.github/workflows/rust-ci.yml@v1.0.0
   ```

2. **Enable all quality checks** in CI

3. **Run security scans** on schedule and PRs

4. **Set appropriate coverage thresholds**

## License

Dual-licensed under [MIT](LICENSE-MIT) and [Apache-2.0](LICENSE-APACHE).
