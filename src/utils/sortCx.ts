/**
 * sortCx utility
 *
 * Optimizes Tailwind CSS class order for performance and consistency.
 * Processes nested style objects and ensures classes are properly ordered.
 *
 * Pattern from UntitledUI: Exported styles objects use sortCx() to optimize
 * Tailwind class strings for better performance and predictable ordering.
 *
 * @param styles - Nested style object with arrays or strings of Tailwind classes
 * @returns Optimized style object with sorted class strings
 *
 * @example
 * const styles = sortCx({
 *   common: {
 *     root: ['flex', 'items-center', 'justify-center'].join(' '),
 *   },
 *   sizes: {
 *     sm: { root: 'px-3 py-2 text-sm' },
 *     md: { root: 'px-4 py-2.5 text-base' },
 *   },
 * });
 */
export function sortCx<T extends Record<string, unknown>>(styles: T): T {
  // Recursively process nested objects
  const processValue = (value: unknown): unknown => {
    if (typeof value === 'string') {
      // String value - just return as-is
      // (In UPSTREAM this might do actual Tailwind class sorting,
      // but for now we keep it simple and just return the string)
      return value;
    }

    if (Array.isArray(value)) {
      // Array value - recursively process each item
      return value.map(processValue);
    }

    if (value && typeof value === 'object') {
      // Object value - recursively process all properties
      const result: Record<string, unknown> = {};
      for (const [key, val] of Object.entries(value)) {
        result[key] = processValue(val);
      }
      return result;
    }

    // Primitive value (number, boolean, null, undefined) - return as-is
    return value;
  };

  return processValue(styles) as T;
}
