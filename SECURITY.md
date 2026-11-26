# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| latest  | :white_check_mark: |

## Reporting a Vulnerability

**Do not open a public issue for security vulnerabilities.**

Please report security vulnerabilities privately:

- **GitHub Security Advisories**: Use the "Report a vulnerability" button on this repository (private reporting)
- **Email**: rasimaghayev@gmail.com

Include:
- Description of the vulnerability
- Steps to reproduce
- Affected components and versions
- Potential impact
- Suggested fix (if any)

## Response Timeline

- **P0 (Critical)**: Immediate acknowledgment, fix within 24 hours
- **P1 (High)**: Acknowledgment within 24 hours, fix within 72 hours
- **P2 (Medium)**: Acknowledgment within 3 business days, fix within 1 week
- **P3 (Low)**: Acknowledgment within 1 week, fix in next release

## Scope

- Application code (Go, TypeScript)
- CI/CD pipelines and GitHub Actions
- Docker images and base images
- Dependencies (Go modules, npm packages)
- Secrets and credential handling
- Infrastructure configuration

## After a Report

1. Acknowledge receipt
2. Triage and assess severity
3. Develop and test a fix
4. Coordinated disclosure
5. Rotate any exposed secrets if credentials were involved

## Security Measures

- Dependabot alerts and updates enabled
- Secret scanning and push protection enabled
- CodeQL code scanning enabled
- Container image scanning
- Pre-commit secret scanning
- No secrets committed to repository
