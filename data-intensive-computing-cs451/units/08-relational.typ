= Relational Data
\ OLTP: Online Transaction Processing:
  - Most apps
  - User-facing
  - Tasks: Small set of common queries
  - Access: Random reads, small writes
\ OLAP: Online Analytical Processing:
  - BI and Data Mining
  - Back-end: Batch workloads, low concurrency
  - Tasks: Complex analytics (Ad-hoc)
  - Access: Full table scans, big data

#image("/assets/image-5.png")

\ Data Warehousing: Take a database tuned for OLTP and ETL (Extract, Transform, Load) it to a data warehouse tuned for OLAP. This can support multiple databases.

\ ETL: Extract (Pull data from DB), Transform (Clean + Put into schema suited for OLAP), Load (put into data warehouse). Done regularly during periods of low use. 

*OLAP vs OLTP schema*: OLTP is relational between items. OLAP has a "star" schema, with a center fact table pointing to dimension tables. Stars are used because BI and data-mining queries are ad-hoc, and schemas can't be designed around ad-hoc queries.

\ Fact Table: Contains all elements that don't relate to the other rows. 

#image("/assets/image-4.png")

*When to use databases vs not*:
- Good if data is structured, clean, and queries are known
- Bad when unstructured, noisy/messy, and you don't know what you're looking for

\ Data Lakes: Relational and non-relational data from many sources. No schema, low-cost storage. Mix of curated and raw data. Useful for data science/develops/analysts. Main diff from data warehouse is data warehouses store structured, filtered data and prioritize performance. 

#image("/assets/image-6.png")

== HIVE/Spark SQL
- HIVE/Spark SQL call SQL query interface which calls execution layer which calls on HDFS
- Process: Query (Parse) => AST (Plan) => Intermediate Representation (Generate) Java Code => (Execute) Hadoop Cluster

=== Relational Algebra
- Primitives:
  - Selection: Select all rows with a certain attribute. Equivalent to SELECT WHERE from SQL
    - Implemented as a map-side filter with no reducer task. As fast as parsing.
  - Projection: Selects attributes from row. Equivalent to SELECT(col1, col2, ..) FROM SQL
    - Implemented as Map-side tuple transformation, no reducer. As fast as parsing.
  - Rename: Equivalent to SELECT (userID u) FROM users. Renaming userID as u doesn't matter at map-reduce level. 
  - Union: Unions together two data sources. (See below) Equivalent to (SELECT ..) UNION (SELECT ..) in SQL
    - Implemented as MultipleInputFile class
  - Difference: Opposite of Union. Equivalent to (SELECT ..) MINUS (SELECT ..). This isn't parallel. Requires shuffle to get everything to one side. 
    - Implemented as MultipleInputFiles again, but each mapper has key: The entire Tuple + id of the mapper. The value isn't used, and you sort "RHS" tuples before "LHS" tuples. (RHS being subtracted) The reducer remembers the last RHS tuple, emit LHS tuples only if they don't equal last RHS. Basically modified merge sort.
  - Cartesian Product: Create all products of all possibilities from values. See below. Same as SELECT table1.thing, table2.thing FROM table1, table2. 
    - Not a good idea to use.
  - AGGREGATE:
    - Reduce in MapReduce is called "Aggregation Phase". Every SQL aggregation is done on reduce side. 
      - COUNT, SUM, MIN, MAX, AVG
#image("/assets/image-7.png")
#image("/assets/image-8.png")

== Relational Joins
- Inner Joint
#image("/assets/image-9.png")
#image("/assets/image-10.png")

- To do one-to-one, basically do modified merge sort
- To do one-to-many. Hold one tuple in memory, cross with all tuples from the "many" side with matching join key.

#image("/assets/image-11.png")

- To do many-to-many, need to hold all tuples with a given key in memory for both sets and cross sets against each other.
#image("/assets/image-12.png")

=== Inner Join on MapReduce
Three Options:
  - Hash Join (aka Broadcast Join)
    - If one set is small enough to fit in memory in single node, then load into mapper as hash table, each mapper joints its split against the hash table. Map-side only, can be pipeline and is very fast.
  - Map-Side Join
    - Ensure that the files are sorted by key and split by the same partitioner, then you have two indexes for each file, and you can iterate through the two partitions in a modified merge sort based on the keys. See below drawing
  - Reduce-Side join
    - Always available, but just hard. 
    - 1-to-1 join
      - Reducer always gets 1 key per subquery. Join is simple. Just tag each tuple with its source, but the sort order doesn't matter. The reducer gets a key and iterable list of values, for 1-to-1 join, iterate through values, identify which record belongs to whom by tags and emit combined result.
    - 1-to-many join
      - Reducer holds the tuple from 1-side in memory, then joins with all. Use secondary sorting pattern to ensure 1-side comes first. "(Join Key, Origin) -> Map" as your reduce Key
    - Many-to-Many join
      - Need to hold all tuples with one key from one set and cross against other set. 
    - Outer join
      - Logic the same, but handle the empty case instead of skipping the unpaired tuple. 

#image("/assets/image-13.png")

* Process of executing Hadoop SQL*:
- Build logical plan (as a parsing of query)
- Optimize logical plan (change filters to be as early as possible)
- Select physical plan (Determine which RDD operations need to be done to execute)

=== Spark Dataframes
- Dataframe is like Tuple RDD except with diff operators, each element of tuple is called a "column", each column has a name.

```scala
val myRDD = sc.textFile("marks.csv").map(_.split).map(attrs => (attr[0].toInt, attr[1], attr[2].toFloat))
val myDF = myRDD.toDF("studentid", "component", "mark")
``` The myDF assigns column names. Schemas are inferred by RDD data types.

Querying dataset: First register (`people.createOrReplaceTempView("people")`) then query (`teens = spark.sql("SELECT name, age FROM people WHERE age BETWEEN 13 AND 19")`)

Why is SPARK slow? Parsing text is slow. Best thing is using a binary format with a schema separating logical and physical views.

#image("/assets/image-14.png")

Row-stores:
  - Easier to modify record (in-place updates)
  - Might read unnecessary data when processing
Column-stores:
  - Only read necessary data
  - Tuple writes require multiple operations
  - Tuple updates are complex

The benefits of column stores are:
- Better compression (use Gzip which works because columns have repetition via Run-length encoding)
- Read efficiency
- Works well with compiled queries and vectorized execution

*Apache Parquet*: Columnar storage for Hadoop
