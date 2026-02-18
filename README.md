# Pipelines

Reusable CI/CD templates and GitHub Actions workflows for the Sebastien Rousseau ecosystem.

## Overview

Pipelines provides standardized continuous integration and deployment configurations that ensure consistent quality across all projects.

## Templates

- `rust-ci.yml` - Rust project CI with testing, linting, and security scanning
- `python-ci.yml` - Python project CI with pytest and coverage
- `release.yml` - Automated release workflow with changelog generation
- `security.yml` - Security scanning and dependency auditing

## Usage

```yaml
jobs:
  ci:
    uses: sebastienrousseau/pipelines/.github/workflows/rust-ci.yml@main
```

## License

Dual-licensed under MIT and Apache-2.0.
