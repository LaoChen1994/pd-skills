---
name: Create Monorepo Package
description: Instructions for creating and configuring a new package in the pd-markdown monorepo project.
---

# Create Monorepo Package Skill

This skill defines the standard structure and configuration for packages in this pnpm monorepo. Use this guide when asked to create a new package or set up a similar sub-project within the monorepo.

## 1. Monorepo Structure

The project uses a pnpm workspace with the following structure:
```
create-monorepo-package/
├── SKILL.md                 # Main entry point
├── agents/                  # Agent metadata
│   └── openai.yaml
└── references/              # Supporting materials
    ├── package.json.tmpl
    ├── rollup.config.ts.tmpl
    ├── tsconfig.json.tmpl
    ├── init-package.sh
    └── standard-package/
```


- **Workspace config (`pnpm-workspace.yaml`)**:
  ```yaml
  packages:
    - 'packages/*'
    - 'examples/*'
  ```

## 2. Supporting Materials

When creating a new package, use the following resources located in the `references/` directory:

- **Templates**:
  - [package.json.tmpl](file:///Users/pidan/Work/Learn/skills/create-monorepo-package/references/package.json.tmpl)
  - [rollup.config.ts.tmpl](file:///Users/pidan/Work/Learn/skills/create-monorepo-package/references/rollup.config.ts.tmpl)
  - [tsconfig.json.tmpl](file:///Users/pidan/Work/Learn/skills/create-monorepo-package/references/tsconfig.json.tmpl)
- **Reference Example**: [standard-package/](file:///Users/pidan/Work/Learn/skills/create-monorepo-package/references/standard-package/)
- **Automation Script**: [init-package.sh](file:///Users/pidan/Work/Learn/skills/create-monorepo-package/references/init-package.sh)

## 4. Root Setup Checklist


When a new package is created, make sure to:
1. **Update `tsconfig.base.json`** with `paths` pointing to the new package for IDE support:
   ```json
   "paths": {
     "pd-markdown-[package-name]": ["./packages/[package-name]/src/index.ts"],
     "pd-markdown/[package-name]": ["./packages/[package-name]/src/index.ts"]
   }
   ```
2. **Update Root `package.json`** exports map so external users can import via the umbrella package name:
   ```json
   "exports": {
     "./[package-name]": {
       "types": "./packages/[package-name]/dist/index.d.ts",
       "import": "./packages/[package-name]/dist/index.mjs",
       "require": "./packages/[package-name]/dist/index.cjs"
     }
   },
   "typesVersions": {
     "*": {
       "[package-name]": ["./packages/[package-name]/dist/index.d.ts"]
     }
   }
   ```

## 5. Execution Steps
When prompted to create a new package:
1. Create folder `packages/[new-pkg]`.
2. Initialize `package.json` based on the template.
3. Add `rollup.config.ts` and `tsconfig.json`.
4. Create the source file `src/index.ts`.
5. Update `tsconfig.base.json` in the root with new `paths`.
6. Update root `package.json` `exports` and `typesVersions`.
7. Run `pnpm install` from root.
8. Test the build with `pnpm build`.
