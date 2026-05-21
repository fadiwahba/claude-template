# Code Conventions

## TypeScript

- `strict: true` always. No `any` — use `unknown` and narrow.
- Prefer `interface` over `type` for object shapes; use `type` for unions, intersections, and primitives.
- Explicit return types on exported functions and React components when non-trivial.
- Use `satisfies` for typed config objects instead of casting.
- Prefer discriminated unions over optional fields when modelling state.

## React

- Functional components only. No class components.
- Server Components by default; mark Client Components with `"use client"` only when needed (state, effects, browser APIs, event handlers).
- One component per file. Co-locate the component with its types and (if requested) tests.
- Props: destructure in the parameter list; never pass `...rest` blindly except for primitive HTML wrappers.
- Hooks: name `useThing`, keep them pure, no side effects outside `useEffect`.

## Styling

- Tailwind utility classes first. Reach for `@apply` or custom CSS only when utilities can't express it cleanly.
- Use `cn()` (clsx + tailwind-merge) for conditional class composition.
- Design tokens live in the Tailwind theme — don't hardcode hex values in components.
- shadcn/ui primitives are owned by the project — modify them directly if needed, don't wrap them in another wrapper for trivial reasons.

## File & Folder Naming

| Kind | Convention | Example |
|---|---|---|
| Component file | `PascalCase.tsx` | `UserCard.tsx` |
| Hook file | `useCamelCase.ts` | `useAuth.ts` |
| Utility file | `camelCase.ts` | `formatDate.ts` |
| Route folder | `kebab-case` | `app/user-settings/` |
| Type file | `camelCase.ts` or `types.ts` | `user.types.ts` |
| Constants file | `camelCase.ts` or `constants.ts` | `routes.ts` |

## Imports

- Absolute paths via the `@/` alias for anything inside `src/`. No deep relative paths (`../../../`).
- Group order: external libs → internal modules (`@/`) → relative (`./`) → types (separate `import type`).
- One import per line; let Prettier sort.

## Don't

- Don't add comments unless they explain *why*, not *what*. Code should be self-documenting.
- Don't introduce a new dependency without checking with the user first.
- Don't write tests unless the user asks for them.
- Don't generate boilerplate `try/catch` blocks that just rethrow — let errors propagate to the proper boundary.
- Don't use `useEffect` to derive state — derive it directly during render.
- Don't `console.log` in committed code — use the project's logger.

## Do

- Do prefer composition over configuration.
- Do colocate logic with where it's used; promote to `lib/` only when shared.
- Do write code that fails loudly and early — throw, don't silently fallback.
- Do use Zod (or the project's validator) at trust boundaries (API input, env vars, external responses).
