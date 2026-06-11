# AI Product Rules

These rules extend the baseline AGENTS.md for building generative AI applications and LLM pipelines.

## 1. Prompt Architecture

- **Separation of Concerns**: Do not hardcode prompt instructions within business logic control flow. Maintain them as clean, isolated templates or config objects.
- **Templating**: Inject user inputs into prompt placeholders safely. Always escape inputs if they might break prompt boundaries (Prompt Injection defense).

## 2. LLM Operations

- **Structured Output**: Enforce JSON schema responses (e.g., Structured Outputs, function calling, or response formats) instead of parsing unstructured text manually with regex.
- **Streaming by Default**: For conversational or slow generation endpoints, implement token-by-token streaming response to minimize perceived latency.
- **Fallback Mechanisms**: Configure alternate models (e.g., smaller or offline models) or cached static responses if the primary API fails.

## 3. Cost & Performance

- **Context Optimization**: Prune unnecessary history or details before sending requests. Limit input tokens dynamically based on task requirements.
- **Rate Limit Resilience**: Wrap LLM calls in robust rate-limiting middleware supporting exponential backoff.
