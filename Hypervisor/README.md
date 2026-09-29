# Proxmox Hypervisor ***(work in progress)***

This section documents the Proxmox VE environment that forms the core of my homelab. The previously documented Proxmox release family is 9.x (the exact installed point release and update schedule need re-verification) on an HPE ProLiant DL380 Gen9 configured as my primary hypervisor. Proxmox has been a reliable and flexible platform for managing virtual machines, containers, and hardware pass-through, and it continues to be one of the best hypervisors for hands-on learning and experimentation.

My setup is designed to support storage virtualization, media services, network services, and general testing. Proxmox provides an easy way to isolate workloads, snapshot them, experiment with new configurations, and recover quickly when something breaks.


## Current Virtualization Layout

### Virtual Machines
I am currently running the following VMs on the hypervisor:

- **TrueNAS SCALE VM**  
  Manages all storage using ZFS, with twenty-four 10K SAS drives passed directly through the Smart Array controller operating in HBA mode. TrueNAS handles all disk integrity, redundancy, and pool management.

- **Docker Server VM**  
  Runs my media server stack using Docker and includes containers such as Jellyfin, Radarr, Sonarr, qBittorrent, Gluetun, Prowlarr, Seerr, Homarr, NPM, Unpackerr, Decluttarr, secondary Uptime Kuma, Streamystats, and Dockhand. This VM centralizes the main application workloads and keeps storage separate from applications.

- **AMP Gameserver VM**  
  Hosts the AMP game management panel by Cubecoders. While AMP requires a license, the lifetime option is very affordable and provides a powerful, centralized way to deploy, manage, and maintain multiple game servers. The platform is actively developed and regularly updated, making it a reliable solution for long-term use.

### LXC Containers
- **AdGuard Home**  
  Runs as an LXC container for improved efficiency and lower overhead compared to a full VM. This provides network-wide DNS filtering and ad blocking.

## Hardware Configuration Through Proxmox

- **HPE Smart Array (HBA Mode)**  
  All twenty-four SAS drives are passed directly into the TrueNAS VM for ZFS control.

- **NVIDIA Quadro P2000**  
  Installed and visible inside the Jellyfin container. Application-level hardware acceleration is currently disabled; enabling and verifying NVENC/NVDEC is pending a maintenance window.

- **Dual Intel Xeon E5-2695 v4 CPUs**  
  Provide more than enough cores for virtualization, media work, and parallel testing.

- **64 GB ECC RAM**  
  Allocated across VMs and containers based on workload requirements.

## Why I Chose Proxmox

Proxmox is well-suited for homelab environments due to its balance of enterprise features, community support, and simplicity. It supports:

- Web-based management
- LXC and KVM-based virtualization
- Built-in ZFS support (even though I currently offload ZFS to TrueNAS)
- GPU passthrough (With additional configuration)
- Backup and snapshot tooling
- Network flexibility with bridges, VLANs, and bonded interfaces

Its ease of use and stability make it ideal for learning and iterating on homelab designs without sacrificing performance or reliability.

## Recommended Best Practices for Initial Proxmox Setup

These are commonly suggested steps when setting up a Proxmox host for the first time, along with notes based on my own experience:

### 1. Configure Out-of-Band Management Early  
If your server supports it (such as HPE iLO), set it up immediately. Remote console access saves a significant amount of time when troubleshooting boot issues, updating firmware, or managing ISO installs.

### 2. Use a Separate Disk or SSD for the Proxmox OS  
Avoid installing Proxmox directly onto your main storage pool. A small SSD keeps your hypervisor environment clean and independent from your virtual machines.

In my setup, its not actually possible to run proxmox on my main pool, as its passing through directly to TrueNAS, but even if it was possible it is not reccomended.

### 3. Enable Notifications and Update Regularly  
Proxmox updates are frequent and generally reliable. Enabling email notifications can help keep you informed about system updates, disk issues, or backup alerts.

### 4. Disable the Enterprise Repository (If Not Subscribed)  
Switch to the “no-subscription” repository to avoid update errors. This is a common first step for homelab builds.

### 5. Set Up a Backup Strategy Immediately  
Use scheduled VM backups with tested restores, and use snapshots separately for short-term rollback where the storage supports them. Snapshots are not independent backups. NFS media and passed-through TrueNAS data disks require separate protection; do not assume they are included in a VM backup.

### 6. Keep Your Hardware Features in Mind
If using GPU passthrough, SAS controllers, or high-performance drives, ensure all devices appear correctly in the IOMMU groups and that passthrough is configured before building your VMs.

## Update automation status

Nightly updates, weekly reboots, and alerts for updates requiring manual review were discussed. This documentation update did not verify or change the actual Proxmox timers, scripts, reboot schedule, or backup jobs, so those must not be treated as deployed guarantees. Host uptime alone does not prove that package updates succeeded.

Record the installed package version, timer schedule, removal-handling policy, success/failure notifications, and reboot safeguards after checking the host. See [operations](../Operations/README.md) for the current follow-up list.
