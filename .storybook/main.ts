import type { StorybookConfig } from '@storybook/react-vite';

/**
 * Storybook 9.x Configuration
 *
 * Features:
 * - Vite builder for fast HMR
 * - React 19 support
 * - Tailwind CSS integration
 * - Accessibility addon (a11y)
 * - Interactive testing
 * - Auto-generated docs
 */
const config: StorybookConfig = {
  // Story files location
  stories: ['../src/**/*.mdx', '../src/**/*.stories.@(js|jsx|ts|tsx)'],

  // Addons for enhanced functionality
  addons: [
    '@storybook/addon-essentials', // Docs, controls, actions, backgrounds, etc.
    '@storybook/addon-interactions', // Interactive testing
    '@storybook/addon-links', // Link between stories
    '@storybook/addon-a11y', // Accessibility testing (WCAG 2.1 AA)
  ],

  // Framework configuration
  framework: {
    name: '@storybook/react-vite',
    options: {
      builder: {
        viteConfigPath: '../vite.config.ts',
      },
    },
  },

  // TypeScript configuration
  typescript: {
    check: true,
    reactDocgen: 'react-docgen-typescript',
    reactDocgenTypescriptOptions: {
      shouldExtractLiteralValuesFromEnum: true,
      shouldRemoveUndefinedFromOptional: true,
      propFilter: (prop) => {
        // Filter out props from node_modules
        if (prop.parent) {
          return !prop.parent.fileName.includes('node_modules');
        }
        return true;
      },
    },
  },

  // Documentation options
  docs: {
    autodocs: 'tag', // Generate docs for stories with 'autodocs' tag
  },

  // Core configuration
  core: {
    disableTelemetry: true, // Disable telemetry for privacy
  },

  // Static directories for assets
  staticDirs: ['../public'],

  // Vite configuration overrides
  async viteFinal(config) {
    return config;
  },
};

export default config;
