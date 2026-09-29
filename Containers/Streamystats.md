# Streamystats

Streamystats records Jellyfin playback activity so I can understand which parts of the library people use before deciding what to remove. It runs on the Docker host, separately from Jellyfin.

Verified September 28, 2026: the initial sync completed, both libraries and all users synchronized, and a real playback session appeared in the dashboard. Detailed viewing history accumulates while the collector is running; synchronizing the library does not recreate a complete historical playback log. Playback Reporting was not installed during setup.

## Deployment

- Host: `10.10.20.5`
- Directory: `/docker/streamystats`
- Image: `ghcr.io/fredrikburmester/streamystats-aio:v2.20.0`
- Direct web access: `http://10.10.20.5:3002`
- NPM example hostname: `streamy.example.com`
- Jellyfin connection: `http://10.10.20.5:8096`
- Timezone: `America/New_York`

The official all-in-one image includes the web application, job server, and PostgreSQL database. Only the web port is published. No media folders are mounted into this container.

The public [Compose file](Streamystats.yaml) follows the same layout as the other services:

```text
/docker/streamystats/
  compose.yaml
  .env
  data/
  backup.sh
  backups/
```

Copy the Compose example to `compose.yaml` and [Streamystats.env.example](Streamystats.env.example) to `.env` on a new deployment. Generate independent random values for the password and application keys as described in the example. Keep `.env` private and preserve it across container recreation.

```sh
cd /docker/streamystats
chmod 600 .env
docker compose config --quiet
docker compose up -d
docker compose ps
```

## First setup and everyday use

Connect the setup wizard to Jellyfin with a dedicated API key named for Streamystats. Sign in to Streamystats with an existing Jellyfin account; a Jellyfin administrator can access server-wide settings and statistics. Credentials are not included in this repository.

Useful views include active sessions, playback history, user activity, and individual library-item statistics. Interpret an empty history as missing observations until enough data has accumulated, rather than proof that a title has never been watched.

NPM forwards HTTPS to the HTTP backend on port 3002, using an existing wildcard certificate, Force SSL, HTTP/2, and WebSocket support. The application still requires its own login. Signing in through the LAN address does not also sign in through the domain.

## Backups and updates

Copy [streamystats-backup.sh](streamystats-backup.sh) to `/docker/streamystats/backup.sh` and make it executable with `chmod 700 backup.sh`. The script creates a consistent PostgreSQL dump and a separate archive of `compose.yaml` and `.env`. An initial backup was created after setup. These archives contain sensitive data and must stay out of Git.

```sh
cd /docker/streamystats
./backup.sh
```

The backups on this host are local recovery copies, not protection against losing the host. Copy them to independent storage. No recurring or off-host Streamystats backup schedule has been established by this work.

Before an update, take a backup and review the upstream release notes. The image is pinned so a routine pull does not silently switch to a development build. Reverting an image after a database migration can require restoring the matching database backup too.

To restore, stop the application, preserve the existing data directory, restore the matching Compose and environment files, and start the matching image. Restore the database dump during a maintenance window while collection activity is paused. Follow the upstream [AIO backup and restore procedure](https://github.com/fredrikburmester/streamystats/blob/v2.20.0/AIO.md#backup--restore); restoring over a live database is a destructive operation, not a routine health check.

## Scope

Streamystats is collecting statistics. Automatic media deletion and external AI providers are not configured. Maintainerr is a separate, deferred project; see [planned work](../Operations/README.md#planned-maintenance).

Sources: [Streamystats](https://github.com/fredrikburmester/streamystats), [release Compose example](https://github.com/fredrikburmester/streamystats/blob/v2.20.0/docker-compose.aio.yml).
