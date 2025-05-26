# td-observability

This project sets up **Prometheus** and **Grafana** using Docker Compose to monitor multiple microservices, such as `nikit-server`. It’s a ready-to-use solution for development, testing, or observability environments. TeamDroid Observability.

---

## 📦 Project Structure

```
td-observability/
├── docker-compose.yml                # Defines Grafana and Prometheus services
├── prometheus/
│   └── prometheus.yml                # Scrape configuration for Prometheus
├── grafana/
│   └── datasources/
│       └── datasource.yml            # Preconfigured datasource for Grafana
├── .env                              # Optional environment variables
└── README.md                         # Documentation
```

---

## 🚀 How to launch the solution

### 1. Make sure the `td-network` exists

If it doesn’t exist, create it with:

```bash
docker network create td-network
```

### 2. Start the containers

```bash
docker compose up -d
```

This command will download the images if not available locally and launch `prometheus` and `grafana` in detached mode (`-d`).

---

## 🧯 How to stop the containers

```bash
docker compose down
```

This stops and removes the containers. It does not affect volumes or persistent configurations (like saved Grafana dashboards).

---

## 🔄 How to restart the containers

If you've made changes to `.env` or `docker-compose.yml`:

```bash
docker compose down
docker compose up --build -d
```

This ensures new values are applied and rebuilds the containers if needed.

---

## 📊 Access to tools

- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000  
  - Username: `admin`  
  - Password: `admin` (you can change it after the first login, e.g., to `abc123..`)

---

## 🔎 Basic usage guide

### 🔹 Prometheus

- Visit [http://localhost:9090/targets](http://localhost:9090/targets) to check which targets are being scraped.
- Try queries in the **Graph** tab, for example:
  ```text
  http_server_requests_seconds_count
  ```
- Spring Boot metrics are exposed at `/actuator/prometheus` for each microservice.

### 🔹 Grafana

- Once logged in, you'll see a preconfigured Prometheus datasource.
- To import a dashboard:
  1. Go to **Dashboards > New > Import**
  2. Under “Import via grafana.com”, enter ID: `11378`
  3. Click “Load” and select the Prometheus datasource
  4. Click “Import”

> Dashboard ID **11378** is specifically designed for **Spring Boot with micrometer** and provides ready-to-use visualizations.

---

## 🧪 Requirements for monitored microservices

Each Spring Boot microservice must:

- Expose metrics at `/actuator/prometheus`
- Include these properties:

```properties
management.endpoints.web.exposure.include=prometheus
management.endpoint.prometheus.enabled=true
```

- Be attached to the `td-network` Docker network
- Be listed as a `target` in `prometheus/prometheus.yml`

---

## 🛠️ Customization

You can edit `prometheus/prometheus.yml` to add more jobs and targets in the following format:

```yaml
scrape_configs:
  - job_name: 'my-microservice'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['service-name:port']
```

---

## ✅ Recommendation

Use this stack as a base for observability in local or integration environments. For production, consider:

- Prometheus alerting
- Backup and dashboard persistence in Grafana
- Securing access with proper credentials and restrictions

---
