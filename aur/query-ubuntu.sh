#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <software_name> <file_path>"
  exit 1
fi

file_path=$1
software_name=$2

# Search in the package list file
grep -P "^$software_name:" "$file_path" 2>/dev/null || echo "Package not found in list file"

echo "=== APT Package Info ==="
# Try to get info from apt
if dpkg -l | grep -q "^ii.*$software_name"; then
    echo "Package installed via APT:"
    apt show "$software_name" 2>/dev/null || echo "No apt info available"
fi

echo "=== Snap Package Info ==="
# Try to get info from snap
if snap list 2>/dev/null | grep -q "$software_name"; then
    echo "Package installed via Snap:"
    snap info "$software_name" 2>/dev/null || echo "No snap info available"
fi

echo "=== Flatpak Package Info ==="
# Try to get info from flatpak
if flatpak list 2>/dev/null | grep -q "$software_name"; then
    echo "Package installed via Flatpak:"
    flatpak info "$software_name" 2>/dev/null || echo "No flatpak info available"
fi