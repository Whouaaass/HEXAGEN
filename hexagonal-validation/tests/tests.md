# HEXAGEN Metrics Evaluation

Automated quality evaluation framework for HEXAGEN-generated Spring Boot models using Epsilon EVL/EOL.

## Overview

Four metrics evaluate the quality of generated SMM (Spring Boot Metamodel) instances against the source HMM (Hexagonal Metamodel) architecture:

| Metric | File | Type | Evaluates |
|---|---|---|---|
| [SC](#1-syntactic-correctness-scevl) | `sc.evl` | EVL | Well-formedness of SMM model instance |
| [AF](#2-architectural-fidelity-afeol) | `af.eol` | EOL | Correspondence between HMM architecture and generated SMM code |
| [FC](#3-functional-completeness-fceol) | `fc.eol` | EOL | Element count ratio (generated / expected) |
| [SM](#4-structural-maintainability-smevl) | `sm.evl` | EVL | Orphan elements, broken references, duplicated structures |
| [All](#5-aggregate-report-evaluate-alleol) | `evaluate-all.eol` | EOL | Combined report of all 4 metrics |

## Prerequisites

- Eclipse Modeling Tools 2023-12+
- Epsilon 2.5+ (EVL, EOL)
- SMM and HMM metamodels (in `models/`)
- SMM model instance to evaluate (e.g., `LibraryLoanSystem-smm-pure.xmi`)
- HMM model instance to compare against (e.g., `LibraryLoanSystem.xmi`)

---

## SMM Metamodel Reference

All metrics validate against this SMM structure (`models/smm.ecore`, nsURI: `smm`):

```
Application
 ├── name : String
 ├── basePackage : String
 ├── javaVersion : String
 ├── serverPort : String
 └── modules : Module[]
       ├── name : String
       ├── entities : Entity[]          (extends JavaClass, has idType)
       ├── valueObjects : ValueObject[] (extends JavaClass)
       ├── repositories : Repository[]  (has entityType, idType, methods)
       ├── services : Service[]         (extends JavaClass, has requiredRepositories)
       ├── controllers : Controller[]   (extends JavaClass, has basePath, service, endpoints)
       └── dtos : Dto[]                 (extends JavaClass)

JavaClass (abstract)
 ├── name : String
 ├── attributes : Attribute[]  (name, type, isId, isNullable)
 └── methods : Method[]        (name, returnType, parameters)

Endpoint extends Method  (httpMethod, path)
Repository                (entityType, idType, methods)
Type (abstract)
 ├── PrimitiveType  (kind: STRING/INTEGER/LONG/BOOLEAN/DOUBLE/DATE/UUID)
 ├── CustomType     (reference: JavaClass)
 ├── CollectionType (collection, innerType)
 └── MapType        (keyType, valueType)
```

---

## 1. Syntactic Correctness (`sc.evl`)

**File:** `tests/metrics/sc.evl`
**Type:** EVL (Epsilon Validation Language)
**Target:** SMM model instance
**Required model alias:** `SMM`

### Constraints (25 rules)

| ID | Context | Check |
|---|---|---|
| SC001 | `Application` | `name` is non-empty |
| SC002 | `Application` | `basePackage` is non-empty |
| SC003 | `Application` | has at least one `Module` |
| SC004 | `Module` | `name` is non-empty |
| SC005 | `Entity` | `name` is non-empty |
| SC006 | `Entity` | `idType` is defined |
| SC007 | `ValueObject` | `name` is non-empty |
| SC008 | `Repository` | `name` is non-empty |
| SC009 | `Repository` | `entityType` is defined |
| SC010 | `Service` | `name` is non-empty |
| SC011 | `Service` | has at least one `requiredRepositories` |
| SC012 | `Controller` | `name` is non-empty |
| SC013 | `Controller` | `basePath` is non-empty |
| SC014 | `Controller` | `service` is defined |
| SC015 | `Endpoint` | `name` is non-empty |
| SC016 | `Endpoint` | `path` is non-empty |
| SC017 | `Endpoint` | `httpMethod` is defined |
| SC018 | `Attribute` | `name` is non-empty |
| SC019 | `Attribute` | `type` is defined |
| SC020 | `Parameter` | `name` is non-empty |
| SC021 | `Parameter` | `type` is defined |
| SC022 | `Dto` | `name` is non-empty |
| SC023 | `CollectionType` | `innerType` is defined |
| SC024 | `MapType` | `keyType` is defined |
| SC025 | `MapType` | `valueType` is defined |

### Score Mapping

| Violations | Score |
|---|---|
| 0 | 5 |
| 1–2 | 4 |
| 3–5 | 3 |
| 6–10 | 2 |
| >10 | 1 |

### Launch Config

```xml
<launchConfiguration type="org.eclipse.epsilon.evl.eclipse.launch.EpsilonEvlLaunchConfigurationDelegate">
    <listAttribute key="models">
        <listEntry value="SMM&#10;models/LibraryLoanSystem-smm-pure.xmi&#10;smm&#10;true&#10;false"/>
    </listAttribute>
    <listAttribute key="metamodels">
        <listEntry value="models/smm.ecore"/>
    </listAttribute>
    <stringAttribute key="evl.file" value="tests/metrics/sc.evl"/>
</launchConfiguration>
```

---

## 2. Architectural Fidelity (`af.eol`)

**File:** `tests/metrics/af.eol`
**Type:** EOL (Epsilon Object Language)
**Target:** HMM + SMM models loaded simultaneously
**Required model aliases:** `HMM` (Hexagon), `SMM` (Application)

### Rules

| # | Rule | Weight | Check |
| --- | --- | --- | --- |
| R1 | Controllers generated from InboundAdapters | 1 | SMM `controllers.size` >= HMM `InboundAdapter` count |
| R2 | Services generated from ApplicationServices | 1 | SMM `services.size` >= HMM `ApplicationService` count |
| R3 | Repositories generated from OutboundPorts | 1 | SMM `repositories.size` >= HMM `OutboundPort` count |
| R4 | Dependency inversion preserved | 1 | Every SMM `Service` uses `requiredRepositories` (none have empty repo deps) |
| R5 | Domain entities separated from infrastructure | 1 | No entity name appears in any controller name |

### Score

`Score = (rulesPassed / 5) * 5`

| Rules Passed | Score |
|---|---|
| 5 | 5 |
| 4 | 4 |
| 3 | 3 |
| 2 | 2 |
| 1 | 1 |
| 0 | 0 |

### Launch Config

```xml
<launchConfiguration type="org.eclipse.epsilon.eol.dt.launching.EolLaunchConfigurationDelegate">
    <listAttribute key="models">
        <listEntry value="HMM&#10;models/LibraryLoanSystem.xmi&#10;http://co.edu.unicauca.hexagen.hexagonal&#10;true&#10;false"/>
        <listEntry value="SMM&#10;models/LibraryLoanSystem-smm-pure.xmi&#10;smm&#10;true&#10;false"/>
    </listAttribute>
    <listAttribute key="metamodels">
        <listEntry value="models/hmm.ecore"/>
        <listEntry value="models/smm.ecore"/>
    </listAttribute>
    <stringAttribute key="source" value="tests/metrics/af.eol"/>
</launchConfiguration>
```

---

## 3. Functional Completeness (`fc.eol`)

**File:** `tests/metrics/fc.eol`
**Type:** EOL (Epsilon Object Language)
**Target:** SMM model instance
**Required model alias:** `SMM`

### Formula

```
FC = totalGenerated / expectedElements
```

`totalGenerated` = entities + valueObjects + repositories + services + controllers + dtos

### How Expected Counts Are Derived

The expected counts are computed dynamically from the HMM source model:

| Element | Source in HMM |
|---|---|
| Entities | Each `AggregateRoot` counts as 1 entity, plus every `Entity` member inside aggregates |
| ValueObjects | Every `ValueObject` member inside aggregates |
| Repositories | `OutboundPort` instances whose name contains `"Repository"` |
| Services | `ApplicationService` instances |
| Controllers | `InboundAdapter` instances |
| DTOs | Unique `ValueObject` names used as inputs/outputs across all use cases |

### Score Mapping

| Ratio | Score |
|---|---|
| >= 95% | 5 |
| >= 80% | 4 |
| >= 60% | 3 |
| >= 40% | 2 |
| < 40% | 1 |

### Launch Config

```xml
<launchConfiguration type="org.eclipse.epsilon.eol.dt.launching.EolLaunchConfigurationDelegate">
    <listAttribute key="models">
        <listEntry value="SMM&#10;models/LibraryLoanSystem-smm-pure.xmi&#10;smm&#10;true&#10;false"/>
    </listAttribute>
    <listAttribute key="metamodels">
        <listEntry value="models/smm.ecore"/>
    </listAttribute>
    <stringAttribute key="source" value="tests/metrics/fc.eol"/>
</launchConfiguration>
```

---

## 4. Structural Maintainability (`sm.evl`)

**File:** `tests/metrics/sm.evl`
**Type:** EVL (Epsilon Validation Language)
**Target:** SMM model instance
**Required model alias:** `SMM`

### Categories

#### Orphan Elements (elements not referenced by any other element)

| Constraint | Context | Check |
|---|---|---|
| `NoOrphanEntity` | `Entity` | Referenced by at least one `Repository.entityType` |
| `NoOrphanValueObject` | `ValueObject` | Referenced by at least one `Entity` attribute via `CustomType` |
| `NoOrphanService` | `Service` | Used by at least one `Controller.service` |
| `NoOrphanRepository` | `Repository` | Required by at least one `Service.requiredRepositories` |
| `NoOrphanDto` | `Dto` | Used as return/parameter type in at least one `Service` or `Controller` method |

#### Broken References (null or undefined references)

| Constraint | Context | Check |
|---|---|---|
| `EntityTypeExists` | `Repository` | `entityType` is defined |
| `RepositoriesExist` | `Service` | All `requiredRepositories` are defined |
| `ServiceReferenceExists` | `Controller` | `service` is defined |
| `ReferenceExists` | `CustomType` | `reference` is defined |
| `InnerTypeExists` | `CollectionType` | `innerType` is defined |
| `ReturnTypeExists` | `Method` | `returnType` is defined |
| `TypeExists` | `Parameter` | `type` is defined |

#### Duplicated Structures (duplicate names within the same container)

| Constraint | Context | Check |
|---|---|---|
| `UniqueEntityNames` | `Module` | No duplicate entity names |
| `UniqueValueObjectNames` | `Module` | No duplicate value object names |
| `UniqueRepositoryNames` | `Module` | No duplicate repository names |
| `UniqueServiceNames` | `Module` | No duplicate service names |
| `UniqueControllerNames` | `Module` | No duplicate controller names |
| `UniqueDtoNames` | `Module` | No duplicate DTO names |
| `UniqueAttributeNames` | `Entity` | No duplicate attribute names |
| `UniqueMethodNames` | `Service` | No duplicate method names |
| `UniqueEndpointPaths` | `Controller` | No duplicate endpoint paths |

### Score Mapping

Violations are counted as the total number of failed constraints across all three categories.

| Total Violations | Score | Label |
|---|---|---|
| 0 | 5 | None |
| 1–2 | 4 | Minor |
| 3–5 | 3 | Moderate |
| 6–10 | 2 | Many |
| >10 | 1 | Severe |

### Launch Config

```xml
<launchConfiguration type="org.eclipse.epsilon.evl.eclipse.launch.EpsilonEvlLaunchConfigurationDelegate">
    <listAttribute key="models">
        <listEntry value="SMM&#10;models/LibraryLoanSystem-smm-pure.xmi&#10;smm&#10;true&#10;false"/>
    </listAttribute>
    <listAttribute key="metamodels">
        <listEntry value="models/smm.ecore"/>
    </listAttribute>
    <stringAttribute key="evl.file" value="tests/metrics/sm.evl"/>
</launchConfiguration>
```

---

## 5. Aggregate Report (`evaluate-all.eol`)

**File:** `tests/metrics/evaluate-all.eol`
**Type:** EOL (Epsilon Object Language)
**Required model aliases:** `HMM` + `SMM`

Runs all four metrics and produces a unified report like:

```
╔═══════════════════════════════════════════════════════════
║  HEXAGEN — Model Quality Evaluation Report
╚═══════════════════════════════════════════════════════════

...
╔═══════════════════════════════════════════════════════════
║  FINAL SCORES
╠═══════════════════════════════════════════════════════════
║  SC (Syntactic Correctness)    : 5/5
║  AF (Architectural Fidelity)   : 4/5
║  FC (Functional Completeness)  : 5/5
║  SM (Structural Maintainability): 5/5
╠═══════════════════════════════════════════════════════════
║  OVERALL                      : 4.75/5
╚═══════════════════════════════════════════════════════════
```

### Launch Config

```xml
<launchConfiguration type="org.eclipse.epsilon.eol.dt.launching.EolLaunchConfigurationDelegate">
    <listAttribute key="models">
        <listEntry value="HMM&#10;models/LibraryLoanSystem.xmi&#10;http://co.edu.unicauca.hexagen.hexagonal&#10;true&#10;false"/>
        <listEntry value="SMM&#10;models/LibraryLoanSystem-smm-pure.xmi&#10;smm&#10;true&#10;false"/>
    </listAttribute>
    <listAttribute key="metamodels">
        <listEntry value="models/hmm.ecore"/>
        <listEntry value="models/smm.ecore"/>
    </listAttribute>
    <stringAttribute key="source" value="tests/metrics/evaluate-all.eol"/>
</launchConfiguration>
```

---

## Running the Tests

### From Eclipse

1. Import `hexagonal-validation` into Eclipse (File → Import → Existing Projects)
2. Expand `runconfigs/`
3. Right-click a `.launch` file → **Run As** → **Run Configurations**
4. Select the configuration → **Run**

| Launch Config | Runs |
|---|---|
| `RunSC.launch` | Syntactic Correctness only |
| `RunSM.launch` | Structural Maintainability only |
| `RunFC.launch` | Functional Completeness only |
| `RunAF.launch` | Architectural Fidelity only |
| `RunAllMetrics.launch` | Aggregate report of all 4 |

### From Command Line (ANT)

```bash
ant -f tests/build.xml evaluate-all
```

Requires Epsilon ANT tasks on the classpath (`epsilon-ant.jar` from `$ECLIPSE_HOME/plugins/`).

### From Command Line (Shell)

```bash
./tests/run-metrics.sh /path/to/eclipse
```

The script auto-detects Eclipse in common install locations.

---

## Adapting to a Different Domain

Expected counts are derived automatically from the HMM source model — no hardcoded values to update. To adapt:

1. **Update model paths** in launch configs (the `modelFile` values)
2. **Ensure the HMM model** has `AggregateRoot` elements in `domain.aggregates` (each becomes an entity)
3. **Use `Entity`/`ValueObject`/`Attribute` members** inside aggregates to drive the count
4. **Wire `ServiceAggregateLink`** from application services to domain aggregates so the transformation picks them up
5. **Update metamodel paths** if using different `.ecore` versions

### Example: Medical Appointment System

Expected counts derive from the HMM model's aggregates, members, ports, and services — no manual editing of `fc.eol` required.

### Example: Sports Complex Reservation

Same approach — define aggregates, entities, value objects, and links in the HMM `.xmi` file, and the test computes all expected counts automatically.

---

## File Structure

```
hexagonal-validation/
├── .project                              # Eclipse project descriptor
├── models/
│   ├── hmm.ecore                         # Hexagonal Metamodel
│   ├── smm.ecore                         # Spring Boot Metamodel
│   ├── LibraryLoanSystem.xmi             # HMM example (source architecture)
│   └── LibraryLoanSystem-smm-pure.xmi    # SMM example (generated code)
└── tests/
    ├── README.md                         # This file
    ├── build.xml                         # ANT build file
    ├── run-metrics.sh                    # Shell script runner
    ├── metrics/
    │   ├── sc.evl                        # Metric 1: Syntactic Correctness
    │   ├── af.eol                        # Metric 2: Architectural Fidelity
    │   ├── fc.eol                        # Metric 3: Functional Completeness
    │   ├── sm.evl                        # Metric 4: Structural Maintainability
    │   └── evaluate-all.eol             # Combined report
    └── runconfigs/
        ├── RunSC.launch
        ├── RunSM.launch
        ├── RunFC.launch
        ├── RunAF.launch
        └── RunAllMetrics.launch
```
