
module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  parserOptions: {
    ecmaVersion: 2022,
    sourceType: 'module',
  },
  extends: [
    'eslint:recommended',
    'google',
    'plugin:node/recommended',
  ],
  rules: {
    'no-restricted-globals': ['error', 'name', 'length'],
    'prefer-arrow-callback': 'error',
    'quotes': ['error', 'single', { 'allowTemplateLiterals': true }],

    'indent': ['error', 2, {
      'SwitchCase': 1,
      'flatTernaryExpressions': true,
    }],
    'max-len': ['warn', { 'code': 120, 'ignoreComments': true, 'ignoreUrls': true }],
    'comma-dangle': ['error', 'always-multiline'],
    'arrow-parens': ['error', 'as-needed'],
    'eol-last': ['error', 'always'],
    'semi': ['error', 'always'],

    'keyword-spacing': ['error', { 'before': true, 'after': true }],
    'space-before-blocks': ['error', 'always'],
    'space-before-function-paren': ['error', {
      'anonymous': 'never',
      'named': 'never',
      'asyncArrow': 'always',
    }],
    'object-curly-spacing': ['error', 'always'],
    'array-bracket-spacing': ['error', 'never'],
    'space-infix-ops': 'error',
    'space-unary-ops': ['error', { 'words': true, 'nonwords': false }],
    'key-spacing': ['error', { 'beforeColon': false, 'afterColon': true }],
    'comma-spacing': ['error', { 'before': false, 'after': true }],
    'no-trailing-spaces': 'error',
    'no-multi-spaces': 'error',
    'padded-blocks': ['error', 'never'],
    'one-var-declaration-per-line': ['error', 'always'],
    'arrow-spacing': ['error', { 'before': true, 'after': true }],
  },
  overrides: [
    {
      files: ['**/*.spec.*'],
      env: {
        mocha: true,
      },
      rules: {},
    },
  ],
};
