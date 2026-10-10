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
Features complex orchestration including supply chain attack prevention (dependency pinning, vulnerability scanning, provenance attestation), optional SBOM (Software Bill of Materials) artifact generation and signing, environment promotions, and automated rollbacks or manual approvals. Once automated acceptance tests pass in a prod-like environment, parallel post-deployment verification runs: manual exploratory testing, security vulnerability/penetration testing, and performance testing (load, spike, and soak with memory profiling).

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
    G --> H1[Automated Acceptance Tests]
    H1 --> H2[Manual Exploratory Testing]
    H1 --> H3[Security Vulnerability & Pen-Testing]
    H1 --> H4[Performance Testing: Load, Spike & Soak with Memory Profiling]
    end
    
    H2 & H3 & H4 --> I{Manual Approval}
    
    subgraph Production [Production: Blue/Green Option]
    I --> J[Deploy Green Environment]
    J --> K[Smoke & Health Checks on Green]
    K --> L[Switch Traffic Router to Green]
    end
    
    L --> M{Post-Cutover Health Check}
    M -- Fail --> N[Auto-Rollback: Switch Router to Blue]
    M -- Pass --> O[Decommission Old Blue / Idle]
```

#### Production Promotion Strategies

Depending on risk tolerance, architecture, and traffic profile, teams typically choose between Blue/Green cutover or progressive Canary promotions:

##### Strategy A: Blue/Green Deployment
- Spins up an identical target environment (Green) running the new version.
- Validates the deployment in isolation.
- Switches router/load balancer traffic instantly from Blue to Green.
- Rapid rollbacks are accomplished by instantly repointing the router back to Blue.

##### Strategy B: Canary Deployment (Progressive Delivery)
- Deploys the new revision alongside the current version to a small subset of infrastructure.
- Incrementally routes real traffic (e.g., 5% &rarr; 25% &rarr; 100%) while automated metric analysis (error rates, latency, APM telemetry) validates system health at each step.
- Automatically halts and rolls traffic back to 0% if error or latency thresholds are exceeded.

```mermaid
graph TD
    Approval((Manual Approval / Auto-Promote)) --> DeployCanary[Deploy Canary Pods / Instances]
    DeployCanary --> Step1[Route 5% Traffic to Canary]
    Step1 --> Check1{Metrics Analysis: Error Rate & Latency}

    Check1 -- Degraded --> Rollback1[Auto-Rollback: Route 0% to Canary]
    Check1 -- Healthy --> Step2[Promote: Route 25% - 50% Traffic]
    
    Step2 --> Check2{Metrics Analysis: Error Rate & Latency}

    Check2 -- Degraded --> Rollback2[Auto-Rollback: Route 0% to Canary]
    Check2 -- Healthy --> Step3[Promote: Route 100% Traffic]

    Step3 --> FinalHealth{Full Production Health Check}
    FinalHealth -- Degraded --> RollbackFull[Emergency Rollback / Fast Drain]
    FinalHealth -- Healthy --> Success((Promotion Complete))
```

## Provider Specific Implementations

*Links coming soon for:*
- GitHub Actions (GHA)
- Jenkins
- GitLab CI/CD
- ArgoCD
