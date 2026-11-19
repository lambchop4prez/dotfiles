#!/bin/sh
# Install chezmoi from a pinned GitHub release with checksum verification.
# The anti-`curl | sh`: you can read all 40 lines, the binary is verified,
# and it lands in this repo's .homebrew/bin/ without touching your system.
#
# To update: check https://github.com/twpayne/chezmoi/releases/latest,
# update CHEZMOI_VERSION and the checksum below from
# chezmoi_<ver>_checksums.txt (the darwin_arm64 line), run again.
set -eu

CHEZMOI_VERSION=2.74.0
CHECKSUM_darwin_arm64="9d89672a597a9333ab47ea5173fcececb85c04864205686a7aa5699c3d8bd98c"

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
bindir="$repo_dir/.homebrew/bin"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

os=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)
[ "$arch" = "arm64" ] || arch=$(uname -m)   # extend for x86_64: fill CHECKSUM from release
checksum_var="CHECKSUM_${os}_${arch}"
expected=$(eval "echo \${$checksum_var:-}")
[ -n "$expected" ] || { echo "no checksum for ${os}_${arch}" >&2; exit 1; }

tarball="chezmoi_${CHEZMOI_VERSION}_${os}_${arch}.tar.gz"
base="https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}"

echo "downloading $tarball ..."
curl -fsSL --proto '=https' -o "$tmp/$tarball" "$base/$tarball"
curl -fsSL --proto '=https' -o "$tmp/checksums.txt" "$base/chezmoi_${CHEZMOI_VERSION}_checksums.txt"

actual=$(shasum -a 256 "$tmp/$tarball" | cut -d' ' -f1)
[ "$actual" = "$expected" ] || { echo "CHECKSUM MISMATCH: $actual != $expected" >&2; exit 1; }
# cross-check against the release's own checksums file
grep "  ${tarball}\$" "$tmp/checksums.txt" | grep -q "^${actual} " || {
  echo "checksum not found in release checksums.txt" >&2; exit 1; }

tar -C "$tmp" -xzf "$tmp/$tarball" chezmoi
mkdir -p "$bindir"
mv "$tmp/chezmoi" "$bindir/chezmoi"
chmod 755 "$bindir/chezmoi"
echo "installed: $("$bindir/chezmoi" --version)"
echo "next: $bindir/chezmoi init --apply --source $repo_dir"
