= Streaming

*Batch vs Stream Processing*:
  - Batch: Process all data at once, higher end-to-end delay, not real-time.
  - Stream: Process data continuously as it arrives, low latency, "real-time-ish".
  - Common real-time-ish domains: finance/payments, transportation, manufacturing, retail, monitoring.

*Typical Stream Pipeline*:
  - Data sources $arrow.r$ Data ingest/broker $arrow.r$ Stream engine $arrow.r$ sinks/apps
  - Common components:
    - Broker/ingest: Kafka (and sometimes Flume)
    - Storage/sinks: HDFS, HBase, data lake
    - Consumers: app1 ... app_n

*Data Stream Model*:
  - A stream is a high-volume, continuously arriving sequence of ordered tuples.
  - Operators look familiar: `filter`, `map`, `flatMap`, `group`, `aggregate`, `join`.
  - Hard part: reduce-like operations need bounded data, but streams are unbounded.

== Windowing
Windowing makes unbounded streams analyzable by defining finite subsets.

*Window Triggers / Definitions*:
  - Time/ordering attribute based
  - Count based (`n` records)
  - Explicit marker based (application-level boundaries)

*Sliding vs Tumbling*:
  - Sliding window: e.g., last 1 minute, recomputed every 5 seconds; adjacent windows overlap heavily.
  - Tumbling window: e.g., last 1 minute, recomputed every 1 minute; no overlap between windows.
  - Sliding windows can often be built from smaller tumbling micro-batches.

*Count Windows*:
  - Window size is record-count based, not wall-clock based.
  - Slow stream $arrow.r$ long duration windows.
  - Fast stream $arrow.r$ short duration windows.

*Why Windows Matter*:
  - Aggregation/grouping: defines when accumulation starts/stops.
  - Stream-static joins: typically straightforward lookup.
  - Stream-stream joins: window determines how long to wait for matching keys.

== Distributed Streaming Challenges
*Inherent Challenges*:
  - Low-latency requirements
  - Memory/storage pressure

*Framework / Systems Challenges*:
  - Bursty traffic
  - Load balancing and clustering
  - Out-of-order delivery
  - Exactly-once delivery semantics (hard)

== Producers, Consumers, and Brokers
*Communication Patterns*:
  - Push: producer sends data to consumer/broker
  - Pull: consumer polls for data
  - Hybrid push-pull is common (producer $arrow.r$ broker via push, consumer polls broker)

*Why a Broker?*:
  - Decouples many producers and many consumers
  - Supports pub/sub and queue-like behavior
  - Smooths mismatched producer/consumer rates

*Polling Tradeoff*:
  - Pros: robust to flaky consumer connectivity, consumer controls pace
  - Cons: frequent polling can waste resources when arrivals are sparse

== Stream Processing Frameworks
- Apache Spark Streaming
- Apache Storm
- Apache Flink

=== Spark Streaming (DStreams)
*Core Idea*:
  - Model stream as a sequence of small, periodic micro-batches (often around 1s).
  - Every `t` seconds, ingest records into an RDD and run normal Spark RDD transformations/actions.
  - DStream = sequence of RDDs over time.

*Operation Types*:
  - Stateless transforms: map/filter/flatMap-style per micro-batch ops
  - Stateful/windowed transforms: combine current + prior micro-batches
  - Output ops: push results to external systems

*Window Example (hashtags)*:
  - `hashTags.window(Minutes(10), Seconds(1)).countByValue()`
  - First output depends on first 600 one-second hashtag RDDs; next output shifts by one batch.

*Incremental Window Aggregation*:
  - `countByValueAndWindow(...)` avoids full recomputation for each slide.
  - Reuses prior result and applies "add new / remove old" logic.
  - Generalizes to reduce-like operations when an inverse operation exists.

== Kafka (Data Broker)
*What It Is*:
  - Distributed pub-sub broker (origin: LinkedIn)
  - Built for high throughput, resilience, and availability

*Performance Intuition*:
  - Persists data to disk, but writes/read paths benefit from OS page cache and efficient socket transfer.

*Data Model*:
  - Data organized by *topic*
  - Topic split into *partitions*
  - Partitions replicated across brokers
  - Per-partition leader/follower replication
  - With replication factor `R`, system tolerates up to `R - 1` failures without data loss (for replicated data)

*Ordering*:
  - Total order within a partition
  - No global total order across whole topic
  - With keyed events: same key hashes to same partition $arrow.r$ preserved per-key order by arrival
  - Without key: strict per-entity ordering is not guaranteed

*Delivery / Dedup Notes*:
  - Producers can send unique identifiers for idempotent writes
  - Brokers track and reject duplicates under idempotent producer settings

*Consumers and Offsets*:
  - Consumers track their own offset per partition
  - A partition can be read by multiple consumers (independent offsets)
  - Consumer groups split partitions among members:
    - Group receives full topic logically
    - Each partition assigned to at most one consumer in that group

== Flume
Apache Flume is a distributed service for collecting/aggregating log data and routing it through pipelines (commonly to HDFS, but not limited to HDFS).

== Burst Handling and Approximate Streaming Algorithms
When bursts exceed processing capacity, approximate summaries keep loss bounded and useful.

=== Reservoir Sampling
*Goal*: Uniformly sample `S` items from a stream of unknown/very large `N`.

*Algorithm*:
  - Keep first `S` items.
  - For the `k`th item (`k > S`):
    - Keep it with probability `S / k`.
    - If kept, evict one of current `S` samples uniformly at random.

*Guarantee*:
  - After seeing `K >= S` items, each of the `K` items is in reservoir with probability `S / K`.

=== HyperLogLog (HLL)
*Goal*: Estimate cardinality (num distinct items) in a multiset.
*Idea*: Hash values, track maximum run of leading zeros; longer runs imply larger distinct counts.
*Property*: Tiny memory footprint with probabilistic error.

=== Bloom Filter
*Goal*: Approximate membership query ("have we seen X?").
*Structure*: Bit vector of length `m`, `k` hash functions.
*Semantics*:
  - No false negatives
  - Possible false positives
  - Tune false-positive rate by choosing `m` and `k`

=== Count-Min Sketch
*Goal*: Approximate frequency of element `X`.
*Structure*: `k x m` counter matrix (one row per hash function).
*Update*: Increment one counter per row for each item.
*Query*: Return minimum of the `k` counters for `X` (mitigates collision overcount).
