# Uptime Kuma

I use two independent Uptime Kuma instances so a failure of the primary monitoring device can still generate an alert.

| Instance | Host | Role |
|---|---|---|
| Primary | Raspberry Pi, `10.10.20.8` | Main service monitoring; shares the device with secondary AdGuard Home |
| Secondary | Docker host, `10.10.20.5` | Watches the Pi and the primary Uptime Kuma service |

The secondary instance lives at `/docker/uptime`, uses `./data:/app/data`, and publishes `10.10.20.5:3001`. Its image was verified as `louislam/uptime-kuma:2.5.5` on September 28, 2026. The [Compose example](UptimeKuma.yaml) describes that secondary deployment; it is not an export of the Pi's configuration.

## Failure detection

The two active secondary monitors were checked directly:

| Monitor | Check | Interval | Retries |
|---|---|---|---|
| Monitoring Pi host | ICMP ping to `10.10.20.8` | 60 seconds | 2 |
| Primary Uptime Kuma | HTTP service check | 60 seconds | 2 |

Notifications use Telegram, with a separate notification configuration on the secondary instance using the same bot. Credentials and chat identifiers stay in the application, never in this repo. Monitor names identify the secondary source so alerts can be distinguished.

These instances are independent, not a replicated cluster. A change to the primary's monitors is not automatically copied to the secondary. Replicator Kuma was discussed but not deployed as part of this work.

## What different checks mean

| Check | Question it answers |
|---|---|
| Host ping | Can this monitoring device reach the host by ICMP? |
| HTTP or TCP to the LAN address and port | Is the application endpoint responding? |
| HTTPS through the service domain | Does the DNS/proxy/TLS/application path work from this monitor's location? |
| DNS query to an AdGuard server | Can that resolver answer a real DNS request? |

This is the intended layered monitoring pattern. The table describes the design, not a claim that every service already has all four checks. A ping does not prove an application is healthy, and a working web interface does not prove every backend dependency works.

The secondary checks were reverified for this documentation update. The full primary monitor inventory should be exported and reviewed separately before documenting exact coverage or thresholds for every service.

## Testing and limitations

During a planned test, stop only the monitored application, confirm the down notification, restore it, and confirm recovery. A Docker `unless-stopped` policy does not restart a container deliberately stopped with `docker stop`; start it explicitly or establish a separate recovery timer before testing.

The Pi and Docker host still share the home network and potentially the same power and Internet connection. If both monitors lose Internet access, neither can deliver a Telegram alert. This is local monitoring redundancy, not external outage monitoring.

Back up each instance's data independently with a consistent database backup or while its container is stopped. Preserve notification credentials privately. Never treat a host's uptime alone as proof that updates installed successfully.

Source: [Uptime Kuma](https://github.com/louislam/uptime-kuma).
