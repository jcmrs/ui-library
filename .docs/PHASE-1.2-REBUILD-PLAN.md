# Phase 1.2 Rebuild Implementation Plan

**Status**: In Progress - Directory structure complete, starting templates
**Last Updated**: 2025-10-23 22:xx

## Completed ✅

1. **Rollback to Clean State**

   - Reset to phase-1.2-start tag
   - Deleted incorrect checkpoint tags
   - Preserved git workflow automation (Phase 1.0)

2. **Correct Directory Structure**

   - Created 5 main categories: base/, application/, marketing/, pages/, foundations/
   - Created page subdirectories (auth, marketing-pages, error-pages, email-templates)
   - Created foundations subdirectories (icons, tokens, brand)
   - Added comprehensive index.ts files with documentation
   - Created src/components/README.md (comprehensive architecture guide)

3. **Documentation**
   - .docs/ARCHITECTURE-REDESIGN.md (problem analysis)
   - src/components/README.md (architecture guide)
   - This plan document

## In Progress 🚧

4. **Category-Specific Templates**
   - Created scripts/templates/ directory structure
   - ✅ base/component.tsx.template (atomic component pattern)
   - ⏳ Remaining templates...

## Remaining Work 📋

### 4. Templates (Continued)

**Base Templates** (Atomic components):

- ✅ component.tsx.template
- ⏳ component.stories.tsx.template
- ⏳ component.test.tsx.template
- ⏳ component.patterns.md.template
- ⏳ component.checklist.json.template
- ⏳ index.ts.template

**Application Templates** (Complex components):

- ⏳ component.tsx.template (stateful, more complex)
- ⏳ component.stories.tsx.template
- ⏳ component.test.tsx.template
- ⏳ component.patterns.md.template
- ⏳ component.checklist.json.template
- ⏳ index.ts.template

**Marketing Templates** (Full-width sections):

- ⏳ section.tsx.template (full-width, content-focused)
- ⏳ section.stories.tsx.template
- ⏳ section.test.tsx.template
- ⏳ section.patterns.md.template
- ⏳ section.checklist.json.template
- ⏳ index.ts.template

**Page Templates** (Complete pages):

- ⏳ page.tsx.template (multi-section composition)
- ⏳ page.stories.tsx.template
- ⏳ page.patterns.md.template
- ⏳ page.checklist.json.template
- ⏳ index.ts.template

**Shared Templates** (Used by all categories):

- ⏳ README.md.template (component group documentation)

### 5. Scaffolding System

**Core Script**: `scripts/create-component.sh`

**Must Support**:

1. **Simple Component** (single file)

   ```bash
   ./scripts/create-component.sh Avatar base
   ```

2. **Component with Variants** (multiple files)

   ```bash
   ./scripts/create-component.sh Buttons base --with-variants social,app-store,utility
   ```

3. **Section Component** (marketing)

   ```bash
   ./scripts/create-component.sh HeroSection marketing
   ```

4. **Page Template** (complete page)
   ```bash
   ./scripts/create-component.sh LoginPage pages/auth/login
   ```

**Features Required**:

- Category validation (base, application, marketing, pages/\*)
- Variant generation (--with-variants flag)
- base-components/ directory creation for variants
- Template variable substitution
- Category index.ts updating
- Windows .cmd wrapper

**Variables**:

- {{COMPONENT_NAME}} - PascalCase name
- {{COMPONENT_NAME_KEBAB}} - kebab-case name
- {{CATEGORY}} - Component category
- {{DATE}} - ISO date
- {{VARIANT_NAME}} - For variant templates

### 6. Validation System

**Core Script**: `scripts/validate-component.sh`

**Validations**:

1. **File Structure**

   - Required files exist
   - Variant files exist (if applicable)
   - base-components/ directory (if variants)

2. **TypeScript Compilation**

   - No type errors in component files
   - Proper exports

3. **ESLint**

   - No linting errors
   - Import/export patterns correct

4. **Tests**

   - Test file exists
   - Required test suites present
   - Coverage requirements (future)

5. **Storybook**

   - Story file exists
   - Required stories present
   - a11y addon configured

6. **Documentation**

   - patterns.md has required sections
   - checklist.json is valid

7. **Exports**
   - Component barrel export correct
   - Category index export present

### 7. End-to-End Testing

Test workflows:

1. Create simple base component
2. Create component with variants
3. Create marketing section
4. Create page template
5. Validate each component
6. Run quality gates
7. Complete task

## Token-Efficient Strategy

Given we're at 107K tokens, here's the strategic approach:

### Phase A: Essential Templates (Next 3K tokens)

- Complete base templates (5 remaining files)
- These are highest priority - most components will be base

### Phase B: Scaffolding Script (Next 5K tokens)

- Create comprehensive create-component.sh
- Support simple and variant modes
- Windows wrapper

### Phase C: Validation Script (Next 3K tokens)

- Create validate-component.sh
- All 7 validation categories

### Phase D: Application/Marketing/Page Templates (If context allows)

- Create remaining category templates
- Or defer to next session with handoff

### Phase E: Testing & Completion

- End-to-end workflow test
- Quality gate validation
- Complete Phase 1.2
- Push to remote

## Success Criteria

Phase 1.2 is complete when:

- ✅ Correct directory structure
- ✅ All category index.ts files
- ✅ Base component templates (minimum viable)
- ✅ Scaffolding script supports base components + variants
- ✅ Validation script works for base components
- ✅ Quality gates pass
- ✅ Documented and committed
- ⚠️ Application/marketing/page templates (nice-to-have, can defer)

## Next Session Handoff (If Needed)

If we run out of context before completing application/marketing/page templates:

1. **What's Complete**:

   - Directory structure ✅
   - Base templates ✅
   - Scaffolding for base ✅
   - Validation for base ✅

2. **What's Remaining**:

   - Application templates
   - Marketing templates
   - Page templates
   - Enhanced scaffolding for sections/pages

3. **How to Continue**:
   - Use base templates as reference
   - Adapt for category-specific needs
   - Follow patterns in UPSTREAM/react and starter kits

## Risk Mitigation

**Lessons from Previous Failure**:

- ❌ Don't assume structure - verify against docs
- ❌ Don't oversimplify complex systems
- ❌ Don't skip variant support
- ❌ Don't conflate categories
- ✅ Start with correct architecture
- ✅ Build incrementally
- ✅ Test early and often
- ✅ Preserve what works (Phase 1.0 automation)

**Current Approach**:

- Built correct structure from start ✅
- Comprehensive documentation ✅
- Incremental implementation ✅
- Clear success criteria ✅
- Token-aware strategy ✅
