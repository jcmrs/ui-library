import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';
import path from 'path';

/**
 * Vite Configuration
 *
 * Features:
 * - React plugin with Fast Refresh
 * - Tailwind CSS 4.x integration
 * - Path aliases for clean imports
 * - Build optimization
 */
export default defineConfig({
  plugins: [react(), tailwindcss()],

  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
      '@/components': path.resolve(__dirname, './src/components'),
      '@/foundations': path.resolve(__dirname, './src/components/foundations'),
      '@/base': path.resolve(__dirname, './src/components/base'),
      '@/application': path.resolve(__dirname, './src/components/application'),
      '@/internal': path.resolve(__dirname, './src/components/internal'),
      '@/shared-assets': path.resolve(__dirname, './src/components/shared-assets'),
    },
  },

  build: {
    lib: {
      entry: path.resolve(__dirname, 'src/index.ts'),
      name: 'UILibrary',
      formats: ['es', 'cjs'],
      fileName: (format) => `ui-library.${format}.js`,
    },
    rollupOptions: {
      external: ['react', 'react-dom', 'react/jsx-runtime'],
      output: {
        globals: {
          react: 'React',
          'react-dom': 'ReactDOM',
          'react/jsx-runtime': 'jsxRuntime',
        },
      },
    },
    sourcemap: true,
    minify: 'esbuild',
  },

  server: {
    port: 5173,
    open: false,
  },

  preview: {
    port: 4173,
  },
});
