= Spark

*Abstraction*:
#image("../assets/map-reduce-multiple-jobs.png")
Problem is, there's a lot of disk i/o which reduces running MapReduce jobs. 

If you want Map to Map, you can use a ChainMap function to pass 2+ Mapper classes together, but taking a reducer to a reducer is not allowed.

== Comparison to MapReduce
- MapReduce shuffles using MergeSort, putting it in sorted order. Spark outputs in a hash table. Spark uses mostly memory, which means it can be overloaded and memory bound, whereas MapReduce reads from disk, so it'll be slower, but it'll have more parallel tasks. Spark requires more servers, with more memory to beat MapReduce.

*Resilient Distributed Dataset*:
- Automatically rebuilt on failure
- Distributed across system
- Everything outputted by Spark is in this collection class
- RDDs are divided into partitions to allow independent work
- Immutable
- Collections of objects spread across cluster, stored in RAM or on disk
- Can be transformed (map, filter) or acted on (count, collect, save)
#image("../assets/RDD-structure.png")

#image("../assets/map-reduce-functions.png")
Only set of functions/workflow we had for MapReduce
#image("../assets/spark-map-functions.png")
Map: Same as map in MapReduce. Maps are lazy-evaluated to when accessed.
Filter: This doesn't modify the RDD, it drops elements in the RDD. Output is same type.
FlatMap: f(x) called on each item x in RDD, then the RDD is flattened.
MapPartitions: f is given an iterator on T, and provides an iterator with the function applied to each value. Useful analogue to MapReduce's setup and cleanup
#image("../assets/spark-reduce-functions.png")
GroupByKey: Like MapReduce shuffle, which brings pairs to a single place. 
ReduceByKey: Like MapReduce's shuffle + combine + reduce
  - First creates hash table
  - For each k-v pair in RDD, if k is not a key in HT, associate k with v in HT otherwise retrieve old value from HT and replace it with $f(v_"old", v)$
  - Perform a shuffle - each reducer-like worker will receive k-v pairs
  - Then repeat step 2 for all received pairs
AggregateByKey(zero, insert, merge): general version of reduceBykey
  - Creates hash table called HT
  - For each k-v pair in RDD, if k is not in HT, associate k with insert(zero, v) in HT. Otherwise, retrieve accumulator u from HT, and replace with insert(u, v) => u'
  - Perform shuffle, each reducer-like-worker will receive k-v pairs. Third parameter, merge, is used to combine accumulators
  - This can produce any output type, not just same, as ReduceByKey requests

Since Spark mostly works via memory, caching can significantly improve performance. Iterative algorithms with lots of constant information are much more performant in Spark because of caching.

== Spark programming
`sc.textFile("directory/*.txt")` creates an RDD of lines in file held in arbitrary order, w/o mentioning file origin

`nums = sc.parallelize([1, 2, 3])`
`nums.collect`: For manageable amount of data, collect to hold all in memory at once
`nums.take`: Only takes first k elements
`nums.count`: Counts \# of elements
`nums.reduce`: Merge elemnts with an associative function
`nums.saveAsTextFile("hdfs://file.txt")`: Makes a directory of name "file.txt", won't acc make a txt file

Distributed reduce transformations operate on RDDs of key-value pairs.

`val nums = 1` Val casts a fixed value
`var nums = 1` Var holds a mutable value.

*Key-Value Ops*:
- `visits.join(pageNames)`: Same as SQL iner join, where if key in visits matches key in pageNames, you match the value from one to the value to the other
- `visits.cogroup(pageNames)`: Combines all values for a single key into one combined set.

All pair RDD operations take an optional second parameter for the *minimum* number of tasks/partitions. You should match the number of partitions to the number of cores in the computer. 

=== DAG Scheduler
#image("../assets/DAG-scheduler.png")
The job is broken down to multiple stages, forming a DAG. This automatically pipelines functions. It's aware of data locality, and aware of how to partition to avoid shuffles.

#image("../assets/spark-physical-operators.png")

Narrow dependencies are much faster than wide dependencies because they don't require shuffling data between working nodes

Spark is faster when you can keep the shuffle data in memory, whereas Hadoop always reads from disk, so the lack of caching is a downside.

#image("../assets/hadoop-v1-job-tracker.png")
#image("../assets/hadoop-v2-job-tracker.png")
#image("../assets/spark-job-tracker.png")

Whereas Hadoop only sees the executor, Spark sees the tasks sa the workers, so spark would recognize 4 tasks in the above, whereas Hadoop would see 2 executors. Therefore, the Spark driver must send relevant code to run each task. The executor is to tasks what processes are to threads.

Eg: `myRdd.map(lambda x: x >= thresh)` is compiled as byteocde and passed to each task. This is fine for compiled integers, but for hash tables this can be expensive. *Serialization* is necessary across all the tasks.

*Broadcast*: 
- This method only sends one copy per Executor (worker machine) rather than task. 
- These are read-only, so it avoid coordination across machines. 
- These carry info from driver to executor
- `eg: thresh = sc.broadcast(5)`

*Accumulator*:
- Carry info from executor to driver
- eg: `lineCount = sc.accumulator(0)`

*Partitioning*: 
- Spark uses a hash partitioner, and it uses a heuristic to divide into approximately equal size partitions
- Need to define a partitioner class, descending from Partition tooverride partition function. 

== reduceByKey vs others
*Reduce*:
- $(K_2, V_2) arrow.double "List"[K_3, V_3]$
- K-V pairs are partitioned and shuffled by partitioner
- Reduce job calls reduce on keys in sorted order

*reduceByKey*:
- $V arrow.double V$
- $"RDD"\[\(K, V\)\] arrow.double "RDD"\[\(K, V\)\]$
- Less flexible 
- Reduces before shuffle (combiner)
- Reduces after shuffle (reducer)

*combineByKey*:
- More fine-grained control
- $"RDD"\[\(K, V\)\]."combineByKey"\("create, append, merge"\) arrow.double "RDD"\[\(K,C\)\]$
- create: make C from V
- append: take C and add V to it
- merge: combine two C

*aggregateByKey*:
- In between reduceByKey and combineByKey
- $"RDD"\[\(K, V\)\]."aggregateByKey"\("zero, append, merge"\) arrow.double "RDD"\[\(K,C\)\]$

#image("../assets/spark-group-by-key.png")

== Core Concepts
- Lineage Information: RDDs track their lineage (the graph of operations used to build them). This is what makes them "Resilient"; if a partition is lost, Spark uses the lineage to efficiently recompute just the missing data.
- Performance: Spark is up to 10x faster on disk, 100x faster in memory, and requires 2-5x less code compared to Hadoop MapReduce.
- SparkContext (sc): The main entry point for Spark functionality. It connects to the cluster and allows creation of RDDs (e.g., sc.textFile, sc.parallelize).
- Lazy Evaluation: Transformations (like map, filter) are lazy and don't execute immediately. Actions (like collect, take, reduce) trigger the actual execution of the DAG.
- Historical Context: Hadoop v1 only supported MapReduce. Hadoop v2 introduced YARN (Yet-Another-Resource-Negotiator), which manages resources for any distributed application, allowing Spark to run on Hadoop clusters.

== Specific RDD Operations
- take(k): Returns the first $k$ elements of the RDD.
- collect(): Returns all elements of the RDD to the driver program. Warning: Can cause OutOfMemory (OOM) errors if the dataset is too large.
- Scala Specifics: Uses val for immutable values and var for mutable variables. Scala handles key-value pairs cleanly using pattern matching and case lambdas.

== Partitioning & Shuffling
- Range Partitioner: Often used for sorting. Workers gather statistics on key distributions, and heuristics attempt to divide the keys into ranges of approximately equal sizes.
- Custom Partitioner: You can define custom routing by extending the Partitioner class, requiring you to override numPartitions and getPartition(key).
- Repartition vs. Coalesce:
  - repartition(n): Increases or decreases the number of partitions. It always triggers a full network shuffle.
  - coalesce(n): Only decreases the number of partitions. It avoids a full shuffle by safely merging existing partitions (narrow dependency), making it much faster than repartitioning when downscaling.