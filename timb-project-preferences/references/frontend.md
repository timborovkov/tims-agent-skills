# Frontend Preferences

- Choose the frontend framework by project shape. For lightweight frontends, prefer Vite with React instead of reaching for Next.js by default.
- Use Next.js with App Router when the app benefits from routing conventions, SSR/RSC, server routes, SEO-heavy pages, middleware/proxy behavior, or deployment/platform integrations. Use the latest stable supported Next.js release, fetch current docs before version-sensitive setup, and avoid deprecated conventions. In Next.js 16, use `proxy.ts`/`proxy.js` and `proxy` exports instead of deprecated `middleware.ts`/`middleware.js` and `middleware` exports unless the repo has a documented reason.
- Run `react-doctor` for Next.js/React projects when reviewing or improving codebase health, performance, security, correctness, or architecture.
- TypeScript for all app and component code. Prefer `.tsx` for React components and `.ts` for utilities, route handlers, server actions, config, tests, and scripts.
- Keep strict TypeScript settings on. Do not loosen `strict`, `noImplicitAny`, or related checks to make code pass.
- Tailwind CSS and shadcn/ui for UI primitives, including modals, popovers, buttons, menus, form controls, and dialogs.
- No custom one-off component primitives when shadcn/ui fits.
- Proper loading, empty, pending, optimistic, success, and error states.
- i13n/i18n by default: no hardcoded user-facing strings in app code when the project has or should have a message/catalog system.
- React Query where reasonable for client/server state, especially caching, invalidation, optimistic updates, and mutation status.
- Vitest for unit/component tests unless the repo has a stronger existing choice.
