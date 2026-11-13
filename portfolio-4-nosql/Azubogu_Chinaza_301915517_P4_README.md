# NoSQL and Advanced Data Models

**Case Study:** Electronic Document Management System (EDMS)  
**Database:** MongoDB  

---

## Document model

This portfolio implements a MongoDB document model for the Electronic Document Management System (EDMS) case study used in the previous portfolios.

The database is named `edms_nosql` and contains one collection, `activity_events`. Each document represents one EDMS activity event.

The model uses shared fields for the event identifier, event type and event time. Related actor and document information is stored in embedded documents, while the `details` section contains information specific to each event type.

### Document structure

| Field | Description | Example |
|---|---|---|
| `_id` | Unique event identifier | EDMS-E001 |
| `event_type` | Identifies the activity type | document_version_created |
| `event_time` | Date and time of the event | 2026-01-10 |
| `actor` | Embedded user information | Ada Okafor |
| `document` | Embedded document information | Annual Financial Policy |
| `details` | Event-specific information | Version number or permission review |

Two event types were implemented:

1. `document_version_created` – records when a new document version is created.
2. `document_permission_reviewed` – records when document access permissions are reviewed.

The four fictional event documents use relevant identifiers and document details from the existing EDMS records. These MongoDB examples were entered separately and were not automatically extracted from or synchronized with PostgreSQL.

### Example document

The following example represents a completed permission review for the Annual Financial Policy.

```javascript
{
  _id: "EDMS-E003",
  event_type: "document_permission_reviewed",
  event_time: ISODate("2026-02-01T10:00:00Z"),
  actor: {
    user_id: 2,
    full_name: "Ada Okafor"
  },
  document: {
    document_id: 1,
    title: "Annual Financial Policy"
  },
  details: {
    review_type: "document_access_review",
    permissions_checked: ["view", "approve", "sign"],
    review_status: "completed"
  }
}
```

---

## Implementation and results

MongoDB was installed and configured in the Ubuntu GitHub Codespaces environment.

### Environment configuration

| Configuration | Details |
|---|---|
| Operating System | Ubuntu 24.04 |
| MongoDB Server | 8.0.38 |
| MongoDB Shell | 2.14.2 |
| Database | edms_nosql |
| Collection | activity_events |
| Connection | mongodb://127.0.0.1:27017 |
| Storage Directory | /workspaces/mongodb-data |

The MongoDB connection was verified successfully using the database version and ping commands.

### Database and collection setup

The database was selected using:

```javascript
db = db.getSiblingDB("edms_nosql");
```

The collection was checked before inserting records:

```javascript
db.activity_events.countDocuments();
```

The actual result was:

```text
0
```

This confirmed that the collection was empty before insertion.

### Document insertion

Four fictional EDMS activity documents were inserted into the `activity_events` collection using MongoDB's `insertMany()` operation.

MongoDB acknowledged the insertion successfully and returned the following identifiers:

- EDMS-E001
- EDMS-E002
- EDMS-E003
- EDMS-E004

### Query results

Three MongoDB queries were executed successfully.

| Query | Description | Actual Result |
|---|---|---|
| Total event count | Counts all documents in the collection | 4 documents |
| Document event history | Retrieves events associated with document ID 1 in chronological order | 3 documents |
| Nested-field filter | Retrieves events where `details.review_status` is `completed` | 2 documents |

### Query 1: Total event count

```javascript
db.activity_events.countDocuments();
```

**Actual result:** 4 documents.

This confirmed that all four activity-event documents were stored successfully.

### Query 2: Document event history

```javascript
db.activity_events.find(
  { "document.document_id": 1 }
).sort(
  { event_time: 1 }
);
```

**Actual result:** Three records were returned:

- EDMS-E001 – First version created.
- EDMS-E002 – Second version created.
- EDMS-E003 – Permission review completed.

The results were displayed in chronological order for the Annual Financial Policy.

### Query 3: Nested-field filtering

```javascript
db.activity_events.find(
  { "details.review_status": "completed" }
);
```

**Actual result:** Two records were returned:

- EDMS-E003
- EDMS-E004

Both records contained `review_status: "completed"` inside the embedded `details` document.

These results demonstrate MongoDB's ability to retrieve records using nested document fields.

### Screenshot evidence

The screenshot below provides evidence of the four inserted documents and the three successfully executed queries.

![MongoDB Events and Query Results](Screenshots/Azubogu_Chinaza_301915517_P4_EventsAndQueries.png)

---

## Why MongoDB fits

MongoDB is suitable for the EDMS activity-event model because it supports flexible document structures and embedded data.

Different event types can contain different information without requiring every event to have identical fields. For example, a document-version event stores version numbers and file information, while a permission-review event stores the permissions checked and review status.

Embedding actor and document information within each event also makes related information available in a single document.

MongoDB supports nested-field queries and chronological sorting, as demonstrated by the three queries executed in this portfolio.

### Limitation

Embedded copies of user and document information may become outdated when the original records change in the main EDMS database.

This implementation also does not provide automatic synchronization or enforce PostgreSQL foreign-key relationships. Additional validation and application-level controls would be required in a production environment.

---

## Files

### MongoDB implementation

- [Azubogu_Chinaza_301915517_P4_MongoDB.js](Azubogu_Chinaza_301915517_P4_MongoDB.js)

### MongoDB setup notes

- [Azubogu_Chinaza_301915517_P4_Setup.md](Azubogu_Chinaza_301915517_P4_Setup.md)

### Screenshot evidence

- [Azubogu_Chinaza_301915517_P4_EventsAndQueries.png](Screenshots/Azubogu_Chinaza_301915517_P4_EventsAndQueries.png)

---

## References

1. MongoDB Documentation. (n.d.). *Documents*. Available at: https://www.mongodb.com/docs/manual/core/document/

2. MongoDB Documentation. (n.d.). *Embedded Data Models*. Available at: https://www.mongodb.com/docs/manual/data-modeling/embedding/

3. MongoDB Documentation. (n.d.). *Query Documents*. Available at: https://www.mongodb.com/docs/manual/tutorial/query-documents/

4. MongoDB Documentation. (n.d.). *insertMany()*. Available at: https://www.mongodb.com/docs/manual/reference/method/db.collection.insertMany/

5. MongoDB Documentation. (n.d.). *Install MongoDB Community Edition on Ubuntu*. Available at: https://www.mongodb.com/docs/v8.0/tutorial/install-mongodb-on-ubuntu/

---
