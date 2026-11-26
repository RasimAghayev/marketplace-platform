# Event Architecture

## Messaging System

NATS JetStream with durable streams, consumer acknowledgments, exactly-once semantics.

## Patterns

- Outbox (PostgreSQL → NATS)
- Idempotent consumers
- Retry with backoff
- DLQ (Dead Letter Queue)
- Event versioning
- Correlation IDs
- Distributed tracing (OpenTelemetry)

## Subjects

- `marketplace.orders.*`
- `marketplace.payments.*`
- `marketplace.inventory.*`
- `marketplace.delivery.*`
- `marketplace.notifications.*`

## Events

`StoreCreated`, `ProductPublished`, `OrderPlaced`, `PaymentAuthorized`, `PaymentFailed`, `InventoryReserved`, `CourierAssigned`, `DeliveryStarted`, `OrderDelivered`, `OrderCancelled`, `RefundProcessed`, `LoyaltyPointsAdded`.
