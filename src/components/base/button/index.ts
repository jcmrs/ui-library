/**
 * Button Component Exports
 *
 * @category base
 * @module Button
 *
 * This barrel file exports the Button component and its associated types.
 * Import from this file to use the component in your application.
 *
 * @example
 * ```tsx
 * import { Button } from "@/components/base/button";
 * import type { ButtonProps } from "@/components/base/button";
 * ```
 *
 * @see {@link ./button.tsx} for component implementation
 * @see {@link ./button.patterns.md} for usage patterns
 */

export { Button } from './button';
export type { ButtonProps } from './button';

// Export styles for advanced customization (optional)
export { styles as ButtonStyles } from './button';
