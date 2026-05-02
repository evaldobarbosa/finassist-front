#!/bin/bash
set -e

ENVIRONMENT=${1:-production}

echo "=== Deploy ZapGrana Frontend - $ENVIRONMENT ==="

# Login no GitHub Container Registry
if [ -f .github_token ]; then
    cat .github_token | docker login ghcr.io -u ${GITHUB_USER:-github} --password-stdin
    rm -f .github_token
fi

# Pull da nova imagem
echo "Baixando imagem..."
docker compose -f docker-compose.github.yml pull front

# Parar containers antigos
echo "Parando containers..."
docker compose -f docker-compose.github.yml down --remove-orphans || true

# Subir novos containers
echo "Iniciando containers..."
docker compose -f docker-compose.github.yml up -d

# Limpar imagens antigas
echo "Limpando imagens antigas..."
docker image prune -f

echo "=== Deploy concluido! ==="
