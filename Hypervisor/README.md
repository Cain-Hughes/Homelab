# Proxmox Hypervisor ***(work in progress)***

This section documents the Proxmox VE environment that forms the core of my homelab. I am currently running Proxmox VE 9.x.x (Latest version as I am constantly updating) on an HPE ProLiant DL380 Gen9 configured as my primary hypervisor. Proxmox has been a reliable and flexible platform for managing virtual machines, containers, and hardware pass-through, and it continues to be one of the best hypervisors for hands-on learning and experimentation.

My setup is designed to support storage virtualization, media services, network services, and general testing. Proxmox provides an easy way to isolate workloads, snapshot them, experiment with new configurations, and recover quickly when something breaks.


## Current Virtualization Layout

### Virtual Machines
I am currently running the following VMs on the hypervisor:

- **TrueNAS SCALE VM**  
  Manages all storage using ZFS, with twenty-four 10K SAS drives passed directly through the Smart Array controller operating in HBA mode. TrueNAS handles all disk integrity, redundancy, and pool management.

- **Docker Server VM**  
  Runs my media server stack using Docker and includes containers such as Jellyfin, Radarr, Sonarr, qBittorrent, Gluetun, Prowlarr, Jellyseerr, Homarr, Cloudflare-DDNS, and NPM. This VM centralizes all containerized workloads and keeps storage separate from applications.

### LXC Containers
- **AdGuard Home**  
  Runs as an LXC container for improved efficiency and lower overhead compared to a full VM. This provides network-wide DNS filtering and ad blocking.

## Hardware Configuration Through Proxmox

- **HPE Smart Array (HBA Mode)**  
  All twenty-four SAS drives are passed directly into the TrueNAS VM for ZFS control.

- **NVIDIA Quadro P2000**  
  Installed for media transcoding and available for GPU passthrough. The P2000 is known for its strong NVENC/NVDEC support and low power draw, making it a great fit for Jellyfin and similar workloads.

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
Use the built-in backup system to schedule regular snapshots or full VM backups. This is especially important for experimentation-heavy environments.

### 7. Keep Your Hardware Features in Mind  
If using GPU passthrough, SAS controllers, or high-performance drives, ensure all devices appear correctly in the IOMMU groups and that passthrough is configured before building your VMs.
