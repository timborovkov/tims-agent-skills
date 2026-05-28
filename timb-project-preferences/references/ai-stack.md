# AI Stack Preferences

- LangChain and LangGraph for agent/workflow orchestration when useful.
- Use LangChain middleware for agent cross-cutting concerns such as tool selection, human-in-the-loop approval/checkpoints, conversation summarization, guardrails, retries, tracing hooks, and context management.
- LangSmith for tracing/evaluation when AI behavior needs observability.
- Vercel AI SDK, including its UI utilities, for streaming/chat UI when appropriate.
- OpenRouter is the default inference gateway and model access layer unless the project explicitly requires direct provider SDKs.
- Model definitions and model routing/config live in code as versioned config files, not in environment variables. Env vars should hold secrets and deployment-specific endpoints only.
