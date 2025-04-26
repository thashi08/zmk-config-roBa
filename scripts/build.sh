#!/bin/bash
set -e

usage() {
    echo "Usage: $0 [-p] [-h]"
    echo "  -p  Build pristine (clean build)"
    echo "  -h  Show this help message"
}

ZMK_PATH="./zmk"
pristine_build=0

# Parse option
while getopts "ph" opt; do
    case "$opt" in
    p) pristine_build=1 ;;
    h)
        usage
        exit 0
        ;;
    ?)
        usage
        exit 1
        ;;
    esac
done

# Run Dev Container
devcontainer up --workspace-folder "$ZMK_PATH" || {
    echo "ERROR: Failed to start Dev Container."
    exit 1
}

# Build firmware
echo "Building firmware..."
if [ $pristine_build = 1 ]; then
    devcontainer exec --workspace-folder "$ZMK_PATH" west build -p -s app -d build/right -b seeeduino_xiao_ble -S studio-rpc-usb-uart \
        -- -DZMK_CONFIG=/workspaces/zmk-config/config -DSHIELD=roBa_R -DZMK_EXTRA_MODULES=/workspaces/zmk-modules/zmk-pmw3610-driver
    devcontainer exec --workspace-folder "$ZMK_PATH" west build -p -s app -d build/left -b seeeduino_xiao_ble \
        -- -DZMK_CONFIG=/workspaces/zmk-config/config -DSHIELD=roBa_L
    devcontainer exec --workspace-folder "$ZMK_PATH" west build -p -s app -d build/reset -b seeeduino_xiao_ble \
        -- -DZMK_CONFIG=/workspaces/zmk-config/config -DSHIELD=settings_reset
else
    devcontainer exec --workspace-folder "$ZMK_PATH" west build -s app -d build/right
    devcontainer exec --workspace-folder "$ZMK_PATH" west build -s app -d build/left
    devcontainer exec --workspace-folder "$ZMK_PATH" west build -s app -d build/reset
fi

# Copy firmware
OUTPUT_DIR="./build"
mkdir -p "$OUTPUT_DIR"
cp "$ZMK_PATH"/build/right/zephyr/zmk.uf2 "$OUTPUT_DIR"/roBa_R.uf2
cp "$ZMK_PATH"/build/left/zephyr/zmk.uf2 "$OUTPUT_DIR"/roBa_L.uf2
cp "$ZMK_PATH"/build/reset/zephyr/zmk.uf2 "$OUTPUT_DIR"/settings_reset.uf2

echo "Build has been completed."
