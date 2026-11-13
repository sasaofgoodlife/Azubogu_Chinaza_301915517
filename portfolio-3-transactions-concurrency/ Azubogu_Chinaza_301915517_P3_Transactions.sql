-- Exercise: COMMIT and ROLLBACK
--
-- IMPORTANT:
-- This exercise uses existing EDMS records and constraints.
-- Run the exercise once against the prepared database.
-- The COMMIT operation permanently changes Document 1's
-- retention date from 2031-01-10 to 2032-01-10.
-- =========================================================



-- 1. STARTING-DATA CHECK
-- Check the selected documents and existing versions.

SELECT
    document_id,
    title,
    document_status,
    retention_end_date,
    keywords
FROM document
WHERE document_id IN (1, 2)
ORDER BY document_id;

SELECT
    version_id,
    document_id,
    version_number,
    file_name
FROM document_version
WHERE document_id = 1
ORDER BY version_number;


-- 2. COMMIT TRANSACTION
-- Update the retention date of Document 1.
-- The condition prevents repeating the same update.

BEGIN;

UPDATE document
SET retention_end_date = DATE '2032-01-10'
WHERE document_id = 1
  AND retention_end_date = DATE '2031-01-10'
RETURNING
    document_id,
    title,
    retention_end_date;

COMMIT;


-- Repeat check: the original date should no longer match.

SELECT
    document_id,
    title,
    retention_end_date
FROM document
WHERE document_id = 1
  AND retention_end_date = DATE '2031-01-10';


-- 3. ROLLBACK TRANSACTION
-- First perform a valid temporary update.
-- Then deliberately violate the existing unique constraint
-- on (document_id, version_number).

BEGIN;

-- Valid update inside the transaction.
UPDATE document
SET keywords = keywords || ', rollback-test'
WHERE document_id = 2
RETURNING
    document_id,
    keywords;

-- Deliberate duplicate-version constraint violation.
UPDATE document_version
SET version_number = 1
WHERE version_id = 2;

-- The preceding statement should produce a unique
-- constraint error. The transaction must then be rolled back.
ROLLBACK;


-- 4. FINAL VERIFICATION
-- Confirm that the committed change remains and the
-- temporary update has been reversed.

SELECT
    document_id,
    title,
    retention_end_date,
    keywords
FROM document
WHERE document_id IN (1, 2)
ORDER BY document_id;

SELECT
    version_id,
    document_id,
    version_number,
    file_name
FROM document_version
WHERE document_id = 1
ORDER BY version_number;

