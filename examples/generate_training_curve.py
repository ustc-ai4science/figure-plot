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


def main() -> int:
    repo_root = Path(__file__).resolve().parent.parent
    example_dir = repo_root / "examples"
    output_dir = example_dir / "output"
    output_dir.mkdir(parents=True, exist_ok=True)

    csv_path = example_dir / "training_curve_results.csv"
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
            "lines.linewidth": 2.0,
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

    fig, ax = plt.subplots(figsize=(3.5, 2.5))
    ax.plot(df["Epoch"], df["Ours_mean"], label="Ours", color="#4C6A92")
    ax.fill_between(df["Epoch"], df["Ours_low"], df["Ours_high"], color="#4C6A92", alpha=0.18)
    ax.plot(df["Epoch"], df["Baseline_mean"], label="Baseline", color="#7A8F63")
    ax.fill_between(df["Epoch"], df["Baseline_low"], df["Baseline_high"], color="#7A8F63", alpha=0.18)
    ax.set_xlabel("Epoch")
    ax.set_ylabel("Accuracy (%)")
    ax.set_xlim(1, 10)
    ax.legend(loc="lower right", framealpha=0.9)
    fig.tight_layout(pad=0.4)

    png_path = output_dir / "training_curve_example.png"
    pdf_path = output_dir / "training_curve_example.pdf"
    fig.savefig(pdf_path, bbox_inches="tight")
    fig.savefig(png_path, bbox_inches="tight")

    print(f"csv={csv_path}")
    print(f"png={png_path}")
    print(f"pdf={pdf_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
