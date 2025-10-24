#!/bin/bash

# validate-component.sh - Component validation script
# Part of Phase 1.2: Component Scaffolding System
# See: scripts/README.md for usage details

set +e  # Don't exit on error - this is validation mode

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Counters
ERRORS=0
WARNINGS=0
CHECKS=0

# Function: Print colored message
print_message() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function: Print section
print_section() {
    echo ""
    print_message "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$MAGENTA" "$1"
    print_message "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Function: Check with status
check_item() {
    local label=$1
    local status=$2
    local detail=$3

    ((CHECKS++))

    printf "  %-60s " "$label"

    case $status in
        "pass")
            print_message "$GREEN" "✓ OK"
            ;;
        "warn")
            print_message "$YELLOW" "⚠ WARNING"
            ((WARNINGS++))
            ;;
        "fail")
            print_message "$RED" "✗ FAIL"
            ((ERRORS++))
            ;;
    esac

    if [ -n "$detail" ]; then
        echo "     $detail"
    fi
}

# Function: Print usage
print_usage() {
    cat <<EOF
Usage: ./scripts/validate-component.sh <component-name> <category>

Arguments:
  component-name    Name of the component to validate (PascalCase)
  category          Component category (base, application, marketing, pages/*)

Examples:
  ./scripts/validate-component.sh Button base
  ./scripts/validate-component.sh Modal application
  ./scripts/validate-component.sh HeroSection marketing
  ./scripts/validate-component.sh LoginPage pages/auth/login

This script validates that a component:
  - Has all required files
  - Passes TypeScript type checking
  - Passes ESLint validation
  - Has proper exports
EOF
}

# Function: Convert PascalCase to kebab-case
to_kebab_case() {
    echo "$1" | sed 's/\([A-Z]\)/-\1/g' | sed 's/^-//' | tr '[:upper:]' '[:lower:]'
}

# Function: Validate required files
validate_files() {
    local component_name=$1
    local component_name_kebab=$2
    local category=$3
    local component_dir="${PROJECT_ROOT}/src/components/${category}/${component_name_kebab}"

    print_section "📋 REQUIRED FILES"
    echo ""

    local required_files=(
        "${component_name_kebab}.tsx:Component implementation"
        "${component_name_kebab}.stories.tsx:Storybook stories"
        "${component_name_kebab}.test.tsx:Component tests"
        "${component_name_kebab}.patterns.md:Usage patterns documentation"
        "${component_name_kebab}.checklist.json:Validation checklist"
        "index.ts:Barrel export file"
    )

    for file_spec in "${required_files[@]}"; do
        local file="${file_spec%%:*}"
        local label="${file_spec##*:}"

        if [ -f "${component_dir}/${file}" ]; then
            check_item "$label" "pass" "$file"
        else
            check_item "$label" "fail" "File not found: $file"
        fi
    done

    echo ""
}

# Function: Validate TypeScript compilation
validate_typescript() {
    local component_name=$1
    local category=$2

    print_section "📘 TYPESCRIPT VALIDATION"
    echo ""

    cd "$PROJECT_ROOT"

    print_message "$BLUE" "→ Running TypeScript type check..."
    local output=$(npm run type-check 2>&1)
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        check_item "TypeScript compilation" "pass" "No type errors"
    else
        check_item "TypeScript compilation" "fail" "Type errors found"
    fi

    echo ""
}

# Function: Validate ESLint
validate_eslint() {
    local component_name=$1
    local category=$2

    print_section "🔍 ESLINT VALIDATION"
    echo ""

    cd "$PROJECT_ROOT"

    print_message "$BLUE" "→ Running ESLint..."
    local output=$(npm run lint:check 2>&1)
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        check_item "ESLint" "pass" "No linting errors"
    else
        check_item "ESLint" "warn" "Linting errors found (check output)"
    fi

    echo ""
}

# Function: Validate exports
validate_exports() {
    local component_name=$1
    local component_name_kebab=$2
    local category=$3
    local component_index="${PROJECT_ROOT}/src/components/${category}/${component_name_kebab}/index.ts"
    local category_index=""

    print_section "📦 EXPORT VALIDATION"
    echo ""

    # Determine category index path
    if [[ "$category" =~ ^pages/ ]]; then
        local page_path="${category#pages/}"
        category_index="${PROJECT_ROOT}/src/components/pages/${page_path}/index.ts"
    else
        category_index="${PROJECT_ROOT}/src/components/${category}/index.ts"
    fi

    # Check component index.ts
    if [ -f "$component_index" ]; then
        if grep -q "export.*${component_name}" "$component_index"; then
            check_item "Component barrel export" "pass" "index.ts exports component"
        else
            check_item "Component barrel export" "fail" "index.ts missing export"
        fi
    else
        check_item "Component barrel export" "fail" "No index.ts found"
    fi

    # Check category index.ts
    if [ -f "$category_index" ]; then
        if grep -q "export.*from.*'./${component_name_kebab}'" "$category_index"; then
            check_item "Category index export" "pass" "${category}/index.ts exports component"
        else
            check_item "Category index export" "warn" "${category}/index.ts missing export"
        fi
    else
        check_item "Category index export" "fail" "No ${category}/index.ts found"
    fi

    echo ""
}

# Function: Generate summary
generate_summary() {
    local component_name=$1
    local category=$2

    print_section "📊 VALIDATION SUMMARY"

    echo ""
    echo "  Component: ${component_name}"
    echo "  Category: ${category}"
    echo ""
    echo "  Total Checks: $CHECKS"
    echo "  Errors: $ERRORS"
    echo "  Warnings: $WARNINGS"
    echo "  Passed: $((CHECKS - ERRORS - WARNINGS))"
    echo ""

    if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
        print_message "$GREEN" "  ✅ Perfect! Component is fully validated."
    elif [ $ERRORS -eq 0 ]; then
        print_message "$YELLOW" "  ⚠️  Component is valid with minor warnings."
    else
        print_message "$RED" "  ❌ Component has errors that need to be fixed."
    fi

    echo ""

    # Provide actionable next steps
    if [ $ERRORS -gt 0 ] || [ $WARNINGS -gt 0 ]; then
        echo "Next steps:"
        echo ""
        if [ $ERRORS -gt 0 ]; then
            echo "  1. Fix all errors marked with ✗"
        fi
        if [ $WARNINGS -gt 0 ]; then
            echo "  2. Address warnings marked with ⚠"
        fi
        echo "  3. Run validation again to verify fixes"
        echo ""
    fi
}

# Main script
main() {
    # Parse arguments
    if [ $# -lt 2 ]; then
        print_usage
        exit 1
    fi

    local COMPONENT_NAME=$1
    local CATEGORY=$2
    local COMPONENT_NAME_KEBAB=$(to_kebab_case "$COMPONENT_NAME")

    # Validate component directory exists
    local COMPONENT_DIR="${PROJECT_ROOT}/src/components/${CATEGORY}/${COMPONENT_NAME_KEBAB}"
    if [ ! -d "$COMPONENT_DIR" ]; then
        print_message "$RED" "✗ Component not found: ${CATEGORY}/${COMPONENT_NAME}"
        echo "  Directory does not exist: $COMPONENT_DIR"
        exit 1
    fi

    # Header
    clear
    echo ""
    print_message "$CYAN" "╔═══════════════════════════════════════════════════════╗"
    print_message "$CYAN" "║          COMPONENT VALIDATION                         ║"
    print_message "$CYAN" "╚═══════════════════════════════════════════════════════╝"

    # Run validations
    validate_files "$COMPONENT_NAME" "$COMPONENT_NAME_KEBAB" "$CATEGORY"
    validate_typescript "$COMPONENT_NAME" "$CATEGORY"
    validate_eslint "$COMPONENT_NAME" "$CATEGORY"
    validate_exports "$COMPONENT_NAME" "$COMPONENT_NAME_KEBAB" "$CATEGORY"
    generate_summary "$COMPONENT_NAME" "$CATEGORY"

    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Exit with error code if there are errors
    exit $ERRORS
}

# Run main function
main "$@"
