#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
skill_root="$(cd "$script_dir/.." && pwd)"
python_bin="${PYTHON_BIN:-python3}"

"$script_dir/check-deps.sh"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

export MPLCONFIGDIR="$tmp_dir/.mplconfig"
export XDG_CACHE_HOME="$tmp_dir/.cache"
export MPLBACKEND="${MPLBACKEND:-Agg}"
mkdir -p "$MPLCONFIGDIR" "$XDG_CACHE_HOME"

SKILL_TMP="$tmp_dir" "$python_bin" - <<'PY'
import os
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np

out_dir = Path(os.environ["SKILL_TMP"])
plt.rcParams.update(
    {
        "font.family": "sans-serif",
        "font.sans-serif": ["Arial", "DejaVu Sans", "Helvetica"],
        "font.size": 9,
        "axes.labelsize": 9,
        "xtick.labelsize": 8,
        "ytick.labelsize": 8,
        "legend.fontsize": 8,
        "axes.grid": True,
        "axes.grid.axis": "y",
        "axes.spines.top": False,
        "axes.spines.right": False,
        "pdf.fonttype": 42,
        "ps.fonttype": 42,
        "savefig.dpi": 300,
    }
)

labels = ["A", "B", "C"]
values = np.array([88.2, 85.6, 83.4])
fig, ax = plt.subplots(figsize=(3.5, 2.4))
ax.bar(labels, values, color=["#4C6A92", "#7A8F63", "#B5875A"], zorder=3)
ax.set_ylabel("Accuracy (%)")
ax.set_ylim(80, 90)
fig.tight_layout(pad=0.4)
fig.savefig(out_dir / "self_test_bar.pdf", bbox_inches="tight")
fig.savefig(out_dir / "self_test_bar.png", bbox_inches="tight")
print(out_dir / "self_test_bar.pdf")
print(out_dir / "self_test_bar.png")
PY

test -s "$tmp_dir/self_test_bar.pdf"
test -s "$tmp_dir/self_test_bar.png"
echo "[figure-plot] self-test passed"
