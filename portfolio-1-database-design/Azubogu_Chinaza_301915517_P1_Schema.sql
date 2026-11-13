--Electronic Document Management System (EDMS)
 
-- PostgreSQL 16 Database Schema
 
BEGIN;
 
-- 1. Department
 
CREATE TABLE public.department (
 
    department_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 
    department_name VARCHAR(100) NOT NULL UNIQUE
 
);
 
-- 2. User Account
 
CREATE TABLE public.user_account (
 
    user_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 
    department_id INTEGER NOT NULL,
 
    full_name VARCHAR(150) NOT NULL,
 
    email VARCHAR(150) NOT NULL UNIQUE,
 
    username VARCHAR(50) NOT NULL UNIQUE,
 
    password_hash TEXT NOT NULL,
 
    role VARCHAR(40) NOT NULL,
 
    account_status VARCHAR(20) NOT NULL,
 
    CONSTRAINT fk_user_department
 
        FOREIGN KEY (department_id)
 
        REFERENCES public.department(department_id),
 
    CONSTRAINT chk_user_role
 
        CHECK (role IN (
 
            'System Administrator',
 
            'Department Administrator',
 
            'Document Creator',
 
            'Document Reviewer',
 
            'Document Approver',
 
            'General Employee',
 
            'Auditor'
        )),
 
    CONSTRAINT chk_account_status
 
        CHECK (account_status IN ('Active', 'Disabled'))
 
);
 
-- 3. Document
 
CREATE TABLE public.document (
 
    document_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 
    owner_id INTEGER NOT NULL,
 
    department_id INTEGER NOT NULL,
 
    title VARCHAR(200) NOT NULL,
 
    category VARCHAR(100) NOT NULL,
 
    keywords TEXT,
 
    document_status VARCHAR(30) NOT NULL,
 
    upload_date TIMESTAMPTZ NOT NULL,
 
    retention_end_date DATE NOT NULL,
 
    checked_out_by INTEGER,
 
    checked_out_at TIMESTAMPTZ,
 
    CONSTRAINT fk_document_owner
 
        FOREIGN KEY (owner_id)
 
        REFERENCES public.user_account(user_id),
 
    CONSTRAINT fk_document_department
 
        FOREIGN KEY (department_id)
 
        REFERENCES public.department(department_id),
 
    CONSTRAINT fk_document_checked_out_by
 
        FOREIGN KEY (checked_out_by)
 
        REFERENCES public.user_account(user_id),
 
    CONSTRAINT chk_document_status
 
        CHECK (document_status IN (
 
            'Active',
 
            'Archived',
 
            'Disposed'
 
        )),
 
    CONSTRAINT chk_retention_date
 
        CHECK (retention_end_date >= upload_date::DATE)
 
);
 
-- 4. Document Version
 
CREATE TABLE public.document_version (
 
    version_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 
    document_id INTEGER NOT NULL,
 
    version_number INTEGER NOT NULL,
 
    file_name VARCHAR(255) NOT NULL,
 
    storage_reference TEXT NOT NULL UNIQUE,
 
    uploaded_by INTEGER NOT NULL,
 
    extracted_text TEXT,
 
    created_at TIMESTAMPTZ NOT NULL,
 
    CONSTRAINT fk_version_document
 
        FOREIGN KEY (document_id)
 
        REFERENCES public.document(document_id),
 
    CONSTRAINT fk_version_uploader
 
        FOREIGN KEY (uploaded_by)
 
        REFERENCES public.user_account(user_id),
 
    CONSTRAINT chk_version_number
 
        CHECK (version_number >= 1),
 
    CONSTRAINT uq_document_version
 
        UNIQUE (document_id, version_number)
 
);
 
-- 5. Document Access
 
CREATE TABLE public.document_access (
 
    access_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 
    document_id INTEGER NOT NULL,
 
    user_id INTEGER NOT NULL,
 
    can_view BOOLEAN NOT NULL,
 
    can_edit BOOLEAN NOT NULL,
 
    can_approve BOOLEAN NOT NULL,
 
    can_sign BOOLEAN NOT NULL,
 
    granted_by INTEGER NOT NULL,
 
    date_granted TIMESTAMPTZ NOT NULL,
 
    CONSTRAINT fk_access_document
 
        FOREIGN KEY (document_id)
 
        REFERENCES public.document(document_id),
 
    CONSTRAINT fk_access_user
 
        FOREIGN KEY (user_id)
 
        REFERENCES public.user_account(user_id),
 
    CONSTRAINT fk_access_granted_by
 
        FOREIGN KEY (granted_by)
 
        REFERENCES public.user_account(user_id),
 
    CONSTRAINT uq_document_user_access
 
        UNIQUE (document_id, user_id)
 
);
 
-- 6. Activity Record
 
CREATE TABLE public.activity_record (
 
    activity_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 
    user_id INTEGER NOT NULL,
 
    document_id INTEGER,
 
    version_id INTEGER,
 
    activity_type VARCHAR(40) NOT NULL,
 
    comments TEXT,
 
    signature_reference TEXT,
 
    activity_date TIMESTAMPTZ NOT NULL,
 
    CONSTRAINT fk_activity_user
 
        FOREIGN KEY (user_id)
 
        REFERENCES public.user_account(user_id),
 
    CONSTRAINT fk_activity_document
 
        FOREIGN KEY (document_id)
 
        REFERENCES public.document(document_id),
 
    CONSTRAINT fk_activity_version
 
        FOREIGN KEY (version_id)
 
        REFERENCES public.document_version(version_id),
 
    -- Signature activities require a signature reference.
 
    CONSTRAINT chk_signature_reference
 
        CHECK (
 
            activity_type <> 'Signature'
 
            OR signature_reference IS NOT NULL
 
        )
 
);
 
-- Business rules requiring application-level validation:
 
-- 1. Each document must have at least one version.
 
-- 2. Review must take place before approval.
 
-- 3. Checkout user and checkout date must remain consistent.
 
-- 4. Access permissions and assigned roles must be checked
 
--    before document operations are allowed.
 
-- 5. Document archiving and disposal require retention
 
--    policy processing.
 
-- 6. OCR, AI processing, email and signature verification
 
--    are handled by the application.
 
-- 7. Related operations should use transactions so that
 
--    COMMIT or ROLLBACK maintains consistency.
 
COMMIT;
 
 
 
 