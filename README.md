# PD Skills

This repository is a collection of personal technical skills, best practices, and automation templates designed for both human reference and AI agent discovery.

## 🛠 Skills & Agents Index

| Skill Name | Agent Capability | Reference Assets |
| :--- | :--- | :--- |
| [**Create Monorepo Package**](./create-monorepo-package/SKILL.md) | Scaffolds new packages into the monorepo, handles Rollup/TS config, and registers exports in root. | [Template](./create-monorepo-package/references/package.json.tmpl), [Script](./create-monorepo-package/references/init-package.sh) |
| [**Use AGENTS.md Rules**](./use-agent-md/SKILL.md) | Enforces project rule reading via `AGENTS.md` (set as the global `contextFileName`) and handles `AGENT.override.md` logic. | [Agent Definition](./use-agent-md/agents/openai.yaml) |

---

## 📂 Directory Structure Pattern

Each skill in this repository follows a standardized structure:
- `SKILL.md`: The main entry point and human-readable guide.
- `agents/`: Metadata for AI agent discovery (`openai.yaml`).
- `references/`: Supporting materials including templates, scripts, and examples.

## 🚀 How to Use

1. **Browse**: Look through the index table above.
2. **Follow**: Open the `SKILL.md` of any skill for step-by-step instructions.
3. **Automate**: Use the `init` scripts in `references/` for rapid development.
4. **Agentic Workflows**: If you are an AI assistant, check `agents/openai.yaml` to understand the schema and usage of the skill.

---
*Created and maintained by Antigravity.*
