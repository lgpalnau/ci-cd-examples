# Default recipe to list available recipes
default:
    @just --list

# Run all CI checks
ci: format-check lint typecheck test

# Check code formatting with Ruff
format-check:
    cd backend && uv run ruff format --check .

# Format code with Ruff
format:
    cd backend && uv run ruff format .

# Run Ruff linter
lint:
    cd backend && uv run ruff check .

# Run type checks with ty
typecheck:
    cd backend && uv run ty check

# Run pytest unit tests
test:
    cd backend && uv run pytest
