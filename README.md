# td-observability

This project sets up **Prometheus + Grafana** and **ELK Stack (Elasticsearch, Logstash, Kibana)** using Docker Compose to monitor and collect logs from microservices such as `nikit-server`. It’s a ready-to-use solution for development, testing, or observability environments. TeamDroid Observability.

---

## 📦 Project Structure

```
td-observability/
├── elk/
│   ├── logstash/
│   │   └── pipeline/
│   │       └── logstash.conf         # Logstash pipeline config
│   └── docker-compose.yml            # ELK stack orchestration
├── prometheus-grafana/
│   ├── grafana/
│   │   └── datasources/
│   │       └── datasource.yml        # Preconfigured datasource for Grafana
│   ├── prometheus/
│   │   └── prometheus.yml            # Scrape configuration for Prometheus
│   └── docker-compose.yml            # Prometheus + Grafana orchestration
├── start.sh                          # Launches full observability stack
├── stop.sh                           # Stops the stack
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🚀 How to launch the stack

### 1. Make sure the `td-network` exists

Create it if it doesn't exist:

```bash
docker network create td-network
```

### 2. Start the full stack (ELK + Prometheus + Grafana)

```bash
./start.sh
```

This launches:
- ELK stack (Elasticsearch, Logstash, Kibana)
- Prometheus & Grafana

> Ensure Docker Compose V2 is available in your environment.

---

## 🧯 How to stop the containers

```bash
./stop.sh
```

This stops both `elk` and `prometheus-grafana` containers.

---

## 📊 Access the observability tools

| Tool         | URL                  | Default Credentials       |
|--------------|----------------------|---------------------------|
| Prometheus   | http://localhost:9090| N/A                       |
| Grafana      | http://localhost:3000| admin / admin             |
| Kibana       | http://localhost:5601| No auth (by default)      |

---

## 🔎 Usage Guide

### 🔹 Prometheus

- Visit [http://localhost:9090/targets](http://localhost:9090/targets) to verify targets.
- Run queries like:
  ```text
  http_server_requests_seconds_count
  ```
- Spring Boot services must expose `/actuator/prometheus`.

### 🔹 Grafana

- Preconfigured Prometheus datasource is included.
- To import a dashboard:
  1. Go to **Dashboards > New > Import**
  2. Enter ID `11378` (Spring Boot Micrometer)
  3. Select the Prometheus datasource and click "Import"

### 🔹 Kibana

- Access [http://localhost:5601](http://localhost:5601)
- Go to **Discover > Create index pattern**
- Use: `nikit-logs-*` and select `@timestamp` as time field
- Explore logs by fields like `level`, `controller`, `requestId`, `stage`, etc.

---

## 📥 Sending logs to Logstash

Each microservice (e.g. `nikit-server`) must:

- Be on `td-network`
- Send logs via TCP to Logstash at `logstash:5000`
- Include a `logback-spring.xml` like:

```xml
<appender name="LOGSTASH" class="net.logstash.logback.appender.LogstashTcpSocketAppender">
    <destination>logstash:5000</destination>
    <encoder class="net.logstash.logback.encoder.LogstashEncoder" />
</appender>

<root level="INFO">
    <appender-ref ref="LOGSTASH"/>
</root>
```

> Ensure `logback-spring.xml` is located under `src/main/resources/`.

---

## 🧪 How to test end-to-end

1. Make sure the stack is running:
   ```bash
   docker ps
   ```

2. Send a request to a monitored microservice (e.g., `nikit-server`):
   ```bash
   curl http://localhost:8080/api/v1/knowledge
   ```

3. Go to **Kibana → Discover**, select `nikit-logs-*` and inspect the logs.
4. Go to **Prometheus → Targets**, confirm that your microservice is scraped.
5. Go to **Grafana → Dashboards**, and explore imported metrics.

---

## ✅ Recommendations

For best results in local/dev environments:

- Enable structured logs with `LogstashEncoder`
- Log objects (not strings) to allow field-level observability
- Use `codec => json_lines` in `logstash.conf`
- Always restart Logstash after modifying `logstash.conf`:

```bash
docker restart elk-logstash-1
```

---

## 🔐 Production tips

- Configure user/password in Grafana and Kibana
- Persist Grafana dashboards in volumes
- Use Elasticsearch authentication and TLS in production
- Add alerting in Prometheus
- Backup dashboards and config in source control

---

## 🐳 Useful Docker Commands

### 🔹 Launch individual stacks

**Start only Prometheus + Grafana:**
```bash
cd prometheus-grafana
docker compose up -d
```

**Start only ELK stack:**
```bash
cd elk
docker compose up -d
```

---

### ♻️ Restart after configuration changes

**Restart Logstash (after changing `logstash.conf`):**
```bash
docker restart elk-logstash-1
```

**Restart Prometheus (after editing `prometheus.yml`):**
```bash
docker restart prometheus-grafana-prometheus-1
```

**Restart Grafana (after changing dashboards or datasources):**
```bash
docker restart prometheus-grafana-grafana-1
```

---

### 🧯 Stop and clean up

**Stop all containers from both stacks:**
```bash
./stop.sh
```

**Remove containers (from within a subdirectory):**
```bash
docker compose down
```

---

### 🔍 Troubleshooting

**Check logs of Logstash:**
```bash
docker logs -f elk-logstash-1
```

**Check logs of a microservice (e.g., nikit-server):**
```bash
docker logs -f nikit-server
```

**Check containers attached to `td-network`:**
```bash
docker network inspect td-network
```

**Execute a shell in a container:**
```bash
docker exec -it elk-logstash-1 /bin/bash
```
