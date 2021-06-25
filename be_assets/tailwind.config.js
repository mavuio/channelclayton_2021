const defaultTheme = require('tailwindcss/defaultTheme')

const {
    colors
} = require('tailwindcss/defaultTheme')

module.exports = {
    future: {},
    mode: 'jit',
    purge: [
        "../lib/my_app_be/**/*.html.eex",
        "../lib/my_app_be/**/*.html.leex",
        "../lib/my_app_be/**/views/**/*.ex",
        "../lib/my_app_be/**/live/**/*.ex",
        "../lib/my_app_be/**/ce/*.ex",
        "../deps/mavu*/**/*.html.eex",
        "../deps/mavu*/**/*.html.leex",
        "../linked/mavu*/**/*.html.eex",
        "../linked/mavu*/**/*.html.leex",
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
                'primary': colors.red
            },
        }
    },
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
        // require('@tailwindcss/aspect-ratio'),
    ]


}
