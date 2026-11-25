# Marketplace Platform

Production-ready event-driven multi-tenant marketplace platform built with Go, Next.js, PostgreSQL, MongoDB, Redis, NATS, Docker and automated CI/CD.

## Technology Stack

| Area | Choice |
|------|--------|
| Backend | Go 1.23+, Chi, gRPC, GraphQL (gqlgen), OpenAPI |
| Frontend | Next.js 15, React 19, TypeScript, Tailwind, tRPC |
| Databases | PostgreSQL (primary), MongoDB (documents), Redis (hot) |
| Messaging | NATS JetStream |
| Containers | Docker, Docker Compose |
| CI/CD | GitHub Actions, Dependabot |
| Observability | Prometheus, Grafana, Loki, OpenTelemetry, Jaeger |

## Architecture

Modular monolith + EDA, Clean Architecture, DDD, Repository Pattern, Dependency Injection.

Bounded contexts: Platform, Auth, Stores, Catalog, Orders, Payments, Inventory, Delivery, Notifications, Loyalty, Analytics.

## Getting Started

### Prerequisites

- Docker and Docker Compose only. No host language runtimes.

### Local Development

```bash
make up
```

This builds and starts all services (backend, frontend, PostgreSQL, MongoDB, Redis, NATS, Nginx, monitoring stack) via Docker Compose.

### Testing

```bash
make test
```

Runs the test suite inside Docker containers.

### Verification

```bash
make verify
```

Runs build + test stages. `make up` depends on `make verify`.

## Documentation

Full technical documentation is in `docs/`:
- `docs/architecture/` — C4 diagrams, ADRs, domain boundaries
- `docs/database/` — ERD, responsibility matrix
- `docs/infrastructure/` — Docker, deployment, monitoring
- `docs/api/` — OpenAPI specs
- `docs/security/` — Security architecture
- `docs/testing/` — Test strategy and reports

See `docs/DEPLOYMENT.md` and `docs/OPERATIONS.md` for deployment and operations procedures.

## Community

- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) — Contributor Covenant 2.1
- [CONTRIBUTING.md](CONTRIBUTING.md) — How to contribute
- [SECURITY.md](SECURITY.md) — Vulnerability reporting
- [SUPPORT.md](SUPPORT.md) — Support channels
- [CHANGELOG.md](CHANGELOG.md) — Release history
- [ACCESSIBILITY.md](ACCESSIBILITY.md) — Accessibility commitment

## License

[MIT](LICENSE)
