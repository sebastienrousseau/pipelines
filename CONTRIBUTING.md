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

## Python Tool Locks

Every `pip install` in a workflow uses `--require-hashes` with a lock in
`requirements/`. The reusable workflows fetch these locks at their own
commit (`job.workflow_sha`), so they apply to callers too. To add or
update a tool, edit the `.in` file and regenerate its lock with the
command in the lock's header, for example:

```bash
uv pip compile --universal --generate-hashes --python-version 3.11 --exclude-newer YYYY-MM-DD requirements/poetry.in -o requirements/poetry.txt
```

Pick releases at least 14 days old: `--exclude-newer` is the date 14
days before today. The locks resolve for Python 3.11 and later; 3.9 and
3.10 are end-of-life and the fixed releases of several locked packages
no longer support them. The
`ruff-version` and `mypy-version` defaults in `python-ci.yml` must match
`requirements/ruff.txt` and `requirements/mypy.txt`; `tests/validate.sh`
checks both.

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
