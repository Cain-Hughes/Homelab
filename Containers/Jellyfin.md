# Jellyfin

This compose file defines my Jellyfin media server, which acts as the primary platform for consuming and streaming media within the homelab.

Jellyfin is responsible for presenting and organizing media while leveraging GPU acceleration to handle transcoding workloads efficiently.

---

## Purpose of This Service

Jellyfin serves as the central media playback and management interface.

Core responsibilities include:

- Media library presentation
- Metadata aggregation and artwork
- Client streaming and playback
- Transcoding and format compatibility
- Centralized media access across devices

This container represents the user-facing component of the media stack.

---

## Hardware Acceleration Strategy

This instance is configured to use NVIDIA GPU acceleration.

Key configuration elements:

- `runtime: nvidia`
- `NVIDIA_VISIBLE_DEVICES=all`
- `NVIDIA_DRIVER_CAPABILITIES=compute,video,utility`

GPU offloading significantly reduces CPU load during transcoding and improves playback reliability for remote or bandwidth-constrained clients.

---

## Port Mapping

Jellyfin exposes a single service port:

8096 → Jellyfin Web Interface / HTTP

This port provides access to:

- Web UI
- API endpoints
- Client connections

HTTPS, if used, is typically handled upstream by the reverse proxy.

---

## Data Persistence

Two mounts are used to preserve configuration and media access:

- `./config → /config`  
  Stores server configuration, plugins, cache, and metadata

- `/data → /data`  
  Provides access to the media library

Separating configuration from media storage ensures rebuild safety and simplifies migrations.

---

## Identity & Permissions

The container runs using fixed user and group IDs:

PUID=1000  
PGID=1000

This avoids permission conflicts with shared storage and downloaded media.

---

## Restart Behavior

The container uses:

restart: unless-stopped

This allows Jellyfin to recover automatically after host restarts or transient failures.

---

## Operational Role in the Network

Jellyfin functions as the presentation layer of the media environment.

Typical flow:

Storage → Jellyfin → Client Devices

When combined with a reverse proxy:

Internet / LAN → Proxy → Jellyfin

---

## Notes

- GPU acceleration is critical for efficient transcoding
- Direct exposure is limited to the service port
- Configuration survives container recreation
- Media storage is externally managed
- Reverse proxy handles TLS when enabled

---

This service is designed to remain stable, persistent, and resource-efficient as it directly impacts user experience.
