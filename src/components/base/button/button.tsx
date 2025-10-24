"use client";

/**
 * Button Component
 *
 * @category base
 * @description Production-ready button component with multiple variants, sizes, and states.
 * Follows WCAG 2.1 AA accessibility standards with proper semantic HTML.
 *
 * @example
 * ```tsx
 * // Primary button (default)
 * <Button>Click me</Button>
 *
 * // Secondary button
 * <Button variant="secondary">Cancel</Button>
 *
 * // Different sizes
 * <Button size="sm">Small</Button>
 * <Button size="lg">Large</Button>
 *
 * // Disabled state
 * <Button disabled>Disabled</Button>
 *
 * // With onClick handler
 * <Button onClick={() => console.log('Clicked!')}>Submit</Button>
 * ```
 *
 * @see {@link ./button.patterns.md} for usage patterns
 */

import type { ButtonHTMLAttributes, ReactNode } from "react";
import React from "react";

import { cx } from "@/utils/cx";

/**
 * Style definitions for Button
 *
 * Organized by:
 * - common: Base styles applied to all variants
 * - sizes: Size-specific styles (sm, md, lg, xl)
 * - variants: Visual variant styles (primary, secondary, tertiary, destructive)
 */
export const styles = {
  common: {
    root: [
      "relative inline-flex items-center justify-center whitespace-nowrap",
      "font-semibold",
      "transition duration-100 ease-linear",
      "outline-none focus-visible:ring-2 focus-visible:ring-offset-2",
      // Disabled styles
      "disabled:cursor-not-allowed disabled:opacity-50",
    ].join(" "),
  },
  sizes: {
    sm: {
      root: "gap-1 rounded-lg px-3 py-2 text-sm",
    },
    md: {
      root: "gap-1.5 rounded-lg px-3.5 py-2.5 text-sm",
    },
    lg: {
      root: "gap-1.5 rounded-lg px-4 py-2.5 text-base",
    },
    xl: {
      root: "gap-2 rounded-lg px-5 py-3 text-base",
    },
  },
  variants: {
    primary: {
      root: "bg-blue-600 text-white shadow-sm hover:bg-blue-700 focus-visible:ring-blue-600",
    },
    secondary: {
      root: "bg-white text-gray-900 border border-gray-300 shadow-sm hover:bg-gray-50 focus-visible:ring-gray-500",
    },
    tertiary: {
      root: "text-gray-700 hover:bg-gray-50 focus-visible:ring-gray-500",
    },
    destructive: {
      root: "bg-red-600 text-white shadow-sm hover:bg-red-700 focus-visible:ring-red-600",
    },
  },
};

/**
 * Props for the Button component
 *
 * AI USAGE GUIDANCE:
 * - All props are explicitly typed for clarity
 * - Optional props have sensible defaults
 * - Extends standard HTML button attributes
 * - Use discriminated unions for variant-specific props
 */
export interface ButtonProps extends Omit<ButtonHTMLAttributes<HTMLButtonElement>, "disabled"> {
  /**
   * Child elements to render inside the button
   * @example <Button>Click me</Button>
   */
  children?: ReactNode;

  /**
   * Size variant
   * @default "md"
   */
  size?: "sm" | "md" | "lg" | "xl";

  /**
   * Visual variant
   * @default "primary"
   */
  variant?: "primary" | "secondary" | "tertiary" | "destructive";

  /**
   * Whether the button is disabled
   * @default false
   */
  disabled?: boolean;

  /**
   * Additional CSS classes to apply
   * @example className="custom-class"
   */
  className?: string;

  /**
   * Test ID for automated testing
   * @example data-testid="submit-button"
   */
  "data-testid"?: string;
}

/**
 * Button component implementation
 *
 * IMPLEMENTATION NOTES:
 * - Uses semantic <button> element for accessibility
 * - Uses cx() for conditional className merging (from @/utils/cx)
 * - Uses Tailwind CSS utility classes for styling
 * - Supports all standard HTML button attributes via ...props
 *
 * ACCESSIBILITY:
 * - Proper semantic HTML <button> element
 * - Keyboard navigation support (Enter/Space)
 * - Focus management with visible focus ring
 * - Screen reader friendly
 * - Disabled state properly communicated to AT
 *
 * @param props - Component props
 * @returns Rendered button element
 */
export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  (
    {
      children,
      size = "md",
      variant = "primary",
      disabled = false,
      className,
      type = "button",
      "data-testid": testId,
      ...props
    },
    ref
  ) => {
    return (
      <button
        ref={ref}
        type={type}
        disabled={disabled}
        className={cx(
          styles.common.root,
          styles.sizes[size].root,
          styles.variants[variant].root,
          className
        )}
        data-testid={testId}
        {...props}
      >
        {children}
      </button>
    );
  }
);

// Display name for React DevTools
Button.displayName = "Button";
