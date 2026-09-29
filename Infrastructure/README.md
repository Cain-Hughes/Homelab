# Infrastructure Overview ***(work in progress)***

My primary homelab server is an HPE ProLiant DL380 Gen9 equipped with dual Intel Xeon E5-2695 v4 processors and 64 GB of RAM. I purchased the system used from eBay, and it has proven to be a reliable and capable platform for virtualization and storage workloads.


## Recommended Setup Steps (HPE DL380 Gen9)

### 1. Start with a Clean Slate  
For newly acquired hardware, inventory the drives and preserve any data that must be kept before repurposing storage. Review BIOS and iLO settings deliberately; a reset or format is destructive and is not a routine update step.


### 2. Configure iLO Early  
I strongly recommend setting up iLO at this stage and configuring the server from your preferred workstation. You will spend a significant amount of time managing and adjusting settings, and full remote access becomes invaluable if you ever lose access to your hypervisor.  
With iLO, you can perform complete remote management as if you were physically in front of the server, including tasks like mounting ISO images for installation.
![ILO Example Screenshot](https://github.com/Cain-Hughes/Homelab/blob/main/Infrastructure/Images/ilo1.png)


### 3. Update Firmware  
It is highly recommended to update all firmware components to their latest versions. Though time-consuming, this process ensures stability and compatibility with modern hypervisors. It appears that HPE has released their SPP (Service Pack for Prolient) for this generation of server for free now, so I reccomend using that first and filling in the gaps after.

- [Latest SPP for HPE Gen 9](https://support.hpe.com/connect/s/softwaredetails?tab=releaseNotes&collectionId=MTX-d25d2a7d88de4d64)
- [User Guide](https://support.hpe.com/hpesc/public/docDisplay?docId=c04436966&docLocale=en_US)  
- [Firmware Downloads](https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=7271241&tab=driversAndSoftware)


### 4. Enable Virtualization Features  
Make sure all virtualization settings are enabled in the BIOS:

System Utilities → System Configuration → BIOS/Platform Configuration (RBSU) → Virtualization Options → Intel Virtualization Technology (Intel VT)


### 5. Choose Fast Storage for the OS  
For the operating system or hypervisor, use an SSD rather than traditional hard drives. In my setup, I installed a PCIe adapter with an M.2 slot and mounted a WD Black SN770 1 TB SSD, which provides excellent performance for virtual machine workloads.

This configuration has served as a solid foundation for my homelab and supports future expansion as my environment grows.

The OS/VM storage uses a single SSD. A mirror could improve availability, but it would not replace backups. A tested, scheduled backup strategy has not been verified for this environment; local troubleshooting copies do not establish full recovery coverage. See [operations and recovery](../Operations/README.md).


### 6. SAS Storage Array
My server includes a full array of twenty-four 10K SAS drives installed in the front SFF bays. These drives provide a reliable and high-performance foundation for my storage pool. I am passing all twenty-four drives through the HPE Smart Array controller in HBA mode, allowing TrueNAS to manage the disks directly using ZFS. This setup gives me the flexibility to design my own vdev layout, maintain end-to-end data integrity, and avoid traditional hardware RAID layers.

Running the controller in HBA mode ensures:
- Direct ZFS visibility into all drives  
- Better data consistency and error reporting  
- The ability to utilize ZFS features such as RAIDZ, snapshots, and self-healing  

This configuration supports my media-focused workloads. The disk-health and backup follow-ups below remain outstanding.


### 7. GPU Acceleration
The server is equipped with an NVIDIA Quadro P2000. This card is widely used in media servers for its strong NVENC/NVDEC hardware encoding capabilities and power efficiency. In my setup, it is available for GPU acceleration tasks such as transcoding within Jellyfin and other containers.

The P2000 is intended to:
- Offload transcoding workloads from the CPUs  
- Support multiple simultaneous media streams  
- Maintain lower overall system load during peak usage  

September 28 verification confirmed the GPU is visible inside Jellyfin, but Jellyfin's hardware acceleration method is currently None. Recent video transcodes used software encoding. Enabling and testing hardware acceleration is deferred to a maintenance window.

## Separate monitoring and DNS device

A Raspberry Pi at `10.10.20.8` runs secondary AdGuard Home and primary Uptime Kuma. Secondary Kuma runs on the Docker VM. Keeping the primary monitor on a separate device improves visibility into VM/host failures, while both devices still share some network and power dependencies.

## Storage health and capacity

Twenty-four 600 GB drives provide approximately 14.4 TB of raw decimal capacity. This is not the usable ZFS capacity; redundancy and formatting reduce it. A drive in a RAIDZ2 vdev has reported read errors while remaining ONLINE. The cause and remaining lifetime have not been established, and no replacement or pool rebuild is claimed here.

An independent media backup has not been established by this work. Disk health, backups, and potential future NAS replacement remain follow-ups; proposed hardware is not part of the deployed inventory.
