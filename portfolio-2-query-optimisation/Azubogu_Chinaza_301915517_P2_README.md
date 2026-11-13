# Portfolio 2: Query Processing and Optimisation

**Case Study:** Electronic Document Management System (EDMS)  
**Database:** `edms_portfolio`

## 1. Introduction

This portfolio demonstrates SQL query processing and optimisation using the Electronic Document Management System (EDMS) database developed in Portfolio 1.

Three SQL queries were executed to retrieve active documents, examine document version history, and review document access permissions.

A separate benchmark schema containing 100,000 synthetic EDMS activity records was also created to evaluate the effect of B-tree indexing on query performance.

## 2. Queries and Results

### Query 1: Retrieve Active Documents

This query joins the `document`, `user_account`, and `department` tables to retrieve active documents alongside their owners and departments.

**Result:** 1 row returned.

### Query 2: Retrieve Document Version History

This query joins the `document`, `document_version`, and `user_account` tables to retrieve document versions, filenames, uploaders, and creation dates.

**Result:** 4 rows returned.

### Query 3: Retrieve Document Access Permissions

This query joins the `document`, `document_access`, and `user_account` tables to retrieve access permissions, including viewing, editing, approval, and signing rights.

**Result:** 3 rows returned.

## 3. Indexing and Query Optimisation

A separate schema named `p2_benchmark` was created to conduct the performance experiment without modifying the original EDMS tables.

A synthetic activity-history table containing 100,000 records was generated using existing EDMS user, document, and document-version identifiers.

A date-range query was executed before and after creating a B-tree index on the `activity_date` column.

### Index Comparison

| Measure | Before Indexing | After Indexing |
|---|---|---|
| Scan type | Sequential Scan | Bitmap Index Scan and Bitmap Heap Scan |
| Execution time | 8.852 ms (one observed run) | 2.245 ms, 0.620 ms, 0.600 ms |
| Median execution time | Not available | 0.620 ms |
| Top-level shared buffer hits | 1,249 | 152 (third observed run) |

### Performance Analysis

Before indexing, PostgreSQL used a Sequential Scan and Sort to retrieve the matching records. The execution plan returned 1,000 rows and removed 99,000 rows through filtering. The observed execution time was 8.852 ms.

After creating the B-tree index, PostgreSQL used a Bitmap Index Scan followed by a Bitmap Heap Scan and Sort. The three observed execution times were 2.245 ms, 0.620 ms, and 0.600 ms. The third run recorded 152 top-level shared buffer hits.

These results demonstrate that PostgreSQL selected the new index for the date-range query.

However, only one execution time was recorded before indexing, so a three-run median comparison cannot be calculated. Cache warming and other execution conditions may also influence the results.

Although indexes can improve retrieval performance, they require additional storage and introduce overhead during insert, update, and delete operations. Therefore, indexing should be applied selectively based on query patterns and workload requirements.

## 4. Files and Evidence

### SQL Scripts

- [Portfolio 2 Queries](Azubogu_Chinaza_301915517_P2_Queries.sql)
- [Portfolio 2 Optimisation](Azubogu_Chinaza_301915517_P2_Optimisation.sql)

### Screenshots

- [Query Results](Screenshots/Azubogu_Chinaza_301915517_P2_QueryResults.png)
- [Before Indexing Execution Plan](Screenshots/Azubogu_Chinaza_301915517_P2_BeforeIndex.png)
- [After Indexing Execution Plan](Screenshots/Azubogu_Chinaza_301915517_P2_AfterIndex.png)

## 5. Conclusion

The portfolio demonstrates the use of relational SQL queries, joins, filtering, and query execution plans in PostgreSQL.

The indexing experiment illustrates how a B-tree index can improve the retrieval of records within a selected date range. It also highlights the importance of execution-plan analysis and the trade-offs associated with indexing.

The original EDMS database was preserved, while the performance experiment was conducted in a separate benchmark schema.