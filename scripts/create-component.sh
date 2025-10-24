#!/bin/bash

# create-component.sh - Component scaffolding with variant support
# Part of Phase 1.2: Component Scaffolding System
# See: scripts/README.md for usage details

set -e  # Exit on error

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
TEMPLATES_DIR="${PROJECT_ROOT}/scripts/templates"

# Variables
COMPONENT_NAME=""
CATEGORY=""
VARIANTS=()
SKIP_STORY=false
SKIP_TEST=false
SKIP_PATTERNS=false

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

# Function: Print usage
print_usage() {
    cat <<EOF
Usage: ./scripts/create-component.sh <component-name> <category> [options]

Arguments:
  component-name    Name of the component (PascalCase, e.g., Button, HeroSection)
  category          Component category:
                    - base: Primitive UI components
                    - application: Dashboard/app UI components
                    - marketing: Marketing website sections
                    - pages/auth/login: Page templates (use full path)
                    - pages/marketing-pages/landing: Marketing page templates

Options:
  --with-variants <variant1,variant2,...>
                    Create component with variants (comma-separated)
                    Example: --with-variants social,app-store,utility

  --skip-story      Skip creating Storybook story file
  --skip-test       Skip creating test file
  --skip-patterns   Skip creating patterns documentation

Examples:
  # Simple base component
  ./scripts/create-component.sh Avatar base

  # Component with variants
  ./scripts/create-component.sh Buttons base --with-variants social,app-store,utility

  # Marketing section
  ./scripts/create-component.sh HeroSection marketing

  # Page template
  ./scripts/create-component.sh LoginPage pages/auth/login

  # Skip optional files
  ./scripts/create-component.sh Modal application --skip-story --skip-test

This script:
  - Creates component directory structure
  - Generates files from templates with variable substitution
  - Updates category index.ts for exports
  - Supports variant generation with base-components/
EOF
}

# Function: Convert PascalCase to kebab-case
to_kebab_case() {
    echo "$1" | sed 's/\([A-Z]\)/-\1/g' | sed 's/^-//' | tr '[:upper:]' '[:lower:]'
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
        print_message "$RED" "✗ Component name must start with an uppercase letter (PascalCase)"
        exit 1
    fi

    # Check if name is valid identifier (alphanumeric only)
    if [[ ! "$name" =~ ^[A-Z][A-Za-z0-9]*$ ]]; then
        print_message "$RED" "✗ Component name must be a valid identifier (letters and numbers only, PascalCase)"
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

    # Check if category is valid
    case "$category" in
        base|application|marketing|foundations|internal|shared-assets)
            # Valid top-level category
            ;;
        pages/*)
            # Valid page category (pages/auth/login, pages/marketing-pages/landing, etc.)
            ;;
        *)
            print_message "$RED" "✗ Invalid category: $category"
            print_message "$YELLOW" "Valid categories:"
            print_message "$YELLOW" "  - base (primitive UI components)"
            print_message "$YELLOW" "  - application (dashboard/app UI)"
            print_message "$YELLOW" "  - marketing (marketing sections)"
            print_message "$YELLOW" "  - pages/auth/login, pages/auth/signup, etc. (page templates)"
            print_message "$YELLOW" "  - pages/marketing-pages/landing, pages/marketing-pages/pricing, etc."
            exit 1
            ;;
    esac
}

# Function: Get template category
get_template_category() {
    local category=$1

    case "$category" in
        base)
            echo "base"
            ;;
        application)
            echo "application"
            ;;
        marketing)
            echo "marketing"
            ;;
        pages/*)
            echo "pages"
            ;;
        *)
            echo "base"  # Default fallback
            ;;
    esac
}

# Function: Copy and process template
copy_template() {
    local template_file=$1
    local output_file=$2
    local component_name=$3
    local component_name_kebab=$4
    local category=$5
    local date=$(date -u +"%Y-%m-%d")

    if [ ! -f "$template_file" ]; then
        print_message "$YELLOW" "⚠ Template not found: $template_file (skipping)"
        return 1
    fi

    # Perform variable substitution
    sed -e "s/{{COMPONENT_NAME}}/${component_name}/g" \
        -e "s/{{COMPONENT_NAME_KEBAB}}/${component_name_kebab}/g" \
        -e "s/{{CATEGORY}}/${category}/g" \
        -e "s/{{DATE}}/${date}/g" \
        "$template_file" > "$output_file"

    return 0
}

# Function: Create component files
create_component_files() {
    local component_name=$1
    local component_name_kebab=$2
    local category=$3
    local component_dir=$4
    local template_category=$5

    local template_base="${TEMPLATES_DIR}/${template_category}"

    # Create main component file
    print_message "$BLUE" "→ Creating ${component_name}.tsx"
    if copy_template \
        "${template_base}/component.tsx.template" \
        "${component_dir}/${component_name_kebab}.tsx" \
        "$component_name" \
        "$component_name_kebab" \
        "$category"; then
        print_message "$GREEN" "✓ Created ${component_name}.tsx"
    fi

    # Create Storybook story
    if [ "$SKIP_STORY" = false ]; then
        print_message "$BLUE" "→ Creating ${component_name}.stories.tsx"
        if copy_template \
            "${template_base}/component.stories.tsx.template" \
            "${component_dir}/${component_name_kebab}.stories.tsx" \
            "$component_name" \
            "$component_name_kebab" \
            "$category"; then
            print_message "$GREEN" "✓ Created ${component_name}.stories.tsx"
        fi
    fi

    # Create test file
    if [ "$SKIP_TEST" = false ]; then
        print_message "$BLUE" "→ Creating ${component_name}.test.tsx"
        if copy_template \
            "${template_base}/component.test.tsx.template" \
            "${component_dir}/${component_name_kebab}.test.tsx" \
            "$component_name" \
            "$component_name_kebab" \
            "$category"; then
            print_message "$GREEN" "✓ Created ${component_name}.test.tsx"
        fi
    fi

    # Create patterns documentation
    if [ "$SKIP_PATTERNS" = false ]; then
        print_message "$BLUE" "→ Creating ${component_name}.patterns.md"
        if copy_template \
            "${template_base}/component.patterns.md.template" \
            "${component_dir}/${component_name_kebab}.patterns.md" \
            "$component_name" \
            "$component_name_kebab" \
            "$category"; then
            print_message "$GREEN" "✓ Created ${component_name}.patterns.md"
        fi
    fi

    # Create checklist
    print_message "$BLUE" "→ Creating ${component_name}.checklist.json"
    if copy_template \
        "${template_base}/component.checklist.json.template" \
        "${component_dir}/${component_name_kebab}.checklist.json" \
        "$component_name" \
        "$component_name_kebab" \
        "$category"; then
        print_message "$GREEN" "✓ Created ${component_name}.checklist.json"
    fi

    # Create index.ts
    print_message "$BLUE" "→ Creating index.ts"
    if copy_template \
        "${template_base}/index.ts.template" \
        "${component_dir}/index.ts" \
        "$component_name" \
        "$component_name_kebab" \
        "$category"; then
        print_message "$GREEN" "✓ Created index.ts"
    fi
}

# Function: Create variant files
create_variant_files() {
    local component_name=$1
    local component_name_kebab=$2
    local category=$3
    local component_dir=$4
    local template_category=$5
    local variant_name=$6
    local variant_kebab=$(to_kebab_case "$variant_name")

    local template_base="${TEMPLATES_DIR}/${template_category}"
    local variant_file="${component_dir}/${component_name_kebab}-${variant_kebab}.tsx"

    print_message "$BLUE" "→ Creating variant: ${component_name_kebab}-${variant_kebab}.tsx"

    # Use base component template for variants
    if copy_template \
        "${template_base}/component.tsx.template" \
        "$variant_file" \
        "${component_name}${variant_name}" \
        "${component_name_kebab}-${variant_kebab}" \
        "$category"; then
        print_message "$GREEN" "✓ Created ${component_name_kebab}-${variant_kebab}.tsx"
    fi
}

# Function: Update category index
update_category_index() {
    local component_name=$1
    local component_name_kebab=$2
    local category=$3

    # Determine category index file path
    local category_index=""
    if [[ "$category" =~ ^pages/ ]]; then
        # For pages, use the full path (e.g., src/components/pages/auth/login/index.ts)
        local page_path="${category#pages/}"  # Remove "pages/" prefix
        category_index="${PROJECT_ROOT}/src/components/pages/${page_path}/index.ts"
    else
        category_index="${PROJECT_ROOT}/src/components/${category}/index.ts"
    fi

    if [ ! -f "$category_index" ]; then
        print_message "$YELLOW" "⚠ Category index not found: $category_index"
        return
    fi

    print_message "$BLUE" "→ Updating category index: ${category}/index.ts"

    # Check if export already exists
    if grep -q "export.*from.*'./${component_name_kebab}'" "$category_index"; then
        print_message "$YELLOW" "⚠ Export already exists in category index"
        return
    fi

    # Check if file has empty export
    if grep -q "export {};$" "$category_index"; then
        # Insert export before empty export and remove empty export
        sed -i "/export {};/i export * from './${component_name_kebab}';" "$category_index"
        sed -i "/export {};/d" "$category_index"
        print_message "$GREEN" "✓ Category index updated"
    else
        # Append export at the end
        echo "export * from './${component_name_kebab}';" >> "$category_index"
        print_message "$GREEN" "✓ Category index updated"
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
    shift 2

    # Parse options
    while [ $# -gt 0 ]; do
        case "$1" in
            --with-variants)
                shift
                IFS=',' read -ra VARIANTS <<< "$1"
                ;;
            --skip-story)
                SKIP_STORY=true
                ;;
            --skip-test)
                SKIP_TEST=true
                ;;
            --skip-patterns)
                SKIP_PATTERNS=true
                ;;
            *)
                print_message "$RED" "✗ Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
        shift
    done

    # Validate inputs
    print_message "$BLUE" "→ Validating inputs..."
    validate_component_name "$COMPONENT_NAME"
    validate_category "$CATEGORY"
    print_message "$GREEN" "✓ Validation passed"

    # Convert names
    COMPONENT_NAME_KEBAB=$(to_kebab_case "$COMPONENT_NAME")

    # Determine paths
    COMPONENT_DIR="${PROJECT_ROOT}/src/components/${CATEGORY}/${COMPONENT_NAME_KEBAB}"
    TEMPLATE_CATEGORY=$(get_template_category "$CATEGORY")

    # Header
    clear
    echo ""
    print_message "$CYAN" "╔═══════════════════════════════════════════════════════╗"
    print_message "$CYAN" "║          COMPONENT SCAFFOLDING                        ║"
    print_message "$CYAN" "╚═══════════════════════════════════════════════════════╝"
    echo ""
    print_message "$CYAN" "Creating component: $COMPONENT_NAME ($CATEGORY)"
    if [ ${#VARIANTS[@]} -gt 0 ]; then
        print_message "$CYAN" "With variants: ${VARIANTS[*]}"
    fi
    echo ""

    # Check if component already exists
    if [ -d "$COMPONENT_DIR" ]; then
        print_message "$YELLOW" "⚠ Component directory already exists: $COMPONENT_DIR"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_message "$RED" "✗ Cancelled"
            exit 1
        fi
        rm -rf "$COMPONENT_DIR"
    fi

    # Create directory
    print_message "$BLUE" "→ Creating directory: $COMPONENT_DIR"
    mkdir -p "$COMPONENT_DIR"
    print_message "$GREEN" "✓ Directory created"

    # Create base-components directory if variants exist
    if [ ${#VARIANTS[@]} -gt 0 ]; then
        print_message "$BLUE" "→ Creating base-components directory"
        mkdir -p "${COMPONENT_DIR}/base-components"
        print_message "$GREEN" "✓ base-components directory created"
    fi

    # Create component files
    create_component_files \
        "$COMPONENT_NAME" \
        "$COMPONENT_NAME_KEBAB" \
        "$CATEGORY" \
        "$COMPONENT_DIR" \
        "$TEMPLATE_CATEGORY"

    # Create variant files
    if [ ${#VARIANTS[@]} -gt 0 ]; then
        print_section "Creating Variants"
        for variant in "${VARIANTS[@]}"; do
            create_variant_files \
                "$COMPONENT_NAME" \
                "$COMPONENT_NAME_KEBAB" \
                "$CATEGORY" \
                "$COMPONENT_DIR" \
                "$TEMPLATE_CATEGORY" \
                "$variant"
        done
    fi

    # Update category index
    update_category_index "$COMPONENT_NAME" "$COMPONENT_NAME_KEBAB" "$CATEGORY"

    # Success message
    print_section "Component Created Successfully!"
    echo ""
    print_message "$GREEN" "✅ Component $COMPONENT_NAME created successfully!"
    print_message "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Files created:"
    echo "  📄 src/components/${CATEGORY}/${COMPONENT_NAME_KEBAB}/${COMPONENT_NAME_KEBAB}.tsx"
    [ "$SKIP_STORY" = false ] && echo "  📖 src/components/${CATEGORY}/${COMPONENT_NAME_KEBAB}/${COMPONENT_NAME_KEBAB}.stories.tsx"
    [ "$SKIP_TEST" = false ] && echo "  🧪 src/components/${CATEGORY}/${COMPONENT_NAME_KEBAB}/${COMPONENT_NAME_KEBAB}.test.tsx"
    [ "$SKIP_PATTERNS" = false ] && echo "  📝 src/components/${CATEGORY}/${COMPONENT_NAME_KEBAB}/${COMPONENT_NAME_KEBAB}.patterns.md"
    echo "  ✓ src/components/${CATEGORY}/${COMPONENT_NAME_KEBAB}/${COMPONENT_NAME_KEBAB}.checklist.json"
    echo "  📦 src/components/${CATEGORY}/${COMPONENT_NAME_KEBAB}/index.ts"

    if [ ${#VARIANTS[@]} -gt 0 ]; then
        echo ""
        echo "Variants created:"
        for variant in "${VARIANTS[@]}"; do
            variant_kebab=$(to_kebab_case "$variant")
            echo "  📄 src/components/${CATEGORY}/${COMPONENT_NAME_KEBAB}/${COMPONENT_NAME_KEBAB}-${variant_kebab}.tsx"
        done
    fi

    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Implement the component in ${COMPONENT_NAME_KEBAB}.tsx"
    [ ${#VARIANTS[@]} -gt 0 ] && echo "  2. Implement variants in ${COMPONENT_NAME_KEBAB}-*.tsx files"
    [ "$SKIP_STORY" = false ] && echo "  3. Add Storybook stories for all variants"
    [ "$SKIP_TEST" = false ] && echo "  4. Write comprehensive tests"
    [ "$SKIP_PATTERNS" = false ] && echo "  5. Document usage patterns in ${COMPONENT_NAME_KEBAB}.patterns.md"
    echo "  6. Run: npm run storybook (to view component)"
    echo "  7. Run: npm test (to run tests)"
    echo "  8. Run: npm run type-check && npm run lint"
    echo "  9. Validate: ./scripts/validate-component.sh $COMPONENT_NAME $CATEGORY"
    echo ""
    echo "Import the component:"
    echo "  import { $COMPONENT_NAME } from '@/components/${CATEGORY}/${COMPONENT_NAME_KEBAB}';"
    echo ""
    print_message "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Run main function
main "$@"
