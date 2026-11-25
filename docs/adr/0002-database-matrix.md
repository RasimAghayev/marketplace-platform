# ADR 0002: Database Responsibility Matrix

## Status

Accepted

## Context

The Marketplace Platform needs to store different types of data with different access patterns, consistency requirements, and query patterns. A single database cannot optimally serve all needs.

## Decision

| Database | Responsibility | Examples | Consistency Model |
|----------|---------------|----------|-------------------|
| PostgreSQL | Source of truth, ACID transactions | Users, stores, products, orders, payments, inventory transactions, loyalty balances, financial records | Strong consistency |
| MongoDB | Flexible documents, audit, analytics | Order event history, delivery tracking, recommendation logs, audit trails, flexible metadata | Eventual consistency |
| Redis | Hot data, cache, real-time | Sessions, rate limits, OTP, cart cache, menu cache, courier location, order status cache, distributed locks | Eventual consistency with TTL |

## Rationale

### PostgreSQL as Source of Truth
- **Financial data**: Orders, payments, loyalty balances require ACID transactions
- **Referential integrity**: Foreign keys between users, stores, products, orders
- **Complex queries**: Joins across stores, products, orders with filtering and aggregation
- **Row-level security**: Multi-tenant isolation at the database level
- **JSONB columns**: Flexible metadata where relational model is too rigid

### MongoDB for Documents and Audit
- **Order event history**: Append-only event store for order state transitions
- **Delivery tracking**: Flexible document structure for GPS points, status updates
- **Audit trails**: Immutable log of all system changes
- **Recommendation logs**: Unstructured data for ML recommendations
- **Flexible metadata**: Product attributes that vary by category

### Redis for Hot Data (Never Source of Truth)
- **Session storage**: JWT session data with TTL
- **Rate limiting**: Counter-based rate limiting with sliding windows
- **OTP**: One-time passwords with short TTL
- **Cart cache**: Shopping cart data with TTL
- **Courier location**: Real-time GPS updates with pub/sub
- **Distributed locks**: Redlock pattern for inventory reservation

## Cache Invalidation Policy

| Data Type | TTL | Invalidation Strategy |
|-----------|-----|----------------------|
| Sessions | 24h | Delete on logout, expiry |
| Rate limits | 60s | Sliding window, auto-expire |
| OTP | 5m | Delete on use or expiry |
| Cart cache | 30m | Delete on checkout or expiry |
| Courier location | 30s | Continuous overwrite |
| Order status cache | 5m | Delete on status change |
| Product cache | 1h | Delete on product update |

## Schema Strategy

### PostgreSQL
- Tables per bounded context with schema prefix (e.g., `auth.users`, `stores.stores`, `catalog.products`)
- UUID primary keys
- Created/updated timestamps on all tables
- Soft deletes where business logic requires audit history
- Migrations managed by Go migrate tool
- Deterministic, idempotent seeders

### MongoDB
- Collections per bounded context
- Document versioning for event sourcing
- TTL indexes for auto-expiration
- Change streams for real-time notifications

### Redis
- Key namespacing per bounded context (e.g., `auth:sessions:`, `inventory:locks:`)
- TTL on all volatile keys
- No persistence requirement (data can be rebuilt from source of truth)

## Consequences

### Positive
- Each data store is optimized for its specific workload
- ACID transactions for financial data prevents inconsistencies
- Flexible schema for audit and analytics data
- Sub-millisecond latency for hot data access
- Clear separation of concerns

### Negative
- Increased operational complexity (3 databases to manage)
- Data consistency across stores requires event-driven synchronization
- Cross-database transactions not supported (use Saga/Outbox pattern)
- Operational overhead for backups and monitoring of 3 systems

## Related ADRs

- ADR 0001: Technology Stack Selection
- ADR 0003: Messaging Architecture (NATS JetStream)

## Review Date

2026-12-25
