# Product Service Preferences

- Use Daytona for sandboxing dangerous or untrusted code execution.
- Use PostHog as the guided default for product analytics and feature flags.
- Define a typed product event map: event name, owner, trigger, payload shape, PII policy, and retention. Track meaningful lifecycle events, not every click.
- Use PostHog feature flags by default when PostHog is installed. Keep flag keys typed, documented, owned, and scheduled for cleanup; do not leave flags as permanent config.
- Use Cloudflare Turnstile for risky public surfaces such as contact forms, signup abuse points, anonymous submissions, and exposed AI/API entry points.
- Use Novu for product notifications when notification workflows are needed.
- Use Postmark for email when two-way support, inbound handling, or high-deliverability product email matters.
- Use Resend for simpler outbound email when two-way support is not needed.
- Prefer Polar for payments and billing.
- Use BillingSDK with Polar for billing UI and customer-facing billing flows.
- Keep service provider choices documented in `CONTRIBUTING.md`, deployment docs, and env examples.
- Secrets belong in environment/secret stores only; provider/model/product configuration belongs in versioned code where it is not secret.
