# Portfolio 1 Database Design and Modelling

C# Portfolio 1: Database Design and Modelling

## 1. Case Study

Electronic Document Management System (EDMS) tracks staff, departments, documents, document versions and access rights for one organisation. Authors check out a document, edit it and check it back in as a new version, which a reviewer approves or rejects. Administrators manage access and archive old documents without losing earlier versions.

## 2. Users

* **System Administrator:** Manages users, roles and system permissions.
* **Department Administrator:** Oversees documents within their department.
* **Document Creator:** Uploads, categorises and updates documents.
* **Document Reviewer:** Reviews documents and gives feedback.
* **Document Approver:** Approves or rejects submitted documents.
* **General Employee:** Searches for and opens authorised documents.
* **Auditor:** Reviews document history and user activity.

## 3. Main Operations

* Register users, manage their logins and roles, and manage departments and their users.
* Upload, store and retrieve documents, using AI to categorise them and OCR to extract text from scanned files.
* Search documents by title, keyword and extracted file content.
* Manage document versions.
* Run approval workflows with electronic signatures, plus automated email notifications and reminders.
* Manage role-based access and document permissions.
* Manage document retention, archiving and retrieval, with audit trails, activity monitoring, activity tracking and reporting.

## 4. Business Rules

1. Every user has a unique user ID, login credentials, an assigned role and matching access permissions.
2. Every document has a unique document ID, title, owner, category and upload date, and is linked to its owner and department. Its storage reference must link to a valid database record.
3. A document can have many versions, each with a unique identifier. Previous versions are kept when a document is updated.
4. AI classification assigns each document's category from its content and metadata. OCR extracts readable text from supported scanned documents.
5. Only authorised users can view, modify, approve or sign documents. Documents submitted for approval must follow their assigned approval workflow.
6. Each electronic signature is linked to the responsible user and document version. All approval decisions and signatures are recorded, and email notifications are sent for relevant workflow activities.
7. Every document has a retention period. Documents that reach their retention stage follow the organisation's archiving or disposal process.
8. Important user and document activities are recorded in the audit log. Failed transactions are rolled back so no incomplete updates are saved.

## 5. Scope

One organisation with made-up records, covering the operations above plus user logins, e-signatures, AI classification, OCR and file-text search, email, advanced workflow automation, retention periods, audit trail and monitoring, activity tracking and archiving.

**Exclusions:** Government system links and outside sharing.

 