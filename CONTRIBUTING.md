# Contributing to Pipelines

## Adding or Updating Actions

**All GitHub Actions must be pinned by commit SHA**, not mutable tags. This prevents supply chain attacks.

```yaml
# Bad — mutable tag, can be changed by attacker
- uses: actions/checkout@v4

# Good — immutable SHA with version comment
- uses: actions/checkout@34e114876b0b11c390a56381ad16ebd13914f8d5 # v4
```

To resolve the SHA for an action tag:

```bash
gh api repos/actions/checkout/commits/v4 --jq '.sha'
```

## Workflow Requirements

Every reusable workflow must:

1. Declare `permissions: {}` at the top level
2. Declare minimal permissions at the job level
3. Use `fetch-depth: 1`, `persist-credentials: false`, `show-progress: false` on all checkouts
4. Include a `timeout-minutes` on every job
5. Pass `actionlint` and `yamllint` validation

## Testing

Before submitting a PR, validate locally:

```bash
# Install tools
brew install actionlint
pip install yamllint

# Validate
actionlint
yamllint -d '{extends: default, rules: {line-length: {max: 200}, truthy: disable, comments-indentation: disable, document-start: disable}}' .github/workflows/ templates/

# Verify no mutable tags remain
grep -r '@v' .github/workflows/ && echo "FAIL: mutable tags found" || echo "PASS"
```

## Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` new workflow or feature
- `fix:` bug fix
- `security:` security-related change
- `docs:` documentation only
- `chore:` maintenance (SHA updates, dependency bumps)

## Pull Request Process

1. Create a branch from `main`
2. Make changes following the requirements above
3. Ensure all validation passes
4. Submit a PR with a clear description
5. Wait for review and CI checks
