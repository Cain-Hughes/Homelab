# Media backend / *arr stack

The media stack coordinates requests, downloads, extraction, imports, and library metadata. Its original layout was based on [TechHut's media guide](https://github.com/TechHutTV/homelab/tree/main/media).

The [Compose template](MediaBackend.yaml) is a sanitized example. On a new deployment, copy it to `/docker/mediabackend/compose.yaml` alongside a locally populated `.env` based on [MediaBackend.env.example](MediaBackend.env.example). Compare it with any existing deployment before applying changes.

## Services and networking

| Service | Role | Networking |
|---|---|---|
| Gluetun | Proton VPN gateway and forwarded-port state | Own namespace |
| qBittorrent | Downloads; currently pinned to 5.1.4 | Shares Gluetun's namespace |
| Prowlarr | Indexer management | Shares Gluetun's namespace |
| Deunhealth | Restarts unhealthy labeled containers | No network; privileged Docker socket access |
| Sonarr | TV acquisition, imports, profiles, metadata | LAN/Docker network |
| Radarr | Movie acquisition, imports, profiles, metadata | LAN/Docker network |
| Seerr | Requests and request defaults | LAN/Docker network |
| Unpackerr | Archive extraction for imports | LAN/Docker network |
| Decluttarr | Failed/stalled queue cleanup and configured searches | LAN/Docker network |

qBittorrent and Prowlarr use `network_mode: service:gluetun`. Gluetun provides their tunnel and exposes their web ports. Verify tunnel and firewall behavior; a health check alone does not prove every traffic path is protected.

The template uses **`172.30.0.0/24`**, a private subnet. This deliberately differs from the live media network, whose addressing needs a future correction. No live network migration was performed during this documentation update. Check for overlap and update static assignments together before changing the live network.

The Gluetun check tests connectivity and the presence of its forwarded-port file. The public example uses a DNS name instead of a public IP, which also makes that check depend on DNS. Review the endpoint and failure behavior for your environment.

## Storage and permissions

The Docker host mounts the TrueNAS share at `/data` using NFS. Sonarr, Radarr, and qBittorrent see the same path, allowing hardlinks where the filesystem and configuration permit.

Most application images use UID/GID 1000 or equivalent `PUID`/`PGID` settings. These variables are image-specific, not uniformly supported by every image. Unpackerr explicitly runs as the selected user/group.

Unpackerr's writable mount and *arr search paths are restricted to **`/data/downloads`**. Media library folders are not mounted into it. Original archive deletion remains disabled. Extraction and *arr import are separate steps; a completed download alone does not establish success.

## Download-queue repairs — September 2026

Two settings were disrupting archive imports: qBittorrent excluded archive extensions, and Decluttarr's `remove_bad_files` job deselected multipart archive pieces.

RAR, ZIP, and 7z downloads are now allowed while executable/script exclusions remain. `remove_bad_files` is disabled. Failed-import handling recognizes executable/dangerous-file errors reported by the *arrs. Allowing an archive is not a reason to run files extracted from it.

Decluttarr runs every 15 minutes with a six-strike default. Public-tracker cleanup uses removal; private-tracker handling uses an obsolete tag to respect seeding policy. Existing missing/cutoff searches remain enabled. The `Keep` tag protects download handling; it is not a library-retention exclusion for Maintainerr.

The first live cleanup reduced the observed Sonarr queue from 71 entries to 28 and blocklisted the identified unsafe releases. This was a point-in-time result, not a permanent queue target. Remaining entries need individual diagnosis.

The [Decluttarr example](Decluttarr.example.yaml) intentionally starts in **dry-run mode**, unlike production. Populate its API keys locally, copy it to `decluttarr/config.yaml`, review proposed actions, then deliberately enable live operation. Review upstream configuration changes when updating the image.

## Sonarr profiles and Seerr requests

On September 28, Sonarr had one remaining profile, **HD - 720p/1080p**, and all series used it. Unused profiles were removed after moving the affected shows; changing a profile did not itself rewrite downloaded files. Radarr still has additional profiles, so this consolidation does not apply to both applications.

The Sonarr profile includes TRaSH-based preferences with **Season Pack +10**, minimum custom-format score **0**, and upgrade-until score **10000**. Upgrades remain enabled. Quality ordering and other scores still matter: +10 is a preference, not a guarantee to choose a pack over every episode or to find a complete-series pack.

Seerr's default TV, anime TV, and movie destinations use HD - 720p/1080p. Regular users' advanced-request and 4K-request privileges were removed; approval and quota policies were preserved. Administrators retain administrative controls. Profile IDs are installation-specific.

**Monitoring is separate from queued downloads.** Unmonitoring a show does not cancel an already queued upgrade. Pending unwanted upgrades were canceled separately. If an upgrade already replaced the old library file, canceling its torrent cannot restore the original without a recycle-bin copy or backup.

Reference: [TRaSH Guides — Sonarr](https://trash-guides.info/Sonarr/). These are verified deployment settings, not a claim that every current upstream recommendation has been applied.

## Metadata and artwork

The Kodi (XBMC) / Emby metadata consumer is enabled in both *arrs:

- Sonarr writes series/episode NFO metadata and series/season/episode artwork.
- Radarr writes `movie.nfo` and movie artwork.

This gives Jellyfin local identification and image files. The missing-artwork case involved an unmatched title, not a blanket failure of online providers. A targeted refresh confirmed Jellyfin consumed generated metadata and artwork. This was not a full-library metadata replacement or media re-download.

## Port synchronization

[qbt_port_sync.py](qbt_port_sync.py) is the script described in the [February build log](../BuildLog/2026-2-W4.md). It compares Gluetun's forwarded port with qBittorrent's listening port and updates it when necessary. It requires Python 3 and `requests`.

Its credential and session-cookie files remain private. The five-minute cron schedule is the previously documented setup; it was not revalidated during this documentation update.

## Verification and recovery

1. Confirm required archive parts are selected and complete.
2. Confirm Unpackerr reports successful extraction.
3. Confirm a Sonarr/Radarr import event and the expected library files.
4. Check failure cleanup/blocklisting with the appropriate tracker and seeding behavior.
5. Check actual free space: hardlinks and snapshots can retain storage after deletion.

Configuration snapshots were taken before repairs. They restore settings, not deleted payloads. See [operations](../Operations/README.md) and [Jellyfin](Jellyfin.md).
