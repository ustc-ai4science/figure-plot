#!/usr/bin/env bash
set -euo pipefail

python_bin="${PYTHON_BIN:-python3}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

export MPLCONFIGDIR="$tmp_dir/.mplconfig"
export XDG_CACHE_HOME="$tmp_dir/.cache"
export MPLBACKEND="${MPLBACKEND:-Agg}"
mkdir -p "$MPLCONFIGDIR" "$XDG_CACHE_HOME"

if ! command -v "$python_bin" >/dev/null 2>&1; then
  echo "[figure-plot] missing required dependency: python3"
  echo "Install or expose python3, then rerun."
  exit 1
fi

"$python_bin" - <<'PY'
import importlib
import sys

required = {
    "matplotlib": "pip install matplotlib",
    "seaborn": "pip install seaborn",
    "pandas": "pip install pandas",
    "numpy": "pip install numpy",
}
recommended = {
    "scipy": "pip install scipy",
    "openpyxl": "pip install openpyxl",
}

missing_required = []
missing_recommended = []

for name, install_cmd in required.items():
    try:
        importlib.import_module(name)
    except Exception:
        missing_required.append((name, install_cmd))

for name, install_cmd in recommended.items():
    try:
        importlib.import_module(name)
    except Exception:
        missing_recommended.append((name, install_cmd))

if missing_required:
    print("[figure-plot] missing required plotting dependencies:")
    for name, install_cmd in missing_required:
        print(f"  - {name}: {install_cmd}")
    sys.exit(1)

print("[figure-plot] required dependencies: OK")
if missing_recommended:
    print("[figure-plot] missing recommended dependencies:")
    for name, install_cmd in missing_recommended:
        print(f"  - {name}: {install_cmd}")
else:
    print("[figure-plot] recommended dependencies: OK")
PY
