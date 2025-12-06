# Infrastructure Overview ***(work in progress)***

My primary homelab server is an HPE ProLiant DL380 Gen9 equipped with dual Intel Xeon E5-2695 v4 processors and 64 GB of RAM. I purchased the system used from eBay, and it has proven to be a reliable and capable platform for virtualization and storage workloads.


## Recommended Setup Steps

### 1. Start with a Clean Slate  
Remove any existing storage drives and fully format them. While this is in progress, enter the BIOS and reset all settings to factory defaults, including the iLO module.


### 2. Configure iLO Early  
I strongly recommend setting up iLO at this stage and configuring the server from your preferred workstation. You will spend a significant amount of time managing and adjusting settings, and full remote access becomes invaluable if you ever lose access to your hypervisor.  
With iLO, you can perform complete remote management as if you were physically in front of the server, including tasks like mounting ISO images for installation.
![ILO Example Screenshot](https://github.com/Cain-Hughes/Homelab/blob/main/Infrastructure/Images/ilo1.png)

### 3. Update Firmware  
It is highly recommended to update all firmware components to their latest versions. Though time-consuming, this process ensures stability and compatibility with modern hypervisors.

- User Guide: https://support.hpe.com/hpesc/public/docDisplay?docId=c04436966&docLocale=en_US  
- Firmware Downloads: https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=7271241&tab=driversAndSoftware


### 4. Enable Virtualization Features  
Make sure all virtualization settings are enabled in the BIOS:

System Utilities → System Configuration → BIOS/Platform Configuration (RBSU) → Virtualization Options → Intel Virtualization Technology (Intel VT)


### 5. Choose Fast Storage for the OS  
For the operating system or hypervisor, use an SSD rather than traditional hard drives. In my setup, I installed a PCIe adapter with an M.2 slot and mounted a WD Black SN770 1 TB SSD, which provides excellent performance for virtual machine workloads.

This configuration has served as a solid foundation for my homelab and supports future expansion as my environment grows.
