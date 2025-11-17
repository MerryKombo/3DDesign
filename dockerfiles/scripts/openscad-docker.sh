#!/bin/bash
# ==============================================================================
# OpenSCAD Docker Wrapper with Persistent Configuration
# ==============================================================================
#
# This script launches OpenSCAD from a Docker container while preserving:
# - Recent files list
# - User preferences
# - Window positions
# - Custom settings
#
# The OpenSCAD libraries (BOSL2, NopSCADlib, etc.) remain in the container.
#
# Usage:
#   openscad-docker.sh [OPTIONS] [FILE.scad]
#
# Examples:
#   openscad-docker.sh                    # Launch OpenSCAD GUI
#   openscad-docker.sh mymodel.scad       # Open a specific file
#   openscad-docker.sh --version          # Show version
#   openscad-docker.sh -o out.stl in.scad # Render to STL
#
# ==============================================================================

set -e

# Configuration
DOCKER_IMAGE="${OPENSCAD_DOCKER_IMAGE:-gounthar/openscad:test}"
CONFIG_DIR="${OPENSCAD_CONFIG_DIR:-${HOME}/.openscad-docker}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check dependencies
check_dependencies() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH"
        echo "Please install Docker: https://docs.docker.com/get-docker/"
        exit 1
    fi

    if ! docker info &> /dev/null; then
        log_error "Docker daemon is not running"
        echo "Please start Docker daemon"
        exit 1
    fi
}

# Initialize persistent configuration directory
init_config() {
    # Create config directory structure
    mkdir -p "${CONFIG_DIR}/config"

    # Check if this is first run
    if [ ! -f "${CONFIG_DIR}/.initialized" ]; then
        log_info "First run - initializing persistent configuration..."

        # Create marker file
        touch "${CONFIG_DIR}/.initialized"

        log_info "Configuration directory: ${CONFIG_DIR}"
        log_info "Your OpenSCAD preferences will be saved here."
    fi
}

# Build Docker run command
build_docker_cmd() {
    local cmd="docker run -it --rm"

    # X11/Wayland display (WSL2 compatible)
    cmd+=" -v /tmp/.X11-unix:/tmp/.X11-unix"

    # WSLg support
    if [ -d "/mnt/wslg" ]; then
        cmd+=" -v /mnt/wslg:/mnt/wslg"
    fi

    # Mount filesystems for file access
    cmd+=" -v /mnt:/mnt"

    # Also mount home directory if not under /mnt
    if [ -d "${HOME}" ] && [[ "${HOME}" != /mnt/* ]]; then
        cmd+=" -v ${HOME}:${HOME}"
    fi

    # Persistent configuration (only .config, not .local/share to preserve libraries)
    cmd+=" -v ${CONFIG_DIR}/config:/home/openscad/.config/OpenSCAD"

    # Environment variables for display
    [ -n "${DISPLAY}" ] && cmd+=" -e DISPLAY=${DISPLAY}"
    [ -n "${WAYLAND_DISPLAY}" ] && cmd+=" -e WAYLAND_DISPLAY=${WAYLAND_DISPLAY}"
    [ -n "${XDG_RUNTIME_DIR}" ] && cmd+=" -e XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR}"
    [ -n "${PULSE_SERVER}" ] && cmd+=" -e PULSE_SERVER=${PULSE_SERVER}"

    # Set working directory to current directory (mapped path)
    local workdir
    workdir=$(pwd)
    cmd+=" -w ${workdir}"

    # Docker image
    cmd+=" ${DOCKER_IMAGE}"

    echo "${cmd}"
}

# Main function
main() {
    check_dependencies
    init_config

    # Build the Docker command
    local docker_cmd
    docker_cmd=$(build_docker_cmd)

    # Always explicitly call openscad with arguments
    if [ $# -eq 0 ]; then
        log_info "Launching OpenSCAD GUI..."
        eval "${docker_cmd} openscad"
    else
        # Pass all arguments to OpenSCAD
        log_info "Running: openscad $*"
        eval "${docker_cmd} openscad $*"
    fi
}

# Run main function with all script arguments
main "$@"
