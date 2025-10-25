import type { Meta, StoryObj } from '@storybook/react';

import { Button } from './button';

/**
 * Button component stories
 *
 * Comprehensive Storybook documentation for Button component featuring:
 * - All 9 color variants (primary, secondary, tertiary, link variants, destructive variants)
 * - All 4 size variants (sm, md, lg, xl)
 * - Loading states
 * - Disabled states
 * - Icon handling (leading, trailing, icon-only)
 * - Button/Link polymorphism
 * - Accessibility testing
 *
 * Following UPSTREAM pattern: One story per major color variant showing all combinations.
 *
 * @see {@link ./button.patterns.md} for usage patterns
 * @see {@link ../../.docs/BUTTON-ANALYSIS.md} for architecture details
 */

// Simple test icon component for demonstrations
const TestIcon = () => (
  <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
    <path d="M10 5V15M5 10H15" stroke="currentColor" strokeWidth="2" strokeLinecap="round" />
  </svg>
);

const meta = {
  title: 'Base Components/Button',
  component: Button,
  tags: ['autodocs'],
  parameters: {
    layout: 'centered',
    docs: {
      description: {
        component:
          'Production-ready button component with React Aria accessibility, 9 color variants, and comprehensive feature set.',
      },
    },
    // Accessibility addon configuration
    a11y: {
      config: {
        rules: [
          { id: 'color-contrast', enabled: true },
          { id: 'button-name', enabled: true },
          { id: 'link-name', enabled: true },
        ],
      },
    },
  },
  argTypes: {
    color: {
      control: 'select',
      options: [
        'primary',
        'secondary',
        'tertiary',
        'link-gray',
        'link-color',
        'primary-destructive',
        'secondary-destructive',
        'tertiary-destructive',
        'link-destructive',
      ],
      description: 'Color variant (9 options)',
      table: {
        defaultValue: { summary: 'primary' },
      },
    },
    size: {
      control: 'select',
      options: ['sm', 'md', 'lg', 'xl'],
      description: 'Size variant (4 options)',
      table: {
        defaultValue: { summary: 'md' },
      },
    },
    isDisabled: {
      control: 'boolean',
      description: 'Disabled state',
      table: {
        defaultValue: { summary: 'false' },
      },
    },
    isLoading: {
      control: 'boolean',
      description: 'Loading state (shows spinner)',
      table: {
        defaultValue: { summary: 'false' },
      },
    },
    showTextWhileLoading: {
      control: 'boolean',
      description: 'Keep text visible during loading',
      table: {
        defaultValue: { summary: 'false' },
      },
    },
  },
} satisfies Meta<typeof Button>;

export default meta;
type Story = StoryObj<typeof meta>;

/**
 * Default Button
 *
 * Primary button with medium size - most common use case.
 */
export const Default: Story = {
  args: {
    children: 'Button',
    color: 'primary',
    size: 'md',
  },
};

/**
 * Primary Buttons
 *
 * Primary variant - use for main actions on a page.
 * Shows all sizes, states (disabled, loading), and icon positions.
 */
export const Primary: Story = {
  render: () => (
    <div className="flex flex-col gap-8 p-8">
      {/* All sizes */}
      <div className="flex flex-col gap-4">
        <h3 className="text-sm font-semibold text-gray-700">All Sizes</h3>
        <div className="flex items-center gap-4">
          <Button color="primary" size="sm">
            Button CTA
          </Button>
          <Button color="primary" size="md">
            Button CTA
          </Button>
          <Button color="primary" size="lg">
            Button CTA
          </Button>
          <Button color="primary" size="xl">
            Button CTA
          </Button>
        </div>
      </div>

      {/* Disabled */}
      <div className="flex flex-col gap-4">
        <h3 className="text-sm font-semibold text-gray-700">Disabled</h3>
        <div className="flex items-center gap-4">
          <Button color="primary" size="sm" isDisabled>
            Button CTA
          </Button>
          <Button color="primary" size="md" isDisabled>
            Button CTA
          </Button>
          <Button color="primary" size="lg" isDisabled>
            Button CTA
          </Button>
          <Button color="primary" size="xl" isDisabled>
            Button CTA
          </Button>
        </div>
      </div>

      {/* Loading */}
      <div className="flex flex-col gap-4">
        <h3 className="text-sm font-semibold text-gray-700">Loading</h3>
        <div className="flex items-center gap-4">
          <Button color="primary" size="sm" isLoading showTextWhileLoading>
            Button CTA
          </Button>
          <Button color="primary" size="md" isLoading showTextWhileLoading>
            Button CTA
          </Button>
          <Button color="primary" size="lg" isLoading showTextWhileLoading>
            Button CTA
          </Button>
          <Button color="primary" size="xl" isLoading showTextWhileLoading>
            Button CTA
          </Button>
        </div>
      </div>

      {/* With icons */}
      <div className="flex flex-col gap-4">
        <h3 className="text-sm font-semibold text-gray-700">With Icons</h3>
        <div className="flex items-center gap-4">
          <Button color="primary" size="md" iconLeading={TestIcon}>
            Button CTA
          </Button>
          <Button color="primary" size="md" iconTrailing={TestIcon}>
            Button CTA
          </Button>
        </div>
      </div>

      {/* Icon only */}
      <div className="flex flex-col gap-4">
        <h3 className="text-sm font-semibold text-gray-700">Icon Only</h3>
        <div className="flex items-center gap-4">
          <Button color="primary" size="sm" iconLeading={TestIcon} aria-label="Add" />
          <Button color="primary" size="md" iconLeading={TestIcon} aria-label="Add" />
          <Button color="primary" size="lg" iconLeading={TestIcon} aria-label="Add" />
          <Button color="primary" size="xl" iconLeading={TestIcon} aria-label="Add" />
        </div>
      </div>
    </div>
  ),
};

/**
 * Secondary Buttons
 *
 * Secondary variant - use for alternative actions.
 */
export const Secondary: Story = {
  render: () => (
    <div className="flex flex-col gap-8 p-8">
      <div className="flex items-center gap-4">
        <Button color="secondary" size="sm">
          Button CTA
        </Button>
        <Button color="secondary" size="md">
          Button CTA
        </Button>
        <Button color="secondary" size="lg">
          Button CTA
        </Button>
        <Button color="secondary" size="xl">
          Button CTA
        </Button>
      </div>
    </div>
  ),
};

/**
 * Tertiary Buttons
 *
 * Tertiary variant - use for low-emphasis actions.
 */
export const Tertiary: Story = {
  render: () => (
    <div className="flex flex-col gap-8 p-8">
      <div className="flex items-center gap-4">
        <Button color="tertiary" size="sm">
          Button CTA
        </Button>
        <Button color="tertiary" size="md">
          Button CTA
        </Button>
        <Button color="tertiary" size="lg">
          Button CTA
        </Button>
        <Button color="tertiary" size="xl">
          Button CTA
        </Button>
      </div>
    </div>
  ),
};

/**
 * Link Gray Buttons
 *
 * Link-gray variant - styled as underlined links in gray.
 */
export const LinkGray: Story = {
  render: () => (
    <div className="flex flex-col gap-8 p-8">
      <div className="flex items-center gap-4">
        <Button color="link-gray" size="sm">
          Button CTA
        </Button>
        <Button color="link-gray" size="md">
          Button CTA
        </Button>
        <Button color="link-gray" size="lg">
          Button CTA
        </Button>
        <Button color="link-gray" size="xl">
          Button CTA
        </Button>
      </div>
    </div>
  ),
};

/**
 * Link Color Buttons
 *
 * Link-color variant - styled as underlined links in brand color.
 */
export const LinkColor: Story = {
  render: () => (
    <div className="flex flex-col gap-8 p-8">
      <div className="flex items-center gap-4">
        <Button color="link-color" size="sm">
          Button CTA
        </Button>
        <Button color="link-color" size="md">
          Button CTA
        </Button>
        <Button color="link-color" size="lg">
          Button CTA
        </Button>
        <Button color="link-color" size="xl">
          Button CTA
        </Button>
      </div>
    </div>
  ),
};

/**
 * Primary Destructive Buttons
 *
 * Primary-destructive variant - use for dangerous primary actions (Delete Account, Remove User).
 */
export const PrimaryDestructive: Story = {
  render: () => (
    <div className="flex flex-col gap-8 p-8">
      <div className="flex items-center gap-4">
        <Button color="primary-destructive" size="sm">
          Delete Account
        </Button>
        <Button color="primary-destructive" size="md">
          Delete Account
        </Button>
        <Button color="primary-destructive" size="lg">
          Delete Account
        </Button>
        <Button color="primary-destructive" size="xl">
          Delete Account
        </Button>
      </div>
    </div>
  ),
};

/**
 * Secondary Destructive Buttons
 *
 * Secondary-destructive variant - use for dangerous secondary actions.
 */
export const SecondaryDestructive: Story = {
  render: () => (
    <div className="flex flex-col gap-8 p-8">
      <div className="flex items-center gap-4">
        <Button color="secondary-destructive" size="sm">
          Remove
        </Button>
        <Button color="secondary-destructive" size="md">
          Remove
        </Button>
        <Button color="secondary-destructive" size="lg">
          Remove
        </Button>
        <Button color="secondary-destructive" size="xl">
          Remove
        </Button>
      </div>
    </div>
  ),
};

/**
 * Tertiary Destructive Buttons
 *
 * Tertiary-destructive variant - use for dangerous tertiary actions.
 */
export const TertiaryDestructive: Story = {
  render: () => (
    <div className="flex flex-col gap-8 p-8">
      <div className="flex items-center gap-4">
        <Button color="tertiary-destructive" size="sm">
          Discard
        </Button>
        <Button color="tertiary-destructive" size="md">
          Discard
        </Button>
        <Button color="tertiary-destructive" size="lg">
          Discard
        </Button>
        <Button color="tertiary-destructive" size="xl">
          Discard
        </Button>
      </div>
    </div>
  ),
};

/**
 * Link Destructive Buttons
 *
 * Link-destructive variant - use for dangerous actions styled as links.
 */
export const LinkDestructive: Story = {
  render: () => (
    <div className="flex flex-col gap-8 p-8">
      <div className="flex items-center gap-4">
        <Button color="link-destructive" size="sm">
          Delete Account
        </Button>
        <Button color="link-destructive" size="md">
          Delete Account
        </Button>
        <Button color="link-destructive" size="lg">
          Delete Account
        </Button>
        <Button color="link-destructive" size="xl">
          Delete Account
        </Button>
      </div>
    </div>
  ),
};

/**
 * Button as Link
 *
 * Demonstrates polymorphism - Button renders as <a> when href provided.
 */
export const AsLink: Story = {
  render: () => (
    <div className="flex flex-col gap-8 p-8">
      <div className="flex flex-col gap-4">
        <h3 className="text-sm font-semibold text-gray-700">Button as Link</h3>
        <div className="flex items-center gap-4">
          <Button href="/dashboard" color="primary">
            Go to Dashboard
          </Button>
          <Button href="/settings" color="secondary">
            Settings
          </Button>
          <Button href="https://example.com" target="_blank" rel="noopener" color="link-color">
            External Link
          </Button>
        </div>
      </div>
    </div>
  ),
};

/**
 * Loading States
 *
 * Demonstrates loading spinner with different text visibility options.
 */
export const LoadingStates: Story = {
  render: () => (
    <div className="flex flex-col gap-8 p-8">
      {/* Loading with text hidden */}
      <div className="flex flex-col gap-4">
        <h3 className="text-sm font-semibold text-gray-700">Loading (text hidden)</h3>
        <div className="flex items-center gap-4">
          <Button color="primary" isLoading>
            Submitting...
          </Button>
          <Button color="secondary" isLoading>
            Saving...
          </Button>
        </div>
      </div>

      {/* Loading with text visible */}
      <div className="flex flex-col gap-4">
        <h3 className="text-sm font-semibold text-gray-700">Loading (text visible)</h3>
        <div className="flex items-center gap-4">
          <Button color="primary" isLoading showTextWhileLoading>
            Submitting...
          </Button>
          <Button color="secondary" isLoading showTextWhileLoading>
            Saving...
          </Button>
        </div>
      </div>
    </div>
  ),
};

/**
 * Interactive Playground
 *
 * Use controls panel to test all prop combinations.
 */
export const Interactive: Story = {
  args: {
    children: 'Interactive Button',
    color: 'primary',
    size: 'md',
    isDisabled: false,
    isLoading: false,
    showTextWhileLoading: false,
  },
};
