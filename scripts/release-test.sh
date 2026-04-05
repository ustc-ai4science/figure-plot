#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
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
import pandas as pd
import seaborn as sns

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
        "grid.color": "#e5e7eb",
        "grid.linewidth": 0.6,
        "axes.spines.top": False,
        "axes.spines.right": False,
        "pdf.fonttype": 42,
        "ps.fonttype": 42,
        "savefig.dpi": 300,
    }
)

colors = ["#4C6A92", "#7A8F63", "#B5875A", "#8B6F8E"]

def save(fig, stem):
    fig.tight_layout(pad=0.4)
    fig.savefig(out_dir / f"{stem}.pdf", bbox_inches="tight")
    fig.savefig(out_dir / f"{stem}.png", bbox_inches="tight")
    plt.close(fig)

# comparison-bar
fig, ax = plt.subplots(figsize=(3.5, 2.4))
x = np.arange(3)
vals = np.array([[88.1, 85.2, 84.5], [90.0, 87.3, 86.4], [79.5, 76.2, 74.9]])
w = 0.22
for i, name in enumerate(["Ours", "Base-A", "Base-B"]):
    ax.bar(x + (i - 1) * w, vals[:, i], width=w, label=name, color=colors[i], zorder=3)
ax.set_xticks(x)
ax.set_xticklabels(["D1", "D2", "D3"])
ax.set_ylabel("Accuracy (%)")
ax.legend(framealpha=0.9)
save(fig, "comparison_bar")

# ablation-bar
fig, ax = plt.subplots(figsize=(3.5, 2.4))
abl = pd.DataFrame({"Variant": ["Full", "-Memory", "-Search", "-Rerank"], "Score": [88.4, 86.9, 85.7, 84.8]})
sns.barplot(
    data=abl,
    x="Variant",
    y="Score",
    hue="Variant",
    palette=[colors[0], colors[1], colors[2], colors[3]],
    legend=False,
    ax=ax,
)
ax.set_ylabel("F1")
save(fig, "ablation_bar")

# training-curve
fig, ax = plt.subplots(figsize=(3.5, 2.4))
steps = np.arange(1, 11)
ax.plot(steps, np.linspace(70, 88, 10), label="Ours", color=colors[0], linewidth=2.0)
ax.plot(steps, np.linspace(68, 83, 10), label="Baseline", color=colors[1], linewidth=2.0)
ax.set_xlabel("Epoch")
ax.set_ylabel("Accuracy (%)")
ax.legend(framealpha=0.9)
save(fig, "training_curve")

# hyperparam-heatmap
fig, ax = plt.subplots(figsize=(3.2, 2.8))
heat = pd.DataFrame([[84.1, 85.0, 84.6], [85.4, 86.3, 85.8], [84.9, 85.7, 85.2]], index=[1e-4, 5e-4, 1e-3], columns=[0.0, 0.01, 0.1])
sns.heatmap(heat, annot=True, fmt=".1f", cmap="YlGnBu", ax=ax, cbar_kws={"shrink": 0.9})
ax.set_xlabel("Weight Decay")
ax.set_ylabel("Learning Rate")
save(fig, "hyperparam_heatmap")

# box-runs
fig, ax = plt.subplots(figsize=(3.5, 2.4))
box_df = pd.DataFrame(
    {
        "Method": ["Ours"] * 5 + ["Baseline"] * 5,
        "Score": [88.2, 88.4, 88.1, 88.5, 88.3, 84.3, 84.1, 84.5, 84.2, 84.0],
    }
)
sns.boxplot(data=box_df, x="Method", y="Score", ax=ax, width=0.55, showfliers=False)
sns.stripplot(data=box_df, x="Method", y="Score", ax=ax, color="#6F7C85", jitter=0.15, size=3, alpha=0.75)
save(fig, "box_runs")

# scatter-tradeoff
fig, ax = plt.subplots(figsize=(3.5, 2.4))
trade = pd.DataFrame(
    {
        "Method": ["Ours", "FastBase", "StrongBase"],
        "Latency": [12, 7, 18],
        "Accuracy": [88.6, 84.9, 87.4],
        "Color": [colors[0], colors[1], colors[2]],
    }
)
for _, row in trade.iterrows():
    ax.scatter(row["Latency"], row["Accuracy"], s=48, color=row["Color"])
    ax.text(row["Latency"], row["Accuracy"], row["Method"], fontsize=8, ha="left", va="bottom")
ax.set_xlabel("Latency (ms)")
ax.set_ylabel("Accuracy (%)")
save(fig, "scatter_tradeoff")

print(out_dir)
PY

for stem in comparison_bar ablation_bar training_curve hyperparam_heatmap box_runs scatter_tradeoff; do
  test -s "$tmp_dir/${stem}.pdf"
  test -s "$tmp_dir/${stem}.png"
done

echo "[figure-plot] release-test passed"
