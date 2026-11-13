# Portfolio 3 Transactions and Concurrency

## Case Study

This portfolio uses the Electronic Document Management System (EDMS)
developed in Portfolio 1. The database manages departments, users,
documents, document versions, access permissions and activity records.

Database: `edms_portfolio`

## Transaction Exercise

The exercise demonstrates the use of PostgreSQL transactions through
`BEGIN`, `COMMIT` and `ROLLBACK`.

### 1. COMMIT Transaction

The retention date of the Annual Financial Policy (Document ID 1)
was updated from 2031-01-10 to 2032-01-10.

The transaction completed successfully with `COMMIT`.

A repeat check returned zero rows for the original date, confirming
that the update had been saved.

### 2. ROLLBACK Transaction

A transaction was started and the keywords of Staff Recruitment
Guidelines (Document ID 2) were temporarily updated.

A second operation attempted to assign version number 1 to an
existing document version, violating the unique constraint on
`(document_id, version_number)`.

PostgreSQL rejected the duplicate version operation. The transaction
was rolled back successfully.

### 3. Verification

The final queries confirmed that:

- The committed retention-date change remained saved.
- The temporary keyword change was reversed.
- The existing document version numbers remained unchanged.

This demonstrates how COMMIT preserves successful transactions
and ROLLBACK reverses changes within a failed transaction.

## Files

### SQL Script

- [Portfolio 3 Transactions](Azubogu_Chinaza_301915517_P3_Transactions.sql)

### Screenshot Evidence

- [Commit and Rollback Exercise](Screenshots/Azubogu_Chinaza_301915517_P3_CommitRollback.png)

## Reference

PostgreSQL Documentation – Transactions:

https://www.postgresql.org/docs/current/tutorial-transactions.html


## 4. Two-Session Concurrency Test

The concurrency test used two independent PostgreSQL sessions at the
READ COMMITTED isolation level.

Both sessions attempted to insert version 3 for the Annual Financial
Policy (Document ID 1). Session A committed successfully, while
Session B encountered a unique constraint violation because the
(document_id, version_number) combination already existed.

Session B was rolled back, and the final query confirmed that the
committed version 3 remained intact.

### Evidence

**Screenshot 1: Session B Waiting**

![Concurrency Waiting](Screenshots/Azubogu_Chinaza_301915517_P3_Concurrency_Waiting.png)

**Screenshot 2: Final Concurrency Outcome**

![Concurrency Final](Screenshots/Azubogu_Chinaza_301915517_P3_Concurrency_Final.png)