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

## Member

Represents a library member who can borrow books.

Attributes include:

* Member identifier
* Full name
* Membership date
* Email address
* Phone number

The system must be able to register new members and retrieve member information.

---

## Book Copy

Represents an individual physical copy of a book in the library.

Attributes include:

* Copy identifier
* Barcode
* Condition status

Each copy is associated with a specific book title.
The system must support adding new copies to the catalog.

---

# Value Objects

## Book Metadata

Contains descriptive information about a book, such as:

* Title
* Author
* ISBN

This information should be treated as an immutable value object.

---

## Publisher Info

Contains publication details about a book.

Contains:

* Publisher name
* Publication year

This value object is part of the Book aggregate.

---

## Loan Period

Represents the borrowing period of a loan.

Contains:

* Start date
* Due date
* Loan duration

This object encapsulates all date-related loan calculations.

---

## Email

Represents a member's email address as an immutable value.

Contains:

* Address

---

## Phone

Represents a member's phone number as an immutable value.

Contains:

* Number

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

## Book Copy Service

Responsible for:

* Adding new copies of books to the catalog
* Tracking copy status
* Managing copy lifecycle

---

## Member Service

Responsible for:

* Registering new members
* Retrieving member information
* Managing member records

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

## Notification Service

Responsible for sending notifications to library members.

Responsibilities:

* Sending overdue notices
* Sending loan reminders
* Notifying about loan events

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

## Register Member

A new library member is registered in the system.

Expected behavior:

1. Validate member information.
2. Create a member record.
3. Publish a member-registered event.

---

## Get Member

A user requests information about a specific library member.

Expected result:

* Member details are returned.

---

## Add Book Copy

A new physical copy of a book is added to the library catalog.

Expected behavior:

1. Validate the book exists.
2. Create a copy record with a barcode.
3. Publish a book-copy-added event.

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

## Member Registered

Generated when a new member is registered in the system.

---

## Book Copy Added

Generated when a new physical copy is added to the library catalog.

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
* Register Member
* Manage Book Copies

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

### Member Repository Port

Provides persistence operations for members.

---

### Book Copy Repository Port

Provides persistence operations for book copies.

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

