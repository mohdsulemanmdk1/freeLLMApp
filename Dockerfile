FROM node:20-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
COPY shared/package*.json ./shared/
COPY server/package*.json ./server/
COPY client/package*.json ./client/

RUN npm install

COPY . .

RUN npm run build

FROM node:20-slim

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3001

COPY --from=builder /app /app

EXPOSE 3001

CMD ["node", "server/dist/index.js"]
