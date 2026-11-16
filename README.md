# CommaFeed on Railway

Railway template for [CommaFeed](https://github.com/Athou/commafeed), a self-hosted RSS and Atom reader inspired by Google Reader.

## What it deploys

| Service | Source | Notes |
|---|---|---|
| `CommaFeed` | this repo (`Dockerfile`) | `athou/commafeed:7.5.0-postgresql` (native build), pinned by digest; public HTTPS domain |
| `Postgres` | Railway PostgreSQL | stores users, feeds and entries on a volume |

CommaFeed itself keeps no files on disk when it runs on PostgreSQL, so the app service needs no volume.

## First start

There is no default account. Open the public URL and create the admin account on the setup screen. Do this right after the deploy finishes: until an admin exists, anyone who opens the URL can create it. New user registration is off by default (an admin can create users, or set `COMMAFEED_USERS_ALLOW_REGISTRATIONS=true`).

## Variables

| Variable | Default | Purpose |
|---|---|---|
| `PORT` | `8082` | Port CommaFeed listens on (the domain targets it) |
| `QUARKUS_DATASOURCE_JDBC_URL` | `jdbc:postgresql://${{Postgres.PGHOST}}:${{Postgres.PGPORT}}/${{Postgres.PGDATABASE}}` | Database connection over Railway's private network |
| `QUARKUS_DATASOURCE_USERNAME` | `${{Postgres.PGUSER}}` | Database user |
| `QUARKUS_DATASOURCE_PASSWORD` | `${{Postgres.PGPASSWORD}}` | Database password |
| `QUARKUS_HTTP_AUTH_SESSION_ENCRYPTION_KEY` | `${{secret(32)}}` | Fixed key for the login cookie, so users stay logged in across restarts |

Optional settings (all CommaFeed settings can be set as environment variables, see the [documentation](https://athou.github.io/commafeed/documentation)):

- `COMMAFEED_MAX_HEAP` (default `512m`): heap cap for the native binary.
- `COMMAFEED_USERS_ALLOW_REGISTRATIONS=true`: let visitors sign up.
- Password recovery by email: `COMMAFEED_PASSWORD_RECOVERY_ENABLED`, `COMMAFEED_PASSWORD_RECOVERY_PUBLIC_BASE_URL` and the `QUARKUS_MAILER_*` settings.

The health check path is `/rest/server/get`, which answers without login.

## Updates

The CommaFeed version is pinned in the `FROM` line of the `Dockerfile`. When a new version is merged to `main` here, Railway shows an "update available" notice on projects deployed from this template, and you choose when to apply it. Read `CHANGELOG.md` first. Database migrations run automatically at startup.

## Files

- `Dockerfile`: the pinned upstream image plus the start script.
- `start.sh`: maps Railway's `PORT`, builds the JDBC URL from `PG*` variables if no URL is set, and caps the heap.
