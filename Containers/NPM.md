# Nginx Proxy Manager

[This compose file](https://github.com/Cain-Hughes/Homelab/tree/main/Containers/NPM.yaml) defines my Nginx Proxy Manager (NPM) instance, which serves as the primary entry point for externally exposed services within the homelab.

NPM provides a simple interface for managing reverse proxy hosts, SSL certificates, and traffic routing without requiring manual Nginx configuration.

---

## Purpose of This Service

Nginx Proxy Manager acts as the central routing layer between the public network and internally hosted applications.

Core responsibilities include:

- Reverse proxying internal services
- Managing TLS / SSL certificates via Let's Encrypt
- Providing a web-based administrative interface
- Simplifying domain and subdomain routing
- Reducing the need for manual Nginx edits

This container effectively becomes the "front door" for any intentionally exposed service.

---

## Port Mapping

The container exposes the standard ports required for web traffic and administration:

- **80 → HTTP**  
  Used for inbound HTTP traffic and certificate validation

- **443 → HTTPS**  
  Used for encrypted external access

- **81 → Admin Interface**  
  Web UI for managing proxy hosts, certificates, and settings

Port mappings follow the format:

<host-port>:<container-port>

---

## Data Persistence

Two bind mounts are used to preserve configuration and certificate data:

- `./data → /data`  
  Stores application configuration, settings, and the SQLite database

- `./letsencrypt → /etc/letsencrypt`  
  Stores issued certificates and related metadata

This ensures container recreation or upgrades do not result in lost configuration.

---

## Timezone Configuration

The container uses an explicit timezone setting:

TZ=America/New_York

This keeps logs, certificate timestamps, and scheduled operations aligned with the local environment.

---

## Restart Behavior

The container uses:

restart: unless-stopped

This allows automatic recovery after host reboots or transient failures while still permitting intentional shutdowns.

---

## Database Behavior

By default, Nginx Proxy Manager uses an internal SQLite database stored under `/data`.

For homelab scale, SQLite remains sufficient and simpler to maintain.

---

## Operational Role in the Network

NPM sits at the boundary between external clients and internal services.

Typical flow:

Internet → Port Forwarding → NPM → Internal Service

This model centralizes certificate management and reduces direct exposure of backend containers.

---

## Notes

- Only services intended for remote access are proxied
- Internal-only services remain unexposed
- Certificates and configs survive container rebuilds
- Additional stream ports can be mapped if required

---

This service is intentionally kept minimal, stable, and persistent as many other components depend on its availability.
