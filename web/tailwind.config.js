/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/react-app/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        orange: {
          500: '#FF7828',
          400: '#FF8A47',
          600: '#E56A25',
        }
      },
      fontFamily: {
        sans: ['Baloo 2', 'system-ui', 'sans-serif'],
      },
      animation: {
        'bounce-slow': 'bounce 2s infinite',
        'float': 'float 3s ease-in-out infinite',
        'glow': 'glow 2s ease-in-out infinite alternate',
      },
      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-10px)' }
        },
        glow: {
          '0%': { 
            boxShadow: '0 0 20px rgba(255, 120, 40, 0.3)',
            transform: 'scale(1)'
          },
          '100%': { 
            boxShadow: '0 0 30px rgba(255, 120, 40, 0.6)',
            transform: 'scale(1.02)'
          }
        }
      },
      perspective: {
        '1000': '1000px',
      }
    },
  },
  plugins: [],
};
