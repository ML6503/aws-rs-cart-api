FROM node:12.16.3 as base
WORKDIR /app

FROM base AS dependencies
COPY package*.json ./
RUN npm ci && npm cache clean --force

FROM  dependencies AS build
WORKDIR /app
# COPY src /app
COPY . /app
RUN npm run build

FROM node:alpine AS main
WORKDIR /app
ENV NODE_ENV=production
COPY --from=dependencies /app/package*.json ./
# RUN npm install --only=production && npm cache clean --force
RUN npm install && npm cache clean --force
USER node
COPY --from=build /app .
EXPOSE 4000
# CMD ["node", "dist/main.js"]
ENTRYPOINT ["node", "dist/main.js"]
