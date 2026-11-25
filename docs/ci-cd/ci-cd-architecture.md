# CI/CD Architecture

## Pipeline

Feature branch → lint/format/test → build → security scan → PR to preview → preview → test → main

## Quality Gates

| Branch | Checks |
|--------|--------|
| Feature | fmt, vet, staticcheck, golangci-lint, unit tests, security (gosec), frontend lint/type/test |
| test | Full integration, API contract, migration up/down, E2E (Playwright), Docker build/scan, regression |
| main | Production acceptance, clean migration, release checks, image publish (GHCR), deploy readiness |
| preview | Dependency compat, Renovate/Dependabot, security updates |

## Image Publishing

- Tags: SemVer (vX.Y.Z), commit SHA, latest (only from main tag)
- Registry: ghcr.io/rasimaghayev/marketplace-platform
- Only after quality gate is green
