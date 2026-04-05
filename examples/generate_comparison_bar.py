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
import numpy as np
import pandas as pd


def main() -> int:
    repo_root = Path(__file__).resolve().parent.parent
    example_dir = repo_root / "examples"
    output_dir = example_dir / "output"
    output_dir.mkdir(parents=True, exist_ok=True)

    csv_path = example_dir / "comparison_results.csv"
    df = pd.read_csv(csv_path)

    plt.rcParams.update(
        {
            "font.family": "sans-serif",
            "font.sans-serif": ["Arial", "DejaVu Sans", "Helvetica"],
            "font.size": 9,
            "axes.labelsize": 9,
            "xtick.labelsize": 8,
            "ytick.labelsize": 8,
            "legend.fontsize": 8,
            "lines.linewidth": 1.8,
            "axes.linewidth": 0.8,
            "axes.facecolor": "white",
            "figure.facecolor": "white",
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

    methods = ["Ours", "BaselineA", "BaselineB"]
    datasets = df["Dataset"].tolist()
    values = df[methods].to_numpy()
    colors = ["#4C6A92", "#7A8F63", "#B5875A"]

    fig, ax = plt.subplots(figsize=(3.5, 2.5))
    x = np.arange(len(datasets))
    width = 0.22
    offsets = np.linspace(-(len(methods) - 1) / 2, (len(methods) - 1) / 2, len(methods)) * width

    for i, (name, off) in enumerate(zip(methods, offsets)):
        ax.bar(x + off, values[:, i], width=width * 0.92, label=name, color=colors[i], zorder=3)

    ax.set_xticks(x)
    ax.set_xticklabels(datasets)
    ax.set_ylabel("Accuracy (%)")
    ax.set_ylim(bottom=70)
    ax.legend(loc="upper right", framealpha=0.9)
    fig.tight_layout(pad=0.4)

    png_path = output_dir / "comparison_bar_example.png"
    pdf_path = output_dir / "comparison_bar_example.pdf"
    fig.savefig(pdf_path, bbox_inches="tight")
    fig.savefig(png_path, bbox_inches="tight")

    print(f"csv={csv_path}")
    print(f"png={png_path}")
    print(f"pdf={pdf_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
