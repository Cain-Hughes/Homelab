# Nginx Proxy Manager

NPM provides reverse proxy routing and centralized TLS for the homelab. It runs on the Docker host at `10.10.20.5`, with port 81 for administration and ports 80/443 for HTTP/HTTPS. The [Compose file](NPM.yaml) keeps application state in `./data` and certificates in `./letsencrypt` under `/docker/npm`.

## Recently added routes

Hostnames below are documentation placeholders, not the real service domains.

| Example hostname | Upstream | Purpose |
|---|---|---|
| `uptime.example.com` | `http://10.10.20.8:3001` | Primary Uptime Kuma |
| `uptime2.example.com` | `http://10.10.20.5:3001` | Secondary Uptime Kuma |
| `adguard2.example.com` | `http://10.10.20.8:80` | Secondary DNS administration |
| `streamy.example.com` | `http://10.10.20.5:3002` | Streamystats |

These routes use the existing wildcard certificate and Force SSL. Streamystats additionally has HTTP/2 and WebSocket support enabled, with asset caching disabled. Its HTTPS health endpoint and login page returned successfully, HTTP redirected to HTTPS, and Nginx configuration validation passed after saving the host.

The public Compose file starts NPM; it does not create proxy hosts or restore certificates. Configure routes through NPM or restore its private data consistently. Never publish its database or certificate directory.

## Routing and authentication

The documented external design is Cloudflare proxying, gateway filtering, and forwarded HTTP/HTTPS traffic to NPM. LAN DNS can resolve service domains directly to the internal proxy. A successful LAN check therefore does not validate the entire public Internet path or current firewall rules.

NPM's “Public” access-list label means that NPM itself does not impose an access list. It does not describe an application's login policy or prove the endpoint is reachable from the Internet. Application authentication remains necessary.

HTTPS protects browser-to-proxy traffic. The routes above intentionally use HTTP on the LAN side. WebSocket support is enabled for services that need it; other live updates may use normal HTTP streaming.

## Recovery and checks

- Back up `data` and `letsencrypt` consistently and privately.
- Check DNS from the affected client, then the backend by IP/port, then the HTTPS hostname.
- Review certificate validity, upstream reachability, NPM logs, and application login behavior separately.
- Validate Nginx after a change and test the actual application, not only the proxy host's Online label.
- Do not treat a wildcard certificate as DNS configuration: the hostname must still resolve appropriately.

Related: [networking](../Networking/README.md), [Uptime Kuma](UptimeKuma.md), [Streamystats](Streamystats.md).
