# Common Projen settings

```ts

new Project({

# license
  licensed: false,

  license: 'MIT',
  copyrightOwner: 'Isaac Wagner',


# Prettier
  prettier: true,
  prettierOptions: {
    settings: {
      printWidth: 119,
      tabWidth: 2,
      semi: false,
      singleQuote: true,
      trailingComma: TrailingComma.NONE
    }
  },


# Docs
  docgen: false,

# Pipeline
  github: false,

# Typescript
  tsconfig: { compilerOptions: { noUnusedLocals: false, noUnusedParameters: false } },

})


# VSCode Formatting
project.vscode?.extensions.addRecommendations('esbenp.prettier-vscode')
project.vscode?.settings.addSetting('editor.defaultFormatter', 'esbenp.prettier-vscode', 'typescript')
project.vscode?.settings.addSetting('editor.formatOnPaste', true, 'typescript')
project.vscode?.settings.addSetting('editor.formatOnSave', true, 'typescript')

```
