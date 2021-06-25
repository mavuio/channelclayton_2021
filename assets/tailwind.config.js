const defaultTheme = require('tailwindcss/defaultTheme')

const {
    colors
} = require('tailwindcss/defaultTheme')

module.exports = {
    future: {},
    mode: 'jit',
    purge: [
        "../lib/my_app_web/**/*.html.eex",
        "../lib/my_app_web/**/*.html.leex",
        "../lib/my_app_web/**/views/**/*.ex",
        "../lib/my_app_web/**/live/**/*.ex",
        "../lib/my_app_web/**/ce/*.ex",
        "./js/**/*.js",
    ],
    theme: {
        container: {
            center: true,
            padding: {
                DEFAULT: '1rem',
                sm: '0',
            }
        },
        extend: {
            screens: {
                'xs': {
                    'max': '639px'
                },
                'print': {
                    'raw': 'print'
                },
            },
            colors: {
                'primary': colors.indigo
            },
        }
    },
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
        // require('@tailwindcss/aspect-ratio'),
    ]


}
