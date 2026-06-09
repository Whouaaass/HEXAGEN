# Domain Specification: Library Loan Management System

## Overview

Design a library loan management system following the principles of Hexagonal Architecture (Ports and Adapters).

The system manages books and loans within a library and allows users to:

* Search for books.
* Request book loans.
* Return borrowed books.
* Renew existing loans.
* Receive notifications regarding loan events.

The architecture should separate domain logic from infrastructure concerns using inbound and outbound ports and adapters.

---

# Domain Concepts

## Book

Represents a book available in the library.

Attributes include:

* Book identifier
* Title
* Author
* ISBN
* Publication information
* Availability status

The system must be able to query books and determine whether they are available for loan.

---

## Loan

Represents the lending of a book to a library member.

Attributes include:

* Loan identifier
* Loan status
* Start date
* Due date

A loan is associated with a loan period that defines borrowing duration.

The system must support:

* Loan creation
* Loan renewal
* Loan return

---

# Value Objects

## Book Metadata

Contains descriptive information about a book, such as:

* Title
* Author
* ISBN
* Publication information

This information should be treated as an immutable value object.

---

## Loan Period

Represents the borrowing period of a loan.

Contains:

* Start date
* Due date
* Loan duration

This object encapsulates all date-related loan calculations.

---

# Application Services

## Book Service

Responsible for:

* Querying books
* Checking availability
* Providing book information

---

## Loan Service

Responsible for:

* Creating loans
* Renewing loans
* Returning books
* Coordinating loan workflows

---

# Domain Services

## Availability Service

Responsible for determining whether a book can be borrowed.

Business rules may include:

* Book is not already loaned
* Book exists in the catalog
* Book is eligible for lending

---

## Fine Calculator Service

Responsible for calculating overdue fines.

Business rules may include:

* Fine calculation based on overdue days
* Different rates depending on library policies

---

# Use Cases

## Search Books

A user requests information about books available in the library.

Expected result:

* Matching books are returned.

---

## Request Loan

A user requests to borrow a book.

Expected behavior:

1. Validate book availability.
2. Create a loan.
3. Publish a loan-created event.
4. Notify interested systems if required.

---

## Return Book

A user returns a previously borrowed book.

Expected behavior:

1. Mark loan as returned.
2. Update book availability.
3. Publish a return event.

---

## Renew Loan

A user requests an extension of an existing loan.

Expected behavior:

1. Validate renewal conditions.
2. Extend the loan period.
3. Update the loan record.

---

# Domain Events

The system should publish domain events when important business actions occur.

## Loan Requested

Generated when a new loan is created.

---

## Book Returned

Generated when a loaned book is returned.

---

## Loan Overdue

Generated when a loan exceeds its due date.

This event may trigger notifications or fine calculations.

---

# External Systems

The application communicates with external systems.

## Notification System

Used to send messages to library users.

Examples:

* Loan confirmation
* Due date reminders
* Overdue notifications

---

# Hexagonal Architecture Requirements

The system must follow Hexagonal Architecture.

## Inbound Ports

The application exposes the following capabilities through inbound ports:

* Request Loan
* Query Books
* Return Book
* Renew Loan

These ports represent the operations available to external actors.

---

## Outbound Ports

The application requires the following outbound dependencies:

### Loan Repository Port

Provides persistence operations for loans.

---

### Book Repository Port

Provides persistence operations for books.

---

### Notification Port

Provides notification capabilities.

The application core must depend only on this abstraction and not on any concrete notification technology.

---

## Inbound Adapters

Inbound adapters expose application functionality to external clients.

Examples:

* REST controllers for book queries
* REST controllers for loan operations

---

## Outbound Adapters

Outbound adapters provide concrete implementations of outbound ports.

Examples:

* Database repository adapters
* Notification provider adapters

---

# Expected Architectural Constraints

1. Domain entities must not depend on infrastructure components.
2. Application services interact through ports.
3. Adapters implement ports.
4. Infrastructure components depend on the application core, never the opposite.
5. Business logic must remain inside the domain and application layers.
6. External systems are accessed only through outbound ports.

