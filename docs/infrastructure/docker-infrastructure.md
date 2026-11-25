# Docker Infrastructure Design

## Compose Profiles

- `dev` — Full local development stack
- `test` — CI test stack
- `prod` — Production stack
- `observability` — Prometheus, Grafana, Loki, Jaeger

## Services

- backend (Go API)
- frontend (Next.js)
- postgres (PostgreSQL)
- mongodb (MongoDB)
- redis (Redis)
- nats (NATS JetStream)
- nginx (Ingress)
- prometheus (Metrics)
- grafana (Dashboards)
- loki (Logs)
- jaeger (Tracing)

## Standards

- Multi-stage Dockerfiles
- Non-root runtime
- Healthchecks
- Resource limits
- Secrets via env/Docker secrets
- BuildKit cache mounts
