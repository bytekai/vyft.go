#!/bin/bash

set -e

REPO="vyftlabs/vyft"
BINARY_NAME="vyft"
INSTALL_DIR="/usr/local/bin"
USER_INSTALL_DIR="$HOME/.local/bin"

VERSION="${VYFT_VERSION:-latest}"

detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux" ;;
        Darwin*)    echo "darwin" ;;
        *)          echo "unsupported" ;;
    esac
}

detect_arch() {
    case "$(uname -m)" in
        x86_64|amd64)   echo "amd64" ;;
        aarch64|arm64) echo "arm64" ;;
        *)              echo "unsupported" ;;
    esac
}

get_latest_version() {
    curl -s "https://api.github.com/repos/${REPO}/releases/latest" | \
        grep '"tag_name":' | \
        sed -E 's/.*"([^"]+)".*/\1/'
}

download_binary() {
    local os=$1
    local arch=$2
    local version=$3
    local url
    
    if [ "$version" = "latest" ]; then
        version=$(get_latest_version)
    fi
    
    if [ "$os" = "linux" ]; then
        url="https://github.com/${REPO}/releases/download/${version}/vyft-${os}-${arch}"
    elif [ "$os" = "darwin" ]; then
        url="https://github.com/${REPO}/releases/download/${version}/vyft-${os}-${arch}"
    else
        echo "Unsupported OS: $os"
        exit 1
    fi
    
    echo "Downloading ${BINARY_NAME} ${version} for ${os}/${arch}..."
    curl -fsSL "$url" -o "/tmp/${BINARY_NAME}"
    chmod +x "/tmp/${BINARY_NAME}"
}

install_binary() {
    local target_dir=$1
    
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
    fi
    
    mv "/tmp/${BINARY_NAME}" "${target_dir}/${BINARY_NAME}"
    echo "Installed ${BINARY_NAME} to ${target_dir}/${BINARY_NAME}"
    
    if [[ ":$PATH:" != *":${target_dir}:"* ]]; then
        echo ""
        echo "Warning: ${target_dir} is not in your PATH."
        echo "Add it to your PATH by adding this line to your shell profile:"
        echo "  export PATH=\"\${PATH}:${target_dir}\""
    fi
}

main() {
    local os=$(detect_os)
    local arch=$(detect_arch)
    
    if [ "$os" = "unsupported" ] || [ "$arch" = "unsupported" ]; then
        echo "Error: Unsupported platform ${os}/${arch}"
        exit 1
    fi
    
    download_binary "$os" "$arch" "$VERSION"
    
    if command -v sudo >/dev/null 2>&1 && [ -w "$INSTALL_DIR" ] || sudo -n true 2>/dev/null; then
        if [ -w "$INSTALL_DIR" ]; then
            install_binary "$INSTALL_DIR"
        else
            echo "Installing to ${INSTALL_DIR} (requires sudo)..."
            sudo mv "/tmp/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
            sudo chmod +x "${INSTALL_DIR}/${BINARY_NAME}"
            echo "Installed ${BINARY_NAME} to ${INSTALL_DIR}/${BINARY_NAME}"
        fi
    else
        echo "Installing to ${USER_INSTALL_DIR}..."
        install_binary "$USER_INSTALL_DIR"
    fi
    
    echo ""
    echo "Success! Run '${BINARY_NAME} --version' to verify installation."
}

main "$@"

