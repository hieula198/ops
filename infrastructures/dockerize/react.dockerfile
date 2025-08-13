FROM node:20-alpine AS installer

WORKDIR /app

RUN apk add --no-cache xdg-utils

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile


FROM node:20-alpine AS user_builder

WORKDIR /app

COPY --from=installer /app/node_modules ./node_modules

COPY . .

RUN yarn build


FROM node:20-alpine AS admin_builder

WORKDIR /app

COPY --from=installer /app/node_modules ./node_modules

COPY . .

RUN yarn build:admin


FROM node:20-alpine

WORKDIR /app

RUN yarn global add pm2 serve

COPY --from=user_builder /app/dist /app
COPY --from=admin_builder /app/dist /app

COPY pm2-user.config.cjs pm2-user.config.cjs
COPY pm2-admin.config.cjs pm2-admin.config.cjs

EXPOSE 8080

CMD ["pm2-runtime", "start", "pm2-user.config.cjs"]

