-- QUERY 1: RETRIEVE ACTIVE DOCUMENTS

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


-- QUERY 2: FIND DOCUMENTS WITHOUT ACCESS PERMISSIONS

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


-- QUERY 3: COUNT ACCESS PERMISSIONS PER DOCUMENT

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
