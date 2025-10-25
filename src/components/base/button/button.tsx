'use client';

/**
 * Button Component
 *
 * Production-ready button component with complete feature set:
 * - 9 color variants (primary, secondary, tertiary, link variants, destructive variants)
 * - 4 size variants (sm, md, lg, xl)
 * - Button/Link polymorphism (renders as <a> when href provided)
 * - Loading state with inline SVG spinner
 * - Icon support (leading, trailing, both, icon-only)
 * - Full accessibility (React Aria, WCAG 2.1 AA)
 *
 * @category base
 * @see {@link ./button.patterns.md} for usage patterns
 * @see {@link ../../.docs/BUTTON-ANALYSIS.md} for architecture details
 * @see {@link ../../.docs/UNIVERSAL-VS-BUTTON-PATTERNS.md} for pattern guidance
 */

import type { FC, ReactNode, ButtonHTMLAttributes, AnchorHTMLAttributes } from 'react';
import { isValidElement } from 'react';
import { Button as AriaButton, Link as AriaLink } from 'react-aria-components';
import type { ButtonProps as AriaButtonProps } from 'react-aria-components';

import { cx } from '@/utils/cx';
import { sortCx } from '@/utils/sortCx';

/**
 * Exported styles object for Button component
 *
 * Pattern: Exported styles enable composition and testing.
 * Uses sortCx() utility for Tailwind class optimization.
 *
 * Structure:
 * - common: Base styles applied to ALL buttons
 * - sizes: Size-specific styles (sm, md, lg, xl)
 * - colors: Color variant styles (9 variants)
 */
export const styles = sortCx({
  common: {
    root: [
      // Layout and positioning
      'group relative inline-flex items-center justify-center',
      // Typography
      'font-semibold whitespace-nowrap',
      // Transition and effects
      'transition-all duration-200',
      // Focus management (WCAG 2.1 AA)
      'outline-none focus-visible:outline-2 focus-visible:outline-offset-2',
      // Disabled state styling
      'disabled:cursor-not-allowed disabled:pointer-events-none',
      // Pseudo-element for effects
      'before:absolute before:inset-0 before:rounded-[inherit] before:transition-all',
    ].join(' '),
    icon: 'pointer-events-none size-5 shrink-0',
    text: 'data-text',
  },
  sizes: {
    sm: {
      root: 'gap-1 rounded-lg px-3 py-2 text-sm before:rounded-[7px] data-icon-only:p-2',
      linkRoot: 'gap-1',
    },
    md: {
      root: 'gap-1 rounded-lg px-3.5 py-2.5 text-sm before:rounded-[7px] data-icon-only:p-2.5',
      linkRoot: 'gap-1',
    },
    lg: {
      root: 'gap-1.5 rounded-lg px-4 py-2.5 text-md before:rounded-[7px] data-icon-only:p-3',
      linkRoot: 'gap-1.5',
    },
    xl: {
      root: 'gap-1.5 rounded-lg px-4.5 py-3 text-md before:rounded-[7px] data-icon-only:p-3.5',
      linkRoot: 'gap-1.5',
    },
  },
  colors: {
    primary: {
      root: [
        'bg-brand-solid text-white shadow-xs',
        'hover:bg-brand-solid-hover',
        'focus-visible:outline-brand-600',
        'disabled:bg-disabled disabled:text-disabled-subtle',
      ].join(' '),
    },
    secondary: {
      root: [
        'bg-primary text-secondary shadow-xs',
        'ring-1 ring-inset ring-primary',
        'hover:bg-primary-hover hover:text-secondary-hover',
        'focus-visible:outline-brand-600',
        'disabled:bg-disabled disabled:text-disabled-subtle disabled:ring-disabled',
      ].join(' '),
    },
    tertiary: {
      root: [
        'text-secondary',
        'hover:bg-secondary-hover hover:text-secondary-hover',
        'focus-visible:outline-brand-600',
        'disabled:text-disabled',
      ].join(' '),
    },
    'link-gray': {
      root: [
        'justify-normal rounded p-0! text-tertiary',
        '*:data-text:underline *:data-text:decoration-transparent',
        'hover:*:data-text:decoration-current',
        'focus-visible:outline-gray-600',
        'disabled:text-disabled',
      ].join(' '),
    },
    'link-color': {
      root: [
        'justify-normal rounded p-0! text-brand',
        '*:data-text:underline *:data-text:decoration-transparent',
        'hover:*:data-text:decoration-current',
        'focus-visible:outline-brand-600',
        'disabled:text-disabled',
      ].join(' '),
    },
    'primary-destructive': {
      root: [
        'bg-error-solid text-white shadow-xs',
        'hover:bg-error-solid-hover',
        'focus-visible:outline-error-600',
        'disabled:bg-disabled disabled:text-disabled-subtle',
      ].join(' '),
    },
    'secondary-destructive': {
      root: [
        'bg-error-secondary text-error-primary shadow-xs',
        'ring-1 ring-inset ring-error-tertiary',
        'hover:bg-error-secondary-hover hover:text-error-primary-hover',
        'focus-visible:outline-error-600',
        'disabled:bg-disabled disabled:text-disabled-subtle disabled:ring-disabled',
      ].join(' '),
    },
    'tertiary-destructive': {
      root: [
        'text-error-primary',
        'hover:bg-error-secondary hover:text-error-primary-hover',
        'focus-visible:outline-error-600',
        'disabled:text-disabled',
      ].join(' '),
    },
    'link-destructive': {
      root: [
        'justify-normal rounded p-0! text-error-primary',
        '*:data-text:underline *:data-text:decoration-transparent',
        'hover:*:data-text:decoration-current',
        'focus-visible:outline-error-600',
        'disabled:text-disabled',
      ].join(' '),
    },
  },
});

/**
 * Common props shared by both Button and Link variants
 */
export interface CommonProps {
  /** Whether button is disabled */
  isDisabled?: boolean;
  /** Whether button is in loading state */
  isLoading?: boolean;
  /** Size variant */
  size?: 'sm' | 'md' | 'lg' | 'xl';
  /** Color variant */
  color?:
    | 'primary'
    | 'secondary'
    | 'tertiary'
    | 'link-gray'
    | 'link-color'
    | 'primary-destructive'
    | 'secondary-destructive'
    | 'tertiary-destructive'
    | 'link-destructive';
  /** Icon to display before content (React component or element) */
  iconLeading?: FC<{ className?: string; 'data-icon'?: string }> | ReactNode;
  /** Icon to display after content (React component or element) */
  iconTrailing?: FC<{ className?: string; 'data-icon'?: string }> | ReactNode;
  /** Removes padding from text content (for icon-only buttons) */
  noTextPadding?: boolean;
  /** Keep text visible while loading (default: hide text) */
  showTextWhileLoading?: boolean;
}

/**
 * Props when Button renders as <button>
 */
export interface ButtonProps
  extends CommonProps,
    Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'color' | 'slot' | 'disabled'> {
  /** React Aria slot name */
  slot?: AriaButtonProps['slot'];
}

/**
 * Props when Button renders as <a> (link)
 */
interface LinkProps extends CommonProps, Omit<AnchorHTMLAttributes<HTMLAnchorElement>, 'color'> {}

/**
 * Union type: Button can be either button or link
 */
export type Props = ButtonProps | LinkProps;

/**
 * Type guard to check if icon is React component
 */
const isReactComponent = (
  icon: unknown
): icon is FC<{ className?: string; 'data-icon'?: string }> => typeof icon === 'function';

/**
 * Button Component
 *
 * Polymorphic component that renders as:
 * - <button> by default
 * - <a> when href prop is provided
 *
 * Uses React Aria for accessibility:
 * - AriaButton for <button> elements
 * - AriaLink for <a> elements
 *
 * ACCESSIBILITY FEATURES:
 * - Semantic HTML (button or anchor)
 * - Proper ARIA attributes (handled by React Aria)
 * - Keyboard navigation (Space, Enter)
 * - Focus management with visible indicators
 * - Disabled state communication to assistive technology
 * - Loading state announced to screen readers
 *
 * @example
 * // Primary button (default)
 * <Button>Save Changes</Button>
 *
 * @example
 * // Secondary button
 * <Button color="secondary">Cancel</Button>
 *
 * @example
 * // Button as link
 * <Button href="/dashboard">Go to Dashboard</Button>
 *
 * @example
 * // Loading state
 * <Button isLoading>Submitting...</Button>
 *
 * @example
 * // With icons
 * <Button iconLeading={PlusIcon}>Add Item</Button>
 * <Button iconTrailing={ArrowRightIcon}>Continue</Button>
 *
 * @example
 * // Icon-only button (requires aria-label)
 * <Button iconLeading={CloseIcon} aria-label="Close dialog" />
 */
export function Button({
  isDisabled = false,
  isLoading = false,
  size = 'md',
  color = 'primary',
  iconLeading: IconLeading,
  iconTrailing: IconTrailing,
  noTextPadding = false,
  showTextWhileLoading = false,
  children,
  className,
  ...otherProps
}: Props) {
  // Determine if this is icon-only button (no text children)
  const isIcon = (IconLeading || IconTrailing) && !children;

  // Determine disabled state (button is disabled when isDisabled OR isLoading)
  const disabled = isDisabled || isLoading;

  // Determine if component should render as link (has href prop)
  const href = 'href' in otherProps ? otherProps.href : undefined;

  // Select React Aria component (Link if href, Button otherwise)
  const Component = href ? AriaLink : AriaButton;

  // Determine if this is a link variant (affects styling)
  const isLink = color.startsWith('link-');

  // Build props object based on component type
  let props: Record<string, unknown>;

  if (href) {
    // Link props
    props = {
      ...otherProps,
      // Remove href when disabled (React Aria pattern for disabled links)
      href: disabled ? undefined : href,
      // Since anchor elements don't support `disabled` attribute,
      // we need to specify `data-rac` and `data-disabled` to enable
      // the `disabled:` selector in Tailwind classes
      ...(disabled ? { 'data-rac': true, 'data-disabled': true } : {}),
    };
  } else {
    // Button props
    props = {
      ...otherProps,
      // Use type="button" by default to prevent form submission
      type: (otherProps as ButtonProps).type ?? 'button',
      // React Aria handles isDisabled prop
      isDisabled: disabled,
    };
  }

  return (
    <Component
      {...props}
      className={cx(
        styles.common.root,
        isLink ? styles.sizes[size].linkRoot : styles.sizes[size].root,
        styles.colors[color].root,
        // Loading state classes
        isLoading &&
          (showTextWhileLoading
            ? '[&>*:not([data-icon=loading]):not([data-text])]:hidden'
            : '[&>*:not([data-icon=loading])]:invisible'),
        className
      )}
      data-loading={isLoading ? true : undefined}
      data-icon-only={isIcon ? true : undefined}
    >
      {/* Loading spinner (inline SVG) */}
      {isLoading && (
        <svg
          fill="none"
          data-icon="loading"
          viewBox="0 0 20 20"
          className={cx(
            styles.common.icon,
            !showTextWhileLoading && 'absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2'
          )}
        >
          {/* Background circle */}
          <circle
            className="stroke-current opacity-30"
            cx="10"
            cy="10"
            r="8"
            fill="none"
            strokeWidth="2"
          />
          {/* Spinning indicator */}
          <circle
            className="origin-center animate-spin stroke-current"
            cx="10"
            cy="10"
            r="8"
            fill="none"
            strokeWidth="2"
            strokeDasharray="12.5 50"
            strokeLinecap="round"
          />
        </svg>
      )}

      {/* Leading icon */}
      {!isLoading && IconLeading && (
        <>
          {isValidElement(IconLeading) && IconLeading}
          {isReactComponent(IconLeading) && (
            <IconLeading data-icon="leading" className={styles.common.icon} />
          )}
        </>
      )}

      {/* Button text content */}
      {children && <span className={cx(!noTextPadding && styles.common.text)}>{children}</span>}

      {/* Trailing icon */}
      {!isLoading && IconTrailing && (
        <>
          {isValidElement(IconTrailing) && IconTrailing}
          {isReactComponent(IconTrailing) && (
            <IconTrailing data-icon="trailing" className={styles.common.icon} />
          )}
        </>
      )}
    </Component>
  );
}

Button.displayName = 'Button';
