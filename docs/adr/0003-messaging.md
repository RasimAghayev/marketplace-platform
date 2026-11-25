# ADR 0003: Messaging Architecture (NATS JetStream)

## Status

Accepted

## Context

The Marketplace Platform requires asynchronous communication between bounded contexts. Events such as OrderPlaced, PaymentAuthorized, InventoryReserved need to be propagated reliably with exactly-once semantics.

## Decision

Use NATS JetStream as the event streaming backbone with:
- Durable streams with consumer acknowledgments
- Exactly-once delivery semantics
- Subject-based routing: `marketplace.orders.*`, `marketplace.payments.*`, `marketplace.inventory.*`, `marketplace.delivery.*`, `marketplace.notifications.*`
- Outbox pattern: PostgreSQL → NATS for reliable event publishing
- Idempotent consumers with deduplication
- Retry with exponential backoff
- Dead Letter Queue (DLQ) for failed events
- Event versioning and correlation IDs
- Distributed tracing via OpenTelemetry

## Subjects

| Subject Pattern | Description | Example Events |
|-----------------|-------------|----------------|
| `marketplace.orders.*` | Order lifecycle events | OrderPlaced, OrderConfirmed, OrderCancelled, OrderDelivered |
| `marketplace.payments.*` | Payment events | PaymentAuthorized, PaymentFailed, PaymentCaptured, RefundProcessed |
| `marketplace.inventory.*` | Inventory events | InventoryReserved, InventoryReleased, StockLow |
| `marketplace.delivery.*` | Delivery events | CourierAssigned, DeliveryStarted, DeliveryCompleted |
| `marketplace.notifications.*` | Notification events | NotificationSent, NotificationFailed |
| `marketplace.platform.*` | Platform events | StoreCreated, FeatureFlagChanged |

## Patterns

### Outbox Pattern
1. Application writes event to `outbox` table in PostgreSQL within same transaction as business data
2. Change Data Capture (CDC) or polling relays reads outbox and publishes to NATS
3. Relay marks outbox entry as published after successful NATS publish
4. If NATS publish fails, event remains in outbox for retry

### Idempotent Consumers
1. Each consumer tracks processed event IDs
2. Duplicate events are detected and discarded
3. Consumer state stored in PostgreSQL or Redis

### Retry with Backoff
1. Failed events are retried with exponential backoff
2. Maximum retry count before DLQ
3. DLQ events are manually inspected and reprocessed

### Event Versioning
1. Events include schema version in header
2. Consumers handle multiple versions of same event type
3. Backward-compatible changes only (additive fields)

## Consequences

### Positive
- Loose coupling between bounded contexts
- Exactly-once delivery prevents duplicate processing
- Event replay for recovery and debugging
- Natural fit for microservices evolution
- OpenTelemetry integration for distributed tracing

### Negative
- Eventual consistency requires careful UX design
- Increased complexity in error handling and retry logic
- Dead letter queue requires operational attention
- Schema evolution requires discipline

## Related ADRs

- ADR 0001: Technology Stack Selection
- ADR 0002: Database Responsibility Matrix

## Review Date

2026-12-25
