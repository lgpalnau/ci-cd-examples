from fastapi import FastAPI

app = FastAPI(title="Entry Tier FastAPI CI/CD Example")


@app.get("/")
def read_root() -> dict[str, str]:
    return {"message": "Hello from Entry Tier CI/CD FastAPI!"}


@app.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "healthy"}
