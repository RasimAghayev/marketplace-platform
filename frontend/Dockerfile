FROM node:20-alpine AS base
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install

FROM base AS deps
COPY . .
RUN npm install

FROM base AS test
COPY --from=deps /app /app
RUN npm test -- --run

FROM base AS build
COPY --from=deps /app /app
RUN npm run build

FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=build /app/.next .next
COPY --from=build /app/public ./public
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./package.json
EXPOSE 3000
HEALTHCHECK --interval=15s --timeout=5s --retries=3 CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/health || exit 1
ENV NODE_ENV=production
ENTRYPOINT ["npm", "start"]
