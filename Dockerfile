FROM node:12.16.3 as base

WORKDIR /app

FROM base AS dependencies
COPY --chown=node:node package*.json ./
RUN npm ci && npm cache clean --force

FROM  dependencies AS build
WORKDIR /app
COPY --chown=node:node src /app
RUN npm run build

FROM node:alpine AS main
WORKDIR /app
ENV NODE_ENV production
COPY --chown=node:node --from=dependencies /app/package*.json ./
RUN npm ci --only=production && npm cache clean --force
USER node
COPY --chown=node:node --from=build /app ./
EXPOSE 4000
# CMD ["node", "dist/main.js"]
ENTRYPOINT ["node", "dist/main.js"]
