FROM golang:1.23-alpine AS base
RUN apk add --no-cache git ca-certificates tzdata
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

FROM base AS deps
COPY . .
RUN go mod download

FROM base AS build
COPY --from=deps /app /app
RUN CGO_ENABLED=0 GOOS=linux go build -o /bin/api ./cmd/api

FROM base AS test
COPY --from=deps /app /app
RUN go test ./...

FROM alpine:3.20 AS runtime
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app
COPY --from=build /bin/api /bin/api
EXPOSE 8080
HEALTHCHECK --interval=15s --timeout=5s --retries=3 CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health/live || exit 1
ENTRYPOINT ["/bin/api"]
