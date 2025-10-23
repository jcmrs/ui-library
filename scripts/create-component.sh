#!/bin/bash

# create-component.sh - Automated component scaffolding
# Part of Phase 1.2: Component Scaffolding System
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
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="${PROJECT_ROOT}/scripts/templates"

# Function: Print colored message
print_message() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function: Print usage
print_usage() {
    cat <<EOF
Usage: ./scripts/create-component.sh <component-name> <category> [options]

Arguments:
  component-name    Name of the component (e.g., Button, Modal)
  category          Component category: base, application, foundations, internal

Options:
  --skip-story     Skip creating Storybook story
  --skip-test      Skip creating test file
  --skip-patterns  Skip creating patterns documentation

Examples:
  ./scripts/create-component.sh Button base
  ./scripts/create-component.sh Modal application --skip-test
  ./scripts/create-component.sh ColorPalette foundations

Categories:
  base         - Primitive UI components (Button, Input, etc.)
  application  - Complex components (Modal, Table, etc.)
  foundations  - Design system foundations (Colors, Typography)
  internal     - Internal utilities and shared logic
EOF
}

# Function: Validate component name
validate_component_name() {
    local name=$1

    # Check if name is provided
    if [ -z "$name" ]; then
        print_message "$RED" "✗ Component name is required"
        print_usage
        exit 1
    fi

    # Check if name starts with uppercase
    if [[ ! "$name" =~ ^[A-Z] ]]; then
        print_message "$RED" "✗ Component name must start with an uppercase letter"
        exit 1
    fi

    # Check if name is valid identifier (alphanumeric only)
    if [[ ! "$name" =~ ^[A-Za-z][A-Za-z0-9]*$ ]]; then
        print_message "$RED" "✗ Component name must be a valid identifier (letters and numbers only)"
        exit 1
    fi
}

# Function: Validate category
validate_category() {
    local category=$1

    if [ -z "$category" ]; then
        print_message "$RED" "✗ Category is required"
        print_usage
        exit 1
    fi

    case "$category" in
        base|application|foundations|internal)
            # Valid category
            ;;
        *)
            print_message "$RED" "✗ Invalid category: $category"
            print_message "$YELLOW" "Valid categories: base, application, foundations, internal"
            exit 1
            ;;
    esac
}

# Function: Check if component already exists
check_existing_component() {
    local component_name=$1
    local category=$2
    local component_dir="${PROJECT_ROOT}/src/components/${category}/${component_name}"

    if [ -d "$component_dir" ]; then
        print_message "$YELLOW" "⚠ Component already exists: $component_dir"
        read -p "Overwrite existing component? (y/N): " -n 1 -r
        echo ""

        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_message "$YELLOW" "Component creation cancelled"
            exit 0
        fi

        print_message "$BLUE" "→ Will overwrite existing component"
    fi
}

# Function: Create directory structure
create_directories() {
    local component_name=$1
    local category=$2
    local component_dir="${PROJECT_ROOT}/src/components/${category}/${component_name}"

    print_message "$BLUE" "→ Creating directory: $component_dir"
    mkdir -p "$component_dir"
    print_message "$GREEN" "✓ Directory created"
}

# Function: Copy template with substitutions
copy_template() {
    local template_file=$1
    local output_file=$2
    local component_name=$3
    local category=$4

    print_message "$BLUE" "→ Creating $(basename "$output_file")"

    # Get current date
    local date=$(date +%Y-%m-%d)

    # Perform substitutions
    sed -e "s/{{COMPONENT_NAME}}/${component_name}/g" \
        -e "s/{{CATEGORY}}/${category}/g" \
        -e "s/{{DATE}}/${date}/g" \
        "$template_file" > "$output_file"

    print_message "$GREEN" "✓ Created $(basename "$output_file")"
}

# Function: Create all component files
create_component_files() {
    local component_name=$1
    local category=$2
    local skip_story=$3
    local skip_test=$4
    local skip_patterns=$5

    local component_dir="${PROJECT_ROOT}/src/components/${category}/${component_name}"

    # Create main component file
    copy_template \
        "${TEMPLATES_DIR}/component.tsx.template" \
        "${component_dir}/${component_name}.tsx" \
        "$component_name" \
        "$category"

    # Create Storybook story (unless skipped)
    if [ "$skip_story" != "true" ]; then
        copy_template \
            "${TEMPLATES_DIR}/component.story.tsx.template" \
            "${component_dir}/${component_name}.stories.tsx" \
            "$component_name" \
            "$category"
    fi

    # Create test file (unless skipped)
    if [ "$skip_test" != "true" ]; then
        copy_template \
            "${TEMPLATES_DIR}/component.test.tsx.template" \
            "${component_dir}/${component_name}.test.tsx" \
            "$component_name" \
            "$category"
    fi

    # Create patterns documentation (unless skipped)
    if [ "$skip_patterns" != "true" ]; then
        copy_template \
            "${TEMPLATES_DIR}/component.patterns.md.template" \
            "${component_dir}/${component_name}.patterns.md" \
            "$component_name" \
            "$category"
    fi

    # Create checklist
    copy_template \
        "${TEMPLATES_DIR}/component.checklist.json.template" \
        "${component_dir}/${component_name}.checklist.json" \
        "$component_name" \
        "$category"

    # Create index.ts (barrel export)
    copy_template \
        "${TEMPLATES_DIR}/index.ts.template" \
        "${component_dir}/index.ts" \
        "$component_name" \
        "$category"
}

# Function: Update category index
update_category_index() {
    local component_name=$1
    local category=$2
    local category_index="${PROJECT_ROOT}/src/components/${category}/index.ts"

    print_message "$BLUE" "→ Updating category index: ${category}/index.ts"

    # Check if export already exists
    if grep -q "export.*from.*'./${component_name}'" "$category_index" 2>/dev/null; then
        print_message "$YELLOW" "⚠ Export already exists in category index"
        return
    fi

    # Add export statement (replace the empty export if it exists)
    if grep -q "export {};" "$category_index"; then
        # Replace empty export with actual export
        sed -i "/export {};/i export * from './${component_name}';" "$category_index"
        sed -i "/export {};/d" "$category_index"
    else
        # Append export
        echo "export * from './${component_name}';" >> "$category_index"
    fi

    print_message "$GREEN" "✓ Category index updated"
}

# Function: Display next steps
display_next_steps() {
    local component_name=$1
    local category=$2
    local component_dir="src/components/${category}/${component_name}"

    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$GREEN" "✅ Component ${component_name} created successfully!"
    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Files created:"
    echo "  📄 ${component_dir}/${component_name}.tsx"
    echo "  📖 ${component_dir}/${component_name}.stories.tsx"
    echo "  🧪 ${component_dir}/${component_name}.test.tsx"
    echo "  📝 ${component_dir}/${component_name}.patterns.md"
    echo "  ✓ ${component_dir}/${component_name}.checklist.json"
    echo "  📦 ${component_dir}/index.ts"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Implement the component in ${component_name}.tsx"
    echo "  2. Add Storybook stories for all variants"
    echo "  3. Write comprehensive tests"
    echo "  4. Document usage patterns in ${component_name}.patterns.md"
    echo "  5. Run: npm run storybook (to view component)"
    echo "  6. Run: npm test (to run tests)"
    echo "  7. Run: npm run type-check && npm run lint"
    echo ""
    echo "Import the component:"
    echo "  import { ${component_name} } from '@/components/${category}/${component_name}';"
    echo ""
    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
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
    shift 2

    # Parse options
    SKIP_STORY="false"
    SKIP_TEST="false"
    SKIP_PATTERNS="false"

    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-story)
                SKIP_STORY="true"
                shift
                ;;
            --skip-test)
                SKIP_TEST="true"
                shift
                ;;
            --skip-patterns)
                SKIP_PATTERNS="true"
                shift
                ;;
            *)
                print_message "$RED" "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done

    # Header
    clear
    echo ""
    print_message "$CYAN" "╔═══════════════════════════════════════════════════════╗"
    print_message "$CYAN" "║          COMPONENT SCAFFOLDING                        ║"
    print_message "$CYAN" "╚═══════════════════════════════════════════════════════╝"
    echo ""

    # Validation
    print_message "$BLUE" "→ Validating inputs..."
    validate_component_name "$COMPONENT_NAME"
    validate_category "$CATEGORY"
    check_existing_component "$COMPONENT_NAME" "$CATEGORY"
    print_message "$GREEN" "✓ Validation passed"
    echo ""

    # Create component
    print_message "$CYAN" "Creating component: $COMPONENT_NAME ($CATEGORY)"
    echo ""

    create_directories "$COMPONENT_NAME" "$CATEGORY"
    create_component_files "$COMPONENT_NAME" "$CATEGORY" "$SKIP_STORY" "$SKIP_TEST" "$SKIP_PATTERNS"
    update_category_index "$COMPONENT_NAME" "$CATEGORY"

    echo ""
    display_next_steps "$COMPONENT_NAME" "$CATEGORY"
}

# Run main function
main "$@"
