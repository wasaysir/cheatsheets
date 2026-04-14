= Mutability

*Shift in workload*:
  - Earlier systems: sequential reads + append-only writes.
  - Modern applications often need random reads and random writes at scale.

*Why not only RDBMS?*:
  - Traditional RDBMS are excellent for correctness/transactions, but are harder to scale out horizontally and less natural for semi-structured data.

== NoSQL Overview
NoSQL "Not only SQL" (SQL may still appear in parts of stack).

*Common traits*:
  - Horizontal scaling
  - Replicated, distributed data
  - Flexible/dynamic schemas
  - Large-scale storage and throughput
  - Often weaker consistency guarantees than strict ACID databases

/ *SQL families*:
  - OLTP (transactional)
  - OLAP (analytical)

*NoSQL families*:
  - Key-value stores
  - Column stores
  - Document stores
  - Graph databases

*System design questions*:
  - Partitioning (sharding): where does key `X` live?
  - Replication: how many copies and where?
  - In-memory caching: how is hot data accelerated?

== ACID vs BASE
*ACID* (common SQL emphasis):
  - Atomicity: all-or-nothing transaction behavior.
  - Consistency: transactions preserve declared invariants.
  - Isolation: concurrent transactions behave like some serial order.
  - Durability: committed updates survive crashes.

*BASE* (common NoSQL emphasis):
  - Basically Available: prioritize service continuity.
  - Soft State: intermediate replicas may diverge transiently.
  - Eventually Consistent: replicas converge after propagation delay.

== Partitioning by Key: Consistent Hashing
Used to map keys and nodes onto an `m`-bit identifier ring.

*Rule*:
  - Key `k` maps to first node clockwise with `GUID >= h(k)` = `successor(k)`.

*Benefits*:
  - Balance: with high probability, each of `N` nodes receives about `K/N` of `K` keys.
  - Churn efficiency: node join/leave remaps only `O(K/N)` keys (not all keys).

=== Chord (DHT Protocol)
*Routing structures*:
  - Basic: predecessor/successor pointers $arrow.r$ `O(n)` lookup hops.
  - With finger table (`+2, +4, +8, ...` jumps): `O(log n)` lookup hops.

*Lookup intuition*:
  - Repeatedly jump as far as possible without passing target key; finish with local successor link.

*Join maintenance*:
  - Need invariants:
    - each node knows correct successor
    - each key owned by `successor(k)`
  - Finger-table bootstrap:
    - naive: query each entry
    - better: derive from prior entries / successor table
  - Background stabilization refreshes stale routing metadata.

*Replication in ring style*:
  - Common pattern: successor stores predecessor replicas.

In practice, many production NoSQL systems use other architectures (not pure P2P DHT rings).

== NoSQL System Families (Examples)
=== Key-Value Stores
*Memcached*:
  - Distributed cache of arbitrary byte values
  - Client-side hashing chooses server
  - Servers are mostly independent from each other
  - Non-persistent (cache focus)

*Redis*:
  - In-memory data-structure server (strings, lists, hashes, sets, streams, HLL, etc.)
  - Client-side key distribution + coordinated clustering/resharding
  - Supports replication and persistence (RAM-backed with disk persistence)

=== Document Stores
*MongoDB*:
  - String keys -> JSON-like documents
  - Optional schema, indexes, and query support

*CouchDB*:
  - String keys -> JSON documents
  - Uses MVCC, often associated with eventual consistency patterns

=== Graph Databases
*Neo4j*:
  - Data as nodes/edges/properties
  - Transactional graph workloads, ACID-compliant transactions

=== Column Stores
*Google BigTable*:
  - Conceptual mapping: `(row key, column key, timestamp) -> byte stream`
  - Sparse, distributed, persistent, sorted multidimensional map
  - Bloom filters used in access path optimizations

*HBase*:
  - Open-source analogue in Hadoop ecosystem (BigTable-like model)
  - Integrates with Hadoop jobs for read/write processing

== Consistency, Availability, Partition Tolerance
*CAP dimensions*:
  - Consistency: all nodes return same value view.
  - Availability: requests still receive non-error responses.
  - Partition tolerance: system continues despite network splits.

*CAP framing*:
  - Popular summary: "pick two" (simplified).
  - Better interpretation: under a partition, choose between consistency and availability.
  - In normal (no-partition) operation, latency also becomes a central tradeoff.

*Consistency levels*:
  - Strong consistency: once update completes, later reads see it.
  - Weak consistency: some reads may still see older values.
  - Eventual consistency: after some stabilization time, replicas converge.

*Examples from notes*:
  - Strong consistency preferred for strict financial correctness.
  - Eventual consistency acceptable for large social platforms prioritizing low latency/availability.

== PACELC (More Complete Tradeoff Model)
If *Partition* occurs: trade off *Availability* vs *Consistency* (PA or PC).
*Else* (normal operation): trade off *Latency* vs *Consistency* (EL or EC).

Common labels/examples from class notes:
  - PA/EL: favor availability + low latency (e.g., Dynamo/Cassandra style)
  - PC/EC: favor consistency in both regimes (e.g., BigTable/HBase style)
  - PA/EC: availability under partitions, stronger consistency otherwise (MongoDB-style framing)
  - PC/EL: uncommon/atypical framing

== Transactions and Consensus
=== Two-Phase Commit (2PC)
*Goal*: distributed transaction commits fully or aborts fully.
*Assumes*: persistent storage + write-ahead logs.
*Limitation*: can block; coordinator failures are problematic.

=== Paxos (Consensus)
Addresses replicated state agreement under failures.

*Roles*:
  - Proposers: advocate client requests/value proposals
  - Acceptors: vote/accept proposals
  - Learners: learn/record chosen value

*Quorum rule*:
  - Quorum is majority of acceptors.
  - Any two quorums intersect (cannot be disjoint), ensuring safety.
