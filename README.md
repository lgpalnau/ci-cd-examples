# CI/CD Examples

This repository contains conceptual and implementation examples of CI/CD deployment pipelines.

## Conceptual Pipeline Levels

These examples are provider-agnostic and focus on the workflow structure.

### 1. Basic (Sequential)
A simple linear pipeline suitable for small projects or early-stage development. Each step must succeed before the next begins.

```mermaid
graph LR
    A[Lint] --> B[Test]
    B --> C[Build]
    C --> D[Deploy to Staging]
```

### 2. Medium (Parallel Testing)
Introduces parallelism to speed up the feedback loop. Tests and linting run concurrently.

```mermaid
graph LR
    subgraph CI [Continuous Integration]
    A[Lint]
    B[Unit Tests]
    C[Integration Tests]
    end
    
    Trigger((Commit)) --> A
    Trigger --> B
    Trigger --> C
    
    A & B & C --> D[Build Artifact]
    D --> E[Deploy to Staging]
```

### 3. Advanced (Enterprise Workflow)
Features complex orchestration including security scanning, environment promotions, and automated rollbacks or manual approvals.

```mermaid
graph TD
    subgraph Quality Gates
    A[Static Analysis]
    B[Security Scan]
    C[Unit Tests]
    end

    Start((Push)) --> A & B & C
    
    A & B & C --> D{Build & Registry}
    
    subgraph Staging
    D --> E[Deploy]
    E --> F[Smoke Tests]
    end
    
    F --> G{Manual Approval}
    
    subgraph Production
    G --> H[Blue/Green Deploy]
    H --> I[Post-Deploy Health Check]
    end
    
    I -- Fail --> J[Auto-Rollback]
    I -- Pass --> K((Done))
```

## Provider Specific Implementations

*Links coming soon for:*
- GitHub Actions (GHA)
- Jenkins
- GitLab CI/CD
- ArgoCD
