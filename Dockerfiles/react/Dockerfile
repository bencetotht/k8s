FROM node:22-alpine AS builder
ENV NODE_ENV production
WORKDIR /app
COPY ./package.json ./
COPY ./package-lock.json ./
RUN npm install
COPY . .
ENV TSC_COMPILE_ON_ERROR=true
ENV ESLINT_NO_DEV_ERRORS=true
RUN npm run build

FROM nginx:1.29-alpine AS server
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY ./etc/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build .
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]