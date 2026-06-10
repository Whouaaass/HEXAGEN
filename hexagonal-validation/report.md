## ETL (MDE) Transformation model generation results

```
╔═══════════════════════════════════════════════════════════
║  HEXAGEN — Model Quality Evaluation Report              
╚═══════════════════════════════════════════════════════════

--- Detailed Error Log ---

  [1] ORPHAN: ValueObject 'LoanPeriod' is not referenced by any Entity attribute.
  [2] ORPHAN: ValueObject 'PublisherInfo' is not referenced by any Entity attribute.
  [3] ORPHAN: ValueObject 'Email' is not referenced by any Entity attribute.
  [4] ORPHAN: ValueObject 'Phone' is not referenced by any Entity attribute.
  [5] BROKEN: CustomType has a null JavaClass reference.
  [6] BROKEN: CustomType has a null JavaClass reference.
  [7] BROKEN: CustomType has a null JavaClass reference.
  [8] BROKEN: CustomType has a null JavaClass reference.

  SC Well-formedness violations: 0
  SM Orphan elements: 4
  SM Broken refs: 4
  SM Duplicates: 0
  Total errors: 8
--- M1: Syntactic Correctness ---
  Violations: 0
  SC Score: 5/5

--- M2: Architectural Fidelity ---
  PASS R1: Controllers (6) >= InboundAdapters (6)
  PASS R2: Services (4) >= ApplicationServices (4)
  PASS R3: Repos (4) >= Repository OutboundPorts (4)
  PASS R4: All services use requiredRepositories
  PASS R5: No domain entity names in controllers
  AF Score: 5/5

--- M3: Functional Completeness ---
  Generated: 39, Expected: 39, Ratio: 100.0%
    Entities:       4/4
    ValueObjects:   4/4
    Repositories:   4/4
    Services:       4/4
    Controllers:    6/6
    DTOs:           17/17
  FC Score: 5/5

--- M4: Structural Maintainability ---
  Orphan elements: 4
  Broken refs: 4
  Duplicates: 0
  SM Score: 2/5

╔═══════════════════════════════════════════════════════════
║  FINAL SCORES                                            
╠═══════════════════════════════════════════════════════════
║  SC (Syntactic Correctness)    : 5/5
║  AF (Architectural Fidelity)   : 5/5
║  FC (Functional Completeness)  : 5/5
║  SM (Structural Maintainability): 2/5
╠═══════════════════════════════════════════════════════════
║  OVERALL                      : 4.25/5
╚═══════════════════════════════════════════════════════════

```

## Hybrid AI model generation results

```
╔═══════════════════════════════════════════════════════════
║  HEXAGEN — Model Quality Evaluation Report              
╚═══════════════════════════════════════════════════════════

--- Detailed Error Log ---

  [1] SC016: Endpoint 'requestLoan' must have a non-empty path.
  [2] SC016: Endpoint 'searchBook' must have a non-empty path.
  [3] SC016: Endpoint 'registerMember' must have a non-empty path.

  SC Well-formedness violations: 3
  SM Orphan elements: 0
  SM Broken refs: 0
  SM Duplicates: 0
  Total errors: 3
--- M1: Syntactic Correctness ---
  Violations: 3
  SC Score: 3/5

--- M2: Architectural Fidelity ---
  PASS R1: Controllers (6) >= InboundAdapters (6)
  PASS R2: Services (4) >= ApplicationServices (4)
  PASS R3: Repos (4) >= Repository OutboundPorts (4)
  PASS R4: All services use requiredRepositories
  PASS R5: No domain entity names in controllers
  AF Score: 5/5

--- M3: Functional Completeness ---
  Generated: 39, Expected: 39, Ratio: 100.0%
    Entities:       4/4
    ValueObjects:   4/4
    Repositories:   4/4
    Services:       4/4
    Controllers:    6/6
    DTOs:           17/17
  FC Score: 5/5

--- M4: Structural Maintainability ---
  Orphan elements: 0
  Broken refs: 0
  Duplicates: 0
  SM Score: 5/5

╔═══════════════════════════════════════════════════════════
║  FINAL SCORES                                            
╠═══════════════════════════════════════════════════════════
║  SC (Syntactic Correctness)    : 3/5
║  AF (Architectural Fidelity)   : 5/5
║  FC (Functional Completeness)  : 5/5
║  SM (Structural Maintainability): 5/5
╠═══════════════════════════════════════════════════════════
║  OVERALL                      : 4.5/5
╚═══════════════════════════════════════════════════════════
```

This was a good case, but with the same prompt and artifacts, it can generate something with the following score

```
╔═══════════════════════════════════════════════════════════
║  HEXAGEN — Model Quality Evaluation Report              
╚═══════════════════════════════════════════════════════════

--- Detailed Error Log ---

  [1] SC006: Entity 'Loan' must have a defined idType.
  [2] SC006: Entity 'Book' must have a defined idType.
  [3] SC006: Entity 'Member' must have a defined idType.
  [4] SC006: Entity 'BookCopy' must have a defined idType.
  [5] ORPHAN: Dto 'LoanRequestDTO' is not used by any Service or Controller endpoint.
  [6] ORPHAN: Dto 'ReturnBookRequestDTO' is not used by any Service or Controller endpoint.
  [7] ORPHAN: Dto 'RenewLoanRequestDTO' is not used by any Service or Controller endpoint.
  [8] ORPHAN: Dto 'LoanHistoryRequestDTO' is not used by any Service or Controller endpoint.
  [9] ORPHAN: Dto 'SearchBookRequestDTO' is not used by any Service or Controller endpoint.
  [10] ORPHAN: Dto 'AvailabilityRequestDTO' is not used by any Service or Controller endpoint.
  [11] ORPHAN: Dto 'RegisterMemberRequestDTO' is not used by any Service or Controller endpoint.
  [12] ORPHAN: Dto 'AddBookCopyRequestDTO' is not used by any Service or Controller endpoint.
  [13] BROKEN: Method 'findAll' has a null returnType.
  [14] BROKEN: Method 'save' has a null returnType.
  [15] BROKEN: Method 'deleteById' has a null returnType.
  [16] BROKEN: Method 'findAll' has a null returnType.
  [17] BROKEN: Method 'save' has a null returnType.
  [18] BROKEN: Method 'deleteById' has a null returnType.
  [19] BROKEN: Method 'findAll' has a null returnType.
  [20] BROKEN: Method 'save' has a null returnType.
  [21] BROKEN: Method 'deleteById' has a null returnType.
  [22] BROKEN: Method 'findAll' has a null returnType.
  [23] BROKEN: Method 'save' has a null returnType.
  [24] BROKEN: Method 'deleteById' has a null returnType.

  SC Well-formedness violations: 4
  SM Orphan elements: 8
  SM Broken refs: 12
  SM Duplicates: 0
  Total errors: 24
--- M1: Syntactic Correctness ---
  Violations: 4
  SC Score: 3/5

--- M2: Architectural Fidelity ---
  PASS R1: Controllers (6) >= InboundAdapters (6)
  PASS R2: Services (4) >= ApplicationServices (4)
  PASS R3: Repos (4) >= Repository OutboundPorts (4)
  PASS R4: All services use requiredRepositories
  PASS R5: No domain entity names in controllers
  AF Score: 5/5

--- M3: Functional Completeness ---
  Generated: 39, Expected: 39, Ratio: 100.0%
    Entities:       4/4
    ValueObjects:   4/4
    Repositories:   4/4
    Services:       4/4
    Controllers:    6/6
    DTOs:           17/17
  FC Score: 5/5

--- M4: Structural Maintainability ---
  Orphan elements: 8
  Broken refs: 12
  Duplicates: 0
  SM Score: 1/5

╔═══════════════════════════════════════════════════════════
║  FINAL SCORES                                            
╠═══════════════════════════════════════════════════════════
║  SC (Syntactic Correctness)    : 3/5
║  AF (Architectural Fidelity)   : 5/5
║  FC (Functional Completeness)  : 5/5
║  SM (Structural Maintainability): 1/5
╠═══════════════════════════════════════════════════════════
║  OVERALL                      : 3.5/5
╚═══════════════════════════════════════════════════════════

```



## Pure AI .xmi Generation

```
╔═══════════════════════════════════════════════════════════
║  HEXAGEN — Model Quality Evaluation Report              
╚═══════════════════════════════════════════════════════════

--- Detailed Error Log ---

  [1] SC006: Entity 'Book' must have a defined idType.
  [2] SC006: Entity 'Loan' must have a defined idType.
  [3] SC006: Entity 'Member' must have a defined idType.
  [4] SC006: Entity 'BookCopy' must have a defined idType.
  [5] SC011: Service 'AvailabilityService' must reference at least one Repository.
  [6] SC011: Service 'FineCalculatorService' must reference at least one Repository.
  [7] SC011: Service 'NotificationService' must reference at least one Repository.
  [8] SC016: Endpoint 'searchBooks' must have a non-empty path.
  [9] SC016: Endpoint 'requestLoan' must have a non-empty path.
  [10] SC016: Endpoint 'registerMember' must have a non-empty path.
  [11] SC016: Endpoint 'addBookCopy' must have a non-empty path.
  [12] ORPHAN: Service 'AvailabilityService' is not used by any Controller. A service with no controller exposing it is dead code.
  [13] ORPHAN: Service 'FineCalculatorService' is not used by any Controller. A service with no controller exposing it is dead code.
  [14] ORPHAN: Service 'NotificationService' is not used by any Controller. A service with no controller exposing it is dead code.

  SC Well-formedness violations: 11
  SM Orphan elements: 3
  SM Broken refs: 0
  SM Duplicates: 0
  Total errors: 14
--- M1: Syntactic Correctness ---
  Violations: 11
  SC Score: 1/5

--- M2: Architectural Fidelity ---
  FAIL R1: Controllers (4) < InboundAdapters (6)
  PASS R2: Services (7) >= ApplicationServices (4)
  PASS R3: Repos (4) >= Repository OutboundPorts (4)
  FAIL R4: AvailabilityService, FineCalculatorService, NotificationService have no repo deps
  PASS R5: No domain entity names in controllers
  AF Score: 3/5

--- M3: Functional Completeness ---
  Generated: 28, Expected: 39, Ratio: 71.7948717948718%
    Entities:       4/4
    ValueObjects:   5/4
    Repositories:   4/4
    Services:       7/4
    Controllers:    4/6
    DTOs:           4/17
  FC Score: 3/5

--- M4: Structural Maintainability ---
  Orphan elements: 3
  Broken refs: 0
  Duplicates: 0
  SM Score: 3/5

╔═══════════════════════════════════════════════════════════
║  FINAL SCORES                                            
╠═══════════════════════════════════════════════════════════
║  SC (Syntactic Correctness)    : 1/5
║  AF (Architectural Fidelity)   : 3/5
║  FC (Functional Completeness)  : 3/5
║  SM (Structural Maintainability): 3/5
╠═══════════════════════════════════════════════════════════
║  OVERALL                      : 2.5/5
╚═══════════════════════════════════════════════════════════

```
