# Netwokring Overview (Work In Progress)

This document provides a high-level overview of my home network architecture, segmentation strategy, and external exposure model.

The environment is built around UniFi for routing, firewalling, and VLAN management, with a Cisco switch providing Layer 2 switching.

---

## Core Architecture

**Gateway / Routing / Firewall**

- UniFi Cloud Gateway Max  
- Handles inter-VLAN routing, firewall policies, and network segmentation  
- Serves as the primary security boundary

**Switching**

- Cisco Catalyst Switch  
- Operating strictly at Layer 2  
- VLAN trunking to the gateway, access ports to endpoints

---

## Network Design Philosophy

The network is intentionally segmented to separate trust boundaries, reduce lateral movement, and improve overall security posture.

Each functional device class resides within its own VLAN and subnet.

Addressing follows a simple convention: 10.10.<VLAN_ID>.0/24

Exception:

- The Work VLAN uses a 192.168.x.0/24 network to prevent overlap with an external corporate network accessed via VPN.

---

## VLAN Layout

| VLAN | Purpose            | Subnet            |
|------|--------------------|-------------------|
| 1    | UniFi Infrastructure | 10.10.1.0/24Default |
| 20   | Servers            | 10.10.20.0/24     |
| 30   | Trusted Clients    | 10.10.30.0/24     |
| 40   | IoT Devices        | 10.10.40.0/24     |
| 50   | Guest Network      | 10.10.50.0/24     |
| 60   | Work Devices       | 192.168.1.0/24    |

---

## Wireless Networks

Wireless networks are mapped directly to VLANs.

- **wifi** → Trusted VLAN  
- **wifi-guest** → Guest VLAN  
- **wifi-IoT** → IoT VLAN  
- **wifi-work (hidden)** → Work VLAN  

SSID names are intentionally abstracted for privacy.

---

## Firewall & External Exposure Model

The network follows a minimal exposure principle.

**Externally forwarded ports:**

- Limited ports for a non-disclosed game server  
- TCP 80 / 443 only

**Cloudflare Integration:**

- Public-facing services are routed through Cloudflare  
- Cloudflare proxying is used to prevent direct IP exposure  
- UniFi firewall rules restrict inbound traffic to Cloudflare IP ranges only

This model ensures the WAN IP address is not directly exposed for proxied services.

---

## Remote Access Strategy

Remote access is handled exclusively through VPN connectivity.

**WireGuard VPN**

- Custom WireGuard configuration  
- Tunnel Network: `10.10.99.0/24`  
- Provides secure access to internal services and management interfaces  
- Eliminates the need to expose internal applications directly

---

## Security Approach

Key design priorities include:

- Network segmentation by trust level  
- Least-privilege firewall policies  
- Minimal port forwarding  
- Reverse proxying and IP masking via Cloudflare  
- VPN-only access to internal resources

---

## Notes

This document intentionally omits sensitive operational details, hostnames, and identifying information.

Its purpose is to describe architectural decisions and design patterns rather than deployment specifics.
