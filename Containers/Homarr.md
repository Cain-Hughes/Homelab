# Homarr

[This compose file](https://github.com/Cain-Hughes/Homelab/tree/main/Containers/Homarr.yaml) defines my Homarr dashboard instance, which serves as the primary interface for navigating and visualizing services within the homelab.

Homarr acts as a centralized landing page that simplifies access to self-hosted applications and improves overall usability of the environment.

---

## Purpose of This Service

Homarr functions as the organizational and visibility layer of the container ecosystem.

Core responsibilities include:

- Centralized service dashboard
- Quick navigation to internal applications
- Visual grouping of services
- Status monitoring and widgets
- Improved day-to-day usability

Rather than remembering ports and URLs, Homarr provides a single consistent entry point.

---

## Operational Role

This container does not provide backend infrastructure or processing workloads.  
Its value is purely in aggregation, visibility, and user experience.


This keeps the environment easier to operate and reduces friction when adding or modifying services.

---

## Port Mapping

Homarr exposes a single application port:

7575 → Homarr Web Interface

This port provides access to the dashboard UI and associated features.

---

## Data Persistence

A bind mount is used for persistent application state:

./homarr/appdata → /appdata

This stores:

- Dashboard configuration
- Layout data
- Widgets and settings
- User preferences

Container recreation does not impact dashboard state.

---

## Docker Integration

Optional Docker socket mounting is enabled:

/var/run/docker.sock → /var/run/docker.sock

This allows Homarr to:

- Query container states
- Display service status information
- Provide dynamic widgets

The container itself does not control Docker but can observe it.

---

## Security Considerations

Homarr requires a secret encryption key:

SECRET_ENCRYPTION_KEY=<value>

This key is used internally for secure handling of sensitive configuration data.

---

## Restart Behavior

The container uses:

restart: unless-stopped

This ensures dashboard availability after host restarts or transient failures.

---

## Notes

- Homarr improves service discoverability
- No direct dependency on backend containers
- Configuration survives rebuilds
- Docker integration is optional but useful
- Functions purely as an interface layer

---

This service exists to make the homelab easier to interact with, manage, and understand at a glance.
