# Postgres-e2econtainer

[![Docker](https://img.shields.io/docker/pulls/brandazine/postgres-e2econtainer.svg)](https://hub.docker.com/r/brandazine/postgres-e2econtainer)

A High-performance PostgreSQL docker imaeg optimized for E2E testing, with unnecessary features such as logging, recovery, and synchronization disabled for faster query execution.

In our testing environment, we've seen nearly 3x performance improvements in query execution times compared to the default PostgreSQL image.

## Base Image

https://github.com/hbontempo-br/docker-postgres-hll

## Notable changes to the default PostgreSQL configuration

- shared_buffers: 512MB (default: 128MB)
- fsync: off (default: on) - disabled to ensures that PostgreSQL does not wait for disk flushes.
- synchronous_commit: off (default: on) - disabled to avoid waiting for WAL writes, further reducing transaction latency.
- full_page_writes: off (default: on) - disabled to avoid writing full pages to the WAL.
- wal_level: minimal (default: replica) - set to minimal to reduce the amount of WAL data generated, as we don't need point-in-time recovery or replication.
- autovacuum: off (default: on) - disabled autovacuum since this is a temporary testing environment and we won't need ongoing maintenance.
- random_page_cost: 1.1 (default: 4.0) - lowered to reflect more accurate I/O costs for random disk access, optimizing query planner decisions.

## Recommended Usage (GitHub Actions)

To use the `postgres-e2econtainer` in your GitHub Actions workflow, you can use the following configuration:

```yaml
services:
  postgres:
    image: brandazine/postgres-e2econtainer:15-alpine3.20-hll2.18
    env:
      TZ: Asia/Seoul
    options: >-
      --health-cmd pg_isready
      --health-interval 3s
      --health-timeout 5s
      --health-retries 8
    volumes:
      - /dev/shm/${{ github.run_id }}-postgres:/var/lib/postgresql/data
```

**Important:** Storing the data in `/dev/shm` is highly recommended to maximize performance,
as it's a memory-backed filesystem that can dramatically reduce I/O latency,
leading to significantly faster database operations.
