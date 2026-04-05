---
name: figure-plot
description: |
  Generate publication-quality AI/ML paper figures from CSV, inline tables, or clearly described experiment results.

  Trigger this skill when the user asks to plot, draw, visualize, or turn results into a figure, especially for:
  - ablations, method comparisons, training curves, hyperparameter sensitivity, stability plots, tradeoff plots
  - bar charts, line charts, heatmaps, box plots, scatter plots
  - NeurIPS / ICML / ICLR / CVPR / IEEE / camera-ready / publication-quality figures
  - pasted numeric markdown tables, CSV text, or file paths such as .csv / .xlsx / .json
---

# Figure Plot

Use this skill when the task is to turn experimental results into a paper-ready static figure.

This skill is for academic plotting, not dashboard building.
Prefer `matplotlib` + `seaborn`.
Do not switch to `plotly`, `bokeh`, or browser charting unless the user explicitly asks for an interactive figure.

## Core workflow

Follow this order:

1. run the preflight dependency check with `scripts/check-deps.sh`
2. understand the data structure and the claim the figure should communicate
3. choose one plot family using the matrix below
4. load or build a dataframe and inspect it before plotting
5. write a small deterministic plotting script
6. export both `pdf` and `png`
7. inspect the rendered `png`
8. revise specific parameters if readability is weak

If required dependencies are missing, stop after printing the install command.
Do not continue into plotting with a broken environment.

## Plotting philosophy

- understand first, then plot
- one figure should carry one dominant claim
- pick the simplest plot that faithfully answers the question
- use restrained academic styling by default
- prefer explicit sizes, labels, units, and export paths
- after rendering, inspect the figure itself instead of trusting the code

If the data structure or intended comparison is ambiguous, ask one compact clarifying question before plotting.
Do not guess the chart type from incomplete prose.

## Chart selection matrix

Choose the plot family from the question, not from habit:

- `comparison-bar`
  - use for `N methods x M datasets` endpoint comparisons
- `ablation-bar`
  - use for ablation studies with a small number of variants
- `training-curve`
  - use for metrics over epoch / step / budget
- `hyperparam-heatmap`
  - use for `param x param x score`
- `box-runs`
  - use for repeated-run stability or distribution questions
- `scatter-tradeoff`
  - use for two-metric tradeoffs such as quality vs latency

Open [references/plot-presets.md](./references/plot-presets.md) after you pick the plot family.

## Data intake

Support these three input paths.

### 1. File path

For `.csv`, `.xlsx`, or `.json`, load the file with pandas and inspect it first:

- print `head()`
- print `dtypes`
- confirm column names before writing plotting code

### 2. Inline table or CSV text

Convert the pasted content into a dataframe explicitly.
Do not write plotting code against unparsed raw text.

### 3. Natural-language description

If the user gives only prose, ask for the exact numbers in one turn.
Once the numbers are complete, construct a dataframe and continue as above.

If you need reshape or aggregation patterns, open [references/data-patterns.md](./references/data-patterns.md).

## Style contract

Every plotting script must define and apply an academic rc block before plotting.
Use the compact defaults from [references/style-guide.md](./references/style-guide.md).

Hard rules:

- white background
- restrained palette
- no neon colors
- no rainbow / jet colormap
- light y-grid only when it helps reading
- remove top and right spines unless the plot truly needs them
- embed fonts for vector export: `pdf.fonttype = 42`, `ps.fonttype = 42`
- save `pdf` and `png`
- use explicit `figsize` in inches based on likely venue layout

## Output contract

Each completed plotting pass must:

1. save both `pdf` and `png`
2. use a deterministic filename that contains the plot family
3. print the exact output paths
4. inspect the generated `png`
5. report what the figure shows in one or two sentences

Prefer names like:

- `comparison_bar.pdf`
- `comparison_bar.png`
- `training_curve.pdf`
- `training_curve.png`

If the user already has a file naming convention, follow that instead.

## Iteration rules

When the first render is weak, revise narrowly.
Change the minimum necessary parameter set, for example:

- figure size
- y-axis range
- tick density
- legend placement
- line width / marker size
- bar width
- annotation size
- color ordering

Do not rewrite the full plotting script unless the original chart type was wrong.

## Self-review checklist

Before calling the figure complete, check:

- is the main claim obvious within a few seconds
- are labels, units, and legend readable
- do any labels overlap
- is text still readable after likely paper down-scaling
- is the method hierarchy visually clear
- are grid lines too heavy
- are colors restrained and distinguishable
- is the vector export suitable for paper submission

If any answer is no, revise once before reporting completion.

## References

Open references only as needed:

- chart defaults and code skeletons: [references/plot-presets.md](./references/plot-presets.md)
- rc params, palette, venue sizing: [references/style-guide.md](./references/style-guide.md)
- dataframe reshape and aggregation patterns: [references/data-patterns.md](./references/data-patterns.md)
- common matplotlib / seaborn failures: [references/troubleshooting.md](./references/troubleshooting.md)

## Validation scripts

Use:

- `scripts/check-deps.sh` for environment readiness
- `scripts/self-test.sh` for a quick smoke test
- `scripts/release-test.sh` for the broader regression set
