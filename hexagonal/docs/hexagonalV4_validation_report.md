# Validation Rules Report — `hexagonalV4.evl`

**Project:** HEXAGEN — Hexagonal Architecture + DDD Metamodel (HAD™)
**Universidad del Cauca**
**Module:** `co.edu.unicauca.hexagen`
**Validation file:** `validations/hexagonalV4.evl`
**Target metamodel:** `metamodels/v4/hexagonalpro.ecore` (`http://co.edu.unicauca.hexagen.hexagonal`)

This report documents every EVL constraint declared in `hexagonalV4.evl`, grouped by `context` block, together with the architectural rationale that justifies each rule against the HAD™ specification.

---

## 1. Root Element `Hexagon`

The `Hexagon` is the top-level container that must aggregate exactly one of each of the three architectural layers plus the cross-layer links and external actors.

### 1.1 Basic structural invariants

| Constraint | Purpose |
|---|---|
| `HexagonHasName` | Guarantees the hexagon has a non-empty `name`. A nameless root element cannot be referenced unambiguously by tooling, code generators or documentation. |
| `HexagonHasInfrastructure` | Enforces the presence of the `InfrastructureLayer`. Per the HAD™ spec the boundary with the outside world is mandatory; an hexagon with no infrastructure cannot expose or consume any port. |
| `HexagonHasApplication` | Enforces the presence of the `ApplicationLayer`. The orchestration of use cases is mandatory — the domain alone is not executable. |
| `HexagonHasDomain` | Enforces the presence of the `DomainCore`. Mirrors the previous rule on the opposite side: without a domain there is nothing to orchestrate. |
| `InfrastructureHasName` | A layer without a name cannot be distinguished in generated artefacts, multi-hexagon scenarios or model queries. |
| `ApplicationHasName` | Same as above for the `ApplicationLayer`. |
| `DomainHasName` | Same as above for the `DomainCore`. |

### 1.2 Infrastructure composition

| Constraint | Purpose |
|---|---|
| `InfrastructureHasPorts` | At least one `Port` is required. The hexagon's contract with the outside world is expressed through ports; an infrastructure without them is meaningless. |
| `InfrastructureHasAdapters` | At least one `Adapter` is required. Without adapters, the declared ports cannot be realised by any technology. |
| `HasInboundPorts` | Requires at least one `InboundPort` (driven side). The hexagon must expose at least one entry point that the outside world can invoke. |
| `HasOutboundPorts` | Requires at least one `OutboundPort` (driving side). The hexagon must declare at least one dependency on an external capability. |
| `HasInboundAdapters` | Requires at least one `InboundAdapter`, ensuring the driven side is concretely implemented. |
| `HasOutboundAdapters` | Requires at least one `OutboundAdapter`, ensuring the driving side is concretely implemented. |

### 1.3 Application and Domain composition

| Constraint | Purpose |
|---|---|
| `ApplicationHasServices` | An `ApplicationLayer` must contain at least one `ApplicationService`; otherwise the layer is an empty container with no orchestrators. |
| `DomainHasAggregates` | The `DomainCore` must contain at least one `AggregateRoot`. A domain with no aggregate has no transactional consistency boundary. |
| `DomainHasServices` | The `DomainCore` must contain at least one `DomainService`, ensuring the domain side is not empty even when logic that does not belong to a single aggregate is required. |

### 1.4 Link integrity

| Constraint | Purpose |
|---|---|
| `AllLinksHaveNames` | Every `HexagonLink` instance must have a non-empty `name`. Named links can be traced, logged and used as anchor points in code generation. |
| `AllAdaptersAreLinked` | Every `Adapter` must appear as the `source` of at least one `AdapterPortLink`. An adapter that is not bound to a port is dead code in the model. |
| `AllExternalSystemsAreLinked` | Every `ExternalSystem` must appear as the `source` of at least one `ExternalSystemLink`. External actors that are not bound to an adapter are not actually integrated. |

---

## 2. Ports and Adapters

### 2.1 `Port` (abstract)

| Constraint | Purpose |
|---|---|
| `PortHasName` | Generic name check for all ports. |
| `PortNameEndsWithPort` | **Recommended** convention: port names end with `Port` / `port`. Promotes readability and lets transformations and code generators apply consistent naming rules. |

### 2.2 `InboundPort`

| Constraint | Purpose |
|---|---|
| `InboundPortHasName` | Reinforces the generic name check for the driven-side subtype. |

### 2.3 `OutboundPort`

| Constraint | Purpose |
|---|---|
| `OutboundPortHasName` | Reinforces the generic name check for the driving-side subtype. |

### 2.4 `Adapter` (abstract)

| Constraint | Purpose |
|---|---|
| `AdapterHasName` | Generic name check for all adapters. |

### 2.5 `InboundAdapter`

| Constraint | Purpose |
|---|---|
| `InboundAdapterNaming` | **Recommended** convention: ends with `Controller`, `Adapter` or `REST`. Aligns with common naming for HTTP/REST entry points in DDD-style projects. |

### 2.6 `OutboundAdapter`

| Constraint | Purpose |
|---|---|
| `OutboundAdapterNaming` | **Recommended** convention: ends with `Repository`, `Adapter` or `ORM`. Aligns with the standard naming for persistence-side adapters. |

---

## 3. Application Layer

### 3.1 `ApplicationService`

| Constraint | Purpose |
|---|---|
| `ServiceHasName` | A service without a name cannot be referenced by links or by code generation. |
| `ServiceHasUseCases` | Every `ApplicationService` must declare at least one `UseCase`; a service with no use case has nothing to orchestrate. |
| `ServiceNameEndsWithService` | **Recommended** convention: ends with `Service`, so that generated artefacts follow the HAD™ recommended vocabulary. |

### 3.2 `UseCase`

| Constraint | Purpose |
|---|---|
| `UseCaseHasName` | Use cases must be identifiable to participate in traces, tests and code generation. |
| `UseCaseHasInputOrOutput` | A use case must declare at least one input or one output `DomainObject`. A use case with neither is a method with no signature. |

---

## 4. Domain Core

### 4.1 `DomainCore`

| Constraint | Purpose |
|---|---|
| `DomainHasContent` | The domain must contain at least one of: `AggregateRoot`, `DomainService` or `DomainObject`. Guards against a completely empty domain layer. |

### 4.2 `AggregateRoot`

| Constraint | Purpose |
|---|---|
| `AggregateHasName` | Aggregates are the main domain entities; they must be named. |
| `AggregateHasMembers` | An aggregate must contain at least one `DomainObject` member (entity, value object, attribute, operation). An aggregate with no member has no internal state or behaviour, which contradicts the DDD notion of an aggregate. |

### 4.3 `DomainObject`

| Constraint | Purpose |
|---|---|
| `DomainObjectHasName` | All domain objects (the abstract superclass) must be named. |

### 4.4 `Attribute`

| Constraint | Purpose |
|---|---|
| `AttributeHasType` | An `Attribute` must specify a non-empty `type`. An attribute without a type cannot be translated to any concrete language construct. |

### 4.5 `DomainService`

| Constraint | Purpose |
|---|---|
| `DomainServiceHasName` | A domain service must be named to be referenced. |
| `DomainServiceHasOperations` | A domain service must declare at least one `DomainOperation`. An empty service has no behaviour to expose. |

### 4.6 `DomainOperation`

| Constraint | Purpose |
|---|---|
| `OperationHasName` | Each domain operation must be named. |
| `OperationHasReturnType` | Each domain operation must specify a non-empty `returnType`. Operations without a return type cannot be mapped to typed language signatures. |

### 4.7 `DomainEvent`

| Constraint | Purpose |
|---|---|
| `EventHasName` | Domain events must be named to participate in traces and code generation. |
| `EventHasPayload` | Each `DomainEvent` must carry at least one `Attribute` in its payload. An event without data is not informative. |

---

## 5. External Actors

### 5.1 `ExternalSystem`

| Constraint | Purpose |
|---|---|
| `ExternalSystemHasName` | External systems (UI, DB, third-party APIs, etc.) must be named so that they can be linked and documented. |

---

## 6. Cross-Layer Links (`HexagonLink` and subtypes)

The `HexagonLink` hierarchy is the only legal way to express cross-layer communication in HAD™. The following constraints guarantee that every link is well formed.

### 6.1 `HexagonLink` (abstract)

| Constraint | Purpose |
|---|---|
| `LinkHasName` | Every link must have a non-empty name (also reinforced by `AllLinksHaveNames` at the `Hexagon` level). |

### 6.2 `AdapterPortLink`

| Constraint | Purpose |
|---|---|
| `AdapterPortLinkHasSource` | The `source` (an `Adapter`) must be present. Note: the metamodel already sets `lowerBound="1"`, so this constraint is defensive against accidental model corruption. |
| `AdapterPortLinkHasTarget` | The `target` (a `Port`) must be present. A link with no port does not connect to the hexagon contract. |

### 6.3 `ExternalSystemLink`

| Constraint | Purpose |
|---|---|
| `ExternalSystemLinkHasSource` | The `source` (an `ExternalSystem`) must be present. |
| `ExternalSystemLinkHasTarget` | The `target` (an `Adapter`) must be present. |

### 6.4 `ServicePortLink`

| Constraint | Purpose |
|---|---|
| `ServicePortLinkHasSource` | The `source` (an `ApplicationService`) must be present. |
| `ServicePortLinkHasTarget` | The `target` (a `Port`) must be present. |

### 6.5 `ServiceAggregateLink`

| Constraint | Purpose |
|---|---|
| `ServiceAggregateLinkHasSource` | The `source` (an `ApplicationService`) must be present. |
| `ServiceAggregateLinkHasTarget` | The `target` (an `AggregateRoot`) must be present. |

### 6.6 `ServiceDomainServiceLink`

| Constraint | Purpose |
|---|---|
| `ServiceDomainServiceLinkHasSource` | The `source` (an `ApplicationService`) must be present. |
| `ServiceDomainServiceLinkHasTarget` | The `target` (a `DomainService`) must be present. |

---

## 7. Summary by Architectural Concern

| Concern | Constraints |
|---|---|
| **Naming hygiene** | `HexagonHasName`, `InfrastructureHasName`, `ApplicationHasName`, `DomainHasName`, `PortHasName`, `InboundPortHasName`, `OutboundPortHasName`, `AdapterHasName`, `ServiceHasName`, `UseCaseHasName`, `AggregateHasName`, `DomainObjectHasName`, `DomainServiceHasName`, `OperationHasName`, `EventHasName`, `ExternalSystemHasName`, `LinkHasName`, `AllLinksHaveNames` |
| **Mandatory layer presence** | `HexagonHasInfrastructure`, `HexagonHasApplication`, `HexagonHasDomain` |
| **Mandatory element presence** | `InfrastructureHasPorts`, `InfrastructureHasAdapters`, `HasInboundPorts`, `HasOutboundPorts`, `HasInboundAdapters`, `HasOutboundAdapters`, `ApplicationHasServices`, `DomainHasAggregates`, `DomainHasServices`, `DomainHasContent`, `ServiceHasUseCases`, `AggregateHasMembers`, `DomainServiceHasOperations`, `EventHasPayload` |
| **Naming conventions (recommended)** | `PortNameEndsWithPort`, `InboundAdapterNaming`, `OutboundAdapterNaming`, `ServiceNameEndsWithService` |
| **Typing completeness** | `AttributeHasType`, `OperationHasReturnType`, `UseCaseHasInputOrOutput` |
| **Link integrity** | `AllAdaptersAreLinked`, `AllExternalSystemsAreLinked`, plus the per-link `HasSource` / `HasTarget` constraints for `AdapterPortLink`, `ExternalSystemLink`, `ServicePortLink`, `ServiceAggregateLink`, `ServiceDomainServiceLink` |

---

## 8. Cross-Reference with the Metamodel (`hexagonalpro.ecore`)

The validation rules are deliberately written so that they complement the structural multiplicities already declared in the Ecore model:

- `Hexagon.infrastructure`, `Hexagon.application` and `Hexagon.domain` already have `lowerBound="1"` in the metamodel. The EVL constraints `HexagonHasInfrastructure`, `HexagonHasApplication` and `HexagonHasDomain` therefore act as *semantic* invariants: they re-state the well-formedness rule in user-readable Spanish and ensure that even models loaded without strict EMF validation still trigger the error.
- The link subclasses (`AdapterPortLink`, `ExternalSystemLink`, `ServicePortLink`, `ServiceAggregateLink`, `ServiceDomainServiceLink`) already declare `lowerBound="1"` for both `source` and `target` in the metamodel. The corresponding EVL `HasSource` / `HasTarget` constraints reinforce the rule at the validation layer and emit explicit messages.
- The `EVL` rules `AllLinksHaveNames`, `AllAdaptersAreLinked` and `AllExternalSystemsAreLinked` add **model-level** invariants that are not expressible as Ecore multiplicities (e.g. "every adapter participates in at least one link") and therefore fully rely on EVL.

This dual approach — strict Ecore multiplicities for cardinality, EVL for semantics, naming and global integrity — implements the **well-formedness constraints** described in the HAD™ technical specification.
