# Homelab ***(work in progress)***

This repository documents the evolution of my personal homelab, covering its core infrastructure, virtual machines, containers, network architecture, and more. My goal is to capture what I’ve built, what I’ve learned, and what I continue to refine as my skills and environment grow.

Feel free to explore, take inspiration, or offer constructive feedback. I'm always looking for ways to improve and expand this project.

## BuildLog

Ongoing changes, experiments, and operational notes from my homelab are documented in the BuildLog.

This section serves as a lightweight, chronological journal of improvements, troubleshooting, and design decisions as the environment evolves.

→ **[View the B(uild)Log](https://github.com/Cain-Hughes/Homelab/tree/main/buildlog/readme.md)**

# Navigation

* [Infrastructure](https://github.com/Cain-Hughes/Homelab/tree/main/Infrastructure) - List of all of my infrastructure including configuration
* [Networking](https://github.com/Cain-Hughes/Homelab/tree/main/Networking) - Logical layout and design of my network
* [Hypervisor](https://github.com/Cain-Hughes/Homelab/tree/main/Hypervisor) - My preferred hypervisor and its configuration
* [Virtual Machines](https://github.com/Cain-Hughes/Homelab/tree/main/Virtual-Machines) - List of all my VM's and their setups
* [Containers](https://github.com/Cain-Hughes/Homelab/tree/main/Containers) - List of all my containers and their setups


## Infrastructure

My current hardware stack centers around an HPE ProLiant DL380 Gen9 server with approximately 14 TB of storage, supported by an Eaton 1U UPS.  
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
