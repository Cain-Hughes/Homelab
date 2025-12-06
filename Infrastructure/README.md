# Infrastructure Overview ***(work in progress)***

My primary homelab server is an HPE ProLiant DL380 Gen9 equipped with dual Intel Xeon E5-2695 v4 processors and 64 GB of RAM. I purchased the system used from eBay, and it has proven to be a reliable and capable platform for virtualization and storage workloads.

## Recommended Setup Steps

### 1. Start with a Clean Slate  
Remove any existing storage drives and fully format them. While this is in progress, enter the BIOS and reset all settings to factory defaults, including the iLO module.

### 2. Update Firmware  
It is highly recommended to update all firmware components to their latest versions. Though time-consuming, doing so ensures stability and compatibility with modern hypervisors.

- User Guide: https://support.hpe.com/hpesc/public/docDisplay?docId=c04436966&docLocale=en_US  
- Firmware Downloads: https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=7271241&tab=driversAndSoftware

### 3. Enable Virtualization Features  
Make sure all virtualization settings are enabled in the BIOS:

System Utilities → System Configuration → BIOS/Platform Configuration (RBSU) → Virtualization Options → Intel Virtualization Technology (Intel VT)

### 4. Choose Fast Storage for the OS  
For the operating system or hypervisor, use an SSD rather than traditional hard drives. In my setup, I installed a PCIe adapter with an M.2 slot and mounted a WD Black SN770 1 TB SSD, which provides excellent performance for virtual machine workloads.

This configuration has served as a solid foundation for my homelab and supports future expansion as my environment grows.
