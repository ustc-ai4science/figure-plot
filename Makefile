PYTHON ?= python3

.PHONY: test test-release

test:
	PYTHON_BIN=$(PYTHON) ./scripts/self-test.sh

test-release:
	PYTHON_BIN=$(PYTHON) ./scripts/release-test.sh
