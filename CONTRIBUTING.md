# Contributing

Thank you for considering contributing to the Marketplace Platform! This document outlines the contribution process.

## How to Contribute

1. **Report bugs and feature requests** using the issue templates in `.github/ISSUE_TEMPLATE/`.
2. **Fork the repo** and create a branch from `preview`.
3. **Write code** following the conventions in this repo.
4. **Run `make verify`** (build + test) in Docker before submitting.
5. **Open a PR** against `preview` with a Conventional Commit title.
6. **Maintainers review** and merge after CI is green.

## Branch Naming

- `phase-<n>/<topic>` — for phase work (e.g. `phase-0/repo-foundation`)
- `feature/ISSUE-<n>-<slug>` — for issue-driven work
- `renovate/*` / `dependabot/*` — dependency updates (target `preview`)

## Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` — new feature
- `fix:` — bug fix
- `docs:` — documentation changes
- `test:` — adding or updating tests
- `chore:` — build/tooling changes
- `build(deps):` — dependency updates
- `refactor:` — code refactoring
- `perf:` — performance improvements
- `security:` — security fixes
- `revert:` — reverting changes

One logical change per commit. Breaking changes use `!` or `BREAKING CHANGE:`.

## Development Setup

All development runs in Docker:

```bash
make up        # Build and start all services (depends on make verify)
make test      # Run the test suite
make verify    # Build + test (run this before make up)
make shell     # Open a shell in the backend container
make logs      # View service logs
make down      # Stop all services
```

Code is written only inside `projects/worktrees/marketplace-platform/` (git worktree).

## Review Process

- One PR per phase per repo (per the GitHub Issue-driven workflow)
- Maintainers merge after CI is green
- Required status checks must pass
- No force push or deletion of protected branches

## AI-Attribution Ban

No commit, PR title, PR description, or PR/issue comment carries an AI co-author or session trailer (e.g. `Co-Authored-By: ...`, `Generated with ...`, AI session links). Authorship is the contributor's alone.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
