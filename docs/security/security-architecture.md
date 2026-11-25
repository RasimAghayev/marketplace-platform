# Security Architecture

## Principles

- No secrets/tokens in repo
- Secrets via env vars or secret manager only
- No hardcoded credentials
- .gitignore covers .env*/keys
- .env.example with placeholders only
- Pre-commit secret scan
- CI secret-scan job
- GitHub secret scanning + push protection
- Actions pinned by commit SHA
- OIDC instead of long-lived cloud credentials
- Least-privilege permissions
- No secrets to fork PRs

## Security Scans

- Dependabot alerts/updates
- Secret scanning
- Code scanning (CodeQL)
- Container image scanning (Trivy)
- gosec (Go source scanning)
- npm audit (frontend)

## Security Headers

- CORS configuration
- Rate limiting
- Input validation
- SQL injection prevention
- XSS protection
