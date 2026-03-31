.PHONY: tests test-nopar

all: help

tests: ## Run all tests (parallel)
	bash tests/run.sh

tests-nopar: ## Run all tests (single-threaded)
	bash tests/run.sh --no-parallel

test: tests

test-nopar: tests-nopar

help: ## Show this help
	@printf "Usage:\033[36m make [target]\033[0m\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
