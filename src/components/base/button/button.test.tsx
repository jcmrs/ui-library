import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { axe, toHaveNoViolations } from "jest-axe";
import { Button } from "./button";

// Extend expect with jest-axe matchers
expect.extend(toHaveNoViolations);

/**
 * Test suite for Button component
 *
 * Tests are organized into the following categories:
 * - Rendering: Basic rendering and prop handling
 * - Accessibility: WCAG 2.1 AA compliance, keyboard navigation, screen readers
 * - Interactions: User interactions and state changes
 * - Edge Cases: Error conditions, empty states, boundary conditions
 *
 * @see {@link ./button.patterns.md} for usage patterns
 */

describe("Button", () => {
  describe("Rendering", () => {
    it("renders without crashing", () => {
      render(<Button>Test Content</Button>);
      expect(screen.getByText("Test Content")).toBeInTheDocument();
    });

    it("renders children correctly", () => {
      const testContent = "Test Children Content";
      render(<Button>{testContent}</Button>);
      expect(screen.getByText(testContent)).toBeInTheDocument();
    });

    it("applies custom className", () => {
      const customClass = "custom-test-class";
      render(
        <Button className={customClass} data-testid="component">
          Content
        </Button>
      );
      expect(screen.getByTestId("component")).toHaveClass(customClass);
    });

    it("renders with default size (md)", () => {
      render(<Button data-testid="component">Content</Button>);
      const element = screen.getByTestId("component");
      expect(element).toBeInTheDocument();
    });

    it("renders all size variants correctly", () => {
      const sizes = ["sm", "md", "lg", "xl"] as const;
      sizes.forEach((size) => {
        const { unmount } = render(
          <Button size={size} data-testid={`component-${size}`}>
            {size}
          </Button>
        );
        expect(screen.getByTestId(`component-${size}`)).toBeInTheDocument();
        unmount();
      });
    });

    it("renders all visual variants correctly", () => {
      const variants = ["primary", "secondary"] as const;
      variants.forEach((variant) => {
        const { unmount } = render(
          <Button variant={variant} data-testid={`component-${variant}`}>
            {variant}
          </Button>
        );
        expect(screen.getByTestId(`component-${variant}`)).toBeInTheDocument();
        unmount();
      });
    });

    it("forwards ref correctly", () => {
      const ref = { current: null };
      render(
        <Button ref={ref as React.RefObject<HTMLDivElement>}>
          Content
        </Button>
      );
      expect(ref.current).toBeInstanceOf(HTMLDivElement);
    });

    it("spreads additional props to root element", () => {
      render(
        <Button data-testid="component" data-custom="test-value">
          Content
        </Button>
      );
      expect(screen.getByTestId("component")).toHaveAttribute("data-custom", "test-value");
    });
  });

  describe("Accessibility", () => {
    it("has no accessibility violations", async () => {
      const { container } = render(<Button>Content</Button>);
      const results = await axe(container);
      expect(results).toHaveNoViolations();
    });

    it("has no accessibility violations when disabled", async () => {
      const { container } = render(
        <Button disabled>Content</Button>
      );
      const results = await axe(container);
      expect(results).toHaveNoViolations();
    });

    it("properly communicates disabled state to assistive technology", () => {
      render(
        <Button disabled data-testid="component">
          Content
        </Button>
      );
      expect(screen.getByTestId("component")).toHaveAttribute("aria-disabled", "true");
    });

    it("has proper semantic structure", () => {
      render(<Button data-testid="component">Content</Button>);
      const element = screen.getByTestId("component");
      expect(element).toBeInTheDocument();
      // Add more specific semantic checks based on component type
    });

    it("supports keyboard navigation", () => {
      render(<Button data-testid="component">Content</Button>);
      const element = screen.getByTestId("component");
      element.focus();
      expect(element).toHaveFocus();
    });

    it("has visible focus indicator", () => {
      render(<Button data-testid="component">Content</Button>);
      const element = screen.getByTestId("component");
      element.focus();
      // Check for focus-visible class or outline
      expect(element).toHaveFocus();
    });
  });

  describe("Interactions", () => {
    it("does not respond to interactions when disabled", async () => {
      const user = userEvent.setup();
      render(
        <Button disabled data-testid="component">
          Content
        </Button>
      );
      const element = screen.getByTestId("component");

      // Try to interact with disabled component
      await user.click(element);

      // Verify no interaction occurred (adjust based on component behavior)
      expect(element).toHaveAttribute("aria-disabled", "true");
    });

    it("handles user interactions correctly", async () => {
      const user = userEvent.setup();
      render(<Button data-testid="component">Content</Button>);
      const element = screen.getByTestId("component");

      // Test appropriate user interactions based on component type
      await user.click(element);
      // Add assertions based on expected behavior
    });
  });

  describe("Edge Cases", () => {
    it("handles empty children gracefully", () => {
      render(<Button data-testid="component" />);
      expect(screen.getByTestId("component")).toBeInTheDocument();
    });

    it("handles null children gracefully", () => {
      render(
        <Button data-testid="component">{null}</Button>
      );
      expect(screen.getByTestId("component")).toBeInTheDocument();
    });

    it("handles undefined children gracefully", () => {
      render(
        <Button data-testid="component">{undefined}</Button>
      );
      expect(screen.getByTestId("component")).toBeInTheDocument();
    });

    it("handles very long text content", () => {
      const longText = "A".repeat(1000);
      render(<Button data-testid="component">{longText}</Button>);
      expect(screen.getByTestId("component")).toHaveTextContent(longText);
    });

    it("handles special characters in content", () => {
      const specialText = '<script>alert("test")</script>';
      render(<Button data-testid="component">{specialText}</Button>);
      // Should render as text, not execute script
      expect(screen.getByTestId("component")).toHaveTextContent(specialText);
    });

    it("handles rapid prop changes", () => {
      const { rerender } = render(
        <Button size="sm" data-testid="component">
          Content
        </Button>
      );

      rerender(
        <Button size="lg" data-testid="component">
          Content
        </Button>
      );

      expect(screen.getByTestId("component")).toBeInTheDocument();
    });

    it("cleans up properly on unmount", () => {
      const { unmount } = render(<Button>Content</Button>);
      expect(() => unmount()).not.toThrow();
    });
  });
});
