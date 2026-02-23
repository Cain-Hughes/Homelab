# Media Backend / *arr Stack Overview

This compose file defines my media backend environment built around the *arr ecosystem.  
It is designed to keep download traffic isolated through a VPN while allowing the rest of the services to operate normally on the local network.

A large portion of this stack, its structure, and several design decisions were created with guidance from **TechHutTV**.  
Their excellent GitHub repository is referenced directly inside the compose file and served as the foundation for this setup:

https://github.com/TechHutTV/homelab/tree/main/media

I highly recommend following their YouTube guide and documentation on their GitHub for configuring a home media service like this, it was the easiest to follow and understand.  
---

## General Design

The stack is split into two logical groups:

**1. VPN-bound services**  
These containers share the network namespace of the VPN container so that all of their traffic is forced through the tunnel.

**2. Local network services**  
These containers run normally on the Docker network and are reachable directly from the LAN.

All containers use the same user and group IDs (`PUID` / `PGID`) to avoid permission issues with downloaded files.

Configuration data is stored using bind mounts relative to the compose directory.

---

## Network Layout

A dedicated Docker network is used:

- **Network Name:** `medianetwork`
- **Subnet:** `172.39.0.0/24`

Static IPs are assigned to key services for consistency and easier troubleshooting.

---

## Container Roles

### Gluetun (VPN Gateway)

Acts as the network gateway for VPN-restricted containers.

Responsibilities:

- Establishes VPN tunnel
- Owns forwarded ports
- Provides shared network stack for dependent containers
- Exposes required service ports

Other containers use:

network_mode: service:gluetun


This ensures their traffic never bypasses the VPN.

---

### qBittorrent

Runs entirely through Gluetun’s network namespace.

Key behaviors:

- Web UI exposed via Gluetun
- Torrent traffic forced through VPN
- Restarted automatically if unhealthy (via Deunhealth)

Depends on Gluetun being healthy before starting.

---

### Deunhealth

Monitors Docker health states and restarts containers that become unhealthy.

Purpose:

- Self-healing behavior
- Prevents silent container failures
- Especially useful for VPN-dependent services

Runs without network access.

---

### Prowlarr

Also routed through Gluetun.

Purpose:

- Indexer aggregation
- Centralized indexer management for Sonarr / Radarr
- Benefits from VPN routing

---

### Sonarr

Manages TV show acquisition and organization.

Runs on the local Docker network so it is easily reachable from the LAN.

Responsibilities:

- Library management
- Download automation
- qBittorrent integration
- Media organization

---

### Radarr

Handles movie acquisition and management.

Very similar role to Sonarr, but focused on films.

---

### Seerr

Provides the user-facing request interface.

Responsibilities:

- Request management
- Integrations with Sonarr / Radarr
- Friendly UI for discovery and approval workflows

---

## Health & Stability Strategy

Several mechanisms help keep the stack reliable:

- Docker health checks
- Gluetun health validation (connectivity + forwarded port)
- Deunhealth auto-restarts
- Explicit container dependencies

This reduces manual intervention after reboots or transient failures.

---

## Configuration Notes

Environment variables are stored in a `.env` file.

Typical values include:

- `PUID`
- `PGID`
- `TZ`
- VPN provider credentials

Refer to the TechHutTV documentation for variable structure and examples:

https://github.com/TechHutTV/homelab/tree/main/media#docker-compose-and-env
