#!/usr/bin/env bash
# Tashi DePIN Worker Installer (Fixed Version)

set -e

# -----------------------------
# CONFIG
# -----------------------------

IMAGE_TAG="${IMAGE_TAG:-ghcr.io/tashigg/tashi-depin-worker:latest}"
CONTAINER_NAME="tashi-depin-worker"
AUTH_VOLUME="tashi-depin-worker-auth"
AUTH_DIR="/home/worker/auth"

AGENT_PORT=39065

RUST_LOG="info,tashi_depin_worker=debug,tashi_depin_common=debug"

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

CHECK="${GREEN}✓${RESET}"
ERROR="${RED}✗${RESET}"
WARN="${YELLOW}⚠${RESET}"

# -----------------------------
# LOG
# -----------------------------

log() {
    echo -e "$1"
}

# -----------------------------
# CHECK DOCKER
# -----------------------------

check_docker() {

    if command -v docker >/dev/null 2>&1; then
        RUNTIME="docker"
        log "Docker detected ${CHECK}"
    elif command -v podman >/dev/null 2>&1; then
        RUNTIME="podman"
        log "Podman detected ${CHECK}"
    else
        log "${ERROR} Docker or Podman not installed"
        exit 1
    fi
}

# -----------------------------
# SYSTEM CHECKS
# -----------------------------

check_cpu() {

    CPU=$(nproc)

    if [ "$CPU" -ge 2 ]; then
        log "CPU: $CPU threads ${CHECK}"
    else
        log "CPU: minimum 2 threads required ${ERROR}"
        exit 1
    fi
}

check_ram() {

    RAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    RAM=$((RAM / 1024 / 1024))

    if [ "$RAM" -ge 2 ]; then
        log "RAM: ${RAM}GB ${CHECK}"
    else
        log "RAM: minimum 2GB required ${ERROR}"
        exit 1
    fi
}

check_disk() {

    DISK=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')

    if [ "$DISK" -ge 20 ]; then
        log "Disk: ${DISK}GB free ${CHECK}"
    else
        log "Disk: minimum 20GB required ${ERROR}"
        exit 1
    fi
}

# -----------------------------
# INTERNET CHECK
# -----------------------------

check_network() {

    if curl -s https://google.com >/dev/null; then
        log "Internet connectivity ${CHECK}"
    else
        log "Internet connection required ${ERROR}"
        exit 1
    fi
}

# -----------------------------
# IMAGE CHECK
# -----------------------------

check_image() {

    log "Checking worker image..."

    if ! $RUNTIME pull "$IMAGE_TAG"; then
        log "${WARN} Pull failed. Trying GHCR login..."

        docker login ghcr.io || {
            log "${ERROR} Login failed"
            exit 1
        }

        $RUNTIME pull "$IMAGE_TAG"
    fi

    log "Worker image ready ${CHECK}"
}

# -----------------------------
# INSTALL WORKER
# -----------------------------

install_worker() {

    log ""
    log "Starting worker setup..."

    $RUNTIME run --rm -it \
        --mount type=volume,src=$AUTH_VOLUME,dst=$AUTH_DIR \
        "$IMAGE_TAG" \
        interactive-setup $AUTH_DIR

    log ""
    log "Starting worker node..."

    $RUNTIME run -d \
        --name $CONTAINER_NAME \
        -p $AGENT_PORT:$AGENT_PORT \
        -p 127.0.0.1:9000:9000 \
        --mount type=volume,src=$AUTH_VOLUME,dst=$AUTH_DIR \
        -e RUST_LOG="$RUST_LOG" \
        --restart=on-failure \
        "$IMAGE_TAG" \
        run $AUTH_DIR

    log ""
    log "Worker started ${CHECK}"
}

# -----------------------------
# STATUS
# -----------------------------

show_status() {

    echo ""
    echo "Worker status:"
    $RUNTIME ps | grep $CONTAINER_NAME || true

    echo ""
    echo "Logs command:"
    echo "docker logs $CONTAINER_NAME"
}

# -----------------------------
# MAIN
# -----------------------------

echo ""
echo "Tashi DePIN Worker Installer"
echo ""

check_docker
check_cpu
check_ram
check_disk
check_network
check_image

install_worker
show_status
