# Database Responsibility Matrix

| DB | Responsibility | Examples |
|----|----------------|----------|
| PostgreSQL | Source of truth, ACID | Users, stores, products, orders, payments, inventory txns, loyalty balances, financial records |
| MongoDB | Flexible documents, audit, analytics | Order event history, delivery tracking, recommendation logs, audit trails, flexible metadata |
| Redis | Hot data, cache, real-time | Session, rate limit, OTP, cart cache, menu cache, courier location, order status cache, distributed locks |

Redis is never source of truth. Cache invalidation + TTL policy documented in ADR.

## Schema Strategy

PostgreSQL owns all transactional data with proper constraints, indexes, and migrations. MongoDB stores flexible, append-only documents. Redis caches derived data with TTL.
