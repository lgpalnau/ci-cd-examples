# --- Stage 1: Builder & Dependency Installation ---
# Pin official astral-sh/uv image for reproducible BuildKit integration
FROM ghcr.io/astral-sh/uv:0.5.15 AS uv-bin
FROM python:3.15-slim AS builder

# Copy uv binary from official astral-sh/uv image
COPY --from=uv-bin /uv /uvx /bin/

WORKDIR /app

# Enable bytecode compilation and disable installer downloads
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV UV_PROJECT_ENVIRONMENT=/app

# Install dependencies using pyproject.toml and uv.lock with BuildKit caching
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    uv sync --frozen --no-dev --no-editable --no-install-project

# Install Python project as bytecode for faster container startups
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=backend,target=app
    uv pip sync --frozen --no-dev --no-editable


# --- Stage 2: Runtime (Security Hardened) ---
FROM python:3.15-slim AS runtime

# Security best practice: Create and use a non-root system user
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

# Copy python application files from builder
COPY --from=builder /app /app

# Secure file permissions
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

# Production health check for container reliability and monitoring
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
