# System Overview

## Architecture Style

**Modular Monolith + Event-Driven Architecture (EDA)**

The platform is deployed as a single deployable unit (modular monolith) with clear bounded context boundaries. Internally, modules communicate asynchronously via NATS JetStream events and synchronously via direct in-process calls where appropriate.

## Architectural Patterns

| Pattern | Usage |
|---------|-------|
| Clean Architecture | Each module follows dependency rule: domain → application → infrastructure |
| DDD Bounded Contexts | 11 bounded contexts with clear boundaries |
| Repository Pattern | Data access abstracted behind repository interfaces |
| Dependency Injection | Wire/Fx for DI container |
| Outbox Pattern | Reliable event publishing (PostgreSQL → NATS) |
| Event Sourcing | Order event history in MongoDB |
| CQRS (light) | Read models separate from write models where needed |
| State Machine | Order lifecycle with strict transitions |
| Circuit Breaker | External service calls (payment providers) |
| Retry with Backoff | Failed event processing |
| Dead Letter Queue | Unprocessable events |

## Component Diagram

See `docs/diagrams/component.mmd` for module-level component diagram.

## Container Diagram

See `docs/diagrams/container.mmd` for container-level diagram.

## System Context Diagram

See `docs/diagrams/system-context.mmd` for system context with external actors and systems.

## Technology Stack

See `docs/adr/0001-technology-stack.md` for full stack selection rationale.

## Domain Boundaries

See `docs/architecture/domain-boundaries.md` for bounded context definitions, entities, aggregates, events, and dependencies.

## Security Architecture

See `docs/security/security-architecture.md` for authentication, authorization, RBAC, ABAC, and security controls.

## Data Architecture

See `docs/adr/0002-database-matrix.md` for database responsibility matrix.

## Event Architecture

See `docs/adr/0003-messaging.md` for NATS JetStream messaging architecture.

## Review Date

2026-12-25
