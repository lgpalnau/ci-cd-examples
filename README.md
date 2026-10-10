# CI/CD Examples

This repository contains conceptual and implementation examples of CI/CD deployment pipelines.

## Conceptual Pipeline Levels

These examples are provider-agnostic and focus on the workflow structure.

### 1. Basic (Sequential)
A simple linear pipeline suitable for small projects or early-stage development. Each step must succeed before the next begins. 
These ideally are running on CI/CD infra so there is no dependence on a single workstation to deploy changes. 

```mermaid
graph LR
    A[Lint] --> B[Test]
    B --> C[Build]
    C --> D[Deploy to Prod-like environment]
```

### 2. Medium (Parallel Testing & Pre-Commit Hygiene)
Introduces local pre-commit guardrails alongside parallel CI execution. The pre-commit phase targets only modified files to keep feedback instantaneous (auto-formatting, staged linting, type checks, and rapid unit tests).

```mermaid
graph LR
    subgraph Local [Pre-Commit Hook - Staged Files Only]
    PC1[Auto-Format] --> PC2[Staged Lint & Type Check] --> PC3[Fast Unit Tests - optional]
    end

    subgraph CI [Continuous Integration]
    A[Full Lint]
    B[Unit Tests - run in parrallel when volume warrants it]
    C[Integration Tests]
    end

    PC3 -. Commit .-> Trigger((Push))
    Trigger --> A
    Trigger --> B
    Trigger --> C

    A & B & C --> D[Build Artifact]
    D --> E[Deploy to Prod-like]
```

### 2.5 Medium+ (PR Automation & Review Bots)
Builds upon the Medium workflow by integrating automated PR review tooling. Triggers on pull requests to provide early feedback directly in review threads prior to merging.

```mermaid
graph TD
    PR((Pull Request Published/Updated)) --> LocalCI[CI Validation Matrix]
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
    ReviewPass -- Merge --> Deploy[Deploy to Prod-like]
```

### 3. Advanced (Enterprise Workflow & Supply Chain Security)
Features complex orchestration including supply chain attack prevention (dependency pinning, vulnerability scanning, provenance attestation), optional SBOM (Software Bill of Materials) artifact generation and signing, environment promotions, and automated rollbacks or manual approvals.

```mermaid
graph TD
    subgraph Quality & Security Gates
    A[Static Analysis]
    B[Dependency & SAST Scan]
    C[Unit & Integration Tests]
    end

    Start((Push)) --> A & B & C
    
    A & B & C --> D[Build & Package]

    subgraph Supply Chain Hardening [Supply Chain & Attestation]
    D --> E1[Generate SBOM]
    D --> E2[Sign Artifact & Attestation]
    end

    E1 & E2 --> F{Push to Secure Registry}
    
    subgraph Prod-like
    F --> G[Deploy to Prod-like]
    G --> H1[Smoke & Integration Tests]
    H1 --> H2[Manual Exploratory Testing]
    end
    
    H2 --> I{Manual Approval}
    
    subgraph Production
    I --> J[Blue/Green Deploy]
    J --> K[Post-Deploy Health Check]
    end
    
    K -- Fail --> L[Auto-Rollback]
    K -- Pass --> M((Done))
```

## Provider Specific Implementations

*Links coming soon for:*
- GitHub Actions (GHA)
- Jenkins
- GitLab CI/CD
- ArgoCD
