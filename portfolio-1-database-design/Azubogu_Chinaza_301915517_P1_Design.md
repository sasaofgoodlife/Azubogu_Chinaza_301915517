# Electronic Document Management System Database Design

## 1. Entities

The database keeps records of six things: **Department**, **User_Account** (staff, logins and roles), **Document**, **Document_Version** (each saved version with its file location and OCR text), **Document_Access** (each user's rights on a document) and **Activity_Record** (reviews, approvals, signatures and other key actions). Six is enough because approvals and audit entries share one activity table.

## 2. Attributes and keys

A primary key (PK) picks out one row. A foreign key (FK) points to a row in another table. An identity column numbers rows by itself. Fields are required unless marked optional.

| **Table** | **Fields** |
|---|---|
| **Department** | `department_id` integer identity PK; `department_name` varchar(100), unique |
| **User_Account** | `user_id` integer identity PK; `department_id` FK; `full_name` varchar(150); `email` varchar(150), unique; `username` varchar(50), unique; `password_hash` text (scrambled password); `role` varchar(40), one of the seven roles; `account_status` varchar(20), Active or Disabled |
| **Document** | `document_id` integer identity PK; `owner_id` FK; `department_id` FK; `title` varchar(200); `category` varchar(100); `keywords` text, optional; `document_status` varchar(30), Active, Archived or Disposed; `upload_date` timestamptz (date and time); `retention_end_date` date, not before the upload date; `checked_out_by` FK, optional; `checked_out_at` timestamptz, optional |
| **Document_Version** | `version_id` integer identity PK; `document_id` FK; `version_number` integer, from 1; `file_name` varchar(255); `storage_reference` text, unique; `uploaded_by` FK; `extracted_text` text, optional; `created_at` timestamptz. A document can't repeat a version number. |
| **Document_Access** | `access_id` integer identity PK; `document_id` FK; `user_id` FK; `can_view`, `can_edit`, `can_approve` and `can_sign` boolean; `granted_by` FK; `date_granted` timestamptz. A user has one access row per document. |
| **Activity_Record** | `activity_id` integer identity PK; `user_id` FK; `document_id` FK, optional; `version_id` FK, optional; `activity_type` varchar(40), such as Login, Upload, Review, Approval, Rejection or Signature; `comments` text, optional; `signature_reference` text, optional; `activity_date` timestamptz |

## 3. Relationships

- A department has zero or many users and documents. Each user and document belongs to one department.
- A user owns zero or many documents and uploads zero or many versions. Each document has one owner and each version one uploader.
- A document has one or many versions, as version 1 is saved with it. Each version belongs to one document.
- `Document_Access` links users and documents many to many. Either side may have no rows yet.
- A user, document or version has zero or many activity records. Each record has one user and may have no document, as with a login.
- A document is checked out by nobody or one user.

## 4. Business rules and constraints

1. The PK and unique email and username stop duplicate users. `password_hash` and `role` are required, and checks limit role and status to agreed values.
2. The PK, required fields and FKs cover this rule. Each `storage_reference` sits on a version row, so every file belongs to a real document.
3. The unique `document_id` and `version_number` pair stops repeats. A key can't stop overwriting, so every edit adds a new version row.
4. `category` holds the AI result and `extracted_text` the OCR result. The AI and OCR run in the application.
5. Access rows and roles are checked before anyone views, edits, approves or signs. A key can't enforce workflow order, so the application checks review comes before approval.
6. Decisions and signatures are saved in `Activity_Record` with the user and version. A check requires `signature_reference` for Signature rows. The application sends emails.
7. `retention_end_date` is required. A policy uploaded on 15 January 2026 and kept five years ends on 15 January 2031, when the application archives or disposes of it.
8. Each key action adds an `Activity_Record` row. Transactions use COMMIT to save changes together and ROLLBACK to cancel them if one fails. **Note:** this is a database feature, not a business rule.

## 5. Design assumptions

1. Each user has one role and belongs to one department.
2. Files are stored outside the database; only their location is saved.
3. Email, AI, OCR and signature checking run in the application; the database stores their results.