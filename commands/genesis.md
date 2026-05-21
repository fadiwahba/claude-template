---
description: Initialise Claude files in a project — explores the codebase, populates templates, and writes CLAUDE.md, .claude/rules/*, KNOWLEDGE_BASE.md, and .claudeignore. Pass any argument (e.g. --yes) to skip the discovery gate.
argument-hint: [--yes | auto | any value to skip the discovery gate]
---

## `/genesis` — Claude Project Initialiser

You are executing the `/genesis` command. Follow every phase below **exactly and in order**. Do not skip phases, do not combine phases, do not paraphrase instructions.

---

## Phase 1 — Template Check

Read each of the following files. If any are missing, stop immediately and output the error block below — do not proceed to Phase 2.

Required template files:
- `~/.claude/templates/CLAUDE.md`
- `~/.claude/templates/.claude/rules/stack.md`
- `~/.claude/templates/.claude/rules/architecture.md`
- `~/.claude/templates/.claude/rules/conventions.md`
- `~/.claude/templates/.claude/rules/commands.md`

If any file is missing, output exactly:
```
ERROR: /genesis cannot run — missing template files in ~/.claude/templates/

Expected files:
  ~/.claude/templates/CLAUDE.md
  ~/.claude/templates/.claude/rules/stack.md
  ~/.claude/templates/.claude/rules/architecture.md
  ~/.claude/templates/.claude/rules/conventions.md
  ~/.claude/templates/.claude/rules/commands.md

To fix: restore the missing files to ~/.claude/templates/ and re-run /genesis.
```

Then stop. Do not continue.

---

## Phase 2 — Deep Codebase Exploration

Explore the current working directory to build a **discovery object**. Read every source listed below that exists — skip silently if absent.

### Sources to read (in this order)

1. `package.json` — framework, version, scripts (dev/build/test/lint), dependencies
2. `pyproject.toml` or `setup.py` — if Python project
3. `Cargo.toml` — if Rust project
4. `go.mod` — if Go project
5. Lock files: `pnpm-lock.yaml` → pnpm; `bun.lockb` → bun; `yarn.lock` → yarn; `package-lock.json` → npm
6. `tsconfig.json` or `jsconfig.json` — strict mode, path aliases (look for `@/` or similar)
7. Any config file matching: `next.config.*`, `vite.config.*`, `astro.config.*`, `nuxt.config.*`, `svelte.config.*`, `remix.config.*`
8. Top-level directory listing — identify key folders, detect monorepo (presence of `packages/`, `apps/`, `libs/`)
9. `src/` or `app/` — list up to 10 files; read 3–5 representative source files to infer naming conventions and import patterns
10. `.env.example` — environment variable names (not values)
11. First 50 lines of `README.md` if present
12. `.github/workflows/*.yml` — detect CI commands and deployment targets
13. `Dockerfile` or `docker-compose.yml` — infrastructure clues
14. `Makefile` or `justfile` — custom commands

### Discovery object to build

Populate every field. Use the literal string `unknown` for any field you cannot determine — never guess or fabricate.

```
language:            e.g. TypeScript | Python | Go | Rust | JavaScript
framework:           e.g. Next.js 15 (App Router) | Vite + React | FastAPI | unknown
ui_library:          e.g. React 19 | Vue 3 | Svelte 5 | unknown
styling:             e.g. Tailwind CSS v4 + shadcn/ui | CSS Modules | styled-components | unknown
state:               e.g. Zustand + TanStack Query | Redux Toolkit | Pinia | unknown
forms:               e.g. React Hook Form + Zod | Formik | unknown
runtime:             e.g. Node.js 22 | Bun 1.x | Deno | unknown
backend_framework:   e.g. Next.js Route Handlers | Express | FastAPI | NestJS | unknown
database:            e.g. PostgreSQL 16 + Prisma | SQLite + Drizzle | MongoDB | unknown
auth:                e.g. Auth.js | Clerk | custom JWT | unknown
package_manager:     e.g. pnpm 9 | bun | yarn | npm | unknown
monorepo_tool:       e.g. Turborepo | Nx | none | unknown
linter:              e.g. ESLint flat config | Biome | Ruff | unknown
formatter:           e.g. Prettier | Biome | Black | unknown
test_runner:         e.g. Vitest | Jest | Playwright | pytest | unknown
host:                e.g. Vercel | Hetzner | AWS | unknown
ci_cd:               e.g. GitHub Actions | GitLab CI | unknown
container:           e.g. Docker | Docker Compose | none | unknown
dev_command:         e.g. pnpm dev | bun dev | python manage.py runserver | unknown
build_command:       e.g. pnpm build | cargo build | unknown
test_command:        e.g. pnpm test | pytest | go test ./... | unknown
lint_command:        e.g. pnpm lint | ruff check . | unknown
typecheck_command:   e.g. pnpm typecheck | mypy . | unknown
key_directories:     list each significant top-level dir with a one-line purpose
naming_convention:   e.g. PascalCase components / camelCase utils / snake_case Python | unknown
import_alias:        e.g. @/ → src/ | none detected
ts_strict:           true | false | unknown
commit_style:        e.g. Conventional Commits | unknown
branch_pattern:      e.g. feat/, fix/, chore/ | unknown
```

---

## Phase 3 — Discovery Gate

**Skip this entire phase if `$ARGUMENTS` is non-empty.** Proceed directly to Phase 4.

Otherwise, present the discovery object as a human-readable summary in this exact format:

```
DISCOVERY SUMMARY — /genesis
──────────────────────────────────────────────────────
Language / Runtime:    <language> · <runtime>
Framework:             <framework>
UI Library:            <ui_library>
Styling:               <styling>
State / Data:          <state>
Package manager:       <package_manager>
Database:              <database>
Auth:                  <auth>
Monorepo:              <monorepo_tool>
Test runner:           <test_runner>
Container:             <container>

Commands detected:
  dev:         <dev_command>
  build:       <build_command>
  test:        <test_command>
  lint:        <lint_command>
  typecheck:   <typecheck_command>

Key directories:
<list each key_directory entry as "  path/   purpose">

Conventions:
  Naming:        <naming_convention>
  Import alias:  <import_alias>
  TS strict:     <ts_strict>
  Commit style:  <commit_style>
  Branch names:  <branch_pattern>

Unknown fields (left as placeholders): <comma-separated list of unknown fields, or "none">
──────────────────────────────────────────────────────
Proceed with these values? Reply "yes" to continue, or describe any corrections.
```

Wait for the user's reply before continuing to Phase 4.

If the user provides corrections, update the relevant discovery fields, confirm the changes in one sentence, then proceed to Phase 4 without re-presenting the full summary.

---

## Phase 4 — Write Files

Write each file listed below. **Skip any file that already exists — do not overwrite.** Track which files were created and which were skipped.

### 4a — CLAUDE.md

If `CLAUDE.md` does not exist in the project root:
- Copy the content of `~/.claude/templates/CLAUDE.md` verbatim.
- Write it to `./CLAUDE.md`.

### 4b — .claude/rules/ files

For each of the 4 rule files, check if it exists before writing. Skip if present.

Create the `.claude/rules/` directory if it does not exist.

#### stack.md

Copy `~/.claude/templates/.claude/rules/stack.md` and replace every `<!-- e.g. ... -->` placeholder with the corresponding discovered value. If the value is `unknown`, leave the placeholder comment intact. Remove entire rows/lines whose technology was clearly not detected (e.g. remove the "CMS" line if no CMS was found). Write to `./.claude/rules/stack.md`.

#### architecture.md

Copy `~/.claude/templates/.claude/rules/architecture.md` and:
- Replace the directory tree example with the actual `key_directories` from the discovery object, formatted as a code block matching the template's style.
- Leave the "Data Flow", "External Services", "Boundaries", and "Known Gotchas" sections as comment placeholders — the user fills these in over time.

Write to `./.claude/rules/architecture.md`.

#### conventions.md

Copy `~/.claude/templates/.claude/rules/conventions.md` verbatim. Write to `./.claude/rules/conventions.md`.

If the project is **not** TypeScript/JavaScript (e.g. Python, Go, Rust), prepend this note at the top of the file before any other content:
```
> ⚠️  This project uses <language>. The conventions below are TypeScript/React defaults from the template — update them to match the actual language and stack.
```

#### commands.md

Copy `~/.claude/templates/.claude/rules/commands.md` and replace the placeholder bash commands with the detected values:
- `pnpm dev` → `<dev_command>`
- `pnpm build` → `<build_command>`
- `pnpm start` → `<start_command if detected, else leave placeholder comment>`
- `pnpm lint` → `<lint_command>`
- `pnpm lint:fix` → `<lint_command> --fix (or detected equivalent)`
- `pnpm typecheck` → `<typecheck_command>`
- `pnpm test` → `<test_command>`
- `pnpm test:watch` → `<test_command> --watch (or detected equivalent)`
- `pnpm format` → `<formatter> --write . (or detected equivalent)`

If a command is `unknown`, leave the template placeholder comment for that line.

Write to `./.claude/rules/commands.md`.

### 4c — KNOWLEDGE_BASE.md

If `KNOWLEDGE_BASE.md` does not exist in the project root, write to `./KNOWLEDGE_BASE.md` with exactly this content:

```markdown
# Knowledge Base

> Authoritative source of truth for architectural decisions, conventions, gotchas, and persistent learnings.
> Updated via `/sync-knowledge`. Keep lean — only information that changes future behaviour belongs here.

## Architecture Decisions

## Known Gotchas

## Integration Constraints

## Workflow Conventions
```

### 4d — .claudeignore

If `.claudeignore` does not exist in the project root, build the ignore list from two parts:

**Always include (universal):**
```
# Dependencies
node_modules/
.pnp/
.pnp.js

# Build outputs
dist/
build/
out/
.next/
.nuxt/
.svelte-kit/
.astro/

# Cache & tooling
.cache/
.parcel-cache/
.turbo/
.eslintcache
.stylelintcache
*.tsbuildinfo

# Test output
coverage/
.nyc_output/

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# Environment & secrets
.env
.env.*
!.env.example
*.pem
*.key

# OS artifacts
.DS_Store
Thumbs.db

# Git
.git/
```

**Append conditionally based on discovered stack:**

If Python detected:
```
# Python
__pycache__/
*.py[cod]
*.pyo
.venv/
venv/
env/
.pytest_cache/
*.egg-info/
.mypy_cache/
.ruff_cache/
```

If Rust detected:
```
# Rust
target/
```

If Go detected:
```
# Go
bin/
*.exe
```

If monorepo detected (Turborepo/Nx or `packages/`/`apps/` directories exist):
```
# Monorepo — nested dependencies
packages/*/node_modules/
apps/*/node_modules/
libs/*/node_modules/
```

Write the combined list to `./.claudeignore`.

---

## Final Report

Output the completion report in this exact format:

```
/genesis complete ✓
──────────────────────────────────────────────────────
Created:
  ✓ CLAUDE.md
  ✓ .claude/rules/stack.md
  ✓ .claude/rules/architecture.md
  ✓ .claude/rules/conventions.md
  ✓ .claude/rules/commands.md
  ✓ KNOWLEDGE_BASE.md
  ✓ .claudeignore

Skipped (already existed):
  — <list files that were skipped, or "none">

Placeholder fields remaining (fill these in manually):
  <list of unknown fields that left template placeholders, or "none">
──────────────────────────────────────────────────────
Next: run /sync-knowledge after your first working session to start populating KNOWLEDGE_BASE.md.
```
