#!/bin/bash

# setup-new-project.sh - Automated project initialization from templates
# Part of Phase 1.1: Project Setup Automation
# See: scripts/README.md for usage details

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TEMPLATES_DIR="${PROJECT_ROOT}/config-templates"
REQUIRED_NODE_VERSION="20.0.0"

# Function: Print colored message
print_message() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function: Print section
print_section() {
    echo ""
    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$CYAN" "$1"
    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Function: Check Node.js version
check_node_version() {
    print_message "$BLUE" "→ Checking Node.js version..."

    if ! command -v node &> /dev/null; then
        print_message "$RED" "✗ Node.js is not installed"
        echo "  Install Node.js ${REQUIRED_NODE_VERSION} or later from: https://nodejs.org/"
        exit 1
    fi

    local node_version=$(node -v | sed 's/v//')
    local required_major=$(echo "$REQUIRED_NODE_VERSION" | cut -d. -f1)
    local current_major=$(echo "$node_version" | cut -d. -f1)

    if [ "$current_major" -lt "$required_major" ]; then
        print_message "$RED" "✗ Node.js version too old"
        echo "  Required: >= ${REQUIRED_NODE_VERSION}"
        echo "  Current: ${node_version}"
        exit 1
    fi

    print_message "$GREEN" "✓ Node.js ${node_version} detected"
}

# Function: Check if in git repository
check_git_repository() {
    print_message "$BLUE" "→ Checking git repository..."

    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_message "$RED" "✗ Not a git repository"
        echo "  Initialize with: git init"
        exit 1
    fi

    print_message "$GREEN" "✓ Git repository detected"
}

# Function: Check for existing files
check_existing_files() {
    print_message "$BLUE" "→ Checking for existing configuration files..."

    local existing_files=()
    local config_files=(
        "package.json"
        "tsconfig.json"
        "eslint.config.js"
        "tailwind.config.ts"
        "vite.config.ts"
        ".prettierrc"
        ".storybook/main.ts"
        ".storybook/preview.ts"
    )

    for file in "${config_files[@]}"; do
        if [ -f "${PROJECT_ROOT}/${file}" ]; then
            existing_files+=("$file")
        fi
    done

    if [ ${#existing_files[@]} -gt 0 ]; then
        print_message "$YELLOW" "⚠ Found existing configuration files:"
        for file in "${existing_files[@]}"; do
            echo "    - $file"
        done
        echo ""
        read -p "Overwrite existing files? (y/N): " -n 1 -r
        echo ""

        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_message "$YELLOW" "Setup cancelled by user"
            exit 0
        fi

        print_message "$BLUE" "→ Will overwrite existing files"
    else
        print_message "$GREEN" "✓ No conflicting files found"
    fi
}

# Function: Gather project information
gather_project_info() {
    print_section "📝 PROJECT INFORMATION"

    echo ""
    read -p "Project name (default: ui-library): " PROJECT_NAME
    PROJECT_NAME=${PROJECT_NAME:-ui-library}

    read -p "Author name (default: $(git config user.name 2>/dev/null || echo 'Your Name')): " AUTHOR_NAME
    AUTHOR_NAME=${AUTHOR_NAME:-$(git config user.name 2>/dev/null || echo 'Your Name')}

    echo ""
    print_message "$GREEN" "✓ Project: $PROJECT_NAME"
    print_message "$GREEN" "✓ Author: $AUTHOR_NAME"
}

# Function: Copy template file with substitutions
copy_template() {
    local template=$1
    local destination=$2

    print_message "$BLUE" "→ Creating ${destination}..."

    # Create directory if needed
    mkdir -p "$(dirname "${PROJECT_ROOT}/${destination}")"

    # Copy template and perform substitutions
    sed -e "s/{{PROJECT_NAME}}/${PROJECT_NAME}/g" \
        -e "s/{{AUTHOR_NAME}}/${AUTHOR_NAME}/g" \
        "${TEMPLATES_DIR}/${template}" > "${PROJECT_ROOT}/${destination}"

    print_message "$GREEN" "✓ Created ${destination}"
}

# Function: Copy all configuration templates
copy_configurations() {
    print_section "📦 COPYING CONFIGURATION FILES"

    echo ""

    # Copy main config files
    copy_template "package.json.template" "package.json"
    copy_template "tsconfig.json.template" "tsconfig.json"
    copy_template "eslint.config.js.template" "eslint.config.js"
    copy_template "tailwind.config.ts.template" "tailwind.config.ts"
    copy_template "vite.config.ts.template" "vite.config.ts"
    copy_template ".prettierrc.template" ".prettierrc"

    # Copy Storybook config
    copy_template ".storybook/main.ts.template" ".storybook/main.ts"
    copy_template ".storybook/preview.ts.template" ".storybook/preview.ts"

    # Copy .gitignore if it doesn't exist
    if [ ! -f "${PROJECT_ROOT}/.gitignore" ]; then
        copy_template ".gitignore.template" ".gitignore"
    else
        print_message "$YELLOW" "⚠ .gitignore already exists - skipping"
    fi

    echo ""
    print_message "$GREEN" "✓ All configuration files created"
}

# Function: Create project structure
create_project_structure() {
    print_section "📁 CREATING PROJECT STRUCTURE"

    echo ""

    local directories=(
        "src"
        "src/components"
        "src/components/foundations"
        "src/components/base"
        "src/components/application"
        "src/components/internal"
        "src/components/shared-assets"
        "public"
    )

    for dir in "${directories[@]}"; do
        if [ ! -d "${PROJECT_ROOT}/${dir}" ]; then
            mkdir -p "${PROJECT_ROOT}/${dir}"
            print_message "$GREEN" "✓ Created ${dir}/"
        else
            print_message "$YELLOW" "⚠ ${dir}/ already exists"
        fi
    done

    # Create initial index files if they don't exist
    if [ ! -f "${PROJECT_ROOT}/src/index.ts" ]; then
        cat > "${PROJECT_ROOT}/src/index.ts" <<EOF
/**
 * UI Library - Main Entry Point
 * Export all components and utilities
 */

// Export foundation components
export * from './components/foundations';

// Export base components
export * from './components/base';

// Export application components
export * from './components/application';
EOF
        print_message "$GREEN" "✓ Created src/index.ts"
    fi

    if [ ! -f "${PROJECT_ROOT}/src/index.css" ]; then
        cat > "${PROJECT_ROOT}/src/index.css" <<EOF
@import 'tailwindcss';
EOF
        print_message "$GREEN" "✓ Created src/index.css"
    fi

    echo ""
    print_message "$GREEN" "✓ Project structure created"
}

# Function: Install dependencies
install_dependencies() {
    print_section "📦 INSTALLING DEPENDENCIES"

    echo ""
    print_message "$BLUE" "→ Installing npm packages (this may take a few minutes)..."

    cd "$PROJECT_ROOT"

    if npm install; then
        print_message "$GREEN" "✓ Dependencies installed successfully"
    else
        print_message "$RED" "✗ Failed to install dependencies"
        echo ""
        echo "Try running manually:"
        echo "  cd ${PROJECT_ROOT}"
        echo "  npm install"
        exit 1
    fi
}

# Function: Run initial validation
run_initial_validation() {
    print_section "✅ RUNNING INITIAL VALIDATION"

    echo ""

    # Type check
    print_message "$BLUE" "→ Running TypeScript type check..."
    if npm run type-check > /dev/null 2>&1; then
        print_message "$GREEN" "✓ Type check passed"
    else
        print_message "$YELLOW" "⚠ Type check warnings (expected for empty project)"
    fi

    # Lint check
    print_message "$BLUE" "→ Running ESLint..."
    if npm run lint:check > /dev/null 2>&1; then
        print_message "$GREEN" "✓ Lint check passed"
    else
        print_message "$YELLOW" "⚠ Lint warnings (expected for empty project)"
    fi

    echo ""
    print_message "$GREEN" "✓ Initial validation complete"
}

# Function: Display next steps
display_next_steps() {
    print_section "🎉 SETUP COMPLETE"

    echo ""
    print_message "$GREEN" "Your project is ready!"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Start Storybook development server:"
    echo "     npm run storybook"
    echo ""
    echo "  2. Start creating components in src/components/"
    echo ""
    echo "  3. Run quality checks:"
    echo "     npm run test"
    echo ""
    echo "  4. Validate setup:"
    echo "     ./scripts/setup/validate-setup.sh"
    echo ""
    echo "See .docs/ for detailed documentation."
    echo ""
}

# Main script
main() {
    clear

    echo ""
    print_message "$CYAN" "╔═══════════════════════════════════════════════════════╗"
    print_message "$CYAN" "║          PROJECT SETUP - UI LIBRARY                   ║"
    print_message "$CYAN" "╚═══════════════════════════════════════════════════════╝"

    print_section "🔍 PREREQUISITE CHECKS"
    echo ""
    check_node_version
    check_git_repository
    check_existing_files

    gather_project_info
    copy_configurations
    create_project_structure
    install_dependencies
    run_initial_validation
    display_next_steps

    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Run main function
main "$@"
