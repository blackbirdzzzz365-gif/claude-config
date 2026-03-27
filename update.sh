#!/bin/bash
cd "$(dirname "$0")"
git pull
echo "✅ Config updated. Symlinks apply automatically."
