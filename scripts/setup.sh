#!/bin/bash
set -e

# Check if tools are installed
for cmd in docker devcontainer; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "ERROR: $cmd could not be found. Please install it first."
        exit 1
    fi
done

# Clone ZMK and modules
ZMK_DIR="./zmk"
PMW3610_DIR="./modules/zmk-pmw3610-driver"

echo "Cloning ZMK repository..."
if [ -d "$ZMK_DIR" ]; then
    echo "ZMK repository already exists. Skip cloning."
else
    git clone https://github.com/zmkfirmware/zmk.git "$ZMK_DIR"
fi

echo "Cloning PMW3610 driver module..."
if [ -d "$PMW3610_DIR" ]; then
    echo "PMW3610 driver module already exists. Skip cloning."
else
    git clone https://github.com/kumamuk-git/zmk-pmw3610-driver.git "$PMW3610_DIR"
fi

# Create Docker volumes
CONFIG_PATH="$(realpath .)"
MODULES_PATH="$(realpath ./modules)"

echo "Creating Docker volumes..."
docker volume create --driver local -o o=bind -o type=none \
    -o device="$CONFIG_PATH" zmk-config
docker volume create --driver local -o o=bind -o type=none \
    -o device="$MODULES_PATH" zmk-modules

# Run Dev Container
echo "Starting Dev Container..."
devcontainer up --workspace-folder "$ZMK_DIR"

# Configure Zephyr Workspace
echo "Configuring Zephyr workspace..."
devcontainer exec --workspace-folder "$ZMK_DIR" west init -l app/
devcontainer exec --workspace-folder "$ZMK_DIR" west update

echo "Setup has been completed."
