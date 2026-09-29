# Containers

Service documentation pairs a description with a public Compose example. Actual deployments use `/docker/<service>/compose.yaml` with persistent state beside the Compose file.

| Service | Documentation | Public configuration |
|---|---|---|
| Media backend | [MediaBackend.md](MediaBackend.md) | [Compose](MediaBackend.yaml), [environment example](MediaBackend.env.example), [Decluttarr example](Decluttarr.example.yaml) |
| Jellyfin | [Jellyfin.md](Jellyfin.md) | [Compose](Jellyfin.yaml) |
| Nginx Proxy Manager | [NPM.md](NPM.md) | [Compose](NPM.yaml) |
| Homarr | [Homarr.md](Homarr.md) | [Compose](Homarr.yaml) |
| Uptime Kuma | [UptimeKuma.md](UptimeKuma.md) | [Secondary Compose](UptimeKuma.yaml) |
| Streamystats | [Streamystats.md](Streamystats.md) | [Compose](Streamystats.yaml), [environment example](Streamystats.env.example), [backup script](streamystats-backup.sh) |

The existing [qBittorrent port-sync script](qbt_port_sync.py) is now available as a file rather than only embedded in the February build log. Dockhand is also running on the Docker host; detailed documentation for it remains a follow-up.

## Deployment conventions

- Persistent application state uses bind mounts; replacing a container does not create a backup of that state.
- Version pins are retained where verified, including qBittorrent, secondary Kuma, and Streamystats. Other existing examples still use mutable tags; pinning everything is not claimed as completed work.
- Secrets are populated on the host, not in Git. Copy environment examples to `.env` locally.
- Images handle users/permissions differently; follow each image's supported configuration.
- Docker socket access grants administrative capability and is not merely passive monitoring.
- Compose restart policies do not guarantee application health or restart containers intentionally stopped by an operator.

## Example versus production

These files are reviewed templates, not an export of production state. Domain names use `example.com`; the media network uses a private example subnet that differs from the live configuration. Decluttarr's public example is deliberately in dry-run mode. Review these differences before deploying.

Application settings such as Sonarr custom formats, Seerr permissions, Kuma monitors, Jellyfin metadata providers, and NPM routes are not recreated solely by `docker compose up`. Their service pages describe the settings that were verified.

See [operations and recovery](../Operations/README.md) for completed changes and deferred work.
