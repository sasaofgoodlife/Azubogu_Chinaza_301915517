-- MIT 8103: Advanced Database Systems
-- Portfolio 1: Database Design and Modelling
-- EDMS Negative Constraint Tests
-- Student ID: 301915517
--
-- IMPORTANT:
-- 1. Run SampleData.sql first.
-- 2. Execute each INSERT statement separately.
-- 3. Each statement should produce an expected database ERROR.
-- 4. Do not place these statements inside BEGIN/COMMIT.


-- =====================================================
-- 1. DEPARTMENT CONSTRAINTS
-- =====================================================

-- Test 01: Department name cannot be NULL.
INSERT INTO department (department_name)
VALUES (NULL);


-- Test 02: Duplicate department name is not allowed.
INSERT INTO department (department_name)
SELECT department_name
FROM department
LIMIT 1;


-- =====================================================
-- 2. USER ACCOUNT CONSTRAINTS
-- =====================================================

-- Test 03: User full name cannot be NULL.
INSERT INTO user_account
(department_id, full_name, email, username, password_hash, role, account_status)
SELECT department_id, NULL, 'negative_test_03@example.com',
       'negative_test_03', password_hash, role, account_status
FROM user_account
LIMIT 1;


-- Test 04: Duplicate user email is not allowed.
INSERT INTO user_account
(department_id, full_name, email, username, password_hash, role, account_status)
SELECT department_id, full_name, email,
       'negative_test_04', password_hash, role, account_status
FROM user_account
LIMIT 1;


-- Test 05: Duplicate username is not allowed.
INSERT INTO user_account
(department_id, full_name, email, username, password_hash, role, account_status)
SELECT department_id, full_name, 'negative_test_05@example.com',
       username, password_hash, role, account_status
FROM user_account
LIMIT 1;


-- Test 06: Invalid user role is rejected.
INSERT INTO user_account
(department_id, full_name, email, username, password_hash, role, account_status)
SELECT department_id, full_name, 'negative_test_06@example.com',
       'negative_test_06', password_hash, 'InvalidRole', account_status
FROM user_account
LIMIT 1;


-- Test 07: Invalid account status is rejected.
INSERT INTO user_account
(department_id, full_name, email, username, password_hash, role, account_status)
SELECT department_id, full_name, 'negative_test_07@example.com',
       'negative_test_07', password_hash, role, 'Suspended'
FROM user_account
LIMIT 1;


-- Test 08: Invalid department foreign key is rejected.
INSERT INTO user_account
(department_id, full_name, email, username, password_hash, role, account_status)
SELECT -999999, full_name, 'negative_test_08@example.com',
       'negative_test_08', password_hash, role, account_status
FROM user_account
LIMIT 1;


-- =====================================================
-- 3. DOCUMENT CONSTRAINTS
-- =====================================================

-- Test 09: Invalid document status is rejected.
INSERT INTO document
(owner_id, department_id, title, category, document_status,
 upload_date, retention_end_date)
SELECT owner_id, department_id, 'Negative Test 09',
       category, 'InvalidStatus', upload_date, retention_end_date
FROM document
LIMIT 1;


-- Test 10: Retention end date cannot be earlier than upload date.
INSERT INTO document
(owner_id, department_id, title, category, document_status,
 upload_date, retention_end_date)
SELECT owner_id, department_id, 'Negative Test 10',
       category, document_status, upload_date, upload_date - 1
FROM document
LIMIT 1;


-- Test 11: Invalid document owner foreign key is rejected.
INSERT INTO document
(owner_id, department_id, title, category, document_status,
 upload_date, retention_end_date)
SELECT -999999, department_id, 'Negative Test 11',
       category, document_status, upload_date, retention_end_date
FROM document
LIMIT 1;


-- Test 12: Invalid document department foreign key is rejected.
INSERT INTO document
(owner_id, department_id, title, category, document_status,
 upload_date, retention_end_date)
SELECT owner_id, -999999, 'Negative Test 12',
       category, document_status, upload_date, retention_end_date
FROM document
LIMIT 1;


-- Test 13: Invalid checked-out user foreign key is rejected.
INSERT INTO document
(owner_id, department_id, title, category, document_status,
 upload_date, retention_end_date, checked_out_by)
SELECT owner_id, department_id, 'Negative Test 13',
       category, document_status, upload_date, retention_end_date, -999999
FROM document
LIMIT 1;


-- =====================================================
-- 4. DOCUMENT VERSION CONSTRAINTS
-- =====================================================

-- Test 14: Duplicate version number for the same document is rejected.
INSERT INTO document_version
(document_id, version_number, file_name, storage_reference,
 uploaded_by, created_at)
SELECT document_id, version_number, 'negative_test_14.pdf',
       'negative_test_14_storage', uploaded_by, CURRENT_TIMESTAMP
FROM document_version
LIMIT 1;


-- Test 15: Version number must be greater than zero.
INSERT INTO document_version
(document_id, version_number, file_name, storage_reference,
 uploaded_by, created_at)
SELECT document_id, 0, 'negative_test_15.pdf',
       'negative_test_15_storage', uploaded_by, CURRENT_TIMESTAMP
FROM document_version
LIMIT 1;


-- Test 16: Invalid version uploader foreign key is rejected.
INSERT INTO document_version
(document_id, version_number, file_name, storage_reference,
 uploaded_by, created_at)
SELECT document_id, version_number + 100,
       'negative_test_16.pdf', 'negative_test_16_storage',
       -999999, CURRENT_TIMESTAMP
FROM document_version
LIMIT 1;


-- Test 17: Duplicate storage reference is not allowed.
INSERT INTO document_version
(document_id, version_number, file_name, storage_reference,
 uploaded_by, created_at)
SELECT document_id, version_number + 100,
       'negative_test_17.pdf', storage_reference,
       uploaded_by, CURRENT_TIMESTAMP
FROM document_version
LIMIT 1;


-- Test 18: Invalid document version foreign key is rejected.
INSERT INTO document_version
(document_id, version_number, file_name, storage_reference,
 uploaded_by, created_at)
SELECT -999999, 1, 'negative_test_18.pdf',
       'negative_test_18_storage', uploaded_by, CURRENT_TIMESTAMP
FROM document_version
LIMIT 1;


-- =====================================================
-- 5. DOCUMENT ACCESS CONSTRAINTS
-- =====================================================

-- Test 19: Duplicate document-user access combination is rejected.
INSERT INTO document_access
(document_id, user_id, can_view, can_edit, can_approve,
 can_sign, granted_by, date_granted)
SELECT document_id, user_id, can_view, can_edit, can_approve,
       can_sign, granted_by, CURRENT_TIMESTAMP
FROM document_access
LIMIT 1;


-- Test 20: Invalid access document foreign key is rejected.
INSERT INTO document_access
(document_id, user_id, can_view, can_edit, can_approve,
 can_sign, granted_by, date_granted)
SELECT -999999, user_id, can_view, can_edit, can_approve,
       can_sign, granted_by, CURRENT_TIMESTAMP
FROM document_access
LIMIT 1;


-- Test 21: Invalid access user foreign key is rejected.
INSERT INTO document_access
(document_id, user_id, can_view, can_edit, can_approve,
 can_sign, granted_by, date_granted)
SELECT document_id, -999999, can_view, can_edit, can_approve,
       can_sign, granted_by, CURRENT_TIMESTAMP
FROM document_access
LIMIT 1;


-- Test 22: Invalid access granted-by foreign key is rejected.
INSERT INTO document_access
(document_id, user_id, can_view, can_edit, can_approve,
 can_sign, granted_by, date_granted)
SELECT document_id, user_id, can_view, can_edit, can_approve,
       can_sign, -999999, CURRENT_TIMESTAMP
FROM document_access
LIMIT 1;


-- =====================================================
-- 6. ACTIVITY RECORD CONSTRAINTS
-- =====================================================

-- Test 23: Invalid activity user foreign key is rejected.
INSERT INTO activity_record
(user_id, document_id, version_id, activity_type, comments, activity_date)
SELECT -999999, document_id, version_id, activity_type,
       'Negative test 23', CURRENT_TIMESTAMP
FROM activity_record
LIMIT 1;


-- Test 24: Invalid activity document foreign key is rejected.
INSERT INTO activity_record
(user_id, document_id, version_id, activity_type, comments, activity_date)
SELECT user_id, -999999, version_id, activity_type,
       'Negative test 24', CURRENT_TIMESTAMP
FROM activity_record
LIMIT 1;


-- Test 25: Invalid activity version foreign key is rejected.
INSERT INTO activity_record
(user_id, document_id, version_id, activity_type, comments, activity_date)
SELECT user_id, document_id, -999999, activity_type,
       'Negative test 25', CURRENT_TIMESTAMP
FROM activity_record
LIMIT 1;


-- Test 26: Signature activity requires a signature reference.
INSERT INTO activity_record
(user_id, document_id, version_id, activity_type,
 comments, signature_reference, activity_date)
SELECT user_id, document_id, version_id, 'Signature',
       'Negative test 26', NULL, CURRENT_TIMESTAMP
FROM activity_record
LIMIT 1;


-- END OF 26 NEGATIVE CONSTRAINT TESTS
