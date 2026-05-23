# Hexagonal Architecture + DDD Metamodel (HAD™) - Project Context

## Overview
This project implements the **Technical Metamodel Specification** for a **Hexagonal Architecture + DDD Metamodel (HAD™)**. It is intended for model-driven engineering tasks such as validation (EVL), transformation (ETL), and code generation (EGL) using Eclipse Modeling Tools (such as Emfatic, EMF, and Epsilon).

The goal of this project is to represent a software system's hexagonal architecture combined with Domain-Driven Design (DDD) principles as a metamodel, which can later be transformed into language-specific metamodels for code generation.

## Core Layers
The metamodel defines three primary layers encapsulated within a root `Hexagon` container:

### 1. Infrastructure Layer (`InfrastructureLayer`)
Represents the boundary between the hexagon and the external world. Groups all ports and adapters.
- **Port**: Interfaces declared inside the hexagon. Includes `InboundPort` (driven) and `OutboundPort` (driving).
- **Adapter**: Concrete implementations outside the hexagon connecting external systems to ports. Includes `InboundAdapter` and `OutboundAdapter`.
- **ExternalSystem**: Actors or systems outside the hexagon (UI, DB, APIs).

### 2. Application Layer (`ApplicationLayer`)
Orchestrates domain objects to fulfill business use cases. Contains no domain logic.
- **ApplicationService**: Orchestrator that groups related use cases.
- **UseCase**: Specific application operation.
- **UseCaseParameter**: Typed parameter representing input/output for a use case.

### 3. Domain Core (`DomainCore`)
The core of the application containing all business logic. It is completely isolated and contains no references to the Application or Infrastructure layers.
- **DomainObject** (Abstract): Superclass for domain concepts.
  - **AggregateRoot**: A cluster of DomainObjects, acting as a single entry point.
  - **Entity**: A domain object with persistent identity.
  - **ValueObject**: A domain object defined entirely by its attributes (no identity).
  - **Attribute**: A typed data field belonging to another DomainObject.
  - **DomainOperation**: Represents a behavior or method exposed by a DomainService.
- **DomainService**: Encapsulates domain logic that does not naturally belong to a single aggregate.
- **DomainEvent**: A record of a meaningful occurrence within the domain, carrying a payload of Attributes.

## Cross-Layer Links (`HexagonLink`)
All cross-layer relationships are expressed as typed link classes to keep each layer free of direct references:
- **AdapterPortLink**: Connects an adapter to a port.
- **ExternalSystemLink**: Connects an external actor to its adapter.
- **ServicePortLink**: Service exposes (`InboundPort`) or calls (`OutboundPort`).
- **ServiceAggregateLink**: Service coordinates an aggregate root.
- **ServiceDomainServiceLink**: Service invokes a domain service.

## Well-Formedness Constraints
The metamodel specifies strict well-formedness constraints to be implemented (e.g., in EVL), such as:
- A `Hexagon` MUST define exactly one `InfrastructureLayer`, one `ApplicationLayer`, and one `DomainCore`.
- The `DomainCore` MUST NOT reference any element from the ApplicationLayer or InfrastructureLayer (Domain Isolation).
- Cross-layer communication MUST go through `HexagonLink`s.
- `AggregateRoot` MUST contain at least one member (Entity or ValueObject).

## Purpose for AI Agents
This document provides the foundational context of the architectural metamodel being built. When generating code, writing model transformations, or implementing validations in this project, ensure that the rules, layers, and class definitions outlined in this HAD™ specification are strictly followed.
