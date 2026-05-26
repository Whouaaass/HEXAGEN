# HEXAGEN

A Model-Driven Engineering platform for automated generation of hexagonal Spring Boot applications.

**Universidad del Cauca — Advanced Topics in Software Engineering — 2026**

---

## Overview

HEXAGEN is a generative MDE infrastructure that captures architectural knowledge in reusable metamodels and transformations. Developers specify their domain using high-level conceptual models and obtain fully functional Spring Boot applications adhering to hexagonal architecture (ports and adapters).

The platform is organized around **three metamodel layers**, each capturing a different level of abstraction:

| Layer | Metamodel | Scope |
|-------|-----------|-------|
| Conceptual | CMM | Domain entities, attributes, operations, business rules (technology-agnostic) |
| Hexagonal | HMM | Ports (input/output interfaces) and adapters (primary/secondary) |
| Spring Boot | SMM | Annotated Java classes, components, JPA, REST, configuration |

### Transformation Chain

```
Conceptual Metamodel (CMM)
       │
       │ CMM2HMM (ETL)
       ▼
Hexagonal Metamodel (HMM)
       │
       │ HMM2SMM (ETL)
       ▼
Spring Boot Metamodel (SMM)
       │
       │ SMM2Code (EGL)
       ▼
   Java / Spring Boot Source Code
```

---

## Team Structure

The project is organized into **three teams**, each responsible for one metamodel and the transformation to the next level:

### Team 1 — CMM

| Responsibility | Technology |
|---|---|
| CMM Metamodel Design | ECore |
| CMM Graphical Editor | Sirius |
| CMM Validation Constraints | EVL |
| CMM2HMM Transformation | ETL |

**Delivers:** Metamodel to instantiate.
**Input:** Conceptual domain model of the Library System.

### Team 2 — HMM

| Responsibility | Technology |
|---|---|
| HMM Metamodel Design | ECore |
| HMM Graphical Editor | Sirius |
| HMM Validation Constraints | EVL |
| HMM2SMM Transformation | ETL |

**Delivers:** HMM metamodel to Team 1.  
**Input:** Receives SMM from Team 3.

### Team 3 — SMM

| Responsibility | Technology |
|---|---|
| SMM Metamodel Design | ECore |
| SMM Graphical Editor | Sirius |
| SMM Validation Constraints | EVL |
| SMM2Code Code Generation Templates | EGL |

**Delivers:** Generated Spring Boot application.

---

## Validation Case Study: Library System

All teams collaborate on a common case study to validate the platform.

### Domain

- **Book** (isbn, title, author, publicationYear, status)
- **User** (id, name, email, membershipDate)
- **Loan** (id, book, user, loanDate, dueDate, returnDate)
- **Reservation** (id, book, user, reservationDate, status)

### Services

- `LoanService` — borrowBook, returnBook, renewLoan, checkOverdue
- `CatalogService` — searchBooks, addBook, updateBook, removeBook
- `UserService` — registerUser, updateUser, suspendUser

### Business Rules

- Max 5 books per user simultaneously
- Loans due 14 days after borrowing
- Overdue fines: 2500 COP/day
- Reserved books held for 48 hours

---

## Technology Stack

| Tool | Version | Purpose |
|---|---|---|
| Eclipse Modeling Tools | 2023-12 | IDE |
| EMF (Eclipse Modeling Framework) | 2.30+ | Core metamodeling |
| Epsilon | 2.5+ | ETL, EGL, EVL languages |
| Sirius | 7.0+ | Graphical model editors |
| Git / GitHub | — | Version control |
| Maven | 3.9+ | Build automation for generated code |
| JDK | 17+ | Java development kit |
| Spring Boot | 3.1+ | Target framework |

---

## Project Structure

> Review if the final project stricture will be like this

```
hexagen/
├── conceptual/
│   ├── metamodel/            # CMM.ecore
│   ├── edit/             # CMM.edit
│   └── editor/           # CMM.editor
├── hexagonal/
│   ├── metamodel/            # HMM.ecore
│   ├── edit/             # HMM.edit
│   └── editor/           # HMM.editor
├── springboot/
│   ├── metamodel/            # SMM.ecore
│   ├── edit/             # SMM.edit
│   └── editor/           # SMM.editor
├── transformations/
│   ├── cmm2hmm/          # CMM2HMM.etl
│   ├── hmm2smm/          # HMM2SMM.etl
│   └── smm2code/         # SMM2Code.egl (templates/)
├── validation/
│   ├── cmm.evl
│   ├── hmm.evl
│   └── smm.evl
├── tests/
│   └── library-system/
│       ├── models/
│       └── generated/
└── docs/
```

---

## Implementation Roadmap

| Weeks | Milestone |
|---|---|
| 1–2 | Foundations: EMF, ECore, Epsilon languages, Sirius training |
| 3–4 | Metamodel development: CMM, HMM, SMM in ECore + Sirius editors + EVL constraints |
| 5–7 | Transformation implementation: CMM2HMM, HMM2SMM (ETL), SMM2Code (EGL) |
| 8–9 | Full pipeline integration, Library System case study, debugging |
| 10–11 | Validation, metrics, documentation |
| 12 | Final delivery and presentations |

---

## Getting Started

1. Install [Eclipse Modeling Tools 2023-12](https://www.eclipse.org/downloads/packages/release/2023-12)
2. Install Epsilon 2.5+ via the [Epsilon update site](https://download.eclipse.org/epsilon/updates/2.5/)
3. Install Sirius 7.0+ via the Eclipse Marketplace
4. Clone this repository
5. Import existing projects into Eclipse workspace
6. See each team's subdirectory for specific setup instructions

---

## Evaluation Criteria

| Criterion | Weight |
|---|---|
| Metamodel Quality | 15% |
| Transformation Correctness | 20% |
| Code Generation | 25% |
| Validation | 10% |
| Documentation | 10% |
| Collaboration | 10% |
| Innovation | 10% |

---

## Expected Outcomes

1. Three validated metamodels (CMM, HMM, SMM) with ECore implementations and Sirius graphical editors
2. Three model transformations: CMM2HMM (ETL), HMM2SMM (ETL), SMM2Code (EGL)
3. EVL validation constraints for well-formedness at each level
4. End-to-end automated generation pipeline
5. Fully generated Library System application
6. Reusable platform applicable to multiple domains
7. Comprehensive technical documentation

---

*See [project-specification.pdf](project-specification.pdf) for the full specification document.*
