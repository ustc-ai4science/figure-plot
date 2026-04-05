# Data Patterns

Use these small pandas patterns to normalize experiment tables before plotting.

## Wide table to long table

When metrics are stored as columns and you need seaborn-style plotting:

```python
long_df = df.melt(
    id_vars=["Method"],
    value_vars=["ACC", "F1", "AUC"],
    var_name="Metric",
    value_name="Score",
)
```

## Pivot for heatmap

```python
pivot_df = df.pivot(index="lr", columns="wd", values="score")
```

## Group mean and standard deviation

```python
summary = (
    df.groupby(["Method", "Dataset"], as_index=False)
      .agg(mean_score=("Score", "mean"), std_score=("Score", "std"))
)
```

## Sort by narrative order

Do not rely on alphabetical order when the paper story has a preferred sequence:

```python
order = ["Baseline", "Baseline+Aug", "Ours"]
df["Method"] = pd.Categorical(df["Method"], categories=order, ordered=True)
df = df.sort_values("Method")
```

## Build dataframe from inline values

```python
df = pd.DataFrame(
    {
        "Method": ["Ours", "Baseline-A", "Baseline-B"],
        "Accuracy": [87.3, 83.1, 81.5],
    }
)
```

## Repeated runs for box plot

Keep one row per run:

```python
df = pd.DataFrame(
    {
        "Method": ["Ours"] * 5 + ["Baseline"] * 5,
        "Score": [87.2, 87.4, 87.1, 87.5, 87.3, 84.0, 84.2, 83.8, 84.1, 84.0],
    }
)
```

## Training curves from step logs

```python
curve_df = (
    df.groupby(["Method", "Step"], as_index=False)
      .agg(mean_metric=("Metric", "mean"), std_metric=("Metric", "std"))
)
```

Then plot one line per method and, if useful, one error band from `mean ± std`.
