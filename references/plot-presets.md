# Plot Presets

Use these as defaults after selecting the chart family.
Adjust only when the data or venue clearly requires it.

## `comparison-bar`

Use for a small number of methods across datasets or tasks.

- chart: grouped bar
- figsize: `3.5 x 2.5 in` single-column, `7.0 x 3.0 in` double-column
- y label: metric name with unit, for example `Accuracy (%)`
- legend: top-right if compact; otherwise above plot
- bar width: `0.16 - 0.22`
- error bars: show when mean/std or mean/sem exists
- dominant method: place first and give the strongest muted color

Suggested skeleton:

```python
fig, ax = plt.subplots(figsize=(3.5, 2.5))
x = np.arange(len(groups))
n = len(series)
w = 0.18
offsets = np.linspace(-(n - 1) / 2, (n - 1) / 2, n) * w
for i, (name, off) in enumerate(zip(series_names, offsets)):
    ax.bar(
        x + off,
        values[:, i],
        width=w * 0.92,
        label=name,
        color=colors[i],
        yerr=errors[:, i] if errors is not None else None,
        error_kw=dict(elinewidth=0.8, capsize=2, capthick=0.8),
        zorder=3,
    )
```

## `ablation-bar`

Use for ablation variants or component drop studies.

- chart: grouped or simple bar
- figsize: `3.5 x 2.4 in`
- sort variants by narrative order, not alphabetically
- highlight the full model or preferred variant
- keep variants under about `6` if possible

When a single metric is the story, direct value annotations may help.

## `training-curve`

Use for metrics over epoch, step, or compute budget.

- chart: line plot
- figsize: `3.5 x 2.4 in` or `7.0 x 2.8 in`
- line width: `1.8 - 2.2`
- marker: optional, sparse only
- uncertainty: prefer `fill_between` for bands
- x formatting: convert large step counts to `k`
- smoothing: only if explicitly justified; never hide raw trend dishonestly

Suggested skeleton:

```python
fig, ax = plt.subplots(figsize=(3.5, 2.4))
for name, y in curves.items():
    ax.plot(x, y, label=name, linewidth=2.0)
    if name in lower and name in upper:
        ax.fill_between(x, lower[name], upper[name], alpha=0.18)
```

## `hyperparam-heatmap`

Use for `param x param x score`.

- chart: seaborn heatmap
- figsize: `3.2 x 2.8 in` or slightly larger if labels are long
- `annot=True` only when the grid is small enough
- format: usually `.2f`
- colormap: muted sequential or diverging palette
- mark the best cell with a thin rectangle or annotation

Suggested skeleton:

```python
sns.heatmap(
    pivot_df,
    annot=True,
    fmt=".2f",
    cmap="RdYlGn",
    cbar_kws={"shrink": 0.9},
    ax=ax,
)
```

## `box-runs`

Use for repeated runs, stability, or spread.

- chart: box plot with light jitter overlay
- figsize: `3.5 x 2.5 in`
- pair `sns.boxplot` with `sns.stripplot`
- use a small jitter such as `0.12 - 0.18`
- keep outliers visible unless they are clearly artifacts

Suggested skeleton:

```python
sns.boxplot(data=df, x="Method", y="Score", ax=ax, width=0.55, showfliers=False)
sns.stripplot(data=df, x="Method", y="Score", ax=ax, color="#6b7280", jitter=0.15, size=3, alpha=0.75)
```

## `scatter-tradeoff`

Use for two-metric tradeoffs such as performance vs latency or accuracy vs memory.

- chart: scatter
- figsize: `3.5 x 2.5 in`
- annotate each method directly if there are only a few points
- avoid legends when labels near points are clearer
- if one method is the focus, emphasize it with size or darker color

Suggested skeleton:

```python
for _, row in df.iterrows():
    ax.scatter(row["x"], row["y"], s=40, color=row["color"])
    ax.text(row["x"], row["y"], row["label"], fontsize=8, ha="left", va="bottom")
```
