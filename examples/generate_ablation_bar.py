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
import pandas as pd
import seaborn as sns


def main() -> int:
    repo_root = Path(__file__).resolve().parent.parent
    example_dir = repo_root / "examples"
    output_dir = example_dir / "output"
    output_dir.mkdir(parents=True, exist_ok=True)

    csv_path = example_dir / "ablation_results.csv"
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

    colors = ["#4C6A92", "#7A8F63", "#B5875A", "#8B6F8E"]
    fig, ax = plt.subplots(figsize=(3.5, 2.4))
    sns.barplot(data=df, x="Variant", y="Score", hue="Variant", palette=colors, legend=False, ax=ax)
    ax.set_ylabel("F1")
    fig.tight_layout(pad=0.4)

    png_path = output_dir / "ablation_bar_example.png"
    pdf_path = output_dir / "ablation_bar_example.pdf"
    fig.savefig(pdf_path, bbox_inches="tight")
    fig.savefig(png_path, bbox_inches="tight")

    print(f"csv={csv_path}")
    print(f"png={png_path}")
    print(f"pdf={pdf_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
