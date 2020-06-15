module.exports = {
    env: {
        node: true,
        es6: true,
        mocha: true,
        browser: true
    },
    extends: 'eslint:recommended',
    parserOptions: {
        sourceType: 'module',
        ecmaVersion: 2020
    },
    rules: {
        'no-undef': 'off',
        'no-var': 'error',
        'newline-before-return': 'error',
        'no-console': 'off',
        'prefer-template': 'error',
        'no-unused-vars': [
            'error',
            {
                args: 'none'
            }
        ],
        indent: [
            'error',
            4,
            {
                SwitchCase: 1
            }
        ],
        quotes: ['error', 'single'],
        'quote-props': ['error', 'as-needed'],
        semi: ['error', 'always'],
        strict: ['error', 'global'],
        'arrow-parens': ['error', 'as-needed'],
        'comma-dangle': ['error', 'never'],
        'object-curly-spacing': ['error', 'always'],
        'space-in-parens': ['error', 'never'],
        'array-bracket-spacing': ['error', 'never'],
        'no-multiple-empty-lines': [
            'error',
            {
                max: 1,
                maxEOF: 0,
                maxBOF: 0
            }
        ],
        'comma-spacing': [
            'error',
            {
                before: false,
                after: true
            }
        ],
        'space-before-blocks': [
            'error',
            {
                functions: 'always',
                keywords: 'always',
                classes: 'always'
            }
        ]
    }
};
