# Troubleshooting

## `ModuleNotFoundError`

Install the missing package first.
Typical commands:

- `pip install matplotlib seaborn pandas numpy`
- `pip install scipy`
- `pip install openpyxl`

If a required plotting dependency is missing, stop and report the install command instead of half-running the script.

## Font warnings or missing glyphs

If Arial or Helvetica is unavailable, fall back to `DejaVu Sans`.
For Chinese labels, `PingFang SC` may not exist on all machines; keep a fallback list.

Do not remove `pdf.fonttype = 42` just to silence warnings.

## PDF text looks outlined or submission checker complains

Confirm:

- `plt.rcParams["pdf.fonttype"] = 42`
- `plt.rcParams["ps.fonttype"] = 42`

Then regenerate the vector export.

## Seaborn style conflicts with Matplotlib rc

If seaborn overwrites the style too aggressively, set rc after importing seaborn or use explicit axes-level configuration.

## Heatmap labels overlap

Try one or more of:

- increase figure width / height
- reduce annotation fontsize
- round to fewer decimals
- disable `annot=True`

## Bar chart looks crowded

Try one or more of:

- reduce the number of methods in one panel
- widen the figure slightly
- move the legend above the plot
- shorten tick labels

## Training curve is noisy

Only smooth if the user agrees or if the paper convention clearly supports it.
If you smooth, disclose it in the caption or report.

## Axis range hides the story

For endpoint comparisons, a truncated y-axis can be acceptable only if it is honest and clearly labeled.
If there is any risk of visual exaggeration, prefer a zero baseline or explain the truncation.

## PNG looks fine but PDF is broken

Check:

- font embedding settings
- unsupported transparency patterns
- whether text was accidentally converted into paths by downstream tooling

Regenerate with a simpler export path if needed.
