# Redis

Currently running Redis via Docker: `docker run -p 6379:6379 -d redis`,
version 5.0.5.

Running mulitple redis servers:

```
docker run --rm -p 6379:6379 redis
docker run --rm -p 6380:6379 redis
docker run --rm -p 6381:6379 redis
```
