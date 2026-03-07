# Contributing Guide

## Workflow

1. Create a branch from the latest `codex/initial-setup` (or the current integration branch).
2. Make small, focused changes.
3. Run quality checks.
4. Open a PR with clear scope and testing notes.

## Branch Strategy

Use `codex/` prefix for all working branches.

Recommended branch names:

- `codex/feat-pos-cart`
- `codex/fix-printer-reconnect`
- `codex/chore-ci-lint`
- `codex/docs-readme`

Keep one concern per branch.

## Commit Convention

Use Conventional Commit style:

- `feat(scope): add new capability`
- `fix(scope): fix a bug`
- `chore(scope): maintenance/config`
- `refactor(scope): internal restructuring`
- `test(scope): add/update tests`
- `docs(scope): update documentation`

Examples:

- `feat(app): add flavor bootstrap and env config`
- `feat(core): add logger abstraction and global error handlers`
- `feat(ui): add shared loading error empty widgets`
- `docs(readme): add architecture and folder rules`

Rules:

- Keep commits small and atomic.
- Commit only related files in one commit.
- Write imperative messages (`add`, `fix`, `update`).

## PR Checklist

Before creating PR:

```bash
flutter pub get
flutter analyze
flutter test
```

Include in PR description:

- What changed
- Why it changed
- How it was tested
- Screenshots (if UI changed)

## Code Organization Rules

- Follow project folder rules in `README.md`.
- Use design tokens from `lib/app/design_system.dart`.
- Do not add direct service implementations in UI pages.
- Keep shared widgets generic and reusable.

## Secrets and Sensitive Files

Do not commit:

- `.env`
- `.env.*`
- `android/key.properties`
- `*.jks`
- `*.keystore`
