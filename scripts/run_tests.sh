#!/usr/bin/env bash
# ==============================================================================
# Gin Web Framework for Aura Language
# scripts/run_tests.sh - Automated Test Runner & Verification Suite
# ==============================================================================

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR"

echo "================================================================================"
echo "  🚀 RUNNING FULL TEST SUITE FOR GIN AURA FRAMEWORK"
echo "================================================================================"
echo "Working directory: $DIR"
echo "Aura version:      $(aura version 2>&1 | head -n 1)"
echo ""

SUITES=(
  "tests/router_test.aura"
  "tests/context_test.aura"
  "tests/binding_test.aura"
  "tests/middleware_test.aura"
  "tests/gin_e2e_test.aura"
)

EXAMPLES=(
  "examples/quickstart.aura"
  "examples/rest_api.aura"
  "examples/middleware_demo.aura"
  "examples/csp_streaming.aura"
  "examples/main.aura"
)

TOTAL_SUITES=${#SUITES[@]}
PASSED_SUITES=0
FAILED_SUITES=0

echo ">>> Phase 1: Unit & Integration Test Suites Execution"
echo "--------------------------------------------------------------------------------"

for suite in "${SUITES[@]}"; do
  echo "▶ Running test suite: $suite"
  if aura run "$suite"; then
    echo "✔ PASSED: $suite"
    echo ""
    PASSED_SUITES=$((PASSED_SUITES + 1))
  else
    echo "✘ FAILED: $suite"
    echo ""
    FAILED_SUITES=$((FAILED_SUITES + 1))
  fi
done

echo ">>> Phase 2: Static Verification of Showcase Examples"
echo "--------------------------------------------------------------------------------"

CHECK_PASSED=0
CHECK_FAILED=0

for ex in "${EXAMPLES[@]}"; do
  echo -n "• Type checking $ex ... "
  if aura check "$ex" > /dev/null 2>&1; then
    echo "OK"
    CHECK_PASSED=$((CHECK_PASSED + 1))
  else
    echo "FAIL"
    CHECK_FAILED=$((CHECK_FAILED + 1))
  fi
done

echo ""
echo "================================================================================"
echo "  📊 TEST EXECUTION SUMMARY"
echo "================================================================================"
echo "  • Test Suites:    $PASSED_SUITES / $TOTAL_SUITES passed ($FAILED_SUITES failed)"
echo "  • Examples Check: $CHECK_PASSED / ${#EXAMPLES[@]} passed ($CHECK_FAILED failed)"
echo "================================================================================"

if [ "$FAILED_SUITES" -gt 0 ] || [ "$CHECK_FAILED" -gt 0 ]; then
  echo "❌ TEST SUITE FAILED"
  exit 1
else
  echo "✅ ALL GIN AURA TESTS AND EXAMPLES PASSED PERFECTLY!"
  exit 0
fi
