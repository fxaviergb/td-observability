#!/bin/bash

echo "Deteniendo Prometheus + Grafana..."
docker-compose -f prometheus-grafana/docker-compose.yml down

echo "Deteniendo ELK Stack..."
docker-compose -f elk/docker-compose.yml down

echo "Todos los servicios han sido detenidos."
