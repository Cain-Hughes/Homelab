# Operations and recovery

Status checked September 28, 2026. This page separates completed configuration changes from work that still needs a maintenance window or further verification.

## Completed

- Primary Uptime Kuma on the Pi and a separate secondary monitor on the Docker host.
- Secondary monitoring of the Pi and primary Kuma, with Telegram notifications.
- Sonarr profile consolidation and Seerr request restrictions.
- Download-queue cleanup, archive-handling repairs, and reduced Unpackerr filesystem access.
- Local NFO and artwork export from Sonarr/Radarr for Jellyfin.
- Streamystats deployment, first synchronization, live playback detection, and an initial local backup.
- NPM routes for the new monitoring/statistics services and secondary AdGuard.

See the [September build log](../BuildLog/2026-09.md) for the reasoning behind these changes.

## Planned maintenance

The following are explicitly deferred until nobody is using the media service:

1. **Enable and test NVIDIA acceleration in Jellyfin.** The Quadro P2000 is visible inside the container, but the live acceleration method is `none`. Save the current configuration, check driver/FFmpeg compatibility, enable supported NVENC/NVDEC options, and verify a new transcode. GPU availability alone is not proof of hardware encoding.
2. **Evaluate Continue Watching deduplication.** The goal is one most-recently-played unfinished episode per series while preserving older resume positions. The candidate third-party plugin's published target is older than the installed Jellyfin release. Back up Jellyfin's database/configuration and test compatibility before installing it in production.
3. **Evaluate Maintainerr.** Start with candidate lists and a “Do nothing” action. Review all-user playback history, partial sessions, exclusions, grace periods, and Sonarr/Radarr monitoring behavior before allowing deletion. No automatic library deletion is currently configured by this project.
4. **Correct the media Docker network addressing.** The live subnet is outside the private address ranges. Public Compose examples use `172.30.0.0/24`; this is a sanitized template, not a deployed migration. Check for overlap and coordinate all static addresses before changing the live network.

Additional follow-ups: verify actual Proxmox update timers and backup jobs, complete the primary monitoring inventory, establish independent backups, and review the NAS disk read errors. Discussed update scripts, weekly reboots, snapshots, and new NAS hardware must not be presented as completed deployments without verification.

## Storage and deletion

The Docker host mounts the TrueNAS media share at `/data` over NFS. Library files and torrent download files may be hardlinks to the same data. Removing one pathname does not reclaim the blocks while another hardlink remains; snapshots can also retain deleted blocks.

Before bulk cleanup, check the actual file links, torrent state, library paths, and available space. Avoid summing folder sizes as though every pathname represented independent storage. Coordinate library cleanup with seeding requirements and *arr monitoring to prevent unnecessary re-downloads.

An ONLINE ZFS device can still have recorded read errors. Read errors alone do not establish the cause or remaining drive life. A full pool affects performance and free-space headroom, but does not by itself explain a device read-error counter. Review pool status, SMART/device health, controller/cable errors, and error trends. RAIDZ2 redundancy is not a backup.

## Recovery boundaries

| Mechanism | What it can recover | Limitation |
|---|---|---|
| App configuration backup | Settings and, when included, application databases | Does not restore deleted media |
| Streamystats database dump | Collected statistics and application state | Current backup is on the same host |
| VM snapshot | Supported virtual disks at a point in time | Not an independent backup; excludes unrelated NFS media |
| VM backup | Virtual disks included in that backup job | Does not automatically include passed-through NAS disks |
| Independent NAS backup | Media/data copied to separate storage | Not established by this work |

A tested, scheduled backup plan for the entire environment is still outstanding. Existing troubleshooting copies and a local database dump are useful recovery tools, but must not be described as full homelab backup coverage.

## Publication rules

This is a public documentation repository, not a copy of production state. Internal addresses are retained where useful; service domains use `example.com`. Never commit populated environment files, API keys, Telegram chat IDs, session cookies, VPN keys, private certificates, database exports, personal viewing history, or public IP addresses.

The `.gitignore` is a guardrail, not a substitute for reviewing staged changes. Examples can differ from production for privacy or portability; such differences are called out in their documentation.
