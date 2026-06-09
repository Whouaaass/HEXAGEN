#!/bin/bash
# ============================================================
# HEXAGEN Metrics Evaluation — Command-line Runner
# Requires: Eclipse Modeling Tools with Epsilon installed.
#
# Usage:
#   ./tests/run-metrics.sh [eclipse-home]
#
# If eclipse-home is omitted, it searches common locations.
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
WORKSPACE_DIR="$(cd "$PROJECT_DIR/.." && pwd)"

# Find Eclipse
ECLIPSE=""
for dir in "$1" "/opt/eclipse" "/usr/lib/eclipse" "$HOME/eclipse" \
           "/c/Program Files/Eclipse" "/Applications/Eclipse.app/Contents/MacOS"; do
    if [ -f "$dir/eclipse" ]; then
        ECLIPSE="$dir/eclipse"
        break
    elif [ -f "$dir/eclipse.exe" ]; then
        ECLIPSE="$dir/eclipse.exe"
        break
    fi
done

if [ -z "$ECLIPSE" ]; then
    echo "Error: Eclipse not found. Set ECLIPSE_HOME or pass as first argument."
    exit 1
fi

echo "Using Eclipse: $ECLIPSE"
echo "Project: $PROJECT_DIR"
echo ""

# Run each metric
run_evl() {
    local name="$1"
    local evl_file="$2"
    local model_file="$3"
    local metamodel_uri="$4"
    local metamodel_file="$5"

    echo "=== Running: $name ==="
    "$ECLIPSE" -nosplash -application org.eclipse.epsilon.evl.launch.EvlHeadlessApplication \
        -data "$WORKSPACE_DIR" \
        -model "SMM:$model_file:$metamodel_uri" \
        -metamodel "$metamodel_file" \
        -script "$evl_file" 2>&1 || true
    echo ""
}

run_eol() {
    local name="$1"
    local eol_file="$2"
    shift 2
    local model_args=()
    local metamodel_args=()
    while [ $# -gt 0 ]; do
        model_args+=("-model" "$1")
        metamodel_args+=("-metamodel" "$2")
        shift 2
    done

    echo "=== Running: $name ==="
    "$ECLIPSE" -nosplash -application org.eclipse.epsilon.eol.launch.EolHeadlessApplication \
        -data "$WORKSPACE_DIR" \
        "${model_args[@]}" \
        "${metamodel_args[@]}" \
        -script "$eol_file" 2>&1 || true
    echo ""
}

SMM_MODEL="$PROJECT_DIR/models/LibraryLoanSystem-smm-pure.xmi"
HMM_MODEL="$PROJECT_DIR/models/LibraryLoanSystem.xmi"
SMM_META="$PROJECT_DIR/models/smm.ecore"
HMM_META="$PROJECT_DIR/models/hmm.ecore"

echo "====== HEXAGEN Metrics Evaluation ======"
echo ""

# SC - Syntactic Correctness
run_evl "SC: Syntactic Correctness" \
    "$PROJECT_DIR/tests/metrics/sc.evl" \
    "$SMM_MODEL" "smm" "$SMM_META"

# SM - Structural Maintainability
run_evl "SM: Structural Maintainability" \
    "$PROJECT_DIR/tests/metrics/sm.evl" \
    "$SMM_MODEL" "smm" "$SMM_META"

# FC - Functional Completeness
run_eol "FC: Functional Completeness" \
    "$PROJECT_DIR/tests/metrics/fc.eol" \
    "SMM:$SMM_MODEL:smm" "$SMM_META"

# AF - Architectural Fidelity
run_eol "AF: Architectural Fidelity" \
    "$PROJECT_DIR/tests/metrics/af.eol" \
    "HMM:$HMM_MODEL:http://co.edu.unicauca.hexagen.hexagonal" "$HMM_META" \
    "SMM:$SMM_MODEL:smm" "$SMM_META"

# All Metrics
run_eol "ALL: Aggregate Report" \
    "$PROJECT_DIR/tests/metrics/evaluate-all.eol" \
    "HMM:$HMM_MODEL:http://co.edu.unicauca.hexagen.hexagonal" "$HMM_META" \
    "SMM:$SMM_MODEL:smm" "$SMM_META"

echo "====== Evaluation Complete ======"
