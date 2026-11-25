# ADR 0001: Technology Stack Selection

## Status

Accepted

## Context

The Marketplace Platform requires a technology stack that supports:
- High concurrency and horizontal scalability
- Strong typing and compile-time safety
- Polyglot persistence (relational, document, cache, event streaming)
- Event-driven architecture with exactly-once semantics
- Full-stack type safety between backend and frontend
- Container-first deployment with Docker and Kubernetes
- Production-grade observability (metrics, logging, tracing)

## Decision

| Area | Choice | Version |
|------|--------|---------|
| Backend Language | Go | 1.23+ |
| Backend Framework | Chi (HTTP), gRPC, GraphQL (gqlgen) | Latest stable |
| Backend Tests | testify, ginkgo/gomega, testcontainers-go | Latest stable |
| Frontend Framework | Next.js | 15 |
| Frontend Library | React | 19 |
| Frontend Language | TypeScript | 5.6+ |
| Frontend Styling | Tailwind CSS | 3.4+ |
| API Layer | tRPC | Latest stable |
| Primary Database | PostgreSQL | 16 |
| Document Database | MongoDB | 7 |
| Cache / Hot Data | Redis | 7 |
| Event Streaming | NATS JetStream | Latest stable |
| Container Runtime | Docker | Latest stable |
| Container Orchestration | Docker Swarm, Kubernetes | Latest stable |
| CI/CD | GitHub Actions | Native |
| Dependency Management | Dependabot | Weekly |
| Observability | Prometheus, Grafana, Loki, Jaeger, OpenTelemetry | Latest stable |
| Code Quality | golangci-lint, staticcheck, gosec, Trivy, CodeQL | Latest stable |

## Rationale

### Go for Backend
- **Performance**: Compiled to native code, excellent for high-throughput APIs
- **Concurrency**: Goroutines and channels for concurrent request handling
- **Strong typing**: Compile-time error catching, refactoring safety
- **Standard library**: Rich stdlib reduces external dependency surface
- **Container-friendly**: Small binary size, fast startup, non-root capable
- **Ecosystem**: Mature database drivers (pgx, mongo-driver), NATS client, Chi router

### PostgreSQL as Primary Database
- **ACID compliance**: Critical for financial transactions (orders, payments, loyalty)
- **Relational integrity**: Foreign keys, constraints, transactions for order state machines
- **JSONB support**: Flexible schema where needed without losing relational benefits
- **Mature ecosystem**: Extensive tooling, monitoring, backup/recovery options
- **Connection pooling**: pgx with native connection pooling

### MongoDB for Documents
- **Flexible schema**: Order event history, delivery tracking, audit trails
- **Horizontal scaling**: Sharding for high-volume event data
- **Append-only workloads**: Ideal for event sourcing and audit logs
- **Geospatial queries**: Delivery zone and courier location queries

### Redis for Hot Data
- **Sub-millisecond latency**: Session storage, rate limiting, OTP, cart cache
- **Data structures**: Sorted sets for leaderboards, hashes for sessions
- **Pub/Sub**: Real-time courier location updates, order status notifications
- **TTL support**: Automatic expiration for sessions, rate limits, OTP codes

### NATS JetStream for Event Streaming
- **Exactly-once semantics**: Critical for order and payment events
- **Durable streams**: Event replay and consumer recovery
- **Lightweight**: Lower operational overhead than Kafka
- **JetStream persistence**: Durable message storage with acknowledgments
- **Subject-based routing**: `marketplace.orders.*`, `marketplace.payments.*`, etc.

### Next.js 15 + React 19 + TypeScript for Frontend
- **Full-stack framework**: Server components, API routes, incremental static regeneration
- **Type safety**: tRPC provides end-to-end type safety between backend and frontend
- **React 19**: Concurrent features, improved hydration, actions
- **Tailwind CSS**: Utility-first styling, rapid UI development
- **Four apps**: customer-web, merchant-web, courier-web, admin-web from one monorepo

### tRPC for API Layer
- **End-to-end type safety**: Shared types between Go backend (via generated clients) and TypeScript frontend
- **No code generation overhead**: Unlike GraphQL, no schema file to maintain
- **Lightweight**: Smaller bundle size, simpler middleware
- **React integration**: First-class React hooks for queries and mutations

### Docker + Docker Compose for Local Development
- **Environment parity**: Same images run locally, in CI, and in production
- **No host dependencies**: No Go, Node, PostgreSQL, MongoDB, Redis, or NATS installed on host
- **Multi-stage builds**: Small production images, non-root runtime
- **Compose profiles**: dev, test, prod, observability profiles

### GitHub Actions for CI/CD
- **Native integration**: Tightly integrated with GitHub repository
- **Self-hosted runners**: Option for cost-effective builds
- **Matrix builds**: Test across Go and Node versions
- **Dependabot integration**: Automated dependency updates

## Consequences

### Positive
- Strong type safety across the stack
- Excellent performance and concurrency model
- Polyglot persistence matched to data access patterns
- Event-driven architecture enables loose coupling
- Container-first approach ensures deployment consistency
- Comprehensive observability stack

### Negative
- Go lacks generics for some data structures (mitigated by Go 1.18+ generics)
- Multiple databases increase operational complexity
- Eventual consistency in event-driven flows requires careful design
- Learning curve for NATS JetStream and Outbox pattern
- Two-language stack (Go + TypeScript) requires context switching

## Related ADRs

- ADR 0002: Database Responsibility Matrix
- ADR 0003: Messaging Architecture (NATS JetStream)
- ADR 0004: Authentication and Authorization

## Review Date

2026-12-25 (30 days from acceptance)
