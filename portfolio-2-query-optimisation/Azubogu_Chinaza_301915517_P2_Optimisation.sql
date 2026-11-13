-- =========================================================
-- MIT 8103: ADVANCED DATABASE SYSTEMS
-- PORTFOLIO 2: QUERY PROCESSING AND OPTIMISATION
-- CASE STUDY: ELECTRONIC DOCUMENT MANAGEMENT SYSTEM (EDMS)
-- STUDENT ID: 301915517
-- =========================================================

-- IMPORTANT:
-- Run the setup section ONCE only.
-- The benchmark schema is separate from Portfolio 1.
-- Original EDMS tables and records remain unchanged.

-- =========================================================
-- 1. SETUP: CREATE BENCHMARK SCHEMA AND TABLE
-- =========================================================

CREATE SCHEMA p2_benchmark;

CREATE TABLE p2_benchmark.synthetic_activity_history (
    event_id BIGINT,
    user_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    version_id INTEGER NOT NULL,
    activity_type VARCHAR(40) NOT NULL,
    comments TEXT,
    activity_date TIMESTAMPTZ NOT NULL
);

-- Generate 100,000 synthetic EDMS activity records
-- using existing user, document and version identifiers.

WITH source_ids AS (
    SELECT
        ARRAY(SELECT user_id FROM public.user_account ORDER BY user_id) AS user_ids,
        ARRAY(SELECT document_id FROM public.document ORDER BY document_id) AS document_ids,
        ARRAY(SELECT version_id FROM public.document_version ORDER BY version_id) AS version_ids
),
generated_rows AS (
    SELECT
        g AS event_id,
        s.user_ids[((g - 1) % cardinality(s.user_ids)) + 1] AS user_id,
        s.document_ids[((g - 1) % cardinality(s.document_ids)) + 1] AS document_id,
        s.version_ids[((g - 1) % cardinality(s.version_ids)) + 1] AS version_id,

        CASE (g % 5)
            WHEN 0 THEN 'Upload'
            WHEN 1 THEN 'Review'
            WHEN 2 THEN 'Approval'
            WHEN 3 THEN 'Archive'
            ELSE 'Access'
        END AS activity_type,

        'Synthetic EDMS activity event ' || g AS comments,

        TIMESTAMPTZ '2024-01-01 00:00:00+00'
            + (((g - 1) % 1000) * INTERVAL '1 day')
            + (((g * 37) % 86400) * INTERVAL '1 second')
            AS activity_date

    FROM generate_series(1, 100000) AS g
    CROSS JOIN source_ids s
)

INSERT INTO p2_benchmark.synthetic_activity_history (
    event_id,
    user_id,
    document_id,
    version_id,
    activity_type,
    comments,
    activity_date
)
SELECT
    event_id,
    user_id,
    document_id,
    version_id,
    activity_type,
    comments,
    activity_date
FROM generated_rows;

-- Refresh PostgreSQL statistics.
ANALYZE p2_benchmark.synthetic_activity_history;


-- =========================================================
-- 2. COUNT QUERY
-- =========================================================

SELECT COUNT(*) AS total_generated_records
FROM p2_benchmark.synthetic_activity_history;

-- Expected result: 100,000 records.


-- =========================================================
-- 3. BEFORE-INDEX QUERY PLAN
-- =========================================================

-- Execute once as a warm-up.
-- Then execute three additional times for measurement.
-- Record the three execution times and the top-level
-- shared buffer hits from the third measured execution.

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    event_id,
    user_id,
    document_id,
    version_id,
    activity_type,
    activity_date
FROM p2_benchmark.synthetic_activity_history
WHERE activity_date >= TIMESTAMPTZ '2025-02-04 00:00:00+00'
  AND activity_date < TIMESTAMPTZ '2025-02-14 00:00:00+00'
ORDER BY activity_date;


-- =========================================================
-- 4. CREATE B-TREE INDEX
-- =========================================================

CREATE INDEX idx_synthetic_activity_history_activity_date
ON p2_benchmark.synthetic_activity_history
USING BTREE (activity_date);

-- Refresh statistics after creating the index.
ANALYZE p2_benchmark.synthetic_activity_history;


-- =========================================================
-- 5. AFTER-INDEX QUERY PLAN
-- =========================================================

-- Execute once as a warm-up.
-- Then execute three additional times for measurement.
-- Record the three execution times and the top-level
-- shared buffer hits from the third measured execution.

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    event_id,
    user_id,
    document_id,
    version_id,
    activity_type,
    activity_date
FROM p2_benchmark.synthetic_activity_history
WHERE activity_date >= TIMESTAMPTZ '2025-02-04 00:00:00+00'
  AND activity_date < TIMESTAMPTZ '2025-02-14 00:00:00+00'
ORDER BY activity_date;