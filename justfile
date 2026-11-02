# Default recipe to list available recipes
default:
    @just --list

# Run all CI checks
ci: format-check lint typecheck test

# Check code formatting with Ruff
[directory("backend")]
format-check:
    uv run ruff format --check .

# Format code with Ruff
[directory("backend")]
format:
    uv run ruff format .

# Run Ruff linter
[directory("backend")]
lint:
    uv run ruff check .

# Run type checks with ty
[directory("backend")]
typecheck:
    uv run ty check

# Run pytest unit tests
[directory("backend")]
test:
    uv run pytest
