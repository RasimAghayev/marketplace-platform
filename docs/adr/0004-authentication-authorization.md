# ADR 0004: Authentication and Authorization

## Status

Accepted

## Context

The Marketplace Platform needs to support multiple user roles (Platform Admin, Org Owner, Store Manager, Store Staff, Courier, Customer, Support) with authentication via OAuth (Google, Apple, GitHub), MFA, sessions, and tokens. Authorization must enforce store-level isolation (ABAC) and role-based access (RBAC).

## Decision

### Authentication
- **Identity provider**: Internal identity store with OAuth social login (Google, Apple, GitHub)
- **Password hashing**: Argon2id for locally stored passwords
- **Sessions**: JWT access tokens (15 min TTL) + refresh tokens (7 day TTL) stored in Redis
- **MFA**: TOTP-based (Google Authenticator, Authy) for sensitive operations
- **Session invalidation**: Redis-based token blacklist for logout and security events
- **Passwordless**: OTP via email/SMS as alternative login method

### Authorization
- **RBAC**: Role-based access control with predefined roles per bounded context
- **ABAC**: Attribute-based access control for store-level isolation (users can only access stores they belong to)
- **Middleware**: Go middleware enforces RBAC/ABAC on all API endpoints
- **Resource ownership**: Users own resources they create; store staff inherit store-level permissions

### Roles

| Role | Scope | Permissions |
|------|-------|-------------|
| Platform Admin | Global | All resources, all stores, system configuration |
| Org Owner | Organization | Organization settings, store management, billing |
| Store Manager | Store | Store CRUD, products, orders, staff management |
| Store Staff | Store | Products, orders, inventory (read/write) |
| Courier | Delivery zone | Delivery assignments, GPS location, order status updates |
| Customer | Self | Own profile, orders, cart, payments |
| Support | Assigned tickets | Customer support ticket management, order lookup |

## Token Structure

```json
{
  "sub": "user-uuid",
  "org": "org-uuid",
  "store_ids": ["store-uuid-1", "store-uuid-2"],
  "roles": ["store_manager"],
  "iat": 1732500000,
  "exp": 1732500900
}
```

## Consequences

### Positive
- Store-level isolation prevents cross-tenant data access
- JWT stateless validation reduces database lookups
- Refresh tokens enable session revocation
- MFA adds security for sensitive operations
- Social login reduces friction for new users

### Negative
- Token revocation requires Redis lookup (slightly increased latency)
- Complex RBAC/ABAC rules require careful testing
- Multiple identity sources increase integration complexity

## Related ADRs

- ADR 0001: Technology Stack Selection
- ADR 0002: Database Responsibility Matrix (PostgreSQL for users, sessions)

## Review Date

2026-12-25
