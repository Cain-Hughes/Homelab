# Homelab

This repository documents the evolution of my personal homelab, covering its core infrastructure, virtual machines, containers, network architecture, and more. My goal is to capture what I’ve built, what I’ve learned, and what I continue to refine as my skills and environment grow.

Feel free to explore, take inspiration, or offer constructive feedback. I'm always looking for ways to improve and expand this project.

## BuildLog

Ongoing changes, experiments, and operational notes from my homelab are documented in the BuildLog.

This section serves as a lightweight, chronological journal of improvements, troubleshooting, and design decisions as the environment evolves.

→ **[View the B(uild)Log](https://github.com/Cain-Hughes/Homelab/tree/main/BuildLog/README.md)**

# Navigation

* [Infrastructure](https://github.com/Cain-Hughes/Homelab/tree/main/Infrastructure) - List of all of my infrastructure including configuration
* [Networking](https://github.com/Cain-Hughes/Homelab/tree/main/Networking) - Logical layout and design of my network
* [Hypervisor](https://github.com/Cain-Hughes/Homelab/tree/main/Hypervisor) - My preferred hypervisor and its configuration
* [Virtual Machines](https://github.com/Cain-Hughes/Homelab/tree/main/Virtual-Machines) - List of all my VM's and their setups
* [Containers](Containers/README.md) - Service documentation and sanitized Compose examples
* [Operations and recovery](Operations/README.md) - Verified changes, backup boundaries, and planned maintenance


## Infrastructure

My current hardware stack centers around an HPE ProLiant DL380 Gen9 server with approximately 14.4 TB of raw SAS capacity (usable capacity is lower after ZFS redundancy and formatting), supported by an Eaton 1U UPS.
You can find detailed hardware information, configuration notes, and lessons learned on the [Infrastructure](https://github.com/Cain-Hughes/Homelab/tree/main/Infrastructure) page.


## Hypervisor & Virtualization

I run Proxmox as my primary hypervisor, chosen for its flexibility, performance, and extensive community support. More information about my configuration can be found under:  
[Hypervisor](https://github.com/Cain-Hughes/Homelab/tree/main/Hypervisor)

My virtualized environment includes:

- A TrueNAS CE VM responsible for all storage pool management  
- An Ubuntu Server VM running Docker, dedicated to running my media server stack and other useful containers  
- An LXC container for AdGuard Home
- An Ubuntu server VM running AMP, allowing me to run game servers easily and reliably

Details on each virtual machine and their roles can be found on the  
[Virtual Machines](https://github.com/Cain-Hughes/Homelab/tree/main/Virtual-Machines) page.


## Containers & Services

My services are primarily containerized to keep the environment modular and easy to maintain. This includes media applications, supporting tools, and system utilities. A full list of the containers I run, along with their configurations and purposes, can be found on the  
[Containers](https://github.com/Cain-Hughes/Homelab/tree/main/Containers) page.

## September 2026 update

The lab now includes primary and secondary Uptime Kuma monitoring, Telegram notifications, and Streamystats for Jellyfin viewing analytics. Media work consolidated Sonarr profiles, restricted Seerr request choices, repaired archive/queue handling, and added local NFO/artwork export.

GPU acceleration, Continue Watching deduplication, and Maintainerr remain deferred. The P2000 is available to Jellyfin, but acceleration is currently disabled in the application. A complete independent backup strategy is also outstanding.

Read the [September build log](BuildLog/2026-09.md) and [current operations status](Operations/README.md). Configuration examples omit secrets and use placeholder domains. They are not production backups or a promise that every application setting is recreated by Compose.
