# Deployment Strategy

## Local

`make up` — starts all services via Docker Compose with `dev` profile.

## VPS / Swarm

Docker Swarm deployment with service definitions, configs, and secrets.

## Kubernetes

Helm charts and Kustomize manifests in `infrastructure/kubernetes/`.

## Environments

- dev — local Docker Compose
- staging — VPS/Swarm
- prod — Kubernetes or Swarm

## Rollback

Git-based rollback via tag promotion. Image tags are immutable (SemVer + SHA).
