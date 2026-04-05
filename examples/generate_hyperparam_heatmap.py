#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path

cache_root = Path(os.environ.get("FIGURE_PLOT_CACHE_DIR", Path(__file__).resolve().parent / ".cache"))
os.environ.setdefault("MPLBACKEND", "Agg")
os.environ.setdefault("MPLCONFIGDIR", str(cache_root / "mplconfig"))
os.environ.setdefault("XDG_CACHE_HOME", str(cache_root / "xdg-cache"))
Path(os.environ["MPLCONFIGDIR"]).mkdir(parents=True, exist_ok=True)
Path(os.environ["XDG_CACHE_HOME"]).mkdir(parents=True, exist_ok=True)

import matplotlib.pyplot as plt
import matplotlib.patches as patches
import pandas as pd
import seaborn as sns


def main() -> int:
    repo_root = Path(__file__).resolve().parent.parent
    example_dir = repo_root / "examples"
    output_dir = example_dir / "output"
    output_dir.mkdir(parents=True, exist_ok=True)

    csv_path = example_dir / "heatmap_results.csv"
    df = pd.read_csv(csv_path)
    pivot = df.pivot(index="lr", columns="wd", values="score")

    plt.rcParams.update(
        {
            "font.family": "sans-serif",
            "font.sans-serif": ["Arial", "DejaVu Sans", "Helvetica"],
            "font.size": 9,
            "axes.labelsize": 9,
            "xtick.labelsize": 8,
            "ytick.labelsize": 8,
            "axes.linewidth": 0.8,
            "axes.facecolor": "white",
            "figure.facecolor": "white",
            "pdf.fonttype": 42,
            "ps.fonttype": 42,
            "savefig.dpi": 300,
        }
    )

    fig, ax = plt.subplots(figsize=(3.2, 2.8))
    sns.heatmap(pivot, annot=True, fmt=".1f", cmap="YlGnBu", cbar_kws={"shrink": 0.9}, ax=ax)
    best_idx = df["score"].idxmax()
    best = df.loc[best_idx]
    row = list(pivot.index).index(best["lr"])
    col = list(pivot.columns).index(best["wd"])
    rect = patches.Rectangle((col, row), 1, 1, fill=False, edgecolor="#C05F5F", linewidth=2.0)
    ax.add_patch(rect)
    ax.set_xlabel("Weight Decay")
    ax.set_ylabel("Learning Rate")
    fig.tight_layout(pad=0.4)

    png_path = output_dir / "hyperparam_heatmap_example.png"
    pdf_path = output_dir / "hyperparam_heatmap_example.pdf"
    fig.savefig(pdf_path, bbox_inches="tight")
    fig.savefig(png_path, bbox_inches="tight")

    print(f"csv={csv_path}")
    print(f"png={png_path}")
    print(f"pdf={pdf_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
