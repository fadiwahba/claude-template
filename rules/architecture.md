# Architecture

<!-- High-level architecture overview. The goal is fast onboarding for any new agent: where things live, how data flows, what NOT to touch. -->

## Key Directories

```
src/
├── app/              # Next.js App Router routes
│   ├── (public)/     # public marketing/landing
│   ├── (app)/        # authenticated app
│   └── api/          # route handlers
├── components/
│   ├── ui/           # shadcn/ui primitives — DO NOT EDIT generated files
│   └── <feature>/    # feature-specific components
├── lib/              # framework-agnostic utilities, helpers
├── server/           # server-only code (DB, auth, server actions)
├── hooks/            # custom React hooks
├── types/            # shared TypeScript types
└── styles/           # global CSS only — prefer Tailwind for components
```

<!-- Update this tree to match your project. Delete what doesn't apply. -->

## Data Flow

<!-- Describe how data moves through the app. Example:
1. Client → Server Action (in src/server/actions/) → DB via Drizzle
2. Mutations invalidate TanStack Query keys
3. Server Components fetch directly from DB; never via API
-->

## External Services

<!-- Third-party APIs, webhooks, OAuth providers, payment gateways. Include base URLs and where credentials live. -->

## Boundaries — DO NOT cross without asking

<!-- Files / directories that shouldn't be touched casually. Examples:
- src/components/ui/* — shadcn-generated, regenerate via CLI instead
- prisma/migrations/* — never edit historical migrations
- public/* — static assets, ask before adding
-->

## Known Gotchas

<!-- Things that have bitten you before. Examples:
- Strapi v5 uses documentId (not id) as the public identifier
- Next.js 15 cookies() and headers() are async — must `await`
- PM2 cluster mode breaks if the app uses module-level singletons
-->
