# Portfolio 1 Database Design and Modelling

Case study
Electronic Document Management System, tracks staff, departments, documents, document versions and access rights for one organisation. Authors check out a document, edit it and check it back in as a new version, which a reviewer approves or rejects. Administrators manage access and archive old documents without losing earlier versions.

Users
System Administrator: manages users, roles and system permissions.
Department Administrator: oversees documents within their department.
Document Creator: uploads, categorises and updates documents.
Document Reviewer: reviews documents and gives feedback.
Document Approver: approves or rejects submitted documents.
General Employee: searches for and opens authorised documents.
Auditor: reviews document history and user activity.


Main operations
Register users, manage their logins and roles, and manage departments and their users.
Upload, store and retrieve documents, using AI to categorise them and OCR to extract text from scanned files.
Search documents by title, keyword and extracted file content.
Manage document versions.
Run approval workflows with electronic signatures, plus automated email notifications and reminders.
Manage role-based access and document permissions.
Manage document retention, archiving and retrieval, with audit trails, activity monitoring, activity tracking and reporting.
 

Business rules
Every user has a unique user ID, login credentials, an assigned role and matching access permissions.
Every document has a unique document ID, title, owner, category and upload date, and is linked to its owner and department. Its storage reference must link to a valid database record.
A document can have many versions, each with a unique identifier. Previous versions are kept when a document is updated.
AI classification assigns each document's category from its content and metadata. OCR extracts readable text from supported scanned documents.
Only authorised users can view, modify, approve or sign documents. Documents submitted for approval must follow their assigned approval workflow.
Each electronic signature is linked to the responsible user and document version. All approval decisions and signatures are recorded, and email notifications are sent for relevant workflow activities.
Every document has a retention period. Documents that reach their retention stage follow the organisation's archiving or disposal process.
Important user and document activities are recorded in the audit log. Failed transactions are rolled back so no incomplete updates are saved.
 

Scope

One organisation with made-up records, covering the operations above plus user logins, e-signatures, AI classification, OCR and file-text search, email, advanced workflow automation, retention periods, audit trail and monitoring, activity tracking and archiving. Excluded: government system links and outside sharing.
 