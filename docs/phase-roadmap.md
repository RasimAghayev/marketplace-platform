# Phase Roadmap

| # | Phase | Focus |
|---|-------|-------|
| 0 | Repository Foundation | Repo, community, branch protection, GitHub Project, labels, templates, Renovate |
| 1 | Architecture & ADRs | C4 diagrams, domain boundaries, DB responsibility matrix, event architecture, security arch |
| 2 | Local Docker Infra | Compose, PostgreSQL, MongoDB, Redis, NATS, Nginx, monitoring, logging, healthchecks, backup/restore |
| 3 | CI/CD & Quality | GitHub Actions, branch workflows, security scanning, dependency mgmt, Docker image scan |
| 4 | Deployment Infra | VPS, Swarm, Kubernetes/Helm, Terraform modules (AWS/GCP/Azure) |
| 5 | Testing & Data Infra | Testcontainers, factories, synthetic 2-year dataset, idempotent seed, migration up/down tests |
| 6 | Backend Foundation | Go monolith skeleton, config (Viper), logging (zerolog), DI (Wire/Fx), auth foundation, event infra (Outbox), API conventions, OpenAPI |
| 7 | Frontend Foundation | Next.js workspace, design system, tRPC/GraphQL, auth UI, routing, state, responsive |
| 8 | Infrastructure Acceptance Gate | All §16 criteria met |
| 9 | Core Business | Platform tenancy, Auth, Stores, Catalog, Products |
| 10 | Orders & Payments | Cart, checkout, order lifecycle, payment abstraction, wallet, refunds |
| 11 | Inventory, Delivery, Couriers | Stock, reservations, zones, assignment, GPS tracking, real-time |
| 12 | Loyalty, Notifications, Marketing | Points, tiers, campaigns, referrals, multi-channel notifications |
| 13 | Analytics, Admin, Advanced | Dashboards, reports, AI recommendations, fraud detection, multi-lang |
| 14 | Production Readiness | Load/perf/security audit, E2E, accessibility, disaster recovery, runbooks, release |

## Infrastructure Acceptance Gate (§16)

ALL must pass before Phase 9:
- Repo, community standards, security settings complete
- Branch protection works; feature→test→main, preview→test→main validated
- Project, milestones, epics/tasks/subtasks with dependencies created
- GitHub Actions + Renovate operational
- `docker compose up -d` — all services healthy
- Logging, monitoring, tracing, alerting operational
- Migration + deterministic idempotent seed tests pass
- Backup + restore tested successfully
- Security scans (dep, secret, SAST, container) green
- All infra integration tests pass in Docker
- Documentation matches implementation
