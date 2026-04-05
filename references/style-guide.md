# Style Guide

## Academic RC block

Start most scripts from this rc block:

```python
ACADEMIC_RC = {
    "font.family": "sans-serif",
    "font.sans-serif": ["Arial", "DejaVu Sans", "Helvetica", "PingFang SC"],
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
plt.rcParams.update(ACADEMIC_RC)
```

## Default palette

Prefer restrained, paper-safe colors.
Start from these muted colors:

- `#4C6A92`
- `#7A8F63`
- `#B5875A`
- `#8B6F8E`
- `#C05F5F`
- `#6F7C85`

Rules:

- main method gets the clearest muted color
- baselines should be slightly more neutral
- avoid neon blue, neon green, pure red, and jet-like palettes

## Figure sizes

Use explicit figure sizes in inches.

- single-column NeurIPS / ICML / ICLR: around `3.5 in`
- double-column NeurIPS / ICML / ICLR: around `7.0 in`
- single-column IEEE / CVPR: around `3.5 in`
- double-column IEEE / CVPR: around `7.16 in`
- arXiv preprint: `4.0 in` single-column, `8.0 in` wide figure

Common defaults:

- small endpoint comparison: `3.5 x 2.4 in`
- compact bar chart: `3.5 x 2.5 in`
- training curve: `3.5 x 2.4 in`
- wide multi-series figure: `7.0 x 2.8 in`

## Axis and annotation rules

- always label the y-axis unless the quantity is trivially obvious
- include units in labels whenever possible
- keep decimal precision modest
- use concise tick labels
- rotate x labels only when necessary
- avoid excessive text annotations unless they materially help the claim

## Export rules

- export both `pdf` and `png`
- use `bbox_inches="tight"`
- for paper figures, prefer vector output as the canonical artifact
- inspect the `png` preview after rendering

## Font and submission notes

`pdf.fonttype = 42` and `ps.fonttype = 42` are mandatory defaults for camera-ready safety.

If the environment lacks the preferred fonts, fall back gracefully instead of failing.
The figure should remain readable with `DejaVu Sans`.
