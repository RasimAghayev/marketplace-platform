# Domain Boundaries

## Bounded Contexts

The Marketplace Platform is organized into 11 bounded contexts, each with clear boundaries, responsibilities, and integration points.

### 1. Platform (Tenancy & Organization)

**Responsibility**: Multi-tenancy, organizations, feature flags, audit, global settings.

**Entities**: Organization, Tenant, FeatureFlag, AuditLog, Setting

**Aggregates**:
- Organization (root): Contains tenants, settings, feature flags
- FeatureFlag (root): Toggleable features per organization/tenant

**Integration Events Published**: `OrganizationCreated`, `OrganizationUpdated`, `FeatureFlagChanged`, `TenantCreated`

**Integration Events Consumed**: None (inbound only)

**Databases**: PostgreSQL (organizations, tenants, settings, audit)

### 2. Auth (Identity & Access)

**Responsibility**: Identity, OAuth (Google, Apple, GitHub), MFA, sessions, tokens.

**Entities**: User, Credential, Session, Token, MFADevice, OAuthAccount

**Aggregates**:
- User (root): Identity, credentials, roles, MFA devices
- Session (root): Active sessions, tokens, refresh tokens

**Integration Events Published**: `UserRegistered`, `UserAuthenticated`, `SessionCreated`, `SessionRevoked`, `MFADeviceAdded`

**Integration Events Consumed**: None (inbound only)

**Databases**: PostgreSQL (users, credentials, sessions, tokens), Redis (session cache, rate limiting)

### 3. Stores (Store Management)

**Responsibility**: Store CRUD, settings, hours, zones, staff, multi-location.

**Entities**: Store, StoreSetting, StoreHours, StoreZone, StoreStaff, StoreLocation

**Aggregates**:
- Store (root): Store details, settings, hours, zones, staff
- StoreLocation (root): Geographic location, delivery zone

**Integration Events Published**: `StoreCreated`, `StoreUpdated`, `StoreDeleted`, `StoreHoursChanged`, `StaffAdded`, `StaffRemoved`

**Integration Events Consumed**: `OrganizationCreated` (from Platform)

**Databases**: PostgreSQL (stores, settings, hours, zones, staff, locations)

### 4. Catalog (Products & Categories)

**Responsibility**: Categories, products, variants, pricing, media, SEO.

**Entities**: Category, Product, ProductVariant, ProductMedia, Price, SEO

**Aggregates**:
- Category (root): Category hierarchy, SEO
- Product (root): Product details, variants, media, pricing

**Integration Events Published**: `CategoryCreated`, `ProductPublished`, `ProductUpdated`, `ProductUnpublished`, `PriceChanged`

**Integration Events Consumed**: `StoreCreated` (from Stores)

**Databases**: PostgreSQL (categories, products, variants, pricing), MongoDB (product media, flexible attributes)

### 5. Orders (Order Lifecycle)

**Responsibility**: Cart, checkout, order lifecycle, state machine, idempotency keys.

**Entities**: Cart, CartItem, Order, OrderItem, OrderTransition, IdempotencyKey

**Aggregates**:
- Order (root): Order lifecycle, items, transitions, idempotency
- Cart (root): Shopping cart, items (session-scoped)

**Integration Events Published**: `OrderPlaced`, `OrderConfirmed`, `OrderCancelled`, `OrderDelivered`, `OrderStateChanged`

**Integration Events Consumed**: `ProductPublished` (from Catalog), `StoreCreated` (from Stores), `PaymentAuthorized` (from Payments), `PaymentFailed` (from Payments)

**Databases**: PostgreSQL (orders, cart, transitions, idempotency), MongoDB (order event history)

### 6. Payments (Payment Processing)

**Responsibility**: Provider abstraction (Stripe, Adyen), auth/capture, refunds, reconciliation, webhooks.

**Entities**: Payment, PaymentIntent, Refund, Transaction, WebhookEvent

**Aggregates**:
- Payment (root): Payment lifecycle, intents, refunds
- Refund (root): Refund lifecycle, transactions

**Integration Events Published**: `PaymentAuthorized`, `PaymentFailed`, `PaymentCaptured`, `RefundProcessed`, `PaymentWebhookReceived`

**Integration Events Consumed**: `OrderPlaced` (from Orders), `OrderCancelled` (from Orders)

**Databases**: PostgreSQL (payments, refunds, transactions), Redis (idempotency keys)

### 7. Inventory (Stock Management)

**Responsibility**: Stock levels, reservations, movements, bundles, suppliers.

**Entities**: StockItem, StockReservation, StockMovement, Bundle, Supplier

**Aggregates**:
- StockItem (root): Current stock, reservations, movements
- StockReservation (root): Time-boxed reservation with TTL

**Integration Events Published**: `InventoryReserved`, `InventoryReleased`, `StockLow`, `StockReplenished`

**Integration Events Consumed**: `OrderPlaced` (from Orders), `OrderCancelled` (from Orders), `ProductPublished` (from Catalog)

**Databases**: PostgreSQL (stock, reservations, movements), Redis (distributed locks, reservation TTL)

### 8. Delivery (Courier & Delivery)

**Responsibility**: Zones, couriers, assignment, GPS tracking (Redis + MongoDB), ETA, route optimization.

**Entities**: DeliveryZone, Courier, CourierLocation, DeliveryAssignment, DeliveryTracking, ETA

**Aggregates**:
- DeliveryAssignment (root): Assignment lifecycle, courier, order
- Courier (root): Courier profile, availability, zones

**Integration Events Published**: `CourierAssigned`, `DeliveryStarted`, `DeliveryCompleted`, `CourierLocationUpdated`

**Integration Events Consumed**: `OrderConfirmed` (from Orders), `OrderReady` (from Orders)

**Databases**: PostgreSQL (zones, couriers, assignments), MongoDB (delivery tracking, GPS history), Redis (courier location pub/sub)

### 9. Notifications (Multi-channel Messaging)

**Responsibility**: Email, Push, SMS, In-app; preferences, retry, DLQ.

**Entities**: Notification, NotificationPreference, NotificationTemplate, NotificationRetry, DLQEntry

**Aggregates**:
- Notification (root): Notification lifecycle, channels, status
- NotificationPreference (root): User channel preferences

**Integration Events Published**: `NotificationSent`, `NotificationFailed`, `NotificationDelivered`

**Integration Events Consumed**: `OrderPlaced` (from Orders), `OrderConfirmed` (from Orders), `OrderDelivered` (from Orders), `PaymentAuthorized` (from Payments), `PaymentFailed` (from Payments), `CourierAssigned` (from Delivery)

**Databases**: PostgreSQL (notifications, preferences, templates), MongoDB (notification history), Redis (rate limiting, retry queue)

### 10. Loyalty (Points & Rewards)

**Responsibility**: Points, tiers, cashback, referrals, campaigns, birthdays.

**Entities**: LoyaltyAccount, LoyaltyTransaction, LoyaltyTier, Referral, Campaign, BirthdayReward

**Aggregates**:
- LoyaltyAccount (root): Points balance, tier, transactions
- LoyaltyTransaction (root): Points earned/redeemed

**Integration Events Published**: `LoyaltyPointsAdded`, `LoyaltyPointsRedeemed`, `TierChanged`, `ReferralCompleted`

**Integration Events Consumed**: `OrderPlaced` (from Orders), `OrderDelivered` (from Orders), `PaymentCaptured` (from Payments)

**Databases**: PostgreSQL (accounts, transactions, tiers, referrals, campaigns) - financial records require ACID

### 11. Analytics (Events & Reporting)

**Responsibility**: Events, dashboards, reports, BI export.

**Entities**: AnalyticsEvent, Dashboard, Report, Export

**Aggregates**:
- AnalyticsEvent (root): Event data, dimensions, metrics
- Report (root): Report definition, results, export

**Integration Events Published**: `AnalyticsReportGenerated`, `DashboardUpdated`

**Integration Events Consumed**: All domain events (via NATS)

**Databases**: MongoDB (events, dashboards, reports), PostgreSQL (report definitions, exports)

## Module Dependencies

```
Platform ← (none)
Auth ← Platform
Stores ← Platform
Catalog ← Stores
Orders ← Auth, Stores, Catalog
Payments ← Orders, Auth
Inventory ← Catalog, Orders
Delivery ← Orders
Notifications ← Orders, Payments, Delivery
Loyalty ← Orders, Payments
Analytics ← All (event consumer)
```

## Store-Level Isolation (ABAC)

All store-scoped resources must enforce:
1. User belongs to the store's organization
2. User has a role granting access to the resource
3. Resource is within the user's assigned store(s)

Enforced via middleware at the API gateway level and repository-level filters.

## Event Contract Schema

All events follow this schema:

```json
{
  "event_id": "uuid",
  "event_type": "StoreCreated",
  "event_version": "1",
  "timestamp": "2026-11-25T13:00:00Z",
  "correlation_id": "uuid",
  "causation_id": "uuid",
  "producer": "stores",
  "data": { ... }
}
```

## Review Date

2026-12-25
