set working-directory := 'backend'

# Default recipe to list available recipes
default:
    @just --list

# Run all CI checks
ci: format-check lint typecheck test

# Check code formatting with Ruff
format-check:
    uv run ruff format --check .

# Format code with Ruff
format:
    uv run ruff format .

# Run Ruff linter
lint:
    uv run ruff check .

# Run type checks with ty
typecheck:
    uv run ty check

# Run pytest unit tests
test:
    uv run pytest
