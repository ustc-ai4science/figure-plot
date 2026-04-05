PYTHON ?= python3

.PHONY: test test-release example example-all example-comparison example-training example-ablation example-heatmap install

test:
	PYTHON_BIN=$(PYTHON) ./scripts/self-test.sh

test-release:
	PYTHON_BIN=$(PYTHON) ./scripts/release-test.sh

example: example-comparison example-training

example-all: example-comparison example-training example-ablation example-heatmap

example-comparison:
	PYTHON_BIN=$(PYTHON) ./examples/generate_comparison_bar.py

example-training:
	PYTHON_BIN=$(PYTHON) ./examples/generate_training_curve.py

example-ablation:
	PYTHON_BIN=$(PYTHON) ./examples/generate_ablation_bar.py

example-heatmap:
	PYTHON_BIN=$(PYTHON) ./examples/generate_hyperparam_heatmap.py

install:
	./scripts/install-skill.sh
