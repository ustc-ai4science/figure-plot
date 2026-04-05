# figure-plot

[English](./README.md) | [中文](./README_ZH.md)

`figure-plot` is a lightweight plotting skill for turning AI/ML experiment results into publication-quality static figures.

It is designed for agent workflows where the user provides:

- a `.csv`, `.xlsx`, or `.json` result file
- a pasted Markdown table or CSV block
- or a natural-language description of experiment results

The skill then guides the agent to:

1. inspect the data first
2. choose the correct chart family
3. generate a small deterministic plotting script
4. export both `PDF` and `PNG`
5. inspect the rendered figure and revise if needed

This project is intentionally optimized for academic paper figures, not for dashboards or interactive charting.

## What It Covers

The current version includes defaults and workflow guidance for six common research figure families:

- `comparison-bar`
- `ablation-bar`
- `training-curve`
- `hyperparam-heatmap`
- `box-runs`
- `scatter-tradeoff`

The style contract is academic and conservative by default:

- `matplotlib` + `seaborn`
- white background
- restrained palette
- vector-friendly export
- `pdf.fonttype = 42` and `ps.fonttype = 42`

## Repository Layout

```text
figure-plot/
├── SKILL.md
├── README.md
├── Makefile
├── .gitignore
├── references/
│   ├── plot-presets.md
│   ├── style-guide.md
│   ├── data-patterns.md
│   └── troubleshooting.md
└── scripts/
    ├── check-deps.sh
    ├── self-test.sh
    └── release-test.sh
```

## Core Files

- [SKILL.md](./SKILL.md): trigger description, workflow, plot selection logic, style contract, and review checklist
- [references/plot-presets.md](./references/plot-presets.md): chart-family defaults and code skeletons
- [references/style-guide.md](./references/style-guide.md): academic rc params, muted palette, paper sizing guidance
- [references/data-patterns.md](./references/data-patterns.md): common pandas reshape / aggregation patterns
- [references/troubleshooting.md](./references/troubleshooting.md): common matplotlib / seaborn issues and fixes

## Quick Start

### 1. Check dependencies

```bash
./scripts/check-deps.sh
```

Required packages:

- `matplotlib`
- `seaborn`
- `pandas`
- `numpy`

Recommended packages:

- `scipy`
- `openpyxl`

### 2. Run the smoke test

```bash
make test
```

### 3. Run the broader regression suite

```bash
make test-release
```

## Example User Requests

Typical requests that should trigger this skill:

- "Plot this ablation table as a paper-quality bar chart."
- "Turn this CSV into a comparison figure for NeurIPS."
- "Draw a training curve with error bands from these results."
- "Visualize the hyperparameter sensitivity heatmap."
- "Make a camera-ready figure from this results table."

## Usage Contract

The intended workflow is:

1. inspect the input data before plotting
2. ask one clarifying question if the chart type is ambiguous
3. choose the simplest chart that matches the claim
4. write explicit plotting code instead of relying on hidden defaults
5. export both `pdf` and `png`
6. inspect the `png` render before reporting completion

This project deliberately avoids:

- interactive plotting libraries by default
- decorative dashboards
- bright or neon palettes
- guessing chart types from vague prose

## Notes

- The test scripts force a headless-safe Matplotlib backend so they run cleanly on macOS and other non-GUI environments.
- The scripts also isolate Matplotlib cache directories to avoid writable-cache issues during automated runs.
- The repository currently focuses on the skill contract and validation scripts; it does not yet include packaging metadata such as marketplace UI descriptors.

## Development

Useful commands:

```bash
git status
make test
make test-release
```

If you modify chart defaults or export rules, rerun both test targets before pushing.
