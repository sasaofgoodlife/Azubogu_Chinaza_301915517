# Distributed and Cloud Database Exercise

## Current setup

The Electronic Document Management System (EDMS) uses PostgreSQL for its relational records, including departments, user accounts, documents, document versions, document access permissions and activity records.

Portfolio 4 introduced MongoDB for flexible activity-event records. The MongoDB database is named `edms_nosql`, and its collection is `activity_events`. It contains four example events covering document version creation and document permission reviews.

The practical environment uses PostgreSQL and MongoDB within the same GitHub Codespaces environment. MongoDB was installed locally and accessed through `127.0.0.1:27017`. This is a single-server setup, not a distributed deployment.

No MongoDB replica set, sharding configuration, cloud database deployment or failover test has been implemented.

## Proposed replication

To improve the availability of EDMS activity events, I propose a MongoDB replica set with three voting, data-bearing members hosted on separate servers and failure zones.

| Member | Starting role | Location |
|---|---|---|
| A | Primary – accepts event writes | Host 1 / Zone 1 |
| B | Secondary – copies event changes | Host 2 / Zone 2 |
| C | Secondary – copies event changes | Host 3 / Zone 3 |

For example, when the EDMS records a `document_version_created` event for the Annual Financial Policy, the primary receives the event and the secondary members replicate the change asynchronously.

This arrangement provides multiple copies of the event records. Separate failure zones reduce the risk of losing all copies from a single host or zone failure.

This is a proposed architecture and has not been deployed.

Reference: [MongoDB Replication](https://www.mongodb.com/docs/manual/replication/).

## Failure and consistency

If the primary member fails, the remaining eligible members can hold an election to select a new primary. With three voting members, at least two must be available and able to communicate to form a majority.

During an election, new writes may be temporarily interrupted. If only one voting member remains reachable, it cannot form a majority and cannot elect a writable primary.

For important EDMS activity events, the proposed design uses majority write acknowledgement. This requires acknowledgement from a majority of the voting members before the write is considered successful. It improves protection against losing acknowledged events during a single-member failure.

Secondary members may temporarily contain older data because replication is asynchronous. Therefore, queries requiring the latest event information should preferably read from the primary.

The PostgreSQL database remains authoritative for relational EDMS records, including document ownership, department relationships and access permissions. MongoDB replication would protect the activity-event collection only. It would not automatically replicate PostgreSQL records or synchronize the two databases.

References:
- [MongoDB Replica Set Elections](https://www.mongodb.com/docs/v8.0/core/replica-set-elections/)
- [MongoDB Write Concern](https://www.mongodb.com/docs/v8.0/reference/write-concern/)

## Sharding and cloud deployment

Replication and sharding serve different purposes. Replication creates copies of the same data across multiple members, while sharding divides data across multiple servers.

The current EDMS MongoDB collection contains only four example activity events. Sharding is therefore unnecessary for this implementation. A larger production system could consider sharding if event volume and workload exceeded the practical capacity of a single replica set. The shard key would need to be selected based on actual query patterns and data distribution.

A possible cloud deployment could use a managed MongoDB service such as MongoDB Atlas. It should include database authentication, encrypted connections, restricted network access and scheduled backups. Backup restoration should also be tested.

Cloud deployment would introduce hosting and data-transfer costs that would need to be assessed before implementation.

A limitation is that MongoDB replication does not replace backups or provide availability for the entire EDMS. PostgreSQL would require its own backup, replication and recovery strategy. The two databases would also require a separate synchronization mechanism if automatic data exchange became a requirement.

Reference: [MongoDB Sharding](https://www.mongodb.com/docs/manual/sharding/) | [MongoDB Atlas Backup and Restore](https://www.mongodb.com/docs/atlas/backup-restore-cluster/).


