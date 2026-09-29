# Virtual machines and service hosts

The Proxmox system separates storage, application workloads, and game hosting. Internal addresses are retained for clarity; credentials and public endpoints are omitted.

| System | Internal address | Role |
|---|---|---|
| Proxmox host | `10.10.20.2` | Hypervisor and VM/LXC management |
| AMP VM | `10.10.20.3` | Game server management |
| TrueNAS VM | `10.10.20.4` | ZFS storage and the NFS media share |
| Docker VM | `10.10.20.5` | Media stack, Jellyfin, NPM, Homarr, Dockhand, secondary Kuma, Streamystats |
| AdGuard Home LXC | `10.10.20.6` | Primary household DNS filtering |
| Raspberry Pi (separate device) | `10.10.20.8` | Secondary AdGuard Home and primary Uptime Kuma |

The Raspberry Pi is not a VM on Proxmox. Its monitoring role gives visibility when the Docker VM is unavailable. Secondary Kuma on the Docker VM watches the Pi and primary Kuma in return.

## Storage and hardware dependencies

The TrueNAS disks are passed through for ZFS management. The Docker VM mounts `10.10.20.4:/mnt/Olympic/olympic-media` at `/data` using NFS. Container configuration generally resides on the Docker VM's local disk, separate from the shared media.

The Quadro P2000 is accessible inside the Jellyfin container, but Jellyfin acceleration is currently disabled in the application. Enablement and playback testing are pending, not part of the documentation update.

A backup of the Docker VM does not automatically back up the NFS media. A TrueNAS VM backup does not automatically include passed-through data disks. See [recovery boundaries](../Operations/README.md#recovery-boundaries).

Exact VM IDs, per-VM CPU/RAM allocations, backup schedules, and restore-test results remain to be documented after verification.
