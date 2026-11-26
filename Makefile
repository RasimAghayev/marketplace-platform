VERSION := $(shell git describe --tags --always --dirty 2>/dev/null || echo "0.1.0")
COMPOSE_PROJECT_NAME ?= marketplace-platform
export COMPOSE_PROJECT_NAME
COMPOSE_FILE ?= infrastructure/compose/docker-compose.yml
COMPOSE_PROFILES ?= dev
COMPOSE := docker compose -f $(COMPOSE_FILE) --profile $(COMPOSE_PROFILES)
DOCKER_BUILD_ARGS ?=

.PHONY: help build test verify up down run shell logs migrate seed clean lint format migrate-up migrate-down seed-up security

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}

build: ## Build all Docker images
	$(COMPOSE) build

test: ## Run all tests in Docker
	docker build --target test -t marketplace-platform-backend-test ./backend
	docker build --target test -t marketplace-platform-frontend-test ./frontend

verify: build test ## Build and test (quality gate)

up: verify ## Start all services (depends on verify)
	$(COMPOSE) up -d

down: ## Stop all services
	$(COMPOSE) down

run: ## Run services in foreground
	$(COMPOSE) up

shell: ## Open shell in backend container
	$(COMPOSE) run --rm backend /bin/sh

logs: ## View service logs
	$(COMPOSE) logs -f

migrate-up: ## Run database migrations
	$(COMPOSE) run --rm backend /bin/sh -c "cd /app && go run ./cmd/migrate"

migrate-down: ## Rollback database migrations
	$(COMPOSE) run --rm backend /bin/sh -c "cd /app && go run ./cmd/migrate --down"

seed: ## Run database seeders
	$(COMPOSE) run --rm backend /bin/sh -c "cd /app && go run ./cmd/seed"

clean: ## Clean build artifacts
	$(COMPOSE) down --volumes --remove-orphans
	rm -rf backend/bin frontend/node_modules coverage/

lint: ## Run linters
	$(COMPOSE) run --rm backend /bin/sh -c "cd /app && golangci-lint run ./..."
	$(COMPOSE) run --rm frontend /bin/sh -c "cd /app && npm run lint"

format: ## Format code
	$(COMPOSE) run --rm backend /bin/sh -c "cd /app && gofmt -w ."
	$(COMPOSE) run --rm frontend /bin/sh -c "cd /app && npm run format"

security: ## Run security scans
	$(COMPOSE) run --rm backend /bin/sh -c "cd /app && gosec ./..."
	$(COMPOSE) run --rm frontend /bin/sh -c "cd /app && npm audit"

migrate: migrate-up
seed-up: seed
