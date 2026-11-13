-- EDMS Sample Data
-- Fictional records for testing the six tables.

BEGIN;

-- 1. Departments

INSERT INTO public.department (department_name)
VALUES
    ('Finance'),
    ('Human Resources'),
    ('Information Technology');

-- 2. User Accounts

INSERT INTO public.user_account (
    department_id,
    full_name,
    email,
    username,
    password_hash,
    role,
    account_status
)
VALUES
(
    (SELECT department_id FROM public.department
     WHERE department_name = 'Information Technology'),
    'Daniel Okoro',
    'daniel.okoro@example.com',
    'daniel_admin',
    'demo_hash_not_for_login',
    'System Administrator',
    'Active'
),
(
    (SELECT department_id FROM public.department
     WHERE department_name = 'Finance'),
    'Ada Okafor',
    'ada.okafor@example.com',
    'ada_creator',
    'demo_hash_not_for_login',
    'Document Creator',
    'Active'
),
(
    (SELECT department_id FROM public.department
     WHERE department_name = 'Human Resources'),
    'Michael Eze',
    'michael.eze@example.com',
    'michael_reviewer',
    'demo_hash_not_for_login',
    'Document Reviewer',
    'Active'
),
(
    (SELECT department_id FROM public.department
     WHERE department_name = 'Finance'),
    'Grace Bello',
    'grace.bello@example.com',
    'grace_approver',
    'demo_hash_not_for_login',
    'Document Approver',
    'Active'
),
(
    (SELECT department_id FROM public.department
     WHERE department_name = 'Human Resources'),
    'Samuel Obi',
    'samuel.obi@example.com',
    'samuel_employee',
    'demo_hash_not_for_login',
    'General Employee',
    'Disabled'
);

-- 3. Documents

INSERT INTO public.document (
    owner_id,
    department_id,
    title,
    category,
    keywords,
    document_status,
    upload_date,
    retention_end_date,
    checked_out_by,
    checked_out_at
)
VALUES
(
    (SELECT user_id FROM public.user_account
     WHERE username = 'ada_creator'),
    (SELECT department_id FROM public.department
     WHERE department_name = 'Finance'),
    'Annual Financial Policy',
    'Policy',
    'finance, policy, annual',
    'Active',
    '2026-01-10 09:00:00+01',
    '2031-01-10',
    (SELECT user_id FROM public.user_account
     WHERE username = 'ada_creator'),
    '2026-11-10 10:00:00+01'
),
(
    (SELECT user_id FROM public.user_account
     WHERE username = 'michael_reviewer'),
    (SELECT department_id FROM public.department
     WHERE department_name = 'Human Resources'),
    'Staff Recruitment Guidelines',
    'Guideline',
    'staff, recruitment, HR',
    'Archived',
    '2024-02-15 10:00:00+01',
    '2025-02-15',
    NULL,
    NULL
),
(
    (SELECT user_id FROM public.user_account
     WHERE username = 'ada_creator'),
    (SELECT department_id FROM public.department
     WHERE department_name = 'Finance'),
    'Old Expense Procedure',
    'Procedure',
    'expenses, finance, procedure',
    'Disposed',
    '2020-03-01 08:00:00+01',
    '2025-03-01',
    NULL,
    NULL
);

-- 4. Document Versions

INSERT INTO public.document_version (
    document_id,
    version_number,
    file_name,
    storage_reference,
    uploaded_by,
    extracted_text,
    created_at
)
VALUES
(
    (SELECT document_id FROM public.document
     WHERE title = 'Annual Financial Policy'),
    1,
    'financial_policy_v1.pdf',
    'EDMS/FIN/FINPOLICY/V1',
    (SELECT user_id FROM public.user_account
     WHERE username = 'ada_creator'),
    'Initial annual financial policy.',
    '2026-01-10 09:00:00+01'
),
(
    (SELECT document_id FROM public.document
     WHERE title = 'Annual Financial Policy'),
    2,
    'financial_policy_v2.pdf',
    'EDMS/FIN/FINPOLICY/V2',
    (SELECT user_id FROM public.user_account
     WHERE username = 'ada_creator'),
    'Updated annual financial policy.',
    '2026-02-10 11:00:00+01'
),
(
    (SELECT document_id FROM public.document
     WHERE title = 'Staff Recruitment Guidelines'),
    1,
    'recruitment_guidelines.pdf',
    'EDMS/HR/RECRUITMENT/V1',
    (SELECT user_id FROM public.user_account
     WHERE username = 'michael_reviewer'),
    'Staff recruitment guidelines.',
    '2024-02-15 10:00:00+01'
),
(
    (SELECT document_id FROM public.document
     WHERE title = 'Old Expense Procedure'),
    1,
    'old_expense_procedure.pdf',
    'EDMS/FIN/EXPENSE/V1',
    (SELECT user_id FROM public.user_account
     WHERE username = 'ada_creator'),
    'Previous expense procedure.',
    '2020-03-01 08:00:00+01'
);

-- 5. Document Access

INSERT INTO public.document_access (
    document_id,
    user_id,
    can_view,
    can_edit,
    can_approve,
    can_sign,
    granted_by,
    date_granted
)
VALUES
(
    (SELECT document_id FROM public.document
     WHERE title = 'Annual Financial Policy'),
    (SELECT user_id FROM public.user_account
     WHERE username = 'michael_reviewer'),
    TRUE, FALSE, TRUE, FALSE,
    (SELECT user_id FROM public.user_account
     WHERE username = 'daniel_admin'),
    '2026-01-11 09:00:00+01'
),
(
    (SELECT document_id FROM public.document
     WHERE title = 'Annual Financial Policy'),
    (SELECT user_id FROM public.user_account
     WHERE username = 'grace_approver'),
    TRUE, FALSE, TRUE, TRUE,
    (SELECT user_id FROM public.user_account
     WHERE username = 'daniel_admin'),
    '2026-01-11 09:30:00+01'
),
(
    (SELECT document_id FROM public.document
     WHERE title = 'Staff Recruitment Guidelines'),
    (SELECT user_id FROM public.user_account
     WHERE username = 'samuel_employee'),
    TRUE, FALSE, FALSE, FALSE,
    (SELECT user_id FROM public.user_account
     WHERE username = 'daniel_admin'),
    '2024-02-16 09:00:00+01'
);

-- 6. Activity Records

INSERT INTO public.activity_record (
    user_id,
    document_id,
    version_id,
    activity_type,
    comments,
    signature_reference,
    activity_date
)
VALUES
(
    (SELECT user_id FROM public.user_account
     WHERE username = 'ada_creator'),
    (SELECT document_id FROM public.document
     WHERE title = 'Annual Financial Policy'),
    (SELECT version_id FROM public.document_version
     WHERE storage_reference = 'EDMS/FIN/FINPOLICY/V1'),
    'Upload',
    'Initial document uploaded.',
    NULL,
    '2026-01-10 09:00:00+01'
),
(
    (SELECT user_id FROM public.user_account
     WHERE username = 'michael_reviewer'),
    (SELECT document_id FROM public.document
     WHERE title = 'Annual Financial Policy'),
    (SELECT version_id FROM public.document_version
     WHERE storage_reference = 'EDMS/FIN/FINPOLICY/V2'),
    'Review',
    'Document reviewed.',
    NULL,
    '2026-02-11 10:00:00+01'
),
(
    (SELECT user_id FROM public.user_account
     WHERE username = 'grace_approver'),
    (SELECT document_id FROM public.document
     WHERE title = 'Annual Financial Policy'),
    (SELECT version_id FROM public.document_version
     WHERE storage_reference = 'EDMS/FIN/FINPOLICY/V2'),
    'Signature',
    'Document approved and signed.',
    'SIGN-EDMS-2026-001',
    '2026-02-12 12:00:00+01'
),
(
    (SELECT user_id FROM public.user_account
     WHERE username = 'daniel_admin'),
    NULL,
    NULL,
    'Login',
    'System administrator logged in.',
    NULL,
    '2026-02-12 08:00:00+01'
);

COMMIT;