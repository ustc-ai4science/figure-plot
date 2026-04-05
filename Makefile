PYTHON ?= python3

.PHONY: test test-release example install

test:
	PYTHON_BIN=$(PYTHON) ./scripts/self-test.sh

test-release:
	PYTHON_BIN=$(PYTHON) ./scripts/release-test.sh

example:
	PYTHON_BIN=$(PYTHON) ./examples/generate_comparison_bar.py

install:
	./scripts/install-skill.sh
