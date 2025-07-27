#!/usr/bin/env bash
set -euo pipefail

# 1. Define variables
COREDNS_REPO="https://github.com/coredns/coredns.git"
PLUGIN_REPO="https://github.com/giorgio6846/CoreDNS-Plugin-Fastest.git"
WORKDIR="${PWD}/coredns"
PLUGIN_DIR="plugin/fastest"
PLUGIN_CFG="plugin.cfg"
BINARY_NAME="coredns-fastest"

# 2. Clone CoreDNS if not already present
if [ ! -d "$WORKDIR" ]; then
  echo "Cloning CoreDNS into $WORKDIR"
  git clone "$COREDNS_REPO" "$WORKDIR"
else
  echo "CoreDNS directory already exists; pulling latest changes"
  git -C "$WORKDIR" pull
fi

# 3. Clone (or update) the fastest plugin
if [ -d "$WORKDIR/$PLUGIN_DIR" ]; then
  echo "Updating existing fastest plugin"
  git -C "$WORKDIR/$PLUGIN_DIR" pull
else
  echo "Cloning fastest plugin into $PLUGIN_DIR"
  git clone "$PLUGIN_REPO" "$WORKDIR/$PLUGIN_DIR"
fi

cd "$WORKDIR"

# 4. Register the plugin in plugin.cfg (if not already present)
if ! grep -q "^fastest:" "$PLUGIN_CFG"; then
  echo "Registering fastest plugin in $PLUGIN_CFG"
  # Use awk for cross‑platform in‑place insertion.
  awk '/^forward:/ {
      print
      print "fastest:github.com/giorgio6846/CoreDNS-Plugin-Fastest"
      next
    }
    { print }
  ' "$PLUGIN_CFG" > "${PLUGIN_CFG}.new" \
    && mv "${PLUGIN_CFG}.new" "$PLUGIN_CFG"
else
  echo "fastest plugin already registered."
fi

# 4.1 Fetch the fastest module so go.mod knows about it
echo "Fetching fastest plugin module…"
go get github.com/giorgio6846/CoreDNS-Plugin-Fastest
go mod tidy


# 5. Generate and build
echo "Running go generate"
go generate

echo "Building custom CoreDNS binary"
go build -o "../$BINARY_NAME"

echo "✅ Build complete! Binary located at $(dirname "$WORKDIR")/$BINARY_NAME"
