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

### 2. Medium (Parallel Testing & Pre-Commit Hygiene)
Introduces local pre-commit guardrails alongside parallel CI execution. The pre-commit phase targets only modified files to keep feedback instantaneous (auto-formatting, staged linting, type checks, and rapid unit tests).

```mermaid
graph LR
    subgraph Local [Pre-Commit Hook - Staged Files Only]
    PC1[Auto-Format] --> PC2[Staged Lint & Type Check] --> PC3[Fast Unit Tests]
    end

    subgraph CI [Continuous Integration]
    A[Full Lint]
    B[Unit Tests]
    C[Integration Tests]
    end

    PC3 -. Push .-> Trigger((Commit))
    Trigger --> A
    Trigger --> B
    Trigger --> C

    A & B & C --> D[Build Artifact]
    D --> E[Deploy to Staging]
```

### 2.5 Medium+ (PR Automation & Review Bots)
Builds upon the Medium workflow by integrating automated PR review tooling. Triggers on pull requests to provide early feedback directly in review threads prior to merging.

```mermaid
graph TD
    PR((Pull Request Opened/Updated)) --> LocalCI[CI Validation Matrix]
    PR --> BotReview[Automated PR Review]

    subgraph BotReview [PR Bots & Review Automation]
    R1[AI / Bot Code Review]
    R2[Coverage & Bundle Diff Comments]
    R3[Dependency & Secret Scan]
    end

    subgraph LocalCI [PR CI Checks]
    C1[Lint & Type Check]
    C2[Unit & Integration Tests]
    C3[Build Check]
    end

    LocalCI & BotReview --> ReviewPass{Checks & Bot Approvals}
    ReviewPass -- Merge --> Deploy[Deploy to Staging]
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
