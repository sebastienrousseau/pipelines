# Pipelines

Reusable CI/CD templates and GitHub Actions workflows for the Sebastien Rousseau ecosystem.

## Overview

Pipelines provides standardized continuous integration and deployment configurations that ensure consistent quality across all projects. Use these reusable workflows to maintain best practices without duplicating CI/CD code.

## Available Workflows

| Workflow | Purpose | Languages |
|----------|---------|-----------|
| `rust-ci.yml` | Build, test, lint, audit | Rust |
| `python-ci.yml` | Test, lint, type check, coverage | Python |
| `node-ci.yml` | Lint, type check, test, build | Node.js/TypeScript |
| `release.yml` | Automated releases | Rust, Python, Node |
| `security.yml` | Security scanning | All |
| `docker.yml` | Build and push Docker images | All |
| `docs.yml` | Build and deploy documentation | All |
| `labeler.yml` | Auto-label pull requests | All |
| `stale.yml` | Mark stale issues/PRs | All |

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

### Node.js Projects

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  ci:
    uses: sebastienrousseau/pipelines/.github/workflows/node-ci.yml@main
    with:
      node-version: "20"
      package-manager: "pnpm"
```

### Docker Builds

```yaml
# .github/workflows/docker.yml
name: Docker

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  docker:
    uses: sebastienrousseau/pipelines/.github/workflows/docker.yml@main
    with:
      image-name: my-app
      platforms: linux/amd64,linux/arm64
```

### Documentation

```yaml
# .github/workflows/docs.yml
name: Docs

on:
  push:
    branches: [main]

jobs:
  docs:
    uses: sebastienrousseau/pipelines/.github/workflows/docs.yml@main
    with:
      type: rust  # or python-mkdocs, python-sphinx, static
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

### PR Labeling

```yaml
# .github/workflows/labeler.yml
name: Labeler

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  label:
    uses: sebastienrousseau/pipelines/.github/workflows/labeler.yml@main
```

### Stale Issues

```yaml
# .github/workflows/stale.yml
name: Stale

on:
  schedule:
    - cron: '0 0 * * *'  # Daily

jobs:
  stale:
    uses: sebastienrousseau/pipelines/.github/workflows/stale.yml@main
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

### node-ci.yml

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `node-version` | string | `20` | Node.js version |
| `package-manager` | string | `pnpm` | npm, pnpm, or yarn |
| `run-lint` | boolean | `true` | Run linting |
| `run-typecheck` | boolean | `true` | Run type checking |
| `run-tests` | boolean | `true` | Run tests |
| `run-build` | boolean | `true` | Run build |

### docker.yml

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `image-name` | string | required | Docker image name |
| `dockerfile` | string | `Dockerfile` | Path to Dockerfile |
| `platforms` | string | `linux/amd64,linux/arm64` | Target platforms |
| `push` | boolean | `true` | Push to registry |
| `registry` | string | `ghcr.io` | Container registry |

### docs.yml

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `type` | string | required | rust, python-mkdocs, python-sphinx, static |
| `deploy` | boolean | `true` | Deploy to GitHub Pages |
| `working-directory` | string | `.` | Working directory |

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

## Templates

Copy these templates to your repository:

- `templates/dependabot.yml` → `.github/dependabot.yml`
- `templates/labeler.yml` → `.github/labeler.yml`

## Required Secrets

| Secret | Used By | Purpose |
|--------|---------|---------|
| `CRATES_TOKEN` | release.yml | Publish to crates.io |
| `PYPI_TOKEN` | release.yml | Publish to PyPI |
| `NPM_TOKEN` | release.yml | Publish to npm |
| `CODECOV_TOKEN` | *-ci.yml | Upload coverage (optional) |
| `DOCKER_USERNAME` | docker.yml | Docker Hub auth |
| `DOCKER_PASSWORD` | docker.yml | Docker Hub auth |

## Best Practices

1. **Pin to tags** for stability:
   ```yaml
   uses: sebastienrousseau/pipelines/.github/workflows/rust-ci.yml@v1.0.0
   ```

2. **Enable all quality checks** in CI

3. **Run security scans** on schedule and PRs

4. **Set appropriate coverage thresholds**

5. **Use Dependabot** for dependency updates

## License

Dual-licensed under [MIT](LICENSE-MIT) and [Apache-2.0](LICENSE-APACHE).
