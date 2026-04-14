= Graphs

Types of representations:
- Adjacency Matrix (Binary square matrix for edges between nodes). Mostly sparse, and hard to find neighbourhood, but matrices are nice
- Adjacency List (Linked list of outgroup for each node). Smaller than matrix, and easy to find out-neighbours.
- Edge List (Simple, but dumb)

== Single-Source Shortest Path
Dijkstra's algorithm is optimal runtime but requires global state of minimum node, which isn't parallelizable. 

Paralell-Breadth-First-Search:
Mapper:
+ Given current node $n$ with dist $d$, for node $m$ in adjacency list, emit (m: d + 1)
+ Also emit (n, d) (done to keep adj_list data across iterations)
Reducer:
+ Update distance to node $n$ based on $(m: "dist")$ messages from mapper

Each iteration spreads like a wave, usually only need 6 iterations to complete BFS.
You can modify this to find the path.

You can modify this for weighted edges, by adding the weight of the id instead of $1$, and everything else stays the same, but must be wary because termination could be much longer. Stopping condition can be when there are no changes. 

#image("/assets/graph-pbfs-outline.png")

== PageRank

Think of outlinks as votes of importance. If page $j$ has importance $r_j$ with $n$ out links, each link gets $r_j/n$ votes. Page $j$'s importance is sum of votes on in-links.

$r_j = sum_(i arrow j) r_i / d_i$
for all nodes $j$. We then add another constraint to force uniqueness, $sum_(i) r_i = 1$

We can represent this as a stochastic adjacency matrix $M$, a square matrix indexed by nodes of the graph, where each cell represents the percent contribution of a node's importance to its outgroup.

*Power Iteration*:
+ Set $r_j = 1 / N$
+ Step 1: $r'_j = sum_(i arrow j) r_i / d_i$
+ Step 2: $r = r'$
+ Go to step 1

#table(columns: 4,
[], [x], [y], [z],
[x], [1/2], [1/2], [0],
[y], [1/2], [0], [1],
[z], [0], [1/2], [0])

Random walker interpretation: Imagine random web surfer on page $i$ at time $t$, at time $t + 1$ they randomly select outlink from $i$, so the $r$ column is probability of being on any page. When this probability stabilizes, this is a stationary distribution. 

Stationary Distribution: Unique and eventually reached value in a random walk in a Markvo process no matter what initial probability distribution is if it's ergodic (non bi-partite and connected)

Spider-Traps: All out-links are within same group causing it to absorb all importance. Not-connected => Not ergodic. Not a mathematical problem, but a correctness one—they're useless.
- Solution: Random teleports with probability $beta$ so it never gets stuck on a spider trap. This is the "damping factor"
Dead-Ends: No out-links, cause importance to "leak out" Not connected => Not ergodic. These are not column stochastic, so initial Markov assumptions aren't met.
- Solution: Always teleport if at a dead-end to any random page.

Final Google solution:
$r_j = sum_(i arrow j) beta r_i d_i + (1 - beta) 1 /N$
We must preprocess dead-ends to have equal teleportation to all random pages.

=== MapReduce Implementations
!Without considering Deadends!
Mapper:
- Emit (id, node) to keep node data
- page rank p = (n.rank / len(n.adj))
- for m in n.adj: emit(m, p) 

Reducer:
- n = None
- sum = 0
- if message gives node, n = o; if message gives pagerank, add to sum
- n.rank = $s times beta + (1 - beta) / n$
- emit(id, n)

Solution:
- Version 1: Sum all ranks, 1 - R is missing mass, and add (1 - R) / N. Looks like: Map(send mass) -> reduce(compute new mass) -> Map(add missing mass), but combined is Map(add miss mass then send mass) -> Reduce(compute new mass) with a final add miss mass step after all iterations.
- Version 2: In the mapper, dead-ends send their entire rank to an "everyone" special key and the reducer adds $1/N times$ everyone rank to each sum. This requires the everyone node to be send to each reducer, but with an IMC, the mapper only sends 1 extra message per reducer.

Log Masses: Easy way to add up small numbers and avoid precision issues.

=== Spam Farming/Trustworthiness

To avoid search spam, trust what others say about you in link text. To avoid comment spam (commenting links on trusted pages) make forums tag comment links as not endorsements via link tags.

Spider-trap-farming: Page you want to promote has millions of hidden links to farm pages, they all accumulate random-jump weight, which all link back to page you want to promote. They send their rank back to page being boosted. 

- Solution: Instead of random jumps, start from sample of "trustworthy" pages as a sample. Use "good" pages, and after iterations, all pages have trust factor between 0 and 1, and pick a threshold to mark pages below as spam. 
- Assume trustworthy pages link to other trustworhty pages. By only *teleporting* to trustworthy sites, only "good" partitions accumulate trust.

Spam Mass: $r_p$ PageRank of page $p$, $r_p^+$ PageRank of Page p, but random jumps to trusted pages. $r_p^-$ is contribution of low-trust pages to $p$'s rank. $S_p = r_p^- / r_p$ as spam mass, higher spam mass, more closely you are spam.