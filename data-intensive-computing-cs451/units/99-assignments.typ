== Assignments (Condensed)

== Assignment 1 — PMI (MapReduce)
*Core problem*: estimate co-occurrence association using PMI:
$"PMI"(w_1, w_2) = log( p(w_1, w_2) / (p(w_1)p(w_2)) )$

*Why two passes*:
  - Pass 1: count line-level document frequency for each term + total lines `N`.
  - Pass 2: count pair co-occurrences, then compute PMI using pass-1 marginals.

*Pairs pattern*:
```pseudocode
map(line):
  U <- unique_tokens(line)
  for each ordered pair (u,v), u != v:
    emit((u,v), 1)

reduce((u,v), counts):
  c_uv <- sum(counts)
  if c_uv >= threshold:
    emit((u,v), c_uv)
```

*Stripes pattern* (in-mapper combine style):
```pseudocode
map(line):
  U <- unique_tokens(line)
  for each u in U:
    H <- empty_map
    for each v in U, v != u:
      H[v] += 1
    emit(u, H)

reduce(u, maps):
  stripe <- merge_all_maps(maps)      // per-neighbor summed counts
  emit(u, stripe)
```

*Interesting snippet (what to remember)*:
  - Pairs sends many small records.
  - Stripes sends fewer, heavier records and can reduce shuffle volume.
  - Tradeoff is memory pressure in mapper/reducer map merges.

== Assignment 2 — PMI + Bigram Relative Frequency (Spark)
*PMI in Spark*:
```pseudocode
lines <- text.map(tokenize -> unique_set).cache
df <- lines.flatMap(tokens + ["*"]).map((_,1)).reduceByKey(sum).collectAsMap
broadcast(df)
N <- df["*"]

pairs <- lines
  .flatMap(all ordered co-occurrence pairs)
  .map((pair,1)).reduceByKey(sum)
  .filter(count >= threshold)

output <- pairs.map((w1,w2,c) -> (w1,w2, log10((c/N)/((df[w1]/N)*(df[w2]/N))), c))
```

*Bigram relative frequency (left word conditioned)*:
```pseudocode
emit from each bigram (w1,w2):
  ((w1,w2), 1)
  ((w1,"*"), 1)

reduceByKey(sum)
repartitionAndSortWithinPartitions(customPartitionBy(w1))

mapPartitions(sorted by (w1,w2)):
  keep current marginal c(w1,*)
  for each (w1,w2!=*): emit ((w1,w2), c(w1,w2)/c(w1,*))
```

*Interesting snippet*:
```scala
// Critical trick: all keys with same w1 land together and are sorted.
repartitionAndSortWithinPartitions(partitionerByFirstWord)
```
This enables one-pass streaming computation of conditional probabilities per `w1`.

== Assignment 3 — Inverted Index + Boolean Retrieval
*Inverted index construction*:
```pseudocode
for each document d:
  tf <- term_frequency_map(d)
  for each (term, f) in tf:
    emit(term, (docId, f))

group by term
for each term:
  sort postings by docId
  write (term -> posting_list)
```

*Boolean retrieval evaluator*:
```pseudocode
eval(node):
  if TERM(t): return postingSet[t]
  if AND(a,b): return eval(a) ∩ eval(b)
  if OR(a,b):  return eval(a) ∪ eval(b)
```

*Interesting snippets*:
  - Cache index RDD when answering many interactive queries.
  - Convert posting lists to sorted sets once, then fast set algebra for query trees.

== Assignment 4 — Personalized PageRank (Spark)
*State*:
  - Directed graph adjacency list `adj(u)`.
  - Source set `S` for personalization.
  - Damping `alpha` (0.85 in your code).

*Initialization*:
```pseudocode
rank[u] = 1/|S| if u in S else 0
```

*Iteration*:
```pseudocode
contrib <- flatMap u:
  if outdeg(u)>0:
    for v in adj(u): emit(v, rank[u]/outdeg(u))

missingMass <- 1 - sum(contrib.values)     // dangling leakage

rank_new[u] =
  alpha * incoming(u)
  + ( (1-alpha) + alpha*missingMass ) / |S|   if u in S
  + 0                                          otherwise
```

*Interesting snippet (important)*:
  - `rightOuterJoin(adjList)` (or equivalent) to retain nodes with zero in-links each iteration.

== Assignment 5 — Spam Classifier (Online Logistic + Ensemble Inference)
*Train (single epoch SGD, sparse features)*:
```pseudocode
w <- empty sparse map
for each example (y in {0,1}, features):
  score <- sum(w[f] for f in features)
  p <- sigmoid(score)
  for f in features:
    w[f] += eta * (y - p)
```

*Apply one model*:
```pseudocode
score(features) = sum(w[f] for f in features if f in w)
label = spam if score > 0 else ham
```

*Ensemble*:
```pseudocode
s1,s2,s3 <- model scores
average: label from sign((s1+s2+s3)/3)
vote:    label from majority(sign(s1), sign(s2), sign(s3))
```

*Interesting snippets*:
  - Broadcast model weights once per executor.
  - Score in `mapPartitions` to avoid repeated broadcast value lookups per record.

== Assignment 6 — Spark SQL / RDD Analytics (TPC-H style query)
*Core query shape*:
  - Filter `lineitem` by ship date predicate.
  - Filter `orders` by order date predicate.
  - Join on `orderKey`.
  - Aggregate discounted revenue per order/customer metadata.
  - Take global top-k by revenue.

```pseudocode
L <- lineitem.filter(shipdate > D).map(orderKey, extPrice*(1-discount))
O <- orders.filter(orderdate < D).map(orderKey, (orderDate, shipPriority, custKey))
C <- customer.map(custKey, custName)  // broadcast when small enough

J <- cogroup/join(L, O) on orderKey
R <- for each joined order:
       revenue <- sum(L values for order)
       attach customer name from C
       emit((custName, orderKey, orderDate, shipPriority), revenue)

Ans <- reduceByKey(sum).topK(5, by revenue desc)
```

*Interesting snippets*:
  - Broadcast dimension table (`customer`) when it fits memory.
  - Same logical plan works for text and parquet inputs; only scanner/parsing differs.