= Machine Learning
ML Roadmap:
+ Acquire/Clean data
+ Label data
+ Determine features
+ Pick architecture
+ Train model
+ Repeat

Methods to label things by hand at scale:
- Crowdsourcing (captcha)
- Bootstrapping (semi-supervised)
- Exploiting user behaviour (emojis as self-labelled sentiment analysis)

Training a classifier:
$D = \{\(x_i, y_i\)\}$, want to find $f: X arrow Y$, minimizing loss $1/n sum^n_(i=1) ell(f(x_i), y_i)$.

Gradient Descent: Move down loss function gradient to optimize ML parameters. Compute gradient wrt loss and use newton's method to compute new weights. 

$theta' = theta - gamma delta L(theta)$
$L(theta) gt.eq L(theta ')$

General logistic algorithm
```scala
val points =
spark.textFile(...).map(…).cache()
var w = … // initial vector
for (i <- 1 to ITERATIONS) {
val gradient = points.map{ p => {
val score = p.x * w
val y = 1 / (1 + exp(-score)
p.x * (p.y – y)}}.reduce((a,b) => a+b)
w -= gradient * LR
```

Stochastic Gradient descent: Train data one data sample at a time, instead of entire dataset for parallelization.

Ensemble Learning: Train multiple independent models, and combine predictions via voting or merging model results. Perfectly parallel.
- This works because errors aren't correlated (empirically)
- Less likely all models are wrong (empirically)
- Reduced variance

Online Stochastic Gradient Descent:
- Given training data, with X data points, do 1 iteration through all X points and sum gradient, or do 1 iteration per data point. These are less quality iterations than all data, but distributed speed should make up for it.
- Then to run, just use ensemble learning

Online stochastic gradient via one model:
- To build one model, mappers become "parser" parsing strings and emitting feature-label pairs, the learner is run on the reducer. 

Precision: True positives over all labelled positives
Recall: True positives over all real positives.
Type 1 Error: False positive
Type 2 Error: False negative

ROC: Graph Recall (true positive) vs fall out (false positive rate)
  - Represents how if you vary threshold, more false positives slip in and how many more true positives are found.
  - Usually ROCa is used. 
PR: Precision vs recall

K-Fold Cross-Validation Designate a portion of training to be test set and do that multiple times for each partition to evaluate your architecture.

A/B Online Testing - Gather metrics between two alternatives and compare results.

= Data Mining
== Locality Sensitive Hashing
- For $X, X'$ such that $d(X, X') = c$
- Normal hash: If you know $X$ and $h(X)$, no idea what $h(X')$ is
- LSH Hash: If you know $X$ and $h(X)$: $E[d_"hash"(h(X), h(X'))]$
- Items close should, on average, have close hash codes

+ Make a Hash Table
+ Use buckets $w$ wide and overlapped so items go in multiple buckets
+ Most values $x_i, x_j$ st $d(x_i, x_j) < c$ will have at least 1 bucket in common. Most values > c won't share a common bucket.

Jaccard Distance: Given set $C_1, C_2, "sim"(C_1, C_2) = abs(C_1 sect C_2) / abs(C_1 union C_2)$

$d(C_1, C_2) = 1 - "sim"(C_1, C_2)$

An embedding of binary features is a set, which allows this to work as well. We can use n-gram embedding to get an embedding vector for dense features, either byte-level or word-level. 

== Min-Hashing
- Create n-gram embeddings for all documents. 
  - Row = Elements of set (n-gram)
  - Col = One set (document)
  - 1 in (i, j) => n-gram i in doc j

Min-Hash Property: Probability that hash of $C_1$ given permutation $pi$ equals hash $C_2$ given same permutation, equals Jaccard similarity. 
  - Proof: $y = h(C_1 union C_2)$, so $y = h(C_1; pi) "or" y = h(C_2; pi)$ because permutation is random. So every element y in union has same chance of being placed first by permutation.
  - To be in both, there are $abs(C_1 sect C_2)$ things in both, and $abs(C_1 union C_2)$ possible values, so probability it's in both is the fraction of two, which is definition of similarity.

As a result, permuted hash is a locality-sensitive hash.

Signature matrix:
Given permutations of input matrix, select lowest index with a value of $1$:

#image("/assets/data-mining-lsh.png")

You can estimate document similarity by checking the signature matrix. 

The problem is for large enough $n$ we're screwed, we'd need so many bits to distinguish permutations. We can let $h_i$ be a k-universal hash function. Let $pi_i$ be the permutation we get if we sort using $h_i$ as the key function, and break ties arbitrarily.

k-universal hash function: k-degree polynomial modulo prime number.

Essentially, for a one-pass implementation, we create $K$ hash functions, and ordering under $k_i$ gives a random row permutation. For each column C and hash function $k_i$, keep a "slot" for the min-hash value. Initialize all sig(C)[i] = infinity. Scan rows looking for 1s. Suppose row $j$ has 1 in column C, then for each $k_i$, if $k_i(j) < "sig"(C)[i] "then" "sig"(C)[i] arrow.l k_i(j)$

*IN SUMMARY OUR PROCESS FOR FINDING CANDIDATE PAIRS IS*:
+ FIRST DO SHINGLING (converting doc into a set of small overlapping sequences of characters or words)
+ Then do Min-Hashing to build a signature matrix
+ Then do locality-sensitive hashing to find those pairs of signatures that we need to test for similarity.

Locality-Sensitive Hashing:
+ Partition $M$ into $b$ bands. 
#image("/assets/image.png")
#image("/assets/image-1.png")
#image("/assets/image-2.png")

=== Summary
+  convert each document into n-grams
  + convert each unique n-gram into an integer
+ Generate a set of universal hash functions
+ For each document, compute the short signature vector
+ Pick values of R, B to tune to the false-positive and/or false negative rates you want
+ Hash each of the B bands for each document to find candidate pairs
+ Confirm the signatures are similar
+ (Optional) Confirm the documents are similar

Spark Implementation:
+ Generate Signatures : map
+ Split each signature into bands: flatMap
+ Ship each band somewhere: groupByKey with custom partitioner
+ Find collisions within each band: mapPartitions
  + Remove (some) false positives by double checking signatures are similar before emitting
+ Merge results: union -> distinct
+ (optional) remove remaining false positives by checking sets are similar (expensive): filter

=== Clustering
- Sets are vectors: Measure similarity by cosine distance
- Sets as sets: Measure similarity by jaccard distance
- Sets as points: Measure similarity by Euclidean distance

Hierarchical: Methods of clustering:
- Agglomerative (bottom-up). Initially each point is a cluster, repeat combine the two "nearest" clusters into one. (THIS DOESNT WORK WELL WITH SPARK SINCE ITS A GLOBAL CHOICE)
- Divisive (top-down). Start with one cluster and recursively split it.

Point Assignment: Maintain a set of clusters, points belong to "nearest" cluster

==== Hierachical
- Main questions:
  - How to represent cluster of 1+ point
    - Euclidean: Each cluster has "centroid" (avg of data points) 
  - How to determine "nearness" of clusters
    - V1: Measure cluster distances by centroid distances
    - V2: *Inter cluster distance*: Min distances between any two points, one for each cluster. 
    - V3: "cohesion": Merge clusters whose unions are most cohesive
      - V3.1: Use diameter of merged cluster (max dist between points in cluster)
      - V3.2: Use avg dist between points in cluster
      - V3.3: Use density-based approach
  - When to stop combining clusters
    - Combine closest two clusters every time (greedy)
    - Keep going until only one mega cluster remains. 


In the non-euclidean case, the only location are points themselves. We can represent a cluster by clustroids (which is the "closest" to other points). The "nearness" of clusters is by treating clustroids as centroids and computing inter-cluster distances.

"Clustroid" can be found as closest, meaning either smallest max dist to other points, smallest avg dist to other points, smallest sum squares of dists to other points. 

Naive implementation leads to $O(N^3)$ by just computing pairwise distances b/w all pairs of clusters and merging. Priority queues can reduce to $O(N^2 log N)$ but still too expensive for large datasets. 

=== K-Means Clustering
- Assumes Euclidean space
- Start by picking $k$
- Intialize clusters by picking one point per cluster

Procedure:
+ For each point, place in cluster whose current centroid is nearest
+ After all points are assigned, update locations of centroids of the $k$ clusters
+ Reassign all points to their closest centroid, sometimes point switch clusters
+ Repeat prev 2 steps until convergence (points don't move)

*SPARK IS FASTER FOR THIS THAN MAPREDUCE BECAUSE WE CAN CACHE CLUSTER DATA*

We select $k$ by continuing to increase the value, until the average distance to centroid levels off, this is the "elbow"
#image("/assets/image-3.png")

Spark Impl:
+ Pick random centroids
+ Create pair RDD by assigning (key is cluster num) - partition by key and CACHE
+ reduceByKey + map to get new centroids
+ Create new pair RDD by reassigning using new centroids
  + Accumulator tracks how many data points changed cluster ID
  + Unpersist old assignment RDD
+ If acc > 0, go to step 3

The caching is important for persisting values for clusters that don't change.