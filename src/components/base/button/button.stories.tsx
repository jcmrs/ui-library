import type { Meta, StoryObj } from '@storybook/react';

import { Button } from './button';

/**
 * Button component stories
 *
 * This file demonstrates all variants and use cases of the Button component.
 * Stories are used for:
 * - Visual documentation in Storybook
 * - Visual regression testing
 * - Accessibility testing with a11y addon
 * - Interactive component playground
 *
 * @see {@link ./button.patterns.md} for usage patterns
 */

const meta = {
  title: 'base/Button',
  component: Button,
  tags: ['autodocs'],
  parameters: {
    layout: 'centered',
    // Accessibility addon configuration
    a11y: {
      config: {
        rules: [
          { id: 'color-contrast', enabled: true },
          { id: 'heading-order', enabled: true },
          { id: 'label', enabled: true },
          { id: 'landmark-one-main', enabled: true },
          { id: 'region', enabled: true },
        ],
      },
    },
  },
  argTypes: {
    size: {
      control: 'select',
      options: ['sm', 'md', 'lg', 'xl'],
      description: 'Size variant of the component',
    },
    variant: {
      control: 'select',
      options: ['primary', 'secondary'],
      description: 'Visual variant of the component',
    },
    disabled: {
      control: 'boolean',
      description: 'Whether the component is disabled',
    },
    className: {
      control: 'text',
      description: 'Additional CSS classes',
    },
  },
} satisfies Meta<typeof Button>;

export default meta;
type Story = StoryObj<typeof meta>;

/**
 * Default Button
 *
 * The most common use case with default settings.
 */
export const Default: Story = {
  args: {
    children: 'Default Button',
    size: 'md',
    variant: 'primary',
    disabled: false,
  },
};

/**
 * All Sizes
 *
 * Demonstrates all available size variants (sm, md, lg, xl).
 */
export const AllSizes: Story = {
  render: () => (
    <div className="flex flex-col items-start gap-4">
      <Button size="sm">Small (sm)</Button>
      <Button size="md">Medium (md)</Button>
      <Button size="lg">Large (lg)</Button>
      <Button size="xl">Extra Large (xl)</Button>
    </div>
  ),
};

/**
 * All Variants
 *
 * Demonstrates all available visual variants.
 */
export const AllVariants: Story = {
  render: () => (
    <div className="flex flex-col items-start gap-4">
      <Button variant="primary">Primary Variant</Button>
      <Button variant="secondary">Secondary Variant</Button>
    </div>
  ),
};

/**
 * Disabled State
 *
 * Shows the component in a disabled state.
 */
export const Disabled: Story = {
  args: {
    children: 'Disabled Button',
    disabled: true,
  },
};

/**
 * With Custom Styling
 *
 * Demonstrates how to apply custom CSS classes.
 */
export const WithCustomStyling: Story = {
  args: {
    children: 'Custom Styled',
    className: 'shadow-lg border-2 border-purple-500',
  },
};

/**
 * Interactive Playground
 *
 * Use the controls panel to interactively test all props.
 * This story is useful for:
 * - Testing different prop combinations
 * - QA and exploratory testing
 * - Demonstrating component flexibility
 */
export const Interactive: Story = {
  args: {
    children: 'Interactive Button',
    size: 'md',
    variant: 'primary',
    disabled: false,
  },
};

/**
 * Accessibility Testing
 *
 * This story is specifically designed for accessibility testing.
 * Check the a11y addon panel for accessibility issues.
 */
export const AccessibilityTest: Story = {
  render: () => (
    <div className="flex flex-col items-start gap-4">
      <Button>Normal State</Button>
      <Button disabled>Disabled State</Button>
      <Button size="sm">Small Size</Button>
      <Button variant="secondary">Secondary Variant</Button>
    </div>
  ),
};
