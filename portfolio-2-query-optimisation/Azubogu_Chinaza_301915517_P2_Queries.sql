-- =========================================================
-- MIT 8103: ADVANCED DATABASE SYSTEMS
-- PORTFOLIO 2: QUERY PROCESSING AND OPTIMISATION
-- Database: edms_portfolio
-- Case Study: Electronic Document Management System (EDMS)
-- =========================================================


-- =========================================================
-- QUERY 1: RETRIEVE ACTIVE DOCUMENTS
-- Joins document, user_account and department.
-- Filters documents with Active status.
-- =========================================================

SELECT
    d.document_id,
    d.title,
    d.category,
    u.full_name AS document_owner,
    dep.department_name,
    d.upload_date,
    d.document_status
FROM document d
JOIN user_account u
    ON d.owner_id = u.user_id
JOIN department dep
    ON d.department_id = dep.department_id
WHERE d.document_status = 'Active'
ORDER BY
    d.upload_date DESC,
    d.document_id ASC;


-- =========================================================
-- QUERY 2: FIND DOCUMENTS WITHOUT ACCESS PERMISSIONS
-- Uses NOT EXISTS to identify documents without
-- corresponding records in document_access.
-- =========================================================

SELECT
    d.document_id,
    d.title,
    d.category,
    d.document_status
FROM document d
WHERE NOT EXISTS (
    SELECT 1
    FROM document_access da
    WHERE da.document_id = d.document_id
)
ORDER BY
    d.document_id ASC;


-- =========================================================
-- QUERY 3: COUNT ACCESS PERMISSIONS PER DOCUMENT
-- Uses LEFT JOIN to retain documents with zero
-- access permission records.
-- =========================================================

SELECT
    d.document_id,
    d.title,
    COUNT(da.access_id) AS access_permission_count
FROM document d
LEFT JOIN document_access da
    ON d.document_id = da.document_id
GROUP BY
    d.document_id,
    d.title
ORDER BY
    d.document_id ASC;


-- =========================================================
-- END OF PORTFOLIO 2 QUERIES
-- =========================================================