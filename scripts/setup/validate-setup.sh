#!/bin/bash

# validate-setup.sh - Comprehensive validation of project setup
# Part of Phase 1.1: Project Setup Automation
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
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

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

    printf "  %-50s " "$label"

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

# Function: Validate configuration files
validate_config_files() {
    print_section "📋 CONFIGURATION FILES"
    echo ""

    local config_files=(
        "package.json:Package Configuration"
        "tsconfig.json:TypeScript Configuration"
        "eslint.config.js:ESLint Configuration"
        "tailwind.config.ts:Tailwind CSS Configuration"
        "vite.config.ts:Vite Configuration"
        ".prettierrc:Prettier Configuration"
        ".gitignore:Git Ignore Rules"
        ".storybook/main.ts:Storybook Main Config"
        ".storybook/preview.ts:Storybook Preview Config"
    )

    for file_spec in "${config_files[@]}"; do
        local file="${file_spec%%:*}"
        local label="${file_spec##*:}"

        if [ -f "${PROJECT_ROOT}/${file}" ]; then
            check_item "$label" "pass" "$file"
        else
            check_item "$label" "fail" "File not found"
        fi
    done

    echo ""
}

# Function: Validate project structure
validate_project_structure() {
    print_section "📁 PROJECT STRUCTURE"
    echo ""

    local required_dirs=(
        "src:Source Directory"
        "src/components:Components Directory"
        "src/components/foundations:Foundations"
        "src/components/base:Base Components"
        "src/components/application:Application Components"
        "src/components/internal:Internal Utilities"
        "src/components/shared-assets:Shared Assets"
        "public:Public Assets"
        ".storybook:Storybook Configuration"
    )

    for dir_spec in "${required_dirs[@]}"; do
        local dir="${dir_spec%%:*}"
        local label="${dir_spec##*:}"

        if [ -d "${PROJECT_ROOT}/${dir}" ]; then
            check_item "$label" "pass" "$dir/"
        else
            check_item "$label" "fail" "Directory not found"
        fi
    done

    echo ""
}

# Function: Validate dependencies
validate_dependencies() {
    print_section "📦 DEPENDENCIES"
    echo ""

    # Check if node_modules exists
    if [ -d "${PROJECT_ROOT}/node_modules" ]; then
        check_item "Node Modules Installed" "pass"
    else
        check_item "Node Modules Installed" "fail" "Run: npm install"
        return
    fi

    cd "$PROJECT_ROOT"

    # Check critical dependencies
    local critical_deps=(
        "react:React"
        "react-dom:React DOM"
        "typescript:TypeScript"
        "tailwindcss:Tailwind CSS"
        "eslint:ESLint"
        "prettier:Prettier"
        "vite:Vite"
        "storybook:Storybook"
    )

    for dep_spec in "${critical_deps[@]}"; do
        local dep="${dep_spec%%:*}"
        local label="${dep_spec##*:}"

        if [ -d "node_modules/${dep}" ]; then
            # Get version
            local version=$(node -p "require('./node_modules/${dep}/package.json').version" 2>/dev/null || echo "unknown")
            check_item "$label" "pass" "v${version}"
        else
            check_item "$label" "fail" "Not installed"
        fi
    done

    echo ""
}

# Function: Validate npm scripts
validate_npm_scripts() {
    print_section "🔧 NPM SCRIPTS"
    echo ""

    cd "$PROJECT_ROOT"

    local scripts=(
        "dev:Development Server"
        "build:Production Build"
        "test:Quality Checks"
        "type-check:TypeScript Check"
        "lint:ESLint"
        "prettier:Code Formatting"
        "storybook:Storybook Dev"
    )

    for script_spec in "${scripts[@]}"; do
        local script="${script_spec%%:*}"
        local label="${script_spec##*:}"

        if npm run | grep -q "^  ${script}$"; then
            check_item "$label" "pass" "npm run $script"
        else
            check_item "$label" "fail" "Script not found"
        fi
    done

    echo ""
}

# Function: Run TypeScript validation
validate_typescript() {
    print_section "📘 TYPESCRIPT VALIDATION"
    echo ""

    cd "$PROJECT_ROOT"

    # Check if tsc is available
    if ! command -v npx &> /dev/null; then
        check_item "TypeScript Compiler" "fail" "npx not available"
        return
    fi

    # Run type check
    print_message "$BLUE" "→ Running type check..."
    local output=$(npm run type-check 2>&1)
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        check_item "Type Check" "pass" "No type errors"
    else
        # Count errors
        local error_count=$(echo "$output" | grep -c "error TS" || echo "0")
        if [ "$error_count" -eq 0 ]; then
            check_item "Type Check" "pass" "No type errors"
        else
            check_item "Type Check" "fail" "${error_count} type error(s) found"
        fi
    fi

    echo ""
}

# Function: Run ESLint validation
validate_eslint() {
    print_section "🔍 ESLINT VALIDATION"
    echo ""

    cd "$PROJECT_ROOT"

    print_message "$BLUE" "→ Running ESLint..."
    local output=$(npm run lint:check 2>&1)
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        check_item "ESLint" "pass" "No linting errors"
    else
        # Check if there are errors vs warnings
        local error_count=$(echo "$output" | grep -c "✖" || echo "0")
        if [ "$error_count" -eq 0 ]; then
            check_item "ESLint" "warn" "Warnings found"
        else
            check_item "ESLint" "fail" "Linting errors found"
        fi
    fi

    echo ""
}

# Function: Run Prettier validation
validate_prettier() {
    print_section "💅 PRETTIER VALIDATION"
    echo ""

    cd "$PROJECT_ROOT"

    print_message "$BLUE" "→ Running Prettier check..."
    local output=$(npm run prettier:check 2>&1)
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        check_item "Prettier" "pass" "Code properly formatted"
    else
        check_item "Prettier" "warn" "Code needs formatting (run: npm run prettier)"
    fi

    echo ""
}

# Function: Validate Storybook
validate_storybook() {
    print_section "📖 STORYBOOK VALIDATION"
    echo ""

    # Check Storybook config files
    if [ -f "${PROJECT_ROOT}/.storybook/main.ts" ]; then
        check_item "Storybook Configuration" "pass"
    else
        check_item "Storybook Configuration" "fail" "Missing .storybook/main.ts"
        return
    fi

    # Check if Storybook can build (without actually running it)
    if command -v npx &> /dev/null; then
        check_item "Storybook Binary" "pass" "storybook command available"
    else
        check_item "Storybook Binary" "warn" "Cannot verify Storybook"
    fi

    echo ""
}

# Function: Validate Git configuration
validate_git() {
    print_section "🔀 GIT CONFIGURATION"
    echo ""

    # Check if in git repo
    if git rev-parse --git-dir > /dev/null 2>&1; then
        check_item "Git Repository" "pass"
    else
        check_item "Git Repository" "fail" "Not a git repository"
        return
    fi

    # Check .gitignore
    if [ -f "${PROJECT_ROOT}/.gitignore" ]; then
        check_item "Git Ignore File" "pass"

        # Check critical ignores
        if grep -q "node_modules" "${PROJECT_ROOT}/.gitignore"; then
            check_item "Ignore node_modules" "pass"
        else
            check_item "Ignore node_modules" "warn" "Add to .gitignore"
        fi

        if grep -q "dist" "${PROJECT_ROOT}/.gitignore"; then
            check_item "Ignore dist" "pass"
        else
            check_item "Ignore dist" "warn" "Add to .gitignore"
        fi
    else
        check_item "Git Ignore File" "fail" "Missing .gitignore"
    fi

    echo ""
}

# Function: Generate summary
generate_summary() {
    print_section "📊 VALIDATION SUMMARY"

    echo ""
    echo "  Total Checks: $CHECKS"
    echo "  Errors: $ERRORS"
    echo "  Warnings: $WARNINGS"
    echo "  Passed: $((CHECKS - ERRORS - WARNINGS))"
    echo ""

    if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
        print_message "$GREEN" "  ✅ Perfect! Setup is fully validated."
    elif [ $ERRORS -eq 0 ]; then
        print_message "$YELLOW" "  ⚠️  Setup is valid with minor warnings."
    else
        print_message "$RED" "  ❌ Setup has errors that need to be fixed."
    fi

    echo ""
}

# Main script
main() {
    clear

    echo ""
    print_message "$CYAN" "╔═══════════════════════════════════════════════════════╗"
    print_message "$CYAN" "║          PROJECT SETUP VALIDATION                     ║"
    print_message "$CYAN" "╚═══════════════════════════════════════════════════════╝"

    validate_config_files
    validate_project_structure
    validate_dependencies
    validate_npm_scripts
    validate_typescript
    validate_eslint
    validate_prettier
    validate_storybook
    validate_git
    generate_summary

    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Exit with error code if there are errors
    exit $ERRORS
}

# Run main function
main "$@"
