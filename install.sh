#!/usr/bin/env zsh

echo "Do you want to install Nix Flakes? (y/n): "
read answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    arch=$(uname -m)
    echo "Detected architecture: $arch"

    case "$arch" in
        x86_64)
            echo "Installing NixOS Flakes for x86_64"
            ./nix/x86_64_installer.sh
            ;;
        aarch64|arm64)
            echo "Installing NixOS Flakes for ARM64"
            ./nix/ARM64_installer.sh
            ;;
        *)
            echo "Unsupported architecture: $arch"
            exit 1
            ;;
    esac
else
    echo "Not installing Nix Flakes."
fi


echo "Do you want to install the SketchyBar helpers? (y/n): "
read answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "Installing SketchyBar helpers"
    ./sketchybar/helpers.sh
else
    echo "Not installing SketchyBar."
fi
