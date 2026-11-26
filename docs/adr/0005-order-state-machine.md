# ADR 0005: Order State Machine

## Status

Accepted

## Context

The Marketplace Platform requires a well-defined order lifecycle with strict state transitions. Orders move through states from creation to delivery, with additional states for payment failures and cancellations.

## Decision

### Order State Machine

```
DRAFT → PENDING_PAYMENT → CONFIRMED → ACCEPTED → PREPARING → READY → COURIER_ASSIGNED → PICKED_UP → ON_THE_WAY → DELIVERED
```

### Additional States

| State | Description | Entry From | Exit To |
|-------|-------------|------------|---------|
| DRAFT | Order created but not submitted | — | PENDING_PAYMENT, CANCELLED |
| PENDING_PAYMENT | Awaiting payment authorization | DRAFT | CONFIRMED, PAYMENT_FAILED, CANCELLED |
| CONFIRMED | Payment authorized, order confirmed | PENDING_PAYMENT | ACCEPTED, CANCELLED |
| ACCEPTED | Store accepted the order | CONFIRMED | PREPARING, CANCELLED |
| PREPARING | Store preparing the order | ACCEPTED | READY, CANCELLED |
| READY | Order ready for pickup | PREPARING | COURIER_ASSIGNED, CANCELLED |
| COURIER_ASSIGNED | Courier assigned to delivery | READY | PICKED_UP, CANCELLED |
| PICKED_UP | Courier picked up the order | COURIER_ASSIGNED | ON_THE_WAY, CANCELLED |
| ON_THE_WAY | Courier en route to customer | PICKED_UP | DELIVERED, CANCELLED |
| DELIVERED | Order delivered to customer | ON_THE_WAY | — |
| PAYMENT_FAILED | Payment authorization failed | PENDING_PAYMENT | PENDING_PAYMENT (retry), CANCELLED |
| CANCELLED | Order cancelled | DRAFT, PENDING_PAYMENT, CONFIRMED, ACCEPTED, PREPARING, READY, COURIER_ASSIGNED, PICKED_UP, ON_THE_WAY | — |
| REFUND_PENDING | Refund requested | DELIVERED | REFUNDED, CANCELLED |
| REFUNDED | Refund completed | REFUND_PENDING | — |

### Transition Rules

1. **DRAFT → PENDING_PAYMENT**: Customer submits order, creates payment intent
2. **PENDING_PAYMENT → CONFIRMED**: Payment authorized successfully
3. **PENDING_PAYMENT → PAYMENT_FAILED**: Payment authorization declined
4. **PENDING_PAYMENT → CANCELLED**: Customer cancels before payment
5. **CONFIRMED → ACCEPTED**: Store accepts order
6. **CONFIRMED → CANCELLED**: Store rejects or customer cancels
7. **ACCEPTED → PREPARING**: Store starts preparing order
8. **PREPARING → READY**: Order ready for courier pickup
9. **READY → COURIER_ASSIGNED**: Courier assigned to delivery
10. **COURIER_ASSIGNED → PICKED_UP**: Courier picks up order
11. **PICKED_UP → ON_THE_WAY**: Courier en route to customer
12. **ON_THE_WAY → DELIVERED**: Order delivered to customer
13. **ANY_ACTIVE_STATE → CANCELLED**: Cancellation allowed until out for delivery
14. **DELIVERED → REFUND_PENDING**: Customer requests refund
15. **REFUND_PENDING → REFUNDED**: Refund processed
16. **REFUND_PENDING → CANCELLED**: Refund request denied

### Idempotency

- Each order transition recorded with correlation ID
- Duplicate transition requests rejected
- State transitions published as NATS events: `marketplace.orders.state.changed`
- Outbox pattern ensures event publishing consistency with state change

## Consequences

### Positive
- Predictable order lifecycle with clear state transitions
- Audit trail of all state changes
- Event-driven notifications on state changes
- Idempotent transitions prevent duplicate processing

### Negative
- Complex state machine requires thorough testing
- Cancellation rules must balance customer and store needs
- Payment failure recovery requires retry logic

## Related ADRs

- ADR 0001: Technology Stack Selection
- ADR 0003: Messaging Architecture (NATS JetStream)

## Review Date

2026-12-25
