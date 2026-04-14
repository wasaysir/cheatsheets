= MapReduce
Two functions: Map and Reduce
Map: Takes an Iterable and a function, then outputs an Iterable with the function applied to each element. In MapReduce, a flatten step is done after, where all the lists are merged.
Reduce: Takes an initial object, an Iterable of elements, and a reducing function that accepts the initial and the iterable, and does that across all of the project to produce the final output.

MapReduce is based around Key-Value Pairs
Programer needs to define three (maybe four) functions: 
- map: $(k_1, v_1) arrow "List"[(k_2, v_2)]$ ($k_1$ and $k_2$) are usually different types. 
- reduce: $(k_2, "List"[v_2]) arrow "List"[(k_3, v_3)]$ ($k_2$ is an intermediate key not outputted, $k_3$ and $k_2$ are usually same type)
- partition: $(k_2, v_2, n in bb(N)) arrow [0, n)$ $n$ is the number of reducers, essentially given a pair of data $(k_2, v_2)$, you can partition it (assign it) to one of the reducers. Usually hash on key and do modulo on the number of reducers. 
- combine: $(k_2, "List"[v_2]) arrow "List"[(k_2, v_2)]$ Output key must be same type as input key, because this is optionally run before shuffle. Done if mapper is idle. Does same thing as reducer, but before outputting values, to minimize time wasted. Must be commutative (order switch fine) AND associative (brackets anywhere fine).

After data is split into blocks and given to mappers, they're partitioned and "shuffled" (dealt) to reducers to aggregate value. MapReduce uses sortShuffle to sort by key in the reducer.

Sending data from mappers to reducers is slower than data to mappers because of the shuffle. 

#image("../assets/map-reduce-simple.png")

== System View
#image("../assets/map-reduce-physical.png")
Reducers are woken after majority of mappers are done. They need all the ifiles to be complete before they can start. 
+ User submits job to cluster
+ Cluster schedules map and reduce tasks (\# of map tasks derived from size of input files, reduce tasks by user)
+ Workers start reading and mapping their split of the file
+ As they map, they save intermediate k-v pairs to local file system (not network)
+ When job nearly finished, reducers ask mappers for ready intermediate files
+ Once reducer has all its intermediate files, it begins applying reduce. Output written to network FS

#image("../assets/map-reduce-spill.png")
- Map outputs are buffered in circular buffer (memory)
- When buffer reaches threshold, contents spill to disk in single, partitioned file
- Combiner runs (or might run) during the merges
- To reduce file handles, they merge intermediate files in the combiner (if CPU is idle)
- Spills are then hashed and partitioned before moving to different reducers
- Maps are usually assigned to local data, or assigned to nearest worker.

*In-Mapper/Memory Combine*:
- _Combiners improve performance by reducing network traffic_ so In-Mapper Combiners are super fast, if you're not memory bound.
- To implement IMC, override setup and cleanup, so the cleanup can do the combiner step for you. 
- Needs to preserve state across calls to map
- Speeds up, but requires memory management (we make data structure for intermediate values instead of emitting and hadoop storing)

== Implementation Details & Splitting
- Splitting Problem: We can't easily split files by line number because finding newlines requires scanning the entire file, which is too slow. Splitting
  by raw bytes is fast but risks splitting words in the middle. 
- Workflow Bottleneck: The slowest operation in the entire MapReduce framework is the shuffle phase—sending intermediate results from the mappers across the network to the reducers.

== Memory & Combiners
- Memory Management: Mappers process line by line. Thanks to Heap's Law, the number of unique words per line is small, so an in-memory dictionary is usually fine. However, at the scale of terabytes of data, the total unique words $n$ can become very large.
- Combiner Limitations: A combiner runs the reducer logic locally on the mapper to save network bandwidth. However, it can give incorrect answers for non-associative operations like averages (e.g., $"Mean"(2, 3, 4) arrow 3$ vs $"Mean"("Mean"(2, 3), 4) arrow 3.25$).
- Distributed Group By: In the reducer, sorting intermediate data is a multi-pass merge process of map outputs that happens both in memory and on disk. The combiner can optionally run during these merge passes.