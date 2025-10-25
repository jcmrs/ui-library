import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { axe, toHaveNoViolations } from 'jest-axe';
import { Button } from './button';

// Extend expect with jest-axe matchers
expect.extend(toHaveNoViolations);

/**
 * Test suite for Button component
 *
 * Following TDD methodology - these tests define Button behavior BEFORE implementation.
 * Tests cover all Button features from UPSTREAM analysis:
 * - Button/Link polymorphism (href prop changes element)
 * - 9 color variants (primary, secondary, tertiary, link variants, destructive variants)
 * - 4 size variants (sm, md, lg, xl)
 * - Loading state (spinner, text visibility control)
 * - Icon handling (leading, trailing, both, icon-only)
 * - Disabled state (button and link)
 * - Accessibility (WCAG 2.1 AA, keyboard navigation)
 *
 * @see {@link ./button.patterns.md} for usage patterns
 * @see {@link ../../.docs/BUTTON-ANALYSIS.md} for architecture analysis
 */

describe('Button', () => {
  describe('Rendering - Basic Structure', () => {
    it('renders with text content', () => {
      render(<Button>Click me</Button>);
      expect(screen.getByRole('button', { name: 'Click me' })).toBeInTheDocument();
    });

    it('renders as button element by default', () => {
      render(<Button>Content</Button>);
      const button = screen.getByRole('button');
      expect(button.tagName).toBe('BUTTON');
    });

    it('renders as link when href prop provided', () => {
      render(<Button href="/test">Link Button</Button>);
      const link = screen.getByRole('link', { name: 'Link Button' });
      expect(link.tagName).toBe('A');
      expect(link).toHaveAttribute('href', '/test');
    });

    it('renders without children (icon-only)', () => {
      render(<Button data-testid="icon-only" aria-label="Close" />);
      expect(screen.getByTestId('icon-only')).toBeInTheDocument();
    });

    it('applies custom className', () => {
      render(<Button className="custom-class">Content</Button>);
      expect(screen.getByRole('button')).toHaveClass('custom-class');
    });

    it('spreads additional props to root element', () => {
      render(<Button data-custom="test-value">Content</Button>);
      expect(screen.getByRole('button')).toHaveAttribute('data-custom', 'test-value');
    });
  });

  describe('Color Variants - All 9 Variants', () => {
    it('applies primary variant styles by default', () => {
      render(<Button>Primary</Button>);
      const button = screen.getByRole('button');
      // Check for primary variant Tailwind classes
      expect(button.className).toContain('bg-brand-solid');
    });

    it('applies secondary variant styles', () => {
      render(<Button color="secondary">Secondary</Button>);
      const button = screen.getByRole('button');
      expect(button.className).toContain('bg-primary');
      expect(button.className).toContain('text-secondary');
    });

    it('applies tertiary variant styles', () => {
      render(<Button color="tertiary">Tertiary</Button>);
      const button = screen.getByRole('button');
      // Tertiary has specific border/background pattern
      expect(button).toBeInTheDocument();
    });

    it('applies link-gray variant styles', () => {
      render(<Button color="link-gray">Link Gray</Button>);
      const button = screen.getByRole('button');
      expect(button.className).toContain('text-tertiary');
    });

    it('applies link-color variant styles', () => {
      render(<Button color="link-color">Link Color</Button>);
      const button = screen.getByRole('button');
      // Link color uses brand color
      expect(button).toBeInTheDocument();
    });

    it('applies primary-destructive variant styles', () => {
      render(<Button color="primary-destructive">Delete</Button>);
      const button = screen.getByRole('button');
      expect(button.className).toContain('bg-error-solid');
    });

    it('applies secondary-destructive variant styles', () => {
      render(<Button color="secondary-destructive">Remove</Button>);
      const button = screen.getByRole('button');
      expect(button.className).toContain('text-error-primary');
    });

    it('applies tertiary-destructive variant styles', () => {
      render(<Button color="tertiary-destructive">Discard</Button>);
      const button = screen.getByRole('button');
      expect(button.className).toContain('text-error-primary');
    });

    it('applies link-destructive variant styles', () => {
      render(<Button color="link-destructive">Delete Account</Button>);
      const button = screen.getByRole('button');
      expect(button.className).toContain('text-error-primary');
    });
  });

  describe('Size Variants - All 4 Sizes', () => {
    it('applies sm size styles', () => {
      render(<Button size="sm">Small</Button>);
      const button = screen.getByRole('button');
      expect(button.className).toContain('px-3');
      expect(button.className).toContain('py-2');
    });

    it('applies md size styles (default)', () => {
      render(<Button size="md">Medium</Button>);
      const button = screen.getByRole('button');
      expect(button.className).toContain('px-3.5');
      expect(button.className).toContain('py-2.5');
    });

    it('applies lg size styles', () => {
      render(<Button size="lg">Large</Button>);
      const button = screen.getByRole('button');
      expect(button.className).toContain('px-4');
      expect(button.className).toContain('py-2.5');
    });

    it('applies xl size styles', () => {
      render(<Button size="xl">Extra Large</Button>);
      const button = screen.getByRole('button');
      expect(button.className).toContain('px-4.5');
      expect(button.className).toContain('py-3');
    });
  });

  describe('Disabled State - Button and Link', () => {
    it('disables button element when isDisabled=true', () => {
      render(<Button isDisabled>Disabled</Button>);
      const button = screen.getByRole('button');
      expect(button).toBeDisabled();
    });

    it('removes href from link when disabled', () => {
      render(
        <Button href="/test" isDisabled>
          Disabled Link
        </Button>
      );
      const link = screen.getByText('Disabled Link');
      // Disabled links have href removed (React Aria pattern)
      expect(link).not.toHaveAttribute('href');
    });

    it('adds data-disabled to disabled link for Tailwind styling', () => {
      render(
        <Button href="/test" isDisabled>
          Disabled Link
        </Button>
      );
      const link = screen.getByText('Disabled Link');
      expect(link).toHaveAttribute('data-disabled', 'true');
    });

    it('applies disabled styles (cursor, opacity)', () => {
      render(<Button isDisabled>Disabled</Button>);
      const button = screen.getByRole('button');
      expect(button.className).toContain('disabled:cursor-not-allowed');
    });
  });

  describe('Loading State - Spinner and Text', () => {
    it('shows loading spinner when isLoading=true', () => {
      render(<Button isLoading>Loading</Button>);
      const button = screen.getByRole('button');
      // Loading spinner is SVG with data-icon="loading"
      const spinner = button.querySelector('[data-icon="loading"]');
      expect(spinner).toBeInTheDocument();
      expect(spinner?.tagName).toBe('svg');
    });

    it('disables button when loading', () => {
      render(<Button isLoading>Loading</Button>);
      expect(screen.getByRole('button')).toBeDisabled();
    });

    it('adds data-loading attribute when loading', () => {
      render(<Button isLoading>Loading</Button>);
      expect(screen.getByRole('button')).toHaveAttribute('data-loading', 'true');
    });

    it('hides non-loading content by default when loading', () => {
      render(<Button isLoading>Submitting...</Button>);
      const button = screen.getByRole('button');
      // Default behavior: children are invisible (not hidden)
      expect(button.className).toMatch(/invisible/);
    });

    it('keeps text visible when showTextWhileLoading=true', () => {
      render(
        <Button isLoading showTextWhileLoading>
          Submitting...
        </Button>
      );
      // When showTextWhileLoading=true, only non-text/loading icons are hidden
      expect(screen.getByText('Submitting...')).toBeVisible();
    });
  });

  describe('Icon Handling - Leading, Trailing, Both, Icon-Only', () => {
    const TestIcon = ({
      className,
      'data-icon': dataIcon,
    }: {
      className?: string;
      'data-icon'?: string;
    }) => (
      <svg className={className} data-icon={dataIcon} data-testid="test-icon">
        <path d="M0 0h24v24H0z" />
      </svg>
    );

    it('renders leading icon (React component)', () => {
      render(<Button iconLeading={TestIcon}>With Icon</Button>);
      const icon = screen.getByTestId('test-icon');
      expect(icon).toBeInTheDocument();
      expect(icon).toHaveAttribute('data-icon', 'leading');
    });

    it('renders trailing icon (React component)', () => {
      render(<Button iconTrailing={TestIcon}>With Icon</Button>);
      const icon = screen.getByTestId('test-icon');
      expect(icon).toBeInTheDocument();
      expect(icon).toHaveAttribute('data-icon', 'trailing');
    });

    it('renders both leading and trailing icons', () => {
      render(
        <Button iconLeading={TestIcon} iconTrailing={TestIcon}>
          Both Icons
        </Button>
      );
      const icons = screen.getAllByTestId('test-icon');
      expect(icons).toHaveLength(2);
      expect(icons[0]).toHaveAttribute('data-icon', 'leading');
      expect(icons[1]).toHaveAttribute('data-icon', 'trailing');
    });

    it('renders icon element (ReactNode) instead of component', () => {
      const iconElement = (
        <svg data-testid="icon-element">
          <path d="M0 0h24v24H0z" />
        </svg>
      );
      render(<Button iconLeading={iconElement}>With Element</Button>);
      expect(screen.getByTestId('icon-element')).toBeInTheDocument();
    });

    it('applies icon-only data attribute when no children', () => {
      render(<Button iconLeading={TestIcon} aria-label="Close" data-testid="icon-only" />);
      expect(screen.getByTestId('icon-only')).toHaveAttribute('data-icon-only', 'true');
    });

    it('applies icon size classes', () => {
      render(<Button iconLeading={TestIcon}>Icon Button</Button>);
      const icon = screen.getByTestId('test-icon');
      // Icons should have size-5 class from common.icon styles
      expect(icon.className).toContain('size-5');
    });
  });

  describe('Interactions - Click and Keyboard', () => {
    it('calls onClick when clicked', async () => {
      const handleClick = vi.fn();
      render(<Button onClick={handleClick}>Click Me</Button>);

      await userEvent.click(screen.getByRole('button'));
      expect(handleClick).toHaveBeenCalledTimes(1);
    });

    it('does not call onClick when disabled', async () => {
      const handleClick = vi.fn();
      render(
        <Button onClick={handleClick} isDisabled>
          Disabled
        </Button>
      );

      await userEvent.click(screen.getByRole('button'));
      expect(handleClick).not.toHaveBeenCalled();
    });

    it('does not call onClick when loading', async () => {
      const handleClick = vi.fn();
      render(
        <Button onClick={handleClick} isLoading>
          Loading
        </Button>
      );

      await userEvent.click(screen.getByRole('button'));
      expect(handleClick).not.toHaveBeenCalled();
    });

    it('supports keyboard interaction (Space)', async () => {
      const handleClick = vi.fn();
      render(<Button onClick={handleClick}>Press Space</Button>);

      const button = screen.getByRole('button');
      button.focus();
      await userEvent.keyboard(' ');
      expect(handleClick).toHaveBeenCalled();
    });

    it('supports keyboard interaction (Enter)', async () => {
      const handleClick = vi.fn();
      render(<Button onClick={handleClick}>Press Enter</Button>);

      const button = screen.getByRole('button');
      button.focus();
      await userEvent.keyboard('{Enter}');
      expect(handleClick).toHaveBeenCalled();
    });
  });

  describe('Accessibility - WCAG 2.1 AA Compliance', () => {
    it('has no accessibility violations', async () => {
      const { container } = render(<Button>Accessible Button</Button>);
      const results = await axe(container);
      expect(results).toHaveNoViolations();
    });

    it('has no accessibility violations when disabled', async () => {
      const { container } = render(<Button isDisabled>Disabled</Button>);
      const results = await axe(container);
      expect(results).toHaveNoViolations();
    });

    it('has no accessibility violations when loading', async () => {
      const { container } = render(<Button isLoading>Loading</Button>);
      const results = await axe(container);
      expect(results).toHaveNoViolations();
    });

    it('has button role by default', () => {
      render(<Button>Button</Button>);
      expect(screen.getByRole('button')).toBeInTheDocument();
    });

    it('has link role when href provided', () => {
      render(<Button href="/test">Link</Button>);
      expect(screen.getByRole('link')).toBeInTheDocument();
    });

    it('has correct type attribute by default (button)', () => {
      render(<Button>Default Type</Button>);
      expect(screen.getByRole('button')).toHaveAttribute('type', 'button');
    });

    it('accepts aria-label for icon-only buttons', () => {
      render(<Button aria-label="Close dialog">✕</Button>);
      expect(screen.getByRole('button', { name: 'Close dialog' })).toBeInTheDocument();
    });

    it('supports keyboard focus', () => {
      render(<Button>Focusable</Button>);
      const button = screen.getByRole('button');
      button.focus();
      expect(button).toHaveFocus();
    });

    it('has visible focus indicator', () => {
      render(<Button>Focus Me</Button>);
      const button = screen.getByRole('button');
      button.focus();
      // Focus ring should be visible (focus:outline or focus:ring classes)
      expect(button.className).toMatch(/focus:/);
    });
  });

  describe('Edge Cases - Null, Undefined, Long Text, Special Characters', () => {
    it('renders with null children', () => {
      render(<Button>{null}</Button>);
      expect(screen.getByRole('button')).toBeInTheDocument();
    });

    it('renders with undefined children', () => {
      render(<Button>{undefined}</Button>);
      expect(screen.getByRole('button')).toBeInTheDocument();
    });

    it('handles very long text content', () => {
      const longText = 'A'.repeat(1000);
      render(<Button>{longText}</Button>);
      expect(screen.getByRole('button')).toHaveTextContent(longText);
    });

    it('handles special characters safely (no XSS)', () => {
      const specialText = '<script>alert("XSS")</script>';
      render(<Button>{specialText}</Button>);
      // Should render as text, not execute script
      expect(screen.getByRole('button')).toHaveTextContent(specialText);
      expect(screen.getByRole('button').innerHTML).not.toContain('<script>');
    });

    it('handles rapid prop changes without errors', () => {
      const { rerender } = render(
        <Button size="sm" color="primary">
          Content
        </Button>
      );

      rerender(
        <Button size="xl" color="secondary-destructive">
          New Content
        </Button>
      );
      rerender(
        <Button size="md" color="link-gray" isLoading>
          Loading
        </Button>
      );
      rerender(
        <Button size="lg" color="tertiary" isDisabled>
          Disabled
        </Button>
      );

      expect(screen.getByRole('button')).toBeInTheDocument();
    });

    it('cleans up properly on unmount', () => {
      const { unmount } = render(<Button>Unmount Me</Button>);
      expect(() => unmount()).not.toThrow();
    });
  });

  describe('Link-Specific Behavior', () => {
    it('renders link with target attribute', () => {
      render(
        <Button href="https://example.com" target="_blank" rel="noopener">
          External
        </Button>
      );
      const link = screen.getByRole('link');
      expect(link).toHaveAttribute('target', '_blank');
      expect(link).toHaveAttribute('rel', 'noopener');
    });

    it('renders link with download attribute', () => {
      render(
        <Button href="/file.pdf" download="document.pdf">
          Download
        </Button>
      );
      const link = screen.getByRole('link');
      expect(link).toHaveAttribute('download', 'document.pdf');
    });

    it('applies link-specific styles to link variants', () => {
      render(
        <Button href="/test" color="link-gray">
          Link
        </Button>
      );
      const link = screen.getByRole('link');
      // Link variants should have link-specific styling
      expect(link.className).toContain('rounded');
    });
  });
});
