import type { Preview } from '@storybook/react';
import '../src/index.css'; // Import Tailwind CSS

/**
 * Storybook Preview Configuration
 *
 * Global settings for all stories:
 * - Tailwind CSS styles
 * - Dark mode support
 * - Accessibility checks
 * - Responsive viewports
 */
const preview: Preview = {
  parameters: {
    // Controls addon configuration
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
      expanded: true, // Expand controls by default
    },

    // Actions addon configuration
    actions: {
      argTypesRegex: '^on[A-Z].*',
    },

    // Backgrounds addon configuration
    backgrounds: {
      default: 'light',
      values: [
        {
          name: 'light',
          value: '#ffffff',
        },
        {
          name: 'dark',
          value: '#111827',
        },
        {
          name: 'gray',
          value: '#f9fafb',
        },
      ],
    },

    // Viewport addon configuration (mobile-first)
    viewport: {
      viewports: {
        mobile: {
          name: 'Mobile',
          styles: {
            width: '375px',
            height: '667px',
          },
        },
        tablet: {
          name: 'Tablet',
          styles: {
            width: '768px',
            height: '1024px',
          },
        },
        desktop: {
          name: 'Desktop',
          styles: {
            width: '1280px',
            height: '720px',
          },
        },
        wide: {
          name: 'Wide Desktop',
          styles: {
            width: '1920px',
            height: '1080px',
          },
        },
      },
    },

    // Accessibility addon configuration (WCAG 2.1 AA)
    a11y: {
      config: {
        rules: [
          {
            id: 'color-contrast',
            enabled: true, // Enforce color contrast ratios
          },
          {
            id: 'label',
            enabled: true, // Require labels for form elements
          },
          {
            id: 'button-name',
            enabled: true, // Require accessible button names
          },
          {
            id: 'link-name',
            enabled: true, // Require accessible link names
          },
        ],
      },
      options: {
        runOnly: {
          type: 'tag',
          values: ['wcag2a', 'wcag2aa'], // Check WCAG 2.1 A and AA
        },
      },
    },

    // Documentation options
    docs: {
      toc: true, // Show table of contents
    },

    // Layout options
    layout: 'centered', // Center components by default
  },

  // Global decorators
  decorators: [
    (Story) => (
      <div className="antialiased">
        <Story />
      </div>
    ),
  ],

  // Global types for toolbar customization
  globalTypes: {
    theme: {
      description: 'Global theme for components',
      defaultValue: 'light',
      toolbar: {
        title: 'Theme',
        icon: 'circlehollow',
        items: ['light', 'dark'],
        dynamicTitle: true,
      },
    },
  },
};

export default preview;
