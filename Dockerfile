FROM alpine:3.16.2

RUN apk add --no-cache docker-cli

WORKDIR /app

COPY . .

ENTRYPOINT ["/app/entrypoint.sh"]
