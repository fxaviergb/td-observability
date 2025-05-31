#!/bin/bash

set -e  # Finaliza si algún comando falla
set -o pipefail

NETWORK_NAME="td-network"

# Función para limpiar los servicios en caso de fallo
rollback() {
  echo "Error detectado. Deteniendo todos los contenedores de observabilidad..."
  docker-compose -f elk/docker-compose.yml down || true
  docker-compose -f prometheus-grafana/docker-compose.yml down || true
  exit 1
}

# Verificar si la red existe, si no, crearla
if ! docker network inspect "$NETWORK_NAME" > /dev/null 2>&1; then
  echo "Red '$NETWORK_NAME' no existe. Creándola..."
  docker network create "$NETWORK_NAME"
else
  echo "Red '$NETWORK_NAME' ya existe."
fi

# Ejecutar con rollback si algo falla
trap rollback ERR

echo "Levantando ELK Stack..."
docker-compose -f elk/docker-compose.yml up -d

echo "Levantando Prometheus + Grafana..."
docker-compose -f prometheus-grafana/docker-compose.yml up -d

echo "Observabilidad iniciada correctamente."
