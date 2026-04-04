#!/usr/bin/env bash
# Comprehensive validation suite for the pipelines repository.
# This is the "unit test" for a workflow-only repo.
# Run: bash tests/validate.sh
set -euo pipefail

PASS=0
FAIL=0
WORKFLOWS=".github/workflows"

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  FAIL: $1"; }
check() { if eval "$2" >/dev/null 2>&1; then pass "$1"; else fail "$1"; fi; }

echo "=== 1. YAML Validation ==="
check "yamllint workflows" "yamllint -d '{extends: default, rules: {line-length: {max: 200}, truthy: disable, comments-indentation: disable, document-start: disable}}' $WORKFLOWS/ templates/"
check "yamllint examples" "yamllint -d '{extends: default, rules: {line-length: {max: 200}, truthy: disable, comments-indentation: disable, document-start: disable}}' examples/"

echo ""
echo "=== 2. actionlint ==="
check "actionlint passes" "actionlint"

echo ""
echo "=== 3. Supply Chain: SHA Pinning ==="
check "no mutable @v tags in workflows" "! grep -r '@v' $WORKFLOWS/"
check "no @master tags (except comments)" "! grep -P 'uses:.*@master(?!\s)' $WORKFLOWS/"

echo ""
echo "=== 4. Permissions Lockdown ==="
for f in "$WORKFLOWS"/*.yml; do
  name=$(basename "$f")
  check "permissions: {} in $name" "grep -q '^permissions: {}' '$f'"
done

echo ""
echo "=== 5. Job-Level Permissions ==="
for f in "$WORKFLOWS"/*.yml; do
  name=$(basename "$f")
  # Every workflow_call workflow should have job-level permissions
  if grep -q 'workflow_call' "$f"; then
    check "job permissions in $name" "grep -q '    permissions:' '$f'"
  fi
done

echo ""
echo "=== 6. Timeouts ==="
for f in "$WORKFLOWS"/*.yml; do
  name=$(basename "$f")
  if grep -q 'runs-on:' "$f"; then
    check "timeout-minutes in $name" "grep -q 'timeout-minutes' '$f'"
  fi
done

echo ""
echo "=== 7. Shallow Clones ==="
for f in "$WORKFLOWS"/*.yml; do
  name=$(basename "$f")
  if grep -q 'actions/checkout' "$f"; then
    check "persist-credentials: false in $name" "grep -q 'persist-credentials: false' '$f'"
  fi
done

echo ""
echo "=== 8. Required Files ==="
check "SECURITY.md exists" "test -f SECURITY.md"
check "CHANGELOG.md exists" "test -f CHANGELOG.md"
check "CONTRIBUTING.md exists" "test -f CONTRIBUTING.md"
check "README.md exists" "test -f README.md"
check "LICENSE-MIT exists" "test -f LICENSE-MIT"
check "LICENSE-APACHE exists" "test -f LICENSE-APACHE"

echo ""
echo "=== 9. Workflow Coverage ==="
check "rust-ci.yml exists" "test -f $WORKFLOWS/rust-ci.yml"
check "python-ci.yml exists" "test -f $WORKFLOWS/python-ci.yml"
check "node-ci.yml exists" "test -f $WORKFLOWS/node-ci.yml"
check "go-ci.yml exists" "test -f $WORKFLOWS/go-ci.yml"
check "release.yml exists" "test -f $WORKFLOWS/release.yml"
check "security.yml exists" "test -f $WORKFLOWS/security.yml"
check "docker.yml exists" "test -f $WORKFLOWS/docker.yml"
check "docs.yml exists" "test -f $WORKFLOWS/docs.yml"
check "labeler.yml exists" "test -f $WORKFLOWS/labeler.yml"
check "stale.yml exists" "test -f $WORKFLOWS/stale.yml"
check "validate.yml exists" "test -f $WORKFLOWS/validate.yml"
check "scorecard.yml exists" "test -f $WORKFLOWS/scorecard.yml"

echo ""
echo "=== 10. Supply Chain Features ==="
check "attest-build-provenance in release.yml" "grep -q 'attest-build-provenance' $WORKFLOWS/release.yml"
check "cosign in docker.yml" "grep -q 'cosign' $WORKFLOWS/docker.yml"
check "pypi-publish in release.yml" "grep -q 'pypi-publish' $WORKFLOWS/release.yml"
check "--provenance in release.yml" "grep -q '\-\-provenance' $WORKFLOWS/release.yml"
check "sbom-action in release.yml" "grep -q 'sbom-action' $WORKFLOWS/release.yml"
check "sbom-action in docker.yml" "grep -q 'sbom-action' $WORKFLOWS/docker.yml"
check "scorecard-action in scorecard.yml" "grep -q 'scorecard-action' $WORKFLOWS/scorecard.yml"

echo ""
echo "=== 11. ARM64 Runner Support ==="
for f in rust-ci.yml python-ci.yml node-ci.yml go-ci.yml security.yml; do
  check "runner input in $f" "grep -q 'runner:' $WORKFLOWS/$f"
done

echo ""
echo "=== 12. Examples ==="
check "examples/ has 5+ files" "test \$(ls examples/*.yml 2>/dev/null | wc -l) -ge 5"

echo ""
echo "=== 13. Templates ==="
check "dependabot.yml has gomod" "grep -q 'gomod' templates/dependabot.yml"
check "labeler.yml has go patterns" "grep -q '\\*\\*/\\*.go' templates/labeler.yml"

echo ""
echo "==============================="
echo "Results: $PASS passed, $FAIL failed"
echo "==============================="
[ "$FAIL" -eq 0 ] && echo "ALL TESTS PASSED" || exit 1
