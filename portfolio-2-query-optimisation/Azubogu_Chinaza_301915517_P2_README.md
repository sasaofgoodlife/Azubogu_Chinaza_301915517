# Portfolio 2 Query Processing and Optimisation

## Queries and results

The Electronic Document Management System (EDMS) database was used to demonstrate query processing and optimisation.

Three SQL queries were executed:

1. **Active Documents:** Retrieved active documents together with their owners and departments. Result: 1 row.
2. **Document Version History:** Retrieved document versions and the users who uploaded them. Result: 4 rows.
3. **Document Access Permissions:** Retrieved document access permissions, including viewing, editing, approval and signing rights. Result: 3 rows.

For the indexing demonstration, a separate `p2_benchmark` schema was created with a synthetic activity-history table containing 100,000 records. Existing EDMS user, document and version identifiers were reused. The selected date-range query returned 1,000 records.

## Index comparison

A B-tree index was created on the `activity_date` column.

| Measure | Before Indexing | After Indexing |
|---|---|---|
| Scan type | Sequential Scan | Bitmap Index Scan and Bitmap Heap Scan |
| Execution times | 8.852 ms (one observed run) | 2.245 ms, 0.620 ms, 0.600 ms |
| Median execution time | Not available | 0.620 ms |
| Top-level shared buffer hits | 1,249 | 152 (third observed run) |

## Performance analysis

Before indexing, PostgreSQL used a Sequential Scan and Sort to retrieve the matching records. The plan returned 1,000 rows and removed 99,000 rows through filtering, with an observed execution time of 8.852 ms. After creating the B-tree index, PostgreSQL used a Bitmap Index Scan followed by a Bitmap Heap Scan and Sort. The three observed after-index execution times were 2.245 ms, 0.620 ms and 0.600 ms. The third run recorded 152 top-level shared buffer hits. These results demonstrate that PostgreSQL selected the new index for this date-range query. However, the before-index phase has only one recorded execution, so a three-run median comparison cannot be calculated. Cache warming and other execution conditions may also affect timings. Indexes require additional storage and introduce overhead during inserts, updates and deletes. Therefore, an index does not guarantee faster execution for every query.


## Files

### SQL Scripts

- [Portfolio 2 Queries](Azubogu_Chinaza_301915517_P2_Queries.sql)
- [Portfolio 2 Optimisation](Azubogu_Chinaza_301915517_P2_Optimisation.sql)

### Screenshots

- [Query Results](Screenshots/Azubogu_Chinaza_301915517_P2_QueryResults.png)
- [Before Indexing Execution Plan](Screenshots/Azubogu_Chinaza_301915517_P2_BeforeIndex.png)
- [After Indexing Execution Plan](Screenshots/Azubogu_Chinaza_301915517_P2_AfterIndex.png)