#!/bin/bash

# validate-component.sh - Component validation and checklist verification
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
  component-name    Name of the component to validate
  category          Component category: base, application, foundations, internal

Examples:
  ./scripts/validate-component.sh Button base
  ./scripts/validate-component.sh Modal application
  ./scripts/validate-component.sh ColorPalette foundations

This script validates that a component:
  - Has all required files
  - Passes TypeScript type checking
  - Passes ESLint validation
  - Has proper test coverage
  - Meets accessibility standards
  - Has complete documentation
EOF
}

# Function: Validate required files
validate_files() {
    local component_name=$1
    local category=$2
    local component_dir="${PROJECT_ROOT}/src/components/${category}/${component_name}"

    print_section "📋 REQUIRED FILES"
    echo ""

    local required_files=(
        "${component_name}.tsx:Component implementation"
        "${component_name}.stories.tsx:Storybook stories"
        "${component_name}.test.tsx:Component tests"
        "${component_name}.patterns.md:Usage patterns documentation"
        "${component_name}.checklist.json:Validation checklist"
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
    local component_dir="src/components/${category}/${component_name}"

    print_section "📘 TYPESCRIPT VALIDATION"
    echo ""

    cd "$PROJECT_ROOT"

    print_message "$BLUE" "→ Running TypeScript type check..."
    local output=$(npm run type-check 2>&1)
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        check_item "TypeScript compilation" "pass" "No type errors"
    else
        # Check if errors are in this component
        if echo "$output" | grep -q "$component_dir"; then
            local error_count=$(echo "$output" | grep -c "$component_dir" || echo "0")
            check_item "TypeScript compilation" "fail" "${error_count} type error(s) in component"
        else
            check_item "TypeScript compilation" "pass" "No type errors in component"
        fi
    fi

    echo ""
}

# Function: Validate ESLint
validate_eslint() {
    local component_name=$1
    local category=$2
    local component_dir="src/components/${category}/${component_name}"

    print_section "🔍 ESLINT VALIDATION"
    echo ""

    cd "$PROJECT_ROOT"

    print_message "$BLUE" "→ Running ESLint..."
    local output=$(npm run lint:check 2>&1 | grep "$component_dir" || true)

    if [ -z "$output" ]; then
        check_item "ESLint" "pass" "No linting errors"
    else
        local error_count=$(echo "$output" | grep -c "error" || echo "0")
        if [ "$error_count" -eq 0 ]; then
            check_item "ESLint" "warn" "Warnings found"
        else
            check_item "ESLint" "fail" "Linting errors found"
        fi
    fi

    echo ""
}

# Function: Validate tests exist
validate_tests() {
    local component_name=$1
    local category=$2
    local component_file="${PROJECT_ROOT}/src/components/${category}/${component_name}/${component_name}.test.tsx"

    print_section "🧪 TEST VALIDATION"
    echo ""

    if [ ! -f "$component_file" ]; then
        check_item "Test file exists" "fail" "No test file found"
        echo ""
        return
    fi

    check_item "Test file exists" "pass"

    # Check for basic test suites
    local test_content=$(cat "$component_file")

    if echo "$test_content" | grep -q "describe.*Rendering"; then
        check_item "Rendering tests" "pass" "Has rendering test suite"
    else
        check_item "Rendering tests" "warn" "Missing rendering test suite"
    fi

    if echo "$test_content" | grep -q "describe.*Accessibility"; then
        check_item "Accessibility tests" "pass" "Has accessibility test suite"
    else
        check_item "Accessibility tests" "warn" "Missing accessibility test suite"
    fi

    if echo "$test_content" | grep -q "describe.*Interactions"; then
        check_item "Interaction tests" "pass" "Has interaction test suite"
    else
        check_item "Interaction tests" "warn" "Missing interaction test suite"
    fi

    echo ""
}

# Function: Validate Storybook stories
validate_storybook() {
    local component_name=$1
    local category=$2
    local story_file="${PROJECT_ROOT}/src/components/${category}/${component_name}/${component_name}.stories.tsx"

    print_section "📖 STORYBOOK VALIDATION"
    echo ""

    if [ ! -f "$story_file" ]; then
        check_item "Story file exists" "fail" "No story file found"
        echo ""
        return
    fi

    check_item "Story file exists" "pass"

    # Check for required stories
    local story_content=$(cat "$story_file")

    if echo "$story_content" | grep -q "export const Default"; then
        check_item "Default story" "pass" "Has Default story"
    else
        check_item "Default story" "fail" "Missing Default story"
    fi

    if echo "$story_content" | grep -q "export const.*Interactive"; then
        check_item "Interactive story" "pass" "Has Interactive story"
    else
        check_item "Interactive story" "warn" "Missing Interactive story"
    fi

    if echo "$story_content" | grep -q "a11y:"; then
        check_item "Accessibility addon" "pass" "Configured a11y addon"
    else
        check_item "Accessibility addon" "warn" "Missing a11y configuration"
    fi

    echo ""
}

# Function: Validate documentation
validate_documentation() {
    local component_name=$1
    local category=$2
    local patterns_file="${PROJECT_ROOT}/src/components/${category}/${component_name}/${component_name}.patterns.md"

    print_section "📝 DOCUMENTATION VALIDATION"
    echo ""

    if [ ! -f "$patterns_file" ]; then
        check_item "Patterns documentation" "fail" "No patterns.md file found"
        echo ""
        return
    fi

    check_item "Patterns documentation exists" "pass"

    # Check for required sections
    local doc_content=$(cat "$patterns_file")

    if echo "$doc_content" | grep -q "## Basic Usage"; then
        check_item "Basic Usage section" "pass"
    else
        check_item "Basic Usage section" "fail" "Missing Basic Usage section"
    fi

    if echo "$doc_content" | grep -q "## Common Patterns"; then
        check_item "Common Patterns section" "pass"
    else
        check_item "Common Patterns section" "warn" "Missing Common Patterns section"
    fi

    if echo "$doc_content" | grep -q "## Accessibility Guidelines"; then
        check_item "Accessibility Guidelines" "pass"
    else
        check_item "Accessibility Guidelines" "warn" "Missing Accessibility Guidelines"
    fi

    if echo "$doc_content" | grep -q "## AI Usage Guidance"; then
        check_item "AI Usage Guidance" "pass"
    else
        check_item "AI Usage Guidance" "warn" "Missing AI Usage Guidance"
    fi

    echo ""
}

# Function: Validate component exports
validate_exports() {
    local component_name=$1
    local category=$2
    local component_index="${PROJECT_ROOT}/src/components/${category}/${component_name}/index.ts"
    local category_index="${PROJECT_ROOT}/src/components/${category}/index.ts"

    print_section "📦 EXPORT VALIDATION"
    echo ""

    # Check component index.ts
    if [ -f "$component_index" ]; then
        if grep -q "export.*from.*'./${component_name}'" "$component_index"; then
            check_item "Component barrel export" "pass" "index.ts exports component"
        else
            check_item "Component barrel export" "fail" "index.ts missing export"
        fi
    else
        check_item "Component barrel export" "fail" "No index.ts found"
    fi

    # Check category index.ts
    if [ -f "$category_index" ]; then
        if grep -q "export.*from.*'./${component_name}'" "$category_index"; then
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
        echo "  4. Review checklist: src/components/${category}/${component_name}/${component_name}.checklist.json"
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

    COMPONENT_NAME=$1
    CATEGORY=$2

    # Validate component directory exists
    COMPONENT_DIR="${PROJECT_ROOT}/src/components/${CATEGORY}/${COMPONENT_NAME}"
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
    validate_files "$COMPONENT_NAME" "$CATEGORY"
    validate_typescript "$COMPONENT_NAME" "$CATEGORY"
    validate_eslint "$COMPONENT_NAME" "$CATEGORY"
    validate_tests "$COMPONENT_NAME" "$CATEGORY"
    validate_storybook "$COMPONENT_NAME" "$CATEGORY"
    validate_documentation "$COMPONENT_NAME" "$CATEGORY"
    validate_exports "$COMPONENT_NAME" "$CATEGORY"
    generate_summary "$COMPONENT_NAME" "$CATEGORY"

    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Exit with error code if there are errors
    exit $ERRORS
}

# Run main function
main "$@"
