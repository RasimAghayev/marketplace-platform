# Branch Protection Plan

## Branches

| Branch | Purpose | Rules |
|--------|---------|-------|
| main | Production-ready | Only test → PR; all CI/security/migration green; required reviews; no force push/delete |
| test | Integration/QA | Feature/infra/bugfix/docs → PR; unit/integration/API/E2E/migration/security/Docker green |
| preview | Dependency updates | Renovate/Dependabot PRs only; green → aggregate → test; never direct to main |

## Flow

`feature/*` → `test` → `main`; `renovate/*` → `preview` → `test` → `main`.

## Protection Settings

- Required PR reviews: 1
- Dismiss stale reviews: Yes
- Require code owner reviews: Yes
- Required conversation resolution: Yes
- Required linear history: Yes
- Allow force pushes: No
- Allow deletions: No
- Enforce admins: Yes
- Required status checks: CI green

## Source Branch Validation

main only accepts PRs from test (enforced via GitHub Actions workflow).
