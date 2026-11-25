# System Architecture

## Overview

The Marketplace Platform is a production-ready, event-driven, multi-tenant marketplace built as a modular monolith with Clean Architecture and DDD principles.

## Technology Stack

| Area | Choice | Rationale |
|------|--------|-----------|
| Backend | Go 1.23+, Chi | Performance, concurrency, strong typing |
| Frontend | Next.js 15, React 19, TypeScript, Tailwind, tRPC | Full-stack React, type-safe APIs |
| Databases | PostgreSQL (primary), MongoDB (documents), Redis (hot) | Polyglot persistence per responsibility |
| Messaging | NATS JetStream | Lightweight, streaming, exactly-once, JetStream persistence |
| Containers | Docker, Docker Compose | Local → prod parity |
| CI/CD | GitHub Actions, Dependabot | Native, secure, automated |
| Observability | Prometheus, Grafana, Loki, OpenTelemetry, Jaeger | Full stack |

## Bounded Contexts

1. **Platform** — Tenancy, organizations, feature flags, audit, global settings
2. **Auth** — Identity, OAuth (Google, Apple, GitHub), MFA, sessions, tokens
3. **Stores** — Store CRUD, settings, hours, zones, staff, multi-location
4. **Catalog** — Categories, products, variants, pricing, media, SEO
5. **Orders** — Cart, checkout, order lifecycle, state machine, idempotency keys
6. **Payments** — Provider abstraction, auth/capture, refunds, reconciliation, webhooks
7. **Inventory** — Stock levels, reservations, movements, bundles, suppliers
8. **Delivery** — Zones, couriers, assignment, GPS tracking, ETA
9. **Notifications** — Email, Push, SMS, In-app; preferences, retry, DLQ
10. **Loyalty** — Points, tiers, cashback, referrals, campaigns
11. **Analytics** — Events, dashboards, reports, BI export

## Roles

Platform Admin, Org Owner, Store Manager, Store Staff, Courier, Customer, Support.

RBAC + ABAC (store-level isolation).

## Order State Machine

`DRAFT → PENDING_PAYMENT → CONFIRMED → ACCEPTED → PREPARING → READY → COURIER_ASSIGNED → PICKED_UP → ON_THE_WAY → DELIVERED`

Additional: `PAYMENT_FAILED`, `CANCELLED`, `REFUND_PENDING`, `REFUNDED`.

## Messaging Subjects

- `marketplace.orders.*`
- `marketplace.payments.*`
- `marketplace.inventory.*`
- `marketplace.delivery.*`
- `marketplace.notifications.*`

## Event Examples

`StoreCreated`, `ProductPublished`, `OrderPlaced`, `PaymentAuthorized`, `PaymentFailed`, `InventoryReserved`, `CourierAssigned`, `DeliveryStarted`, `OrderDelivered`, `OrderCancelled`, `RefundProcessed`, `LoyaltyPointsAdded`.
