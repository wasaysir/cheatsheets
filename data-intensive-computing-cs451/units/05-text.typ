= Text
Ngrams are trained to calculate $P(w_1, w_2, dots, w_k)$, which then allows you to predict $P(w_k | w_1, dots, w_(k-1)) = P(w_1, dots, w_k) / P(w_1, dots, w_(k-1))$. 

This is calculated as $P(w_k | w_1 dots, w_(k-1)) = C(w_1, dots, w_k) / C(w_1, dots, w_(k-1))$

== Laplace Smoothing
Ensure non-zero probabilities for all combinations of words, to avoid overfitting to training set.
Laplace: Start count at 1.

$P(A, B) = (C(A,B)) / N$ becomes $P_L(A,B) = (C(A,B) + 1)/(N + V^2)$

Since every pair of words $(A,B)$ has +1, we need to add $V^2$ for all pair combination

== Information Retrieval
#image("/assets/text-info-retrieval.png")

Approach: given a document, convert it into a bag-of-words (word-counts of the doc) and tokenize it, after case-folding. This build the inverted index. The inverted index is because it maps context to documents, forward is documents to context. To save space, 

The result is a list of linked-lists with word tokens as the index to main list, and elements of linked-list are document-ids. In the node can be bools, counts, or positions. The linked-lists save space, because most words will be sparse

\ Heap's Law: $M = k T^b$, $M$ is vocab size, $T$ is collection size, $k, b$ are constants 

Heap's law is linear in log-log space, so log-vocab-size grows linearly with log collection size.

Zipf's law is also linear in log-log space, shows few elmeents occur very frequently. Shows that frequency is inversely proportional to rank

\ Secondary Sorting Pattern: Modify key, so that you can leverage it being sorted in the reduce phase. $\(A: \(B, C\)\) arrow.double \(\(A, B\): C\)$, but still partition by $A$

Equivalent in Spark: repartitionAndSortWithinPartitions

Ex. We can use this to leverage MapReduce shuffle-sort, and then build a small postings list via delta-compression, which leverages zipf's law which says rare terms won't get compressed much, but common terms have small docId differences, which benefit from smaller compression.

== Delta Encoding
If sequence is ascending, write down "delta" b/w elements.

\ VInt: (BYTE-LEVEL ENCODING) Variable-Width Int type that uses 1-5 bytes to represent an Int, with same range as 4-byte fixed width. 
Write this into a series of bytes instead of an array of VInts to reduce object overhead.
\ VLQ: (BYTE-LEVEL ENCODING) Variable Length Quantity which uses continuation bits to follow similar principle as VInt.
\ Simple-9: (WORD-LEVEL ENCODING) Way to divide 4 bytes into 9 different classifications of bits, ex. 28 1-bits, 14 2-bits, etc. 4 bits are for selectors.
\ Elias-gamma-code: (BIT-LEVEL ENCODING) Assumes unbounded natural number and small numbers are more common than large numbers. \
Encoding procedure;
+ Let $N = floor(log_2 x)$
+ Write $N 0$'s
+ Write $x$ as an $N+1$-bit number

Decoding procedure:
+ Read 0s until a 1, call this $N$
+ Interpret next $N$+1 bits as a binary number, including $1$

TF-DF distribution demonstrates term frequency and doc frequency, and follows a Poisson distribution. Essentially follows power law.

\ Golomb Code: Similar bit-level encoding of positive integers $x$. Requires parameter $M$ representing data distribution. Golomb is optimal if it follows a geometric distribution. Given an understanding of number of docs containing term, and num docs total we can estimate good values for $M$ for TF-DF

As a result, this requires an understanding of how many docs contain a term before we can identify this, we can follow an emission of term with special character "\*" to calculate num docs before we do anythign else. Like ((term, "\*"), 1) for each doc. Then reduce these to get total num docs with this val.

Generally VInt, Gamma, Golomb all have goldlilocks zones. Gamma is more amenable to within-doc-term frequency because it doesn't handle large numbers as well, and Golomb for docID gap encoding. 

Sample Posting List:
#image("/assets/text-posting-list.png")

== Retrieval
Indexing is perfect for MapReduce because it can handle large datasets in a distributed manner, retrieval needs to reduce latency, which this is not good for.

=== Boolean Retrieval
+ Build query syntax tree (blue AND fish) OR ham
+ For each clause, look up postings
+ Traverse postings and apply boolean operator

\ Term-at-a-time: For each term, generate sets of documents. This can have early termination, but requires moving everything in memory, which can be bad if not careful.

\ Doc-at-a-time: For each doc, see if it passes the query. Since docs are in sorted order, modified merge operation will work. Everything fits in memory but no early termination.

=== Ranked Retrieval
Requires relevance function $R(q, d)$ where $q$ is query, $d$ is document. For now, just make it a list of terms "AND"-ing each other (not strictly)

The reason we don't do boolean retrieval first is that for a query "x y z w" a result for "x y z" could be the best. 

\ TF-IDF: Term-Frequency and Inverse-Doc_Frequency. $w_(i j) = t f_(i j) log N/(d f_i)$ where 
- $w_(i j)$ is weight of term $i$ in doc $j$
- $t f_(i j)$ is num occurrences of term $i$ in doc $j$
- $d f_i$ is num docs containing term $i$
- $N$ total num docs.

This means weights are proportional to frequency in a doc, and inversely proportional to frequency across multiple docs. This highlights rare words and downgrades uncommon words. 

$R(q,d) = sum_(t in q) W_(t, d)$

For doc-at-a-time score each query term, add them up, and accumulate best $k$ hits via min-heap, removing min relevant hit to reduce word. Time is $O(n log k)$ and mem is $O(k)$, but it can't terminate early but it's easily distributed.

For term-at-a-time, collect hits and ranking for rarest term into accumulator. For each other term in query, if doc doesn't have that term, remove from accumulator. Otherwise add next term's ranking to overall ranking. The pro is early termination heuristics exist, since you go from rarest to most common, which means sorted docs won't change much. But this uses a lot of memory.

Usually you partition docs by quality, so partition 0 is best, partition 1 is less good, etc. Then you do doc-at-a-time on best partition, and if good enough, stop.