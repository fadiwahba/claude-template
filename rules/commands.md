# Project Commands

<!-- The exact commands to run common tasks. Replace the placeholders with what actually works in this project. Subagents should use these instead of guessing. -->

## Development

```bash
pnpm dev          # start dev server (default port 3000)
pnpm build        # production build
pnpm start        # start production server
```

## Quality Gates

```bash
pnpm lint         # ESLint
pnpm lint:fix     # ESLint + auto-fix
pnpm typecheck    # tsc --noEmit
pnpm test         # run tests
pnpm test:watch   # watch mode
pnpm format       # Prettier write
```

Before declaring any task "done", run at minimum: `pnpm typecheck && pnpm lint`.

## Database

```bash
# fill in per project, e.g.:
# pnpm db:push          # push schema (dev)
# pnpm db:migrate       # generate + run migration
# pnpm db:studio        # open DB GUI
# pnpm db:seed          # seed dev data
```

## Deployment

```bash
# fill in per project, e.g.:
# git push origin main           # CI handles deploy
# ssh hetzner "cd /apps/foo && pm2 reload foo"
```

## Git Workflow

- Branch from `main`. Branch names: `feat/<short-desc>`, `fix/<short-desc>`, `chore/<short-desc>`.
- Commit style: <!-- e.g. Conventional Commits, "type(scope): subject" -->
- Never `git push --force` to a shared branch. Use `--force-with-lease` on personal branches.
- Pull requests must pass typecheck + lint + tests before merge.

## Environment

- `.env.local` for local dev secrets — never commit.
- `.env.example` lists all required keys with placeholder values — keep in sync.
- Production secrets live in <!-- e.g. Hetzner via systemd EnvironmentFile, GitHub Actions secrets, etc. -->.
