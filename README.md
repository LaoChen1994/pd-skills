# Codex Agents.md Template & Skills Repository

This repository acts as a centralized template for configuring and maintaining agent-specific developer standards and custom AI skill definitions. It is optimized for agentic workflows (specifically Codex agent discovery) and human reference.

---

## 🛠 Skills & Agents Index

All custom AI assistant skills are organized under the `skills/` directory:

| Skill Name | Agent Capability | Reference Assets |
| :--- | :--- | :--- |
| [**Create Monorepo Package**](./skills/create-monorepo-package/SKILL.md) | Scaffolds new packages into the monorepo, handles Rollup/TS config, and registers exports in root. | [Template](./skills/create-monorepo-package/references/package.json.tmpl), [Script](./skills/create-monorepo-package/references/init-package.sh) |
| [**Use AGENTS.md Rules**](./skills/use-agent-md/SKILL.md) | Enforces project rule reading via `AGENTS.md` (set as the global `contextFileName`) and handles `AGENT.override.md` logic. | [Agent Definition](./skills/use-agent-md/agents/openai.yaml) |
| [**Feedback to AGENTS.md**](./skills/feedback-to-agents-md/SKILL.md) | Captures user corrections/criticism, summarizes reusable lessons, and persists rules to `AGENTS.md` after approval. | [Agent Definition](./skills/feedback-to-agents-md/agents/openai.yaml) |
| [**AGENTS.md Chinese Rules**](./skills/agents-global-rules/SKILL.md) | Enforces development standards in Chinese (thinking before coding, simplicity first, surgical changes, goal-driven execution). | [Agent Definition](./skills/agents-global-rules/agents/openai.yaml) |

---

## ⚙️ How to Use AGENTS.md (3 Usage Patterns)

Codex reads the `AGENTS.md` file in your workspace to load project-specific rules, constraints, testing commands, and coding preferences. There are three recommended ways to organize and use this:

### 1. Current Project Rules (Baseline Rules)
If you want to apply these global development rules (Think Before Coding, Simplicity First, Surgical Changes) to a specific repository, copy the root `AGENTS.md` into that project's root folder:
```bash
cp AGENTS.md /path/to/your-project/AGENTS.md
```

### 2. Global Preferences (System-wide Rules)
To load these preferences globally across all your coding sessions, copy the global rules into your agent's system-wide preference directory (e.g. `~/.codex/`):
```bash
cp AGENTS.md ~/.codex/AGENTS.md
```

### 3. Domain-Specific Overrides (Scenario Templates)
If your repository focus is dedicated to a specific stack, combine or overwrite the baseline rules with one of our specialized templates under the `examples/` directory:
- **Frontend Development**: [examples/frontend/AGENTS.md](./examples/frontend/AGENTS.md) (React, CSS system, Core Web Vitals, a11y)
- **Node.js Backends**: [examples/node-backend/AGENTS.md](./examples/node-backend/AGENTS.md) (validation destructuring, async APIs, error handling)
- **AI Products**: [examples/ai-product/AGENTS.md](./examples/ai-product/AGENTS.md) (prompts engineering, LLM error handling, JSON structures)
- **Design & Layouts**: [examples/design/AGENTS.md](./examples/design/AGENTS.md) (layout hierarchy, micro-animations, color tokens)

Example for a Next.js web application:
```bash
cp examples/frontend/AGENTS.md /path/to/your-nextjs-app/AGENTS.md
```

---

## 📂 Directory Structure Pattern

```
codex-agents-md-template/
├── README.md                 # Project entry point and usage documentation
├── AGENTS.md                 # Baseline global developer guidelines
├── CHANGELOG.md              # Project change log
├── examples/                 # Specialized domain-specific AGENTS.md templates
│   ├── frontend/AGENTS.md
│   ├── node-backend/AGENTS.md
│   ├── ai-product/AGENTS.md
│   └── design/AGENTS.md
└── skills/                   # Sub-skills containing guide docs and metadata
    ├── create-monorepo-package/
    ├── use-agent-md/
    ├── feedback-to-agents-md/
    └── agents-global-rules/
```

*Created and maintained by Antigravity.*
